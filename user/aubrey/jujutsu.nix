{ config, pkgs, ... }:
{
  programs.jujutsu =
    let
      git = config.programs.git;
      gitCfg = git.settings;
    in
    {
      enable = true;
      package = pkgs.callPackage (
        {
          lib,
          stdenv,
          rustPlatform,
          fetchFromGitHub,
          installShellFiles,
          gitMinimal,
          gnupg,
          openssh,
          buildPackages,
          nix-update-script,
          versionCheckHook,
        }:

        rustPlatform.buildRustPackage (finalAttrs: {
          pname = "jujutsu";
          version = "0.40.0";

          src = fetchFromGitHub {
            owner = "jj-vcs";
            repo = "jj";
            rev = "533a0c12653df27fa8f77e94d45fd6aa58e88a6d";
            hash = "sha256-A4qFx+KAvvyAsVg8ufRv2TIXSon5ZifXkPHbMFg9A1g=";
          };

          cargoHash = "sha256-fCSMdLl1UHPhp42lvFVUrUTHy5vBTsoCa+FmomBwQFE=";

          nativeBuildInputs = [
            installShellFiles
          ];

          nativeCheckInputs = [
            gitMinimal
            gnupg
            openssh
          ];

          cargoBuildFlags = [
            # Don’t install the `gen-protos` build tool.
            "--bin"
            "jj"
          ];

          useNextest = true;

          cargoTestFlags = [
            # Don’t build the `gen-protos` build tool when running tests.
            "-p"
            "jj-lib"
            "-p"
            "jj-cli"
          ];

          env = {
            # Disable vendored libraries.
            ZSTD_SYS_USE_PKG_CONFIG = "1";
            LIBGIT2_NO_VENDOR = "1";
            LIBSSH2_SYS_USE_PKG_CONFIG = "1";
          };

          postInstall =
            let
              jj = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/jj";
            in
            lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
              mkdir -p $out/share/man
              ${jj} util install-man-pages $out/share/man/

              installShellCompletion --cmd jj \
                --bash <(COMPLETE=bash ${jj}) \
                --fish <(COMPLETE=fish ${jj}) \
                --zsh <(COMPLETE=zsh ${jj})
            '';

          doInstallCheck = true;
          nativeInstallCheckInputs = [ versionCheckHook ];
          versionCheckProgram = "${placeholder "out"}/bin/jj";

          passthru = {
            updateScript = nix-update-script { };
          };

          meta = {
            description = "Git-compatible DVCS that is both simple and powerful";
            homepage = "https://jj-vcs.dev/";
            changelog = "https://github.com/jj-vcs/jj/blob/v${finalAttrs.version}/CHANGELOG.md";
            license = lib.licenses.asl20;
            maintainers = with lib.maintainers; [
              _0x4A6F
              thoughtpolice
              emily
              bbigras
            ];
            mainProgram = "jj";
          };
        })
      ) { };
      settings = {
        user = {
          name = gitCfg.user.name;
          email = gitCfg.user.email;
        };
        signing = {
          backend = "ssh";
          behavior = "own";
          key = gitCfg.user.signingKey;
          backends.ssh.program = gitCfg."gpg \"ssh\"".program;
        };
        ui = {
          default-command = "log";
          movement.edit = true;
        };
        aliases = {
          a = [ "abandon" ];
          n = [ "next" ];
          p = [ "prev" ];
        };
        git = {
          sign-on-push = true;
        };
      };
    };

  programs.nushell = {
    extraConfig = ''
      alias jjgf = jj git fetch
      alias jjgp = jj git push
      def --wrapped jjbm [...args] {
        jj b m -t 'heads(::@ ~ empty())' ...$args
      }
    '';
  };
}
