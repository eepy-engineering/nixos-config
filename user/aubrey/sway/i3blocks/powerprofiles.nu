use utils.nu *

mut btn = env int button -1;

let profiles = {
  "performance": "󱤿󱥵󱥉",
  "balanced": "󱤿󱥵󱤍",
  "power-saver": "󱤿󱥵󱤢",
};

mut profile = ^powerprofilesctl get;

if $btn == 1 {
  powerprofilesctl set (match $profile {
    "performance" | "balanced" => "power-saver",
    "power-saver" => "performance",
  })
  $profile = ^powerprofilesctl get;
}

$profiles | get $profile