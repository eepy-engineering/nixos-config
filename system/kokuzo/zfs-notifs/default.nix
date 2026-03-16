{
  lib,
  pkgs,
  config,
  ...
}:
{
  environment.etc = {
    "zfs/zed.d/all-discord.nu" = {
      source = pkgs.writeNushellScript "discord.nu" (builtins.readFile ./discord.nu);
    };
  };

  opnix.secrets = [
    {
      path = "zfs/discord_webhook";
      reference = "op://Services/ZFS Notifications/notesPlain";
    }
  ];
}
