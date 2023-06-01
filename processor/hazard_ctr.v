module hazardCtr(rs1, rs2, exmem_rd, memwb_rd, exmem_opcode, memwb_opcode,exmem_imm, exmem_pcPlusFour, exmem_pcPlusOffset, memwb_memdata, exmem_branch, exmem_pcctr, is_stall, is_flash, forward_data, regdata_ctr)

input [4:0] rs1;
input [4:0] rs2;
input [4:0] exmem_rd;
input [4:0] memwb_rd;
input [6:0] exmem_opcode;
input [6:0] memwb_opcode;
input [31:0] exmem_imm;
input [31:0] exmem_pcPlusFour;
input [31:0] exmem_pcPlusOffset;
input [31:0] exmem_aluOutData;
input exmem_branch;
input exmem_pcctr;
input [31:0] memwb_memdata;

output is_flash;
output is_stall;
output [31:0] forward_data;
output [1:0] regdata_ctr;


if(exmem_rd == rs1 or memwb_rd == rs1)begin//update rs1data
  regdata_ctr = 2'b00;
end else if(exmem_rd == rs2 or memwb_rd == rs2)begin// update rs2data
  regdata_ctr = 2'b11;
end else begin
  regdata_ctr = 2'b01;
end


if((exmem_rd == rs1 or exmem_rd == rs2) and (exmem_opcode == 7'b0000011))begin
  is_stall = 1'b1;
end else begin
  is_stall = 1'b0;
end


if((exmem_rd == rs1 or exmem_rd == rs2) and (exmem_opcode == 7'b0110111))begin
  forward_data = exmem_imm;
end else if((exmem_rd == rs1 or exmem_rd == rs2) and (exmem_opcode == 7'b0010111))begin
  forward_data = exmem_pcPlusOffset;
end else if((exmem_rd == rs1 or exmem_rd == rs2) and (exmem_opcode == 7'b1101111 or exmem_opcode == 7'b1100111))begin
  forward_data = exmem_pcPlusFour;
end else if((exmem_rd == rs1 or exmem_rd == rs2) and (exmem_opcode == 7'b0110011 or exmem_opcode == 7'b0010011))begin
  forward_data = exmem_aluOutData;
end else if ((memwb_rd == rs1 or memwb_rd == rs2) and (memwb_opcode == 7'b0000011))begin
  forward_data = memwb_memdata;
end 


if(exmem_branch && exmem_pcctr)begin
  is_flash = 1;
end else begin
  is_flash = 0;
end

endmodule