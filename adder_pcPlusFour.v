module adder_pcPlusFour (pc, plusFour_out_data);
  input [31:0] pc;
  output [31:0] plusFour_out_data;

  assign plusFour_out_data = pc + 32'b00000000000000000000000000000100;


endmodule