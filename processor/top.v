`include "stage_IF.v"
`include "stage_ID.v"
`include "stage_EX.v"
`include "stage_WB.v"
`include "pr_IFID.v"
`include "pr_IDEX.v"
`include "pr_EXMEM.v"
`include "pr_MEMWB.v"


module top (clk, rst, ACKD_n, ACKI_n, IDT, OINT_n, IAD, DAD, MREQ, WRITE, SIZE, IACK_n, DDT);

input  clk;
input  rst;
input  ACKD_n; // is zero when the signal is unstable (data.mem) ***
input  ACKI_n; // is zero when the signal is unstable (inst.mem) ***
input [31:0] IDT; // instruction data (= order_data)
input [2:0] OINT_n; //whether there is interruption(yes -> 0)       ***
inout [31:0] DDT; // sw(top(register) to mem) reg_data2, lw(mem to top(register)) mem_data
output [31:0] IAD; // instruction address data(pc_out_data)
output [31:0] DAD; // data address data(alu_out_data)
output  MREQ; // mem_read
output  WRITE; // mem_write
output [1:0] SIZE; // data width                                    
output  IACK_n; // processor status (ok -> 1)                    


//function for SIZE
function [1:0] size;
  input [2:0] funct3;

  case(funct3)
  3'b0,
  3'b100: size = 2'b11; //byte
  3'b001,
  3'b101: size = 2'b01; //half
  3'b010: size = 2'b00; //word
  endcase

endfunction




//*** modules ***//

//hazard_ctr
wire is_stall;
wire is_flash;
wire [31:0] forward_data;
wire[1:0] regdata_ctr;

hazard_ctr u_hazard_ctr(
  .rs1(id_rs1_out),
  .rs2(id_rs2_out),
  .exmem_rd(idex_rd_out),
  .memwb_rd(exmem_rd_out),
  .exmem_opcode(idex_opcode_out),
  .memwb_opcode(exmem_opcode_out),
  .exmem_imm(idex_imm_out),
  .exmem_pcPlusFour(idex_plusfour_out),
  .exmem_pcPlusOffset(ex_plusimm_out),
  .memwb_memdata(DDT),
  .exmem_branch(idex_branch_out),
  .exmem_pcctr(ex_pcctr_out),
  .is_stall(is_stall),
  .is_flash(is_flash),
  .forward_data(forward_data),
  .regdata_ctr(regdata_ctr)
);


//IF
wire [31:0] if_plusfour_out;
wire [31:0] if_order_out;
wire [31:0] if_pc_out;

if_stage u_if_stage(
  .clk(clk),
  .rst(rst),
  .is_stall(is_stall),
  .pc_in_data(exmem_pcnext_out),
  .plusFour_out_data(if_plusfour_out),
  .order_data(if_order_out),
  .pc_out_data(if_pc_out)
);


//IFID
wire [31:0] ifid_order_out;
wire [31:0] ifid_pc_out;
wire [31:0] ifid_plusfour_out;

ifid u_ifid(
  .clk(clk),
  .ifid_order_in(if_order_out),
  .ifid_pc_in(if_pc_out),
  .ifid_plusfour_in(if_plusfour_out),
  .is_stall(is_stall),
  .is_flash(is_flash),
  .ifid_order_out(ifid_order_out),
  .ifid_pc_out(ifid_pc_out),
  .ifid_plusfour_out(ifid_plusfour_out)
);


//ID
wire [31:0] id_imm_out;
wire [31:0] id_regdata1_out;
wire [31:0] id_regdata2_out;
wire [6:0] id_opcode_out;
wire [2:0] id_funct3_out;
wire [2:0] id_aluop_out;
wire id_alusrc_out;
wire id_jump_out;
wire id_regwrite_out;
wire id_memtoreg_out;
wire id_memread_out;
wire id_memwrite_out;
wire id_branch_out;
wire id_jalr_out;
wire id_regwrite_out;
wire id_rd_out;

id u_id(
  .clk(clk),
  .rst(rst),
  .order_data(ifid_order_out),
  .memwb_rd(memwb_rd_out),
  .memwb_regwrite(memwb_regwirte_out),
  .srcMem_out_data(srcMem_out_data),
  .imm(id_imm_out),
  .reg_data1(id_regdata1_out),
  .reg_data2(id_regdata2_out),
  .rs1(id_rs1_out),
  .rs2(id_rs2_out),
  .opcode(id_opcode_out),
  .funct3(id_funct3_out),
  .aluop(id_aluop_out),
  .alusrc(id_alusrc_out),
  .jump(id_jump_out),
  .mem_to_reg(id_memtoreg_out),
  .mem_read(id_memread_out),
  .mem_write(id_memwrite_out),
  .branch(id_branch_out),
  .jalr(id_jalr_out),
  .reg_write(id_regwrite_out),
  .decode_rd(id_rd_out)
);


