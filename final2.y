%{

#include <bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <fstream>
#include <vector>
#include <string>
#include <map>
#include <sstream>
#include <stack>
#include <algorithm>

using namespace std;
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" int yylineno ;
extern int yyleng;
extern char* yytext;
void yyerror(const char *  error_message );
FILE* temporary;
typedef struct node node; 
struct node
 	{
 		char state[20];                   // 
 		node* pro[17];
		int count;
		char id[50];
 		//string ID;                      // Identifier
 		string DT;  
		//char DT[10];
		string name;                    // DataType		//scope checking, type, return
		string tempname;
 	};

node* root;

typedef struct u_type u_type;

struct u_type
{
	node* Node;
	char* c;
};

#define YYSTYPE u_type


vector <map<string,string>> STable;

int scope = 0;
string currentfunc="global";
string currentret;

int findIdScope(string id)
{
	for(int i=scope;i>=0;i--)
	{
		if(STable[i].find(id) != STable[i].end())	
			return scope;
	}
	return -1;
}

extern int lineno;
extern char fty[100];
//node* nlist[100]; ncount=0;

void push(node* temp, node* n)
{

	temp->pro[temp->count]=n;
	temp->count++;

} 

void ds(node* temp)
{	if(temp==NULL)
	{
	}
	else 
	{
		int cot=0;
		int a=(temp->count);
		while(cot<a)
		{
			printf(" %s ", (temp->pro[cot])->state);
			ds((temp->pro[cot]));
			cot++;
		}
		printf("\n");
	}

}

string current;
string currentl;

void getnewreg()
{
	static int count=0;
	stringstream ss;
	ss<<++count;
	current=string("t"+ss.str());
}

string getnewlabel()
{
	static int label=0;
	stringstream ss;
	ss<<++label;
	currentl= string("label"+ss.str()+":");
}

//ofstream fout; fout.open("variables.txt");
	

%}

%error-verbose
%start Program

%token IF ELSE WHILE PRINT SCAN ENDL STRING_CONST INT_CONST DOUBLE_CONST CHAR_CONST BOOL_CONST VAR_NAME OR NOT AND INT VOID BOOL CHAR DOUBLE STRING RETURN BREAK CONTINUE MAIN GLOBAL IN OUT FE INR DCR INE DCE LE GE NE EE THEN



%left '|' '(' ')' '[' ']' IN OUT "<" ">" LE GE NE EE ','
%left '&'
%left '+' '-'
%left '*' '/' '%'
%right '$' '=' INE DCE INR DCR FE 
%left UMINUS  /*supplies precedence for unary minus */

%%                   /* beginning of rules section */

/* Global statements: */

Program: Program1				{
							root = $1.Node; 
							sprintf(root->state,"PROGRAM"); 
						}
	;

Program1:  G X                                { 
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "PROGRAM1");
							push(temp,$1.Node);
							push(temp,$2.Node);
							//push(temp,$3.Node);
							$$.Node = temp; 
						}
	//| error ';'				{ yyerrok; }
	;

G: 		/* empty */			{   	
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "G");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "epsilon");
							push(temp,temp1);
							$$.Node = temp; //cout<<" dude "<<endl;
						}
							
	|  D1 ';' G 				{
							node* temp = new node; temp->count=0;
							node* temp1 = new node; temp1->count=0;
							sprintf( temp->state, "G");
							sprintf( temp1->state, ";");
							push(temp,$1.Node);
							push(temp,temp1);
							push(temp,$3.Node);
							$$.Node = temp;
							
						}
	;
 


