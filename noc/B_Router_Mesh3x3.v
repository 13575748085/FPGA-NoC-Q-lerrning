module B_Router_Mesh3x3(clk, reset,
enroute,RouteInfoIn,ReqRoute,Sor_DesInfo,Q_learn_ready,switch,done);  
// ------------------------ Parameter Declarations --------------------------- //
parameter routerID 		= 6'b000000; 
parameter ModuleID 	  	= 6'b000000;
parameter packetwidth   	= 55; 
parameter datawidth   	= 25;
parameter addressWidth	= 4;//fifo addr
parameter fifoDepth 		=  ( ( 1 << addressWidth ) - 1 ); 
// ------------------------ Inputs Declarations ------------------------------ //
input wire clk;
input wire reset;
input wire enroute;
input wire [29:0] RouteInfoIn;
input wire Q_learn_ready;
input wire switch;
output wire ReqRoute;
output wire [9:0] Sor_DesInfo;
output wire done;
/*  	  x   y		  x   y		  x   y		
		-000,000(1-	-001,000(2-	-010,000(3-	
			 |			 |			 |		
			 |			 |			 |		 
		-000,001(4-	-001,001(5-	-010,001(6-	
			 |			 |			 |		
			 |			 |			 |		
		-000,010(7-	-001,010(8-	-010,010(9-	
*/			
//#######################        Request Signals     ############################			
//east to west																	|| Not Connected ||
wire eastReq_000_000_w, eastReq_001_000_w, eastReq_010_000_w;
wire eastReq_000_001_w, eastReq_001_001_w, eastReq_010_001_w;
wire eastReq_000_010_w, eastReq_001_010_w, eastReq_010_010_w;
//north to south
wire northReq_000_000_s, northReq_001_000_s, northReq_010_000_s;//Not connected
wire northReq_000_001_s, northReq_001_001_s, northReq_010_001_s;
wire northReq_000_010_s, northReq_001_010_s, northReq_010_010_s;
//west to east
wire westReq_000_000_e, westReq_001_000_e, westReq_010_000_e;
wire westReq_000_001_e, westReq_001_001_e, westReq_010_001_e;
wire westReq_000_010_e, westReq_001_010_e, westReq_010_010_e;
//south to north
wire southReq_000_000_n, southReq_001_000_n, southReq_010_000_n;
wire southReq_000_001_n, southReq_001_001_n, southReq_010_001_n;
wire southReq_000_010_n, southReq_001_010_n, southReq_010_010_n;
//Local UpStr
wire  localReqUpStr_000_000, localReqUpStr_001_000,localReqUpStr_010_000;
wire  localReqUpStr_000_001, localReqUpStr_001_001,localReqUpStr_010_001;
wire  localReqUpStr_000_010, localReqUpStr_001_010,localReqUpStr_010_010;		
//Local DnStr
wire  localReqDnStr_000_000, localReqDnStr_001_000,localReqDnStr_010_000;
wire  localReqDnStr_000_001, localReqDnStr_001_001,localReqDnStr_010_001;
wire  localReqDnStr_000_010, localReqDnStr_001_010,localReqDnStr_010_010;		
//#######################        Grant Signals     ############################
//east to west
wire eastGnt_000_000_w, eastGnt_001_000_w, eastGnt_010_000_w;
wire eastGnt_000_001_w, eastGnt_001_001_w, eastGnt_010_001_w;
wire eastGnt_000_010_w, eastGnt_001_010_w, eastGnt_010_010_w;
//north to south
wire northGnt_000_000_s, northGnt_001_000_s, northGnt_010_000_s;
wire northGnt_000_001_s, northGnt_001_001_s, northGnt_010_001_s;
wire northGnt_000_010_s, northGnt_001_010_s, northGnt_010_010_s;
//west to east
wire westGnt_000_000_e, westGnt_001_000_e, westGnt_010_000_e;
wire westGnt_000_001_e, westGnt_001_001_e, westGnt_010_001_e;
wire westGnt_000_010_e, westGnt_001_010_e, westGnt_010_010_e;
//south to north
wire southGnt_000_000_n, southGnt_001_000_n, southGnt_010_000_n;
wire southGnt_000_001_n, southGnt_001_001_n, southGnt_010_001_n;
wire southGnt_000_010_n, southGnt_001_010_n, southGnt_010_010_n;
//Local UpStr
wire  localGntUpStr_000_000, localGntUpStr_001_000,localGntUpStr_010_000;
wire  localGntUpStr_000_001, localGntUpStr_001_001,localGntUpStr_010_001;
wire  localGntUpStr_000_010, localGntUpStr_001_010,localGntUpStr_010_010;		
//Local  DnStr
wire  localGntDnStr_000_000, localGntDnStr_001_000,localGntDnStr_010_000;
wire  localGntDnStr_000_001, localGntDnStr_001_001,localGntDnStr_010_001;
wire  localGntDnStr_000_010, localGntDnStr_001_010,localGntDnStr_010_010;		
//#######################        Full Signals     ###############################
//east to west
wire eastFull_000_000_w, eastFull_001_000_w, eastFull_010_000_w;
wire eastFull_000_001_w, eastFull_001_001_w, eastFull_010_001_w;
wire eastFull_000_010_w, eastFull_001_010_w, eastFull_010_010_w;
//north to south
wire northFull_000_000_s, northFull_001_000_s, northFull_010_000_s;
wire northFull_000_001_s, northFull_001_001_s, northFull_010_001_s;
wire northFull_000_010_s, northFull_001_010_s, northFull_010_010_s;
//west to east
wire westFull_000_000_e, westFull_001_000_e, westFull_010_000_e;
wire westFull_000_001_e, westFull_001_001_e, westFull_010_001_e;
wire westFull_000_010_e, westFull_001_010_e, westFull_010_010_e;
//south to north
wire southFull_000_000_n, southFull_001_000_n, southFull_010_000_n;
wire southFull_000_001_n, southFull_001_001_n, southFull_010_001_n;
wire southFull_000_010_n, southFull_001_010_n, southFull_010_010_n;

