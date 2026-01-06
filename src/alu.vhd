library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic(
    dim : natural := 32
  );
  port (
    add, subtract, multiply, divide: in std_logic;
    d1, d2: in signed(dim - 1 downto 0);
    q: out signed(dim - 1 downto 0)
  );
end alu;

architecture behavioral of alu is
  signal temp: signed((dim*2-1) downto 0);
begin
  temp <= d1 * d2 when multiply = '1' else
          (others => '0');

  q <=  d1 + d2 when add = '1' else
        d1 - d2 when subtract = '1' else
        d1 / d2 when divide = '1' else
        temp(dim-1 downto 0);
end behavioral ; -- behavioral