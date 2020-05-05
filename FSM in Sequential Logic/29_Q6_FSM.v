module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    
    parameter A = 3'b000 ;
    parameter B = 3'b001 ;
    parameter C = 3'b010 ;
    parameter D = 3'b011 ;
    parameter E = 3'b100 ;
    parameter F = 3'b101 ;
    
    reg [2:0] cstate , nstate ;
    
    always @(posedge clk) begin
        if(reset) begin
            cstate <= A ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate) 
            A : nstate = w ? A : B ;
            B : nstate = w ? D : C ;
            C : nstate = w ? D : E ;
            D : nstate = w ? A : F ;
            E : nstate = w ? D : E ;
            F : nstate = w ? D : C ;
        endcase
    end
    
    assign z = (cstate == E || cstate == F) ;
    

endmodule
