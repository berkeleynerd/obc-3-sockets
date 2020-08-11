MODULE sockets;

IMPORT SYSTEM, Out, Bit;

CONST

   SockStream*    = 1; 
   AfInet*        = 2;   (* IP protocol family.  *)   

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

   ErrorCode*  = INTEGER;
   FileHandle* = INTEGER;

   PROCEDURE Socket*(domain, type, protocol: INTEGER):INTEGER IS "socket";

   PROCEDURE Bind*(sockfd: INTEGER; VAR addr: SockAddrIn; addrlen: INTEGER):INTEGER IS "bind";

   PROCEDURE Listen*(sockfd, backlog: INTEGER): INTEGER IS "listen";

   PROCEDURE Accept*(sockfd: INTEGER; VAR addr: SockAddrIn; VAR addrlen: INTEGER): INTEGER IS "accept";

   PROCEDURE Fork*(): INTEGER IS "fork";

   PROCEDURE closefile(fd: INTEGER): INTEGER IS "close";

   PROCEDURE Close*(h: INTEGER): INTEGER;
   BEGIN
      IF closefile(h) < 0 THEN
         Out.String("FAILED TO CLOSE!");
         RETURN -1;
      ELSE
         RETURN 0;
      END;
   END Close;

   PROCEDURE SetCShort(i: INTEGER; VAR si: SHORTINT);
   BEGIN
      (* "*(short * )si = i"; *)
      si := SHORT(i);
   END SetCShort;

   PROCEDURE SetCShortSwapped(i: INTEGER; VAR si: SHORTINT);
   BEGIN
      (* "*(short * )si = ((i >> 8) & 0x00ff) | ((i << 8) & 0xff00)"; *)
      si := SHORT(Bit.Or(Bit.And(LSR(i,8), 255), Bit.And(LSL(i,8), 65280)));
   END SetCShortSwapped;

   PROCEDURE writefile(fd: INTEGER; p: INTEGER; l: INTEGER): INTEGER IS "write";
   
   PROCEDURE Write*(h: INTEGER; p: INTEGER; l: INTEGER): ErrorCode;
      VAR written: INTEGER;
   BEGIN
      written := writefile(h, p, l);
      IF written < 0 THEN
         Out.String("WRITE FAILED!");
         RETURN -1;
      ELSE
         RETURN 0;
      END;
   END Write;

   PROCEDURE readfile(fd: INTEGER; p: INTEGER; l: INTEGER): INTEGER IS "read";

   PROCEDURE ReadBuf*(h: INTEGER; VAR b: ARRAY OF SYSTEM.BYTE; VAR n: INTEGER): SHORTINT;
   BEGIN
      n := readfile(h, SYSTEM.ADR(b), LEN(b));
      IF n < 0 THEN
         Out.String("READ FAILED!");
         RETURN -1;
      ELSE
         RETURN 0;
      END;
   END ReadBuf;

   PROCEDURE DoSmth(sock: INTEGER);
   VAR 
     str, aff: ARRAY 256 OF CHAR;
     n:   INTEGER;
   BEGIN
     aff := "Affirmative, Dave";
     IF ReadBuf(sock, str, n) # 0 THEN
       Out.String("error reading from socket"); Out.Ln;
       HALT(-1);
     ELSE
       str[n] := 0X; (* Make sure that received message is zero terminated *)
       Out.String("received message is "); Out.String(str); Out.Ln;
       
       IF Write(sock, SYSTEM.ADR(aff), LEN(aff)) # 0 THEN
         Out.String("error writing to socket"); Out.Ln;
         HALT(-1);
       END;
     END;
   END DoSmth;

   PROCEDURE SetSockAddrIn*(family, port, inaddr: INTEGER; VAR sai: SockAddrIn);
   VAR i: INTEGER;
   BEGIN
      SetCShort(family, sai.SinFamily);
      SetCShortSwapped(port, sai.SinPort);
      sai.SinAddr.SAddr := inaddr;
      i := 0; WHILE i < 8 DO sai.SinZero[i] := 0X; INC(i) END
   END SetSockAddrIn;

   PROCEDURE serve;
   CONST  
      Port     = 2055;
      MaxQueue = 5;
   VAR 
      sockfd:        INTEGER;
      newsockfd:     INTEGER;
      ServAddr:      SockAddrIn;
      pid:           INTEGER;
      res:           INTEGER;
      sockaddrlen:   INTEGER;
   BEGIN

      sockfd := Socket(AfInet, SockStream, 0);
      Out.Int(sockfd, 5);
      Out.Ln;
      IF sockfd < 0 THEN
         Out.String("error opening socket");
      ELSE
         Out.String("socket created.")
      END;
      Out.Ln;
   
      Out.String("ServAddr.SinFamily      : "); Out.Int(ServAddr.SinFamily, 8); Out.Ln;
      Out.String("ServAddr.SinPort        : "); Out.Int(ServAddr.SinPort, 8); Out.Ln;
      Out.String("ServAddr.SinZero        : "); Out.String(ServAddr.SinZero); Out.Ln;
      Out.String("ServAddr.SinAddr.SAddr  : "); Out.Int(ServAddr.SinAddr.SAddr, 8); Out.Ln;

      SetSockAddrIn(AfInet, Port, 0, ServAddr);

      Out.String("ServAddr.SinFamily      : "); Out.Int(ServAddr.SinFamily, 8); Out.Ln;
      Out.String("ServAddr.SinPort        : "); Out.Int(ServAddr.SinPort, 8); Out.Ln;
      Out.String("ServAddr.SinZero        : "); Out.String(ServAddr.SinZero); Out.Ln;
      Out.String("ServAddr.SinAddr.SAddr  : "); Out.Int(ServAddr.SinAddr.SAddr, 8); Out.Ln;

      IF Bind(sockfd, ServAddr, SIZE(SockAddrIn)) < 0 THEN
         Out.String("error on binding");
         HALT(-1);
      ELSE
         Out.String("binding completed.")
      END;
      Out.Ln;
       
      IF Listen(sockfd, MaxQueue) # 0 THEN
         Out.String("listen() failed");
      ELSE
         Out.String("listen okay");
      END;
      Out.Ln;
   
      LOOP
         sockaddrlen := SIZE(SockAddrIn);
         newsockfd := Accept(sockfd, ServAddr, sockaddrlen);
         IF newsockfd < 0 THEN
            Out.String("error on accept");
            HALT(-1);
         ELSE
            Out.String("accept okay")
         END;
         Out.Ln;

         pid := Fork();
         IF pid < 0 THEN
            Out.String("error on fork");
         ELSIF pid = 0 THEN
            Out.String("forked okay"); Out.Ln;
            res := Close(sockfd);
            DoSmth(newsockfd);
         ELSE
            res := Close(newsockfd)
         END
      END
   END serve;

BEGIN

   serve;

END sockets.