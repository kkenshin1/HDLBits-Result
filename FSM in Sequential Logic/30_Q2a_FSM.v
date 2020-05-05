module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    input w,
    output z
);
    
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
            A : nstate = w ? B : A ;
            B : nstate = w ? C : D ;
            C : nstate = w ? E : D ;
            D : nstate = w ? F : A ;
            E : nstate = w ? E : D ;
            F : nstate = w ? C : D ;
        endcase
    end
    
    assign z = (cstate == E || cstate == F) ;

endmodule
