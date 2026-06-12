{
  home.file = {
    ".gdbinit".text = ''
      set history save on
      set auto-load local-gdbinit

      define swbt
        set $frame = $fp
        set $prev_frame = 0
        while $frame != 0 && $prev_frame != $frame
          set $prev_frame = $frame
          p/x ((unsigned long long *)$frame)[1]
          set $frame = ((unsigned long long *)$frame)[0]
        end
      end
    '';
    ".gdbearlyinit".text = ''
      set startup-quietly on
    '';

    ".lldbinit".text = ''
      settings set target.x86-disassembly-flavor intel
    '';
  };
}