//IDEX
wire [31:0] idex_pc_out;
wire [31:0] idex_plusfour_out;
wire [31:0] idex_regdata1_out;
wire [31:0] idex_regdata2_out;
wire [31:0] idex_imm_out;
wire [4:0] idex_rs1_out;
wire [4:0] idex_rs2_out;
wire [4:0] idex_rd_out;
wire [6:0] idex_opcode_out;
wire [2:0] idex_funct3_out;
wire [2:0] idex_aluop_out;
wire idex_alusrc_out;
wire idex_regwrite_out;
wire idex_jump_out;
wire idex_memtoreg_out;
wire idex_memread_out;
wire idex_memwrite_out;
wire idex_branch_out;
wire idex_jalr_out;

idex u_idex(
  .clk(clk),
  .idex_pc_in(ifid_pc_out),
  .idex_plusfour_in(ifid_plusfour_out),
  .idex_regdata1_in(id_regdata1_out),
  .idex_regdata2_in(id_regdata2_out),
  .idex_imm_in(id_imm_out),
  .idex_rs1_in(id_rs1_out),
  .idex_rs2_in(id_rs2_out),
  .idex_rd_in(id_rd_out),
  .idex_opcode_in(id_opcode_out),
  .idex_funct3_in(id_funct3_out),
  .idex_aluop_in(id_aluop_out),
  .idex_alusrc_in(id_alusrc_out),
  .idex_jump_in(id_jump_out),
  .idex_regwrite_in(id_regwrite_out),
  .idex_memtoreg_in(id_memtoreg_out),
  .idex_memread_in(id_memread_out),
  .idex_memwrite_in(id_memwrite_out),
  .idex_branch_in(id_branch_out),
  .idex_jalr_in(id_jalr_out),
  .is_flash(is_flash),
  .forward_data(forward_data),
  .regdata_ctr(regdata_ctr),
  .idex_pc_out(idex_pc_out),
  .idex_plusfour_out(idex_plusfour_out),
  .idex_regdata1_out(idex_regdata1_out),
  .idex_regdata2_out(idex_regdata2_out),
  .idex_imm_out(idex_imm_out),
  .idex_rs1_out(idex_rs1_out),
  .idex_rs2_out(idex_rs2_out),
  .idex_rd_out(idex_rd_out),
  .idex_opcode_out(idex_opcode_out),
  .idex_funct3_out(idex_funct3_out),
  .idex_aluop_out(idex_aluop_out),
  .idex_alusrc_out(idex_alusrc_out),
  .idex_jump_out(idex_jump_out),
  .idex_regwrite_out(idex_regwrite_out),
  .idex_memtoreg_out(idex_memtoreg_out),
  .idex_memread_out(idex_memread_out),
  .idex_memwrite_out(idex_memwrite_out),
  .idex_branch_out(idex_branch_out),
  .idex_jalr_out(idex_jalr_out)
  );


//EX
wire [31:0] ex_pcnext_out;
wire [31:0] ex_aluout_out;
wire [31:0] ex_plusimm_out;
wire ex_pcctr_out;
wire zero;
wire overflow;

ex u_ex(
  .plusFour_out_data(idex_plusfour_out),
  .pc_out_data(idex_pc_out),
  .imm(idex_imm_out),
  .reg_data1(idex_regdata1_out),
  .reg_data2(idex_regdata2_out),
  .funct3(idex_funct3_out),
  .jump(idex_jump_out),
  .branch(idex_branch_out),
  .alu_op(idex_aluop_out),
  .alu_src(idex_alusrc_out),
  .jalr(idex_jalr_out),
  .pc_in_data(ex_pcnext_out),
  .alu_out_data(ex_aluout_out),
  .plusOffset_out_data(ex_plusimm_out),
  .pc_ctr(ex_pcctr_out),
  .zero(zero),
  .overflow(overflow)
);


//EXMEM
wire [31:0] exmem_pc_out;
wire [31:0] exmem_pcnext_out;
wire [31:0] exmem_aluout_out;
wire [31:0] exmem_imm_out;
wire [31:0] exmem_regdata2_out;
wire [31:0] exmem_plusfour_out;
wire [31:0] exmem_plusimm_out;
wire [4:0] exmem_rd_out;
wire exmem_regwrite_out;
wire exmem_memtoreg_out;
wire [6:0] exmem_opcode_out;
wire [2:0] exmem_funct3_out;
wire exmem_memwrite_out;
wire exmem_memread_out;
wire exmem_branch_out;
wire exmem_pcctr_out;

