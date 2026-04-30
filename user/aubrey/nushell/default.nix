{
  pkgs,
  lib,
  ...
}:
{
  programs = {
    nushell = {
      enable = true;
      package = pkgs.nushell;
      configFile.source = lib.mkAfter ./config.nu;
      extraConfig = ''
         def "nu-complete zoxide path" [context: string] {
         let parts = $context | split row " " | skip 1
             {
               options: {
                 sort: false,
                 completion_algorithm: substring,
                 case_sensitive: false,
               },
               completions: (^zoxide query --list --exclude $env.PWD -- ...$parts | lines),
             }
           }
        def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
          __zoxide_z ...$rest
        }

        ${builtins.readFile ./commands.nu}
      '';
      shellAliases = {
        ghidra = "_JAVA_AWT_WM_NONREPARENTING=1 ${pkgs.stable-pkgs.ghidra}/lib/ghidra/ghidraRun";
      };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      presets = [
        "plain-text-symbols"
      ];
    };
  };
}
