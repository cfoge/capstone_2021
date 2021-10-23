----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Robert D Jordan
-- 
-- Create Date: 09.08.2021 15:26:40
-- Design Name: Alpha blender
-- Module Name: alphaBlend - Behavioral
-- Project Name: 
-- Target Devices: Arty Z7
-- Tool Versions: VIVADO 2020.2
-- Description: Alpha blend between 2 concatinated 8bit RGB pixel streams using an X bit alpha mix coefishent
-- // must be synthisized OOC to work, otherwise VIVADO ignores it!!
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; --this lib gives us access to the unsigned variable tyoe

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alphaBlend is -- must be synthisized OOC to work, otherwise VIVADO ignores it!!
port(
    clk1x:       in  std_logic; --pixel clock input


    --RGB input 0
    r_strm0:     in  std_logic_vector(9 downto 0);
    g_strm0:     in  std_logic_vector(9 downto 0);              
    b_strm0:     in  std_logic_vector(9 downto 0);

    --RGB input 2
    r_strm1:     in  std_logic_vector(9 downto 0);
    g_strm1:     in  std_logic_vector(9 downto 0);
    b_strm1:     in  std_logic_vector(9 downto 0);
    
    alpha_strm:  in  std_logic_vector(9 downto 0); -- alpha mix value as interger
    
    --RGB output
    r_blnd:     out std_logic_vector(9 downto 0);
    g_blnd:     out std_logic_vector(9 downto 0);
    b_blnd:     out std_logic_vector(9 downto 0)   
);
end alphaBlend;

architecture Behavioral of alphaBlend is

  --mix registers
  signal r0  : integer := 0;
  signal r1  : integer := 0;
  signal g0  : integer := 0;
  signal g1  : integer := 0;
  signal b0  : integer := 0;
  signal b1  : integer := 0;
  
  --output registers
  signal r0drive  : integer := 0;
  signal r1drive  : integer := 0;
  signal g0drive  : integer := 0;
  signal g1drive  : integer := 0;
  signal b0drive  : integer := 0;
  signal b1drive  : integer := 0;
  
  signal alpha_strm_drive: unsigned(10 downto 0); -- variable for our alpha coefishent with the value 0.0-1.0
  signal oneminusalpha : integer; -- variable for the 1-alpha
  
begin

    process (clk1x) is -- can i run this from a faster clock then the pixel clock?? would i want to?
        variable temp : unsigned(19 downto 0);
    begin
    if rising_edge(clk1x) then
    
      --  alpha values is sign-extend the lowest bit into the bottom
      -- two bits, so full brightness is  $3FF/$400 = 99.9%,

      alpha_strm_drive <= unsigned("0"&alpha_strm);
      oneminusalpha <= (1024-to_integer(unsigned(alpha_strm)));
    
--Input ch 1 R
      r0 <= to_integer(unsigned(r_strm0)) * to_integer(alpha_strm_drive);
      r1 <= to_integer(unsigned(r_strm1)) * oneminusalpha;
      r0drive <= r0;
      r1drive <= r1;
      temp := to_unsigned(r0drive+r1drive,20);
      r_blnd <= std_logic_vector(temp(19 downto 10));

--Input ch 2 G
      g0 <= to_integer(unsigned(g_strm0)) * to_integer(alpha_strm_drive);
      g1 <= to_integer(unsigned(g_strm1)) * oneminusalpha;
      g0drive <= g0;
      g1drive <= g1;
      temp := to_unsigned(g0drive+g1drive,20);
      g_blnd <= std_logic_vector(temp(19 downto 10));
      
--Input ch 3 B    
      b0 <= to_integer(unsigned(b_strm0)) * to_integer(alpha_strm_drive);
      b1 <= to_integer(unsigned(b_strm1)) * oneminusalpha;
      b0drive <= b0;
      b1drive <= b1;
      temp := to_unsigned(b0drive+b1drive,20);
      b_blnd <= std_logic_vector(temp(19 downto 10));
      
      
    end if;
    end process;
end Behavioral;
