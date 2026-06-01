use utils.nu *

mut btn = env int button -1;

def brightness_percent []: nothing -> int {
  let max_brightness = ^brightnessctl m | into int;
  let brightness = ^brightnessctl g | into int;
  (($brightness / $max_brightness) * 100) | into int;
}

mut brightness = brightness_percent;
let offset = match $btn {
  4 => "5%+",
  5 => "5%-",
  _ => null,
};
if $btn == 1 {
  if $brightness < 50 {
    ^brightnessctl s 100% | null
  } else {
    ^brightnessctl s 0% | null
  }
  sleep 100ms
} else if $offset != null {
  ^brightnessctl s $offset | null
}
$brightness = brightness_percent

$"󱥤($brightness)%"