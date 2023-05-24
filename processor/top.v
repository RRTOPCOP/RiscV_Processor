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




always @(posedge clk) begin
  //IF
  u_if_stage.pc_in_data <= u_ex.pc_in_data;
  //IF to IFID
  u_ifid.order_data <= u_if_stage.order_data;
  u_ifid.pc_out_data <= u_if_stage.pc_out_data;
  u_ifid.plusFour_out_data <= u_if_stage.plusFour_out_data;
  //IFID to ID
  u_id.order_data <= u_ifid.order_data;
  u_id.srcMem_out_data <= u_wb.srcMem_out_data;
  

  
end











assign DDT = reg_data2; //write in mem
assign mem_data = DDT; //write in register from mem
assign IAD = pc_out_data;
assign DAD = alu_out_data;
assign MREQ = mem_read || mem_write;
assign WRITE = mem_write;
assign IACK_n = 1;
assign SIZE = size(funct3);



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


//variable definition
wire [31:0] pc_in_data; //mux_jalr to pc
wire [31:0] pc_out_data; //pc to order_mem, adder_pcPlusOffset, adder_pcPlusFour
wire [31:0] order_data; //order_mem to decoder
  //field in order_data
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [31:0] imm;
  wire [2:0] alu_op;
  wire  reg_write;
  wire  alu_src;
  wire  jump;
  wire  mem_to_reg;
  wire  mem_read;
  wire  mem_write;
  wire  branch;
  wire  jalr;
wire [31:0] plusFour_out_data; //adder_pcPlusFour to mux_pcsrc, src_mem
wire [31:0] plusOffset_out_data; //adder_pcPlusOffset to mux_pcsrc, src_mem
wire [31:0] reg_data1; //register to alu
wire [31:0] reg_data2; //register to mux_alu, mem
  //output from alu
  wire [31:0] alu_out_data; // alu to mem, mux_jalr, src_mem
  wire  zero; // alu to src_pc
  wire  overflow;
wire [31:0] mem_data; // mem to src_mem
wire [31:0] srcMem_out_data; // src_mem to register



//*** modules ***//

//IF
if_stage u_if_stage(
  .clk(clk),
  .rst(rst),
  .pc_in_data(pc_in_data),
  .plusFour_out_data(plusFour_out_data),
  .order_data(order_data),
  .pc_out_data(pc_out_data)
);

//IFID
ifid u_ifid(
  .order_data(order_data),
  .pc_out_data(plusFour_out_data),
  .plusFour_out_data(plusFour_out_data)
);

//ID
id u_id(
  .clk(clk),
  .rst(rst),
  .order_data(order_data),
  .srcMem_out_data(srcMem_out_data),
  .reg_data1(reg_data1),
  .reg_data2(reg_data2),
  .imm(imm),
  .opcode(opcode),
  .funct3(funct3),
  .alu_op(alu_op),
  .alu_src(alu_src),
  .jump(jump),
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .branch(branch),
  .jalr(jalr)
);

//IDEX
idex u_idex(
  .pc_out_data(pc_out_data),
  .plusFour_out_data(plusFour_out_data),
  .reg_data1(reg_data1),
  .reg_data2(reg_data2),
  .imm(imm),
  .opcode(opcode),
  .funct3(funct3),
  .alu_op(alu_op),
  .alu_src(alu_src),
  .jump(jump),
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .branch(branch),
  .jalr(jalr)
);

//EX
ex u_ex(
  .plusFour_out_data(plusFour_out_data),
  .pc_out_data(pc_out_data),
  .imm(imm),
  .reg_data1(reg_data1),
  .reg_data2(reg_data2),
  .funct3(funct3),
  .jump(jump),
  .branch(branch),
  .alu_op(alu_op),
  .jalr(jalr),
  .alu_src(alu_src),
  .pc_in_data(pc_in_data),
  .alu_out_data(alu_out_data),
  .plusOffset_out_data(plusOffset_out_data),
  .zero(zero),
  .overflow(overflow)
);

//EXMEM
exmem u_exmem(
  .reg_data2(reg_data2),
  .imm(imm),
  .opcode(opcode),
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .plusFour_out_data(plusFour_out_data),
  .alu_out_data(alu_out_data),
  .plusOffset_out_data(plusOffset_out_data)
);

//MEMWB
memwb u_memwb(
  .opcode(opcode),
  .mem_to_reg(mem_to_reg),
  .plusOffset_out_data(plusOffset_out_data),
  .alu_out_data(alu_out_data),
  .imm(imm),
  .plusFour_out_data(plusFour_out_data),
  .mem_data(mem_data)
);

//WB
wb u_wb(
  .mem_to_reg(mem_to_reg),
  .plusOffset_out_data(plusOffset_out_data),
  .imm(imm),
  .plusFour_out_data(plusFour_out_data),
  .mem_data(mem_data),
  .alu_out_data(alu_out_data),
  .srcMem_out_data(srcMem_out_data)
);


endmodule