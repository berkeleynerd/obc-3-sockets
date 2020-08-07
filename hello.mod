MODULE hello;
IMPORT Out;

  PROCEDURE usleep(t: INTEGER) IS "usleep";

  PROCEDURE HelloWorld*;
  BEGIN
    Out.String("Hello world!");Out.Ln
  END HelloWorld;

  PROCEDURE Goodbye*;
  BEGIN
    Out.String("Goodbye!");Out.Ln
  END Goodbye;

BEGIN

  HelloWorld;

  usleep(4000000);

  Goodbye;

END hello.