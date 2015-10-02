%{
	#include <stdlib.h>
	#include "y.tab.h"
%}
NOMBRE [0-9]+
ESPACE	[ \t]
LETTRE [A-Z]
%%
ESPACE
^{ESPACE}+	
{ESPACE}+$	
{ESPACE}+
\n	
{LETTRE}	{	yylval.lettre = yytext[0];
			return var;
		}
{NOMBRE}	{
			yylval.ival = atoi(yytext);
			return	cst;
		}
,	{	return ',';}
implique	{
			yylval.lettre = yytext[0];
			return imp_;
		}
equivaut	{return '-';}
et	{return '&';}
ou	{return '^';}
\{	{return '{';}
\}	{return '}';}
\)	{return ')';}
\(	{return '(';}
\*	{return '*';}
.
