library ieee;
use ieee.std_logic_1164.all;

entity test_mips_processor is
end test_mips_processor;

architecture sim of test_mips_processor is
  component mips_processor
    port (
      clk, rst : in std_logic);
  end component;

  signal clk, rst : std_logic;

  constant CYCLE      : time := 100 ns;
  constant HALF_CYCLE : time := 50 ns;
  constant DELAY      : time := 25 ns;
  constant BEGIN_WAIT : time := 300 ns;

  signal DONE : boolean := false;

begin
  proc : mips_processor port map (clk, rst);

  process
  begin
    clk <= '1'; wait for HALF_CYCLE;
    clk <= '0'; wait for HALF_CYCLE;

    if done then
      wait;
    end if;
  end process;

  process
  begin
    rst <= '1'; wait for DELAY;
    rst <= '0'; wait for HALF_CYCLE;
    rst <= '1'; wait;
  end process;

  process
  begin
    for i in 0 to 100 loop
      wait for CYCLE;
    end loop;

    done <= true;
    wait;
  end process;

end sim;

configuration cfg_mips of test_mips_processor is
  for sim
  end for;
end cfg_mips;
