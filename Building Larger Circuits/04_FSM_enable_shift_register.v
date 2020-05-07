module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    reg cnt_ena = 0 ; 
    reg [2:0] cnt ;

    
    always @(posedge clk) begin
        if(reset) begin
            cnt <= 0 ;
            cnt_ena <= 1 ;
        end
        else begin
            if(cnt == 4-1) begin
                cnt_ena <= 0 ;
                cnt <= cnt ;
            end
            else begin
                cnt <= cnt + 1 ;
            end
        end
    end
    
    assign shift_ena = cnt_ena ;

endmodule