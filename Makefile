all:
	obc -C -o EchoServer Platform.mod Sockets.mod EchoServer.mod
clean:
	rm *.k
	rm *.o
	rm EchoServer
