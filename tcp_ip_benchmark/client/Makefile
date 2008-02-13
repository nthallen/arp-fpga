LDLIBS=-lnort
CFLAGS=-Wall

UDPOBJS=udp.o benchmark.o
TCPOBJS=benchmark_tcp.o
all : benchmark benchmark_tcp

benchmark : $(UDPOBJS)
	cc -o benchmark $(UDPOBJS) $(LDLIBS)
benchmark_tcp : $(TCPOBJS)
	cc -o benchmark_tcp $(TCPOBJS) $(LDLIBS)
