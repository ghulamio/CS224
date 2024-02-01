`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2023 03:40:24 PM
// Design Name: 
// Module Name: BASYS_Processor
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


module BASYS_Processor(
    input logic clk, reset, step,
    output logic dp, 
    output logic [1:0] led,
    output logic [3:0] an,
    output logic [6:0] seg);
    
    // Wires
    logic debouncedStep;
    logic [31:0] writedata, dataadr, pc, instr, readdata;
    logic [3:0] in3, in2, in1, in0;
    logic memwrite, regwrite;
    
    debouncer d(clk, reset, step, debouncedStep);
    
    MIPS_Processor processor (
        .clk(debouncedStep),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .pc(pc),
        .instr(instr),
        .readdata(readdata),
        .memwrite(memwrite)
    );
    
    assign in3 = pc[7:4];
    assign in2 = pc[3:0];
    assign in1 = dataadr[7:4];
    assign in0 = dataadr[3:0];
    assign led[0] = memwrite;
    
    display_controller dc (clk, in3, in2, in1, in0, seg, dp, an);
        
endmodule
