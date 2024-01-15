# Makefile pentru proiectul exvar

# Specifică compilatorul
CC = g++

# Numele fișierelor sursă și ale programului rezultat
LEX_SRC = lexer.l
YACC_SRC = parser.y
TARGET = main

# Regula implicită: compilează fișierele sursă
all: $(TARGET)

# Reguli pentru generarea fișierelor intermediare și compilarea
$(TARGET): lex.yy.c parser.tab.c
	$(CC) parser.tab.c lex.yy.c -o $(TARGET)

lex.yy.c: $(LEX_SRC)
	flex $(LEX_SRC)

parser.tab.c: $(YACC_SRC)
	bison -d $(YACC_SRC)

# Curăță fișierele intermediare și programul executabil
clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h $(TARGET)