// Compiler Theory and Design
// Dr. Duane J. Jarc
/* Student Infromation

	Name: Alexander Phillips
	Project: Assignment 4
	Date due: Oct 10, 2023
	Listing main file
*/
// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrorsTotal = 0;
static int syntaxErrorsTotal = 0;
static int semanticErrorsTotal = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
    printf("\r");
    displayErrors();
    
    if(totalErrors == 0)
    {
      printf("Compiled Successfully! \n");
      }
    else 
    {
      printf("Lexical Errors: %i \n", lexicalErrorsTotal);
      printf("Syntax Errors: %i \n", syntaxErrorsTotal);
      printf("Semantic Errors: %i \n", semanticErrorsTotal);
    }
    return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
    string messages[] = { "Lexical Error, Invalid Character ", "",
   	 "Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
   	 "Semantic Error, Undeclared " };
    if ( error != "")
      error += "\n";
    if(errorCategory == LEXICAL)
      lexicalErrorsTotal++;
    if(errorCategory == SYNTAX)
      syntaxErrorsTotal++;
    if(errorCategory == GENERAL_SEMANTIC)
      semanticErrorsTotal++;
    //printf("%i %s\n", lexicalErrorsTotal, message.c_str());
    error += messages[errorCategory] + message ;
    
    totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}
