library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Data Memory
entity dmem is
  port (
    clk      : in  std_logic;
    we       : in  std_logic;
    addr, wd : in  std_logic_vector(31 downto 0);
    rd       : out std_logic_vector(31 downto 0));
end dmem;

architecture behv of dmem is
  type   ramtype is array (0 to 63) of std_logic_vector(31 downto 0);
  signal mem : ramtype := (others => (others => '0'));
begin
  rd <= mem(conv_integer(addr(7 downto 2)));

  process (clk, we, wd, addr)
  begin
    if clk'event and clk = '1' then
      if we = '1' then
        mem(conv_integer(addr(7 downto 2))) <= wd;
      end if;
    end if;
  end process;

end behv;
