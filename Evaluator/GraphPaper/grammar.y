%{
	#include <libc.h>
	#include <math.h>

	int printingError = 0;
%}

%start list

%union
{
	int    ival;
	double dval;
}

%token <dval> NUMBER
%token <dval> SIN COS TAN ASIN ACOS ATAN
%token <dval> SINH COSH TANH ASINH ACOSH ATANH
%token <dval> SQRT MOD LN LOG PI
%type  <dval> expr number 

%left '+' '-'
%left '*' '/' 
%left SIN COS TAN ASIN ACOS ATAN SINH COSH TANH ASINH
%left ACOSH ATANH
%left '^' SQRT MOD LN LOG
%left UMINUS   /* supplies precedence for unary minus */

%%             /* beginning of rules section */

list : stat
     | list stat
     ;

stat : expr '\n'
{
	printf("%10g\n",$1);
	printingError = 0;
	fflush(stdout);
}
| expr ',' expr '\n'
     {
       printf("%g,%g\n", $1, $3);
       printingError = 0;
       fflush(stdout);
}
;

expr   : '(' expr ')'
{
	$$ = $2;
}
  | expr '+' expr   { $$ = $1 + $3;}
  | expr '-' expr   { $$ = $1 - $3;}
  | expr '*' expr   { $$ = $1 * $3;}
  | expr '/' expr   { $$ = $1 / $3;}
  | SIN expr { $$ = sin($2); }
  | COS expr { $$ = cos($2); }
  | TAN expr { $$ = tan($2); }
  | ASIN expr { $$ = asin($2); }
  | ACOS expr { $$ = acos($2); }
  | ATAN expr { $$ = atan($2); }
  | SINH expr { $$ = sinh($2); }
  | COSH expr { $$ = cosh($2); }
  | TANH expr { $$ = tanh($2); }
  | ASINH expr { $$ = asinh($2); }
  | ACOSH expr { $$ = acosh($2); }
  | ATANH expr { $$ = atanh($2); }
  | expr '^' expr { $$ = pow($1,$3); }
  | expr MOD expr { $$ = fmod($1,$3); }
  | LN expr { $$ = log($2); }
  | LOG expr { $$ = log10($2); }
  | SQRT expr { $$ = sqrt($2); }
  | '-' expr %prec UMINUS
  {
     $$ = -$2;
  }
  | number
	;

number : NUMBER   /* lex number */
  | PI { $$ = M_PI; }
  ;

%% /* beginning of functions section */
int yyerror(char *s)
{
  if (printingError == 0) {
     printf("Syntax Error\n");
     fflush(stdout);
     printingError = 1;
  }
}

int main(int argc,char **argv)
{
  while (!feof(stdin)) {
     yyparse();
  }
  exit(0);
}

