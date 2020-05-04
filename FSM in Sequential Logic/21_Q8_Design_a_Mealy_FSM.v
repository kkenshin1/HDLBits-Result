module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter S0 = 0 , S1 = 1 , S2 = 2  ;
    reg [1:0] cstate ,nstate ;
    
    always @(posedge clk or negedge aresetn) begin
        if(!aresetn) begin
            cstate <= S0 ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            S0 : nstate = x ? S1 : S0 ;
            S1 : nstate = x ? S1 : S2 ;
            S2 : nstate = x ? S1 : S0 ;
        endcase
    end
    
    assign z = (cstate == S2) && x ;

endmodule