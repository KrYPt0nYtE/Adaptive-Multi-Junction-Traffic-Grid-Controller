//Module Interface
module tb_generic_timer();
reg clk,reset,start4,start8,start16;
wire done4,done8,done16;
reg [3:0] count_target4;
reg [7:0] count_target8;
reg [15:0] count_target16;

//Instantiation
generic_timer #(.COUNTER_WIDTH(4)) timer4(.clk(clk),.reset(reset),.start(start4),.count_target(count_target4),.done(done4));
generic_timer #(.COUNTER_WIDTH(8)) timer8(.clk(clk),.reset(reset),.start(start8),.count_target(count_target8),.done(done8));
generic_timer #(.COUNTER_WIDTH(16)) timer16(.clk(clk),.reset(reset),.start(start16),.count_target(count_target16),.done(done16));

always #5 clk=~clk;
initial begin
    clk = 0;
    reset = 1;

    start4 = 0;
    start8 = 0;
    start16 = 0;

    count_target4  = 5;
    count_target8  = 10;
    count_target16 = 30;

    #10 reset = 0;

    #10;
    start4 = 1;
    start8 = 1;
    start16 = 1;

    #10;
    start4 = 0;
    start8 = 0;
    start16 = 0;

    #400;

    $finish;
end
endmodule