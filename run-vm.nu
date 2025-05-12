#!/usr/bin/env nu
def --wrapped main [hostname: string, ...args: string] {
  let img = $"($hostname).qcow2";
  rm -f $img
  let tmpimg = mktemp -t;
  qemu-img create -f raw $tmpimg 1024M
  mkfs.ext4 -L nixos $tmpimg
  let tmpfld = mktemp -td;
  sudo mount -o loop $tmpimg $tmpfld
  sudo mkdir $"($tmpfld)/var"
  sudo cp /etc/opnix-token $"($tmpfld)/var/opnix-token"
  sudo umount $tmpfld
  qemu-img convert -f raw -O qcow2 $tmpimg $img
  rm -r $tmpimg $tmpfld
  nixos-rebuild --flake $".#($hostname)" build-vm ...$args
  QEMU_KERNEL_PARAMS=console=ttyS0 result/bin/run-($hostname)-vm -nographic
}
