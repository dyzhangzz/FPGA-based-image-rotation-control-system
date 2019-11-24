//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: lhj                                                               //
//                                                                             //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2018/1/3                    1.0          Original
//*******************************************************************************/

module uart_test(
input                           sys_clk,
input                           rst_n,
input                           uart_rx,
output                          led,
output [8:0] end_data_t
);

parameter                      CLK_FRE = 50;//Mhz
//localparam                       IDLE =  0;
//localparam                       SEND =  1;   //send HELLO ALINX\r\n
//localparam                       WAIT =  2;   //wait 1 second and send uart received data
reg[7:0]                         tx_data;
//reg[7:0]                         tx_str/*synthesis syn_keep=1*/;
//reg                              tx_data_valid;
//wire                             tx_data_ready;
//reg[7:0]                         tx_cnt;
wire[7:0]                        rx_data;
wire                             rx_data_valid;
wire                             rx_data_ready;
reg[31:0]                        wait_cnt;
reg[3:0]                         state;

parameter    time_1s = 50000000;
reg [31:0]   cnt_time;
reg [8:0]                        end_data; 
assign rx_data_ready = 1'b1;//always can receive data,
							//if HELLO ALINX\r\n is being sent, the received data is discarded
/*
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		wait_cnt <= 32'd0;
		tx_data <= 8'd0;
		state <= IDLE;
		tx_cnt <= 8'd0;
		tx_data_valid <= 1'b0;
	end
	else
	case(state)
		IDLE:
			state <= SEND;
		SEND:
		begin
			wait_cnt <= 32'd0;
			tx_data <= tx_str;

			if(tx_data_valid == 1'b1 && tx_data_ready == 1'b1 && tx_cnt < 8'd12)//Send 12 bytes data
			begin
				tx_cnt <= tx_cnt + 8'd1; //Send data counter
			end
			else if(tx_data_valid && tx_data_ready)//last byte sent is complete
			begin
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
				state <= WAIT;
			end
			else if(~tx_data_valid)
			begin
				tx_data_valid <= 1'b1;
			end
		end
		WAIT:
		begin
			wait_cnt <= wait_cnt + 32'd1;

			if(rx_data_valid == 1'b1)
			begin
				tx_data_valid <= 1'b1;
				tx_data <= rx_data;   // send uart received data
			end
			else if(tx_data_valid && tx_data_ready)
			begin
				tx_data_valid <= 1'b0;
			end
			else if(wait_cnt >= CLK_FRE * 1000000) // wait for 1 second
				state <= SEND;
		end
		default:
			state <= IDLE;
	endcase
end

*/
//combinational logic
//Send "HELLO ALINX\r\n"
/*always@(*)
begin
	case(tx_cnt)
		8'd0 :  tx_str <= "H";
		8'd1 :  tx_str <= "E";
		8'd2 :  tx_str <= "L";
		8'd3 :  tx_str <= "L";
		8'd4 :  tx_str <= "O";
		8'd5 :  tx_str <= " ";
		8'd6 :  tx_str <= "A";
		8'd7 :  tx_str <= "L";
		8'd8 :  tx_str <= "I";
		8'd9 :  tx_str <= "N";
		8'd10:  tx_str <= "X";
	   // 8'd11:  tx_str <= "\r";
        8'd11:  tx_str <= 8'h0d;
		8'd12:  tx_str <= "\n";
		default:tx_str <= 8'd0;
	endcase
end*/

uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);
reg [3:0] data_bai;
reg [3:0] data_shi;
reg [3:0] data_ge;
reg [3:0] reg_state;
reg       en_end_data;
always @(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n) begin
        state <=0;        
        end_data <=0;
        data_bai <=0;
        data_shi <=0;
        data_ge  <=0;
        wait_cnt <=0;
        reg_state <=0;
        en_end_data <=0;
        end
    else begin
        case(state)
            0:begin
                if(rx_data_valid) begin
                    wait_cnt <=0;
                    reg_state <=state;
                    state <=1;
                    if(rx_data == 'd48)
                        data_bai <=0;
                    else if(rx_data == 'd49)
                        data_bai <=1;
                    else if(rx_data == 'd50)
                        data_bai <=2;
                    else if(rx_data == 'd51)
                        data_bai <=3;
                    else if(rx_data == 'd52)
                        data_bai <=4;
                    else if(rx_data == 'd53)
                        data_bai <=5;
                    else if(rx_data == 'd54)
                        data_bai <=6;
                    else if(rx_data == 'd55)
                        data_bai <=7;
                    else if(rx_data == 'd56)
                        data_bai <=8;
                    else if(rx_data == 'd57)
                        data_bai <=9;
                    end
            
                end
            1:begin
                wait_cnt <= wait_cnt +1; 
                if(rx_data_valid) begin
                    reg_state <=state;
                    state <=2;
                    if(rx_data == 'd48)
                        data_shi <= 0;
                    else if(rx_data == 'd49)
                        data_shi <= 1;
                    else if(rx_data == 'd50)
                        data_shi <= 2;
                    else if(rx_data == 'd51)
                        data_shi <= 3;
                    else if(rx_data == 'd52)
                        data_shi <= 4;
                    else if(rx_data == 'd53)
                        data_shi <= 5;
                    else if(rx_data == 'd54)
                        data_shi <= 6;
                    else if(rx_data == 'd55)
                        data_shi <= 7;
                    else if(rx_data == 'd56)
                        data_shi <= 8;
                    else if(rx_data == 'd57)
                        data_shi <= 9;
                    end

                if(wait_cnt == 'd10000) begin
                    state <= 4;
                    reg_state <= state;
                    end
                end
            2:begin
                wait_cnt <= wait_cnt +1; 
                if(rx_data_valid) begin
                    reg_state <= state;
                    state <=3;
                    if(rx_data == 'd48)
                        data_ge <= 0;
                    else if(rx_data == 'd49)
                        data_ge <= 1;
                    else if(rx_data == 'd50)
                        data_ge <= 2;
                    else if(rx_data == 'd51)
                        data_ge <= 3;
                    else if(rx_data == 'd52)
                        data_ge <= 4;
                    else if(rx_data == 'd53)
                        data_ge <= 5;
                    else if(rx_data == 'd54)
                        data_ge <= 6;
                    else if(rx_data == 'd55)
                        data_ge <= 7;
                    else if(rx_data == 'd56)
                        data_ge <= 8;
                    else if(rx_data == 'd57)
                        data_ge <= 9;
                    end
                if(wait_cnt == 'd20000) begin
                    state <= 4;
                    reg_state <= state;
                    end
                end
            3:begin
                reg_state <=state;
                state <=4;
                end
            4:begin
                if(reg_state ==1)begin
                    end_data <= data_bai;
                    state <=5;    
                    end
                else if(reg_state ==2)begin
                    end_data <= data_bai*10 +data_shi;
                    state <=5;
                    end
                else if(reg_state ==3)begin
                    end_data <= data_bai*100 +data_shi*10 +data_ge;
                    state <=5;
                    end
                else begin
                    state <=5;
                    end
                en_end_data <= 'b1;
                end                                
            5:begin
                en_end_data <='b0;
                wait_cnt <=0;
                state <=0;
                reg_state <=0; 
                data_bai <=0;
                data_shi <=0;
                data_ge <=0;                
                end
            default:begin

                end
            endcase
        end
end
reg led_t;
always @(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)begin
        led_t <=0;
        end
    else begin
        if(end_data == 125)
            led_t <=1;
        end
end
reg led_f;
always @(posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)begin
        led_f <=1;
        cnt_time <=0;
        end
    else begin
        if(led_t)begin
            cnt_time <= cnt_time +1;
            if(cnt_time == time_1s-1)begin
                led_f <= ~led_f;
                cnt_time <=0;
                end
            end
        end
end

assign led = led_f;
assign end_data_t = end_data;
/*
uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_tx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);*/
endmodule