//Local UpStr
wire  localUpStrFull_000_000, localUpStrFull_001_000,localUpStrFull_010_000;
wire  localUpStrFull_000_001, localUpStrFull_001_001,localUpStrFull_010_001;
wire  localUpStrFull_000_010, localUpStrFull_001_010,localUpStrFull_010_010;		
//Local  DnStr
wire  localDnStrFull_000_000, localDnStrFull_001_000,localDnStrFull_010_000;
wire  localDnStrFull_000_001, localDnStrFull_001_001,localDnStrFull_010_001;
wire  localDnStrFull_000_010, localDnStrFull_001_010,localDnStrFull_010_010;		
//####################### Packets between ports   ###############################
//east to west
wire [packetwidth-1:0] eastPacket_000_000_w, eastPacket_001_000_w, eastPacket_010_000_w; 
wire [packetwidth-1:0] eastPacket_000_001_w, eastPacket_001_001_w, eastPacket_010_001_w; 
wire [packetwidth-1:0] eastPacket_000_010_w, eastPacket_001_010_w, eastPacket_010_010_w; 
//north to south
wire [packetwidth-1:0] northPacket_000_000_s, northPacket_001_000_s, northPacket_010_000_s; 
wire [packetwidth-1:0] northPacket_000_001_s, northPacket_001_001_s, northPacket_010_001_s; 
wire [packetwidth-1:0] northPacket_000_010_s, northPacket_001_010_s, northPacket_010_010_s; 
//west to east
wire [packetwidth-1:0] westPacket_000_000_e, westPacket_001_000_e, westPacket_010_000_e; 
wire [packetwidth-1:0] westPacket_000_001_e, westPacket_001_001_e, westPacket_010_001_e; 
wire [packetwidth-1:0] westPacket_000_010_e, westPacket_001_010_e, westPacket_010_010_e; 
//south to north
wire [packetwidth-1:0] southPacket_000_000_n, southPacket_001_000_n, southPacket_010_000_n; 
wire [packetwidth-1:0] southPacket_000_001_n, southPacket_001_001_n, southPacket_010_001_n; 
wire [packetwidth-1:0] southPacket_000_010_n, southPacket_001_010_n, southPacket_010_010_n; 
//Local localPacketIn
wire [packetwidth-1:0] localPacketIn_000_000, localPacketIn_001_000,localPacketIn_010_000;
wire [packetwidth-1:0] localPacketIn_000_001, localPacketIn_001_001,localPacketIn_010_001;
wire [packetwidth-1:0] localPacketIn_000_010, localPacketIn_001_010,localPacketIn_010_010;
//Local  localPacketOut
wire [packetwidth-1:0] localPacketOut_000_000, localPacketOut_001_000,localPacketOut_010_000;
wire [packetwidth-1:0] localPacketOut_000_001, localPacketOut_001_001,localPacketOut_010_001;
wire [packetwidth-1:0] localPacketOut_000_010, localPacketOut_001_010,localPacketOut_010_010;
/*
###########################     Routers Intantiation    #################################
#########################################################################################
####################### Instantiate of Router 000_000 ###################################
#########################################################################################
*/
 Base_Router # (.routerNo(5'b00001),.routerID(6'b000_000),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_000_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_000_e), 
 .eastGntUpStr(eastGnt_000_000_w), 
 .eastUpStrFull(eastFull_000_000_w), 
 .eastPacketIn(westPacket_001_000_e),
 .eastReqDnStr(eastReq_000_000_w), 
 .eastGntDnStr(westGnt_001_000_e),
 .eastDnStrFull(westFull_001_000_e),  
 .eastPacketOut(eastPacket_000_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_001_s), 
 .southGntUpStr(southGnt_000_000_n), 
 .southUpStrFull(southFull_000_000_n),
 .southPacketIn(northPacket_000_001_s),
 .southReqDnStr(southReq_000_000_n),
 .southGntDnStr(northGnt_000_001_s), 
 .southDnStrFull(northFull_000_001_s), 
 .southPacketOut(southPacket_000_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_000), 
 .localGntUpStr(localGntUpStr_000_000), 
 .localUpStrFull(localUpStrFull_000_000),
 .localPacketIn(localPacketIn_000_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_000), 
 .localDnStrFull(localDnStrFull_000_000), 
 .localGntDnStr(localGntDnStr_000_000), 
 .localPacketOut(localPacketOut_000_000)
); 
//######################################################################################
//####################### Instantiate of Router 001_000 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00010),.routerID(6'b001_000),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_001_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_000_e), 
 .eastGntUpStr(eastGnt_001_000_w), 
 .eastUpStrFull(eastFull_001_000_w), 
 .eastPacketIn(westPacket_010_000_e),
 .eastReqDnStr(eastReq_001_000_w), 
 .eastGntDnStr(westGnt_010_000_e),
 .eastDnStrFull(westFull_010_000_e),  
 .eastPacketOut(eastPacket_001_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_000_000_w),  
 .westGntUpStr(westGnt_001_000_e),
 .westUpStrFull(westFull_001_000_e),  
 .westPacketIn(eastPacket_000_000_w),
 .westReqDnStr(westReq_001_000_e),  
 .westGntDnStr(eastGnt_000_000_w), 
 .westDnStrFull(eastFull_000_000_w),
 .westPacketOut(westPacket_001_000_e),
 //******************************
 .southReqUpStr(northReq_001_001_s), 
 .southGntUpStr(southGnt_001_000_n), 
 .southUpStrFull(southFull_001_000_n),
 .southPacketIn(northPacket_001_001_s),
 .southReqDnStr(southReq_001_000_n),
 .southGntDnStr(northGnt_001_001_s), 
 .southDnStrFull(northFull_001_001_s), 
 .southPacketOut(southPacket_001_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_000), 
 .localGntUpStr(localGntUpStr_001_000), 
 .localUpStrFull(localUpStrFull_001_000),
 .localPacketIn(localPacketIn_001_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_000), 
 .localDnStrFull(localDnStrFull_001_000), 
 .localGntDnStr(localGntDnStr_001_000), 
 .localPacketOut(localPacketOut_001_000)
); 
//######################################################################################
//####################### Instantiate of Router 010_000 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00011),.routerID(6'b010_000),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_010_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_001_000_w),  
 .westGntUpStr(westGnt_010_000_e),
 .westUpStrFull(westFull_010_000_e),  
 .westPacketIn(eastPacket_001_000_w),
 .westReqDnStr(westReq_010_000_e),  
 .westGntDnStr(eastGnt_001_000_w), 
 .westDnStrFull(eastFull_001_000_w),
 .westPacketOut(westPacket_010_000_e),
 //******************************
 .southReqUpStr(northReq_010_001_s), 
 .southGntUpStr(southGnt_010_000_n), 
 .southUpStrFull(southFull_010_000_n),
 .southPacketIn(northPacket_010_001_s),
 .southReqDnStr(southReq_010_000_n),
 .southGntDnStr(northGnt_010_001_s), 
 .southDnStrFull(northFull_010_001_s), 
 .southPacketOut(southPacket_010_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_000), 
 .localGntUpStr(localGntUpStr_010_000), 
 .localUpStrFull(localUpStrFull_010_000),
 .localPacketIn(localPacketIn_010_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_000), 
 .localDnStrFull(localDnStrFull_010_000), 
 .localGntDnStr(localGntDnStr_010_000), 
 .localPacketOut(localPacketOut_010_000)
); 
//######################################################################################
//######################################################################################
//##########################        Second row        ##################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_001 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00100),.routerID(6'b000_001),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_000_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_001_e), 
 .eastGntUpStr(eastGnt_000_001_w), 
 .eastUpStrFull(eastFull_000_001_w), 
 .eastPacketIn(westPacket_001_001_e),
 .eastReqDnStr(eastReq_000_001_w), 
 .eastGntDnStr(westGnt_001_001_e),
 .eastDnStrFull(westFull_001_001_e),  
 .eastPacketOut(eastPacket_000_001_w),
 //******************************
 .northReqUpStr(southReq_000_000_n), 
 .northUpStrFull(northFull_000_001_s),
 .northGntUpStr(northGnt_000_001_s),
 .northPacketIn(southPacket_000_000_n),
 .northReqDnStr(northReq_000_001_s), 
 .northDnStrFull(southFull_000_000_n),
 .northGntDnStr(southGnt_000_000_n), 
 .northPacketOut(northPacket_000_001_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_010_s), 
 .southGntUpStr(southGnt_000_001_n), 
 .southUpStrFull(southFull_000_001_n),
 .southPacketIn(northPacket_000_010_s),
 .southReqDnStr(southReq_000_001_n),
 .southGntDnStr(northGnt_000_010_s), 
 .southDnStrFull(northFull_000_010_s), 
 .southPacketOut(southPacket_000_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_001), 
 .localGntUpStr(localGntUpStr_000_001), 
 .localUpStrFull(localUpStrFull_000_001),
 .localPacketIn(localPacketIn_000_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_001), 
 .localDnStrFull(localDnStrFull_000_001), 
 .localGntDnStr(localGntDnStr_000_001), 
 .localPacketOut(localPacketOut_000_001)
); 
//######################################################################################
//####################### Instantiate of Router 001_001 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00101),.routerID(6'b001_001),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_001_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_001_e), 
 .eastGntUpStr(eastGnt_001_001_w), 
 .eastUpStrFull(eastFull_001_001_w), 
 .eastPacketIn(westPacket_010_001_e),
 .eastReqDnStr(eastReq_001_001_w), 
 .eastGntDnStr(westGnt_010_001_e),
 .eastDnStrFull(westFull_010_001_e),  
 .eastPacketOut(eastPacket_001_001_w),
 //******************************
 .northReqUpStr(southReq_001_000_n), 
 .northUpStrFull(northFull_001_001_s),
 .northGntUpStr(northGnt_001_001_s),
 .northPacketIn(southPacket_001_000_n),
 .northReqDnStr(northReq_001_001_s), 
 .northDnStrFull(southFull_001_000_n),
 .northGntDnStr(southGnt_001_000_n), 
 .northPacketOut(northPacket_001_001_s),
 //******************************
 
 .westReqUpStr(eastReq_000_001_w),  
 .westGntUpStr(westGnt_001_001_e),
 .westUpStrFull(westFull_001_001_e),  
 .westPacketIn(eastPacket_000_001_w),
 .westReqDnStr(westReq_001_001_e),  
 .westGntDnStr(eastGnt_000_001_w), 
 .westDnStrFull(eastFull_000_001_w),
 .westPacketOut(westPacket_001_001_e),
 //******************************
 .southReqUpStr(northReq_001_010_s), 
 .southGntUpStr(southGnt_001_001_n), 
 .southUpStrFull(southFull_001_001_n),
 .southPacketIn(northPacket_001_010_s),
 .southReqDnStr(southReq_001_001_n),
 .southGntDnStr(northGnt_001_010_s), 
 .southDnStrFull(northFull_001_010_s), 
 .southPacketOut(southPacket_001_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_001), 
 .localGntUpStr(localGntUpStr_001_001), 
 .localUpStrFull(localUpStrFull_001_001),
 .localPacketIn(localPacketIn_001_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_001), 
 .localDnStrFull(localDnStrFull_001_001), 
 .localGntDnStr(localGntDnStr_001_001), 
 .localPacketOut(localPacketOut_001_001)
); 
//######################################################################################
//####################### Instantiate of Router 010_001 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00110),.routerID(6'b010_001),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_010_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_010_000_n), 
 .northUpStrFull(northFull_010_001_s),
 .northGntUpStr(northGnt_010_001_s),
 .northPacketIn(southPacket_010_000_n),
 .northReqDnStr(northReq_010_001_s), 
 .northDnStrFull(southFull_010_000_n),
 .northGntDnStr(southGnt_010_000_n), 
 .northPacketOut(northPacket_010_001_s),
 //******************************
 .westReqUpStr(eastReq_001_001_w),  
 .westGntUpStr(westGnt_010_001_e),
 .westUpStrFull(westFull_010_001_e),  
 .westPacketIn(eastPacket_001_001_w),
 .westReqDnStr(westReq_010_001_e),  
 .westGntDnStr(eastGnt_001_001_w), 
 .westDnStrFull(eastFull_001_001_w),
 .westPacketOut(westPacket_010_001_e),
 //******************************
 .southReqUpStr(northReq_010_010_s), 
 .southGntUpStr(southGnt_010_001_n), 
 .southUpStrFull(southFull_010_001_n),
 .southPacketIn(northPacket_010_010_s),
 .southReqDnStr(southReq_010_001_n),
 .southGntDnStr(northGnt_010_010_s), 
 .southDnStrFull(northFull_010_010_s), 
 .southPacketOut(southPacket_010_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_001), 
 .localGntUpStr(localGntUpStr_010_001), 
 .localUpStrFull(localUpStrFull_010_001),
 .localPacketIn(localPacketIn_010_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_001), 
 .localDnStrFull(localDnStrFull_010_001), 
 .localGntDnStr(localGntDnStr_010_001), 
 .localPacketOut(localPacketOut_010_001)
); 
//######################################################################################
//######################################################################################
//##########################         Third row        ##################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_010 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b00111),.routerID(6'b000_010),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_000_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_010_e), 
 .eastGntUpStr(eastGnt_000_010_w), 
 .eastUpStrFull(eastFull_000_010_w), 
 .eastPacketIn(westPacket_001_010_e),
 .eastReqDnStr(eastReq_000_010_w), 
 .eastGntDnStr(westGnt_001_010_e),
 .eastDnStrFull(westFull_001_010_e),  
 .eastPacketOut(eastPacket_000_010_w),
 //******************************
 .northReqUpStr(southReq_000_001_n), 
 .northUpStrFull(northFull_000_010_s),
 .northGntUpStr(northGnt_000_010_s),
 .northPacketIn(southPacket_000_001_n),
 .northReqDnStr(northReq_000_010_s), 
 .northDnStrFull(southFull_000_001_n),
 .northGntDnStr(southGnt_000_001_n), 
 .northPacketOut(northPacket_000_010_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_010), 
 .localGntUpStr(localGntUpStr_000_010), 
 .localUpStrFull(localUpStrFull_000_010),
 .localPacketIn(localPacketIn_000_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_010), 
 .localDnStrFull(localDnStrFull_000_010), 
 .localGntDnStr(localGntDnStr_000_010), 
 .localPacketOut(localPacketOut_000_010)
); 
//######################################################################################
//####################### Instantiate of Router 001_010 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b01000),.routerID(6'b001_010),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_001_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_010_e), 
 .eastGntUpStr(eastGnt_001_010_w), 
 .eastUpStrFull(eastFull_001_010_w), 
 .eastPacketIn(westPacket_010_010_e),
 .eastReqDnStr(eastReq_001_010_w), 
 .eastGntDnStr(westGnt_010_010_e),
 .eastDnStrFull(westFull_010_010_e),  
 .eastPacketOut(eastPacket_001_010_w),
 //******************************
 .northReqUpStr(southReq_001_001_n), 
 .northUpStrFull(northFull_001_010_s),
 .northGntUpStr(northGnt_001_010_s),
 .northPacketIn(southPacket_001_001_n),
 .northReqDnStr(northReq_001_010_s), 
 .northDnStrFull(southFull_001_001_n),
 .northGntDnStr(southGnt_001_001_n), 
 .northPacketOut(northPacket_001_010_s),
 //******************************
 .westReqUpStr(eastReq_000_010_w),  
 .westGntUpStr(westGnt_001_010_e),
 .westUpStrFull(westFull_001_010_e),  
 .westPacketIn(eastPacket_000_010_w),
 .westReqDnStr(westReq_001_010_e),  
 .westGntDnStr(eastGnt_000_010_w), 
 .westDnStrFull(eastFull_000_010_w),
 .westPacketOut(westPacket_001_010_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_010), 
 .localGntUpStr(localGntUpStr_001_010), 
 .localUpStrFull(localUpStrFull_001_010),
 .localPacketIn(localPacketIn_001_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_010), 
 .localDnStrFull(localDnStrFull_001_010), 
 .localGntDnStr(localGntDnStr_001_010), 
 .localPacketOut(localPacketOut_001_010)
); 
//######################################################################################
//####################### Instantiate of Router 010_010 ################################
//######################################################################################
 Base_Router # (.routerNo(5'b01001),.routerID(6'b010_010),.packetwidth(packetwidth),
 .addressWidth(addressWidth) ,.fifoDepth(fifoDepth)) Router_010_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_010_001_n), 
 .northUpStrFull(northFull_010_010_s),
 .northGntUpStr(northGnt_010_010_s),
 .northPacketIn(southPacket_010_001_n),
 .northReqDnStr(northReq_010_010_s), 
 .northDnStrFull(southFull_010_001_n),
 .northGntDnStr(southGnt_010_001_n), 
 .northPacketOut(northPacket_010_010_s),
 //******************************
 .westReqUpStr(eastReq_001_010_w),  
 .westGntUpStr(westGnt_010_010_e),
 .westUpStrFull(westFull_010_010_e),  
 .westPacketIn(eastPacket_001_010_w),
 .westReqDnStr(westReq_010_010_e),  
 .westGntDnStr(eastGnt_001_010_w), 
 .westDnStrFull(eastFull_001_010_w),
 .westPacketOut(westPacket_010_010_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_010), 
 .localGntUpStr(localGntUpStr_010_010), 
 .localUpStrFull(localUpStrFull_010_010),
 .localPacketIn(localPacketIn_010_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_010), 
 .localDnStrFull(localDnStrFull_010_010), 
 .localGntDnStr(localGntDnStr_010_010), 
 .localPacketOut(localPacketOut_010_010)
); 
//#########################################################################################
//#########################################################################################
//###########################                             #################################
//###########################   Modules(PEs) Intantiation #################################
//###########################                             #################################
//#########################################################################################
//###########################            First row        #################################
//###########################                             #################################
//#########################################################################################
//#########################################################################################
//#######################  Instantiate of PE_Module 000_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################

