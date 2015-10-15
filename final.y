%{

#include <bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
stack <string> labels;
stack <string> arguments;
stack <string> parameters;
FILE* lovely;
map<string,int> varmap;
void yyerror(const char *  error_message );
/*typedef struct node node; 
struct node
 	{
 		char state[20];                   // 
 		node* pro[17];
		int count;
		char id[50];
 		//string ID;                      // Identifier
 		//string DT;                      // DataType
 	};

node* root;
*/
//typedef struct u_type u_type;
string gs; string tb; char *aaa;
union u_type
{
	char* c;
};

#define YYSTYPE u_type
string newlabel; string label8; string label9;
vector <vector<string> > STable;

/*
vector <map<string,string>> STable;

int scope = 0;


int findIdScope(string id)
{
	for(int i=scope;i>=0;i--)
	{
		if(STable[i].find(id) != STable[i].end())	
			return scope;
	}
	return -1;
}
*/
extern int lineno; int countar=0; int k=0;
/*//node* nlist[100]; ncount=0;

void push(node* lovely, node* n)
{

	lovely->pro[lovely->count]=n;
	lovely->count++;

} 

void ds(node* lovely)
{	if(lovely==NULL)
	{
	}
	else 
	{
		int cot=0;
		int a=(lovely->count);
		while(cot<a)
		{
			printf(" %s ", (lovely->pro[cot])->state);
			ds((lovely->pro[cot]));
			cot++;
		}
		printf("\n");
	}

}
*/
string current;
string currentl;

string getnewreg()
{
	static int count=0;
	stringstream ss;
	ss<<++count;
	current=string("t"+ss.str());
	return current;
}

string getnewlabel()
{
	static int label=0;
	stringstream ss;
	ss<<++label;
	currentl= string("label"+ss.str()+":");
	return currentl;
}

string currentfunc="global";
string currentfunctype="";
int scope=0;

int check_scope(string str)	
{
	for(int i=STable.size()-1; i>-1; i--)
	{
		for(int j=0; j<STable[i].size(); j++)
		{
			if(STable[i][j]==str)
				return i;
		}
	}

}

int valentine(char *);
%}


%error-verbose
%start Program

%token IF ELSE WHILE PRINT SCAN ENDL STRING_CONST INT_CONST DOUBLE_CONST CHAR_CONST BOOL_CONST VAR_NAME OR NOT AND INT BOOL CHAR DOUBLE STRING RETURN BREAK CONTINUE MAIN GLOBAL IN OUT FE INR DCR INE DCE LE GE NE EE THEN



%left OR '(' ')' IN OUT '<' '>' LE GE NE EE ','
%left AND
%left '+' '-'
%left '*' '/' '%'
%right '=' INE DCE INR DCR FE 
//%left UMINUS  /*supplies precedence for unary minus */

%%                   /* beginning of rules section */

/* Global statements: */

Program: Program1				{ 
						}
	;

Program1:  G X                                	{ 
							
						}
	;

G: 		/* empty */			{
						}
							
	|  D1 ';' G 				{
						}
	;
 


X:	Y X 					{
						}
	| INT MAIN 				{              currentfunc="main";
							       currentfunctype="int";
							//	cout<<" hiiii "<<endl;
							       fprintf(lovely,"main:\n");
							       fprintf(lovely,"move $t0 $sp\n");
							       fprintf(lovely,"addiu $sp $sp %d\n",-4*k );
						}
	'(' argsm ')' '{' 			{ scope++; vector<string>map1; STable.push_back(map1); }

	Block '}'				{ scope--; STable.pop_back(); }	
	;
		
