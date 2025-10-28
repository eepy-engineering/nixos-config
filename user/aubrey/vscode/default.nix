{
  pkgs,
  isDesktop,
  ...
}:
{
  programs.vscode = {
    enable = isDesktop;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;

    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./vscode_settings.json);
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;

      extensions = with pkgs.vscode-marketplace; [
        # theming
        trag1c.gleam-theme
        vscode-icons-team.vscode-icons

        # nix
        mkhl.direnv
        jnoortheen.nix-ide

        # dx
        vscodevim.vim
        tauri-apps.tauri-vscode
        jjk.jjk
        bradlc.vscode-tailwindcss

        # languages
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        mkornelsen.vscode-arm64
        ms-vscode.cpptools-extension-pack
        llvm-vs-code-extensions.vscode-clangd
        svelte.svelte-vscode
        ms-vscode.cmake-tools
        surendrajat.apklab
        loyieking.smalise
        denoland.vscode-deno
        pbkit.vscode-pbkit
        ms-python.python
        haskell.haskell
        justusadam.language-haskell
        ocamllabs.ocaml-platform
        mshr-h.veriloghdl
        dalance.vscode-veryl
      ];
    };
  };
}