Injector_000_000 # (.ModuleID(6'b000_000),.packetwidth(packetwidth)) Local_Injector_000_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_000),
 .GntDnStr(localGntUpStr_000_000),
 .DnStrFull(localUpStrFull_000_000),
 .PacketOut(localPacketIn_000_000),
 .enroute(enroute),
 .RouteInfoIn(RouteInfoIn),
 .ReqRoute(ReqRoute),
 .Sor_DesInfo(Sor_DesInfo),//Packet in from local port
 .Q_learn_ready(Q_learn_ready),
 .switch(switch)
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_000 # (.ModuleID(6'b000_000),.packetwidth(packetwidth)) Local_Collector_000_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_000),
 .GntUpStr(localGntDnStr_000_000), 
 .UpStrFull(localDnStrFull_000_000),
 .PacketIn(localPacketOut_000_000) 
);
//#########################################################################################
//#######################  Instantiate of PE_Module 001_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_000 # (.ModuleID(6'b000_001),.packetwidth(packetwidth)) Local_Injector_001_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_000),
 .GntDnStr(localGntUpStr_001_000),
 .DnStrFull(localUpStrFull_001_000),
 .PacketOut(localPacketIn_001_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_000 # (.ModuleID(6'b000_001),.packetwidth(packetwidth)) Local_Collector_001_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_000),
 .GntUpStr(localGntDnStr_001_000), 
 .UpStrFull(localDnStrFull_001_000),
 .PacketIn(localPacketOut_001_000) 
);


