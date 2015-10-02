%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	//extern int yydebug;
	int regle;
	int alphabet;
	char* lettres;
	int* matrice;
%}
%union {int ival; char lettre;}
%token <lettre>var
%token <ival>cst
%token <lettre>imp_
%type <ival>NOMBRE
%type <lettre>SYMBOLE
%start DEFINITION
%%
DEFINITION	:	NOMBRE NOMBRE	ALPHABET	FAITS	LISTE_REGLES
		;

NOMBRE	:	cst
	;

ALPHABET	:	'{'	LISTE_SYMBOLE	'}'	{printf("\n");}
		;

LISTE_SYMBOLE	:	SYMBOLE	LISTE_SYMBOLE	
		|	
		;

SYMBOLE	:	var	{printf(" %c ",$1);}
	;

FAITS	:	'('	LISTE_SYMBOLE	')'	{printf("\n");}
	;

LISTE_REGLES	:	REGLE	LISTE_REGLES
		|
		;

REGLE	:	'*'	LISTE_SYMBOLE IMPLIQUE	LISTE_SYMBOLE	{printf("\n");}
	;

IMPLIQUE	:	imp_	{printf(" implique ");}
		;
%%

void yyerror(char const *s)
{
	fprintf(stderr, "%s\n",s);
}
extern FILE* yyin;
int main(int argc, char* argv[])
{
	//yydebug = 1;
	if(argc < 2)
	{
		exit(0);
	}
	yyin = fopen(argv[1],"r");
	yyparse();
}