Y: 	T1 VAR_NAME 				{	
							$1.c=strdup(yytext);
							fprintf(lovely,"%s:\n",strdup(yytext));
							currentfunc=strdup(yytext);
							currentfunctype=string($1.c);
							
						}
	
	'(' param 				{	
							while(!parameters.empty())
							{
							 	fprintf(lovely, "lw $a0 4($sp)\n");
								fprintf(lovely, "addiu $sp $sp 4\n");
								string a=parameters.top()+"."+currentfunc+"."+to_string(scope);
								char *s = new char[a.length()+1]; 
								strcpy(s,a.c_str());
								
								k=valentine(s);
								
								parameters.pop();
								fprintf(lovely,"sw $a0 %d($t0)\n", 4*k-4);
								//arguments.pop(); cout<<" till here "<<endl;
							}
					
							  fprintf(lovely,"sw $ra 0($sp)\n");
							  fprintf(lovely,"addiu $sp $sp - 4\n");
							  
					  
						}

	')' '{' 				{   scope++; vector<string>map1; STable.push_back(map1); }
	
	Block '}'				{
						       //cout<<"gghkhkhkhkhk"<<endl;
						       fprintf(lovely,"lw $ra 4($sp)\n"); 
						       fprintf(lovely,"addiu $sp $sp %d\n",4);  
						       //fprintf(lovely,"li $a0 0\n");
						       //fprintf(lovely,"sw $a0 0($sp)\n");
						       //fprintf(lovely,"addiu $sp $sp -4\n");
						       fprintf(lovely,"jr $ra\n");
							countar=0; scope--; STable.pop_back();
		                    		}
	;

T1:	type 					{ $$.c=$1.c;
						}
	;

Block:  stmt					{
						}
	;

argsm: 						{
						}
	;


/* Conditional statements: */
C: 	IF '(' expr ')' 			{
                               
						       fprintf(lovely,"lw $a0 4($sp)\n");
						       fprintf(lovely,"addiu $sp $sp 4\n");
						       label8 = getnewlabel();
						       fprintf(lovely, "beqz $a0  %s\n", label8.c_str() );
						       labels.push(label8);						       

						 }
	
	'{' 					{ scope++; vector<string>map1; STable.push_back(map1); }

	stmt '}' 				{
                                                  	fprintf(lovely, "%s:\n",labels.top().c_str() );labels.pop();   
							scope--; STable.pop_back();                                 
                                       		 }

	| IF '(' expr ')' 			{
                               
						       fprintf(lovely,"lw $a0 4($sp)\n");
						       fprintf(lovely,"addiu $sp $sp 4\n");
						       label8 = getnewlabel();
						       fprintf(lovely, "beqz $a0  %s\n", label8.c_str() );
						       labels.push(label8);						       

						 }	
			
	THEN '{' 					{ scope++; vector<string>map1; STable.push_back(map1); }
	
	stmt '}' 				{ scope--; STable.pop_back(); }	

	ELSE '{'				{ scope++; vector<string>map1; STable.push_back(map1);
                                                  fprintf(lovely, "%s:\n",labels.top().c_str());  labels.pop();
                                       		}

	stmt '}' 				{ scope--; STable.pop_back(); }
	;

	


/* Loops: */

W: 	WHILE '(' 				{
							newlabel = getnewlabel();
							fprintf(lovely, "%s :\n", newlabel.c_str());  
							labels.push(newlabel);
				      		 }

	expr 					{
							   fprintf(lovely,"lw $a0 4($sp)\n");
							   fprintf(lovely,"addiu $sp $sp 4\n");
							   label9 = getnewlabel();
							   labels.push(label9);
							   fprintf(lovely, "beqz $a0  %s\n", label9.c_str() );
				          
				      		}
	')' '{' 				{ scope++; vector<string>map1; STable.push_back(map1); }

	stmt '}' 				{
						  string s1= labels.top(); labels.pop(); string s2=labels.top(); labels.pop();
				                  fprintf(lovely,"b %s\n",s2.c_str());
				                  fprintf(lovely, "%s:\n",s1.c_str()); scope--; STable.pop_back();               
                            			}
	;			//include-- for later


/* Input/Output: */

O:	PRINT E2 				{
						}
	
	;

E2:	OUT cexpr				{ 	fprintf(lovely,"lw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");

							fprintf(lovely,"li $v0 1\n");
							fprintf(lovely,"syscall\n");
						}
	| OUT cexpr E2				{  	fprintf(lovely,"lw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");

							fprintf(lovely,"li $v0 1\n");
							fprintf(lovely,"syscall\n");
						}
	;

