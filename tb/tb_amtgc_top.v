`timescale 1ns/1ps

module tb_amtgc_top();

  parameter COUNTER_WIDTH      = 8;
  parameter GREEN_WAVE_OFFSET  = 5;

  reg clk, reset, ped_request_A, ped_request_B, emergency_override;

  wire NS_green_A, NS_yellow_A, NS_red_A, EW_green_A, EW_yellow_A, EW_red_A;
  wire NS_green_B, NS_yellow_B, NS_red_B, EW_green_B, EW_yellow_B, EW_red_B;

  // Instantiate Top Level Module
  amtgc_top #(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .GREEN_WAVE_OFFSET(GREEN_WAVE_OFFSET)
  ) dut (
    .clk(clk),
    .reset(reset),
    .ped_request_A(ped_request_A),
    .ped_request_B(ped_request_B),
    .emergency_override(emergency_override),
    .NS_green_A(NS_green_A), .NS_yellow_A(NS_yellow_A), .NS_red_A(NS_red_A),
    .EW_green_A(EW_green_A), .EW_yellow_A(EW_yellow_A), .EW_red_A(EW_red_A),
    .NS_green_B(NS_green_B), .NS_yellow_B(NS_yellow_B), .NS_red_B(NS_red_B),
    .EW_green_B(EW_green_B), .EW_yellow_B(EW_yellow_B), .EW_red_B(EW_red_B)
  );

  // Clock Generation (10ns period)
  always #5 clk = ~clk;

  // -------------------------------------------------------------------
  // Console Transcript Monitoring for ModelSim
  // -------------------------------------------------------------------
  initial begin
    $display("====================================================================================================");
    $display("                                  AMTGC SYSTEM SIMULATION TRANSCRIPT                                ");
    $display("====================================================================================================");
    $display(" Time(ns) | Reset | Override | PedReq (A/B) | State A/B | Light A (NS/EW) | Light B (NS/EW) | Ped Grant (A/B)");
    $display("----------------------------------------------------------------------------------------------------");
    
    $monitor("%8t |   %b   |    %b     |    %b / %b   |  %2d / %2d  |  G:%b Y:%b R:%b / G:%b Y:%b R:%b | G:%b Y:%b R:%b / G:%b Y:%b R:%b |    %b / %b",
      $time, reset, emergency_override, ped_request_A, ped_request_B,
      dut.A.current_state, dut.B.current_state,
      NS_green_A, NS_yellow_A, NS_red_A, EW_green_A, EW_yellow_A, EW_red_A,
      NS_green_B, NS_yellow_B, NS_red_B, EW_green_B, EW_yellow_B, EW_red_B,
      dut.ped_grant_A, dut.ped_grant_B
    );
  end

  // -------------------------------------------------------------------
  // Main Test Stimulus
  // -------------------------------------------------------------------
  initial begin
    // 1. System Initialization
    clk                = 0;
    reset              = 1;
    ped_request_A      = 0;
    ped_request_B      = 0;
    emergency_override = 0;

    #20;
    reset = 0;
    $display("\n[%0t ns] *** SYSTEM RESET DEASSERTED ***\n", $time);
    #100;

    // 2. Simultaneous Pedestrian Requests (Round-Robin Verification)
    $display("\n[%0t ns] *** TEST 1: Simultaneous Pedestrian Requests (Round 1) ***", $time);
    ped_request_A = 1;
    ped_request_B = 1;
    #20;
    ped_request_A = 0;
    ped_request_B = 0;

    // Wait until both complete
    #300;

    $display("\n[%0t ns] *** TEST 1: Simultaneous Pedestrian Requests (Round 2) ***", $time);
    ped_request_A = 1;
    ped_request_B = 1;
    #20;
    ped_request_A = 0;
    ped_request_B = 0;

    #300;

    // 3. Emergency Override Assertion during Active Pedestrian Phase
    $display("\n[%0t ns] *** TEST 2: Requesting Pedestrian Access for Junction A ***", $time);
    ped_request_A = 1;
    #20;
    ped_request_A = 0;

    // Wait until Junction A reaches PED_ALLOW state (4'd6)
    wait (dut.A.current_state == 4'd6);
    $display("\n[%0t ns] *** CRITICAL TEST: Triggering Emergency Override inside PED_ALLOW ***", $time);
    #10;
    emergency_override = 1;

    #100;

    // 4. Emergency Deassertion & Safe Recovery
    $display("\n[%0t ns] *** TEST 3: Deasserting Emergency Override (Checking Safe Recovery) ***", $time);
    emergency_override = 0;

    #200;

    $display("\n====================================================================================================");
    $display("                                   SIMULATION COMPLETE SUCCESSFULLY                                  ");
    $display("====================================================================================================\n");
    $finish;
  end

endmodule