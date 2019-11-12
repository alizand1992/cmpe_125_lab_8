module control_unit(
        input clk, rst, go,
        input [3:0] status_signal,
        output reg  done, err,
        output reg [3:0] control_signal
    );
    
    always @ (posedge clk)
    begin
        if(!rst && go)
        begin
            control_signal = control_signal + status_signal;
    
            if (control_signal == 4'b0111)
                { done, err } = 2'b10;
            else
                done = 0;
        end   
        else
            control_signal = 0;
    end
endmodule
