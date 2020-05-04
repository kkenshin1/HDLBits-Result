module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    parameter NONE = 0 , S1 = 1 , S2 = 2 , S3 = 3 , S4 = 4 ;
    parameter S5 = 5 ,S6= 6 , DISCARD = 7 , FLAG = 8 , ERROR = 9 ;
    reg [3:0] cstate , nstate ;
    
    always @(posedge clk) begin
        if(reset) begin
            cstate <= NONE ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case (cstate) 
            NONE : nstate = in ? S1 : NONE ;
            S1   : nstate = in ? S2 : NONE ;
            S2   : nstate = in ? S3 : NONE ;
            S3   : nstate = in ? S4 : NONE ;
            S4   : nstate = in ? S5 : NONE ;
            S5   : nstate = in ? S6 : DISCARD ;
            S6   : nstate = in ? ERROR : FLAG ;
            DISCARD : nstate = in ?  S1 : NONE ;
            FLAG : nstate = in ? S1 : NONE ;
            ERROR : nstate = in ? ERROR : NONE ;
        endcase
    end
    
    assign disc = (cstate == DISCARD) ;
    assign flag = (cstate == FLAG) ;
    assign err  = (cstate == ERROR) ;
    

endmodule