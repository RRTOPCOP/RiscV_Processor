`include "../rv32i_decoder.v"


module decoder_test;
//variable definition
reg [31:0] instruction;
wire [6:0] opcode;
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
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




endmodule