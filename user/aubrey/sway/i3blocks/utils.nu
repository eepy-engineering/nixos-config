export def "env int" [name: string, default: int] {
  $env | get -o $name | default $default | into int
}
