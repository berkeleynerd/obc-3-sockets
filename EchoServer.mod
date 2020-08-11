MODULE EchoServer;

IMPORT Out, Platform, Sockets, Strings, SYSTEM;

PROCEDURE DoEcho(sock: Platform.FileHandle);
VAR 
  str: ARRAY 256 OF CHAR;
  n:   INTEGER;
BEGIN
  IF Platform.ReadBuf(sock, str, n) # 0 THEN
    Out.String("error on socket.read"); 
    Out.Ln;
  ELSE
    Out.String("echoing message : "); 
    Out.String(str); 
    
    str[n] := 0X; (* Make sure that received message is zero terminated *)

    IF Platform.Write(sock, SYSTEM.ADR(str), Strings.Length(str)) # 0 THEN
      Out.String("error on socket.write"); 
      Out.Ln;
    END;
  END;
END DoEcho;

PROCEDURE serve;
CONST  
  Port     = 2055;
  MaxQueue = 5;
VAR 
  sockfd:      INTEGER;
  newsockfd:   INTEGER;
  ServAddr:    Sockets.SockAddrIn;
  pid:         INTEGER;
  res:         Platform.ErrorCode;
  sockaddrlen: INTEGER;
BEGIN

  sockfd := Sockets.Socket(Sockets.AfInet, Sockets.SockStream, 0);
  IF sockfd < 0 THEN
    Out.String("error on socket.create");
    Out.Ln;
  END;

  Sockets.SetSockAddrIn(Sockets.AfInet, Port, 0, ServAddr);
  IF Sockets.Bind(sockfd, ServAddr, SIZE(Sockets.SockAddr)) < 0 THEN
    Out.String("error on socket.bind");
    Out.Ln;
  END;

  IF Sockets.Listen(sockfd, MaxQueue) # 0 THEN
    Out.String("error on socket.listen");
    Out.Ln;
  END;

  LOOP
    sockaddrlen := SIZE(Sockets.SockAddrIn);
    newsockfd := Sockets.Accept(sockfd, ServAddr, sockaddrlen);

    IF newsockfd < 0 THEN
      Out.String("error on socket.accept");
      Out.Ln;
    END;

    pid := Platform.Fork();

    IF pid < 0 THEN
      Out.String("error on system.fork");
      Out.Ln;
    ELSIF pid = 0 THEN
      res := Platform.Close(sockfd);
      DoEcho(newsockfd);
      EXIT;
    ELSE
      res := Platform.Close(newsockfd);
    END;
  END;

END serve;

BEGIN

serve;

END EchoServer.
