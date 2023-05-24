module mux_pcsrc (pc_ctr, pc_plus_four, pc_plus_offset, muxPcSrc_out_data);
  input  pc_ctr; // from pc_src
  input [31:0] pc_plus_four, pc_plus_offset;
  output [31:0] muxPcSrc_out_data; //to mux_jalr


  assign muxPcSrc_out_data = pcInData(pc_ctr, pc_plus_four, pc_plus_offset);

  //function for muxPcSrc_out_data
  function [31:0] pcInData;
  
  input  pc_ctr;
  input [31:0] pc_plus_four, pc_plus_offset;

  if (pc_ctr == 1) begin
    pcInData = pc_plus_offset; 
  end else begin
    pcInData = pc_plus_four;
  end

  endfunction

endmodule