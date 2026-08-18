//Module Interface
module generic_timer #(parameter COUNTER_WIDTH=8)
(
  input wire clk,
  input wire reset,
  input wire start,
  input wire [COUNTER_WIDTH-1:0] count_target,
  output reg done
);
//Counter register and logic
  reg counting;
  reg [COUNTER_WIDTH-1:0] counter;
  always@(posedge clk or posedge reset)
  begin
    if(reset)
    begin
      counting<=0;counter<=0;done<=0;
    end
    else if(start && !counting)
    begin
      counting<=1;counter<=0;done<=0;
    end
    else if(counting)
    begin
      if(counter<count_target)
      begin
        counter<=counter+1;
        done<=0;
      end
      else
      begin
        counting<=0;done<=1;counter<=0;
      end
    end
     else 
      begin
        done<=0;
      end
  end

endmodule