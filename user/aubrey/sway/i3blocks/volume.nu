let volume = (wpctl get-volume @DEFAULT_SINK@ | parse -r "Volume: (?<volume>\\d.\\d+)" | get volume.0 | into float) * 100;

{
  full_text: $"󰝟 ($volume | format number | get display)%",
} | to json | print
