final: _prev: {
  writeNushellScript = name: contents:
    final.writeTextFile {
      inherit name;
      executable = true;
      checkPhase = ''
        ${final.nushell}/bin/nu -c "open $target | nu-check -d"
      '';
      text = ''
        #!${final.nushell}/bin/nu
        ${contents}
      '';
    };
  writeNushellScriptBin = name: contents:
    final.writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      checkPhase = ''
        ${final.nushell}/bin/nu -c "open $target | nu-check -d"
      '';
      text = ''
        #!${final.nushell}/bin/nu
        ${contents}
      '';
    };
}
