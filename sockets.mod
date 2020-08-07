MODULE sockets;

IMPORT SYSTEM;

CONST 
  SockStream*    = 1;      
  SockDgram*     = 2;      
  SockRaw*       = 3;      
  SockRdm*       = 4;      
  SockSeqpacket* = 5;      
  SockDccp*      = 6;      
  SockPacket*    = 10;      
     
  AfUnscec*     = 0;   (* Unspecified.  *)          
  AfLocal*      = 1;   (* Local to host (pipes and file-domain).  *)          
  AfUnix*       = 1;   (* POSIX name for PF_LOCAL.  *)          
  AfFile*       = 1;   (* Another non-standard name for PF_LOCAL.  *)          
  AfInet*       = 2;   (* IP protocol family.  *)          
  AfAx25*       = 3;   (* Amateur Radio AX.25.  *)          
  AfIpx*        = 4;   (* Novell Internet Protocol.  *)          
  AfAppletalk*  = 5;   (* Appletalk DDP.  *)          
  AfNetrom*     = 6;   (* Amateur radio NetROM.  *)          
  AfBridge*     = 7;   (* Multiprotocol bridge.  *)          
  AfAtmpvc*     = 8;   (* ATM PVCs.  *)          
  AfX25*        = 9;   (* Reserved for X.25 project.  *)          
  AfInet6*      = 10;  (* IP version 6.  *)          
  AfRose*       = 11;  (* Amateur Radio X.25 PLP.  *)          
  AfDecnet*     = 12;  (* Reserved for DECnet project.  *)          
  AfNetbeui*    = 13;  (* Reserved for 802.2LLC project.  *)          
  AfSecurity*   = 14;  (* Security callback pseudo AF.  *)          
  AfKey*        = 15;  (* PF_KEY key management API.  *)          
  AfNetlink*    = 16;       
  AfRoute*      = 16;  (* Alias to emulate 4.4BSD.  *)          
  AfPacket      = 17;  (* Packet family.  *)          
  AfAsh         = 18;  (* Ash.  *)          
  AfEconet*     = 19;  (* Acorn Econet.  *)          
  AfAtmsvc*     = 20;  (* ATM SVCs.  *)          
  AfRds*        = 21;  (* RDS sockets.  *)          
  AfSna         = 22;  (* Linux SNA Project *)          
  AfIrda*       = 23;  (* IRDA sockets.  *)          
  AfPppox       = 24;  (* PPPoX sockets.  *)          
  AfWanpipe*    = 25;  (* Wanpipe API sockets.  *)          
  AfLlc*        = 26;  (* Linux LLC.  *)          
  AfCan*        = 29;  (* Controller Area Network.  *)          
  AfTipc*       = 30;  (* TIPC sockets.  *)          
  AfBluetooth*  = 31;  (* Bluetooth sockets.  *)          
  AfIucv*       = 32;  (* IUCV sockets.  *)          
  AfRxrpc*      = 33;  (* RxRPC sockets.  *)          
  AfIsdn*       = 34;  (* mISDN sockets.  *)          
  AfPhonet*     = 35;  (* Phonet sockets.  *)          
  AfIeee802154* = 36;  (* IEEE 802.15.4 sockets.  *)          
  AfCaif*       = 37;  (* CAIF sockets.  *)          
  AfAlg*        = 38;  (* Algorithm sockets.  *)          
  AfNfc*        = 39;  (* NFC sockets.  *)          
  AfVsock*      = 40;  (* vSockets.  *)          
  AfMax*        = 41;  (* For now..  *)          
     
  InAddrAny* = 0;      

TYPE

   (* via /usr/include/netinet/in.h *)
   InAddr* = RECORD
    SAddr*: INTEGER;
   END;

   SockAddrIn* = RECORD
    SinFamily*: SHORTINT;
    SinPort*:   SHORTINT;
    SinAddr*:   InAddr;
    SinZero*:   ARRAY 8 OF CHAR;
   END;

   (* via /usr/include/sys/socket.h *)
   SockAddr* = RECORD
    SaFamily*: SHORTINT;
    SaData*:   ARRAY 14 OF CHAR;
   END;

   PROCEDURE Socket(domain, type, protocol: LONGINT):INTEGER IS "socket";

   PROCEDURE Bind(sockfd: LONGINT; VAR addr: SockAddr; addrlen: LONGINT):INTEGER IS "bind";

END sockets.
