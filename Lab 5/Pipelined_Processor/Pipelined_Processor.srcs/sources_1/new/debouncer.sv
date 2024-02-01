`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2023 07:25:21 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(input logic clk, reset, sin,
    output logic sout);

    typedef enum logic [1:0] {S0, S1, S2} statetype;
    statetype [1:0] state, nextstate;
    
    //State register
    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= nextstate;
    end
    
    //Next state logic
    always_comb
        case (state)
            S0: if (sin) nextstate <= S1;
                else nextstate <= S0; 
            S1: if (sin) nextstate <= S2;
                else nextstate <= S0;
            S2: if (sin) nextstate <= S2;
                else nextstate <= S0;
            default: nextstate <= S0;
        endcase
    
    //Output logic
    assign sout = (state == S1);
endmodule