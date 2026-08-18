// Module Interface
module junction_controller #(
  parameter COUNTER_WIDTH = 8,
  parameter GREEN_TIME    = 30,
  parameter MAX_GREEN     = 50,
  parameter MIN_GREEN     = 10,       
  parameter EXT_GREEN      = 5,       //Green wave extension
  parameter YELLOW_TIME   = 5,
  parameter RED_TIME      = 2,
  parameter PED_TIME      = 10 
)(
  input wire clk, reset, ped_request, ped_grant, emergency_override,
  input wire [2:0] traffic_density,   //3-bit traffic density
  output reg NS_green, NS_yellow, NS_red, EW_green, EW_yellow, EW_red, ped_allow, ped_done,
  output reg ped_pending
);

// State Encoding
localparam NS_GREEN   = 4'd0,
           NS_YELLOW  = 4'd1,
           ALL_RED1   = 4'd2,
           EW_GREEN   = 4'd3,
           EW_YELLOW  = 4'd4,
           ALL_RED2   = 4'd5,
           PED_ALLOW  = 4'd6,
           EMERGENCY  = 4'd7;

reg [3:0] current_state, next_state;
reg timer_start;
wire timer_done;
reg [COUNTER_WIDTH-1:0] timer_value;
reg [COUNTER_WIDTH-1:0] green_time_dynamic;

//Traffic Density Calculation
wire [COUNTER_WIDTH-1:0] raw_green_time = GREEN_TIME + (traffic_density * EXT_GREEN);    // Raw Green Time for basic calculation of Green Time
wire [COUNTER_WIDTH-1:0] clamped_green_time = (raw_green_time > MAX_GREEN) ? MAX_GREEN :  
                                              (raw_green_time < MIN_GREEN) ? MIN_GREEN :
                                              raw_green_time;                           /* Clamped Green Time for prevention of Starvation 
                                                                                          and having safety bounds*/

// Timer Instance
generic_timer #(.COUNTER_WIDTH(COUNTER_WIDTH)) timer (
  .clk(clk),
  .reset(reset || emergency_override), // Reset timer during emergency
  .start(timer_start),
  .count_target(timer_value),
  .done(timer_done)
);

// Current State Register Logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    current_state      <= NS_GREEN;
    green_time_dynamic <= GREEN_TIME;
  end else if (emergency_override) begin
    current_state <= EMERGENCY;
  end else begin
    current_state <= next_state;
    if ((current_state == ALL_RED2)||
        (current_state == ALL_RED1)) begin
      green_time_dynamic <= clamped_green_time;
    end 
  end
end

// Next State Logic
always @(*) begin
  next_state = current_state;
  case (current_state)
    NS_GREEN:  if (timer_done) next_state = NS_YELLOW;
    NS_YELLOW: if (timer_done) next_state = ALL_RED1;
    ALL_RED1:  if (timer_done) next_state = EW_GREEN;
    EW_GREEN:  if (timer_done) next_state = EW_YELLOW;
    EW_YELLOW: if (timer_done) next_state = ALL_RED2;
    ALL_RED2:  begin
      if (timer_done) begin
        if (ped_pending && ped_grant)
          next_state = PED_ALLOW;
        else
          next_state = NS_GREEN;
      end
    end
    PED_ALLOW: if (timer_done) next_state = NS_GREEN;
    EMERGENCY: begin
      if (!emergency_override) begin
        next_state = ALL_RED1; // Safe recovery: pass through ALL_RED first
      end else begin
        next_state = EMERGENCY;
      end
    end
    default: next_state = NS_GREEN;
  endcase
end

// Output & Timer Trigger Logic
always @(*) begin
  NS_green = 0; NS_yellow = 0; NS_red = 0;
  EW_green = 0; EW_yellow = 0; EW_red = 0;
  ped_allow = 0;
  timer_start = 0;
  timer_value = green_time_dynamic;

  case (current_state)
    NS_GREEN: begin
      NS_green = 1; EW_red = 1;
      timer_start = 1;
      timer_value = green_time_dynamic;
    end
    NS_YELLOW: begin
      NS_yellow = 1; EW_red = 1;
      timer_start = 1;
      timer_value = YELLOW_TIME;
    end
    ALL_RED1: begin
      NS_red = 1; EW_red = 1;
      timer_start = 1;
      timer_value = RED_TIME;
    end
    EW_GREEN: begin
      NS_red = 1; EW_green = 1;
      timer_start = 1;
      timer_value = green_time_dynamic;
    end
    EW_YELLOW: begin
      NS_red = 1; EW_yellow = 1;
      timer_start = 1;
      timer_value = YELLOW_TIME;
    end
    ALL_RED2: begin
      NS_red = 1; EW_red = 1;
      timer_start = 1;
      timer_value = RED_TIME;
    end
    PED_ALLOW: begin
      NS_red = 1; EW_red = 1; ped_allow = 1;
      timer_start = 1;
      timer_value = PED_TIME;
    end
    EMERGENCY: begin
      NS_red = 1; EW_red = 1;
      timer_start = 0;
      timer_value = 0;
    end
    default: begin
      NS_red = 1; EW_red = 1;
      timer_start = 0;
      timer_value = 0;
    end
  endcase
end

// Pedestrian Pending Flag
always @(posedge clk or posedge reset) begin
  if (reset) begin
    ped_pending <= 0;
  end else if (ped_request) begin
    ped_pending <= 1;
  end else if (current_state == PED_ALLOW && timer_done) begin
    ped_pending <= 0;
  end
end

// Pedestrian Done Pulse
always @(posedge clk or posedge reset) begin
  if (reset) begin
    ped_done <= 0;
  end else if (current_state == PED_ALLOW && next_state != PED_ALLOW) begin
    ped_done <= 1;
  end else begin
    ped_done <= 0;
  end
end
endmodule