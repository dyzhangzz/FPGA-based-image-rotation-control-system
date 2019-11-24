module b_out(
        i_clk,
        i_reset,
		i_hsyn,
		iv_b11,
		iv_b12,
		iv_b21,
		iv_b22,
		iv_fx,
		iv_fy,
		
		o_hsyn,
		ov_b,
		
		wv_b1r,wv_b1g,wv_b1b,wv_b2r,wv_b2g,wv_b2b
		);
input i_clk;
input i_reset;		
input i_hsyn;
input [15:0] iv_b11,iv_b12,iv_b21,iv_b22;
input [10:0] iv_fx,iv_fy;

output o_hsyn;
output [15:0] ov_b;

output [7:0] wv_b1r,wv_b1g,wv_b1b,wv_b2r,wv_b2g,wv_b2b;

wire [7:0] wv_b11_r = {iv_b11[15:11],iv_b11[13:11]};
wire [7:0] wv_b11_g = {iv_b11[10:5],iv_b11[6:5]};
wire [7:0] wv_b11_b = {iv_b11[4:0],iv_b11[2:0]};

wire [7:0] wv_b12_r = {iv_b12[15:11],iv_b12[13:11]};
wire [7:0] wv_b12_g = {iv_b12[10:5],iv_b12[6:5]};
wire [7:0] wv_b12_b = {iv_b12[4:0],iv_b12[2:0]};

wire [7:0] wv_b21_r = {iv_b21[15:11],iv_b21[13:11]};
wire [7:0] wv_b21_g = {iv_b21[10:5],iv_b21[6:5]};
wire [7:0] wv_b21_b = {iv_b21[4:0],iv_b21[2:0]};

wire [7:0] wv_b22_r = {iv_b22[15:11],iv_b22[13:11]};
wire [7:0] wv_b22_g = {iv_b22[10:5],iv_b22[6:5]};
wire [7:0] wv_b22_b = {iv_b22[4:0],iv_b22[2:0]};

wire [20:0] wv_fx_b1r,wv_fx_b1g,wv_fx_b1b,wv_fx_b2r,wv_fx_b2g,wv_fx_b2b;

fxy_b_mult fx_b1r (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b12_r} - {1'd0,wv_b11_r}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b1r));

fxy_b_mult fx_b1g (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b12_g} - {1'd0,wv_b11_g}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b1g));


fxy_b_mult fx_b1b (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b12_b} - {1'd0,wv_b11_b}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b1b));


fxy_b_mult fx_b2r (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b22_r} - {1'd0,wv_b21_r}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b2r));

fxy_b_mult fx_b2g (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b22_g} - {1'd0,wv_b21_g}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b2g));


fxy_b_mult fx_b2b (
    .a({1'd0,iv_fx}),
    .b({1'd0,wv_b22_b} - {1'd0,wv_b21_b}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fx_b2b));


wire [7:0] wv_b1r,wv_b1g,wv_b1b,wv_b2r,wv_b2g,wv_b2b;
assign wv_b1r = wv_fx_b1r[10+:8] + wv_b11_r;
assign wv_b1g = wv_fx_b1g[10+:8] + wv_b11_g;
assign wv_b1b = wv_fx_b1b[10+:8] + wv_b11_b;
assign wv_b2r = wv_fx_b2r[10+:8] + wv_b21_r;
assign wv_b2g = wv_fx_b2g[10+:8] + wv_b21_g;
assign wv_b2b = wv_fx_b2b[10+:8] + wv_b21_b;

wire [20:0] wv_fy_br,wv_fy_bg,wv_fy_bb;


fxy_b_mult fy_br (
    .a({1'd0,iv_fy}),
    .b({1'd0,wv_b2r} - {1'd0,wv_b1r}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fy_br));


fxy_b_mult fy_bg (
    .a({1'd0,iv_fy}),
    .b({1'd0,wv_b2g} - {1'd0,wv_b1g}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fy_bg));

fxy_b_mult fy_bb (
    .a({1'd0,iv_fy}),
    .b({1'd0,wv_b2b} - {1'd0,wv_b1b}),
    .clk(i_clk),
    .rst(i_reset),
    .ce('b1),
    .p(wv_fy_bb));
		
wire [7:0] wv_br = wv_fy_br[10+:8] + wv_b1r;
wire [7:0] wv_bg = wv_fy_bg[10+:8] + wv_b1g;
wire [7:0] wv_bb = wv_fy_bb[10+:8] + wv_b1b;

assign ov_b = {wv_br[7:3],wv_bg[7:2],wv_bb[7:3]};
assign o_hsyn = i_hsyn;
		
endmodule
