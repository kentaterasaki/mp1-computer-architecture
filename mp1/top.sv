// RGB LED Color Cycling Controller
module top(
    input logic     clk,        // 12 MHz clock
    output logic    RGB_R,      // Red LED output (inverted logic)
    output logic    RGB_G,      // Green LED output (inverted logic)  
    output logic    RGB_B       // Blue LED output (inverted logic)
);

// Parameters for timing
parameter CLK_FREQ = 12_000_000;        // 12 MHz
parameter COLOR_DURATION = CLK_FREQ / 6; // 1/6 second per color

// Counter for timing
logic [31:0] counter;
logic [2:0] color_state;

// Color states (6 colors at 60° intervals)
parameter RED     = 3'b000;  // 0°
parameter YELLOW  = 3'b001;  // 60°
parameter GREEN   = 3'b010;  // 120°
parameter CYAN    = 3'b011;  // 180°
parameter BLUE    = 3'b100;  // 240°
parameter MAGENTA = 3'b101;  // 300°

always_ff @(posedge clk) begin
    // Counter counting to COLOR_DURATION
    if (counter >= COLOR_DURATION - 1) begin
        // Reset counter
        counter <= 0;
        // Move to next color logic

        // If last color, go back to red
        if (color_state == MAGENTA)
            color_state <= RED;

        // If any other color, go to the next color degree
        else
            color_state <= color_state + 1;
    end else begin
        counter <= counter + 1;
    end
end

// RGB LED control (inverted logic: 0 = ON, 1 = OFF)
always_comb begin
    case (color_state)
        RED: begin
            RGB_R = 1'b0;  // Red ON
            RGB_G = 1'b1;  // Green OFF
            RGB_B = 1'b1;  // Blue OFF
        end
        YELLOW: begin
            RGB_R = 1'b0;  // Red ON
            RGB_G = 1'b0;  // Green ON
            RGB_B = 1'b1;  // Blue OFF
        end
        GREEN: begin
            RGB_R = 1'b1;  // Red OFF
            RGB_G = 1'b0;  // Green ON
            RGB_B = 1'b1;  // Blue OFF
        end
        CYAN: begin
            RGB_R = 1'b1;  // Red OFF
            RGB_G = 1'b0;  // Green ON
            RGB_B = 1'b0;  // Blue ON
        end
        BLUE: begin
            RGB_R = 1'b1;  // Red OFF
            RGB_G = 1'b1;  // Green OFF
            RGB_B = 1'b0;  // Blue ON
        end
        MAGENTA: begin
            RGB_R = 1'b0;  // Red ON
            RGB_G = 1'b1;  // Green OFF
            RGB_B = 1'b0;  // Blue ON
        end
        default: begin
            RGB_R = 1'b1;  // All OFF
            RGB_G = 1'b1;
            RGB_B = 1'b1;
        end
    endcase
end

endmodule
