/* Compiler Theory and Design
   Duane J. Jarc */
/* Student Infromation
	Name: Alexander Phillips
	Project: Assignment 4
	Date due: Oct 10, 2023
	Parses all the infromation from as a bison.
*/
%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP ARROW NOTOP
%token CASE ELSE ENDCASE ENDIF IF OTHERS THEN WHEN REAL
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%type <type> type statement statement_ reductions expression relation term
	factor primary

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';';

optional_variable:
	variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{checkAssignment($3, $5, "Variable Initialization");
		symbols.insert($1, $3);} ;

type:
	INTEGER {$$ = INT_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF  {if ($2 == true) {$$ = $4;} else{$$ = $6;};}|
	CASE expression IS possible_case OTHERS ARROW statement_ ENDCASE {$$ = $<value>4 == $1 ? $<value>4 : $7;} ;

operator:
	ADDOP |
	REMOP |
	EXPOP |
	MULOP ;

possible_case:
	possible_case case {$<value>$ = isnan($<value>1)  ? $<value>2 : $<value>1;}|            %empty  {$<value>$ = NAN;}| 
	error ';' {$<value>$ = 0;};

case:
	WHEN INT_LITERAL ARROW statement_ {$<value>$ = $<value>2==$2 ? $4 : NAN;};

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression ANDOP relation {$$ = checkLogical($1, $3);} |
	expression2 ;
	
expression2:
	expression OROP relation {$$ = $1 || $3;}|
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP primary  {$$ = checkArithmetic($1, $3);} |
	factor REMOP primary {$$ = (int)$1 % (int)$3;}|
	primary ;
	
exponent:
	factor EXPOP notion | 
	notion;
	
notion:
	NOTOP notion {$<value>$ = !$<value>2;}|
	primary;
	
primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
