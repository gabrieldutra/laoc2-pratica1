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
	reg [4:0] memAddress = 5'b00000;
	reg [7:0] memData = 8'b00000000;
	reg memWren = 0;
	wire [7:0] memOutput;
	reg [1:0] memCount = 2'b00;
	
	// cache
	reg [16:0] cache[3:0];
	
	// output
	reg [7:0] outputData = 8'b00000000;
	reg outputValid = 0;
	
	// current
	reg [4:0] currentAddress = 5'b00000;
	reg [7:0] currentData;
	reg currentWren = 0;
	
	// local
	reg [2:0] count = 3'b000;
	reg [1:0] writeAddress = 2'b00;
	
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
				currentData = data;
				memCount = 0;
			end
		
		// Leitura e Escrita Cache - Cache Hit
		
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
			
		// Cache Miss
		if (outputValid == 0)
			begin
				// Pega o LRU = 3
				if (cache[0][14:13] == 2'b11) writeAddress = 2'b00;
				if (cache[1][14:13] == 2'b11) writeAddress = 2'b01;
				if (cache[2][14:13] == 2'b11) writeAddress = 2'b10;
				if (cache[3][14:13] == 2'b11) writeAddress = 2'b11;			
					
				if (memWren == 1) // Quando a escrita na memória do Write Back é feita
					begin
						memWren = 0;
						cache[writeAddress][15:15] = 0;
					end
					
				if (cache[writeAddress][15:15] == 1) // Write Back
					begin
						memAddress = cache[writeAddress][12:8];
						memData = cache[writeAddress][7:0];
						memWren = 1;
					end
					else begin // Só altera o registro quando o dado não está mais dirty
						if (currentWren) // Escrita no caso de miss
							begin
								cache[writeAddress][16:16] = 1'b1; // Valid
								cache[writeAddress][15:15] = 1'b1; // Dirty
								cache[writeAddress][12:8] = currentAddress;
								cache[writeAddress][7:0] = currentData;
								outputValid = 1;
								// Update LRU
								if (cache[writeAddress][14:13] > cache[1][14:13]) 
									cache[1][14:13] = cache[1][14:13] + 2'b01;
								if (cache[writeAddress][14:13] > cache[2][14:13]) 
									cache[2][14:13] = cache[2][14:13] + 2'b01;
								if (cache[writeAddress][14:13] > cache[0][14:13]) 
									cache[0][14:13] = cache[0][14:13] + 2'b01;
								cache[writeAddress][14:13] = 2'b00;
							end
							else begin // Leitura no caso de miss
								if (memCount == 2'b11) // Clock - Leitura 
									begin
										cache[writeAddress][16:16] = 1'b1; // Valid
										cache[writeAddress][15:15] = 1'b0; // Dirty
										cache[writeAddress][12:8] = currentAddress;
										cache[writeAddress][7:0] = memOutput;
										// Update LRU
										if (cache[writeAddress][14:13] > cache[1][14:13]) 
											cache[1][14:13] = cache[1][14:13] + 2'b01;
										if (cache[writeAddress][14:13] > cache[2][14:13]) 
											cache[2][14:13] = cache[2][14:13] + 2'b01;
										if (cache[writeAddress][14:13] > cache[0][14:13]) 
											cache[0][14:13] = cache[0][14:13] + 2'b01;
										cache[writeAddress][14:13] = 2'b00;
									end
								memAddress = currentAddress;
								memData = 8'b00000000;
								memWren = 0;
								memCount = memCount + 2'b01;
							end
					end
			end
			
		
	end
	
	//cache cache(cacheAddress, clock, cacheData, cacheWren, cacheOutput);
	ramlpm ram(memAddress, clock, memData, memWren, memOutput);

	assign valid = outputValid;
	assign q = outputData;
	
endmodule