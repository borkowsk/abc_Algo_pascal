// pascal.jison
/* lexical grammar */
%lex
%%
\s+                    /* skip whitespace */
"PROGRAM"              return 'PROGRAM'
"BEGIN"                return 'BEGIN'
"END"                  return 'END'
"WRITELN"              return 'WRITELN'
"("                    return 'LPAREN'
")"                    return 'RPAREN'
"."                    return 'DOT'
":="                   return 'ASSIGN'
";"                    return 'SEMICOLON'
[0-9]+                 return 'NUMBER'
[a-zA-Z_][a-zA-Z0-9_]* return 'IDENTIFIER'
<<EOF>>                return 'EOF'
/lex

/* syntactic grammar */
%start Program

%%

Program
    : PROGRAM IDENTIFIER SEMICOLON Block DOT EOF
        { return $4; }
    ;

Block
    : BEGIN StatementList END
        { return $2; }
    ;

StatementList
    : Statement SEMICOLON StatementList?
        { $$ = [$1].concat($3 || []); }
    | Statement
        { $$ = [$1]; }
    | /* empty */
        { $$ = []; }
    ;

Statement
    : IDENTIFIER ASSIGN Expression
        { $$ = { type: 'assignment', id: $1, expr: $3 }; }
    | WRITELN LPAREN Expression RPAREN
        { $$ = { type: 'writeln', expr: $3 }; }
    ;

Expression
    : IDENTIFIER
        { $$ = { type: 'identifier', value: $1 }; }
    | NUMBER
        { $$ = { type: 'number', value: Number($1) }; }
    ;
%%

