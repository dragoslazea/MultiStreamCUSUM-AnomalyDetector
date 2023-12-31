library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_multi_stream_threshold_exceeding_detector is
end testbench_multi_stream_threshold_exceeding_detector;

architecture Tb of testbench_multi_stream_threshold_exceeding_detector is

component multi_stream_threshold_exceeding_detector is
    Port ( aclk : in STD_LOGIC;
       arstn : in STD_LOGIC;
       gp_in_valid : in STD_LOGIC;
       gp_in_ready : out STD_LOGIC;
       gp_in_data : in STD_LOGIC_VECTOR (63 downto 0);
       gn_in_valid : in STD_LOGIC;
       gn_in_ready : out STD_LOGIC;
       gn_in_data : in STD_LOGIC_VECTOR (63 downto 0);
       th_valid : in STD_LOGIC;
       th_ready : out STD_LOGIC;
       th_data : in STD_LOGIC_VECTOR (31 downto 0);
       abnormal_valid : out STD_LOGIC;
       abnormal_ready : in STD_LOGIC;
       abnormal_data : out STD_LOGIC;
       gp_out_valid : out STD_LOGIC;
       gp_out_ready : in STD_LOGIC;
       gp_out_data : out STD_LOGIC_VECTOR (63 downto 0);
       gn_out_valid : out STD_LOGIC;
       gn_out_ready : in STD_LOGIC;
       gn_out_data : out STD_LOGIC_VECTOR (63 downto 0));
end component;

constant T : time := 20 ns;

signal clk, rst : std_logic := '0';
signal a : std_logic_vector(31 downto 0) := x"41400000"; -- 12.0
signal b : std_logic_vector(31 downto 0);

signal gp_in, gn_in, gp_out, gn_out : std_logic_vector(63 downto 0);
signal th : std_logic_vector(31 downto 0);
signal fp_a_ready, fp_a_valid, fp_b_ready, fp_b_valid : std_logic := '0';
signal abnormal_valid, abnormal, gp_out_valid, gn_out_valid : std_logic := '0';

subtype index_type is integer range 0 to 9;
signal i : index_type := 0;

type test_array is array(0 to 9) of std_logic_vector(63 downto 0);
signal test_data : test_array := (
    x"0000000141200000", -- 10.0
    x"0000000141b0cccd", -- 22.1
    x"0000000241300000", -- 11.0
    x"0000000241400000", -- 12.0
    x"0000000341500000", -- 13.0
    x"0000000341600000", -- 14.0
    x"00000003416b3333", -- 14.7
    others => (others => '0')
    
);

begin


    clk <= not clk after T / 2;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if fp_a_ready = '1' and fp_a_valid = '1' and fp_b_ready = '1' then 
                if i >= index_type'high - 1 then
                    i <= index_type'low;
                else
                    i <= i + 2;
                end if;
            end if;
        end if;
    end process;
    
--    fp_a_valid <= '0', '1' after 2 * T, '0' after 4 * T, '1' after 6 * T;
--    fp_b_valid <= '0', '1' after T, '0' after 2 * T, '1' after 3 * T, '0' after 4 * T, '1' after 5 * T, '0' after 6 * T, '1' after 7 * T;

    rst <= '0', '1' after 3 * T;
    fp_a_valid <= '0', '1' after 6 * T, '0' after 10 * T, '1' after 13 * T;
    fp_b_valid <= '0', '1' after 6 * T, '0' after 10 * T, '1' after 13 * T;
    
    gp_in <= test_data(0), test_data(2) after 13 * T;
    gn_in <= test_data(1), test_data(3) after 13 * T;  
    th <= test_data(4)(31 downto 0);  
    
    DUT : multi_stream_threshold_exceeding_detector
        PORT MAP (
            aclk => clk,
            arstn => rst,
            gp_in_valid => fp_a_valid,
            gp_in_ready => fp_a_ready,
            gp_in_data => gp_in,
            gn_in_valid => fp_b_valid,
            gn_in_ready => fp_a_ready,
            gn_in_data => gn_in,
            th_valid => '1',
            th_ready => fp_b_ready,
            th_data => th,
            abnormal_valid => abnormal_valid,
            abnormal_data => abnormal,
            abnormal_ready => '1',
            gp_out_valid => gp_out_valid,
            gp_out_ready => '1',
            gp_out_data => gp_out,
            gn_out_valid => gn_out_valid,
            gn_out_ready => '1',
            gn_out_data => gn_out
        );

end Tb;
