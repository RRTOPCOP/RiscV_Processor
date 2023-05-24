`include "rv32i_decoder.v"
`include "rf32x32.v"

module id(clk, rst, order_data, srcMem_out_data, imm, reg_data1, reg_data2, opcode, funct3, alu_op, alu_src, jump, mem_to_reg, mem_read, mem_write, branch, jalr)

input clk;
input rst;
input [31:0] order_data;       
input [31:0] srcMem_out_data;
output [31:0] reg_data1;  //to ex
output [31:0] reg_data2;  //to ex, mem
output [31:0] imm;        //to ex, wb
output [6:0] opcode;      //to wb
output [2:0] funct3;      //to ex
output [2:0] alu_op;      //to ex
output  alu_src;          //to ex
output  jump;             //to ex
output  mem_to_reg;       //to wb
output  mem_read;         //to mem
output  mem_write;        //to mem
output  branch;           //to ex
output  jalr;             //to ex

wire [6:0] funct7;      
wire reg_write;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;



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
  .jalr(jalr),
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

