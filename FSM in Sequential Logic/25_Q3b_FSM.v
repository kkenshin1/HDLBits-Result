module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    
    parameter S0 = 3'b000 ;
    parameter S1 = 3'b001 ;
    parameter S2 = 3'b010 ;
    parameter S3 = 3'b011 ;
    parameter S4 = 3'b100 ;
    
    reg [2:0] cstate , nstate ;
    
    always @(posedge clk) begin
        if(reset) begin
            cstate <= S0 ;
        end
        else begin
            cstate <= nstate ;
        end
    end

    always @(*) begin
        case(cstate)
            S0 : nstate = x ? S1 : S0 ;
            S1 : nstate = x ? S4 : S1 ;
            S2 : nstate = x ? S1 : S2 ;
            S3 : nstate = x ? S2 : S1 ;
            S4 : nstate = x ? S4 : S3 ;
        endcase
    end
    
    assign z = (cstate == S3 || cstate == S4 ) ;
    
endmodule
