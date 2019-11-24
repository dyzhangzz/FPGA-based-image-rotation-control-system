module sincos_cal(
		i_clk,
		i_reset,
		iv_degree,
		
		ov_sin,
		ov_cos
		);
		
input i_clk,i_reset;
input [6:0] iv_degree;

output [10:0] ov_cos,ov_sin;

reg [6:0] address;
always@(*)begin
	if(i_reset)
		address <= 7'd0;
	else begin
		if(iv_degree >= 7'd90)
			address <= 7'b1111111;
		else if(iv_degree > 7'd45)
			address <= 7'd90 - iv_degree;
		else
			address <= iv_degree;
	end
end

wire [21:0] wv_q;
//sincos_rom(.address(address[5:0]),.clock(i_clk),.q({wv_q}));

sincos_rom sincos_rom (
    .wr_data(),
    .addr(address[5:0]),
    .wr_en('b0),
    .clk(i_clk),
    .rst(i_reset),
    .rd_data(wv_q));

assign ov_cos = (iv_degree > 7'd45)?wv_q[21:11]:wv_q[10:0];
assign ov_sin = (iv_degree > 7'd45)?wv_q[10:0]:wv_q[21:11];

endmodule
