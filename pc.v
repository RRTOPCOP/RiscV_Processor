module pc (pc_in_data, clk, rst, pc_out_data);
input [31:0] pc_in_data; //from mux_pcsrc
input   clk; //top module
input   rst; //top module
output reg [31:0] pc_out_data; //to order_mem

always @ (posedge clk or negedge rst) begin

  if (~rst) begin
    pc_out_data <= 32'b0;
  end else begin
    pc_out_data <= pc_in_data;
  end

end

endmodule