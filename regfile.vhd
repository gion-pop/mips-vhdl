library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity regfile is
  port (
    clk, rst      : in  std_logic;
    we3           : in  std_logic;
    ra1, ra2, wa3 : in  std_logic_vector(4 downto 0);
    wd3           : in  std_logic_vector(31 downto 0);
    rd1, rd2      : out std_logic_vector(31 downto 0));
end regfile;

architecture behv of regfile is
  type ramtype is array (0 to 31) of std_logic_vector(31 downto 0);
  signal mem : ramtype := (others => (others => '0'));
begin

  process (clk)
  begin
    if rst = '0' then
      mem <= (others => (others => '0'));
    elsif clk'event and clk = '1' then
      if we3 = '1' then
        mem(conv_integer(wa3)) <= wd3;
      end if;
    end if;
  end process;

  process (ra1, ra2, mem)
  begin
    if conv_integer(ra1) = 0 then
      rd1 <= X"00000000";
    else
      rd1 <= mem(conv_integer(ra1));
    end if;

    if conv_integer(ra2) = 0 then
      rd2 <= X"00000000";
    else
      rd2 <= mem(conv_integer(ra2));
    end if;
  end process;
end behv;
