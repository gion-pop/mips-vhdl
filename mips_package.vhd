library ieee;
use ieee.std_logic_1164.all;


package mips_package is

  subtype address_width is std_logic_vector(31 downto 0);
  subtype data_width is std_logic_vector(31 downto 0);
  subtype register_description is std_logic_vector(4 downto 0);

  subtype op_code is std_logic_vector(5 downto 0);
  constant r_form : op_code := "000000";
  constant j      : op_code := "000010";
  constant jal    : op_code := "000011";
  constant beq    : op_code := "000100";
  constant addi   : op_code := "001000";
  constant andi   : op_code := "001100";
  constant ori    : op_code := "001001";
  constant lw     : op_code := "100011";
  constant sw     : op_code := "101011";

  subtype funct_code is std_logic_vector(5 downto 0);
  constant funct_jr  : funct_code := "001000";
  constant funct_add : funct_code := "100000";
  constant funct_sub : funct_code := "100010";
  constant funct_and : funct_code := "100100";
  constant funct_or  : funct_code := "100101";
  constant funct_nor : funct_code := "100111";

  -- extended compat with real mips proc
  subtype alu_code is std_logic_vector(3 downto 0);
  constant alu_and : alu_code := "0000";
  constant alu_or  : alu_code := "0001";
  constant alu_add : alu_code := "0010";
  constant alu_sub : alu_code := "0110";
  constant alu_nor : alu_code := "1100";

end mips_package;
