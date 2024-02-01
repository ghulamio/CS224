`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 10:39:11 PM
// Design Name: 
// Module Name: MIPS_Processor_tb
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


module MIPS_Processor_tb();

    // Declare inputs and outputs for the testbench
    logic clk, reset;
    logic [31:0] writedata, dataadr, pc, instr, readdata;
    logic memwrite;

    // Instantiate the MIPS processor module
    MIPS_Processor dut (
        .clk(clk),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .pc(pc),
        .instr(instr),
        .readdata(readdata),
        .memwrite(memwrite)
    );

    // Create a clock signal with a period of 10ns
    always #5 clk = ~clk;

    // Initialize the inputs to the DUT
    initial begin
        clk = 0;
        reset = 1;
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
