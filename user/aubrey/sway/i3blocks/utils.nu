export def "env int" [name: string, default: int] {
  $env | get -o $name | default $default | into int
}

export def "env bool" [name: string, default: bool] {
  $env | get -o $name | default $default | into bool
}