I:	SCAN IN VAR_NAME ';'				{ 	
							fprintf(lovely,"li $v0 5\n");
							fprintf(lovely,"syscall\n");
							//fprintf(lovely,"lw $a0 0($sp)\n");
							//fprintf(lovely,"addiu $sp $sp 4\n");
							string ss = strdup(yytext);
							int i=check_scope(ss);
							if(i>0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string(ss)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k-4);
									//check
						}
	;



 /* Declaration: */

D1:  	GLOBAL type Dmult			{
						  STable[scope].push_back(string($2.c));
						}
	;

D:  	type Dmult 				{ $$.c=$2.c;
						  STable[scope].push_back(string($$.c));
						}
	;

Dmult:   VAR_NAME 				{ $$.c=strdup(yytext);
						}
	| assign 				{ $$.c=$1.c;
						}
	; 


assign:  VAR_NAME '=' const				{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							//k=valentine($1);
							string ss=strdup(yytext);
							int i=check_scope(ss);
							if(i>0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string(ss)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k-4);
							$$.c=strdup(yytext);
						}
	| VAR_NAME '=' VAR_NAME				{
							string ss=strdup(yytext); $$.c=strdup(yytext);
							int i=check_scope(ss); int k1=0;
							if(i>0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k1=valentine(a);
								
							}
							if(i==0)
							{
								string s=string(ss)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k1=valentine(a);
							}
							if(k1==-1)
							{
								string s=string(ss)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k1=valentine(a);
							}
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k1-4);
							fprintf(lovely,"addiu $sp $sp 4\n");
							//
							//$3.c=strdup(yytext);
							string sss = strdup(yytext);
							i=check_scope(string(sss));
							if(i>0)
							{
								string s=string(sss)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string(sss)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string(sss)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k-4);
							
							
						}
	;



type:   INT					{	$$.c=strdup(yytext);
						}
	/*| VOID					{
						}*/	
	| DOUBLE				{	$$.c=strdup(yytext);
						}
	| BOOL					{	$$.c=strdup(yytext);
						}
	| CHAR 					{	$$.c=strdup(yytext);
						}
	| STRING				{	$$.c=strdup(yytext);
						}
	;




/* RETURN: */

R: 	/*RETURN ';' 				{
							    fprintf(lovely,"lw $ra 4($sp)\n"); 
						            fprintf(lovely,"addiu $sp $sp 8\n"); 
						            fprintf(lovely,"lw $fp 0($sp)\n"); 
							    fprintf(lovely,"jr $ra\n");	

							
						}
	|*/
	RETURN 					{	
						            fprintf(lovely,"lw $ra 4($sp)\n"); 
						            fprintf(lovely,"addiu $sp $sp 4\n"); 		//4*t +8 pop up 

                            			}
	expr ';' 				{
								fprintf(lovely,"jr $ra\n");	
						}
	;


/* Break: */
B:	  BREAK ';'				{
						}		// check later 
	;

B1:	 CONTINUE ';'				{
						}		//check later
	;

stmt:   	/* empty */			{
						}
	| stmt stmt1				{
						}
	;

stmt1:   B 					{
						}
	| B1 					{
						}
	| R 					{
						}
	| D ';' 				{
						}
	| C 					{
						}
	| W 					{
						}	
	| I 					{
						}
	| O ';'					{
						}
	| F 					{
						}
	| expr ';'				{							
						}
	;

/* Paramaters: */
param:  	/*empty */ 			{ 
						}	
	| param ',' D				{	STable[scope].push_back(string($3.c));
							parameters.push(string($3.c));
							fprintf(lovely,"addiu $sp $sp 4\n");
							countar++;
							
						}
	| D					{	STable[scope].push_back(string($1.c));
							parameters.push(string($1.c));
							fprintf(lovely,"addiu $sp $sp 4\n");
							countar++; 
						}			//look into it later

	;




/* Constants: */
const:  INT_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	| DOUBLE_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	| BOOL_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	| CHAR_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	|  STRING_CONST 			{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}		// these are all tokens
	;

const1:  INT_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
							//cout<<" integer constant"<<endl;
						}
	| DOUBLE_CONST				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}					// these are all tokens
	;

