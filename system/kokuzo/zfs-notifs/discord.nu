
if ($env.ZEVENT_SUBCLASS == "history_event") {
  exit 0
}

try {
  let webhook = open -r /var/lib/opnix/secrets/zfs/discord_webhook | str trim
  
  http post $webhook --content-type "multipart/form-data" {
    content: $"Event: ($env.ZEVENT_SUBCLASS)\nPool: ($env.ZEVENT_POOL)\nSeverity: ($env.ZEVENT_CLASS)\nTime: <t:($env.ZEVENT_TIME_SECS)>",
    "env.txt": ($env | reject ...($env | columns | where {not ($in | str starts-with ZEVENT_)}) | table -t light | into binary)
  }
} catch {|e|
  $e | save -f /tmp/webhook.json
}