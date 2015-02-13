library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use WORK.mips_package.all;

entity alu is
  port (
    srcA, srcB : in  data_width;
    alucontrol : in  alu_code;
    aluout     : out data_width;
    zero       : out std_logic);
end alu;

architecture behv of alu is
  signal result : data_width;
  constant all_zero : data_width := (others => '0');
begin
  aluout <= result;

  process (srcA, srcB, alucontrol)
  begin
    case alucontrol is
      when alu_and => result <= srcA and srcB;
      when alu_or  => result <= srcA or srcB;
      when alu_add => result <= srcA + srcB;
      when alu_sub => result <= srcA - srcB;
      when alu_nor => result <= srcA nor srcB;
      when others  => result <= (others => 'X');
    end case;
  end process;

  zero <= '1' when result = all_zero else '0';
end behv;