X:	Y X 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "X");
							push(temp,$1.Node);
							push(temp,$2.Node);
							$$.Node = temp;
						}
	| INT MAIN				{ currentret="int"; currentfunc="main"; } 

		'(' argsm ')' '{' 		{ map<string,string>map1; STable.push_back(map1); scope++; }


		Block '}'			{ scope--; STable.pop_back();
							cout << "IN MAIN" << endl;
							node* temp = new node; temp->count=0;
							node* temp1 = new node; temp1->count=0;
							node* temp2 = new node; temp2->count=0;
							node* temp3 = new node; temp3->count=0;
							node* temp4 = new node; temp4->count=0;
							node* temp5 = new node; temp5->count=0;
							node* temp6 = new node; temp6->count=0;
							sprintf( temp->state, "X");
							sprintf( temp1->state, "INT");
							sprintf( temp2->state, "MAIN");
							sprintf( temp3->state, "(");
							sprintf( temp4->state, ")");
							sprintf( temp5->state, "{");
							sprintf( temp6->state, "}");
							push(temp,temp1);
							push(temp,temp2);
							push(temp,temp3);
							push(temp,$5.Node);
							push(temp,temp4);
							push(temp,temp5);
							push(temp,$9.Node);
							push(temp,temp6);
							$$.Node = temp;
						}
	| error ';'				{ yyerrok; }
	//| INT INT				{ printf("heyyyyyyyyy "); dfs(root); }		
	;
		
Y: 	T1 XXX '(' 				{ currentfunc=$2.Node->tempname; 
						  $2.Node->DT=$1.Node->DT;
						  currentret=$1.Node->DT;
						  //cout<<" till here fine "<<currentfunc<<" "<<currentret<<endl;
						  map<string,string>map1; STable.push_back(map1); scope++;
						}

	param ')' '{'				

	Block '}'				{	scope--; STable.pop_back();
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "Y");
							push(temp,$1.Node);
							push(temp,$2.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "(");
							push(temp,temp1);
							push(temp,$5.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ")");
							push(temp,temp2);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, "{");
							push(temp,temp3);
							push(temp,$8.Node);
							node* temp4 = new node; temp4->count=0;
							sprintf( temp4->state, "}");
							push(temp,temp4);
							$$.Node = temp;
						}
	;

T1:	type 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "T1");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT=$1.Node->DT;
							//cout<<$1.Node->DT<<" hrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr "<<endl;
							
						
						}
	| error					{yyerrok; }
	;

Block:  stmt					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "BLOCK");
							push(temp,$1.Node);
							$$.Node = temp;
							//string a=string(yytext,yyleng);
							//cout<<" b->stmt "<<a<<endl;
						}
	;


argsm: 						{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGSM");
							$$.Node = temp;
						}
	| error	')'				{ yyerrok; }
	;

/*Blockm: stmt					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "BLOCKM");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	;	*/


/* Conditional statements: */
C: 	IF '(' expr ')' '{'			{ map<string,string> map1; STable.push_back(map1);scope++; } 

	stmt '}' 				{	scope--; STable.pop_back();
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "IF");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "(");
							push(temp,temp2);
							push(temp,$3.Node);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ")");
							push(temp,temp3);
							node* temp4 = new node; temp4->count=0;
							sprintf( temp4->state, "{");
							push(temp,temp4);
							push(temp,$7.Node);
							node* temp5 = new node; temp5->count=0;
							sprintf( temp5->state, "}");
							push(temp,temp5);
							$$.Node = temp;
						}
	| IF '(' expr ')' THEN '{' 		{ map<string,string> map1; STable.push_back(map1); scope++;
						}
		
	stmt '}' 				{ scope--; STable.pop_back(); }

	ELSE '{' 				{ map<string,string> map1; STable.push_back(map1); scope++; }
	
	stmt '}' 				{		scope--; STable.pop_back();
									node* temp = new node; temp->count=0;
									sprintf( temp->state, "C");
									node* temp1 = new node; temp1->count=0;
									sprintf( temp1->state, "IF");
									push(temp,temp1);
									node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "(");
							push(temp,temp2);
									push(temp,$3.Node);
									node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ")");
							push(temp,temp3);
							node* temp34 = new node; temp34->count=0;
							sprintf( temp34->state, "THEN");
							push(temp,temp34);
									node* temp4 = new node; temp4->count=0;
							sprintf( temp4->state, "{");
							push(temp,temp4);
									push(temp,$8.Node);
									node* temp5 = new node; temp5->count=0;
							sprintf( temp5->state, "}");
							push(temp,temp5);
									node* temp6 = new node; temp6->count=0;
							sprintf( temp6->state, "ELSE");
							push(temp,temp6);
									node* temp7 = new node; temp7->count=0;
							sprintf( temp7->state, "{");
							push(temp,temp7);
									push(temp,$14.Node);
									node* temp8 = new node; temp8->count=0;
							sprintf( temp8->state, "}");
							push(temp,temp8);
									$$.Node = temp;
								}
	| error '}'					{ yyerrok; }
	;

	


