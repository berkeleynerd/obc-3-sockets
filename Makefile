all:
	obc -c platform.mod types.mod sockets.mod s.mod 
	obc -C -o s platform.k types.k sockets.k s.k
clean:
	rm *.k
	rm s
