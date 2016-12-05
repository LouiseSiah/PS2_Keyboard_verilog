 module PS2_Demo (
	// Inputs
	CLOCK_50,
	KEY,
	SW,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,

	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	// HEX6,
	// HEX7
	LEDG,
	LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;
input		[17:0]SW;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
// output		[6:0]	HEX6;
// output		[6:0]	HEX7;
output 		[7:0] LEDG;
output		[17:0]LEDR;

assign LEDR = SW;
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;
wire				change;
// Internal Registers
reg			[7:0]	last_data_received;
reg			[7:0] new_keycode;
reg			[7:0] display_code;
// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50, negedge KEY[0])
begin
	if (!KEY[0])
	begin
		last_data_received <= 8'h00;
		new_keycode <= 8'h00;
	end
	else
	begin
		if (ps2_key_pressed == 1'b1)
		begin
			last_data_received <= ps2_key_data;
			new_keycode <= last_data_received;
		end
		// else
		// begin
		// end
	end
end

assign change = (last_data_received != new_keycode)? 1:0;

always@(change) begin
	if(change) begin
		if(new_keycode == 8'hF0) begin
			display_code = last_data_received;
			LEDG = 1;
		end
		else begin
			LEDG = 8'hF0;
		end
	end
	else begin
		LEDG = 8'hFF;
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// assign HEX2 = 7'h7F;
// assign HEX3 = 7'h7F;
// assign HEX4 = 7'h7F;
// assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50			(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX1)
);

Hexadecimal_To_Seven_Segment Segment2 (
	// Inputs
	.hex_number			(new_keycode[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX2)
);

Hexadecimal_To_Seven_Segment Segment3 (
	// Inputs
	.hex_number			(new_keycode[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX3)
);


Hexadecimal_To_Seven_Segment Segment4 (
	// Inputs
	.hex_number			(display_code[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX4)
);

Hexadecimal_To_Seven_Segment Segment5 (
	// Inputs
	.hex_number			(display_code[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX5)
);
endmodule
