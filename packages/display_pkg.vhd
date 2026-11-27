library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;

package display_pkg is

  --Copied and converted from SDL
  constant  K_KEY_UNKNOWN                : natural := 16#00000000#;
  constant  K_KEY_RETURN                 : natural := 16#0000000d#;
  constant  K_KEY_ESCAPE                 : natural := 16#0000001b#;
  constant  K_KEY_BACKSPACE              : natural := 16#00000008#;
  constant  K_KEY_TAB                    : natural := 16#00000009#;
  constant  K_KEY_SPACE                  : natural := 16#00000020#;
  constant  K_KEY_EXCLAIM                : natural := 16#00000021#;
  constant  K_KEY_DBLAPOSTROPHE          : natural := 16#00000022#;
  constant  K_KEY_HASH                   : natural := 16#00000023#;
  constant  K_KEY_DOLLAR                 : natural := 16#00000024#;
  constant  K_KEY_PERCENT                : natural := 16#00000025#;
  constant  K_KEY_AMPERSAND              : natural := 16#00000026#;
  constant  K_KEY_APOSTROPHE             : natural := 16#00000027#;
  constant  K_KEY_LEFTPAREN              : natural := 16#00000028#;
  constant  K_KEY_RIGHTPAREN             : natural := 16#00000029#;
  constant  K_KEY_ASTERISK               : natural := 16#0000002a#;
  constant  K_KEY_PLUS                   : natural := 16#0000002b#;
  constant  K_KEY_COMMA                  : natural := 16#0000002c#;
  constant  K_KEY_MINUS                  : natural := 16#0000002d#;
  constant  K_KEY_PERIOD                 : natural := 16#0000002e#;
  constant  K_KEY_SLASH                  : natural := 16#0000002f#;
  constant  K_KEY_0                      : natural := 16#00000030#;
  constant  K_KEY_1                      : natural := 16#00000031#;
  constant  K_KEY_2                      : natural := 16#00000032#;
  constant  K_KEY_3                      : natural := 16#00000033#;
  constant  K_KEY_4                      : natural := 16#00000034#;
  constant  K_KEY_5                      : natural := 16#00000035#;
  constant  K_KEY_6                      : natural := 16#00000036#;
  constant  K_KEY_7                      : natural := 16#00000037#;
  constant  K_KEY_8                      : natural := 16#00000038#;
  constant  K_KEY_9                      : natural := 16#00000039#;
  constant  K_KEY_COLON                  : natural := 16#0000003a#;
  constant  K_KEY_SEMICOLON              : natural := 16#0000003b#;
  constant  K_KEY_LESS                   : natural := 16#0000003c#;
  constant  K_KEY_EQUALS                 : natural := 16#0000003d#;
  constant  K_KEY_GREATER                : natural := 16#0000003e#;
  constant  K_KEY_QUESTION               : natural := 16#0000003f#;
  constant  K_KEY_AT                     : natural := 16#00000040#;
  constant  K_KEY_LEFTBRACKET            : natural := 16#0000005b#;
  constant  K_KEY_BACKSLASH              : natural := 16#0000005c#;
  constant  K_KEY_RIGHTBRACKET           : natural := 16#0000005d#;
  constant  K_KEY_CARET                  : natural := 16#0000005e#;
  constant  K_KEY_UNDERSCORE             : natural := 16#0000005f#;
  constant  K_KEY_GRAVE                  : natural := 16#00000060#;
  constant  K_KEY_A                      : natural := 16#00000061#;
  constant  K_KEY_B                      : natural := 16#00000062#;
  constant  K_KEY_C                      : natural := 16#00000063#;
  constant  K_KEY_D                      : natural := 16#00000064#;
  constant  K_KEY_E                      : natural := 16#00000065#;
  constant  K_KEY_F                      : natural := 16#00000066#;
  constant  K_KEY_G                      : natural := 16#00000067#;
  constant  K_KEY_H                      : natural := 16#00000068#;
  constant  K_KEY_I                      : natural := 16#00000069#;
  constant  K_KEY_J                      : natural := 16#0000006a#;
  constant  K_KEY_K                      : natural := 16#0000006b#;
  constant  K_KEY_L                      : natural := 16#0000006c#;
  constant  K_KEY_M                      : natural := 16#0000006d#;
  constant  K_KEY_N                      : natural := 16#0000006e#;
  constant  K_KEY_O                      : natural := 16#0000006f#;
  constant  K_KEY_P                      : natural := 16#00000070#;
  constant  K_KEY_Q                      : natural := 16#00000071#;
  constant  K_KEY_R                      : natural := 16#00000072#;
  constant  K_KEY_S                      : natural := 16#00000073#;
  constant  K_KEY_T                      : natural := 16#00000074#;
  constant  K_KEY_U                      : natural := 16#00000075#;
  constant  K_KEY_V                      : natural := 16#00000076#;
  constant  K_KEY_W                      : natural := 16#00000077#;
  constant  K_KEY_X                      : natural := 16#00000078#;
  constant  K_KEY_Y                      : natural := 16#00000079#;
  constant  K_KEY_Z                      : natural := 16#0000007a#;
  constant  K_KEY_LEFTBRACE              : natural := 16#0000007b#;
  constant  K_KEY_PIPE                   : natural := 16#0000007c#;
  constant  K_KEY_RIGHTBRACE             : natural := 16#0000007d#;
  constant  K_KEY_TILDE                  : natural := 16#0000007e#;
  constant  K_KEY_DELETE                 : natural := 16#0000007f#;
  constant  K_KEY_PLUSMINUS              : natural := 16#000000b1#;
  constant  K_KEY_CAPSLOCK               : natural := 16#40000039#;
  constant  K_KEY_F1                     : natural := 16#4000003a#;
  constant  K_KEY_F2                     : natural := 16#4000003b#;
  constant  K_KEY_F3                     : natural := 16#4000003c#;
  constant  K_KEY_F4                     : natural := 16#4000003d#;
  constant  K_KEY_F5                     : natural := 16#4000003e#;
  constant  K_KEY_F6                     : natural := 16#4000003f#;
  constant  K_KEY_F7                     : natural := 16#40000040#;
  constant  K_KEY_F8                     : natural := 16#40000041#;
  constant  K_KEY_F9                     : natural := 16#40000042#;
  constant  K_KEY_F10                    : natural := 16#40000043#;
  constant  K_KEY_F11                    : natural := 16#40000044#;
  constant  K_KEY_F12                    : natural := 16#40000045#;
  constant  K_KEY_PRINTSCREEN            : natural := 16#40000046#;
  constant  K_KEY_SCROLLLOCK             : natural := 16#40000047#;
  constant  K_KEY_PAUSE                  : natural := 16#40000048#;
  constant  K_KEY_INSERT                 : natural := 16#40000049#;
  constant  K_KEY_HOME                   : natural := 16#4000004a#;
  constant  K_KEY_PAGEUP                 : natural := 16#4000004b#;
  constant  K_KEY_END                    : natural := 16#4000004d#;
  constant  K_KEY_PAGEDOWN               : natural := 16#4000004e#;
  constant  K_KEY_RIGHT                  : natural := 16#4000004f#;
  constant  K_KEY_LEFT                   : natural := 16#40000050#;
  constant  K_KEY_DOWN                   : natural := 16#40000051#;
  constant  K_KEY_UP                     : natural := 16#40000052#;
  constant  K_KEY_NUMLOCKCLEAR           : natural := 16#40000053#;
  constant  K_KEY_KP_DIVIDE              : natural := 16#40000054#;
  constant  K_KEY_KP_MULTIPLY            : natural := 16#40000055#;
  constant  K_KEY_KP_MINUS               : natural := 16#40000056#;
  constant  K_KEY_KP_PLUS                : natural := 16#40000057#;
  constant  K_KEY_KP_ENTER               : natural := 16#40000058#;
  constant  K_KEY_KP_1                   : natural := 16#40000059#;
  constant  K_KEY_KP_2                   : natural := 16#4000005a#;
  constant  K_KEY_KP_3                   : natural := 16#4000005b#;
  constant  K_KEY_KP_4                   : natural := 16#4000005c#;
  constant  K_KEY_KP_5                   : natural := 16#4000005d#;
  constant  K_KEY_KP_6                   : natural := 16#4000005e#;
  constant  K_KEY_KP_7                   : natural := 16#4000005f#;
  constant  K_KEY_KP_8                   : natural := 16#40000060#;
  constant  K_KEY_KP_9                   : natural := 16#40000061#;
  constant  K_KEY_KP_0                   : natural := 16#40000062#;
  constant  K_KEY_KP_PERIOD              : natural := 16#40000063#;
  constant  K_KEY_APPLICATION            : natural := 16#40000065#;
  constant  K_KEY_POWER                  : natural := 16#40000066#;
  constant  K_KEY_KP_EQUALS              : natural := 16#40000067#;
  constant  K_KEY_F13                    : natural := 16#40000068#;
  constant  K_KEY_F14                    : natural := 16#40000069#;
  constant  K_KEY_F15                    : natural := 16#4000006a#;
  constant  K_KEY_F16                    : natural := 16#4000006b#;
  constant  K_KEY_F17                    : natural := 16#4000006c#;
  constant  K_KEY_F18                    : natural := 16#4000006d#;
  constant  K_KEY_F19                    : natural := 16#4000006e#;
  constant  K_KEY_F20                    : natural := 16#4000006f#;
  constant  K_KEY_F21                    : natural := 16#40000070#;
  constant  K_KEY_F22                    : natural := 16#40000071#;
  constant  K_KEY_F23                    : natural := 16#40000072#;
  constant  K_KEY_F24                    : natural := 16#40000073#;
  constant  K_KEY_EXECUTE                : natural := 16#40000074#;
  constant  K_KEY_HELP                   : natural := 16#40000075#;
  constant  K_KEY_MENU                   : natural := 16#40000076#;
  constant  K_KEY_SELECT                 : natural := 16#40000077#;
  constant  K_KEY_STOP                   : natural := 16#40000078#;
  constant  K_KEY_AGAIN                  : natural := 16#40000079#;
  constant  K_KEY_UNDO                   : natural := 16#4000007a#;
  constant  K_KEY_CUT                    : natural := 16#4000007b#;
  constant  K_KEY_COPY                   : natural := 16#4000007c#;
  constant  K_KEY_PASTE                  : natural := 16#4000007d#;
  constant  K_KEY_FIND                   : natural := 16#4000007e#;
  constant  K_KEY_MUTE                   : natural := 16#4000007f#;
  constant  K_KEY_VOLUMEUP               : natural := 16#40000080#;
  constant  K_KEY_VOLUMEDOWN             : natural := 16#40000081#;
  constant  K_KEY_KP_COMMA               : natural := 16#40000085#;
  constant  K_KEY_KP_EQUALSAS400         : natural := 16#40000086#;
  constant  K_KEY_ALTERASE               : natural := 16#40000099#;
  constant  K_KEY_SYSREQ                 : natural := 16#4000009a#;
  constant  K_KEY_CANCEL                 : natural := 16#4000009b#;
  constant  K_KEY_CLEAR                  : natural := 16#4000009c#;
  constant  K_KEY_PRIOR                  : natural := 16#4000009d#;
  constant  K_KEY_RETURN2                : natural := 16#4000009e#;
  constant  K_KEY_SEPARATOR              : natural := 16#4000009f#;
  constant  K_KEY_OUT                    : natural := 16#400000a0#;
  constant  K_KEY_OPER                   : natural := 16#400000a1#;
  constant  K_KEY_CLEARAGAIN             : natural := 16#400000a2#;
  constant  K_KEY_CRSEL                  : natural := 16#400000a3#;
  constant  K_KEY_EXSEL                  : natural := 16#400000a4#;
  constant  K_KEY_KP_00                  : natural := 16#400000b0#;
  constant  K_KEY_KP_000                 : natural := 16#400000b1#;
  constant  K_KEY_THOUSANDSSEPARATOR     : natural := 16#400000b2#;
  constant  K_KEY_DECIMALSEPARATOR       : natural := 16#400000b3#;
  constant  K_KEY_CURRENCYUNIT           : natural := 16#400000b4#;
  constant  K_KEY_CURRENCYSUBUNIT        : natural := 16#400000b5#;
  constant  K_KEY_KP_LEFTPAREN           : natural := 16#400000b6#;
  constant  K_KEY_KP_RIGHTPAREN          : natural := 16#400000b7#;
  constant  K_KEY_KP_LEFTBRACE           : natural := 16#400000b8#;
  constant  K_KEY_KP_RIGHTBRACE          : natural := 16#400000b9#;
  constant  K_KEY_KP_TAB                 : natural := 16#400000ba#;
  constant  K_KEY_KP_BACKSPACE           : natural := 16#400000bb#;
  constant  K_KEY_KP_A                   : natural := 16#400000bc#;
  constant  K_KEY_KP_B                   : natural := 16#400000bd#;
  constant  K_KEY_KP_C                   : natural := 16#400000be#;
  constant  K_KEY_KP_D                   : natural := 16#400000bf#;
  constant  K_KEY_KP_E                   : natural := 16#400000c0#;
  constant  K_KEY_KP_F                   : natural := 16#400000c1#;
  constant  K_KEY_KP_XOR                 : natural := 16#400000c2#;
  constant  K_KEY_KP_POWER               : natural := 16#400000c3#;
  constant  K_KEY_KP_PERCENT             : natural := 16#400000c4#;
  constant  K_KEY_KP_LESS                : natural := 16#400000c5#;
  constant  K_KEY_KP_GREATER             : natural := 16#400000c6#;
  constant  K_KEY_KP_AMPERSAND           : natural := 16#400000c7#;
  constant  K_KEY_KP_DBLAMPERSAND        : natural := 16#400000c8#;
  constant  K_KEY_KP_VERTICALBAR         : natural := 16#400000c9#;
  constant  K_KEY_KP_DBLVERTICALBAR      : natural := 16#400000ca#;
  constant  K_KEY_KP_COLON               : natural := 16#400000cb#;
  constant  K_KEY_KP_HASH                : natural := 16#400000cc#;
  constant  K_KEY_KP_SPACE               : natural := 16#400000cd#;
  constant  K_KEY_KP_AT                  : natural := 16#400000ce#;
  constant  K_KEY_KP_EXCLAM              : natural := 16#400000cf#;
  constant  K_KEY_KP_MEMSTORE            : natural := 16#400000d0#;
  constant  K_KEY_KP_MEMRECALL           : natural := 16#400000d1#;
  constant  K_KEY_KP_MEMCLEAR            : natural := 16#400000d2#;
  constant  K_KEY_KP_MEMADD              : natural := 16#400000d3#;
  constant  K_KEY_KP_MEMSUBTRACT         : natural := 16#400000d4#;
  constant  K_KEY_KP_MEMMULTIPLY         : natural := 16#400000d5#;
  constant  K_KEY_KP_MEMDIVIDE           : natural := 16#400000d6#;
  constant  K_KEY_KP_PLUSMINUS           : natural := 16#400000d7#;
  constant  K_KEY_KP_CLEAR               : natural := 16#400000d8#;
  constant  K_KEY_KP_CLEARENTRY          : natural := 16#400000d9#;
  constant  K_KEY_KP_BINARY              : natural := 16#400000da#;
  constant  K_KEY_KP_OCTAL               : natural := 16#400000db#;
  constant  K_KEY_KP_DECIMAL             : natural := 16#400000dc#;
  constant  K_KEY_KP_HEXADECIMAL         : natural := 16#400000dd#;
  constant  K_KEY_LCTRL                  : natural := 16#400000e0#;
  constant  K_KEY_LSHIFT                 : natural := 16#400000e1#;
  constant  K_KEY_LALT                   : natural := 16#400000e2#;
  constant  K_KEY_LGUI                   : natural := 16#400000e3#;
  constant  K_KEY_RCTRL                  : natural := 16#400000e4#;
  constant  K_KEY_RSHIFT                 : natural := 16#400000e5#;
  constant  K_KEY_RALT                   : natural := 16#400000e6#;
  constant  K_KEY_RGUI                   : natural := 16#400000e7#;
  constant  K_KEY_MODE                   : natural := 16#40000101#;
  constant  K_KEY_SLEEP                  : natural := 16#40000102#;
  constant  K_KEY_WAKE                   : natural := 16#40000103#;
  constant  K_KEY_CHANNEL_INCREMENT      : natural := 16#40000104#;
  constant  K_KEY_CHANNEL_DECREMENT      : natural := 16#40000105#;
  constant  K_KEY_MEDIA_PLAY             : natural := 16#40000106#;
  constant  K_KEY_MEDIA_PAUSE            : natural := 16#40000107#;
  constant  K_KEY_MEDIA_RECORD           : natural := 16#40000108#;
  constant  K_KEY_MEDIA_FAST_FORWARD     : natural := 16#40000109#;
  constant  K_KEY_MEDIA_REWIND           : natural := 16#4000010a#;
  constant  K_KEY_MEDIA_NEXT_TRACK       : natural := 16#4000010b#;
  constant  K_KEY_MEDIA_PREVIOUS_TRACK   : natural := 16#4000010c#;
  constant  K_KEY_MEDIA_STOP             : natural := 16#4000010d#;
  constant  K_KEY_MEDIA_EJECT            : natural := 16#4000010e#;
  constant  K_KEY_MEDIA_PLAY_PAUSE       : natural := 16#4000010f#;
  constant  K_KEY_MEDIA_SELECT           : natural := 16#40000110#;
  constant  K_KEY_AC_NEW                 : natural := 16#40000111#;
  constant  K_KEY_AC_OPEN                : natural := 16#40000112#;
  constant  K_KEY_AC_CLOSE               : natural := 16#40000113#;
  constant  K_KEY_AC_EXIT                : natural := 16#40000114#;
  constant  K_KEY_AC_SAVE                : natural := 16#40000115#;
  constant  K_KEY_AC_PRINT               : natural := 16#40000116#;
  constant  K_KEY_AC_PROPERTIES          : natural := 16#40000117#;
  constant  K_KEY_AC_SEARCH              : natural := 16#40000118#;
  constant  K_KEY_AC_HOME                : natural := 16#40000119#;
  constant  K_KEY_AC_BACK                : natural := 16#4000011a#;
  constant  K_KEY_AC_FORWARD             : natural := 16#4000011b#;
  constant  K_KEY_AC_STOP                : natural := 16#4000011c#;
  constant  K_KEY_AC_REFRESH             : natural := 16#4000011d#;
  constant  K_KEY_AC_BOOKMARKS           : natural := 16#4000011e#;
  constant  K_KEY_SOFTLEFT               : natural := 16#4000011f#;
  constant  K_KEY_SOFTRIGHT              : natural := 16#40000120#;
  constant  K_KEY_CALL                   : natural := 16#40000121#;
  constant  K_KEY_ENDCALL                : natural := 16#40000122#;
  constant  K_KEY_LEFT_TAB               : natural := 16#20000001#;
  constant  K_KEY_LEVEL5_SHIFT           : natural := 16#20000002#;
  constant  K_KEY_MULTI_KEY_COMPOSE      : natural := 16#20000003#;
  constant  K_KEY_LMETA                  : natural := 16#20000004#;
  constant  K_KEY_RMETA                  : natural := 16#20000005#;
  constant  K_KEY_LHYPER                 : natural := 16#20000006#;
  constant  K_KEY_RHYPER                 : natural := 16#20000007#;

  type t_color is record
    r : t_byte_uns;
    g : t_byte_uns;
    b : t_byte_uns;
  end record t_color;

  type t_color_real is record
    r : real;
    g : real;
    b : real;
  end record t_color_real;

  constant K_COLOR_WIDTH : natural := 3*K_BYTE_WIDTH;

  subtype t_color_slv is std_logic_vector(K_COLOR_WIDTH-1 downto 0);

  constant K_COLOR_DEFAULT      : t_color      := (others => (others => '0'));
  constant K_COLOR_REAL_DEFAULT : t_color_real := (others => 0.0);

  constant K_COLOR_RED : t_color := (
    r => (others => '1'),
    g => (others => '0'),
    b => (others => '0')
  );
  constant K_COLOR_GREEN : t_color := (
    r => (others => '0'),
    g => (others => '1'),
    b => (others => '0')
  );
  constant K_COLOR_BLUE : t_color := (
    r => (others => '0'),
    g => (others => '0'),
    b => (others => '1')
  );
  constant K_COLOR_WHITE : t_color := (
    r => (others => '1'),
    g => (others => '1'),
    b => (others => '1')
  );
  constant K_COLOR_BLACK : t_color := (
    r => (others => '0'),
    g => (others => '0'),
    b => (others => '0')
  );

  type t_color_arr      is array (natural range <>) of t_color;
  type t_color_real_arr is array (natural range <>) of t_color_real;
  type t_color_slv_arr  is array (natural range <>) of t_color_slv;

  type t_color_arr_2d      is array (natural range <>) of t_color_arr;
  type t_color_real_arr_2d is array (natural range <>) of t_color_real_arr;
  type t_color_slv_arr_2d  is array (natural range <>) of t_color_slv_arr;

  function f_color_to_slv(
    clr : t_color
  ) return t_color_slv;

  function f_slv_to_color(
    slv : t_color_slv
  ) return t_color;

  function f_color_real_to_color(
    clr_real : t_color_real
  ) return t_color;