/* Loops: */

W: 	WHILE '(' expr ')' '{' 				{ map<string,string> map1; STable.push_back(map1); scope++; }

	stmt '}' 	{				scope--; STable.pop_back();
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "W");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "WHILE");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "(");
							push(temp,temp2);
							push(temp,$3.Node);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ")");
							push(temp,temp3);
							node* temp4 = new node; temp4->count=0;
							sprintf( temp4->state, "{");
							push(temp,temp4);
							push(temp,$7.Node);
							node* temp5 = new node; temp5->count=0;
							sprintf( temp5->state, "}");
							push(temp,temp5);
							$$.Node = temp;
						}
	;


/* Input/Output: */

O:	PRINT E2 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "O");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "PRINT");
							push(temp,temp1);
							push(temp,$2.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ";");
							push(temp,temp2);
							$$.Node = temp;
						}
	
	;

E2:	OUT cexpr 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "E2");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "OUT");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "ENDL");
							push(temp,$2.Node);
							$$.Node = temp;
						}
	| OUT cexpr E2			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "E2");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "OUT");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "STRING_CONST");
							push(temp,$2.Node); push(temp,$3.Node);
							$$.Node = temp;
						}
	| error ';'				{ yyerrok; }
	;

I:	SCAN IN S2 ';'				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "I");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "SCAN");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "IN");
							push(temp,temp2);
							push(temp,$3.Node);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ";");
							push(temp,temp3);
							$$.Node = temp;
						}
	;

S2:	XXX 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "S2");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->name = $1.Node->name;
							
						}
	| error					{ yyerrok; }
	;


 /* Declaration: */

D1:  	GLOBAL type Dmult			{ 
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "D1");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "GLOBAL");
							push(temp,temp1);
							push(temp,$2.Node);
							push(temp,$3.Node);
							$$.Node = temp;
							$$.Node->DT=$3.Node->DT;
							//cout<<($3.Node)->name<<" "<<scope<<" "<<currentfunc<<" "<<$2.Node->DT<<endl;
							if(STable[scope].find(($3.Node)->name)==STable[scope].end())
							{
								//cout<<" inserting "<<endl;
								STable[scope][$3.Node->name] = $2.Node->DT;
								//fout<<$3.Node->name<<endl;
								string s=$3.Node->name;
								fprintf(temporary,"%s.%s.%d\n",s.c_str(),currentfunc.c_str(),scope);
							}
							else
							{
								cout << "Semantic error: Multiple declaration" << endl;
							}
							
						}
	;

D:  	type Dmult 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "D");
							push(temp,$1.Node);
							push(temp,$2.Node);
							$$.Node = temp;
							$$.Node->DT=$1.Node->DT;
							if(STable[scope].find(($2.Node)->name)==STable[scope].end())
							{
								STable[scope][$2.Node->name] = $1.Node->DT;
								//fout<<$2.Node->name<<endl;
								string s=$2.Node->name;
								fprintf(temporary,"%s.%s.%d\n",s.c_str(),currentfunc.c_str(),scope);
							}
							else
							{
								cout << "Semantic error: Multiple declaration" << endl;
							}	
						}
	;

