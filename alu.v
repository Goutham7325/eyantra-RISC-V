
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        4'b0000:  alu_out <= a + b;       // ADD
        4'b0001:  alu_out <= a + ~b + 1;  // SUB
        4'b0010:  alu_out <= a & b;       // AND
        4'b0011:  alu_out <= a | b;       // OR
        4'b0101:  begin                   // SLT, SLTI
                     if (a[31] != b[31]) alu_out <= a[31] ? 1 : 0;
                     else alu_out <= a < b ? 1 : 0;
                 end
        4'b1101: begin                   // SLTU, SLTIU
                     if (a[31] != b[31]) alu_out <= a[31] ? 0 : 1;
                     else alu_out <= a < b ? 1 : 0;
                 end
		  4'b0110:  alu_out <= a ^ b;       // XOR  
		  4'b0100:  alu_out <= a << b;      // LEFT SHIFT
		  4'b0111:  alu_out <= a >> b;      // RIGHT SHIFT 
		  4'b1111: begin                    // RIGHT SHIFT ARITHMETIC
							if (a[31]) alu_out <= (a >> b[4:0]) | (~((~32'b0) >> b[4:0]));
							else alu_out <= a >> b[4:0];
					end
		  default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