end package display_pkg;

package body display_pkg is

  function f_color_to_slv(
    clr : t_color
  ) return t_color_slv is
    variable slv : t_color_slv := (others => '0');
  begin
    slv := std_logic_vector(clr.r) &
           std_logic_vector(clr.g) &
           std_logic_vector(clr.b);
    return slv;
  end function f_color_to_slv;

  function f_slv_to_color(
    slv : t_color_slv
  ) return t_color is
    variable clr : t_color := K_COLOR_DEFAULT;
  begin
    clr.b := unsigned(slv(K_BYTE_WIDTH-1   downto 0));
    clr.g := unsigned(slv(2*K_BYTE_WIDTH-1 downto K_BYTE_WIDTH));
    clr.r := unsigned(slv(3*K_BYTE_WIDTH-1 downto 2*K_BYTE_WIDTH));
    return clr;
  end function f_slv_to_color;

  function f_color_real_to_color(
    clr_real : t_color_real
  ) return t_color is
    variable clr : t_color := K_COLOR_DEFAULT;
  begin
    clr.b := to_unsigned(integer(round(clr_real.r)), K_BYTE_WIDTH);
    clr.g := to_unsigned(integer(round(clr_real.g)), K_BYTE_WIDTH);
    clr.r := to_unsigned(integer(round(clr_real.b)), K_BYTE_WIDTH);
    return clr;
  end function f_color_real_to_color;

end package body display_pkg;
