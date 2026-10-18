# Kata Containers: a pod whose RuntimeClass is "kata" runs inside its own
# lightweight VM (QEMU on KVM, with its own kernel) instead of on the host's.
# vibes runs untrusted sketch builds this way.
{ pkgs, ... }:
let
  # nixpkgs' QEMU config points virtio_fs_daemon at the virtiofsd package, but
  # only allows QEMU's bundled one (which QEMU no longer ships), so every pod
  # would be refused. Allow the one it actually uses.
  kataConfig = pkgs.runCommand "kata-configuration-qemu.toml" { } ''
    sed \
      -e 's!^virtio_fs_daemon *=.*!virtio_fs_daemon="${pkgs.virtiofsd}/bin/virtiofsd"!' \
      -e 's!^valid_virtio_fs_daemon_paths *=.*!valid_virtio_fs_daemon_paths=["${pkgs.virtiofsd}/bin/virtiofsd"]!' \
      ${pkgs.kata-runtime}/share/defaults/kata-containers/configuration-qemu.toml > $out
  '';

  # What k3s generates for containerd 2 (config version 3), plus Kata. It has
  # to be config-v3.toml.tmpl: services.k3s.containerdConfigTemplate writes
  # config.toml.tmpl, which k3s takes as a version 2 template and so swaps the
  # base config for every other pod too.
  containerdTemplate = pkgs.writeText "config-v3.toml.tmpl" ''
    {{ template "base" . }}

    [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.kata]
      runtime_type = "io.containerd.kata.v2"
      runtime_path = "${pkgs.kata-runtime}/bin/containerd-shim-kata-v2"
      privileged_without_host_devices = true

    [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.kata.options]
      ConfigPath = "${kataConfig}"
  '';
in
{
  environment.systemPackages = [ pkgs.kata-runtime ];

  systemd.tmpfiles.settings."10-k3s-kata"."/var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.tmpl" =
    {
      "L+".argument = "${containerdTemplate}";
    };
  # k3s only reads the template as it starts. Its containers outlive the
  # restart (KillMode=process).
  systemd.services.k3s.restartTriggers = [ containerdTemplate ];

  services.k3s.manifests.kata-runtimeclass.content = {
    apiVersion = "node.k8s.io/v1";
    kind = "RuntimeClass";
    metadata.name = "kata";
    handler = "kata";
    # What each pod's VM costs beyond its containers, so the scheduler counts it.
    overhead.podFixed = {
      cpu = "250m";
      memory = "160Mi";
    };
  };
}
