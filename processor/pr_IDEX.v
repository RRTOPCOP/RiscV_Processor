module idex(pc_out_data, plusFour_out_data, reg_data1, reg_data2, imm, opcode, funct3, alu_op, alu_src, jump, mem_to_reg, mem_read, mem_write, branch, jalr)

inout [31:0] pc_out_data;
inout [31:0] plusFour_out_data;
inout [31:0] reg_data1;
inout [31:0] reg_data2;
inout [31:0] imm;
inout [6:0] opcode;
inout [2:0] funct3;
inout [2:0] alu_op;
inout alu_src;
inout jump;
inout jalr;
inout mem_to_reg;
inout mem_read;
inout mem_write;
inout branch;


endmodule