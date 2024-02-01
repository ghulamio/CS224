`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2023 07:00:32 PM
// Design Name: 
// Module Name: tb_pipelined_processor
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


module tb_pipelined_processor();
    // Declare inputs and outputs for the testbench
        logic clk, reset;
        logic [31:0] writedata, dataadr, PC, PCF, instrF, readdata;
        logic PcSrcD;
        logic MemWriteD, MemToRegD, ALUSrcD, BranchD, RegDstD, RegWriteD;
        logic [2:0]  ALUControlD;
        logic [31:0] instrD, ALUOutE, WriteDataE;
        logic [1:0] ForwardAE, ForwardBE;
        logic ForwardAD, ForwardBD;
         // My outputs
        logic [4:0] WriteRegW;
        logic RegWriteW, MemtoRegW, RolD;
        logic [31:0] RotatedW, ResultW;
    
        // Instantiate the MIPS processor module
//        top_mips pipelined_processor(.clk(clk), .reset(reset),
        top_mips pipelined_processor(.clk(clk), .reset(reset),
                 .instrF(instrF),
                 .PC(PC), .PCF(PCF),
                 .PcSrcD(PcSrcD),
                 .MemWriteD(MemWriteD), .MemToRegD(MemToRegD), .ALUSrcD(ALUSrcD), .BranchD(BranchD), .RegDstD(RegDstD), .RegWriteD(RegWriteD),
                 .ALUControlD(ALUControlD),
                 .instrD(instrD),
                 .ALUOutE(ALUOutE), .WriteDataE(WriteDataE),
                 .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
                 .ForwardAD(ForwardAD), .ForwardBD(ForwardBD),
                 .WriteRegW(WriteRegW), .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW), .RolD(RolD),
                 .RotatedW(RotatedW), .ResultW(ResultW));
    
        // Create a clock signal with a period of 10ns
        always #5 clk = ~clk;
    
        // Initialize the inputs to the DUT
        initial begin
            clk = 0;
            reset = 1;
//            PC = 0;
    //        dataadr = 32'hfffffff6;
    //        writedata = 32'hxxxxxxxx;
    //        pc = 32'h00000000;
    //        instr = 32'h2014fff6;
    //        readdata = 32'hxxxxxxxx;
            
            #10 reset = 0;
    
            // End the simulation
            #200 $finish;
        end
    
endmodule
