#!/usr/bin/env nu
def "get hostname" [hostname?: string] { $hostname | default (hostname) };
def prebuild [] {
  if (".git" | path exists) {
    # make sure the goddamn files are added because nix flakes won't include files untracked files
    git add -A
  }
  nix fmt .
}
def "get flake uri" [] { $"($env.CURRENT_FILE)/.." | path expand }

def --wrapped rebuild [subcmd: string, hostname: string, ...rest] {
  prebuild

  let hn = hostname;
  if $hostname == $hn {
    rm -rf ~/.config/gtk-3.0/settings.ini;
    rm -rf ~/.config/gtk-4.0/settings.ini;
    rm -rf ~/.config/gtk-4.0/gtk.css;  
    sudo nixos-rebuild --flake $"(get flake uri)#(hostname)" --impure $subcmd ...$rest
  } else {
    print "Remote...";
    nixos-rebuild --flake $"(get flake uri)#($hostname)" --target-host $"($hostname).tailc38f.ts.net" --use-remote-sudo $subcmd ...$rest;
  }
};

def --wrapped "main switch" [
  --hostname (-h): string, # the hostname of the machine to push to
  ...rest
] {
  let hostname = (get hostname $hostname);
  rebuild switch $hostname ...$rest
}

def --wrapped "main boot" [
  --restart (-r) # restart after building
  --hostname (-h): string, # the hostname of the machine to push to
  ...rest
] {
  let hostname = (get hostname $hostname);
  rebuild boot $hostname ...$rest
  if $restart {
    ssh $hostname -t "sudo reboot now"
  }
}

def --wrapped "main run" [
  --hostname (-h): string, # the hostname of the machine to push to
  ...rest
] {
  prebuild

  let hostname = (get hostname $hostname);
  let r = echo ...$rest | into string;
  nix-shell -p nixos-rebuild --command $"nixos-rebuild --flake .#($hostname) build-vm"
  bash $"./result/bin/run-($hostname)-testing-vm"
}

def --wrapped main [--hostname (-h): string, ...rest] {
  let hostname = (get hostname $hostname);
  main switch --hostname $hostname ...$rest
}

def --wrapped "main home" [...args] {
  prebuild

  rm -rf ~/.config/gtk-3.0/settings.ini;
  rm -rf ~/.config/gtk-4.0/settings.ini;
  rm -rf ~/.config/gtk-4.0/gtk.css;
  home-manager switch --flake (get flake uri) ...$args
}