Dmult:   XXX 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "Dmult");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->name = $1.Node->name;
							
							
						}
	| assign 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "Dmult");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->name = $1.Node->name;
						}
	; 


assign:  XXX '=' const			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ASSIGN");
							push(temp,$1.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "=");
							push(temp,temp2);
							push(temp,$3.Node);$$.Node = temp;
							int tt = scope,flag=0;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find($1.Node->name)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name] == $3.Node->DT)
								{
									$$.Node->name = $1.Node->name;
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}              
							
						}
	| XXX '=' XXX				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ASSIGN");
							push(temp,$1.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "=");
							push(temp,temp2);
							push(temp,$3.Node); $$.Node = temp;
							int tt = scope,flag1=0,flag2=0;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find($1.Node->name)==STable[i].end())
								{}
								else
								{ flag1=1;break;}
							
							}
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find($3.Node->name)==STable[i].end())
								{}
								else
								{ flag2=1;break;}
							
							}
							
							
							if(flag1==0 || flag2 ==0)
								cout << "Error: Variable not declared"<<endl;
							else
							{
								if(STable[scope][$1.Node->name] == STable[scope][$3.Node->name])
								{
									$$.Node->name = $1.Node->name;
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							} 
							
							
						}
	;



type:   INT					{
							
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "TYPE");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "INT");
							push(temp,temp1);
							$$.Node = temp;							
							temp->DT = string(fty);
							cout<<"gsghdhsdhsh     "<<temp->DT<<" hhhhhhhhhhh "<<$1.c<<endl;

						}	
	| DOUBLE				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "TYPE");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DOUBLE");
							push(temp,temp1);
							$$.Node = temp;							
							temp->DT = strdup(yytext);
						}
	| BOOL					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "TYPE");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "BOOL");
							push(temp,temp1);
							$$.Node = temp;							
							temp->DT = strdup(yytext);
						}
	| CHAR 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "TYPE");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "CHAR");
							push(temp,temp1);
							$$.Node = temp;							
							temp->DT = strdup(yytext);
						}
	| STRING				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "TYPE");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "STRING");
							push(temp,temp1);
							$$.Node = temp;							
							temp->DT = strdup(yytext);
						}
	;




/* RETURN: */

R: 	/*RETURN ';' 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "R");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "RETURN");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ";");
							push(temp,temp2);
							// got this 2
							$$.Node = temp;
							
						}
	|*/ RETURN expr ';' 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "R");
							// got this 3
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "RETURN");
							push(temp,temp1);
							push(temp,$2.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ";");
							push(temp,temp2);
							if(currentret == $2.Node->DT)
							{}
							else
								cout << "Error in return type" << endl;
							$$.Node = temp;
						}

	| error	'\n'				{ yyerrok; }
	;


/* Break: */
B:	  BREAK ';'				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "B");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "BREAK");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ";");
							push(temp,temp2);
							// got this 2
							$$.Node = temp;
						}
	;

B1:	 CONTINUE ';'				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "B1");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "CONTINUE");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ";");
							push(temp,temp2);
							// got this 2 
							$$.Node = temp;
						}
	;

stmt:   	/* empty */			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "epsilon");
							push(temp,temp1);
							$$.Node = temp;
						}
	| stmt stmt1				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT");
							push(temp,$1.Node);
							push(temp,$2.Node);
							//cout << "s->s1" << endl;
							$$.Node = temp;
						}
	;

stmt1:   B 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| B1 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| R 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| D ';' 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ";");
							push(temp,temp1);
							// got this 2
							$$.Node = temp;
						}
	| C 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| W 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}	
	| I 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| O ';' 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| F 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| expr ';'				{
							//printf(" hiiiii ");
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "STMT1");
							push(temp,$1.Node);
							$$.Node = temp;
							//string a=string(yytext,yyleng);
							//cout<<" bzxvzrtjgjffv "<<a<<endl;
							
						}
	//| const ';'				{ printf("syntax error, wrong expression in lineno: %d", lineno); }
	| error ';'				{ yyerrok; }
	;

