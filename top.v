`include "rf32x32.v"// include register file 
`include "adder_pcPlusFour.v"
`include "adder_pcPlusOffset.v"
`include "alu32_func.v"
`include "mux_alu.v"
`include "mux_jalr.v"
`include "mux_pcsrc.v"
`include "pc.v"
`include "rv32i_decoder.v"
`include "src_mem.v"
`include "src_pc.v"



module top (clk, rst, ACKD_n, ACKI_n, IDT, OINT_n, IAD, DAD, MREQ, WRITE, SIZE, IACK_n, DDT);

input  clk;
input  rst;
input  ACKD_n; // is zero when the signal is unstable (data.mem) ***
input  ACKI_n; // is zero when the signal is unstable (inst.mem) ***
input [31:0] IDT; // instruction data (= order_data)
input [2:0] OINT_n; //whether there is interruption(yes -> 0)       ***
inout [31:0] DDT; // sw(top(register) to mem) reg_data2, lw(mem to top(register)) mem_data
output [31:0] IAD; // instruction address data(pc_out_data)
output [31:0] DAD; // data address data(alu_out_data)
output  MREQ; // mem_read
output  WRITE; // mem_write
output [1:0] SIZE; // data width                                    
output  IACK_n; // processor status (ok -> 1)                    


assign DDT = reg_data2;
assign mem_data = DDT;
assign IAD = pc_out_data;
assign DAD = alu_out_data;
assign MREQ = mem_read;
assign WRITE = mem_write;
assign IACK_n = 1;
assign SIZE = size(funct3);




//function for SIZE
function [1:0] size;
  input [2:0] funct3;

  case(funct3)
  3'b0,
  3'b100: size = 2'b11; //byte
  3'b001,
  3'b101: size = 2'b01; //half
  3'b010: size = 2'b0; //word
  endcase

endfunction


//variable definition
wire [31:0] pc_in_data; //mux_jalr to pc
wire [31:0] pc_out_data; //pc to order_mem, adder_pcPlusOffset, adder_pcPlusFour
wire [31:0] order_data; //order_mem to decoder
  //field in order_data
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [4:0] rd;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [6:0] funct7;
  wire [31:0] imm;
  wire [2:0] alu_op;
  wire  reg_write;
  wire  alu_src;
  wire  jump;
  wire  mem_to_reg;
  wire  mem_read;
  wire  mem_write;
  wire  branch;
  wire  jalr;
wire [31:0] plusFour_out_data; //adder_pcPlusFour to mux_pcsrc, src_mem
wire [31:0] plusOffset_out_data; //adder_pcPlusOffset to mux_pcsrc, src_mem
wire [31:0] reg_data1; //register to alu
wire [31:0] reg_data2; //register to mux_alu, mem
wire [31:0] muxAlu_out_data; //mux_alu to alu
  //output from alu
  wire [31:0] alu_out_data; // alu to mem, mux_jalr, src_mem
  wire  zero; // alu to src_pc
  wire  overflow; 
  wire  u_slt; // alu to src_pc
  wire  s_slt; // slu to src_pc
wire  pc_ctr; // pc_src to mux_pcsrc
wire [31:0] muxPcSrc_out_data; // mux_pcsrc to mux_jalr
wire [31:0] mem_data; // mem to src_mem
wire [31:0] srcMem_out_data; // src_mem to register

assign order_data = IDT;

//*** modules ***//

//program counter
pc u_pc (
  .pc_in_data(pc_in_data),
  .clk(clk),
  .rst(rst),
  .pc_out_data(pc_out_data)
);

//decoder
decoder u_decoder (
  .instruction(order_data),
  .opcode(opcode),
  .funct3(funct3),
  .rd(rd),
  .rs1(rs1),
  .rs2(rs2),
  .funct7(funct7),
  .imm(imm),
  .alu_op(alu_op),
  .reg_write(reg_write),
  .alu_src(alu_src),
  .jump(jump),
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .branch(branch),
  .jalr(jalr)
);

//adder_pcPlusFour
adder_pcPlusFour u_adder_pcPlusFour (
  .pc(pc_out_data),
  .plusFour_out_data(plusFour_out_data)
);

//adder_pcPlusOffset
adder_pcPlusOffset u_adder_pcPlusOffset (
  .pc(pc_out_data),
  .offset(imm),
  .plusOffset_out_data(plusOffset_out_data)
);

//mux_alu
mux_alu u_mux_alu (
  .alu_src(alu_src),
  .imm(imm),
  .reg_data(reg_data2),
  .muxAlu_out_data(muxAlu_out_data)
);

//alu
alu u_alu (
  .dataA(reg_data1),
  .dataB(muxAlu_out_data),
  .alu_op(alu_op),
  .alu_out_data(alu_out_data),
  .zero(zero),
  .overflow(overflow),
  .u_slt(u_slt),
  .s_slt(s_slt)
);

//src_pc
pc_src u_pc_src (
  .branch(branch),
  .jump(jump),
  .funct3(funct3),
  .zero(zero),
  .u_slt(u_slt),
  .s_slt(s_slt),
  .pc_ctr(pc_ctr)
);

//mux_pcsrc
mux_pcsrc u_mux_pcsrc (
  .pc_ctr(pc_ctr),
  .pc_plus_four(plusFour_out_data),
  .pc_plus_offset(plusOffset_out_data),
  .muxPcSrc_out_data(muxPcSrc_out_data)
);

//mux_jalr
mux_jalr u_mux_jalr (
  .jalr(jalr),
  .alu_out(alu_out_data),
  .mux_out(muxPcSrc_out_data),
  .muxJalr_out_data(pc_in_data)
);

//src_mem
src_mem u_src_mem (
  .opcode(opcode),
  .mem_to_reg(mem_to_reg),
  .pc_plus_imm(plusOffset_out_data),
  .imm(imm),
  .pc_plus_four(plusFour_out_data),
  .mem_data(mem_data),
  .alu_data(alu_out_data),
  .srcMem_out_data(srcMem_out_data)
);

//register
rf32x32 register (
  .clk(clk),
  .reset(rst),
  .wr_n(~reg_write),
  .rd1_addr(rs1),
  .rd2_addr(rs2),
  .wr_addr(rd),
  .data_in(srcMem_out_data),
  .data1_out(reg_data1),
  .data2_out(reg_data2)
);


endmodule