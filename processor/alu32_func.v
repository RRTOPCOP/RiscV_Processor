module alu (dataA, dataB, alu_op, alu_out_data, zero, overflow, u_slt, s_slt);
  input [31:0] dataA, dataB;
  input [2:0] alu_op;
  output [31:0] alu_out_data;
  output  zero, overflow, u_slt, s_slt;

  assign alu_out_data = result(dataA, dataB, alu_op);
  assign zero = (alu_out_data == 32'b0);
  assign overflow = ((dataA[31] == dataB[31])&&(alu_out_data[31] != dataA[31]));
  assign u_slt = ((alu_op == 3'b001)&&(dataA < dataB));
  assign s_slt = (alu_op == 3'b001)&&((dataA[31] == dataB[31]) ? u_slt : ~u_slt);


  //function for alu_out_data
  function [31:0] result;
    input [31:0] A, B;
    input [2:0] ctrl;

    case (ctrl)
        3'b000: result = A + B; //ADD
        3'b001: result = A - B; //SUB
        3'b010: result = A | B; //OR
        3'b100: result = A & B; //AND
        3'b011: result = A ^ B; //XOR
        3'b101: result = A >>> B; //shift A right by B
        3'b110: result = A >> B; //logical shift A right by B 
        3'b111: result = A << B; //logical shift A left by B
        default: result = 32'b0;
    endcase
    
  endfunction
      
endmodule