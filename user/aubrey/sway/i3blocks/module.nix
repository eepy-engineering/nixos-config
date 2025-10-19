{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.types;
{
  options.i3blocks =
    let
      keys =
        isGlobal:
        submodule {
          options =
            let
              mkOptionNullable =
                t:
                mkOption {
                  type = nullOr t;
                  default = null;
                };
            in
            (if isGlobal then { } else { name = mkOption { type = str; }; })
            // {
              full_text = mkOptionNullable str;
              short_text = mkOptionNullable str;
              color = mkOptionNullable str;
              background = mkOptionNullable str;
              border = mkOptionNullable str;
              min_width = mkOptionNullable int;
              align = mkOptionNullable str;
              urgent = mkOptionNullable bool;
              markup = mkOptionNullable str;
              separator = mkOptionNullable bool;
              separator_block_width = mkOptionNullable int;

              # i3-gaps specific
              border_top = mkOptionNullable int;
              border_bottom = mkOptionNullable int;
              border_left = mkOptionNullable int;
              border_right = mkOptionNullable int;

              interval = mkOption {
                type = nullOr (oneOf [
                  int
                  (strMatching "^once$")
                  (strMatching "^persist$")
                  (strMatching "^repeat$")
                ]);
                default = 0;
              };
              signal = mkOptionNullable int;
              command = mkOptionNullable str;
              json = mkOption {
                type = bool;
                default = false;
              };

              # user-defined options
              vars = mkOption {
                type = attrsOf str;
                default = { };
              };
            };
        };
      assembleBlock =
        keys:
        filterAttrs (n: v: !(isNull v)) (
          builtins.removeAttrs keys [
            "vars"
            "json"
          ]
        )
        // keys.vars
        // {
          format = if keys.json then "json" else "raw";
        };
    in
    {
      global = mkOption {
        type = keys true;
        apply = assembleBlock;
      };
      blocks = mkOption {
        type = listOf (keys false);
        apply = builtins.map assembleBlock;
      };
    };

  config =
    let
      cfg = config.i3blocks;
      globalText = generators.toKeyValue { } cfg.global;
      blocksTexts = builtins.map (block: generators.toINI { } { "${block.name}" = block; }) cfg.blocks;
      configPath = pkgs.writeText "config" "${globalText}\n${concatLines blocksTexts}";
    in
    {
      xdg.configFile."i3blocks/config" = {
        source = configPath;
      };
    };
}
