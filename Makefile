all:
	obc -C -o EchoServer Platform.mod Sockets.mod EchoServer.mod errno.c -lm
clean:
	rm *.k
	rm *.o
	rm EchoServer
