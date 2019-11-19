module control_unit(
        input clk, rst, go,
        input [4:0] status_signal,
        output reg  done, err,
        output reg [3:0] control_signal
    );
    
    always @ (posedge clk)
    begin
        if(!rst && go)
        begin
            case(status_signal)
                0: //idle
                begin
                    control_signal <= 1;
                    err <= 0;
                    done <= 0;
                end
                1: // error
                begin
                    control_signal <= 0;
                    err <= 1;
                    done <= 0;
                end
                2: // status ok go to next state
                    control_signal = control_signal + 1;
                3: // remainder less than divisor go to state 4
                    control_signal <= 4;
                4: // remainder more than divisor go to state 4
                    control_signal <= 5;
                5: //  done wit division go to 6
                    control_signal <= 6;
                6: // still dividing go to 3
                    control_signal <= 3;
                7: // done with everything go to 1
                    control_signal <= 1;
            endcase
        end   
        else
            control_signal = 0;
    end
endmodule
