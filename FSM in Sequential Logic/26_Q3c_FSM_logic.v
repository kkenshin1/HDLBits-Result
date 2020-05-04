module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    always @(*) begin
        case(y)
            3'b000 , 3'b010 : Y0 = x ;
            default : Y0 = ~x ;
        endcase
    end
    
    assign z = (y == 3'b011 || y == 3'b100) ;

endmodule
