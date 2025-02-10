// generate random requests for the sram
class RandReq;

	parameter NUM_WMASKS = 32;
	parameter DATA_WIDTH = 256;
	parameter ADDR_WIDTH = 4;
	parameter RAM_DEPTH  = 16; 


    rand bit                    r_w;
    rand bit [NUM_WMASKS-1 :0]  rand_wmask;
    rand bit [DATA_WIDTH-1 :0]  rand_din;
    rand bit [ADDR_WIDTH-1 :0]  rand_addr;

    // leaving it to the default constructor

endclass