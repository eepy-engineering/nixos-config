$env.config.show_banner = false
$env.config.history = {
    max_size: 100_000
    sync_on_enter: true
    file_format: "sqlite"
    isolation: true
};

$env.config.edit_mode = "vi";

$env.config.use_kitty_protocol = true
$env.config.highlight_resolved_externals = true

alias nsu = nix-shell --command nu

$env.OP_PLUGIN_ALIASES_SOURCED = 1
alias gh = op plugin run -- gh
$env.EDITOR = "nvim"

use std "path add"
$env.PATH = ($env.PATH | split row (char esep));
path add ($env.HOME | path join ".local" "bin");
path add ($env.HOME | path join tools bin)
path add ($env.HOME | path join .cargo bin)
$env.PATH = ($env.PATH | uniq);
