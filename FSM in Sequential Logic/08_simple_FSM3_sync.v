module top_module(
    input clk,
    input in,
    input reset,
    output out); //

    parameter A = 4'b0001 ;
    parameter B = 4'b0010 ;
    parameter C = 4'b0100 ;
    parameter D = 4'b1000 ;
    reg [3:0] c_state ;
    reg [3:0] n_state ;
    reg r_out ;
    
    assign out = r_out ;
    
    always @(posedge clk) begin
        if(reset) begin
            c_state <= A ;
        end
        else begin
            c_state <= n_state ;
        end
    end
    
    always @(*) begin
        case(c_state)
            A : n_state = in ? B : A ;
            B : n_state = in ? B : C ;
            C : n_state = in ? D : A ;
            D : n_state = in ? B : C ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            r_out <= 0 ;
        end
        else begin
            case(n_state)
        	D : r_out <= 1 ;
            	default : r_out <= 0 ;
            endcase
        end
    end

endmodule