//########################################################################################
//#######################  Instantiate of PE_Module 010_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_000 # (.ModuleID(6'b000_010),.packetwidth(packetwidth)) Local_Injector_010_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_000),
 .GntDnStr(localGntUpStr_010_000),
 .DnStrFull(localUpStrFull_010_000),
 .PacketOut(localPacketIn_010_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_000 # (.ModuleID(6'b000_010),.packetwidth(packetwidth)) Local_Collector_010_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_000),
 .GntUpStr(localGntDnStr_010_000), 
 .UpStrFull(localDnStrFull_010_000),
 .PacketIn(localPacketOut_010_000) 
);

//#########################################################################################
//###########################          Second row         #################################
//###########################                             #################################
//#########################################################################################
//##################################### - 3 - #############################################
//#######################  Instantiate of PE_Module 000_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_001 # (.ModuleID(6'b000_011),.packetwidth(packetwidth)) Local_Injector_000_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_001),
 .GntDnStr(localGntUpStr_000_001),
 .DnStrFull(localUpStrFull_000_001),
 .PacketOut(localPacketIn_000_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_001 # (.ModuleID(6'b000_011),.packetwidth(packetwidth)) Local_Collector_000_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_001),
 .GntUpStr(localGntDnStr_000_001), 
 .UpStrFull(localDnStrFull_000_001),
 .PacketIn(localPacketOut_000_001) 
 );

