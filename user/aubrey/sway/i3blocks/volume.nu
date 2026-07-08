let output = wpctl get-volume @DEFAULT_AUDIO_SINK@;
let parsed = $output | parse --regex '(Volume:\s+)(?P<vol>[0-9.]+)(?P<muted>.+)?' | first;
let volume = $parsed | get vol | into float | $in * 100 | into int;
let is_muted = $parsed | get muted | ($in != null);

mut icon = "";
if $is_muted or $volume == 0 {
  $icon = "󱤕󱤂";
} else {
  $icon = "󱤕";
}

{
  full_text: $"<span size=\"large\">($icon)</span> ($volume)%",
} | to json | print