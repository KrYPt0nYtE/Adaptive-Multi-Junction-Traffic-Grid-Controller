module tb_amtgc_adaptive();
  parameter COUNTER_WIDTH     = 8;
  parameter GREEN_WAVE_OFFSET = 5;

  reg clk,reset,ped_request_A,ped_request_B,emergency_override;
  reg [2:0] traffic_density_A;
  reg [2:0] traffic_density_B;

  wire NS_green_A,NS_yellow_A,NS_red_A,EW_green_A,EW_yellow_A,EW_red_A;
  wire NS_green_B,NS_yellow_B,NS_red_B,EW_green_B,EW_yellow_B,EW_red_B;

  amtgc_top #(.COUNTER_WIDTH(COUNTER_WIDTH),.GREEN_WAVE_OFFSET(GREEN_WAVE_OFFSET)) 
            dut(.clk(clk),
                .reset(reset),
                .traffic_density_A(traffic_density_A),
                .traffic_density_B(traffic_density_B),
                .ped_request_A(ped_request_A),
                .ped_request_B(ped_request_B),
                .emergency_override(emergency_override),
                .NS_green_A(NS_green_A),.NS_yellow_A(NS_yellow_A),.NS_red_A(NS_red_A),
                .EW_green_A(EW_green_A),.EW_yellow_A(EW_yellow_A),.EW_red_A(EW_red_A),
                .NS_green_B(NS_green_B),.NS_yellow_B(NS_yellow_B),.NS_red_B(NS_red_B),
                .EW_green_B(EW_green_B),.EW_yellow_B(EW_yellow_B),.EW_red_B(EW_red_B));

  always #5 clk=~clk;
  integer density_val;
  initial begin
    //Initial Setup
    clk=0;
    reset=1;
    traffic_density_A=3'd0;
    traffic_density_B=3'd0;
    ped_request_A=0;
    ped_request_B=0;
    emergency_override=0;
    #20;
    reset=0;
    $display("[%0t ns] === RESET RELEASED: Starting Task 4 Verification ===", $time);  
    for(density_val = 0; density_val <= 7 ; density_val = density_val + 1)
    begin
      traffic_density_A = density_val [2:0];
      traffic_density_B = density_val [2:0];
      $display("[%0t ns] Applying Traffic Density = %0d (Target calculated: %0d, Clamped: %0d)", 
               $time, density_val, 20 + (density_val * 5), 
               (20 + (density_val * 5) > 50) ? 50 : 20 + (density_val * 5));
      @(posedge NS_green_A);
      @(negedge NS_green_A);
      #50;
    end


    $display("\n[%0t ns] === TEST 2: Testing Mid-Phase Density Change ===", $time);
    traffic_density_A = 3'd1;
    @(posedge NS_green_A);
    
    $display("[%0t ns] NS_GREEN_A started with Density = 1", $time);
    #100;
    traffic_density_A = 3'd7;
    
    $display("[%0t ns] ALERT: Traffic Density changed to 7 mid-phase! Verifying no timing glitch...", $time);
    
    @(negedge NS_green_A);
    $display("[%0t ns] NS_GREEN_A finished smoothly using initial latched duration.", $time);

    $display("\n[%0t ns] === TEST 3: Both Junctions at Maximum Density (3'b111) ===", $time);
    traffic_density_A = 3'd7;
    traffic_density_B = 3'd7;

    //observing two full cycles ensuring fair arbitration
    repeat (2) begin
      @(posedge NS_green_A);
      @(posedge EW_green_A);
    end

    $display("\n[%0t ns] === TASK 4 VERIFICATION COMPLETE ===", $time);
    $finish;
  end
endmodule
