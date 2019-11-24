module point_cal(
		i_clk,
		i_reset,
		i_fsyn,
		i_hsyn,
		iv_depth,
		iv_width,
		iv_cos,
		iv_sin,
		
		ov_p1x,ov_p2y,
		ov_fx,ov_fy,
		o_hsyn,
		
		rv_cos_x,rv_cos_y,
		rv_sin_x,rv_sin_y,
		wv_pointx,
		wv_pointy
		);

input i_clk,i_reset;
input i_fsyn,i_hsyn;
input [11:0] iv_depth,iv_width;
input [10:0] iv_cos,iv_sin;

output [11:0] ov_p1x,ov_p2y;
output [10:0] ov_fx,ov_fy;
output o_hsyn;

output [22:0] rv_cos_x,rv_cos_y,rv_sin_x,rv_sin_y;
output [23:0] wv_pointx,wv_pointy;

assign o_hsyn = i_hsyn;
// reg o_hsyn;
// always@(posedge i_clk or posedge i_reset)begin
// 	if(i_reset)
// 		o_hsyn <= 0;
// 	else
// 		o_hsyn <= i_hsyn;
// end

reg [11:0] rv_counterx,rv_countery;
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		rv_counterx <= 12'd0;
	else if(i_fsyn)
		rv_counterx <= 12'd0;
	else if(i_hsyn) begin
		if(rv_counterx == iv_width - 1'd1)
			rv_counterx <= 12'd0;
		else
			rv_counterx <= rv_counterx + 1'd1;
	end
end
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		rv_countery <= 12'd0;
	else if(i_fsyn)
		rv_countery <= 12'd0;
	else if(i_hsyn && rv_counterx == iv_width - 1'd1) begin
		if(rv_countery == iv_depth - 1'd1)
			rv_countery <= 12'd0;
		else
			rv_countery <= rv_countery + 1'd1;
	end
end

wire [22:0] rv_cos_x,rv_cos_y,rv_sin_x,rv_sin_y;

point_cal_mult point_cal_mult_cos_x (
    .a({1'd0,iv_cos}),
    .b(rv_counterx - (iv_width>>1)),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(rv_cos_x));

point_cal_mult point_cal_mult_cos_y (
    .a({1'd0,iv_cos}),
    .b((iv_depth>>1) - rv_countery),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(rv_cos_y));



point_cal_mult point_cal_mult_sin_x (
    .a({1'd0,iv_sin}),
    .b(rv_counterx - (iv_width>>1)),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(rv_sin_x));


point_cal_mult point_cal_mult_sin_y (
    .a({1'd0,iv_sin}),
    .b((iv_depth>>1) - rv_countery),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(rv_sin_y));
		
// pre_x pre_y
wire [23:0] wv_pointx,wv_pointy;
assign wv_pointx = {rv_cos_x[22],rv_cos_x} - {rv_sin_y[22],rv_sin_y};
assign wv_pointy = {rv_sin_x[22],rv_sin_x} + {rv_cos_y[22],rv_cos_y};
		
// p1_x p2_x p1_y p2_y
wire [11:0] ov_p1x,ov_p2y;
assign ov_p1x = wv_pointx>>10;
// assign ov_p2x = ov_p1x + 1'd1;
// assign ov_p1y = ov_p2y + 1'd1;
assign ov_p2y = wv_pointy>>10;

// fx fy
wire [10:0] ov_fx,ov_fy;
assign ov_fx = wv_pointx - {ov_p1x,10'd0};
assign ov_fy = {(ov_p2y + 1'd1),10'd0} - wv_pointy;

endmodule
