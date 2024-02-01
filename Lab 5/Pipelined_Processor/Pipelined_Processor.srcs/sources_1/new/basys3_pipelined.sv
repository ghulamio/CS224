`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2023 07:03:05 PM
// Design Name: 
// Module Name: basys3_pipelined
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


module basys3_pipelined(
    input logic clk, reset, step,
    output logic dp, 
    output logic [1:0] led,
    output logic [3:0] an,
    output logic [6:0] seg);
    
    // Wires
    logic debouncedStep;
    logic [31:0] writedata, dataadr, pc, instrF, readdata;
    logic [3:0] in3, in2, in1, in0;
    logic memwrite, regwrite, rol;
    
    debouncer d(clk, reset, step, debouncedStep);
    
    
     top_mips pipelined_processor(.clk(debouncedStep), .reset(reset),
                 .instrF(instrF),
                 .PC(pc), .PCF(),
                 .PcSrcD(),
                 .MemWriteD(memwrite), .MemToRegD(), .ALUSrcD(), .BranchD(), .RegDstD(), .RegWriteD(regwrite),
                 .ALUControlD(),
                 .instrD(),
                 .ALUOutE(), .WriteDataE(),
                 .ForwardAE(), .ForwardBE(),
                 .ForwardAD(), .ForwardBD(),
                 .WriteRegW(), .RegWriteW(), .MemtoRegW(), .RolD(rol),
                 .RotatedW(), .ResultW(dataadr));

    
    
    assign in3 = pc[7:4];
    assign in2 = pc[3:0];
    assign in1 = dataadr[7:4];
    assign in0 = dataadr[3:0];
    assign led[0] = memwrite;
    assign led[1] = regwrite;
    assign led[2] = rol;
    
    display_controller dc (clk, in3, in2, in1, in0, seg, dp, an);
    
endmodule