exmem u_exmem(
  .clk(clk),
  .exmem_pc_in(idex_pc_out),
  .exmem_pcnext_in(ex_pcnext_out),
  .exmem_aluout_in(ex_aluout_out),
  .exmem_imm_in(idex_imm_out),
  .exmem_regdata2_in(idex_regdata2_out),
  .exmem_plusfour_in(idex_plusfour_out),
  .exmem_plusimm_in(ex_plusimm_out),
  .exmem_rd_in(idex_rd_out),
  .exmem_regwrite_in(idex_regwrite_out),
  .exmem_memtoreg_in(idex_memtoreg_out),
  .exmem_opcode_in(idex_opcode_out),
  .exmem_funct3_in(idex_funct3_out),
  .exmem_memwrite_in(idex_memwrite_out),
  .exmem_memread_in(idex_memread_out),
  .exmem_branch_in(idex_branch_out),
  .exmem_pcctr_in(ex_pcctr_out),
  .exmem_pc_out(exmem_pc_out),
  .exmem_pcnext_out(exmem_pcnext_out),
  .exmem_aluout_out(exmem_aluout_out),
  .exmem_imm_out(exmem_imm_out),
  .exmem_regdata2_out(exmem_regdata2_out),
  .exmem_plusfour_out(exmem_plusfour_out),
  .exmem_plusimm_out(exmem_plusimm_out),
  .exmem_rd_out(exmem_rd_out),
  .exmem_regwrite_out(exmem_regwrite_out),
  .exmem_memtoreg_out(exmem_memtoreg_out),
  .exmem_opcode_out(exmem_opcode_out),
  .exmem_funct3_out(exmem_funct3_out),
  .exmem_memwrite_out(exmem_memwrite_out),
  .exmem_memread_out(exmem_memread_out),
  .exmem_branch_out(exmem_branch_out),
  .exmem_pcctr_out(exmem_pcctr_out)
);


//MEM
assign DDT = exmem_regdata2_out; //write in mem
assign IAD = exmem_pc_out;
assign DAD = exmem_aluout_out;
assign MREQ = exmem_memread_out || exmem_memwrite_out;
assign WRITE = exmem_memwrite_out;
assign IACK_n = 1;
assign SIZE = size(exmem_funct3_out);


//MEMWB
wire [31:0] memwb_pc_out;
wire [31:0] memwb_memdata_out;
wire [31:0] memwb_plusfour_out;
wire [31:0] memwb_plusimm_out;
wire [31:0] memwb_imm_out;
wire [31:0] memwb_aluout_out;
wire [4:0] memwb_rd_out;
wire memwb_regwrite_out;
wire memwb_memtoreg_out;
wire memwb_opcode_out;

memwb u_memwb(
  .clk(clk),
  .memwb_pc_in(exmem_pc_out),
  .memwb_memdata_in(DDT),
  .memwb_plusfour_in(exmem_plusfour_out),
  .memwb_plusimm_in(exmem_plusimm_out),
  .memwb_imm_in(exmem_imm_out),
  .memwb_aluout_in(exmem_aluout_out),
  .memwb_rd_in(exmem_rd_out),
  .memwb_regwrite_in(exmem_regwrite_out),
  .memwb_memtoreg_in(exmem_memtoreg_out),
  .memwb_opcode_in(exmem_opcode_out),
  .memwb_pc_out(memwb_pc_out),
  .memwb_memdata_out(memwb_memdata_out),
  .memwb_plusfour_out(memwb_plusfour_out),
  .memwb_plusimm_out(memwb_plusimm_out),
  .memwb_imm_out(memwb_imm_out),
  .memwb_aluout_out(memwb_aluout_out),
  .memwb_rd_out(memwb_rd_out),
  .memwb_regwrite_out(memwb_regwrite_out),
  .memwb_memtoreg_out(memwb_memtoreg_out),
  .memwb_opcode_out(memwb_opcode_out)
);


//WB
wire [31:0] srcMem_out_data;

wb u_wb(
  .opcode(memwb_opcode_out),
  .mem_to_reg(memwb_memtoreg_out),
  .plusOffset_out_data(memwb_plusimm_out),
  .imm(memwb_imm_out),
  .plusFour_out_data(memwb_plusfour_out),
  .mem_data(memwb_memdata_out),
  .alu_out_data(memwb_aluout_out),
  .srcMem_out_data(srcMem_out_data)
);


endmodule