`include "adder_pcPlusOffset.v"
`include "mux_pcsrc.v"
`include "mux_jalr.v"
`include "mux_alu.v"
`include "src_pc.v"
`include "alu32_func.v"


module ex(plusFour_out_data, pc_out_data, imm, reg_data1, reg_data2, funct3, jump, branch, alu_op, alu_src, jalr, pc_in_data, alu_out_data, plusOffset_out_data, zero, overflow)

input [31:0] plusFour_out_data;
input [31:0] pc_out_data;
input [31:0] imm;
input [31:0] reg_data1;
input [31:0] reg_data2;
input [2:0] funct3;
input jump;
input branch;
input alu_op;
input jalr;
input alu_src;
output [31:0] pc_in_data;             //to pc
output [31:0] alu_out_data;           //to mem, wb
output [31:0] plusOffset_out_data;    //to wb
output zero;
output overflow;

wire [31:0] muxAlu_out_data;
wire u_slt;
wire s_slt;
wire pc_ctr;
wire [31:0] muxPcSrc_out_data;


//adder_pcPlusOffset
adder_pcPlusOffset u_adder_pcPlusOffset (
  .pc(pc_out_data),
  .offset(imm),
  .plusOffset_out_data(plusOffset_out_data)
);

//mux_alu
mux_alu u_mux_alu (
  .alu_src(alu_src),
  .imm(imm),
  .reg_data(reg_data2),
  .muxAlu_out_data(muxAlu_out_data)
);

//alu
alu u_alu (
  .dataA(reg_data1),
  .dataB(muxAlu_out_data),
  .alu_op(alu_op),
  .alu_out_data(alu_out_data),
  .zero(zero),
  .overflow(overflow),
  .u_slt(u_slt),
  .s_slt(s_slt)
);

//src_pc
pc_src u_pc_src (
  .branch(branch),
  .jump(jump),
  .funct3(funct3),
  .zero(zero),
  .u_slt(u_slt),
  .s_slt(s_slt),
  .pc_ctr(pc_ctr)
);

//mux_pcsrc
mux_pcsrc u_mux_pcsrc (
  .pc_ctr(pc_ctr),
  .pc_plus_four(plusFour_out_data),
  .pc_plus_offset(plusOffset_out_data),
  .muxPcSrc_out_data(muxPcSrc_out_data)
);

//mux_jalr
mux_jalr u_mux_jalr (
  .jalr(jalr),
  .alu_out(alu_out_data),
  .mux_out(muxPcSrc_out_data),
  .muxJalr_out_data(pc_in_data)
);



endmodule