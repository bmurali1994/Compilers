%{ 

#include <stdio.h>
#include "y.tab.h"
int c;
int lineno=0;
extern int yylval;
char fty[100];

#include <stdlib.h>
#include<bits/stdc++.h>

using namespace std;
#define YY_DECL extern "C" int yylex()
%}

BL 	(true|false)
STR 	"([a-zA-Z])*"
ID      [a-zA-Z]([a-zA-Z]|[0-9]|_)*
INT     [+-]?[0-9]+
DECIMAL [0-9]+(\.[0-9]+)
SPACES  [^ \t\n]
HDR 	<.+>
HDR1	<>
%%

\'.\'                   { c = yytext[0]; return(CHAR_CONST); }

\".*\"     		{ c = yytext[0]; return(STRING_CONST); }

","                     { c = yytext[0]; return(c); }
"="                     { c = yytext[0]; return(c); }
"=="                    { c = yytext[0]; return(EE); }
"!="                    { c = yytext[0]; return(NE); }
">="                    { c = yytext[0]; return(GE); }
"<="			{ c = yytext[0]; return(LE); }
">"			{ c = yytext[0]; return(c); }
"<"			{ c = yytext[0]; return(c); }
"++"			{ c = yytext[0]; return(INR); }
"--"			{ c = yytext[0]; return(DCR); }
"+="			{ c = yytext[0]; return(INE); }
"-="			{ c = yytext[0]; return(DCE); }
"F="			{ c = yytext[0]; return(FE); }
"+"			{ c = yytext[0]; return(c); }
"-"			{ c = yytext[0]; return(c); }
"/"			{ c = yytext[0]; return(c); }

">>"			{ c = yytext[0]; return(IN); }
"<<" 			{ c = yytext[0]; return(OUT); }
"("			{ c = yytext[0]; return(c); }
")"			{ c = yytext[0]; return(c); }
"["			{ c = yytext[0]; return(c); }
"]"			{ c = yytext[0]; return(c); }
"{"			{ c = yytext[0]; return(c); }
"}"			{ c = yytext[0]; return(c); }
"%"			{ c = yytext[0]; return(c); }
"&"			{ c = yytext[0]; return(c); }
";"			{ c = yytext[0]; return(c); }


"break"			{ c = yytext[0]; return(BREAK); }
"continue"		{ c = yytext[0]; return(CONTINUE); }
"double"		{ c = yytext[0]; return(DOUBLE); }

"else"			{ c = yytext[0]; return(ELSE); }

"if"			{ c = yytext[0]; return(IF); }
"int"			{ strcpy(fty,yytext); c = yytext[0]; return(INT); }

"char"			{ c = yytext[0]; return(CHAR); }

"string"		{ c = yytext[0]; return(STRING); }
"return"		{ c = yytext[0]; return(RETURN); }

"while"			{ c = yytext[0]; return(WHILE); }
"bool"			{ c = yytext[0]; return(BOOL); }
"main"			{ c = yytext[0]; return(MAIN); }

"print"			{ c = yytext[0]; return(PRINT); }
"scan"			{ c = yytext[0]; return(SCAN); }
"global"		{ c = yytext[0]; return(GLOBAL); }
"endl"			{ c = yytext[0]; return(ENDL); }
"then"			{ c = yytext[0]; return(THEN); }

"OR"            	{ c = yytext[0]; return(OR); }
"AND"            	{ c = yytext[0]; return(AND); }
"NOT"            	{ c = yytext[0]; return(NOT); }

{BL}            	{ return(BOOL_CONST); }
{INT}                   { return(INT_CONST); }
{ID}                    { 
                         return(VAR_NAME); }
{DECIMAL}               { return(DOUBLE_CONST); }

\n	 		{ ++lineno; }

%%

int yywrap (void) {return 1;}
