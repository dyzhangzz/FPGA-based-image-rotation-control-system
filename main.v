module main(
		i_clk,
		i_reset,
		i_fsyn,
		i_hsyn,
		iv_degree,
		iv_depth,
		iv_width,
		
		o_hsyn,
		ov_p1x,ov_p2y,
		o_hrefsyn,
		ov_b,
		
		wv_rotate_degree,
		wv_rotate_num,
		wv_sin,
		wv_cos,
		w_hsyn,
		wv_depth,
		wv_width,
		wv_fx,wv_fy,
		// wv_pointx,
		// wv_pointy,
		w_hsyn_buf,
		wv_fx_buf,wv_fy_buf,
		wv_b11_buf,
		wv_b12_buf,
		wv_b21_buf,
		wv_b22_buf,
		// w_hsyn_r,
		// wv_b1r,wv_b1g,wv_b1b,wv_b2r,wv_b2g,wv_b2b
		);
		
input i_clk,i_reset;
input i_fsyn,i_hsyn;
input [8:0] iv_degree;
input [10:0] iv_depth,iv_width;

output o_hsyn;
output [11:0] ov_p1x,ov_p2y;
output o_hrefsyn;
output [15:0] ov_b;

output [6:0] wv_rotate_degree;
output [1:0] wv_rotate_num;
output [10:0] wv_cos,wv_sin;
output w_hsyn;
output [11:0] wv_depth,wv_width;
output [10:0] wv_fx,wv_fy;
output w_hsyn_buf;
// output [22:0] wv_pointx,wv_pointy;
output [10:0] wv_fx_buf,wv_fy_buf;
output [15:0] wv_b11_buf,wv_b12_buf,wv_b21_buf,wv_b22_buf;
// output w_hsyn_r;
// output [7:0] wv_b1r,wv_b1g,wv_b1b,wv_b2r,wv_b2g,wv_b2b;


wire [6:0] wv_rotate_degree;
wire [1:0] wv_rotate_num;
degree_cal degree_cal(
		.i_reset(i_reset),
		.iv_degree(iv_degree),
		.i_fsyn(i_fsyn),
		
		.ov_rotate_degree(wv_rotate_degree),
		.ov_rotate_num(wv_rotate_num)
		);

wire [10:0] wv_sin,wv_cos;
sincos_cal sincos_cal(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.iv_degree(wv_rotate_degree),
		
		.ov_sin(wv_sin),
		.ov_cos(wv_cos)
		);
		
wire w_fsyn,w_hsyn;
wire [11:0] wv_depth,wv_width;
width_depth_cal width_depth_cal(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_fsyn(i_fsyn),
		.i_hsyn(i_hsyn),
		.iv_depth(iv_depth),
		.iv_width(iv_width),
		.iv_sin(wv_sin),
		.iv_cos(wv_cos),
		.iv_rotate_num(wv_rotate_num),
		
		.o_hsyn(w_hsyn),
		.ov_depth(wv_depth),
		.ov_width(wv_width)
		);
		
wire o_hsyn;
wire [11:0] ov_p1x,ov_p2y;
wire [21:0] cos_x,cos_y,sin_x,sin_y;
wire [22:0] wv_pointx,wv_pointy;
point_cal point_cal(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_fsyn(i_fsyn),
		.i_hsyn(w_hsyn),
		.iv_depth(wv_depth),
		.iv_width(wv_width),
		.iv_cos(wv_cos),
		.iv_sin(wv_sin),
		
		.o_hsyn(o_hsyn),
		.ov_p1x(ov_p1x),
		.ov_p2y(ov_p2y),
		.ov_fx(wv_fx),
		.ov_fy(wv_fy),
		
		.rv_cos_x(cos_x),
		.rv_cos_y(cos_y),
		.rv_sin_x(sin_x),
		.rv_sin_y(sin_y),
		.wv_pointx(wv_pointx),
		.wv_pointy(wv_pointy)
		);

wire [15:0] wv_b11,wv_b12,wv_b21,wv_b22;
wire w_hsyn_r;
ddr_test ddr_test(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_hsyn(o_hsyn),
		.iv_p1x(ov_p1x),
		.iv_p2y(ov_p2y),
		.iv_width(iv_width),
		.iv_depth(iv_depth),
		
		.o_hsyn(w_hsyn_r),
		.ov_b11(wv_b11),
		.ov_b12(wv_b12),
		.ov_b21(wv_b21),
		.ov_b22(wv_b22)
		);

wire w_hsyn_buf;
wire [10:0] wv_fx_buf,wv_fy_buf;
wire [15:0] wv_b11_buf,wv_b12_buf,wv_b21_buf,wv_b22_buf;
fxy_buffer fxy_buffer(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.iv_fx(wv_fx),
		.iv_fy(wv_fy),
		.i_fsyn(i_fsyn),
		.i_hsyn(o_hsyn),
		.i_hsyn_r(w_hsyn_r),
		.iv_b11(wv_b11),
		.iv_b12(wv_b12),
		.iv_b21(wv_b21),
		.iv_b22(wv_b22),
		
		.o_hsyn(w_hsyn_buf),
		.ov_fx(wv_fx_buf),
		.ov_fy(wv_fy_buf),
		.ov_b11(wv_b11_buf),
		.ov_b12(wv_b12_buf),
		.ov_b21(wv_b21_buf),
		.ov_b22(wv_b22_buf)
		);
		
b_out b_out(
		.i_hsyn(w_hsyn_buf),
		.iv_b11(wv_b11_buf),
		.iv_b12(wv_b12_buf),
		.iv_b21(wv_b21_buf),
		.iv_b22(wv_b22_buf),
		.iv_fx(wv_fx_buf),
		.iv_fy(wv_fy_buf),
		
		.o_hsyn(o_hrefsyn),
		.ov_b(ov_b),
		
		.wv_b1r(wv_b1r),
		.wv_b1g(wv_b1g),
		.wv_b1b(wv_b1b),
		.wv_b2r(wv_b2r),
		.wv_b2g(wv_b2g),
		.wv_b2b(wv_b2b)
		);
		
endmodule
