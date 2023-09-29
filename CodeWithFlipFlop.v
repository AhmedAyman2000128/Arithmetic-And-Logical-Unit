module logic_unit(
    input [3:0] op1,op2,
    input [2:0] opcode,
    output reg [3:0] result
);
    always @* begin
        case (opcode)
            3'b000: result = ~op1;
            3'b001: result = ~op2;
            3'b010: result = op1 & op2;
            3'b011: result = op1 | op2;
            3'b100: result = op1 ^ op2;
            3'b101: result = ~(op1 ^ op2);
            3'b110: result = ~(op1 & op2);
            3'b111: result = ~(op1 | op2);
        endcase
    end
endmodule

module Arithmetic_unit(
    input signed[3:0] op1,op2,
    input [2:0] opcode,
    output reg signed [5:0] result
);

    always @* begin
        case (opcode)
            3'b000: result = op1 + 1;
            3'b001: result = op1 - 1;
            3'b010: result = op1 << 1;
            3'b011: result = op2 + 1;
            3'b100: result = op2 - 1;
            3'b101: result = op2 << 1;
            3'b110: result = op1 + op2;
            3'b111: result = op1 << 2;
        endcase
    end
    
endmodule

module mux_2to1(
    input [3:0] input1,
    input  signed[5:0] input0,
    input select,
    output reg signed [5:0] out
);
    always @* begin
        if (select == 1'b0) begin
            out = input0;
        end
        else begin
            out = input1;
        end
    end
endmodule

module d_ff(
  input reg clk, // clock input
  input reg reset, // asynchronous reset input
  input reg signed [3:0]d, // data input
  output reg signed[3:0]q // output
);
  
   always @(posedge clk or negedge reset) begin
    if (reset == 1'b1) begin
      q <= 1'b0; // set output to 0 on reset
    end
    else begin
      q <= d; // set output to input on clock edge
    end
  end
  
endmodule

module d_ff6(
  input reg clk, // clock input
  input reg reset, // asynchronous reset input
  input reg signed[5:0]d, // data input
  output reg signed [5:0]q // output
);
  
   always @(posedge clk or negedge reset) begin
    if (reset == 1'b1) begin
      q <= 1'b0; // set output to 0 on reset
    end
    else begin
   // always @* begin
      q <= d; // set output to input on clock edge
    end
 end
endmodule

module project(
  input reg reset,
  input reg clk,
  input  signed [3:0]a,b ,
  input [3:0]sel,
  output wire signed [5:0]z
  );
  wire [3:0] res2;
  wire signed[5:0] res1;
  wire signed[5:0]y;
  wire signed[3:0]c,d;
  wire signed[5:0]outq;
  d_ff dff_A (.clk(clk),.reset(reset), .d(a), .q(c));
  d_ff dff_B (.clk(clk),.reset(reset), .d(b), .q(d)); 
  logic_unit l1(.op1(c),.op2(d),.opcode(sel[2:0]),.result(res2));
  Arithmetic_unit a1(.op1(c),.op2(d),.opcode(sel[2:0]),.result(res1));
  mux_2to1 m1(.input0(res1),.input1(res2),.select(sel[3]),.out(y));
  d_ff6 dff_C (.clk(clk),.reset(reset), .d(y), .q(z));

endmodule


module PRO_DUT();
  reg reset;
  reg clk;
  reg signed[3:0]A,B;
  reg [3:0]sel;
  wire signed[5:0]Z;
  integer s,a,b;
  initial begin
      reset = 0; // set reset signal to 1
      clk=1;	
      A = 0;
      B = 0;
      sel = 0;
      for(a=-8;a<=7;a=a+1)begin
        for(b=-8;b<=7;b=b+1)begin
           for(s=0;s<=15;s=s+1) begin
            sel=s; A=a;B=b;#100;
      
	    clk=0;
	    #5;
	    clk=1;
            #10;
	    clk=0;
 	   // #100;
           end
         end
      end
    end
  project A1(reset,clk,A,B,sel,Z);
  initial begin
    $display("reset   sel      A       B      Z      clk      sel     A      B      Z  \n");
    $monitor("%b    %b    %b    %b    %b    %b    %d    %d    %d    %d ",reset,sel,A,B,Z,clk,sel,A,B,Z);
    end 
endmodule


