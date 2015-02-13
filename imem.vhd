library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity imem is
  port (
    addr    : in  std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0));
end imem;

architecture behv of imem is
begin

  process
    file FI        : text is in "memfile4.dat";
    variable LI    : line;
    variable inst  : std_logic_vector(31 downto 0);
    variable index : integer;

    type     romtype is array (0 to 63) of std_logic_vector(31 downto 0);
    variable mem : romtype;
  begin
    for I in 0 to 63 loop               -- initialize memory
      mem(I) := (others => '0');
    end loop;

    index := 0;

    while not endfile(FI) loop
      readline(FI, LI);
      read(LI, inst);
      mem(index) := inst;
      index      := index + 1;
    end loop;

    loop
      rd <= mem(conv_integer(addr(7 downto 2)));
      wait on addr;
    end loop;
  end process;
end behv;
