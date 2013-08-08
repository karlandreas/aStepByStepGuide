%{
#include "y.tab.h"
#include <stdlib.h>

#define YY_INPUT(buf,result,max_size) (buf[0])=getchar();result=1;

int yywrap(void);
int yywrap(){return 0;}

%}

%%

"\n" return('\n');

[0-9]*("."[0-9]*("e"[-+][0-9]+)?)?  {yylval.dval = atof(yytext);   return(NUMBER);}

sin        return(SIN);
cos        return(COS);
tan        return(TAN);
asin       return(ASIN);
acos       return(ACOS);
atan       return(ATAN);
sinh       return(SINH);
cosh       return(COSH);
tanh       return(TANH);
asinh      return(ASINH);
acosh      return(ACOSH);
atanh      return(ATANH);
mod        return(MOD);
ln         return(LN);
log        return(LOG);
sqrt       return(SQRT);
pi         return(PI);

[ \t]     ;

.         {return(yytext[0]);}

%%


