module src_mem (opcode, mem_to_reg, pc_plus_imm, imm,  pc_plus_four, mem_data, alu_data, srcMem_out_data);

input [6:0] opcode; //from decoder
input  mem_to_reg; //from decoder
input [31:0] pc_plus_imm; //from adder_pcPlusOffset
input [31:0] imm; //from decoder
input [31:0] pc_plus_four; //from adder_pcPlusFour
input [31:0] mem_data; //from mem
input [31:0] alu_data; //from alu
output [31:0] srcMem_out_data; //to register

assign srcMem_out_data = outdata(opcode, mem_to_reg, pc_plus_imm, imm, pc_plus_four, mem_data, alu_data);

//function for srcMem_out_data
function [31:0] outdata;

input [6:0] opcode;
input  mem_to_reg;
input [31:0] pc_plus_imm; 
input [31:0] imm;
input [31:0] pc_plus_four; 
input [31:0] mem_data; 
input [31:0] alu_data; 


  if (mem_to_reg == 1) begin
    //Iformat(lw)
    outdata = mem_data;
  end else begin
    case(opcode)
    //lui
    7'b0110111: outdata = imm;
    //auipc
    7'b0010111: outdata = pc_plus_imm;
    //Rformat,Iformat(immidiate)
    7'b0110011,
    7'b0010011: outdata = alu_data;
    //jal,jalr
    7'b1101111,
    7'b1100111: outdata = pc_plus_four;
    endcase
  end
  
endfunction
  
endmodule