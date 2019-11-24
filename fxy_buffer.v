module fxy_buffer(
		i_clk,
		i_reset,
		iv_fx,
		iv_fy,
		i_fsyn,
		i_hsyn,
		i_hsyn_r,
		iv_b11,
		iv_b12,
		iv_b21,
		iv_b22,
		
		o_hsyn,
		ov_fx,
		ov_fy,
		ov_b11,
		ov_b12,
		ov_b21,
		ov_b22
		);
		
input i_clk,i_reset;
input [10:0] iv_fx,iv_fy;
input i_fsyn,i_hsyn;
input i_hsyn_r;
input [15:0] iv_b11,iv_b12,iv_b21,iv_b22;

output o_hsyn;
output [10:0] ov_fx,ov_fy;
output [15:0] ov_b11,ov_b12,ov_b21,ov_b22;
		

fxy_fifo fxy_fifo (
    .clk(i_clk),
    .rst(i_reset),
    .wr_en(i_hsyn),
    .wr_data({iv_fx,iv_fy}),
    .wr_full(),
    .almost_full(),
    .rd_en(i_hsyn_r),
    .rd_data({ov_fx,ov_fy}),
    .rd_empty(),
    .almost_empty());
		
reg o_hsyn;
always@(posedge i_clk or posedge i_reset) begin
	if(i_reset)
		o_hsyn <= 1'd0;
	else	
		o_hsyn <= i_hsyn_r;
end

reg [15:0] ov_b11,ov_b12,ov_b21,ov_b22;
always@(posedge i_clk or posedge i_reset) begin
	if(i_reset)begin
		ov_b11 <= 16'd0;
		ov_b12 <= 16'd0;
		ov_b21 <= 16'd0;
		ov_b22 <= 16'd0;
	end
	else begin
		ov_b11 <= iv_b11;
		ov_b12 <= iv_b12;
		ov_b21 <= iv_b21;
		ov_b22 <= iv_b22;
	end
end
		
endmodule
