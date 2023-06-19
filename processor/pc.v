module pc (pc_in_data, clk, rst, pc_ctr, is_stall, pc_out_data);
input [31:0] pc_in_data; 
input clk; 
input rst; 
input pc_ctr;
input is_stall;

integer stall_count = 0;

output reg [31:0] pc_out_data = 32'b0; //to order_mem


always @ (posedge clk or negedge rst) begin
  if(~rst) begin
    pc_out_data <= 32'b00000000000000010000000000000000;
  end else if(is_stall && (stall_count == 0)) begin 
    pc_out_data <= pc_out_data;
    stall_count <= 1;
  end else if(stall_count == 1) begin
    pc_out_data <= pc_out_data + 32'b00000000000000000000000000000100;
    stall_count <= 0;
  end else if(pc_ctr) begin
    pc_out_data <= pc_in_data;
  end else if(~pc_ctr) begin
    pc_out_data <= pc_out_data + 32'b00000000000000000000000000000100;
end
end

endmodule