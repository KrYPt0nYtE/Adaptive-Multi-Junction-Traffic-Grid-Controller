add wave -divider "GLOBAL"
add wave -radix binary /tb_amtgc_top/clk
add wave -radix binary /tb_amtgc_top/reset
add wave -radix binary /tb_amtgc_top/emergency_override

add wave -divider "JUNCTION A SIGNALS"
add wave -radix unsigned /tb_amtgc_top/traffic_density_A
add wave -radix binary   /tb_amtgc_top/ped_request_A
add wave -radix unsigned /tb_amtgc_top/dut/A/current_state
add wave -radix binary   /tb_amtgc_top/NS_green_A
add wave -radix binary   /tb_amtgc_top/NS_yellow_A
add wave -radix binary   /tb_amtgc_top/NS_red_A
add wave -radix binary   /tb_amtgc_top/EW_green_A
add wave -radix binary   /tb_amtgc_top/EW_yellow_A
add wave -radix binary   /tb_amtgc_top/EW_red_A

add wave -divider "JUNCTION B SIGNALS"
add wave -radix unsigned /tb_amtgc_top/traffic_density_B
add wave -radix binary   /tb_amtgc_top/ped_request_B
add wave -radix unsigned /tb_amtgc_top/dut/B/current_state
add wave -radix binary   /tb_amtgc_top/NS_green_B
add wave -radix binary   /tb_amtgc_top/NS_yellow_B
add wave -radix binary   /tb_amtgc_top/NS_red_B
add wave -radix binary   /tb_amtgc_top/EW_green_B
add wave -radix binary   /tb_amtgc_top/EW_yellow_B
add wave -radix binary   /tb_amtgc_top/EW_red_B

add wave -divider "ARBITRATION"
add wave -radix binary /tb_amtgc_top/dut/ped_grant_A
add wave -radix binary /tb_amtgc_top/dut/ped_grant_B
