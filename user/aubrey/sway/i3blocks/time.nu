use utils.nu *

let current_tz = env int current_tz 0;
mut btn = env int button -1;
let offset = match $btn {
  4 => 1,
  5 => -1,
  _ => 0,
};

const timezones = [
  ["PT", "America/Los_Angeles"],
  ["CST", "Canada/Saskatchewan"],
  ["ET", "Canada/Eastern"],
  ["Éire", "Europe/Dublin"],
  ["CET", "Europe/Berlin"],
];

let current_tz = if $btn == 1 { 1 } else { ($current_tz + $offset) mod ($timezones | length) };
let tz = $timezones | get $current_tz;
let date = date now | date to-timezone $tz.1;
let current_time = $date | format date "%a %B %d %G %T";

{
  full_text: $"($current_time) ($tz.0) ($date | format date "UTC%:::z")",
  current_tz: $current_tz
} | to json | print
