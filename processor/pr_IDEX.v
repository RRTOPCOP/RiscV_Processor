module idex(clk, idex_pc_in, idex_plusfour_in, idex_regdata1_in, idex_regdata2_in, idex_imm_in, idex_rs1_in, idex_rs2_in, idex_rd_in, idex_opcode_in, idex_funct3_in, idex_aluop_in, idex_alusrc_in, idex_jump_in, idex_regwrite_in, idex_memtoreg_in, idex_memread_in, idex_memwrite_in, idex_branch_in, idex_jalr_in, is_flash, is_stall, forward_data1, forward_data2,  regdata1_ctr, regdata2_ctr, idex_pc_out, idex_plusfour_out, idex_regdata1_out, idex_regdata2_out, idex_imm_out, idex_rs1_out, idex_rs2_out, idex_rd_out, idex_opcode_out, idex_funct3_out, idex_aluop_out, idex_alusrc_out, idex_jump_out, idex_regwrite_out, idex_memtoreg_out, idex_memread_out, idex_memwrite_out, idex_branch_out, idex_jalr_out);

//from ID
input clk;
input [31:0] idex_pc_in;
input [31:0] idex_plusfour_in;
input [31:0] idex_regdata1_in;
input [31:0] idex_regdata2_in;
input [31:0] idex_imm_in;
input [4:0] idex_rs1_in;
input [4:0] idex_rs2_in;
input [4:0] idex_rd_in;
input [6:0] idex_opcode_in;
input [2:0] idex_funct3_in;
input [2:0] idex_aluop_in;
input idex_alusrc_in;
input idex_jump_in;
input idex_regwrite_in;
input idex_memtoreg_in;
input idex_memread_in;
input idex_memwrite_in;
input idex_branch_in;
input idex_jalr_in;

//from hazrdCtr
input is_flash;
input is_stall;
input [31:0] forward_data1;
input [31:0] forward_data2;
input regdata1_ctr;
input regdata2_ctr;


output reg [31:0] idex_pc_out = 32'b0;
output reg [31:0] idex_plusfour_out = 32'b0;
output reg [31:0] idex_regdata1_out = 32'b0;
output reg [31:0] idex_regdata2_out = 32'b0;
output reg [31:0] idex_imm_out = 32'b0;
output reg [4:0] idex_rs1_out = 5'b0;
output reg [4:0] idex_rs2_out = 5'b0;
output reg [4:0] idex_rd_out = 5'b0;
output reg [6:0] idex_opcode_out = 7'b0;
output reg [2:0] idex_funct3_out = 3'b0;
output reg [2:0] idex_aluop_out = 3'b0;
output reg idex_alusrc_out = 1'b0;
output reg idex_regwrite_out = 1'b0;
output reg idex_jump_out = 1'b0;
output reg idex_memtoreg_out = 1'b0;
output reg idex_memread_out = 1'b0;
output reg idex_memwrite_out = 1'b0;
output reg idex_branch_out = 1'b0;
output reg idex_jalr_out =  1'b0;



always @ (posedge clk) begin
  if(is_flash)begin
    idex_pc_out <= idex_pc_in;
    idex_plusfour_out <= 32'b0;
    idex_imm_out <= 32'b0;
    idex_rs1_out <= 5'b0;
    idex_rs2_out <= 5'b0;
    idex_rd_out <= 5'b0;
    idex_opcode_out <= 7'b0;
    idex_funct3_out <= 3'b0;
    idex_aluop_out <= 3'b0;
    idex_alusrc_out <= 1'b0;
    idex_jump_out <= 1'b0;
    idex_regwrite_out <= 1'b0;
    idex_memtoreg_out <= 1'b0;
    idex_memread_out <= 1'b0;
    idex_memwrite_out <= 1'b0;
    idex_branch_out <= 1'b0;
    idex_jalr_out <= 1'b0;
    idex_regdata1_out <= 32'b0;
    idex_regdata2_out <= 32'b0;
  end else begin
    idex_pc_out <= idex_pc_in;
    idex_plusfour_out <= idex_plusfour_in;
    idex_imm_out <= idex_imm_in;
    idex_rs1_out <= idex_rs1_in;
    idex_rs2_out <= idex_rs2_in;
    idex_rd_out <= idex_rd_in;
    idex_opcode_out <= idex_opcode_in;
    idex_funct3_out <= idex_funct3_in;
    idex_aluop_out <= idex_aluop_in;
    idex_alusrc_out <= idex_alusrc_in;
    idex_jump_out <= idex_jump_in;
    idex_regwrite_out <= idex_regwrite_in;
    idex_memtoreg_out <= idex_memtoreg_in;
    idex_memread_out <= idex_memread_in;
    idex_memwrite_out <= idex_memwrite_in;
    idex_branch_out <= idex_branch_in;
    idex_jalr_out <= idex_jalr_in;
    idex_regdata1_out <= idex_regdata1_in;
    idex_regdata2_out <= idex_regdata2_in;
  end


// if(regdata1_ctr) begin
//   #0.5;
//   idex_regdata1_out <= forward_data1;
// end

// if(regdata2_ctr) begin
//   #0.5;
//   idex_regdata2_out <= forward_data2;
// end



if(regdata1_ctr && regdata2_ctr) begin
  #0.5;
  idex_regdata1_out <= forward_data1;
  idex_regdata2_out <= forward_data2;
end else if(regdata1_ctr && (~regdata2_ctr))begin
  idex_regdata2_out <= idex_regdata2_in;
  #0.5;
  idex_regdata1_out <= forward_data1;
end else if((~regdata1_ctr) && regdata2_ctr)begin
  idex_regdata1_out <= idex_regdata1_in;
  #0.5;
  idex_regdata2_out <= forward_data2;
end

end


wire both = regdata1_ctr && regdata2_ctr;
wire only1 = regdata1_ctr && (~regdata2_ctr);
wire only2 = (~regdata1_ctr) && regdata2_ctr;



endmodule