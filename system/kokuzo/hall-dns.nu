def main [tokenPath: path] {
  const zoneId = "6660383af493f45f1cc32ee47606e459";
  const hallDnsRecord = "fbac35d169fae3c674a118e4bb1ed0f3";
  let token = open $tokenPath -r | str trim;
  mut payload = {
    type: "A",
    content: ""
  };
  mut logged = false;
  loop {
    loop {
      try {
        let old = $payload.content;
        $payload.content = http get https://icanhazip.com;
        if $old == $payload.content {
          if not $logged { print "same ip, not updating" }
          $logged = true;
          break;
        }
        $logged = false;

        $payload | to json | http patch $"https://api.cloudflare.com/client/v4/zones/($zoneId)/dns_records/($hallDnsRecord)" --headers {
          "Authorization": $"Bearer ($token)",
          "Content-Type": "application/json",
        };

        print "updated ip"
      } catch {|err| 
        $err.rendered | print
      }
      break;
    }
    sleep 3sec
  }
}
