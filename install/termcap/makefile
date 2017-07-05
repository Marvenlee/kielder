
.PHONY:= all

all : libcurses.a libtermcap.a

.PHONY:= install
install :
	cp libcurses.a /kielder/i386-kielder/lib
	cp libtermcap.a /kielder/i386-kielder/lib
	cp curses.h /kielder/i386-kielder/include
	cp termcap.h /kielder/i386-kielder/include

.PHONY:= clean
clean :
	rm libcurses.a libtermcap.a curses.o termcap.o

	
libcurses.a : curses.o
	i386-kielder-ar -r libcurses.a curses.o

libtermcap.a : termcap.o
	i386-kielder-ar -r libtermcap.a termcap.o


curses.o : curses.c
	i386-kielder-gcc -c curses.c -o curses.o

termcap.o : termcap.c
	i386-kielder-gcc -c termcap.c -o termcap.o