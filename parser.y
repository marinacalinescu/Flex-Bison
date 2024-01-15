%{ ////ala bun
	using namespace std;
	#include<iostream>
	#include <stdio.h>
	#include <string.h>
    #include <math.h>
	#include "node.h"

	int yylex();
	extern FILE *yyin;
	int yyparse();
	int yyerror(const char *msg);
	enum VarType { INT, FLOAT, DOUBLE }; // Adaugă aici toate tipurile de variabile de care ai nevoie

    int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
         char tip[10];
	     float valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(const char* n, int tipp, float v = -1);
		 TVAR();
	     int exists(char* n);
         void add(const char* n, const char* tipp, float v = -1);
         float getValue(char* n);
	     void setValue(char* n, float v);
		 void printVars();
		 int getTip(char* n);
		 void printMessageVariable(const char* message, const char* n);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(const char* n, int tipp, float v)
	{
		this->nume = new char[strlen(n) + 1];
		strcpy(this->nume, n);
		this->valoare = v;
		if(tipp == 1)
		{
        	strcpy(this->tip, "float");
        	//printf("TVAR   %s\n\n", this->tip);
		}
		if(tipp == 0)
		{
        	strcpy(this->tip, "int");
        	//printf("TVAR   %s\n\n", this->tip);
		}
		if(tipp == 2)
		{
        	strcpy(this->tip, "double");
        	//printf("TVAR   %s\n\n", this->tip);
		}
		this->next = NULL;
	}

	TVAR::TVAR()
	{
		TVAR::head = NULL;
		TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL) 
		{ 
			if(strcmp(tmp->nume,n) == 0)
	      		return 1;
        	tmp = tmp->next;
	  	}
	  	return 0;
	}

	int TVAR::getTip(char* n) {
		TVAR* tmp = TVAR::head;
		while (tmp != NULL) {
			if(strcmp(tmp->nume, n) == 0)
			{
				if (strcmp(tmp->tip, "float") == 0)
					return 1;
				if (strcmp(tmp->tip, "int") == 0)
					return 0;
				if (strcmp(tmp->tip, "double") == 0)
					return 2;
			}
			tmp = tmp->next;
		}
		return -1;
	}

	/*
	char TVAR::getTipChar(char* n)
	{
		TVAR* tmp = TVAR::head;
		while (tmp != NULL) {
			if(strcmp(tmp->nume, n) == 0)
			{
				if (strcmp(tmp->tip, "float") == 0)
					return "f";
				if (strcmp(tmp->tip, "int") == 0)
					return "d";
				if (strcmp(tmp->tip, "double") == 0)
					return "f";
			}
			tmp = tmp->next;
		}
		return -1;
	}*/


    void TVAR::add(const char* n, const char* tipp, float v)
	{
		VarType typeToAdd;

		if (strcmp(tipp, "int") == 0) {
			typeToAdd = INT;
		} else if (strcmp(tipp, "float") == 0) {
			typeToAdd = FLOAT;
		} else if (strcmp(tipp, "double") == 0) {
			typeToAdd = DOUBLE;
		} else {
			printf("Tip de date necunoscut\n");
			return;
		}
        //printf("add    %s\n\n", tipp);
        //printf("add    %d\n\n", typeToAdd);
		TVAR* elem = new TVAR(n, typeToAdd, v);
		if(head == NULL) { 
			TVAR::head = TVAR::tail = elem;
		} else {
			TVAR::tail->next = elem;
			TVAR::tail = elem;
		}
	}

	const char* tipAsString(int tip) {
        //printf("tipAsString     %d\n\n", tip);
		switch (tip) {
			case 0: return "int";
			case 1: return "float";
			case 2: return "double";
			// Adaugă și alte cazuri pentru tipurile de variabile pe care le folosești
			default: return "unknown"; // Tratează cazurile neașteptate sau inexistente
		}
	}

    float TVAR::getValue(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			if(strcmp(tmp->nume,n) == 0)
				return tmp->valoare;
	     	tmp = tmp->next;
	    }
		return -1;
	}

	void TVAR::setValue(char* n, float v)
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
			if(strcmp(tmp->nume,n) == 0)
			{
				tmp->valoare = v;
			}
			tmp = tmp->next;
	    }
	}

	void TVAR::printVars()
	{
		cout<<"\nPrinting table of variables...\n";
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			cout<<tmp->nume<<"="<<tmp->valoare<<"\n";
			tmp = tmp->next;
		}	  
	}

	void printValue(char tip, float val) {
		switch (tip) {
			case 0:
				printf("%.0f\n", val);
				break;
			case 1:
				printf("%f\n", val);
				break;
			case 2:
				printf("%f\n", val);
				break;
			default:
				printf("Tipul variabilei nu este recunoscut\n");
				break;
		}
	}

	// Funcția pentru afișarea unui mesaj și a variabilei asociate
	void TVAR:: printMessageVariable(const char *message, const char *n) {
		TVAR* tmp = TVAR::head;
		while (tmp != NULL) {
			if(strcmp(tmp->nume, n) == 0)
			{
				if (strcmp(tmp->tip, "float") == 0)
					printf("%s %f\n", message, tmp->valoare);
				if (strcmp(tmp->tip, "int") == 0)
					printf("%s %.0f\n", message, tmp->valoare);
				if (strcmp(tmp->tip, "double") == 0)
					printf("%s %f\n", message, tmp->valoare);
			}
			tmp = tmp->next;
		}
	}

	void executeScript(const char *filename) {
		FILE *scriptFile = fopen(filename, "r");
		if (scriptFile == NULL) {
			fprintf(stderr, "Error: Nu am putut deschide fisierul %s\n", filename);
			return;
		}

		yyin = scriptFile; // Seteaza intrarea la fisierul scriptului

		// Itereaza pentru a interpreta comenzile din fisierul scriptului
		while (!feof(yyin)) {
			yyparse(); // Parseaza comanda din fisierul scriptului
		}

		fclose(scriptFile); // Inchide fisierul dupa terminarea executiei
	}

	TVAR* ts = NULL;
