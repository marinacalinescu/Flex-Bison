%option noyywrap
%{
	#include "parser.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%
"/*"([^\*]|[\r\n]|"\*"+[^*/])*"*/"        { colNo += strlen(yytext); printf("merge si pe mai multe linii"); } //comentarii pe mai multe linii
"//".*                   { colNo += strlen(yytext); printf("Merg comentariile\n"); } //comentarii pe o linie
"+"				{ colNo++; return TOK_PLUS; }
"-"				{ colNo++; return TOK_MINUS; }
"*"				{ colNo++; return TOK_MULTIPLY; }
"/"				{ colNo++; return TOK_DIVIDE; }
"("				{ colNo++; return TOK_LEFT; }
")"				{ colNo++; return TOK_RIGHT; }
";"				{ colNo++; return ';'; }
"&"				{ colNo++; return '&'; }
"="				{ colNo++; return '='; }
"<"				{ colNo++; return TOK_MARE; }
">"				{ colNo++; return TOK_MIC; }
"<="			{ colNo++; return TOK_MIC_EQ; }
"=>"			{ colNo++; return TOK_MARE_EQ; }
"int"			{ colNo+=3; 
                  yylloc.first_line = lineNo; 
				  yylloc.first_column = colNo; 
				  colNo+=strlen(yytext); 
				  yylval.tip = new char[strlen(yytext)+1]; 
				  strcpy(yylval.tip,yytext);
                  return TOK_INT; }
"float"         { colNo+=3; 
                  yylloc.first_line = lineNo; 
				  yylloc.first_column = colNo; 
				  colNo+=strlen(yytext); 
				  yylval.tip = new char[strlen(yytext)+1]; 
				  strcpy(yylval.tip,yytext);
				  return TOK_FLOAT; }
"double"        { colNo+=3; 
                  yylloc.first_line = lineNo; 
				  yylloc.first_column = colNo; 
				  colNo+=strlen(yytext); 
				  yylval.tip = new char[strlen(yytext)+1]; 
				  strcpy(yylval.tip,yytext);
				  return TOK_DOUBLE; }
"print"				{ colNo+=5; return TOK_PRINT; }
"scanf"				{ colNo+=5; return TOK_SCAN; }
"run"               { colNo+=5; return TOK_RUN; }
"if"				{ colNo+=5; return 	TOK_IF; }
"while"				{ colNo+=5; return TOK_WHILE; }
[a-zA-Z0-9_]+\.(txt|c|cpp|l|y|h) {
									colNo += yyleng; //yyleng - lungimea tokenului curent
									yylval.filename = strdup(yytext);
									return TOK_FILENAME;
								 }
[A-Z]+[a-zA-Z.,/:'' ]*			{	yylloc.first_line = lineNo; 
						yylloc.first_column = colNo; 
						colNo+=strlen(yytext); 
						yylval.message = new char[strlen(yytext)+1]; 
						strcpy(yylval.message,yytext); 
						return MESSAGE; }
[a-zA-Z][a-zA-Z0-9]* { 	yylloc.first_line = lineNo; 
						yylloc.first_column = colNo; 
						colNo+=strlen(yytext); 
						yylval.sir = new char[strlen(yytext)+1]; 
						strcpy(yylval.sir,yytext); 
						return TOK_VARIABLE;
					}
[0-9]+[.]*[0-9]*+f*     { 
                            yylloc.first_line = lineNo; 
                            yylloc.first_column = colNo; 
                            colNo+=strlen(yytext); 
                            yylval.val = atof(yytext);
                         	return NUMBER; 
                        }
[ ]				{ colNo++; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
.				{ 
					colNo++; 
					printf("Caracter necunoscut: %c\n", *yytext); // Afișează caracterul necunoscut
					return TOK_ERROR; 
				}

%%
