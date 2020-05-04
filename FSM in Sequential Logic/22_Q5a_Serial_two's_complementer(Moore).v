module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter IDLE = 0 , S0 = 1 , S1 = 2 , S2 = 3 ;
    reg [1:0] cstate , nstate ;
    
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            cstate <= IDLE ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            IDLE : nstate = x ? S0 : IDLE ;
            S0   : nstate = x ? S2 : S1 ;
            S1   : nstate = x ? S2 : S1 ;
            S2   : nstate = x ? S2 : S1 ; 
        endcase  
    end
    
    assign z = (cstate == S0 || cstate == S1) ;
    
    
    
endmodule