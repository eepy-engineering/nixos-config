lib: options_attrset:
let
  map_single = name: value: if value == true then name else "${name}=${builtins.toString value}";
  mapper =
    acc: name: value:
    if builtins.isAttrs value then
      acc ++ map (str: "${name}.${str}") (lib.attrsets.foldlAttrs mapper [ ] value)
    else
      acc ++ [ (map_single name value) ];
  options_array = lib.attrsets.foldlAttrs mapper [ ] options_attrset;
in
lib.strings.concatStrings (lib.strings.intersperse "," options_array)
