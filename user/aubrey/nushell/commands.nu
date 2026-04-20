# Like `describe` but dropping item types for collections.
export def describe-primitive []: any -> string {
  $in | describe | str replace --regex '<.*' ''
}


# A command for cherry-picking values from a record key recursively
export def "flatten record-paths" [
    --separator (-s): string = "."    # The separator to use when chaining paths
] {
    let input = $in

    if ($input | describe) !~ "record" {
        error make {msg: "The record-paths command expects a record"}
    }

    $input | flatten-record-paths $separator
}

def flatten-record-paths [separator: string, ctx?: string] {
    let input = $in
    match ($input | describe-primitive) {
        "record" => {
            $input
            | items { |key, value|
                  let path = if $ctx == null { $key } else { [$ctx $key] | str join $separator }
                  {path: $path, value: $value}
              }
            | reduce -f [] { |row, acc|
                  $acc
                  | append ($row.value | flatten-record-paths $separator $row.path)
                  | flatten
              }
        },
        "list" => {
            $input
            | enumerate
            | each { |e|
                  {path: ([$ctx $e.index] | str join $separator), value: $e.item}
              }
        },
        "table" => {
            $input | enumerate | each { |r| $r.item | flatten-record-paths $separator ([$ctx $r.index] | str join $separator) }
        }
        "block" | "closure" => { 
            error make {msg: "Unexpected type"} 
        },
        _ => {
            {path: $ctx, value: $input}
        },
    }
}