const2:  BOOL_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	| CHAR_CONST 				{
							fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}
	| STRING_CONST				{
							
				                    	fprintf(lovely,"li $a0 %s\n",strdup(yytext));
				                    	fprintf(lovely,"sw $a0 0($sp)\n");
						   	 fprintf(lovely,"addiu $sp $sp -4\n");
				                   	 $$.c = strdup(yytext);
						}	//these are all tokens
	;



/* General Expressions: 			//IF and RETURN expr */
expr:	  v '=' expr 				{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							//
							int i=check_scope(string($1.c));
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k-4);
							fprintf(lovely,"addiu $sp $sp 4\n"); 
						}
	| v INE expr 				{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							//
							int i=check_scope(string($1.c));
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"add $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| v DCE expr 				{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							//
							int i=check_scope(string($1.c));
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"sub $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| v INR 				{
							fprintf(lovely,"li $t1 1\n");
							//
							int i=check_scope(string($1.c));
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"add $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| v DCR 				{
							fprintf(lovely,"li $t1 1\n");
							//
							int i=check_scope(string($1.c));
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"sub $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| INR v 				{
							fprintf(lovely,"li $t1 1\n");
							//
							int i=check_scope(string($2.c));
							if(i>0)
							{
								string s=string($2.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($2.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($2.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"add $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| DCR v 				{
							fprintf(lovely,"li $t1 1\n");
							//
							int i=check_scope(string($2.c));
							if(i>0)
							{
								string s=string($2.c)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($2.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($2.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"sub $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k - 4);
							fprintf(lovely,"addiu $sp $sp 4\n");
						}
	| cexpr 				{	//cout<<" bfq348758469"<<endl;
							
						}
	;

cexpr:  cexpr OR c1expr 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"or $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
							
						}
	| c1expr				{	//cout<<" finall122"<<endl;
						}
	;

c1expr:  c1expr AND c2expr 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"and $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| c2expr				{	//cout<<" gfua1111"<<endl;
						}
	;

c2expr:  NOT c2expr 				{
							fprintf(lovely,"lw $a0 4($sp)\n");		//check if working not
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"nor $a0 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr1 				{	 //cout<<" atleast here"<<endl;
						}
	| expr2					{ 
						}
	;

expr1:	 expr2 LE expr2 			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"ble $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");		
						}
	| expr2 '<' expr2 			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"blt $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr2 '>' expr2 			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"bgt $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");
						}
	|  expr2 GE expr2 			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"bge $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr2 EE  expr2 			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"beq $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr2 NE expr2			{
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $a0 4($sp)\n");
                                                        fprintf(lovely,"addiu $sp $sp 4\n");
							string label1 = getnewlabel();
							string label2 = getnewlabel();
                                                        fprintf(lovely,"bne $a0 $t1 %s\n",label1.c_str());
							fprintf(lovely, "li $a0 0\n" );
							fprintf(lovely, "b %s\n",label2.c_str() );
							fprintf(lovely, "%s:",label1.c_str() );
							fprintf(lovely, "li $a0 1\n" );
							fprintf(lovely, "%s:",label2.c_str() );
                                                        fprintf(lovely,"sw $a0 0($sp)\n");
			                                fprintf(lovely,"addiu $sp $sp -4\n");
						}
	;

expr2:  expr2 {cout<<" hereeeeee "<<endl; }'+' expr3 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"add $a0 $a0 $t1\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
							
						}
	| expr2 '-' expr3 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"sub $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}	
	| expr3					{ //cout<<" hhhhhhhhhhereeee "<<endl;	
						}
	;

expr3:  expr3 '*' expr4 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"mul $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr3 '/' expr4 			{
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"div $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr3 '%' expr4 			{		//write modulus
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"move $t2 $a0\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"div $a0 $t1 $a0\n");
							fprintf(lovely,"mul $a0 $t2 $a0\n");
							fprintf(lovely,"sub $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| expr4					{	//cout<<" kasfu"<<endl;
						}
	;

expr4:  XXX 					{	//cout<<" till jere1"<<endl;
							
						}
	| '-' XXX 				{
							fprintf(lovely,"li $a0 -1\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"mul $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	| const1 				{	//cout<<" til here 33"<<endl;
						}
	| '-' '(' expr ')' 			{
							fprintf(lovely,"li $a0 -1\n");
							fprintf(lovely,"lw $t1 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							fprintf(lovely,"mul $a0 $t1 $a0\n");
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
						}
	|  '(' expr ')' 			{
						}	
	| const2				{
						}

	;

v:	XXX					{	//cout<<"huhoihoho"<<endl;
							$$.c = $1.c;
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n"); 
							//cout<<" hhhhhhhhh "<<endl;
						}
	| error ']'				{ yyerrok; }
	;

XXX:  VAR_NAME					{	//cout<<"hhojljjpkppopop"<<endl;
							//string st=to_string(scope);
							
							string a = string(yytext);
							char *s = new char[a.length() + 1];
							strcpy(s, a.c_str());
							$1.c=strdup(yytext);
							//cout<<s<<" gggggg "<<$1.c<<endl;
							//
							int i=check_scope(s);
							//cout<<i<<endl;
							if(i>0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(i);
								//cout<<s<<endl;
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string($1.c)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string($1.c)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							//cout<<" hgyfgeoho "<<k<<endl;
						        //cout << yytext << endl;
							if(k!=-1) {
							fprintf(lovely,"lw $a0 %d($t0)\n",4*k-4); 
							fprintf(lovely,"sw $a0 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n"); 
							}
							$$.c = strdup(yytext);
							//cout<<" expr3"<<endl;
						}
	;




/* Function calls: */
F:  	VAR_NAME { gs=strdup(yytext); } FE VAR_NAME 			{
							fprintf(lovely,"sw $ra 0($sp)\n");
							fprintf(lovely,"addiu $sp $sp -4\n");
							tb=string(strdup(yytext));
							aaa=new char[tb.length()+1];
								strcpy(aaa,tb.c_str());
						}

	'(' args ')' ';'		{		//$4.c = strdup(yytext);
							fprintf(lovely,"jal %s\n",aaa);
							
							//
							int i=check_scope(string(gs));
							if(i>0)
							{
								string s=string(gs)+ "." + currentfunc + "." + to_string(i);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
								
							}
							if(i==0)
							{
								string s=string(gs)+ "." + currentfunc + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							if(k==-1)
							{
								string s=string(gs)+ "." + "global" + "." + to_string(0);
								char *a=new char[s.length()+1];
								strcpy(a,s.c_str());
								k=valentine(a);
							}
							//
							fprintf(lovely,"lw $a0 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n"); 
							fprintf(lovely,"sw $a0 %d($t0)\n",4*k-4); 
							fprintf(lovely,"lw $ra 4($sp)\n");
							fprintf(lovely,"addiu $sp $sp 4\n");
							//fprintf(lovely,"addiu $sp $sp 4\n");
							//countar=0; 							
						}
	;

/*
F1:	 XXX ',' F1 
	| XXX
	;
*/

args:   	/*empty */			{

						}
	| const ',' args 			{	//countar++;
							arguments.push(string($1.c));
						}
	| const 				{
							//countar++; 
							arguments.push(string($1.c));
						}
	| XXX ',' args 				{
							//countar++; 
							arguments.push(string($1.c));
						}
	| XXX					{
							//countar++; 
							arguments.push(string($1.c));
						}	
	;








/* end here */




%%

int valentine(char *a)
{
        string x(a);
	if(varmap.find(x)!=varmap.end())return varmap[x];
	else return -1;
}


int main()
{
	char a[1000];
       
	lovely=fopen("variables.txt","r");
	k=0;
	while(fscanf(lovely,"%s",a)!=EOF)
	{
		string b(a);
              if(varmap.find(b)==varmap.end())
               {varmap[b]=++k;}
	}
        
	fclose(lovely);
     	vector <string> str;
	STable.push_back(str);
	lovely=fopen("output.s","w");
	//cout<<"gfjgkudsfgiudsgiu"<<endl;
	yyparse ();
	//fprintf(lovely,"jr $ra\n" );
	fclose(lovely);
	
       	return 0;

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






