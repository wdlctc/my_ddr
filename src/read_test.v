`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/28 10:14:28
// Design Name: 
// Module Name: read_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module read_test(
    input				clk,
	input				rst,
	
	input		[512:0]	idata,
	input				idata_ready,
	output				odata_rd,
	
	input				iweight_ready,
	output				oweight_rd,
	input		[256:0]	iweight,
	
	input				iresult_ready,
    output              oresult_rd,
    output      [512:0] oresult,
	
	output		[127:0] olabel,
	output				olabel_valid
);

    reg         data_rd_r;
    reg         weight_rd_r;
    reg         result_rd_r;
    reg     [31:0]  cnt0;
    reg     [31:0]  cnt1;
    reg     [31:0]  cnt2;
    reg             state;
    reg             state_dly;
    
    always @(posedge clk)
    begin
        if(rst) begin
            data_rd_r <= 1'b0;
            weight_rd_r <= 1'b0;
            result_rd_r <= 1'b0;
        end
        else
            begin
                if(idata_ready)
                    data_rd_r <= 1'b1;
                else
                    data_rd_r <= 1'b0;
                    
                if(iweight_ready)
                    weight_rd_r <= 1'b1;
                else
                    weight_rd_r <= 1'b0;
                    
                if(iresult_ready && (cnt0 == 16'd5000) && (cnt1 == 16'd5000))
                    result_rd_r <= 1'b1;
                else
                    result_rd_r <= 1'b0; 
                    
            end
    end
    assign  odata_rd = data_rd_r & (idata_ready);
    assign  oweight_rd = iweight_ready & (weight_rd_r);
    assign  oresult_rd = iresult_ready & (result_rd_r);
    
    always @(posedge clk)
    begin
        if(rst)
            state <= 1'b0;
        else if((cnt0 == 16'd5000) && (cnt1 == 16'd5000) && (cnt2 == 16'd5000))
            state <= 1'b1;
    end
    
    always @(posedge clk)
        state_dly <= state;
    
    always @(posedge clk)
    begin
        if(rst) begin
            cnt0 <= 32'h0;
            cnt1 <= 32'h0;
            cnt2 <= 32'h0;
        end
        else begin
            if(odata_rd)
                cnt0 <= (cnt0 == 16'd5000) ? 16'd5000: cnt0 + 1'b1;
            
            if(oweight_rd)
                cnt1 <= (cnt1 == 16'd5000) ? 16'd5000: cnt1 + 1'b1;
            
            if(oresult_rd)
                begin
                    cnt2 <= (cnt2 == 16'd5000) ? 16'd5000: cnt2 + 1'b1;
                end
           
        end
    end
    
    assign oresult = {0,cnt2};
	
    assign olabel_valid = state;
    assign olabel = {0,cnt0,cnt1,cnt2};
    
endmodule
