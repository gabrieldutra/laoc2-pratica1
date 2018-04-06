module memory (
	address,
	clock,
	data,
	wren,
	q,
	valid);
	
	input	[4:0]  address;
	input	 clock;
	input	[7:0]  data;
	input	  wren;
	output	[7:0]  q;
	output valid;
	
	
	// memory
	reg [4:0] memAddress;
	reg [7:0] memData;
	reg memWren;
	wire [7:0] memOutput;
	
	// cache
	reg [1:0] cacheAddress;
	reg [7:0] cacheData;
	reg cacheWren;
	wire [16:0] cacheOutput;
	
	// output
	reg [7:0] outputData = 8'b00000000;
	reg outputValid = 0;
	
	// current
	reg [4:0] currentAddress = 8'b00000000;
	reg [7:0] currentData;
	reg currentWren = 0;
	
	// local
	reg [2:0] count = 3'b000;
	
	
	
	always @(posedge clock)
	begin
		
		if (outputValid == 1 && ( address != currentAddress || wren != currentWren ))
			begin
				count = 0;
				outputValid = 0;
				currentAddress = address;
				currentWren = currentWren;
				cacheWren = 0;
			end
		
		if (count >= 3'b000 && count <= 3'b100 && outputValid == 0)
			begin
				cacheAddress = count[1:0];
				cacheData = data;
				cacheWren = 0;
				count = count + 1;
				
				if(count != 3'b000 && currentAddress == cacheOutput[10:8]) // Cache Hit
					begin
						if (currentWren)
							begin
								count = 3'b101; // Write in cache
							end
						else		
							begin
								outputData = cacheOutput[7:0];
								outputValid = 1;	
							end			
					end
			end
		
		if (count == 3'b101) // Write in cache
			begin
				// To Do
			end
		
		
		
	end
	
	cache cache(cacheAddress, clock, cacheData, cacheWren, cacheOutput);
	ramlpm ram(memAddress, clock, memData, memWren, memOutput);

	assign valid = outputValid;
	assign q = outputData;
	
endmodule