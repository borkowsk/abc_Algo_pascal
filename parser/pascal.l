%{
#include "y.tab.h" // Plik nagłówkowy generowany przez Yacc
#include <string>
#include <iostream>

using namespace std;

// Funkcja wywoływana w przypadku nierozpoznanego tokenu (opcjonalnie)
void yyerror(const char *s);
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
INTEGER     {DIGIT}+
REAL        {DIGIT}+\.{DIGIT}+
STRING      \"[^"]*\"

%%
program         { return PROGRAM; }
var             { return VAR; }
begin           { return BEGIN; }
end             { return END; }
if              { return IF; }
then            { return THEN; }
else            { return ELSE; }
while           { return WHILE; }
do              { return DO; }
for             { return FOR; }
to              { return TO; }
downto          { return DOWNTO; }
readln          { return READLN; }
writeln         { return WRITELN; }
integer         { return INTEGER_TYPE; }
real            { return REAL_TYPE; }
string          { return STRING_TYPE; }
boolean         { return BOOLEAN_TYPE; }
true            { yylval.sval = new string("prawda"); return BOOLEAN_LITERAL; }
false           { yylval.sval = new string("fałsz"); return BOOLEAN_LITERAL; }
:=              { return ASSIGN; }
=               { return EQUAL; }
<>              { return NOT_EQUAL; }
<               { return LESS_THAN; }
>               { return GREATER_THAN; }
<=              { return LESS_EQUAL; }
>=              { return GREATER_EQUAL; }
\+              { return PLUS; }
-               { return MINUS; }
\* { return MULTIPLY; }
/               { return DIVIDE; }
\(              { return LPAREN; }
\)              { return RPAREN; }
\[              { return LBRACKET; }
\]              { return RBRACKET; }
;               { return SEMICOLON; }
:               { return COLON; }
,               { return COMMA; }
\.              { return DOT; }
{IDENTIFIER}    { yylval.sval = new string(yytext); return IDENTIFIER; }
{INTEGER}       { yylval.ival = atoi(yytext); return INTEGER_LITERAL; }
{REAL}          { yylval.dval = atof(yytext); return REAL_LITERAL; }
{STRING}        { yylval.sval = new string(yytext); return STRING_LITERAL; }
[ \t\n]+        ; // Ignoruj białe znaki
.               { yyerror("Nierozpoznany znak"); }
%%


