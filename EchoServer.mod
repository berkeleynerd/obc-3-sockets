MODULE EchoServer;

IMPORT SYSTEM, Sockets, Platform, Out, Strings;

PROCEDURE DoSmth(sock: Platform.FileHandle);
VAR 
  str, aff: ARRAY 256 OF CHAR;
  n:   INTEGER;
BEGIN
  aff := "Affirmative, Dave";
  IF Platform.ReadBuf(sock, str, n) # 0 THEN
    Out.String("error reading from socket"); Out.Ln;
  ELSE
    str[n] := 0X; (* Make sure that received message is zero terminated *)
    Out.String("received message is "); Out.String(str); Out.Ln;
    
    IF Platform.Write(sock, SYSTEM.ADR(aff), Strings.Length(aff)) # 0 THEN
      Out.String("error writing to socket"); Out.Ln
    END;
  END;
END DoSmth;

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
    Out.String("error opening socket")
  ELSE
    Out.String("socket created.")
  END;
  Out.Ln;

  Sockets.SetSockAddrIn(Sockets.AfInet, Port, 0, ServAddr);
  IF Sockets.Bind(sockfd, ServAddr, SIZE(Sockets.SockAddr)) < 0 THEN
    Out.String("error on binding")
  ELSE
    Out.String("binding completed.")
  END;
  Out.Ln;

  IF Sockets.Listen(sockfd, MaxQueue) # 0 THEN
    Out.String("listen() failed");
  ELSE
    Out.String("listen okay");
  END;
  Out.Ln;

  LOOP
    sockaddrlen := SIZE(Sockets.SockAddrIn);
    newsockfd := Sockets.Accept(sockfd, ServAddr, sockaddrlen);

    IF newsockfd < 0 THEN
      Out.String("error on accept")
    ELSE
      Out.String("accept okay")
    END;
    Out.Ln;

    pid := Platform.Fork();

    IF pid < 0 THEN
      Out.String("error on fork")
    ELSIF pid = 0 THEN
      Out.String("forked okay"); Out.Ln;
      res := Platform.Close(sockfd);
      DoSmth(newsockfd);
      EXIT
    ELSE
      Out.Ln;
      res := Platform.Close(newsockfd)
    END
  END

END serve;

BEGIN

serve;

END EchoServer.
