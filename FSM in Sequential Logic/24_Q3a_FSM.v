module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    
    parameter A = 0 , B = 1 ;
    reg cstate , nstate ;
    reg [1:0] cnt ;
    reg cnt_end ;
    reg [1:0] w_cnt ;
    
    assign z = cnt_end ;
    
    always @(posedge clk) begin
        if(reset) begin
            cstate <= A ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case (cstate) 
            A : nstate = s ? B : A ;
            B : nstate = B ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            cnt <= 2'b00 ;
            w_cnt <= 2'b00 ;
            cnt_end <= 0 ;
        end
        else begin
            if(cstate == B) begin
                if(cnt == 3-1) begin
                    cnt <= 2'b00 ;
                    w_cnt <= 2'b00 ; 
                    if(w == 1) begin
                        if(w_cnt == 1) begin
                            cnt_end <= 1 ;
                        end
                        else begin
                            cnt_end <= 0 ;
                        end
                    end
                    else begin
                        if(w_cnt == 2) begin
                            cnt_end<= 1 ;
                        end
                        else begin
                            cnt_end <= 0 ;
                        end
                    end
                end
                else begin
                    cnt_end <= 0 ;
                    cnt <= cnt + 1;
                    if(w == 1) begin
                        w_cnt <= w_cnt + 1 ;
                    end
                    else begin
                        w_cnt <= w_cnt + 0 ;
                    end
                end
            end
        end
    end
    

endmodule
