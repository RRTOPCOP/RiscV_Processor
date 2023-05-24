`include "pc.v"
`include "adder_pcPlusFour.v"

module if_stage(clk, rst, pc_in_data, plusFour_out_data, order_data, pc_out_data)

input clk;
input rst;
input [31:0] pc_in_data;
output [31:0] plusFour_out_data;  //to ex, wb
output [31:0] order_data;         //to id
output [31:0] pc_out_data;        //to ex


//pc
pc u_pc (
  .pc_in_data(pc_in_data),
  .clk(clk),
  .rst(rst),
  .pc_out_data(pc_out_data),
);

//adder_pcPlusFour
adder_pcPlusFour u_adder_pcPlusFour (
  .pc(pc_out_data),
  .plusFour_out_data(plusFour_out_data)
);


endmodule