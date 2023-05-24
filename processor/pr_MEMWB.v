module memwb(opcode, mem_to_reg, plusOffset_out_data, alu_out_data, imm, mem_data, plusFour_out_data)

inout [6:0] opcode;
inout mem_to_reg;
inout [31:0] plusOffset_out_data;
inout [31:0] alu_out_data;
inout [31:0] imm;
inout [31:0] plusFour_out_data;
inout [31:0] mem_data;

endmodule