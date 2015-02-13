library ieee;
use ieee.std_logic_1164.all;

use WORK.mips_package.all;

entity mips_processor is
  port (
    clk, rst : in std_logic);
end mips_processor;

architecture net of mips_processor is
  signal rd1sel, branch, jump         : std_logic;
  signal regwrite, regdst, r31set     : std_logic;
  signal memwrite, memtoreg, pc4toreg : std_logic;
  signal alusrc                       : std_logic;
  signal alucontrol                   : alu_code;
  signal instr                        : data_width;
  signal op                           : op_code;
  signal funct                        : funct_code;

  component mips_datapath
    port (
      clk, rst                     : in  std_logic;
      rd1sel, branch, jump         : in  std_logic;
      regwrite, regdst, r31Set     : in  std_logic;
      memwrite, memtoreg, pc4toreg : in  std_logic;
      alusrc                       : in  std_logic;
      alucontrol                   : in  alu_code;
      instr : out data_width;
      pc                    : out address_width);
  end component;

  component mips_controller
    port (
      op                           : in  op_code;
      funct                        : in  funct_code;
      rd1sel, branch, jump         : out std_logic;
      regwrite, regdst, r31set     : out std_logic;
      memwrite, memtoreg, pc4toreg : out std_logic;
      alusrc                       : out std_logic;
      alucontrol                   : out alu_code);
  end component;

begin
  DATAPATH : mips_datapath port map (
    clk, rst,
    rd1sel, branch, jump, regwrite, regdst, r31Set,
    memwrite, memtoreg, pc4toreg, alusrc, alucontrol, instr);

  op    <= instr(31 downto 26);
  funct <= instr(5 downto 0);

  CTRL : mips_controller port map (
    op, funct,
    rd1sel, branch, jump, regwrite, regdst, r31Set,
    memwrite, memtoreg, pc4toreg, alusrc, alucontrol);
end net;
