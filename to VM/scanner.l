/* Compiler Theory and Design
   Duane J. Jarc */
/* Student Infromation
	Name: Alexander Phillips
	Project: Assignment 4
	Date due: Oct 10, 2023
	This file is basically the scanner to check each line of code in
	a file. It will check for any of the items below and output each
	ones code(token) to the lexemes file.
*/
/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
real	 ([0-9]+)(\.[0-9]?+)([eE][-+]?[0-9]+)?
bool	 true|false
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{commentTwo}    { ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO;  return(RELOP); }
"+"		{ ECHO;  return(ADDOP); }
"*"		{ ECHO;  return(MULOP); }
">"	 {ECHO; return(RELOP);}
"-"	 { ECHO; return(ADDOP); }
"/"   	 { ECHO; return(MULOP); }
case	{ECHO; return(CASE);}
else 	{ECHO; return(ELSE);}
endcase {ECHO; return(ENDCASE);}
endif  {ECHO; return(ENDIF);}
if 	{ECHO; return(IF);}
others {ECHO; return(OTHERS);}
{real} 	{ECHO;return(REAL_LITERAL);}
real 	{ECHO; return(REAL);}
then 	{ECHO; return(THEN);}
when 	{ECHO; return(WHEN);}
or	{ECHO; return(OROP);}
not	{ECHO; return(NOTOP);}
rem	{ECHO; return(REMOP);}
begin   { ECHO; return(BEGIN_); }
boolean   { ECHO; return(BOOLEAN); }
end   	 { ECHO; return(END); }
endreduce    { ECHO; return(ENDREDUCE); }
function    { ECHO; return(FUNCTION); }
integer   { ECHO; return(INTEGER); }
is   	 { ECHO; return(IS); }
reduce   { ECHO; return REDUCE; }
returns   { ECHO; return(RETURNS); }
and   	 { ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}  { ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}   { ECHO; return(yytext[0]); }
"="	{ECHO; yylval.oper = EQUAL;return(RELOP);}
"/="	{ECHO;return(RELOP);}
">="	{ECHO; return(RELOP);}
"<="	{ECHO; return(RELOP);}
"=>"	{ECHO; return(ARROW);}
"**"	{ECHO;return(EXPOP);}

%%
