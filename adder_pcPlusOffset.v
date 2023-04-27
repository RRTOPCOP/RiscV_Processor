module adder_pcPlusOffset (pc, offset, plusOffset_out_data);
input [31:0] pc;
input [31:0] offset; //from decoder (imm)
output [31:0] plusOffset_out_data; 

assign plusOffset_out_data = pc + offset;

endmodule