//###################################### - 4 - ############################################
//#######################  Instantiate of PE_Module 001_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_001 # (.ModuleID(6'b000_100),.packetwidth(packetwidth)) Local_Injector_001_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_001),
 .GntDnStr(localGntUpStr_001_001),
 .DnStrFull(localUpStrFull_001_001),
 .PacketOut(localPacketIn_001_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_001 # (.ModuleID(6'b000_100),.packetwidth(packetwidth)) Local_Collector_001_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_001),
 .GntUpStr(localGntDnStr_001_001), 
 .UpStrFull(localDnStrFull_001_001),
 .PacketIn(localPacketOut_001_001) 
);

//####################################### - 5 - ###########################################
//#######################  Instantiate of PE_Module 010_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_001 # (.ModuleID(6'b000_101),.packetwidth(packetwidth)) Local_Injector_010_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_001),
 .GntDnStr(localGntUpStr_010_001),
 .DnStrFull(localUpStrFull_010_001),
 .PacketOut(localPacketIn_010_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_001 # (.ModuleID(6'b000_101),.packetwidth(packetwidth)) Local_Collector_010_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_001),
 .GntUpStr(localGntDnStr_010_001), 
 .UpStrFull(localDnStrFull_010_001),
 .PacketIn(localPacketOut_010_001) 
);

