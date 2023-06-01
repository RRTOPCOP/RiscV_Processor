module exmem(clk, exmem_pc_in, exmem_pcnext_in, exmem_aluout_in, exmem_imm_in, exmem_regdata2_in, exmem_plusfour_in, exmem_plusimm_in, exmem_rd_in, exmem_regwrite_in, exmem_memtoreg_in, exmem_opcode_in, exmem_funct3_in, exmem_memwrite_in, exmem_memread_in, exmem_branch_in, exmem_pcctr_in, exmem_pc_out, exmem_pcnext_out, exmem_aluout_out, exmem_imm_out, exmem_regdata2_out, exmem_plusfour_out, exmem_plusimm_out, exmem_rd_out, exmem_regwrite_out, exmem_memtoreg_out, exmem_opcode_out, exmem_funct3_out, exmem_memwrite_out,exmem_memread_out, exmem_branch_out, exmem_pcctr_out)

input clk;
input [31:0] exmem_pc_in;
input [31:0] exmem_pcnext_in;
input [31:0] exmem_aluout_in;
input [31:0] exmem_imm_in;
input [31:0] exmem_regdata2_in;
input [31:0] exmem_plusfour_in;
input [31:0] exmem_plusimm_in;
input [4:0] exmem_rd_in;
input exmem_regwrite_in;
input exmem_memtoreg_in;
input [6:0] exmem_opcode_in;
input [2:0] exmem_funct3_in;
input exmem_memwrite_in;
input exmem_memread_in;
input exmem_branch_in;
input exmem_pcctr_in;


output [31:0] exmem_pc_out;
output [31:0] exmem_pcnext_out;
output [31:0] exmem_aluout_out;
output [31:0] exmem_imm_out;
output [31:0] exmem_regdata2_out;
output [31:0] exmem_plusfour_out;
output [31:0] exmem_plusimm_out;
output [4:0] exmem_rd_out;
output exmem_regwrite_out;
output exmem_memtoreg_out;
output [6:0] exmem_opcode_out;
output [2;0] exmem_funct3_out;
output exmem_memwrite_out;
output exmem_memread_out;
output exmem_branch_out;
output exmem_pcctr_out;

always @ (posedge clk) begin

    exmem_pc_out <= exmem_pc_in;
    exmem_pcnext_out <= exmem_pcnext_in;
    exmem_aluout_out <= exmem_aluout_in;
    exmem_imm_out <= exmem_imm_in;
    exmem_regdata2_out <= exmem_regdata2_in;
    exmem_plusfour_out <= exmem_plusfour_in;
    exmem_plusimm_out <= exmem_plusimm_in;
    exmem_rd_out <= exmem_rd_in;
    exmem_regwrite_out <= exmem_regwrite_in;
    exmem_memtoreg_out <= exmem_memtoreg_in;
    exmem_opcode_out <= exmem_opcode_in;
    exmem_funct3_out <= exmem_funct3_in;
    exmem_branch_out <= exmem_branch_in;
    exmem_pcctr_out <= exmem_pcctr_in;

end


endmodule