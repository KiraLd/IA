LEX = flex
YACC = yacc -d
CC = gcc


all: logique

logique: y.tab.o lex.yy.o 
	$(CC) -o logique lex.yy.o y.tab.o -lfl 

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

y.tab.o: y.tab.c y.tab.h 
	$(CC) -c y.tab.c 

lex.yy.c: logique.lex
	$(LEX) logique.lex

y.tab.c y.tab.h: logique.yacc
	$(YACC) -v logique.yacc

clean:
	rm -f *.o lex.yy.c *.tab.*

mrproper: clean
	rm -f logique