%}

%union { char* sir; float val; char* tip; char* message; char* filename; float conditie; }

%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_PRINT TOK_ERROR TOK_SCAN TOK_RUN TOK_IF TOK_MARE TOK_MIC TOK_MARE_EQ TOK_MIC_EQ TOK_WHILE

%token <val> NUMBER
%token <sir> TOK_VARIABLE
%token <tip> TOK_INT TOK_DOUBLE TOK_FLOAT
%token <message> MESSAGE
%token <filename> TOK_FILENAME
%type <val> E

%start S
%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S : 
    | I ';' S
    | TOK_ERROR { EsteCorecta = 0; }
	;
	/*| IF_STATEMENT ';' S
	| WHILE_STATEMENT ';' S
    ;
IF_STATEMENT : TOK_IF TOK_LEFT CONDITION TOK_RIGHT TOK_ACOLADA_STANGA S TOK_ACOLADA_DREAPTA
    {
        struct Node* ifNode = malloc(sizeof(struct Node));
        ifNode->type = "IF_STATEMENT";
        ifNode->data = $6; // Sau altceva, dacă ai nevoie să inițializezi și alte date

        struct Node* elseNode = malloc(sizeof(struct Node));
        elseNode->type = "ELSE_STATEMENT";
        elseNode->data = $8; // Sau altceva, dacă ai nevoie să inițializezi și alte date

        struct Node* conditionNode = malloc(sizeof(struct Node));
        conditionNode->type = "CONDITION";
        conditionNode->data = $3; // Sau altceva, dacă ai nevoie să inițializezi și alte date

        struct Node* ifStatementNode = malloc(sizeof(struct Node));
        ifStatementNode->type = "IF_STATEMENT_NODE";
        ifStatementNode->data = ifNode; // Asociază blocul IF cu nodul general

        $$ = ifStatementNode; // Asignare la rezultatul pentru această regulă
    
    }
    ;

ELSE_STATEMENT: TOK_ELSE TOK_ACOLADA_STANGA S TOK_ACOLADA_DREAPTA
    {
        struct Node* elseNode = malloc(sizeof(struct Node));
        elseNode->type = "ELSE_STATEMENT";
        elseNode->data = $3; // Sau altceva, dacă ai nevoie să inițializezi și alte date

        $$ = elseNode;
    }
    ;

WHILE_STATEMENT : TOK_WHILE TOK_LEFT CONDITION TOK_RIGHT TOK_ACOLADA_STANGA S TOK_ACOLADA_DREAPTA
    {
        struct Node* whileNode = malloc(sizeof(struct Node));
        whileNode->type = "WHILE_STATEMENT_NODE";
        whileNode->data = $6; // Sau altceva, dacă ai nevoie să inițializezi și alte date

        $$ = whileNode;
    }
    ;
CONDITION : 
    E TOK_GREATER E { $$ = ($1 > $3) ? 1 : 0; }
    | E TOK_LESS E { $$ = ($1 < $3) ? 1 : 0; }
    | E TOK_EQUALS E { $$ = ($1 == $3) ? 1 : 0; }
    | E TOK_NOTEQUALS E { $$ = ($1 != $3) ? 1 : 0; }
    | TOK_LEFT CONDITION TOK_RIGHT { $$ = $2; }
    ;
*/
I : TOK_VARIABLE '=' E
    {
		if(ts != NULL)
		{
			if(ts->exists($1) == 1)
			{
				ts->setValue($1, $3);
				//printf("%f\n", $3);
			}
			else 
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    		yyerror(msg);
	    		YYERROR;
	  		}
		}
		else
		{
	  		sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  		yyerror(msg);
	  		YYERROR;
		}
    }
    | TOK_INT TOK_VARIABLE
    {
		if(ts != NULL)
		{
			if(ts->exists($2) == 0)
			{
				ts->add($2, $1, 0);
				//printf("TOK_INT  %d\n\n", ts->getTip($2));
				//printf("%s\n", tipAsString(ts->getTip($2)));
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			ts = new TVAR();
			ts->add($2, $1, 0);
			//printf("TOK_INT  %d\n\n", ts->getTip($2));
			//printf("%s\n", tipAsString(ts->getTip($2)));
		}
    }
    | TOK_FLOAT TOK_VARIABLE
    {
		if(ts != NULL)
		{
			if(ts->exists($2) == 0)
			{
				ts->add($2, $1, 0);
				//printf("TOK_INT  %d\n\n", ts->getTip($2));
				//printf("%s\n", tipAsString(ts->getTip($2)));
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			ts = new TVAR();
			ts->add($2, $1, 0);
			//printf("TOK_INT  %d\n\n", ts->getTip($2));
			//printf("%s\n", tipAsString(ts->getTip($2)));
		}
    }
    | TOK_DOUBLE TOK_VARIABLE
    {
		if(ts != NULL)
		{
			if(ts->exists($2) == 0)
			{
				ts->add($2, $1, 0);
				//printf("TOK_INT  %d\n\n", ts->getTip($2));
				//printf("%s\n", tipAsString(ts->getTip($2)));
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			ts = new TVAR();
			ts->add($2, $1, 0);
			
			//printf("%s\n", tipAsString(ts->getTip($2)));
		}
    }
    | TOK_PRINT TOK_VARIABLE
    {
		if(ts != NULL)
		{
			if(ts->exists($2) == 1)
			{
				if(ts->getValue($2) == -1)
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
				else
				{ 	
					if (ts->getTip($2) == 0) {
						printf("%.0f\n", ts->getValue($2));
					} else {
						printf("%f\n", ts->getValue($2));
					}
					/*
                    if(floor(ts->getValue($2)) == ts->getValue($2))
                    {
                        printf("%.0f\n", ts->getValue($2));
                    }
                    else
                    {
					    printf("%f\n",ts->getValue($2));
                    }
					*/
				}
	  		}
	  		else
	  		{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;
	  		}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
			yyerror(msg);
			YYERROR;
		}
    }
	| TOK_PRINT TOK_LEFT MESSAGE TOK_RIGHT TOK_VARIABLE {
		if(ts != NULL)
		{
			if(ts->exists($5) == 1)
			{
				if(ts->getValue($5) == -1)
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $5);
					yyerror(msg);
					YYERROR;
				}
				else
				{ 	
					ts->printMessageVariable($3, $5);
				}
	  		}
	  		else
	  		{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $5);
				yyerror(msg);
				YYERROR;
	  		}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $5);
			yyerror(msg);
			YYERROR;
		}
	}
	| TOK_PRINT MESSAGE
	{
		printf("%s\n", $2);
	}
	| TOK_SCAN TOK_VARIABLE
	{
		char varName[10]; 
        strcpy(varName, $2); 

        printf("Introdu valoarea pentru variabila %s: ", varName);

        float input;
        scanf("%f", &input);

        ts->setValue(varName, input);
	}
	| TOK_RUN TOK_FILENAME { executeScript($2); }
    ;
