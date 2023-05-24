module mux_alu (alu_src, imm, reg_data, muxAlu_out_data);

input  alu_src; //from decoder
input [31:0] imm; //from decoder
input [31:0] reg_data; //from register
output [31:0] muxAlu_out_data; //to alu

assign muxAlu_out_data = outdata(alu_src, imm, reg_data);

//function for muxAlu_out_data
function [31:0] outdata;
  input  alu_src;
  input [31:0] imm;
  input [31:0] reg_data;

  if (alu_src == 1) begin
    outdata = imm;
  end else begin
    outdata = reg_data;
  end

endfunction

endmodule