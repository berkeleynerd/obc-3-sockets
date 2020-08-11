MODULE Platform;

  IMPORT SYSTEM;

  TYPE
    ErrorCode*  = INTEGER;
    FileHandle* = INTEGER;

  PROCEDURE closefile(fd: INTEGER): INTEGER IS "close";

  PROCEDURE Close*(h: FileHandle): ErrorCode;
  BEGIN
    IF closefile(h) < 0 THEN RETURN err() ELSE RETURN 0 END
  END Close;

  PROCEDURE err(): INTEGER;
  BEGIN
    RETURN 57;
  END err;

  PROCEDURE Fork*(): INTEGER IS "fork";

  PROCEDURE readfile(fd: INTEGER; p: INTEGER; l: INTEGER): INTEGER IS "read";

  PROCEDURE ReadBuf*(h: FileHandle; VAR b: ARRAY OF SYSTEM.BYTE; VAR n: INTEGER): ErrorCode;
  BEGIN
    n := readfile(h, SYSTEM.ADR(b), LEN(b));
    IF n < 0 THEN n := 0; RETURN err() ELSE RETURN 0 END
  END ReadBuf;

  PROCEDURE writefile(fd: INTEGER; p: INTEGER; l: INTEGER): INTEGER IS "write";

  PROCEDURE Write*(h: FileHandle; p: INTEGER; l: INTEGER): ErrorCode;
    VAR written: INTEGER;
  BEGIN
    written := writefile(h, p, l);
    IF written < 0 THEN RETURN err() ELSE RETURN 0 END
  END Write;

END Platform.