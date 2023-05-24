`include "src_mem.v"

module wb(opcode, mem_to_reg, plusOffset_out_data, imm, plusFour_out_data, mem_data, alu_out_data, srcMem_out_data)

input [6:0] opcode;
input mem_to_reg;
input [31:0] plusOffset_out_data;
input [31:0] imm;
input [31:0] plusFour_out_data;
input [31:0] mem_data;
input [31:0] alu_out_data;
output [31:0] srcMem_out_data;   //to register

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


endmodule