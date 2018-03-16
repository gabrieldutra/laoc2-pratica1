	module pratica1(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
		input [17:0] SW;
		output [0:6] HEX0;
		output [0:6] HEX1;
		output [0:6] HEX2;
		output [0:6] HEX3;
		output [0:6] HEX4;
		output [0:6] HEX5;
		output [0:6] HEX6;
		output [0:6] HEX7;
		wire [7:0] q;
		
		// Address
		bcd_7seg bcd(SW[4:4], HEX7[0:6]);
		bcd_7seg bcd2(SW[3:0], HEX6[0:6]);
		
		// Read/Write		
		assign HEX3 = (7'b0110000 & {7{SW[5]}}) | (7'b1110001 & ~{7{SW[5]}});
		
		// Turned off Idle Displays
		assign HEX2 = 7'b1111111;
		
		// Write data
		bcd_7seg bcd3(SW[13:10], HEX4[0:6]);
		bcd_7seg bcd4(SW[17:14], HEX5[0:6]);
		
		// Memory
		ramlpm ram(SW[4:0], SW[6], SW[17:10], SW[5], q);
		bcd_7seg bcd5(q[3:0], HEX0[0:6]);
		bcd_7seg bcd6(q[7:4], HEX1[0:6]);
	
	endmodule