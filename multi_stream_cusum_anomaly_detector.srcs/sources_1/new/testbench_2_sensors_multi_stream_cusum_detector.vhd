library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_lOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_2_sensors_multi_stream_cusum_detector is
end testbench_2_sensors_multi_stream_cusum_detector;

architecture tb of testbench_2_sensors_multi_stream_cusum_detector is

component multi_stream_cusum_detector is
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
           timestamp_valid : out STD_LOGIC);
end component;

constant T : time := 20 ns;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal nrst, prev_nrst : STD_LOGIC := '1';

-- data signals
signal Tt, Tt_1 : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal th, drift, timestamp : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal abnormal : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');

-- ready signals
signal Tt_ready, Tt_1_ready, th_ready, drift_ready, timestamp_ready, abnormal_ready : STD_LOGIC;

-- valid signals
signal Tt_valid, Tt_1_valid, th_valid, drift_valid, timestamp_valid, abnormal_valid : STD_LOGIC;


signal rd_count_s1, wr_count_s1 : integer := 0;
signal rd_count_s2, wr_count_s2 : integer := 0;
signal end_of_reading_s1, end_of_reading_s2 : std_logic := '0';
signal rd_index, wr_index : std_logic := '0';

type measurements_type is array (0 to 5000) of std_logic_vector (63 downto 0);
signal measurements_s1, measurements_s2 : measurements_type := (others => (others => '0'));
signal total_rd_count : integer := 0;


