`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2023 12:01:16 PM
// Design Name: 
// Module Name: pipelineSkeleton
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 07:36:24 PM
// Design Name: 
// Module Name: PipelineSkeleton
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

// Define pipes that exist in the PipelinedDatapath. 
// The pipes between Writeback (W) and Fetch (F), as well as Decode (D) and Execute (E) are given to you.
// Create the rest of the pipes where inputs follow the naming conventions in the book.


module PipeFtoD(input logic[31:0] instr, PcPlus4F,
                input logic EN, clear, clk, reset,
                output logic[31:0] instrD, PcPlus4D);

                /* to be filled */
                
endmodule

// The pipe between Writeback (W) and Fetch (F) is given as follows.

module PipeWtoF(input logic[31:0] PC,
                input logic EN, clk, reset,		// ~StallF will be connected as this EN
                output logic[31:0] PCF);

                always_ff @(posedge clk, posedge reset)
                    if(reset)
                        PCF <= 0;
                    else if(EN)
                        PCF <= PC;
endmodule

module PipeDtoE(input logic[31:0] RD1, RD2, SignImmD,
                input logic[4:0] RsD, RtD, RdD,
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD,
                input logic[2:0] ALUControlD,
                input logic clear, clk, reset,
                output logic[31:0] RsData, RtData, SignImmE,
                output logic[4:0] RsE, RtE, RdE, 
                output logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE,
                output logic[2:0] ALUControlE);

        always_ff @(posedge clk, posedge reset)
          if(reset || clear)
                begin
                // Control signals
                RegWriteE <= 0;
                MemtoRegE <= 0;
                MemWriteE <= 0;
                ALUControlE <= 0;
                ALUSrcE <= 0;
                RegDstE <= 0;
                
                // Data
                RsData <= 0;
                RtData <= 0;
                RsE <= 0;
                RtE <= 0;
                RdE <= 0;
                SignImmE <= 0;
                end
            else
                begin
                // Control signals
                RegWriteE <= RegWriteD;
                MemtoRegE <= MemtoRegD;
                MemWriteE <= MemWriteD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                
                // Data
                RsData <= RD1;
                RtData <= RD2;
                RsE <= RsD;
                RtE <= RtD;
                RdE <= RdD;
                SignImmE <= SignImmD;
                end

endmodule

module PipeEtoM(/*to be filled*/);
                  // to be filled 
endmodule

module PipeMtoW(/*to be filled*/);
                  // to be filled 
endmodule



// *******************************************************************************
// End of the individual pipe definitions.
// ******************************************************************************

// *******************************************************************************
// Below is the definition of the datapath.
// The signature of the module is given. The datapath will include (not limited to) the following items:
//  (1) Adder that adds 4 to PC
//  (2) Shifter that shifts SignImmD to left by 2
//  (3) Sign extender and Register file
//  (4) PipeFtoD
//  (5) PipeDtoE and ALU
//  (5) Adder for PcBranchD
//  (6) PipeEtoM and Data Memory
//  (7) PipeMtoW
//  (8) Many muxes
//  (9) Hazard unit
//  ...?
// *******************************************************************************

module datapath (input  logic clk, reset,
                input  logic[2:0]  ALUControlD,
                input logic RegWriteD, MemToRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
                 output logic [31:0] instrF,		
                 output logic [31:0] instrD, PC, PCF,
                output logic PcSrcD,                 
                output logic [31:0] ALUOutE, WriteDataE,
                output logic [1:0] ForwardAE, ForwardBE,
                 output logic ForwardAD, ForwardBD); // Add or remove input-outputs if necessary

	// ********************************************************************
	// Here, define the wires that are needed inside this pipelined datapath module
	// ********************************************************************
  
  	//* We have defined a few wires for you
    logic [31:0] PcSrcA, PcSrcB, PcBranchD, PcPlus4F;	
  	logic [31:0] SignImmD, ShiftedImmD;
  	logic [31:0] ResultW;
  	logic [4:0] WriteRegW;
  	logic [31:0] RD1, RD2;
  	logic [31:0] SrcBE;
  	logic [31:0] ReadDataM;
  
	//* You should define others down below (you might want to rename some of the wires above while implementing the pipeline)
  
  	//* We have provided you with a single-cycle datapath
  	//* You should convert it to a pipelined datapath, changing the connections between modules as necessary
    
  	// Replace with PipeWtoF
    flopr #(32) pcreg(clk, reset, PC, PCF);
  
  	// Do some operations
    assign PcPlus4F = PCF + 4;
    assign PcSrcB = PcBranchD;
	assign PcSrcA = PcPlus4F;
  	mux2 #(32) pc_mux(PcSrcA, PcSrcB, PcSrcD, PC);

    imem im1(PCF[7:2], instrF);
    
  	// Replace the code below with PipeFtoD
  	assign instrD = instrF;
  
  	// Decode stage
  	regfile rf(clk, reset, RegWriteD, instrD[25:21], instrD[20:16], WriteRegW, ResultW, RD1, RD2);
  	signext se(instrD[15:0], SignImmD);
  	
  	sl2 shiftimm(SignImmD, ShiftedImmD);
  	adder branchadd(PcPlus4F, ShiftedImmD, PcBranchD);
  	assign PcSrcD = BranchD & (RD1 == RD2); 
  
  	// Instantiate PipeDtoE here
  
  	// Execute stage
  	mux2 #(32) srcBMux(RD2, SignImmD, ALUSrcD, SrcBE);
  	alu alu(RD1, SrcBE, ALUControlD, ALUOutE);
  	mux2 #(5) wrMux(instrD[20:16], instrD[15:11], RegDstD, WriteRegW);

  	// Replace the code below with PipeEtoM
  	assign WriteDataE = RD2;
  
  	// Memory stage
  	dmem DM(clk, MemWriteD, ALUOutE, WriteDataE, ReadDataM);

  	// Instantiate PipeMtoW
    
  	// Writeback stage
  	mux2 #(32) wbmux(ALUOutE, ReadDataM, MemToRegD, ResultW);
  	
  	// Replace the code below with HazardUnit
  	assign ForwardAE = 2'b0;
  	assign ForwardBE = 2'b0;
  	assign ForwardAD = 0;
  	assign ForwardBD = 0;

endmodule

module HazardUnit( input logic RegWriteW, BranchD,
                input logic [4:0] WriteRegW, WriteRegE,
                input logic RegWriteM,MemtoRegM,
                input logic [4:0] WriteRegM,
                input logic RegWriteE,MemtoRegE,
                input logic [4:0] rsE,rtE,
                input logic [4:0] rsD,rtD,
                output logic [1:0] ForwardAE,ForwardBE,
                output logic FlushE,StallD,StallF,ForwardAD, ForwardBD
                 ); // Add or remove input-outputs if necessary
       
	// ********************************************************************
	// Here, write equations for the Hazard Logic.
	// If you have troubles, please study pages ~420-430 in your book.
	// ********************************************************************
  
endmodule


// You can add some more logic variables for testing purposes
// but you cannot remove existing variables as we need you to output 
// these values on the waveform for grading
module pipelineSkeleton (input  logic        clk, reset,
             output  logic[31:0]  instrF,
             output logic[31:0] PC, PCF,
             output logic PcSrcD,
             output logic MemWriteD, MemToRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
             output logic [2:0]  alucontrol,
             output logic [31:0] instrD, 
             output logic [31:0] ALUOutE, WriteDataE,
             output logic [1:0] ForwardAE, ForwardBE,
                 output logic ForwardAD, ForwardBD);


    controller CU(instrD[31:26], instrD[5:0], MemToRegD, MemWriteD, ALUSrcD, RegDstD, RegWriteD, alucontrol, BranchD);
    
    datapath DP(clk, reset, alucontrol, RegWriteD, MemToRegD, MemWriteD, ALUSrcD, RegDstD, BranchD, 
        instrF, instrD, 
        PC, PCF, PcSrcD,
        ALUOutE, WriteDataE, 
        ForwardAE, ForwardBE, ForwardAD, ForwardBD); // Add or remove input-outputs as necessary
  
  
  
endmodule


// External instruction memory used by MIPS
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output
// Modify it to test your own programs.

module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//
// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-e.
//  An example test program is given below.        
//	***************************************************************************
//
//		address		instruction
//		-------		-----------
    8'h00: instr = 32'h20080005;
    8'h04: instr = 32'hac080060;
    8'h08: instr = 32'h8c090060;
    8'h0c: instr = 32'h212a0004;
    8'h10: instr = 32'h212b0003;
    8'h14: instr = 32'h8d6b0058;
    8'h18: instr = 32'h014b5022;
    8'h1c: instr = 32'hac0a0070;
    8'h20: instr = 32'h8c080070;
    8'h24: instr = 32'h8d09006c;
    8'h28: instr = 32'h01094820;

       default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule


// 	***************************************************************************
//	Below are the modules that you should modify to add more instructions to the CPU
//	***************************************************************************

module controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic[2:0] alucontrol,
                  output logic branch);

   logic [1:0] aluop;

  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, aluop);

   aludec ad (funct, aluop, alucontrol);

endmodule

// External data memory used by MIPS single-cycle processor

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite,
	              output logic[1:0] aluop );
  logic [7:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 8'b11000010; // R-type
      6'b100011: controls <= 8'b10100100; // LW
      6'b101011: controls <= 8'b00101000; // SW
      6'b000100: controls <= 8'b00010001; // BEQ
      6'b001000: controls <= 8'b10100000; // ADDI
      default:   controls <= 8'bxxxxxxxx; // illegal op
    endcase
endmodule

module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol);
  always_comb
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b101010: alucontrol  = 3'b111; // SLT
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
endmodule

module regfile (input    logic clk, reset, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on falling edge of clock. Register0 hardwired to 0.

  always_ff @(negedge clk)
     if (reset)
        for (int i=0; i<32; i++) rf[i] = 32'b0;
     else if (we3)
        rf[wa3] <= wd3;

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule

module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);
    
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = {32{1'bx}};
        endcase
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
    
endmodule

module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule

// parameterized register
module flopr #(parameter WIDTH = 8)
              (input logic clk, reset, 
	       input logic[WIDTH-1:0] d, 
               output logic[WIDTH-1:0] q);

  always_ff@(posedge clk, posedge reset)
    if (reset) q <= 0; 
    else       q <= d;
endmodule


// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule

// paramaterized 4-to-1 MUX
module mux4 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1, d2, d3,
              input  logic[1:0] s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s[1] ? ( s[0] ? d3 : d2 ) : (s[0] ? d1 : d0); 
endmodule

