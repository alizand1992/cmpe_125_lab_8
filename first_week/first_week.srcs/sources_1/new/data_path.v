module data_path(
    input [3:0] dividend, divisor, control_signal,
    input clk,
     
    output reg [4:0] status_signal,
    output reg [3:0] quotient, remainder
);

    reg [4:0] internal_remainder;
    reg [3:0] internal_dividend, internal_divisor;
    reg [1:0] count; 

    always @ (posedge clk, control_signal)
    begin
        case (control_signal) 
            4'b0001:
            begin
                internal_remainder <= 0;
                internal_dividend <= dividend;
                internal_divisor <= divisor;
                count <= 3;
                status_signal <= 1;
            end
            
            4'b0010:
            begin
                internal_remainder[4:0] <= {internal_remainder[3:0], internal_dividend[3]};
                internal_dividend[3:0] <= {internal_dividend[2:0], 1'b0};
                status_signal <= 1;
            end
            
            4'b0011:
            begin
                count <= count - 1;
                
                if (internal_remainder < internal_divisor) 
                begin
                    internal_remainder  = internal_remainder - internal_divisor;
                    status_signal <= 1;
                end
                else
                begin
                    status_signal <= 2;
                end
            end
            
            4'b0100:
            begin
                internal_remainder[4:0] <= {internal_remainder[3:0], internal_dividend[3]};
                internal_dividend[3:0] <= {internal_dividend[2:0], 1'b1};
                
                if (count == 0) 
                    status_signal <= 2;
                else
                    status_signal <= -1;
            end
            
            4'b0101:
            begin
                internal_remainder[4:0] <= {internal_remainder[3:0], internal_dividend[3]};
                internal_dividend[3:0] <= {internal_dividend[2:0], 1'b0};

                if (count == 0) 
                    status_signal <= 1;
                else
                    status_signal <= -2;
            end
            
            4'b0110:
            begin
                internal_remainder[4:0] <= { 1'b0, internal_remainder[4:1] };
                status_signal <= 1;
            end
            
            4'b0111:
            begin
                quotient <= internal_dividend[3:0];
                remainder <= internal_remainder[3:0];
                status_signal <= -7;
            end
        endcase    
    end 
endmodule