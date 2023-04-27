module mux_jalr (jalr, alu_out, mux_out, muxJalr_out_data);
  input  jalr; //from decoder
  input [31:0] alu_out; //from alu
  input [31:0] mux_out; //from mux_pcsrc
  output [31:0] muxJalr_out_data; //to pc

  assign muxJalr_out_data = outdata(jalr, alu_out, mux_out);

  //function for muxJalr_out_data
  function [31:0] outdata;

  input  jalr;
  input [31:0] alu_out;
  input [31:0] mux_out;

  if (jalr == 1) begin
    outdata = alu_out;
  end else begin
    outdata = mux_out;
  end

  endfunction

endmodule