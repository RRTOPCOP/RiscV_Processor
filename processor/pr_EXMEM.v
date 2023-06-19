module exmem(clk, exmem_pc_in, exmem_pcnext_in, exmem_aluout_in, exmem_imm_in, exmem_regdata2_in, exmem_plusfour_in, exmem_plusimm_in, exmem_rd_in, exmem_regwrite_in, exmem_memtoreg_in, exmem_opcode_in, exmem_funct3_in, exmem_memwrite_in, exmem_memread_in, exmem_branch_in, exmem_pcctr_in, exmem_pc_out, exmem_pcnext_out, exmem_aluout_out, exmem_imm_out, exmem_regdata2_out, exmem_plusfour_out, exmem_plusimm_out, exmem_rd_out, exmem_regwrite_out, exmem_memtoreg_out, exmem_opcode_out, exmem_funct3_out, exmem_memwrite_out,exmem_memread_out, exmem_branch_out, exmem_pcctr_out);

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


output reg [31:0] exmem_pc_out = 32'b0;
output reg [31:0] exmem_pcnext_out = 32'b0;
output reg [31:0] exmem_aluout_out = 32'b0;
output reg [31:0] exmem_imm_out = 32'b0;
output reg [31:0] exmem_regdata2_out = 32'b0;
output reg [31:0] exmem_plusfour_out = 32'b0;
output reg [31:0] exmem_plusimm_out = 32'b0;
output reg [4:0] exmem_rd_out = 5'b0;
output reg exmem_regwrite_out = 1'b0;
output reg exmem_memtoreg_out = 1'b0;
output reg [6:0] exmem_opcode_out = 7'b0;
output reg [2:0] exmem_funct3_out = 3'b0;
output reg exmem_memwrite_out = 1'b0;
output reg exmem_memread_out = 1'b0;
output reg exmem_branch_out = 1'b0;
output reg exmem_pcctr_out = 1'b0;

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
    exmem_memwrite_out <= exmem_memwrite_in;
    exmem_memread_out <= exmem_memread_in; 
    exmem_opcode_out <= exmem_opcode_in;
    exmem_funct3_out <= exmem_funct3_in;
    exmem_branch_out <= exmem_branch_in;
    exmem_pcctr_out <= exmem_pcctr_in;

end

endmodule