// Compiler Theory and Design
// Duane J. Jarc
/* Student Infromation

	Name: Alexander Phillips
	Project: Assignment 4
	Date due: Oct 10, 2023
	Listing header file
*/

// This file contains the function prototypes for the functions that produce the 
// compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

