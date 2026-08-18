# 1. Create working library
vlib work

# 2. Compile RTL files and Testbench
vlog ../../rtl/ *.v
vlog ../../tb/tb_amtgc_final_verification.v

# 3. Load simulation with full signal visibility
vsim -voptargs="+acc" work.tb_amtgc_final_verification

# 4. Add waveform signals
add wave -divider "GLOBAL SIGNALS"
add wave /tb_amtgc_final_verification/clk
add wave /tb_amtgc_final_verification/reset
add wave /tb_amtgc_final_verification/emergency_override

add wave -divider "JUNCTION A"
add wave /tb_amtgc_final_verification/traffic_density_A
add wave /tb_amtgc_final_verification/ped_request_A
add wave /tb_amtgc_final_verification/dut/A/current_state
add wave /tb_amtgc_final_verification/NS_green_A
add wave /tb_amtgc_final_verification/NS_yellow_A
add wave /tb_amtgc_final_verification/NS_red_A
add wave /tb_amtgc_final_verification/EW_green_A
add wave /tb_amtgc_final_verification/EW_yellow_A
add wave /tb_amtgc_final_verification/EW_red_A
add wave /tb_amtgc_final_verification/dut/A/ped_allow

add wave -divider "JUNCTION B"
add wave /tb_amtgc_final_verification/traffic_density_B
add wave /tb_amtgc_final_verification/ped_request_B
add wave /tb_amtgc_final_verification/dut/B/current_state
add wave /tb_amtgc_final_verification/NS_green_B
add wave /tb_amtgc_final_verification/NS_yellow_B
add wave /tb_amtgc_final_verification/NS_red_B
add wave /tb_amtgc_final_verification/EW_green_B
add wave /tb_amtgc_final_verification/EW_yellow_B
add wave /tb_amtgc_final_verification/EW_red_B
add wave /tb_amtgc_final_verification/dut/B/ped_allow

add wave -divider "SCOREBOARD"
add wave /tb_amtgc_final_verification/assertions_checked
add wave /tb_amtgc_final_verification/error_count

# 5. Run simulation
run -all
