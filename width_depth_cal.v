module width_depth_cal(
		i_clk,
		i_reset,
		i_fsyn,
		i_hsyn,
		iv_depth,
		iv_width,
		iv_sin,
		iv_cos,
		iv_rotate_num,
		
		o_hsyn,
		ov_depth,
		ov_width
		);
		
input i_clk,i_reset;
input i_fsyn,i_hsyn;
input [10:0] iv_depth,iv_width;
input [10:0] iv_cos,iv_sin;
input [1:0] iv_rotate_num;

output o_hsyn;
output [11:0] ov_depth,ov_width;

 assign ov_width = 12'd1024;
 assign ov_depth = 12'd768;
/*
reg [10:0] rv_depth,rv_width;
always@(*)begin
	if(i_reset)begin
		rv_depth <= 11'd0;
		rv_width <= 11'd0;
	end
	else if(i_fsyn) begin
		rv_width <= 11'd0;
		rv_depth <= 11'd0;
	end
	else begin
		case(iv_rotate_num)
			2'd0 : begin rv_depth <= iv_depth;rv_width <= iv_width; end
			2'd1 : begin rv_depth <= iv_width;rv_width <= iv_depth; end
			2'd2 : begin rv_depth <= iv_depth;rv_width <= iv_width; end
			2'd3 : begin rv_depth <= iv_width;rv_width <= iv_depth; end
		endcase
	end
end
		
wire [21:0] wv_width_cos,wv_width_sin,wv_depth_cos,wv_depth_sin;

syn_gen_mult syn_gen_mult_width_cos (
    .a(iv_cos),
    .b(rv_width),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_width_cos));

syn_gen_mult syn_gen_mult_width_sin (
    .a(iv_sin),
    .b(rv_width),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_width_sin));

syn_gen_mult syn_gen_mult_depth_cos (
    .a(iv_cos),
    .b(rv_depth),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_depth_cos));

syn_gen_mult syn_gen_mult_depth_sin (
    .a(iv_sin),
    .b(rv_depth),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_depth_sin));		
reg [11:0] ov_depth,ov_width;
always@(*)begin
	if(i_reset)begin
		ov_width <= 12'd0;
		ov_depth <= 12'd0;
	end
	else if(i_fsyn) begin
		ov_width <= 12'd0;
		ov_depth <= 12'd0;
	end
	else if(i_hsyn) begin
		ov_width <= (wv_width_cos + wv_depth_sin)>>10;
		ov_depth <= (wv_width_sin + wv_depth_cos)>>10;
	end
end
*/
assign o_hsyn = i_hsyn;
		
endmodule