/* Paramaters: */
param:  	/*empty */ 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "PARAM");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "epsilon");
							push(temp,temp1);
							$$.Node = temp;
						}	
	/*| D ',' param				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "PARAM");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ",");
							push(temp,temp1);
							push(temp,$3.Node);
							$$.Node = temp;
						}*/
	|  param ',' D            {
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "PARAM");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ",");
							push(temp,temp1);
							push(temp,$3.Node);
							$$.Node = temp;
						}
	| D					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "PARAM");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| error ')'				{ yyerrok; }

	;




/* Constants: */
const:  INT_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "INT_CONST");
							push(temp,temp1);
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "int";
							
						}
	| DOUBLE_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DOUBLE_CONST");
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "double";
							
						}
	| BOOL_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "BOOL_CONST");
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							string a=string(yytext,yyleng);// strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "bool";
							
						}
	| CHAR_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "CHAR_CONST");
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "char";
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							
						}
	|  STRING_CONST 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "STRING_CONST");
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							$$.Node = temp; $$.Node->DT = "string";
							
						}		// these are all tokens
	;

const1:  INT_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST1");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "INT_CONST");//cout<<" I AM HERE "<<endl;
							string a=string(yytext,yyleng); 
							push(temp,temp1); 
							//cout<<string(yytext,yyleng)<<endl;
							$$.Node = temp; $$.Node->DT = "int";
							
						}
	| DOUBLE_CONST				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST1");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DOUBLE_CONST");
							string a=string(yytext,yyleng); strcpy(temp->id, a.c_str());
							push(temp,temp1); 
							$$.Node = temp; $$.Node->DT = "double";
							
						}					// these are all tokens
	;

const2:  BOOL_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST2");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "BOOL_CONST");
							push(temp,temp1); 
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "bool";
							
						}
	| CHAR_CONST 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST2");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "CHAR_CONST");
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "char";
							
						}
	| STRING_CONST				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CONST2");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "STRING_CONST");
							push(temp,temp1); //temp->id = string(yytext,yyleng);
							string a=string(yytext,yyleng); //strcpy(temp->id, a.c_str());
							$$.Node = temp; $$.Node->DT = "string";
							
						}	//these are all tokens
	;



/* General Expressions: 			//IF and RETURN expr */
expr:	  v '=' expr 				{	
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "=");
							push(temp,temp1);
							push(temp,$3.Node);
							
							int tt = scope,flag=0;
							//cout << "print " << scope << endl;
							string s = $1.Node->name; cout<<tt<<" variable is here "<<s<<endl;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name] == $3.Node->DT)
								{
									
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}							
							}
							$$.Node = temp;
						}
	| v INE expr 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "INE");
							push(temp,temp1);
							push(temp,$3.Node);
							
							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name] == $3.Node->DT)
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							$$.Node = temp;
						}
	| v DCE expr 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DCE");
							push(temp,temp1);
							push(temp,$3.Node);

							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name] == $3.Node->DT)
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							$$.Node = temp;
						}
	| v INR 				{
								node* temp = new node; temp->count=0;
								sprintf( temp->state, "EXPR");
								push(temp,$1.Node);
								node* temp1 = new node; temp1->count=0;
								sprintf( temp1->state, "INR");
								push(temp,temp1);
								$$.Node = temp;

							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name]!="bool" && STable[scope][$1.Node->name]!="string")
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							}
	| v DCR 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DCR");
							push(temp,temp1);

							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$1.Node->name]!="bool" && STable[scope][$1.Node->name]!="string")
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							$$.Node = temp;
						}
	| INR v 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "INR");
							push(temp,temp1);
							push(temp,$2.Node);
							int tt = scope,flag=0;
							string s = $2.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$2.Node->name]!="bool" && STable[scope][$2.Node->name]!="string")
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							$$.Node = temp;
						}
	| DCR v 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "DCR");
							push(temp,temp1);
							push(temp,$2.Node);
							int tt = scope,flag=0;
							string s = $2.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							}
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
							{
								if(STable[scope][$2.Node->name]!="bool" && STable[scope][$2.Node->name]!="string")
								{
								
								}
								else
								{
									cout << "Error: Type mismatch" << endl;
								}
							}
							$$.Node = temp;
						}
	| cexpr 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	;

