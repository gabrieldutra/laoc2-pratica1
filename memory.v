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
	reg [16:0] cache[3:0];
	
	// output
	reg [7:0] outputData = 8'b00000000;
	reg outputValid = 0;
	
	// current
	reg [4:0] currentAddress = 8'b00000000;
	reg [7:0] currentData;
	reg currentWren = 0;
	
	// local
	reg [2:0] count = 3'b000;
	
	initial
		begin
			cache[0] = 17'b10000000000000101;
			cache[1] = 17'b10010001000000001;
			cache[2] = 17'b00110010100000101;
			cache[3] = 17'b10100000100000011;
		end
	
	always @(posedge clock)
	begin
		
		if (outputValid == 1 && ( address != currentAddress || wren != currentWren ))
			begin
				outputValid = 0;
				currentAddress = address;
				currentWren = wren;
			end
		
		if (outputValid == 0 && currentAddress == cache[0][12:8] && cache[0][16:16]) // Cache Hit - 1a linha
			begin
				outputValid = 1;
				if (currentWren)
					begin
						cache[0][7:0] = data;
						cache[0][15:15] = 1'b1;
					end
				outputData = cache[0][7:0];
				// Update LRU
				if (cache[0][14:13] > cache[1][14:13]) 
					cache[1][14:13] = cache[1][14:13] + 2'b01;
				if (cache[0][14:13] > cache[2][14:13]) 
					cache[2][14:13] = cache[2][14:13] + 2'b01;
				if (cache[0][14:13] > cache[3][14:13]) 
					cache[3][14:13] = cache[3][14:13] + 2'b01;
				cache[0][14:13] = 2'b00;
			end
			
		
		if (outputValid == 0 && currentAddress == cache[1][12:8] && cache[1][16:16]) // Cache Hit - 2a linha
			begin
				outputValid = 1;
				if (currentWren)
					begin
						cache[1][7:0] = data;
						cache[1][15:15] = 1'b1;
					end
				outputData = cache[1][7:0];
				// Update LRU
				if (cache[1][14:13] > cache[0][14:13]) 
					cache[0][14:13] = cache[0][14:13] + 2'b01;
				if (cache[1][14:13] > cache[2][14:13]) 
					cache[2][14:13] = cache[2][14:13] + 2'b01;
				if (cache[1][14:13] > cache[3][14:13]) 
					cache[3][14:13] = cache[3][14:13] + 2'b01;
				cache[1][14:13] = 2'b00;
			end
			
			
		if (outputValid == 0 && currentAddress == cache[2][12:8] && cache[2][16:16]) // Cache Hit - 3a linha
			begin
				outputValid = 1;
				if (currentWren)
					begin
						cache[2][7:0] = data;
						cache[2][15:15] = 1'b1;
					end
				outputData = cache[2][7:0];
				// Update LRU
				if (cache[2][14:13] > cache[1][14:13]) 
					cache[1][14:13] = cache[1][14:13] + 2'b01;
				if (cache[2][14:13] > cache[0][14:13]) 
					cache[0][14:13] = cache[0][14:13] + 2'b01;
				if (cache[2][14:13] > cache[3][14:13]) 
					cache[3][14:13] = cache[3][14:13] + 2'b01;
				cache[2][14:13] = 2'b00;
			end
			
			
		if (outputValid == 0 && currentAddress == cache[3][12:8] && cache[3][16:16]) // Cache Hit - 4a linha
			begin
				outputValid = 1;
				if (currentWren)
					begin
						cache[3][7:0] = data;
						cache[3][15:15] = 1'b1;
					end
				outputData = cache[3][7:0];
				// Update LRU
				if (cache[3][14:13] > cache[1][14:13]) 
					cache[1][14:13] = cache[1][14:13] + 2'b01;
				if (cache[3][14:13] > cache[2][14:13]) 
					cache[2][14:13] = cache[2][14:13] + 2'b01;
				if (cache[3][14:13] > cache[0][14:13]) 
					cache[0][14:13] = cache[0][14:13] + 2'b01;
				cache[3][14:13] = 2'b00;
			end
		
		
	end
	
	//cache cache(cacheAddress, clock, cacheData, cacheWren, cacheOutput);
	ramlpm ram(memAddress, clock, memData, memWren, memOutput);

	assign valid = outputValid;
	assign q = outputData;
	
endmodule