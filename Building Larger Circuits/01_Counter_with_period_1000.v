module top_module (
    input clk,
    input reset,
    output [9:0] q);
    
    reg [9:0] o_q ;
    assign q = o_q ;
    
    always @(posedge clk) begin
        if(reset) begin
            o_q <= 10'b0 ;
        end
        else begin
            if(o_q == 999) begin
                o_q <= 10'b0 ;
            end
            else begin
                o_q <= o_q + 1 ;
            end
        end
    end

endmodule