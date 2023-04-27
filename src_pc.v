module pc_src (branch, jump, funct3, zero, u_slt, s_slt, pc_ctr);
  input  branch, jump; //from decoder
  input zero, u_slt, s_slt; //from ALU
  input[2:0] funct3; //from decoder
  output  pc_ctr; //to mux_pcsrc

  assign pc_ctr = pcctr(branch, jump, funct3, zero, u_slt, s_slt);

  //function for pc_ctr
  function  pcctr;

    input  branch;
    input  jump;
    input [2:0] funct3;
    input  zero;
    input  u_slt;
    input  s_slt;

    //jump or branch
    if (jump == 1) begin
      pcctr = 1;
    end else if(branch == 1) begin

      case(funct3)
      3'b000: pcctr = zero; //beq
      3'b001: pcctr = ~zero; //bne
      3'b100: pcctr = s_slt; //blt
      3'b101: pcctr = ~s_slt; //bge
      3'b110: pcctr = u_slt; //bltu
      3'b111: pcctr = ~u_slt; //bgeu
      endcase

    end 
    
  endfunction

endmodule