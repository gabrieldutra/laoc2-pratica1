	module pratica1(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR);
		input [17:0] SW;
		output [0:6] HEX0;
		output [0:6] HEX1;
		output [0:6] HEX2;
		output [0:6] HEX3;
		output [0:6] HEX4;
		output [0:6] HEX5;
		output [0:6] HEX6;
		output [0:6] HEX7;
		output [0:0] LEDR;
		
		// Wires
		wire [4:0] address;
		wire clock;
		wire [7:0] data;
		wire wren;
		wire [7:0] q;
		wire valid;
		
		// Assign for the memory
		assign address = SW[4:0];
		assign clock = SW[6];
		assign data = SW[17:10];
		assign wren = SW[5];
		
		// Displays
		wire [0:6] display1;
		wire [0:6] display2;
		wire [0:6] display3;
		wire [0:6] display4;
		wire [0:6] display5;
		wire [0:6] display6;
		wire [0:6] display7;
		wire [0:6] display8;
		
		// Assign for displays
		assign HEX0 = display1;
		assign HEX1 = display2;
		assign HEX2 = display3;
		assign HEX3 = display4;
		assign HEX4 = display5;
		assign HEX5 = display6;
		assign HEX6 = display7;
		assign HEX7 = display8;
		
		// Led assign
		assign LEDR[0] = valid;
		
		// Address display
		bcd_7seg bcd(address[3:0], display7[0:6]); // Least significant bits as hex
		bcd_7seg bcd2(address[4:4], display8[0:6]); // Most significant bit
		
		// Read/Write display		
		assign display4 = (7'b0110000 & {7{wren}}) | (7'b1110001 & ~{7{wren}}); // Display 'L' when reading and 'E' when writing
		
		// Turn off idle displays
		assign display3 = 7'b1111111;
		
		// Write data displays
		bcd_7seg bcd3(data[3:0], display5[0:6]); // LSB
		bcd_7seg bcd4(data[7:4], display6[0:6]); // MSB
		
		// Memory
		memory memory(address, clock, data, wren, q, valid);
		bcd_7seg bcd5(q[3:0], display1[0:6]);
		bcd_7seg bcd6(q[7:4], display2[0:6]);
		
		/*
		*	SW[6] -> clock
		*	SW[5] -> toggle W/R
		*	SW[4:0] -> memory address
		*	SW[17:10] -> value
		*/
	
	endmodule