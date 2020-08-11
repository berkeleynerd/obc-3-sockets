MODULE sockets;

IMPORT Bit;

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

  (* OBERON-2 PLATFORM TYPE ASSUMPTIONS       *)

  (* SHORTINT      : 16-bit unsigned integer  *)
  (* INTEGER       : 32-bit unsigned integer  *)
  (* LONGINT       : 64-bit unsigned integer  *)
  (* VAR           : pass by reference;       *)
  (*                 only passes address for  *)
  (*                 record types to C        *)

  (* VOC COMPILER DEFAULTS                    *)

  (* oocC.shortint : 16-bit unsigned integer  *)
  (* oocC.int      : 32-bit unsigned integer  *)
  (* SHORTINT      : 8-bit unsigned integer   *)
  (* INTEGER       : 16-bit unsigned integer  *)
  (* LONGINT       : 32-bit unsigned integer  *)

  (* /usr/include/netinet/in.h *)
  (* https://pubs.opengroup.org/onlinepubs/009695399/basedefs/netinet/in.h.html *)

  InAddr* = RECORD
    SAddr*: INTEGER; (* oocC.int; *)
  END;

  SockAddrIn* = RECORD
    SinFamily*: SHORTINT; (* oocC.shortint; *)
    SinPort*:   SHORTINT; (* oocC.shortint; *)
    SinAddr*:   InAddr;
    SinZero*:   ARRAY 8 OF CHAR;
  END;

   (* /usr/include/sys/socket.h *)
   (* https://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html *)
   SockAddr* = RECORD
    SaFamily*: SHORTINT; (* oocC.shortint; *)
    SaData*:   ARRAY 14 OF CHAR (* 16? *)
   END;

   (* PROCEDURE -includesocket "#include <sys/socket.h>"; *)

   (* PROCEDURE -SetCShort(i: INTEGER; VAR si: oocC.shortint) *)
   (*  "*(short * )si = i"; *)

   (* ~~~ DOES NOT DO ANYTHING? *)
   PROCEDURE SetCShort(i: SHORTINT; VAR si: SHORTINT);
   BEGIN
      si := i;
   END SetCShort;

   (* PROCEDURE -SetCShortSwapped(i: INTEGER; VAR si: oocC.shortint) *)
   (*  "*(short * )si = ((i >> 8) & 0x00ff) | ((i << 8) & 0xff00)";  *)

   PROCEDURE SetCShortSwapped(i: SHORTINT; VAR si: SHORTINT);
   BEGIN
      si := SHORT(Bit.Or(Bit.And(LSR(i,8), 255), Bit.And(LSL(i,8), 65280)));
   END SetCShortSwapped;

   (* PROCEDURE SetSockAddrIn*(family, port, inaddr: INTEGER; VAR sai: SockAddrIn);
   VAR i: INTEGER;
   BEGIN
     SetCShort(family, sai.SinFamily);
     SetCShortSwapped(port, sai.SinPort);
     sai.SinAddr.SAddr := inaddr;
     i := 0; WHILE i < 8 DO sai.SinZero[i] := 0X; INC(i) END
   END SetSockAddrIn; *)

   (*

   The sockaddr structure is used to define a socket address which is used in the bind(),
   connect(), getpeername(), getsockname(), recvfrom(), and sendto() functions.
   
   The <sys/socket.h> header shall define the sockaddr_storage structure. 
   
   This structure shall be: 
   
   Large enough to accommodate all supported protocol-specific address structures
   
   Aligned at an appropriate boundary so that pointers to it can be cast as pointers to 
   protocol-specific address structures and used to access the fields of those structures 
   without alignment problems

   *)

   PROCEDURE SetSockAddrIn*(family, port, inaddr: SHORTINT; VAR sai: SockAddrIn);
   VAR i: SHORTINT;
   BEGIN
     SetCShort(family, sai.SinFamily);
     SetCShortSwapped(port, sai.SinPort);
     sai.SinAddr.SAddr := inaddr;
     i := 0; WHILE i < 8 DO sai.SinZero[i] := 0X; INC(i) END
   END SetSockAddrIn;

   (* PROCEDURE -socket(domain, type, protocol: LONGINT): INTEGER
      "(INTEGER)socket((int)domain, (int)type, (int)protocol)";

   PROCEDURE Socket*(domain, type, protocol: LONGINT): INTEGER;
   BEGIN RETURN socket(domain, type, protocol)
   END Socket; *)

   PROCEDURE Socket*(domain, type, protocol: INTEGER):INTEGER IS "socket";

   (* PROCEDURE -bind(sockfd: LONGINT; VAR addr: SockAddr; addrlen: LONGINT): INTEGER
      "(INTEGER)bind((int)sockfd, (const struct sockaddr * )addr, (int)addrlen)";

   PROCEDURE Bind*(sockfd: LONGINT; VAR addr: SockAddr; addrlen: LONGINT): INTEGER;
   BEGIN RETURN bind(sockfd, addr, addrlen)
   END Bind; *)

   PROCEDURE Bind*(sockfd: INTEGER; VAR addr: SockAddrIn; addrlen: INTEGER):INTEGER IS "bind";

   (* PROCEDURE -listen(sockfd, backlog: LONGINT): INTEGER
      "(INTEGER)listen((int)sockfd, (int)backlog)";

   PROCEDURE Listen*(sockfd, backlog: LONGINT): INTEGER;
   BEGIN RETURN listen(sockfd, backlog)
   END Listen; *)

   PROCEDURE Listen*(sockfd, backlog: INTEGER): INTEGER IS "listen";

   (* PROCEDURE -accept(sockfd: LONGINT; VAR addr: SockAddr; VAR addrlen: LONGINT; VAR result: INTEGER)
      "int _o_al = (int)addrlen; *result = (INTEGER)accept((int)sockfd, (struct sockaddr * )addr, &_o_al); *addrlen = _o_al";

   PROCEDURE Accept*(sockfd: LONGINT; VAR addr: SockAddr; VAR addrlen: LONGINT): INTEGER;
   VAR result: INTEGER;
   BEGIN accept(sockfd, addr, addrlen, result); RETURN result
   END Accept; *)

   PROCEDURE Accept*(sockfd: INTEGER; VAR addr: SockAddrIn; VAR addrlen: INTEGER): INTEGER IS "accept";

END sockets.
