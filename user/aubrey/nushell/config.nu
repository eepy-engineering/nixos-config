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
alias nsc = nix-shell 
alias fg = job unfreeze
alias de = direnv exec . nu

$env.OP_PLUGIN_ALIASES_SOURCED = 1
alias gh = op plugin run -- gh
$env.EDITOR = "nvim"

use std "path add"
$env.PATH = ($env.PATH | split row (char esep));
path add ($env.HOME | path join ".local" "bin");
path add ($env.HOME | path join tools bin)
path add ($env.HOME | path join .cargo bin)
$env.PATH = ($env.PATH | uniq);

export def "toolkit setup" [
  --name: string = "toolkit", # the name of the overlay, i.e. the command that will be usable
  --color: string = "yellow_bold", # the color of the "hook" indicator
]: [ nothing -> record<condition: closure, code: string> ] {
  {
    condition: {|_, after| $after | path join 'toolkit.nu' | path exists }
    code: $"
      print $'[\(ansi ($color)\)nu-hooks toolkit\(ansi reset\)] loading \(ansi purple\)toolkit.nu\(ansi reset\) as an overlay'
      overlay use --prefix toolkit.nu as ($name)
    "
  }
}
$env.config.hooks.env_change.PWD = [];
$env.config.hooks.env_change.PWD = (
  $env.config.hooks.env_change.PWD | append (
    toolkit setup --name "tk" --color "yellow_bold"
  )
)