//#########################################################################################
//###########################            Third row        #################################
//###########################                             #################################
//#########################################################################################
//###################################### - 6 - ###########################################
//#######################  Instantiate of PE_Module 000_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_010 # (.ModuleID(6'b000_110),.packetwidth(packetwidth)) Local_Injector_000_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_010),
 .GntDnStr(localGntUpStr_000_010),
 .DnStrFull(localUpStrFull_000_010),
 .PacketOut(localPacketIn_000_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_010 # (.ModuleID(6'b000_110),.packetwidth(packetwidth)) Local_Collector_000_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_010),
 .GntUpStr(localGntDnStr_000_010), 
 .UpStrFull(localDnStrFull_000_010),
 .PacketIn(localPacketOut_000_010) 
);
//##################################### - 7 - ############################################
//#######################  Instantiate of PE_Module 001_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_010 # (.ModuleID(6'b000_111),.packetwidth(packetwidth)) Local_Injector_001_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_010),
 .GntDnStr(localGntUpStr_001_010),
 .DnStrFull(localUpStrFull_001_010),
 .PacketOut(localPacketIn_001_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_010 # (.ModuleID(6'b000_111),.packetwidth(packetwidth)) Local_Collector_001_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_010),
 .GntUpStr(localGntDnStr_001_010), 
 .UpStrFull(localDnStrFull_001_010),
 .PacketIn(localPacketOut_001_010) 
);
//###################################### - 8 - ###########################################
//#######################  Instantiate of PE_Module 010_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_010 # (.ModuleID(6'b001_000),.packetwidth(packetwidth)) Local_Injector_010_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_010),
 .GntDnStr(localGntUpStr_010_010),
 .DnStrFull(localUpStrFull_010_010),
 .PacketOut(localPacketIn_010_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_010 # (.ModuleID(6'b001_000),.packetwidth(packetwidth)) Local_Collector_010_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_010),
 .GntUpStr(localGntDnStr_010_010), 
 .UpStrFull(localDnStrFull_010_010),
 .PacketIn(localPacketOut_010_010) ,
 .done(done)
);

//#########################################################################################
endmodule
//#########################################################################################

