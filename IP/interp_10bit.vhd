----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.08.2021 17:25:32
-- Design Name: 
-- Module Name: interp_10bit - Behavioral
-- Project Name: 
-- Target Devices: Arty Z7
-- Tool Versions: VIVADO 2020.2
-- Description: 10 bit interpolator siongle channel
-- 
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

entity interp_10bit is
  Port (
    clk1x:       in  std_logic; --pixel clock input
      
    -- input 0
    strm0:     in  std_logic_vector(9 downto 0);
    
    -- input 1
    strm1:     in  std_logic_vector(9 downto 0);
    
    alpha_strm:  in  std_logic_vector(9 downto 0); -- alpha mix value as interger
    
    -- output
    blnd:     out std_logic_vector(9 downto 0)
    
   );
end interp_10bit;

architecture Behavioral of interp_10bit is

  --mix registers
  signal r0  : integer := 0;
  signal r1  : integer := 0;
  
  --output registers
  signal r0drive  : integer := 0;
  signal r1drive  : integer := 0;
  
  
  signal alpha_strm_drive: unsigned(10 downto 0); -- variable for our alpha coefishent with the value 0.0-1.0
  signal oneminusalpha : integer; -- variable for the 1-alpha

begin

process (clk1x) is 
        variable temp : unsigned(19 downto 0);
    begin
    if rising_edge(clk1x) then
    

      alpha_strm_drive <= unsigned("0"&alpha_strm);
      oneminusalpha <= (1024-to_integer(unsigned(alpha_strm)));
    
    
      r0 <= to_integer(unsigned(strm0)) * to_integer(alpha_strm_drive);
      r1 <= to_integer(unsigned(strm1)) * oneminusalpha;
      r0drive <= r0;
      r1drive <= r1;
      temp := to_unsigned(r0drive+r1drive,20);
      blnd <= std_logic_vector(temp(19 downto 10));

      
      
    end if;
    end process;

end Behavioral;
