library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use WORK.mips_package.all;

entity mips_datapath is
  port (
    clk, rst                     : in  std_logic;
    rd1sel, branch, jump         : in  std_logic;
    regwrite, regdst, r31Set     : in  std_logic;
    memwrite, memtoreg, pc4toreg : in  std_logic;
    alusrc                       : in  std_logic;
    alucontrol                   : in  alu_code;
    instr                        : out address_width;
    pc                           : out data_width);
end mips_datapath;

architecture structure of mips_datapath is

  component imem
    port (
      addr : in  address_width;
      rd   : out data_width);
  end component;

  component alu
    port (
      srcA, srcB : in  data_width;
      alucontrol : in  alu_code;
      aluout     : out data_width;
      zero       : out std_logic);
  end component;

  component regfile
    port (
      clk, rst      : in  std_logic;
      we3           : in  std_logic;
      ra1, ra2, wa3 : in  register_description;
      wd3           : in  data_width;
      rd1, rd2      : out data_width);
  end component;

  component dmem
    port (
      clk  : in  std_logic;
      we   : in  std_logic;
      addr : in  address_width;
      wd   : in  data_width;
      rd   : out data_width);
  end component;

  component signext
    port (
      a : in  std_logic_vector(15 downto 0);
      y : out address_width);
  end component;

  signal PCreg, pc_next, pc4, pcjump, pcbranch : address_width := (others => '0');

  signal signimm : data_width := (others => '0');

  signal inst : data_width := (others => '0');

  signal srcA, srcB, ALUout : data_width := (others => '0');
  signal zero               : std_logic  := '0';

  signal rs, rt, rd : register_description := (others => '0');
  signal WriteAddr  : register_description := (others => '0');
  signal WriteData  : data_width           := (others => '0');
  signal rd1, rd2   : data_width           := (others => '0');
  signal dmem_rd    : data_width           := (others => '0');
begin

  -----------------------------------------------------------------------------
  pc <= PCreg;

  process (clk, rst)
  begin
    if rst = '0' then
      PCreg <= (others => '0');
    elsif clk'event and clk = '1' then
      PCreg <= pc_next;
    end if;
  end process;

  process (jump, branch, zero, rd1sel, pcjump, pcbranch, srcA, pc4)
  begin
    if jump = '1' then
      pc_next <= pcjump;
    elsif branch = '1' and zero = '1' then
      pc_next <= pcbranch;
    elsif rd1sel = '1' then
      pc_next <= srcA;
    else
      pc_next <= pc4;
    end if;
  end process;

  pc4      <= PCreg + 4;
  pcjump   <= pc4(31 downto 28) & inst(25 downto 0) & "00";
  pcbranch <= (signimm(29 downto 0) & "00") + pc4;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Instruction Fetch
  IMEM0 : imem port map (
    addr => PCreg,
    rd   => inst);

  -----------------------------------------------------------------------------
  -- Instruction Decode
  instr <= inst;
  rs    <= inst(25 downto 21);
  rt    <= inst(20 downto 16);
  rd    <= inst(15 downto 11);

  RF : regfile port map (
    clk => clk,
    rst => rst,
    we3 => regwrite,
    ra1 => rs,
    ra2 => rt,
    wa3 => WriteAddr,
    wd3 => WriteData,
    rd1 => rd1,
    rd2 => rd2);

  process (rt, rd, regdst, r31set)
  begin
    if r31Set = '1' then
      WriteAddr <= "11111";
    elsif regdst = '1' then
      WriteAddr <= rd;
    else
      WriteAddr <= rt;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Execution

  EXT0 : signext port map (a => inst(15 downto 0), y => signimm);
  process (alusrc, signimm, rd2)
  begin
    if alusrc = '0' then
      srcB <= rd2;
    else
      srcB <= signimm;
    end if;
  end process;

  ALU1 : alu port map (
    srcA       => rd1,
    srcB       => srcB,
    alucontrol => alucontrol,
    aluout     => aluout,
    zero       => zero);

  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Memory

  DMEM1 : dmem port map (
    clk  => clk,
    we   => memwrite,
    addr => aluout,
    wd   => rd2,
    rd   => dmem_rd);

  process (aluout, writedata, memtoreg, pc4, pc4toreg)
    variable tmp : data_width;
  begin
    if pc4toreg = '1' then
      WriteData <= pc4;
    elsif memtoreg = '1' then
      WriteData <= dmem_rd;
    else
      WriteData <= aluout;
    end if;
  end process;
  -----------------------------------------------------------------------------

end structure;