cexpr:  cexpr OR c1expr 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CEXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "OR");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
							if($1.Node->DT == "bool" && $3.Node->DT == "bool")
							{
								$$.Node->DT = "bool";
							}
							else
							{
								cout << "Error : Type mismatch " << endl;
							}
							
						}
	| c1expr				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "CEXPR");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	;

c1expr:  c1expr AND c2expr 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C1EXPR");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "AND");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
							if($1.Node->DT == "bool" && $3.Node->DT == "bool")
							{
									$$.Node->DT = "bool";
							}
							else
							{
									cout << "Error : Type mismatch " << endl;
							}
							
						}
	| c2expr				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C1EXPR");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	;

c2expr:  NOT c2expr 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C2EXPR");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "NOT");
							push(temp,temp1);
							push(temp,$2.Node); $$.Node = temp;
							if($2.Node->DT == "bool")
							{
								$$.Node->DT = "bool" ;
							}
							else
							{
								cout << "Error: Type mismatch" << endl;
							}
							
						}
	| expr1 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C2EXPR");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	| expr2					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "C2EXPR");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	;

expr1:	 expr2 LE expr2 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "LE");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
					$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr2 '<' expr2 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "<");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
					$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr2 '>' expr2 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ">");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
						$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
						}
	|  expr2 GE expr2 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "GE");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
					$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr2 EE  expr2 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "EE");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
					$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr2 NE expr2			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR1");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "NE");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
					$$.Node->DT = "bool";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	;

expr2:  expr2 '+' expr3 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR2");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "+");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
						if($1.Node->DT == "double" || $3.Node->DT == "double")
							$$.Node->DT = "double";
						else
							$$.Node->DT = "int";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr2 '-' expr3 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR2");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "-");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
						if($1.Node->DT == "double" || $3.Node->DT == "double")
							$$.Node->DT = "double";
						else
							$$.Node->DT = "int";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}	
	| expr3					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR2");
							push(temp,$1.Node); $$.Node = temp;
							$$.Node->DT = $1.Node->DT;
							
						}
	;

expr3:  expr3 '*' expr4 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR3");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "*");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
						if($1.Node->DT == "double" || $3.Node->DT == "double")
							$$.Node->DT = "double";
						else
							$$.Node->DT = "int";;
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr3 '/' expr4 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR3");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "/");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && ($3.Node->DT == "int" || $3.Node->DT == "double"))
				{
						if($1.Node->DT == "double" || $3.Node->DT == "double")
							$$.Node->DT = "double";
						else
							$$.Node->DT = "int";;
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr3 '%' expr4 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR3");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "MOD");
							push(temp,temp1);
							push(temp,$3.Node); $$.Node = temp;
				if(($1.Node->DT == "int" || $1.Node->DT == "double") && $3.Node->DT == "int")
				{
						if($1.Node->DT == "double" || $3.Node->DT == "double")
							$$.Node->DT = "double";
						else
							$$.Node->DT = "int";
				}
				else
				{

					cout << "Error :Type mismatch " << endl;
				}
							
							
						}
	| expr4					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR3");
							push(temp,$1.Node);
							$$.Node = temp;
							$$.Node->DT = $1.Node->DT;
						}
	;

