module memwb(clk, memwb_pc_in, memwb_memdata_in, memwb_plusfour_in, memwb_plusimm_in, memwb_imm_in, memwb_aluout_in, memwb_rd_in, memwb_regwrite_in, memwb_memtoreg_in, memwb_opcode_in, memwb_pc_out, memwb_memdata_out, memwb_plusfour_out, memwb_plusimm_out, memwb_imm_out, memwb_aluout_out, memwb_rd_out, memwb_regwrite_out, memwb_memtoreg_out, memwb_opcode_out);

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
input [6:0] memwb_opcode_in;


output reg [31:0] memwb_pc_out = 32'b0;
output reg [31:0] memwb_memdata_out = 32'b0;
output reg [31:0] memwb_plusfour_out = 32'b0;
output reg [31:0] memwb_plusimm_out = 32'b0;
output reg [31:0] memwb_imm_out = 32'b0;
output reg [31:0] memwb_aluout_out = 32'b0;
output reg [4:0] memwb_rd_out = 5'b0;
output reg memwb_regwrite_out = 1'b0;
output reg memwb_memtoreg_out = 0;
output reg [6:0] memwb_opcode_out = 0;

always @ (posedge clk) begin

  memwb_pc_out <= memwb_pc_in;
  memwb_memdata_out <= memwb_memdata_in;
  memwb_plusfour_out <= memwb_plusfour_in;
  memwb_plusimm_out <= memwb_plusimm_in;
  memwb_imm_out <= memwb_imm_in;
  memwb_aluout_out <= memwb_aluout_in;
  memwb_rd_out <= memwb_rd_in;
  memwb_regwrite_out <= memwb_regwrite_in;
  memwb_memtoreg_out <= memwb_memtoreg_in;
  memwb_opcode_out <= memwb_opcode_in;

end

endmodule