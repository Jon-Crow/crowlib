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
          G_INIT   => G_INIT(r)(c),
          G_CONFIG => G_CONFIG
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

    end generate gen_cols;
  end generate gen_rows;

  c_neighbors : process(all)
  begin
    n  <= (others => (others => (others => '0')));
    ne <= (others => (others => (others => '0')));
    e  <= (others => (others => (others => '0')));
    se <= (others => (others => (others => '0')));
    s  <= (others => (others => (others => '0')));
    sw <= (others => (others => (others => '0')));
    w  <= (others => (others => (others => '0')));
    nw <= (others => (others => (others => '0')));

    for r in 0 to G_HEIGHT-1 loop
      for c in 0 to G_WIDTH-1 loop

        n (r)(c) <= states((r-1) mod G_HEIGHT)(c);
        ne(r)(c) <= states((r-1) mod G_HEIGHT)((c+1) mod G_WIDTH);
        e (r)(c) <= states(r                 )((c+1) mod G_WIDTH);
        se(r)(c) <= states((r+1) mod G_HEIGHT)((c+1) mod G_WIDTH);
        s (r)(c) <= states((r+1) mod G_HEIGHT)(c);
        sw(r)(c) <= states((r+1) mod G_HEIGHT)((c-1) mod G_WIDTH);
        w (r)(c) <= states(r                 )((c-1) mod G_WIDTH);
        nw(r)(c) <= states((r-1) mod G_HEIGHT)((c-1) mod G_WIDTH);

      end loop;
    end loop;

  end process c_neighbors;

end architecture cellular_automata_grid_arch;
