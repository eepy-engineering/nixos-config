def main [
  username: string,
  password: string,
  region: string,
  ca_cert: string,
  route_exit_node_traffic: bool
] {
  if (sys net | any {|r| $r.name == "pia"}) {
    print "pia link has already been created, nothing to do"
    exit
  }
  let servers = http get https://serverlist.piaservers.net/vpninfo/servers/v6 | lines | get 0 | from json;
  let wg_port = $servers.groups.wg.ports.0.0
  let user_token = http post https://www.privateinternetaccess.com/api/client/v2/token --content-type "multipart/form-data" { username: (open $username -r), password: (open $password -r) } | get token

  let region = $servers.regions | where id == $region | get 0;

  let wg_info = $region.servers.wg.0;
  let wg_info = { hostname: $wg_info.cn, server_ip: $wg_info.ip };

  let keyfile = "/private/wireguard_key";
  let privkey = if ($keyfile | path exists) {
    open $keyfile
  } else {
    mkdir /private
    let key = (wg genkey);
    $key | save /private/wireguard_key;
    $key
  };
  let pubkey = $privkey | wg pubkey;
  print curl "-G" "--connect-to" $"($wg_info.hostname)::($wg_info.server_ip):" "--cacert" $ca_cert "--data-urlencode" $"pt=($user_token)" "--data-urlencode" $"pubkey=($pubkey)"  $"https://($wg_info.hostname):($wg_port)/addKey"
  let json = curl -G --connect-to $"($wg_info.hostname)::($wg_info.server_ip):" --cacert $ca_cert --data-urlencode $"pt=($user_token)" --data-urlencode $"pubkey=($pubkey)"  $"https://($wg_info.hostname):($wg_port)/addKey" | from json

  print $json

  let fwmark = 51820;
  let fwmark_hex = $fwmark | into binary | bytes reverse | bytes at 4..8 | encode hex;
  let config = $"
    [Interface]
    PrivateKey = ($privkey)
    # FwMark = ($fwmark)
    #Address = ($json.peer_ip)
    #DNS = ($json.dns_servers.0)

    [Peer]
    PersistentKeepalive = 25
    PublicKey = ($json.server_key)
    AllowedIPs = 0.0.0.0/0
    Endpoint = ($wg_info.server_ip):($json.server_port)
  ";
  print $config
  $config | save -f /private/pia.wg.conf
  $json.peer_ip | save -f /tmp/pia.ip
  $wg_info | merge { token: $user_token } | to json | save -f /tmp/pia.pf.json

  ip link add dev pia type wireguard
  ip address add dev pia $json.peer_ip

  wg setconf pia /private/pia.wg.conf
  resolvectl dns pia ...$json.dns_servers

  $"table wg-pia {
    chain preraw {
      type filter hook prerouting priority raw;
      iifname != \"pia\" ip daddr ($json.peer_ip) drop;
    };

    chain premangle {
      type filter hook prerouting priority mangle;
      meta l4proto udp mark 0x($fwmark_hex) ct mark set mark;
    };

    chain postmangle {
      type filter hook postrouting priority mangle;
      meta l4proto udp meta mark set ct mark;
    };
  }

  table ip tailscale-pia {
    chain preraw {
      type filter hook prerouting priority raw; policy accept;
      iifname \"tailscale0\" ip daddr != 100.64.0.0/16 mark set ($fwmark);
    }

    chain postrouting {
      type nat hook postrouting priority srcnat;
      iifname \"tailscale0\" masquerade;
    }
  }
  " | nft -ef -

  ip rule add fwmark $fwmark table $fwmark
  ip link set up dev pia

  if $route_exit_node_traffic {
    ip route add 0.0.0.0/0 dev pia table $fwmark
  }

  # needed for binding other apps
  ip -4 route add default dev pia table $fwmark
  ip rule add from $json.peer_ip lookup $fwmark
}

def revert [] {
  ip route del 0.0.0.0/0 dev pia
  try {ip link del dev pia}
}

def "main forwarding" [
  ca_cert: string,
  redirect_port: int,
] {
  let json = open /tmp/pia.pf.json;

  let wg_info = $json;
  let user_token = $json.token;

  loop {
    let sigpay = curl --interface pia -G --connect-to $"($wg_info.hostname)::($wg_info.server_ip):" --cacert $ca_cert --data-urlencode $"token=($user_token)" $"https://($wg_info.hostname):19999/getSignature" | from json
    let sigpay = $sigpay | merge ($sigpay.payload | decode base64 | decode | from json)
    $sigpay | print -e
    $sigpay | save /tmp/pia.pfsig.json -f
    let start = date now;


    sleep 10sec

    let sigpay = open /tmp/pia.pfsig.json
    mut session_id = "";
    loop {
      curl --interface pia -G --connect-to $"($wg_info.hostname)::($wg_info.server_ip):" --cacert $ca_cert --data-urlencode $"payload=($sigpay.payload)" --data-urlencode $"signature=($sigpay.signature)"  $"https://($wg_info.hostname):19999/bindPort"

      try {
        loop {
          let post = http post -eft application/json http://kokuzo:9091/transmission/rpc -H {x-transmission-session-id: $session_id} {
            method: "session-set",
            arguments: {
              "peer-port": $sigpay.port
            }
          };
          if $post.status == 409 {
            $session_id = $post | get headers.response | find -n x-transmission | get 0.value
            continue;
          }
          break;
        }
      } catch {|e|
        $e.rendered | print -e
      }

      sleep 15min

      if ((date now) - $start > 2wk) {
        break;
      }
    }
  }
}
