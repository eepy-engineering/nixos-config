if [ ! -d /root/nixos-config ]; then
  git clone https://github.com/eepy-engineering/nixos-config /root/nixos-config
fi
cd /root/nixos-config
git pull
if [ -d /mnt ]; then 
  umount /mnt/boot
  umount /mnt/nix
  umount /mnt/persist
  umount /mnt/swap
  umount /mnt/
fi
mkdir /mnt
mount -t tmpfs tmpfs /mnt
chmod 755 /mnt
mkdir /mnt/{boot,nix,persist,swap}
mount /dev/sda1 /mnt/boot
mount -o compress=zstd,subvol=persist /dev/sda2 /mnt/persist
mount -o compress=zstd,noatime,subvol=nix /dev/sda2 /mnt/nix
mount -o subvol=swap /dev/sda2 /mnt/swap
nixos-install --flake /root/nixos-config#kerguelen --no-root-password --option store /mnt/nix/store --root /mnt