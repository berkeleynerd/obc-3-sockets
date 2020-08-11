MODULE Sockets;

  IMPORT Bit;

  CONST 
    SockStream*    = 1;
    AfInet*        = 2; (* IP protocol *)

  TYPE

    (* OBC-3 DEFAULT TYPES                 *)

    (* SHORTINT : 16-bit unsigned integer  *)
    (* INTEGER  : 32-bit unsigned integer  *)
    (* LONGINT  : 64-bit unsigned integer  *)
    (* VAR      : pass by reference;       *)
    (*            only passes address for  *)
    (*            record types to C        *)

    (* /usr/include/netinet/in.h *)
    (* https://pubs.opengroup.org/onlinepubs/009695399/basedefs/netinet/in.h.html *)

    InAddr* = RECORD
      SAddr*: INTEGER;
    END;

    SockAddrIn* = RECORD
      SinFamily*: SHORTINT;
      SinPort*:   SHORTINT;
      SinAddr*:   InAddr;
      SinZero*:   ARRAY 8 OF CHAR;
    END;

    (* /usr/include/sys/socket.h *)
    (* https://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html *)
    SockAddr* = RECORD
      SaFamily*: SHORTINT;
      SaData*:   ARRAY 14 OF CHAR (* 16? *)
    END;

  PROCEDURE SetCShort(i: SHORTINT; VAR si: SHORTINT);
  BEGIN
    si := i;
  END SetCShort;

  PROCEDURE SetCShortSwapped(i: SHORTINT; VAR si: SHORTINT);
  BEGIN
    si := SHORT(Bit.Or(Bit.And(LSR(i,8), 255), Bit.And(LSL(i,8), 65280)));
  END SetCShortSwapped;

  PROCEDURE SetSockAddrIn*(family, port, inaddr: SHORTINT; VAR sai: SockAddrIn);
  VAR i: SHORTINT;
  BEGIN
    SetCShort(family, sai.SinFamily);
    SetCShortSwapped(port, sai.SinPort);
    sai.SinAddr.SAddr := inaddr;
    i := 0; WHILE i < 8 DO sai.SinZero[i] := 0X; INC(i) END
  END SetSockAddrIn;

  PROCEDURE Socket*(domain, type, protocol: INTEGER):INTEGER IS "socket";

  PROCEDURE Bind*(sockfd: INTEGER; VAR addr: SockAddrIn; addrlen: INTEGER):INTEGER IS "bind";

  PROCEDURE Listen*(sockfd, backlog: INTEGER): INTEGER IS "listen";

  PROCEDURE Accept*(sockfd: INTEGER; VAR addr: SockAddrIn; VAR addrlen: INTEGER): INTEGER IS "accept";

END Sockets.
