module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    
    parameter IDLE = 0 , F0 = 1 , F1 = 2 ;
    parameter X0   = 3 , X1 = 4 , X2 = 5 ;
    parameter Y0   = 6 , Y1 = 7 ;
    parameter Y00  = 8 , Y01= 9 ;
    
    reg[3:0] cstate , nstate ;
    
    always @(posedge clk) begin
        if(!resetn) begin
            cstate <= IDLE ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            IDLE : nstate = F0 ;
            F0   : nstate = F1 ;
            F1   : nstate = x ? X0 : F1 ;
            X0   : nstate = x ? X0 : X1 ;
            X1   : nstate = x ? X2 : F1 ;
            X2   : nstate = y ? Y1 : Y0 ;
            Y1   : nstate = Y1 ;
            Y0   : nstate = y ? Y01 : Y00 ;
            Y01  : nstate = Y01 ;
            Y00  : nstate = Y00 ;
        endcase
    end
    
    assign f = (cstate == F0) ;
    assign g = (cstate == X2 || cstate == Y1 || cstate == Y0 || cstate == Y01) ;
    

endmodule
