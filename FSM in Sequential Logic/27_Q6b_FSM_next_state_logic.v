module top_module (
    input [3:1] y,
    input w,
    output Y2);
    
    always @(*) begin
        case(y)
            3'b010 , 3'b100 : Y2 = w ;
            3'b000 , 3'b011 : Y2 = 0 ;
            default : Y2 = 1;
        endcase
    end

endmodule