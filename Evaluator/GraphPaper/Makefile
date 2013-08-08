CFLAGS = -O
SRCS = y.tab.c lex.yy.c
LFLAGS =  -ly -ll -lm
Evaluator: $(SRCS) 
	cc $(CFLAGS) -o Evaluator $(SRCS) $(LFLAGS)

clean: /bin/rm -f Evaluator $(SRCS) *.h

lex.yy.c: rules.l y.tab.h 
	lex rules.l

y.tab.h: grammar.y 
	yacc -d grammar.y

y.tab.c: grammar.y  
	yacc grammar.y