begin

    clk <= not clk after T / 2;
    nrst <= '0', '1' after 5 * T;
    
    DUT : multi_stream_cusum_detector port map (
        clk => clk,
        rst => nrst,
        current_sensor_in_data => Tt,
        current_sensor_in_ready => Tt_ready,
        current_sensor_in_valid => Tt_valid,
        previous_sensor_in_data => Tt_1,
        previous_sensor_in_ready => Tt_1_ready,
        previous_sensor_in_valid => Tt_1_valid,
        drift_data => "00111111000000000000000000000000", -- 0.5
        drift_ready => drift_ready,
        drift_valid => '1',
        threshold_data => "01000000000000000000000000000000", -- 2.0
        threshold_ready => th_ready,
        threshold_valid => '1',
        abnormal_data => abnormal,
        abnormal_ready => abnormal_ready,
        abnormal_valid => abnormal_valid,
        timestamp_data => timestamp,
        timestamp_ready => timestamp_ready,
        timestamp_valid => timestamp_valid
    );
    
    abnormal_ready <= '1';
    timestamp_ready <= '1';
    
    process (clk)
        file sensors_data_s1 : text open read_mode is "04-12-22_measurements_bin_short_s1.csv";
        file sensors_data_s2 : text open read_mode is "04-12-22_measurements_bin_short_s2.csv";
        variable in_line : line;
        
        
        variable current_timestamp : string(1 to 16);
        variable t_ds18b20 : std_logic_vector(31 downto 0);
        variable t_dht11 : std_logic_vector(31 downto 0);
        variable t_lm35dz : std_logic_vector(31 downto 0);
        variable t_bmp180 : std_logic_vector(31 downto 0);
        variable t_thermistor : std_logic_vector(31 downto 0);
        variable t_dht22 : std_logic_vector(31 downto 0);
        variable space : character;
        variable comma : character;
        variable s1t, s1t_1, s2t, s2t_1 : std_logic_vector(63 downto 0) := (others => '0');
        
        function to_string(lvec: in std_logic_vector) return string is
            variable text: string(lvec'length-1 downto 0) := (others => '9');
        begin
            for k in lvec'range loop
                case lvec(k) is
                    when '0' => text(k) := '0';
                    when '1' => text(k) := '1';
                    when 'U' => text(k) := 'U';
                    when 'X' => text(k) := 'X';
                    when 'Z' => text(k) := 'Z';
                    when '-' => text(k) := '-';
                    when others => text(k) := '?';
                end case;
            end loop;
            
            return text;
        end function;
    
    begin
        if rising_edge(clk) then
            if rd_index = '0' then
                -- s1
                if nrst = '1' and end_of_reading_s1 = '0' then
                    if not endfile(sensors_data_s1) then     
                        
                        if Tt_ready = '1' and Tt_1_ready = '1' then
                            readline(sensors_data_s1, in_line);
                            read(in_line, current_timestamp);
                        
                            --Tt_1 <= Tt;
                            s1t_1 := s1t;
                            
                            Tt_valid <= '1';
                            Tt_1_valid <= '1';
                            th_valid <= '1';
                            drift_valid <= '1';
                            
                            read(in_line, comma);
                            read(in_line, t_ds18b20);
                            
                            s1t := "00000000000000000000000000000000" & t_ds18b20;
                            
                            Tt <= s1t;
                            Tt_1 <= s1t_1;
                            
                            measurements_s1(rd_count_s1) <= s1t;
                            rd_count_s1 <= rd_count_s1 + 1;
                            
                            report "t = " & current_timestamp;
                            report "T(t - 1) = " & to_string(Tt_1);
                            report "T(t) = " & to_string(Tt);
                            
                            rd_index <= not rd_index;
                            total_rd_count <= total_rd_count + 1;
                        else
                            Tt_valid <= '0';
                            Tt_1_valid <= '0';
                        end if;
                    else
                        file_close(sensors_data_s1);
                        end_of_reading_s1 <= '1';
                        rd_index <= not rd_index;
                    end if;
                
                end if;
            else    
                -- s2
               if nrst = '1' and end_of_reading_s2 = '0' then
                     if not endfile(sensors_data_s2) then     
                         
                         if Tt_ready = '1' and Tt_1_ready = '1' then
                             readline(sensors_data_s2, in_line);
                             read(in_line, current_timestamp);
                         
                             --Tt_1 <= Tt;
                             s2t_1 := s2t;
                             
                             Tt_valid <= '1';
                             Tt_1_valid <= '1';
                             th_valid <= '1';
                             drift_valid <= '1';
                             
                             read(in_line, comma);
                             read(in_line, t_ds18b20);
                             
                             s2t := "00000000000000000000000000000001" & t_ds18b20;
                             
                             Tt <= s2t;
                             Tt_1 <= s2t_1;
                             
                             measurements_s2(rd_count_s2) <= s2t;
                             rd_count_s2 <= rd_count_s2 + 1;
                             
                             report "t = " & current_timestamp;
                             report "T(t - 1) = " & to_string(Tt_1);
                             report "T(t) = " & to_string(Tt);
                             
                             rd_index <= not rd_index;
                             total_rd_count <= total_rd_count + 1;
                         else
                             Tt_valid <= '0';
                             Tt_1_valid <= '0';
                         end if;
                     else
                         file_close(sensors_data_s2);
                         end_of_reading_s2 <= '1';
                         rd_index <= not rd_index;
                     end if;
                 
                 end if;
            end if;
            
            prev_nrst <= nrst;
            
        end if;
        
        
    
    end process;
    
    process 
        file results_s1 : text open write_mode is "C:\IVA\Research\multi_stream_cusum_anomaly_detector\04-12-22_results_bin_short_s1.csv";
        file results_s2 : text open write_mode is "C:\IVA\Research\multi_stream_cusum_anomaly_detector\04-12-22_results_bin_short_s2.csv";
        variable out_line : line;
    begin
        wait until rising_edge(clk);
            
        if nrst = '0' then
            wait until rising_edge(nrst);
        end if;
    
        if wr_index = '0' then
            -- s1
            if wr_count_s1 <= rd_count_s1 then
                if abnormal_valid = '1' then
                    write(out_line, to_integer(signed(timestamp)));
                    write(out_line, string'(", "));
                    write(out_line, measurements_s1(wr_count_s1));
                    write(out_line, string'(", "));
                    write(out_line, abnormal);
                    writeline(results_s1, out_line);
                    
                    if abnormal(0) = '1' then
                        report "abnormal ";
                    end if;
                    
                    wr_count_s1 <= wr_count_s1 + 1;
                    wr_index <= not wr_index;
                end if;
            else
                file_close(results_s1);
                report "execution finished for s1";
                wr_index <= not wr_index;
                wait;
            end if;
        else
            -- s2
            if wr_count_s2 <= rd_count_s2 then
                if abnormal_valid = '1' then
                    write(out_line, to_integer(signed(timestamp)));
                    write(out_line, string'(", "));
                    write(out_line, measurements_s2(wr_count_s2));
                    write(out_line, string'(", "));
                    write(out_line, abnormal);
                    writeline(results_s2, out_line);
                    
                    if abnormal(0) = '1' then
                        report "abnormal ";
                    end if;
                    
                    wr_count_s2 <= wr_count_s2 + 1;
                    wr_index <= not wr_index;
                end if;
            else
                file_close(results_s2);
                report "execution finished for s2";
                wr_index <= not wr_index;
                wait;
            end if;
        end if;
        
    end process;

end tb;
