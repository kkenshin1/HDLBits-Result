module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    parameter BYTE1 = 0 , BYTE2 = 1 , BYTE3 = 2 , DONE = 3 ;
    reg[1:0] cstate , nstate ;

    always @(posedge clk) begin
        if(reset) begin
            cstate <= BYTE1 ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate) 
            BYTE1 : nstate = in[3] ? BYTE2 : BYTE1 ;
            BYTE2 : nstate = BYTE3 ;
            BYTE3 : nstate = DONE ;
            DONE  : nstate = in[3] ? BYTE2 : BYTE1 ;
        endcase
    end
   	
    assign done = (cstate == DONE) ;
    
    
endmodule