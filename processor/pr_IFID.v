module ifid(clk, ifid_order_in, ifid_pc_in, ifid_plusfour_in, is_stall, is_flash, ifid_order_out, ifid_pc_out, ifid_plusfour_out);

input clk;
input [31:0] ifid_order_in;
input [31:0] ifid_pc_in;
input [31:0] ifid_plusfour_in;
input is_flash;
input is_stall;//from hazardCtr

output reg [31:0] ifid_order_out = 32'b0;
output reg [31:0] ifid_pc_out = 32'b0;
output reg [31:0] ifid_plusfour_out = 32'b0;

integer stall_count = 0;

always @ (posedge clk) begin
  if(is_stall && (stall_count == 0)) begin
    ifid_order_out <= ifid_order_out;
    ifid_pc_out <= ifid_pc_out;
    ifid_plusfour_out <= ifid_plusfour_out;
    stall_count <= 1;
  end else if(stall_count == 1) begin
    ifid_order_out <= ifid_order_in;
    ifid_pc_out <= ifid_pc_in;
    ifid_plusfour_out <= ifid_plusfour_in;
    stall_count <= 0;
  end else if(is_flash) begin
    ifid_order_out <= 32'b0;
    ifid_pc_out <= ifid_pc_in;
    ifid_plusfour_out <= 32'b0;
  end else begin
    ifid_order_out <= ifid_order_in;
    ifid_pc_out <= ifid_pc_in;
    ifid_plusfour_out <= ifid_plusfour_in;
  end

end

endmodule