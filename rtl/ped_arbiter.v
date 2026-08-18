//Module Interface
module ped_arbiter(
  input wire clk,
  input wire reset,

  input wire ped_pending_A,
  input wire ped_pending_B,

  input wire ped_done_A,
  input wire ped_done_B,

  output reg ped_grant_A,
  output reg ped_grant_B
);
//Internal Register
reg last_grant; // Round Robin Policy

//Arbitration logic
always@(posedge clk or posedge reset)
begin
  if(reset)
    begin
    last_grant<=0;
    ped_grant_A<=0;
    ped_grant_B<=0;
    end
    else if(ped_done_A || ped_done_B)
      begin
      ped_grant_A <= 0;
      ped_grant_B <= 0;
      end
    else if(ped_grant_A || ped_grant_B)
      begin
        // Hold the current grant
      ped_grant_A <= ped_grant_A;
      ped_grant_B <= ped_grant_B;
      end
    else 
    begin
    case({ped_pending_A,ped_pending_B})
      2'b00: begin
        //No request
      end
      2'b01: begin
        ped_grant_B<=1;
        last_grant<=1;
      end
      2'b10: begin
        ped_grant_A<=1;
        last_grant<=0;
      end
      2'b11: begin
        if(last_grant==0)             //last_grant=0 means A was last served
        begin
          ped_grant_B<=1;
          last_grant<=1;
        end
        else
        begin
          ped_grant_A<=1;
          last_grant<=0;
        end
      end
      default:begin
      ped_grant_A<=0;
      ped_grant_B<=0;
      end
    endcase
    end  
  end
endmodule

// Round-robin arbitration.
// last_grant remembers which junction was served last.
// If both requests are pending, grant the opposite junction next
// to guarantee fairness and prevent starvation.