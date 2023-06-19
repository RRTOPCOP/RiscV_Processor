module hazardCtr(clk, id_rs1_out, id_rs2_out, idex_rd_out, exmem_rd_out, id_opcode_out, idex_opcode_out, exmem_opcode_out,idex_imm_out, exmem_imm_out, idex_plusfour_out, exmem_plusfour_out, ex_plusimm_out, exmem_plusimm_out, ex_aluout_out, exmem_aluout_out, DDT, exmem_branch, exmem_pcctr, id_jump_out, id_jalr_out, idex_jump_out, idex_jalr_out, ifid_pc_out, idex_pc_out, exmem_pc_out, is_stall, is_flash, pc_stall, forward_data1, forward_data2, regdata1_ctr, regdata2_ctr);

input clk;
input [4:0] id_rs1_out;
input [4:0] id_rs2_out;
input [4:0] idex_rd_out;
input [4:0] exmem_rd_out;
input [6:0] id_opcode_out;
input [6:0] idex_opcode_out;
input [6:0] exmem_opcode_out;
input [31:0] idex_imm_out;
input [31:0] exmem_imm_out;
input [31:0] idex_plusfour_out;
input [31:0] exmem_plusfour_out;
input [31:0] ex_plusimm_out;
input [31:0] exmem_plusimm_out;
input [31:0] ex_aluout_out;
input [31:0] exmem_aluout_out;
input exmem_branch;
input exmem_pcctr;
input [31:0] DDT;
input id_jump_out;
input id_jalr_out;
input idex_jalr_out;
input idex_jump_out;
input [31:0] idex_pc_out;
input [31:0] exmem_pc_out;
input [31:0] ifid_pc_out;


output is_flash;
output is_stall;
output pc_stall;
output reg [31:0] forward_data1;
output reg [31:0] forward_data2;
output regdata1_ctr;
output regdata2_ctr;


assign regdata1_ctr =((id_rs1_out != 5'b0) && ((id_opcode_out != 7'b0110111) && (id_opcode_out != 7'b0010111) && (id_opcode_out != 7'b1101111) && (((idex_rd_out == id_rs1_out) && (ifid_pc_out != idex_pc_out) && (idex_opcode_out != 7'b1100011) && (idex_opcode_out != 7'b0100011)) || ((exmem_rd_out == id_rs1_out) && (exmem_opcode_out != 7'b1100011) && (exmem_opcode_out != 7'b0100011)))));

assign regdata2_ctr = ((id_rs2_out != 5'b0) && ((id_opcode_out != 7'b0110111) && (id_opcode_out != 7'b0010111) && (id_opcode_out != 7'b1101111) && (id_opcode_out != 7'b1100111) && (id_opcode_out != 7'b0000011) && (id_opcode_out != 7'b0010011) && (id_opcode_out != 7'b0010111) && (((idex_rd_out == id_rs2_out) && (ifid_pc_out != idex_pc_out) && (idex_opcode_out != 7'b1100011) && (idex_opcode_out != 7'b0100011)) || ((exmem_rd_out == id_rs2_out) && (exmem_opcode_out != 7'b1100011) && (exmem_opcode_out != 7'b0100011)))));

assign is_stall = isStall(idex_rd_out, id_rs1_out, id_rs2_out, idex_opcode_out);
assign is_flash = ((ifid_pc_out != idex_pc_out) && exmem_pcctr);
assign pc_stall = (id_jump_out || id_jalr_out || idex_jump_out || idex_jalr_out);


always @ (posedge clk) begin

//forward_data1
  if ((exmem_rd_out == id_rs1_out) && (exmem_opcode_out == 7'b0000011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= DDT;
    
  end else if((idex_rd_out == id_rs1_out) && (idex_opcode_out == 7'b0110111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= idex_imm_out;
    
  end else if((idex_rd_out == id_rs1_out) && (idex_opcode_out == 7'b0010111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= ex_plusimm_out;
    
  end else if((idex_rd_out == id_rs1_out) && (idex_opcode_out == 7'b1101111 || idex_opcode_out == 7'b1100111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= idex_plusfour_out;
    
  end else if((idex_rd_out == id_rs1_out) && (idex_opcode_out == 7'b0110011 || idex_opcode_out == 7'b0010011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out))) begin
    forward_data1 <= ex_aluout_out;
    
  end else if((exmem_rd_out == id_rs1_out) && (exmem_opcode_out == 7'b0110111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= exmem_imm_out;
    
  end else if((exmem_rd_out == id_rs1_out) && (exmem_opcode_out == 7'b0010111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= exmem_plusimm_out;
    
  end else if((exmem_rd_out == id_rs1_out) && (exmem_opcode_out == 7'b1101111 || exmem_opcode_out == 7'b1100111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data1 <= exmem_plusfour_out;
    
  end else if((exmem_rd_out == id_rs1_out) && (exmem_opcode_out == 7'b0110011 || exmem_opcode_out == 7'b0010011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out))) begin
    forward_data1 <= exmem_aluout_out;
    
  end else begin
    forward_data1 <= forward_data1;

  end



//forward_data2
  if ((exmem_rd_out == id_rs2_out) && (exmem_opcode_out == 7'b0000011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= DDT;
    
  end else if((idex_rd_out == id_rs2_out) && (idex_opcode_out == 7'b0110111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= idex_imm_out;
    
  end else if((idex_rd_out == id_rs2_out) && (idex_opcode_out == 7'b0010111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= ex_plusimm_out;
    
  end else if((idex_rd_out == id_rs2_out) && (idex_opcode_out == 7'b1101111 || idex_opcode_out == 7'b1100111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= idex_plusfour_out;
    
  end else if((idex_rd_out == id_rs2_out) && (idex_opcode_out == 7'b0110011 || idex_opcode_out == 7'b0010011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out))) begin
    forward_data2 <= ex_aluout_out;
    
  end else if((exmem_rd_out == id_rs2_out) && (exmem_opcode_out == 7'b0110111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= exmem_imm_out;
    
  end else if((exmem_rd_out == id_rs2_out) && (exmem_opcode_out == 7'b0010111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= exmem_plusimm_out;
    
  end else if((exmem_rd_out == id_rs2_out) && (exmem_opcode_out == 7'b1101111 || exmem_opcode_out == 7'b1100111) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out)))begin
    forward_data2 <= exmem_plusfour_out;
    
  end else if((exmem_rd_out == id_rs2_out) && (exmem_opcode_out == 7'b0110011 || exmem_opcode_out == 7'b0010011) && ((idex_pc_out != exmem_pc_out ) || (ifid_pc_out != idex_pc_out))) begin
    forward_data2 <= exmem_aluout_out;
    
  end else begin
    forward_data2 <= forward_data2;
  end

end


//function for isStall
function isStall;
  input [4:0] exmem_rd;
  input [4:0] rs1;
  input [4:0] rs2;
  input [6:0] exmem_opcode;


if((exmem_rd == rs1 || exmem_rd == rs2) && (exmem_opcode == 7'b0000011))begin
  isStall = 1'b1;
end else begin
  isStall = 1'b0;
end
endfunction


endmodule