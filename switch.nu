#!/usr/bin/env nu
def --wrapped rebuild [subcmd: string, ...rest] {
  nix fmt
  git add -A # make sure the goddamn files are added because nix won't include unchecked files
  let r = echo ...$rest | into string;
  nix-shell -p nixos-rebuild --command $"sudo nixos-rebuild --flake .#(hostname) ($subcmd) ($r)";
};

def --wrapped "main switch" [
  ...rest
] {
  rebuild switch ...$rest
}

def --wrapped "main boot" [
  --restart (-r) # restart after building
  ...rest
] {
  rebuild boot ...$rest
  if $restart {
    sudo reboot now
  }
}

def main [] {
  main switch
}
