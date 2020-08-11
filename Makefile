all:
	obc -c Platform.mod Sockets.mod EchoServer.mod 
	obc -C -o EchoServer Platform.k Sockets.k EchoServer.k
clean:
	rm *.k
	rm EchoServer
