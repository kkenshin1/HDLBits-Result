module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    
    reg [3:0] o_q = 4'b0 ;
    assign q = o_q ;
    
    always @(posedge clk) begin
        if(shift_ena) begin
            o_q <= {o_q[2:0] , data} ;
        end
        else if(count_ena) begin
            o_q <= o_q - 1'b1 ;
        end
        else begin
            o_q <= o_q ;
        end
    end
    
    

endmodule