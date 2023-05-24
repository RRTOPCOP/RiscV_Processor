module exmem(reg_data2, imm, opcode, mem_to_reg, mem_read, mem_write, plusFour_out_data, alu_out_data, plusOffset_out_data)

inout [31:0] reg_data2;
inout [31:0] imm;
inout [6:0] opcode;
inout mem_to_reg;
inout mem_read;
inout mem_write;
inout plusFour_out_data;
inout alu_out_data;
inout plusOffset_out_data;

endmodule