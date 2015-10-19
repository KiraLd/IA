%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	//extern int yydebug;
	extern FILE* yyin;
	int regle;
	int alphabet;
	char* lettres;
	int** matrice;
	int* faits;
	int compteur = 0;
	int compteur_regle = -1;
	int indice(char c);
	void nettoyage();
	void afficher();
	
%}
%union {int ival; char lettre;}
%token <lettre>var
%token <ival>cst
%token <lettre>imp_
%type <ival>NOMBRE
%type <ival>NB_SYMBOLE
%type <ival>NB_REGLE
%type <lettre>SYMBOLE
%start DEFINITION
%%
DEFINITION	:	NB_SYMBOLE NB_REGLE	ALPHABET	FAITS	LISTE_REGLES	{afficher();nettoyage();printf("\ntraitement\n");}
		;



NOMBRE	:	cst
	;

NB_SYMBOLE	:	NOMBRE	{
					lettres =(char*)malloc(sizeof(char)*$1); alphabet = $1;
					faits =(int*)malloc(sizeof(int)*$1);
				}
		;

NB_REGLE	:	NOMBRE	{
					matrice = (int**)malloc(sizeof(int*)*$1); 
					regle = $1;
					int i,j;
					for(i = 0; i < regle; i++)
					{
						matrice[i] = (int*)malloc(sizeof(int)*alphabet);
						for(j = 0; j < alphabet; j++)
						{
							matrice[i][j] = 0;
						}
					}
				}
		;

ALPHABET	:	'{'	LISTE_SYMBOLE	'}'	{printf("\n");}
		;

LISTE_SYMBOLE	:	SYMBOLE	LISTE_SYMBOLE	
		|	
		;

SYMBOLE	:	var	{
				printf(" %c ",$1);
				if(compteur<alphabet && compteur >= 0)
				{
					lettres[compteur] = $1;
					compteur++;
				}
				else if(compteur == -1)
				{
					int k = indice($1);
					faits[k] = 1;
				}
				else if(compteur == -2)
				{
					matrice[compteur_regle][indice($1)] = 1;
				}
				else if(compteur == -3)
				{
					matrice[compteur_regle][indice($1)] = 2;
				}
			}
	;

FAITS	:	OUVRANT	LISTE_SYMBOLE	FERMANT	{printf("\n");}
	;

OUVRANT	:	'('	{compteur = -1;}
	;

FERMANT	:	')'	{compteur = -2;}
	;

LISTE_REGLES	:	REGLE	LISTE_REGLES
		|
		;

REGLE	:	'*'	OUVRANT_REGLE	LISTE_SYMBOLE	FERMANT_REGLE	IMPLIQUE	SYMBOLE	{printf("\n");}
	;

OUVRANT_REGLE	:	'{'	{compteur_regle++;compteur = -2;}
		;

FERMANT_REGLE	:	'}'	{compteur = -3;}


IMPLIQUE	:	imp_	{printf(" implique ");}
		;
%%

void yyerror(char const *s)
{
	fprintf(stderr, "%s\n",s);
}

int indice(char c)
{
	int k = 0;
	while(c!=lettres[k]&&k<alphabet)
	{
		k++;
	}
	if(k<alphabet)
	{
		return k;
	}
	else
	{
		return 0;
	}
}

void afficher()
{
	int i,j;
	for(i = 0; i < regle; i++)
	{
		for(j = 0; j < alphabet; j++)
		{
			printf(" %d",matrice[i][j]);
		}
		printf("\n");
	}
}

void nettoyage()
{
	free(lettres);
	free(faits);
	int i;
	for(i = regle-1; i>=0; i--)
	{
		free(matrice[i]);
	}
	free(matrice);
	fclose(yyin);
}
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
