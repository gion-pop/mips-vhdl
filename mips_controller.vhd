library ieee;
use ieee.std_logic_1164.all;

use WORK.mips_package.all;

entity mips_controller is
  port (
    op                           : in  std_logic_vector(5 downto 0);  -- Operation
    funct                        : in  std_logic_vector(5 downto 0);  -- function field
    rd1sel, branch, jump         : out std_logic;
    regwrite, regdst, r31set     : out std_logic;
    memwrite, memtoreg, pc4toreg : out std_logic;
    alusrc                       : out std_logic;
    alucontrol                   : out std_logic_vector(3 downto 0));
end mips_controller;

architecture behv of mips_controller is
begin

  -----------------------------------------------------------------------------
  -- decide control signal by operation (exclude ALU)
  process (op, funct)
  begin
    -- initialize
    rd1sel   <= '0';
    branch   <= '0';
    jump     <= '0';
    regwrite <= '0';
    regdst   <= '0';
    r31set   <= '0';
    alusrc   <= '0';
    memwrite <= '0';
    memtoreg <= '0';
    pc4toreg <= '0';

    case op is
      when r_form =>
        regwrite <= '1';
        regdst   <= '1';
        if funct = funct_jr then
          rd1sel <= '1';
        end if;
      when lw =>
        regwrite <= '1';
        alusrc   <= '1';
        memtoreg <= '1';
      when sw =>
        alusrc   <= '1';
        memwrite <= '1';
      when addi | andi | ori =>
        regwrite <= '1';
        alusrc   <= '1';
      when beq =>
        branch <= '1';
      when j =>
        jump <= '1';
      when jal =>
        jump     <= '1';
        regwrite <= '1';
        r31set   <= '1';
      when others => null;
    end case;
  end process;

  -----------------------------------------------------------------------------
  -- decide ALU control signal
  process (op, funct)
  begin
    case op is
      when beq  => alucontrol <= alu_sub;
      when addi => alucontrol <= alu_add;
      when andi => alucontrol <= alu_and;
      when ori  => alucontrol <= alu_or;
      when lw   => alucontrol <= alu_add;
      when sw   => alucontrol <= alu_add;
      when r_form =>
        case funct is
          when funct_add => alucontrol <= alu_add;
          when funct_sub => alucontrol <= alu_sub;
          when funct_and => alucontrol <= alu_and;
          when funct_or => alucontrol <= alu_or;
          when funct_nor => alucontrol <= alu_nor;
          when others => null;
        end case;
      when others => null;
    end case;
  end process;
-----------------------------------------------------------------------------
end behv;
