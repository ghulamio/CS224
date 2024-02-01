`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2023 10:29:53 PM
// Design Name: 
// Module Name: MIPS_Processor
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


module MIPS_Processor(input   logic 	 clk, reset,            
	     output  logic[31:0] writedata, dataadr, 
	     output  logic[31:0] pc, instr, readdata,           
	     output  logic       memwrite);    

   // instantiate processor and memories  
   mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);  
   imem imem (pc[7:2], instr);  
   dmem dmem (clk, memwrite, dataadr, writedata, readdata);

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



// External instruction memory used by MIPS single-cycle
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output


module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//		address		instruction
//		-------		-----------
            // Test rol
            8'h00: instr = 32'h2008a0a0;  	
        	8'h04: instr = 32'h010048ab;  
        	8'h08: instr = 32'h21210002;  	
        	
        	// Test spc
        	8'h0c: instr = 32'h40000028; 
        	8'h10: instr = 32'h8c080028;
        	8'h14: instr = 32'h21080008;

//            // Default instructions
//        	8'h00: instr = 32'h2014fff6;  	// disassemble, by hand 
//        	8'h04: instr = 32'h20090007;  	// or with a program,
//        	8'h08: instr = 32'h22820003;  	// to find out what
//        	8'h0c: instr = 32'h01342025;  	// this program does!
//        	8'h10: instr = 32'h00822824;
//        	8'h14: instr = 32'h00a42820;
//        	8'h18: instr = 32'h1045003d;
//        	8'h1c: instr = 32'h0054202a;
//        	8'h20: instr = 32'h10040001;
//        	8'h24: instr = 32'h00002820;
//        	8'h28: instr = 32'h0289202a;
//        	8'h2c: instr = 32'h00853820;
//        	8'h30: instr = 32'h00e23822;
//        	8'h34: instr = 32'hac470057;
//        	8'h38: instr = 32'h8c020050;
//        	8'h3c: instr = 32'h08000011;
//        	8'h40: instr = 32'h20020001;
//        	8'h44: instr = 32'h2282005a;
//        	8'h48: instr = 32'h08000012;  // j 48, so it will loop here

	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule


// single-cycle MIPS processor, with controller and datapath

module mips (input  logic        clk, reset,
             output logic[31:0]  pc,
             input  logic[31:0]  instr,
             output logic        memwrite,
             output logic[31:0]  aluout, writedata,
             input  logic[31:0]  readdata);

  logic        memtoreg, pcsrc, zero, alusrc, regdst, regwrite, jump, rol, writesrc;
  logic [2:0]  alucontrol;

  controller c (instr[31:26], instr[5:0], zero, memtoreg, memwrite, pcsrc,
                        alusrc, regdst, regwrite, jump, rol, writesrc, alucontrol);

  datapath dp (clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump, rol, writesrc,
                          alucontrol, zero, pc, instr, aluout, writedata, readdata);

endmodule
module controller(input  logic[5:0] op, funct,
                  input  logic     zero,
                  output logic     memtoreg, memwrite,
                  output logic     pcsrc, alusrc,
                  output logic     regdst, regwrite,
                  output logic     jump, rol, writesrc,
                  output logic[2:0] alucontrol);

   logic [1:0] aluop;
   logic       branch;

   maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, 
		 jump, writesrc, aluop);

   aludec  ad (funct, aluop, alucontrol, rol);

   assign pcsrc = branch & zero;

endmodule

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite, jump, writesrc,
	              output logic[1:0] aluop );
   logic [9:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg, aluop, jump, writesrc} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 10'b1100001000; // R-type
      6'b100011: controls <= 10'b1010010000; // LW
      6'b101011: controls <= 10'b0010100000; // SW
      6'b000100: controls <= 10'b0001000100; // BEQ
      6'b001000: controls <= 10'b1010000000; // ADDI
      6'b000010: controls <= 10'b0000000010; // J
      6'b010000: controls <= 10'b0010100001; // SPC
      default:   controls <= 10'bxxxxxxxxxx; // illegal op
    endcase
endmodule

module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol,
               output   logic      rol);
  always_comb
    case(aluop)
      2'b00: begin
        alucontrol  = 3'b010;  // add  (for lw/sw/addi)
        rol = 1'b0;
      end
      2'b01: begin
        alucontrol  = 3'b110;  // sub   (for beq)
        rol = 1'b0;
      end
      default: case(funct)          // R-TYPE instructions
          6'b100000: begin
            alucontrol  = 3'b010; // ADD
            rol = 1'b0;
          end
          6'b100010: begin
            alucontrol  = 3'b110; // SUB
            rol = 1'b0;
          end
          6'b100100: begin
            alucontrol  = 3'b000; // AND
            rol = 1'b0;
          end
          6'b100101: begin 
            alucontrol  = 3'b001; // OR
            rol = 1'b0;
          end
          6'b101010: begin 
            alucontrol  = 3'b111; // SLT
            rol = 1'b0;
          end
          6'b101011: begin
            alucontrol = 3'bxxx; // rol
            rol = 1'b1;
          end
          default: begin
            alucontrol  = 3'bxxx; // ???
            rol = 1'b0;
          end
        endcase
    endcase
endmodule

module datapath (input  logic clk, reset, memtoreg, pcsrc, alusrc, regdst,
                 input  logic regwrite, jump, rol, writesrc,
		 input  logic[2:0]  alucontrol, 
                 output logic zero, 
		 output logic[31:0] pc, 
	         input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	         input  logic[31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, srca, srcb, result, rotated, writedata1, result1;
 
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnext);

// register file logic
   regfile     rf (clk, regwrite, instr[25:21], instr[20:16], writereg,
                   result, srca, writedata1);

   mux2 #(5)    wrmux (instr[20:16], instr[15:11], regdst, writereg);
   mux2 #(32)  resmux (aluout, readdata, memtoreg, result1);
   signext         se (instr[15:0], signimm);

   // SPC
   mux2 #(32) wrdamux (writedata1, pc, writesrc, writedata);

  // ALU logic
   mux2 #(32)  srcbmux (writedata1, signimm, alusrc, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, zero);
   
   // ROL
   leftrotate  lr (srca, instr[10:6], rotated);
   mux2 #(32) rolmux (result1, rotated, rol, result);

endmodule


module regfile (input    logic clk, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on rising edge of clock. Register0 hardwired to 0.

  always_ff@(posedge clk)
     if (we3) 
         rf [wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;

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
            3'b011: result = a ^ b;
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

module leftrotate (input logic[31:0] a,
                   input logic[4:0] shamt,
                   output logic[31:0] b);
  assign b = (a << shamt) | (a >> (32 - shamt)); // left rotates by shamt
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