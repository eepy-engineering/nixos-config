let a = acpi -b;
let battery_level = $a | parse -r '(\d{1,3})%' | get 0.capture0 | into int;
let charging = $a | str contains "Charging";
let not_charging = $a | str contains "Not charging";
let icon = if $charging { "󱥵󱤖" } else if $not_charging { "󱥵󱤈" } else if $battery_level < 20 { "󱥵󱤨" } else { "󱥵󱥣" }

if not $charging and $battery_level < 20 {
  $'<span color="#FF4444">($icon)($battery_level)%</span>'
} else {
  $"($icon)($battery_level)%"
}