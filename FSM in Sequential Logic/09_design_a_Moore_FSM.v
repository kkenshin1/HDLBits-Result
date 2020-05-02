module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    
    parameter A = 4'b0001 ;
    parameter B = 4'b0010 ;
    parameter C = 4'b0100 ;
    parameter D = 4'b1000 ;
    reg [3:0] cstate ;
    reg [3:0] nstate ;
    
    reg o_fr1 , o_fr2 , o_fr3 , o_dfr ;
    assign fr1 = o_fr1 ;
    assign fr2 = o_fr2 ;
    assign fr3 = o_fr3 ;
    assign dfr = o_dfr ;
    
    always @(posedge clk) begin
        if(reset) begin
        	cstate <= A ;
        end
        else begin
        	cstate <= nstate ;
        end
   	end
    
    always @(*) begin
        case(s) 
            3'b000 : nstate = A ;
            3'b001 : nstate = B ;
            3'b011 : nstate = C ; 
            3'b111 : nstate = D ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
        	o_fr1 <= 1 ;
            o_fr2 <= 1 ;
            o_fr3 <= 1 ;
            o_dfr <= 1 ;
        end
        else begin
            case(nstate)
                A : begin
        			o_fr1 <= 1 ;
            		o_fr2 <= 1 ;
            		o_fr3 <= 1 ;
                    o_dfr <= 1 ;
                end
                B : begin
        			o_fr1 <= 1 ;
            		o_fr2 <= 1 ;
            		o_fr3 <= 0 ;
                    if(cstate == C || cstate == D) o_dfr <= 1 ;
                    else if(cstate == A)  o_dfr <= 0 ;
                end
                C : begin
                	o_fr1 <= 1 ;
            		o_fr2 <= 0 ;
            		o_fr3 <= 0 ;
                    if(cstate == D) o_dfr <= 1 ;
                    else if(cstate == A || cstate == B) o_dfr <= 0 ;
                end
                D : begin
                	o_fr1 <= 0 ;
            		o_fr2 <= 0 ;
            		o_fr3 <= 0 ;
                    o_dfr <= 0 ;
                end
            endcase
        end
    end

endmodule