expr4:  XXX 					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							push(temp,$1.Node);
							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							} $$.Node = temp;
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
								$$.Node->DT = STable[scope][$1.Node->name];
							
						}
	| '-' XXX 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "-");
							push(temp,temp1);
							push(temp,$2.Node);
							int tt = scope,flag=0;
							string s = $1.Node->name;
							for(int i=tt;i>=0;i--)
							{
								if(STable[i].find(s)==STable[i].end())
								{}
								else
								{ flag=1;break;}
							
							} $$.Node = temp;
							if(flag==0)
								cout << "Error: Variable not declared" << endl;
							else
								$$.Node->DT = STable[scope][$2.Node->name];
							
						}
	| const1 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							push(temp,$1.Node); $$.Node = temp;
							$$.Node->DT = $1.Node->DT;
							
						}
	| '-' '(' expr ')' 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "-");
							push(temp,temp1);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, "(");
							push(temp,temp2);
							push(temp,$3.Node);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ")"); $$.Node = temp;
							$$.Node->DT = $3.Node->DT;
							push(temp,temp3);
							
						}
	|  '(' expr ')' 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "(");
							push(temp,temp1);
							push(temp,$2.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ")"); $$.Node = temp;
							$$.Node->DT = $2.Node->DT;
							push(temp,temp2);
							
						}	// what to do DCR- ???
	| const2				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "EXPR4");
							push(temp,$1.Node); $$.Node = temp;
							$$.Node->DT = $1.Node->DT;
							
						}

	;

v:	XXX					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "V");
							push(temp,$1.Node);
							string a=string(yytext,yyleng); $$.Node = temp;
							$$.Node->name = $1.Node->name;
							
						}
	| error ']'				{ yyerrok; }
	;

XXX:  VAR_NAME					{
							
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "XXX");
							//push(temp,$1.Node);
							
							string a=strdup(yytext); //strcpy(temp->id, a.c_str());
							
							string st=std::to_string(scope);
							string s=a;//+"."+currentfunc+"."+st;
							temp->name = s;
							//cout<<" hyyyyy "<<endl;
							$$.Node = temp;
							//int tt = scope,flag=0;
						/**/
							$$.Node->tempname=a;
							
						}
	;




/* Function calls: */
F:  	XXX  FE XXX '(' args ')' ';'		{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "F");
							push(temp,$1.Node);
							push(temp,$2.Node);
							push(temp,$3.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "(");
							push(temp,temp1);
							push(temp,$5.Node);
							node* temp2 = new node; temp2->count=0;
							sprintf( temp2->state, ")");
							push(temp,temp2);
							node* temp3 = new node; temp3->count=0;
							sprintf( temp3->state, ";");
							push(temp,temp3);
							//if(STable[$1.Node->name])
							// got this 7
							$$.Node = temp;

						}
	;

/*
F1:	 XXX ',' F1 
	| XXX
	;
*/

args:   	/*empty */			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGS");
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, "epsilon");
							push(temp,temp1);
							$$.Node = temp;
						}
	| const ',' args 			{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGS");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ",");
							push(temp,temp1);
							push(temp,$3.Node);
							$$.Node = temp;
						}
	| const 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGS");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| XXX ',' args 				{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGS");
							push(temp,$1.Node);
							node* temp1 = new node; temp1->count=0;
							sprintf( temp1->state, ",");
							push(temp,temp1);
							push(temp,$3.Node);
							$$.Node = temp;
						}
	| XXX					{
							node* temp = new node; temp->count=0;
							sprintf( temp->state, "ARGS");
							push(temp,$1.Node);
							$$.Node = temp;
						}
	| error ')'				{ yyerrok; }		
	;








/* end here */




%%



int main()
{
	cout<<" hello "<<endl;
	temporary=fopen("variables.txt","w");
	map<string,string> temp1;
	STable.push_back(temp1);
	yyparse ();
	fclose(temporary);
	//printf("%s\n", root->state);
	//printf("%d\n", root->count);
	//ds(root);

return 0;
}

void yyerror(const char *  error_message)
{
	//cout<<"Oops we ran into an Error"<<endl;
	cout<<"The Error : "<<error_message<<"error on line  "<<yylineno<<endl;
	//exit(-1);


}

int yywrap()
{
  return(1);
}






