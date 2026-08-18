//Module Interface
module amtgc_top #(
  parameter COUNTER_WIDTH      = 8,
  parameter GREEN_WAVE_OFFSET = 5
)(
  input wire clk, reset, ped_request_A, ped_request_B, emergency_override,
  input wire [2:0] traffic_density_A,
  input wire [2:0] traffic_density_B,

  output wire NS_green_A, NS_yellow_A, NS_red_A, EW_green_A, EW_yellow_A, EW_red_A,
  output wire NS_green_B, NS_yellow_B, NS_red_B, EW_green_B, EW_yellow_B, EW_red_B
);
//Instantiation and registers
  wire ped_allow_A, ped_allow_B;
  wire ped_grant_A, ped_grant_B;
  wire ped_done_A,  ped_done_B;
  wire ped_pending_A, ped_pending_B;

  // Both modules use standard global reset
  junction_controller #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .GREEN_TIME(30),
    .MAX_GREEN(50),
    .MIN_GREEN(10),
    .EXT_GREEN(5),
    .PED_TIME(10),
    .YELLOW_TIME(5),
    .RED_TIME(2)
  ) A (
    .clk(clk),
    .reset(reset),
    .traffic_density(traffic_density_A),
    .ped_request(ped_request_A),
    .ped_grant(ped_grant_A),
    .ped_pending(ped_pending_A),
    .emergency_override(emergency_override),
    .NS_green(NS_green_A),
    .NS_yellow(NS_yellow_A),
    .NS_red(NS_red_A),
    .EW_green(EW_green_A),
    .EW_yellow(EW_yellow_A),
    .EW_red(EW_red_A),
    .ped_done(ped_done_A),
    .ped_allow(ped_allow_A)
  );

  junction_controller #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .GREEN_TIME(25),
    .MAX_GREEN(45),
    .MIN_GREEN(15),
    .EXT_GREEN(3),
    .PED_TIME(8),
    .YELLOW_TIME(3),
    .RED_TIME(1)
  ) B (
    .clk(clk),
    .reset(reset), // Global reset used cleanly
    .traffic_density(traffic_density_B),
    .ped_request(ped_request_B),
    .ped_grant(ped_grant_B),
    .ped_pending(ped_pending_B),
    .emergency_override(emergency_override),
    .NS_green(NS_green_B),
    .NS_yellow(NS_yellow_B),
    .NS_red(NS_red_B),
    .EW_green(EW_green_B),
    .EW_yellow(EW_yellow_B),
    .EW_red(EW_red_B),
    .ped_done(ped_done_B),
    .ped_allow(ped_allow_B)
  );

  ped_arbiter arbiter (
    .clk(clk),
    .reset(reset),
    .ped_grant_A(ped_grant_A),
    .ped_grant_B(ped_grant_B),
    .ped_done_A(ped_done_A),
    .ped_done_B(ped_done_B),
    .ped_pending_A(ped_pending_A),
    .ped_pending_B(ped_pending_B)
  );

endmodule