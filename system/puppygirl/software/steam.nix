{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.udev = {
    packages = [
      # <3 https://github.com/benley/dotfiles/blob/master/pkgs/steamcontroller-udev-rules/default.nix
      (pkgs.writeTextFile {
        name = "steamcontroller-udev-rules";
        text = builtins.readFile ./controllers.rules;
        destination = "/etc/udev/rules.d/70-steamcontroller.rules";
      })

    ];
  };
}
