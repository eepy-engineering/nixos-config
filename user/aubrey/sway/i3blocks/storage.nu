let ssd = sys disks | get 0;
$"($ssd.total - $ssd.free)/($ssd.total)" | print
