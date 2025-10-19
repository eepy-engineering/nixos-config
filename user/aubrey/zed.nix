{ isDesktop, ... }:
{
  programs.zed-editor = {
    enable = isDesktop;
    # enable = false;
    #    extensions = [
    #      "lua"
    #      "nix"
    #      "nushell"
    #      "vscode-dark-plus"
    #      "wgsl"
    #    ];
    #    userSettings = {
    #      features = {
    #        copilot = false;
    #      };
    #      telemetry.metrics = false;
    #      vim_mode = true;
    #      load_direnv = "shell_hook";
    #      buffer_font_family = "Comic Mono";
    #      buffer_font_fallbacks = [ "Zed Plus Mono" ];
    #      autosave.after_delay.milliseconds = 300;
    #      relative_line_numbers = true;
    #    };
  };
}
