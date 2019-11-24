module ddr_test(
		i_clk,
		i_reset,
		i_hsyn,
		iv_p1x,
		iv_p2y,
		iv_width,
		iv_depth,
		
		o_hsyn,
		o_fsyn,
		ov_b11,
		ov_b12,
		ov_b21,
		ov_b22
		);
		
input i_clk,i_reset;
input i_hsyn;
input [11:0] iv_p1x,iv_p2y;
input [11:0] iv_width,iv_depth;

output o_hsyn,o_fsyn;
output [15:0] ov_b11,ov_b12,ov_b21,ov_b22;

wire [11:0] add_x1,add_x2,add_y1,add_y2;
assign add_x1 = iv_p1x + (iv_width>>1);
assign add_y2 = (iv_depth>>1) - iv_p2y;
assign add_x2 = add_x1 + 1'd1;
assign add_y1 = add_y2 - 1'd1;

reg [25:0] cnt;
always@(posedge i_clk or posedge i_reset)begin
    if(i_reset)
        cnt <= 26'd0;
    else
        cnt <= cnt + 1;
end
reg [1:0] cnt1;
always@(posedge i_clk or posedge i_reset)begin
    if(i_reset)
        cnt1 <= 2'd0;
    else if(cnt <= 28'hfffffff) begin
        if(cnt1 == 4-1)
            cnt1 <= 2'd0;
        else
            cnt1 <= cnt1 + 1;
    end
end

reg [15:0] color;
always@(*)begin
    if(i_reset)
        color <= 16'd0;
    else begin
        case(cnt1)
        0:color <= 16'hffff;
        1:color <= 16'hffff;
        2:color <= 16'hffff;
        3:color <= 16'hffff;
        endcase
    end
end

reg [15:0] ov_b11,ov_b12,ov_b21,ov_b22;
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		ov_b11 <= 16'd0;
	else if(i_hsyn) begin
		if(add_x1 > iv_width - 1'd1 || add_x1 < 12'd0 || add_y1 > iv_depth - 1'd1 || add_y1 < 12'd0)
			ov_b11 <= 16'd0;
		else
			// ov_b11 <= {add_x1[0+:8]+1,add_y1[0+:8]+1};
			ov_b11 <= color;
	end
end
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		ov_b12 <= 16'd0;
	else if(i_hsyn) begin
		if(add_x2 > iv_width - 1'd1 || add_x2 < 12'd0 || add_y1 > iv_depth - 1'd1 || add_y1 < 12'd0)
			ov_b12 <= 16'd0;
		else
			// ov_b12 <= {add_x2[0+:8]+1,add_y1[0+:8]+1};
			ov_b12 <= color;
	end
end
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		ov_b21 <= 16'd0;
	else if(i_hsyn) begin
		if(add_x1 > iv_width - 1'd1 || add_x1 < 12'd0 || add_y2 > iv_depth - 1'd1 || add_y2 < 12'd0)
			ov_b21 <= 16'd0;
		else
			// ov_b21 <= {add_x1[0+:8]+1,add_y2[0+:8]+1};
			ov_b21 <= color;
	end
end
always@(posedge i_clk or posedge i_reset)begin
	if(i_reset)
		ov_b22 <= 16'd0;
	else if(i_hsyn) begin
		if(add_x2 > iv_width - 1'd1 || add_x2 < 12'd0 || add_y2 > iv_depth - 1'd1 || add_y2 < 12'd0)
			ov_b22 <= 16'd0;
		else
			// ov_b22 <= {add_x2[0+:8]+1,add_y2[0+:8]+1};
			ov_b22 <= color;
	end
end

reg o_hsyn;
always@(posedge i_clk or posedge i_reset) begin
	if(i_reset)
		o_hsyn <= 1'd0;
	else	
		o_hsyn <= i_hsyn;
end
		
endmodule
