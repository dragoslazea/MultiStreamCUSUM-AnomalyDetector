library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity basys3_multi_stream_cusum is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end basys3_multi_stream_cusum;

architecture Structural of basys3_multi_stream_cusum is

component rom256x64 is
    Port ( address : in STD_LOGIC_VECTOR (63 downto 0);
           data_out_previous : out STD_LOGIC_VECTOR (63 downto 0);
           data_out_current : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component multi_stream_cusum_detector is
    Generic (
           NUM_SENSORS : integer := 2
    );
    Port ( 
           -- control inputs
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           -- data inputs
           current_sensor_in_data : in STD_LOGIC_VECTOR (63 downto 0);
           current_sensor_in_ready : out STD_LOGIC;
           current_sensor_in_valid : in STD_LOGIC;
           
           previous_sensor_in_data : in STD_LOGIC_VECTOR (63 downto 0);
           previous_sensor_in_ready : out STD_LOGIC;
           previous_sensor_in_valid : in STD_LOGIC;
           
           threshold_data : in STD_LOGIC_VECTOR (31 downto 0);
           threshold_ready : out STD_LOGIC;
           threshold_valid : in STD_LOGIC;
           
           drift_data : in STD_LOGIC_VECTOR (31 downto 0);
           drift_ready : out STD_LOGIC;
           drift_valid : in STD_LOGIC;
           
           -- outputs
           abnormal_data : out STD_LOGIC_VECTOR (32 downto 0);
           abnormal_ready : in STD_LOGIC;
           abnormal_valid : out STD_LOGIC;
           
           timestamp_data : out STD_LOGIC_VECTOR (31 downto 0);
           timestamp_ready : in STD_LOGIC;
           timestamp_valid : out STD_LOGIC
    );
end component;

component display_7seg is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal next_data_en, mpg_en, nrst, next_en : STD_LOGIC := '0';
signal abnormal : STD_LOGIC_VECTOR (32 downto 0) := (others => '0');
signal current_valid, previous_valid, th_valid, drift_valid, abnormal_valid, timestamp_valid : STD_LOGIC;
signal current_ready, previous_ready, abnormal_ready, timestamp_ready, drift_ready, th_ready : STD_LOGIC;
signal timestamp, result_count, anomaly_count : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal measurement_index, current_measurement, previous_measurement : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal to_display : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal is_last_input, is_last_output : STD_LOGIC := '0';

begin

    measurements_memory : rom256x64 port map (address => measurement_index, data_out_previous => previous_measurement, data_out_current => current_measurement);
    
    nrst <= sw(3);
    
    process (clk)
    begin
        if rising_edge(clk) then
            if nrst = '1' then
                if current_ready = '1' and previous_ready = '1' then
                    if current_measurement /= x"0000000000000000" then
                        measurement_index <= measurement_index + 1;
                        current_valid <= '1';
                        previous_valid <= '1';
                        th_valid <= '1';
                        drift_valid <= '1';
                    else
                        is_last_input <= '1';
                        current_valid <= '0';
                        previous_valid <= '0';
                        th_valid <= '0';
                        drift_valid <= '0';
                    end if;
                else
                    current_valid <= '0';
                    previous_valid <= '0';
                end if;
                
                if measurement_index /= 0 and result_count < measurement_index then
                    if abnormal_valid = '1' then
                        result_count <= result_count + 1;
                       
                        if abnormal(0) = '1' then
                            anomaly_count <= anomaly_count + 1;
                        end if;
                    end if;
                else
                    is_last_output <= '1';
                end if;
            else
                measurement_index <= (others => '0');
                anomaly_count <= (others => '0');
                result_count <= (others => '0');
                is_last_input <= '0';
                is_last_output <= '0';
            end if;
        end if;
    end process;
    
    multi_stream_cusum_anomaly_detector : multi_stream_cusum_detector port map (
        clk => clk,
        rst => nrst,
        current_sensor_in_data => current_measurement,
        current_sensor_in_ready => current_ready,
        current_sensor_in_valid => current_valid,
        previous_sensor_in_data => previous_measurement,
        previous_sensor_in_ready => previous_ready,
        previous_sensor_in_valid => previous_valid,
        drift_data => "00111111000000000000000000000000", -- 0.5
        drift_ready => drift_ready,
        drift_valid => '1',
        threshold_data => "01000000000000000000000000000000", -- 2.0
        threshold_ready => th_ready,
        threshold_valid => '1',
        abnormal_data => abnormal,
        abnormal_ready => '1',
        abnormal_valid => abnormal_valid,
        timestamp_data => timestamp,
        timestamp_ready => '1',
        timestamp_valid => timestamp_valid
    ); 
    
    led(0) <= previous_ready;
    led(1) <= current_ready;
    led(2) <= drift_ready;
    led(3) <= th_ready;
    led(4) <= abnormal(0);
    led(5) <= abnormal_valid;
    led(6) <= timestamp_valid;
    led(7) <= current_valid;
    led(8) <= previous_valid;
    led(9) <= nrst;
    led(10) <= is_last_input;
    led(11) <= is_last_output;
    
    to_display <= current_measurement (15 downto 0) when sw(2 downto 0) = "000" else
                  current_measurement (31 downto 16) when sw(2 downto 0) = "001" else
                  previous_measurement (15 downto 0) when sw(2 downto 0) = "010" else
                  previous_measurement (31 downto 16) when sw(2 downto 0) = "011" else
                  anomaly_count (15 downto 0) when sw(2 downto 0) = "100" else
                  anomaly_count (31 downto 16) when sw(2 downto 0) = "101" else
                  measurement_index(15 downto 0) when sw(2 downto 0) = "110" else
                  measurement_index(31 downto 16);
    
    displ_7seg : display_7seg port map (digit0 => to_display (3 downto 0), digit1 => to_display (7 downto 4), digit2 => to_display (11 downto 8), digit3 => to_display (15 downto 12), clk => clk, cat => cat, an => an);

end Structural;
