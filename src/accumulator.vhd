library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
  generic(
    dim : natural := 32
  );
  port (
    clock, reset, acc_init, acc_en: in std_logic;
    d: in signed(dim - 1 downto 0);
    q: out signed(dim - 1 downto 0)
  );
end accumulator;

architecture behavioral of accumulator is
begin
  accumulator_msf : process( clock, reset) is 
  begin
    if reset = '0' then
      q <= (others => '0');
    elsif rising_edge(clock) then
      if acc_init = '1' then
        q <= (others => '0');
      elsif acc_en = '1' then
        q <= d;
      end if ;     
    end if ;   
  end process ; -- accumulator_msf
end behavioral ; -- behavioral