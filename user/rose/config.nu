# Demo

$env.config.show_banner = false;

def nix-with [...rest] {
  if $rest == ["local"] {
    $env.__NIX_SHELL_CONTENTS = "@with local "
    nix-shell --command nu
  } else {
    $env.__NIX_SHELL_CONTENTS = $"@with ($rest | str join ' ') "
    nix-shell --command nu ...($rest | each { |x| ['-p', $x] } | flatten)
  }
}

def exit-with [] {
  $env.__NIX_SHELL_CONTENTS = ""
  exit
}