E : E TOK_PLUS E { $$ = $1 + $3; }
    | E TOK_MINUS E { $$ = $1 - $3; }
    | E TOK_MULTIPLY E { $$ = $1 * $3; }
    | E TOK_DIVIDE E 
	{
		if($3 == 0)
		{
			sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      	yyerror(msg);
	      	YYERROR;
	    } 
	  	else 
		{ 
			$$ = $1 / $3; 
		} 
	}
	| TOK_LEFT E TOK_PLUS E TOK_RIGHT TOK_MULTIPLY E { $$ = ($2 + $4) * $7; } 
	| TOK_LEFT E TOK_PLUS E TOK_RIGHT TOK_DIVIDE E { $$ = ($2 + $4) / $7; } 
	| E TOK_MULTIPLY TOK_LEFT E TOK_PLUS E TOK_RIGHT { $$ = $1 * ($4 + $6); } 
	| E TOK_DIVIDE TOK_LEFT E TOK_PLUS E TOK_RIGHT { 
		if(($4+$6) == 0)
		{
			sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      	yyerror(msg);
	      	YYERROR;
	    } 
	  	else 
		{ 
			$$ = $1 / ($4 + $6);  
		} 
	} 
	| TOK_LEFT E TOK_PLUS E TOK_RIGHT TOK_MULTIPLY TOK_LEFT E TOK_PLUS E TOK_RIGHT  { $$ = ($2 + $4) * ($8 + $10); }
	| TOK_LEFT E TOK_PLUS E TOK_RIGHT TOK_DIVIDE TOK_LEFT E TOK_PLUS E TOK_RIGHT  { 
		if(($8+$10) == 0)
		{
			sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      	yyerror(msg);
	      	YYERROR;
	    } 
	  	else 
		{ 
			$$ = ($2 + $4) / ($8 + $10);   
		} 
	}
    | TOK_LEFT E TOK_RIGHT { $$ = $2; }/*
	| TOK_IF TOK_LEFT E TOK_MARE E TOK_RIGHT { 
		if($3 > $5) 
		$$ = $5 + 1;
	}
	| TOK_IF TOK_LEFT E TOK_MIC E TOK_RIGHT { 
		if($3 < $5) 
		$$ = $3 + 1;
	}
	| TOK_IF TOK_LEFT E TOK_MARE_EQ E TOK_RIGHT { 
		if($3 >= $5) 
		$$ = $5 + 1;
	}*/
	| TOK_IF TOK_LEFT E TOK_MIC_EQ E TOK_RIGHT  { 
		if($3 <= $5) 
		{
			$$ = $3 + 1;
		}
	}
    | NUMBER { $$ = $1; }
    | TOK_VARIABLE { $$ = ts->getValue($1); }
	| TOK_LEFT TOK_INT TOK_RIGHT E { $$ = (int)$4; }
	| TOK_LEFT TOK_FLOAT TOK_RIGHT E { $$ = (float)$4; }
	| TOK_LEFT TOK_DOUBLE TOK_RIGHT E { $$ = (double)$4; }
  ;
          
%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		cout<<"CORECT\n";	
	}	

	ts->printVars();
	return 0;
}

int yyerror(const char *msg)
{
	cout<<"EROARE: "<<msg<<endl;	
	return 1;
}
