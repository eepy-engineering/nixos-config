use utils.nu *

let networks = nmcli -f IN-USE,SSID,BARS,SECURITY -t -c yes d w l
  | lines
  | ansi strip
  | each {str trim | parse -r '(?<active>[^:]*):(?<ssid>(?:\\:|[^:])*):(?<bars>[^:]*):(?<security>[^:]*)$'}
  | flatten
  | update ssid {str replace -a '\' ""}
  | where {$in.ssid != ""}
  | each {$in | merge {
    active: ("*" in $in.active),
    strength: ($in.bars | parse -r '_' | length)
  }}

let active = if ($networks | any {$in.active}) {
  $"󰖩 ($networks | where {$in.active} | first | get ssid)"
} else { "󰖪 " }

{
  full_text: $active,
} | to json | print

let button = env int button -1;
if ($button != 1) { exit 0 }

const colors = [
  "lime"
  "lime"
  "orange"
  "lightred"
];

let result = $networks
  | each {|n|$'<span color="($colors | get ($n.strength))"><tt>($n.bars) </tt>($n.ssid)</span>'}
  | str join "\n"
  | wofi -Gdjl bottom_right -D dmenu-print_line_num=true
  | complete

if ($result.exit_code != 0) { exit 0 }
let index = $result.stdout | into int
let network = $networks | get $index
if ($network.security =~ 'WPA|WEP') {
  let op_list = op item list --vault Private --tags Wifi --format json | from json;
  let op_item = $op_list | where {$in.title == $network.ssid} | get -o 0;
  let password = if $op_item != null {
    op read $"op://Private/($op_item.id)/password"
  } else {
    "" | wofi -GdP
  };
  nmcli d w c $network.ssid password ($password)
  if $op_item == null {
    op item create --category Password --tags Wifi --title $network.ssid - $"password[password]=($password)"
  }
} | {
  nmcli d w c $network.ssid
}

pkill -SIGRTMIN+1 i3blocks
