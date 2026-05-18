#!/usr/bin/env nu
def "fetch hostname" [hostname?: string] { $hostname | default (sys host | get hostname) };
def prebuild [] {
  if (".git" | path exists) {
    # make sure the goddamn files are added because nix flakes won't include files untracked files
    git add -A
  }
  nix fmt .
}
def "get flake uri" [] { $"($env.CURRENT_FILE)/.." | path expand }

def --wrapped rebuild [subcmd: string, hostname: string, --user (-u): string, ...rest] {
  prebuild

  let hn = hostname;
  if $hostname == $hn {
    rm -rf ~/.config/gtk-3.0/settings.ini;
    rm -rf ~/.config/gtk-4.0/settings.ini;
    rm -rf ~/.config/gtk-4.0/gtk.css;
    sudo nixos-rebuild --flake $"(get flake uri)#($hostname)" $subcmd ...$rest
  } else {
    let remote_user = ($user | default $env.USER);
    print "Remote...";
    nixos-rebuild --flake $"(get flake uri)#($hostname)" --target-host $"($remote_user)@($hostname).tailc38f.ts.net" --sudo $subcmd ...$rest;
  }
};

def --wrapped "main switch" [
  --hostname (-h): string, # the hostname of the machine to push to
  --user (-u): string, # the username to SSH as for remote builds
  ...rest
] {
  let hostname = (fetch hostname $hostname);
  rebuild switch $hostname --user $user ...$rest
}

def --wrapped "main boot" [
  --restart (-r) # restart after building
  --hostname (-h): string, # the hostname of the machine to push to
  --user (-u): string, # the username to SSH as for remote builds
  ...rest
] {
  let hostname = (fetch hostname $hostname);
  rebuild boot $hostname --user $user ...$rest
  if $restart {
    ssh $hostname -t "sudo reboot now"
  }
}

def --wrapped "main run" [
  --hostname (-h): string, # the hostname of the machine to push to
  ...rest
] {
  prebuild

  let hostname = (fetch hostname $hostname);
  let r = echo ...$rest | into string;
  nix-shell -p nixos-rebuild --command $"nixos-rebuild --flake .#($hostname) build-vm"
  bash $"./result/bin/run-($hostname)-testing-vm"
}

def --wrapped main [--hostname (-h): string, --user (-u): string, ...rest] {
  let hostname = (fetch hostname $hostname);
  main switch --hostname $hostname --user $user ...$rest
}

def --wrapped "main home" [...args] {
  prebuild

  rm -rf ~/.config/gtk-3.0/settings.ini;
  rm -rf ~/.config/gtk-4.0/settings.ini;
  rm -rf ~/.config/gtk-4.0/gtk.css;
  home-manager switch --flake (get flake uri) ...$args
}
