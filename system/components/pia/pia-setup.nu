def main [
  username: string,
  password: string,
  region: string,
  ca_cert: string,
] {
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
  ip route add 0.0.0.0/0 dev pia table $fwmark
}
