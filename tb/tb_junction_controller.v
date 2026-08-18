module tb_junction_controller();
reg clk,reset,ped_request;
wire NS_red,NS_yellow,NS_green,EW_red,EW_yellow,EW_green,ped_allow;
junction_controller #(.COUNTER_WIDTH(8),.GREEN_TIME(5),.YELLOW_TIME(2),.RED_TIME(1),.PED_TIME(1)) 
dut(.clk(clk),.reset(reset),.ped_request(ped_request),.NS_green(NS_green),.NS_yellow(NS_yellow),.NS_red(NS_red),
.EW_green(EW_green),.EW_yellow(EW_yellow),.EW_red(EW_red),.ped_allow(ped_allow));
always #5 clk=~clk;
initial begin
  clk=0;
  #20 reset=1;
  #10 reset=0;
  #10 ped_request=0;
  #20 reset=0;
  #40 ped_request=1;
  #10 ped_request=0;
 #400 $finish;
end
endmodule
