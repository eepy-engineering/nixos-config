use utils.nu *

let current_tz = env int current_tz 0;
mut btn = env int button -1;
let offset = match $btn {
  4 => 1,
  5 => -1,
  _ => 0,
};

const timezones = [
#  ["PT", "America/Los_Angeles"],
  ["CST", "Canada/Saskatchewan"],
#  ["ET", "Canada/Eastern"],
  ["Éire", "Europe/Dublin"],
  ["CET", "Europe/Berlin"],
];

let current_tz = if $btn == 1 { 0 } else { ($current_tz + $offset) mod ($timezones | length) };
let tz = $timezones | get $current_tz;
let date = date now | date to-timezone $tz.1;

mut shortened = env bool shortened true;
if $btn == 3 {
    $shortened = not $shortened
}

let full_text = if $shortened {
    $"($date | format date "%T") ($tz.0)"
} else { 
    let current_time = $date | format date "%a %B %d %G %T";
    
    $"($current_time) ($tz.0) ($date | format date "UTC%:::z")"
}

{
    full_text: $full_text,
    current_tz: $current_tz,
    shortened: $shortened,
} | to json | print