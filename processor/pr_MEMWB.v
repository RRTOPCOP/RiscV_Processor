module memwb(clk, memwb_pc_in, memwb_memdata_in, memwb_plusfour_in, memwb_plusimm_in, memwb_imm_in, memwb_aluout_in, memwb_rd_in, memwb_regwrite_in, memwb_memtoreg_in, memwb_opcode_in, memwb_pc_out, memwb_memdata_out, memwb_plusfour_out, memwb_plusimm_out, memwb_imm_out, memwb_aluout_out, memwb_rd_out, memwb_regwrite_out, memwb_memtoreg_out, memwb_opcode_out)

input clk;
input [31:0] memwb_pc_in;
input [31:0] memwb_memdata_in;
input [31:0] memwb_plusfour_in;
input [31:0] memwb_plusimm_in;
input [31:0] memwb_imm_in;
input [31:0] memwb_aluout_in;
input [4:0] memwb_rd_in;
input memwb_regwrite_in;
input memwb_memtoreg_in;
input memwb_opcode_in;


output [31:0] memwb_pc_out;
output [31:0] memwb_memdata_out;
output [31:0] memwb_plusfour_out;
output [31:0] memwb_plusimm_out;
output [31:0] memwb_imm_out;
output [31:0] memwb_aluout_out;
output [4:0] memwb_rd_out;
output memwb_regwrite_out;
output memwb_memtoreg_out;
output memwb_opcode_out;

always @ (posedge clk) begin

  memwb_pc_out <= memwb_pc_in;
  memwb_memdata_out <= memwb_memdata_in;
  memwb_plusfour_out <= memwb_plusfour_in;
  memwb_plusimm_out <= memwb_plusimm_in;
  memwb_imm_out <= memwb_imm_in;
  memwb_aluout_out <= memwb_aluout_in;
  memwb_rd_out <= memwb_rd_in;
  memwb_regwirte_out <= memwb_regwrite_in;
  memwb_memtoreg_out <= memwb_memtoreg_in;
  memwb_opcode_out <= memwb_opcode_in;

end

endmodule