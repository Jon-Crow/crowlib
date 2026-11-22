library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;

entity cellular_automata_grid is
  generic (
    G_WIDTH        : natural                                                                 := 256;
    G_HEIGHT       : natural                                                                 := 256;
    G_STATE_WIDTH  : natural                                                                 := 1;
    G_INIT         : t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(G_STATE_WIDTH-1 downto 0) := (others => (others => (others => '0')));
    G_CONFIG_WIDTH : positive                                                                := 1;
    G_CONFIG       : std_logic_vector(G_CONFIG_WIDTH-1 downto 0)                             := (others => '0')
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;

    states : out t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(G_STATE_WIDTH-1 downto 0)
  );
end entity cellular_automata_grid;

architecture cellular_automata_grid_arch of cellular_automata_grid is

  component cellular_automata_cell is
    generic (
      G_INIT   : std_logic_vector(G_STATE_WIDTH-1 downto 0)  := (others => '0');
      G_CONFIG : std_logic_vector(G_CONFIG_WIDTH-1 downto 0) := (others => '0')
    );
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;

      n     : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      ne    : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      e     : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      se    : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      s     : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      sw    : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      w     : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);
      nw    : in  std_logic_vector(G_STATE_WIDTH-1 downto 0);

      state : out std_logic_vector(G_STATE_WIDTH-1 downto 0)
    );
  end component cellular_automata_cell;

  subtype t_state_grid is t_slv_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1)(G_STATE_WIDTH-1 downto 0);

  signal n  : t_state_grid;
  signal ne : t_state_grid;
  signal e  : t_state_grid;
  signal se : t_state_grid;
  signal s  : t_state_grid;
  signal sw : t_state_grid;
  signal w  : t_state_grid;
  signal nw : t_state_grid;

begin

  gen_rows : for r in 0 to G_HEIGHT-1 generate
    gen_cols : for c in 0 to G_WIDTH-1 generate
      u_cell : cellular_automata_cell
        generic map (
          G_INIT => G_INIT(r)(c)
        )
        port map (
          clk   => clk,
          rst   => rst,

          n     => n(r)(c),
          ne    => ne(r)(c),
          e     => e(r)(c),
          se    => se(r)(c),
          s     => s(r)(c),
          sw    => sw(r)(c),
          w     => w(r)(c),
          nw    => nw(r)(c),

          state => states(r)(c)
      );

      gen_west : if c = 0 generate
        w(r)(c) <= (others => '0');
      else generate
        w(r)(c) <= states(r)(c-1);
      end generate gen_west;

      gen_east : if c = G_WIDTH-1 generate
        e(r)(c) <= (others => '0');
      else generate
        e(r)(c) <= states(r)(c+1);
      end generate gen_east;

      gen_north_west : if r = 0 or c = 0 generate
        nw(r)(c) <= (others => '0');
      else generate
        nw(r)(c) <= states(r-1)(c-1);
      end generate gen_north_west;

      gen_north_east : if r = 0 or c = G_WIDTH-1 generate
        ne(r)(c) <= (others => '0');
      else generate
        ne(r)(c) <= states(r-1)(c+1);
      end generate gen_north_east;

      gen_south_west : if r = G_HEIGHT-1 or c = 0 generate
        sw(r)(c) <= (others => '0');
      else generate
        sw(r)(c) <= states(r+1)(c-1);
      end generate gen_south_west;

      gen_south_east : if r = G_HEIGHT-1 or c = G_WIDTH-1 generate
        se(r)(c) <= (others => '0');
      else generate
        se(r)(c) <= states(r+1)(c+1);
      end generate gen_south_east;

    end generate gen_cols;

    gen_north : if r = 0 generate
      n(r) <= (others => (others => '0'));
    else generate
      n(r) <= states(r-1);
    end generate gen_north;

    gen_south : if r = G_HEIGHT-1 generate
      s(r) <= (others => (others => '0'));
    else generate
      s(r) <= states(r+1);
    end generate gen_south;

  end generate gen_rows;

end architecture cellular_automata_grid_arch;
