// pascal.jison - nie potrafi już przejśc do parsowania body-block po deklaracjach :-(
/* lexical grammar */
%lex
%%
\s+                    /* skip whitespace */
"PROGRAM"              return 'PROGRAM'
"VAR"                  return 'VAR'
"INTEGER"              return 'INTEGER_TYPE'
"REAL"                 return 'REAL_TYPE'
"BOOLEAN"              return 'BOOL_TYPE'
"STRING"               return 'STRING_TYPE'
"CHAR"                 return 'CHAR_TYPE'
"BEGIN"                return 'BEGIN'
"END"                  return 'END'
"WRITELN"              return 'WRITELN'
"("                    return 'LPAREN'
")"                    return 'RPAREN'
"."                    return 'DOT'
":="                   return 'ASSIGN'
":"                    return 'COLON'
";"                    return 'SEMICOLON'
[0-9]+                 return 'NUMBER'
[a-zA-Z_][a-zA-Z0-9_]* return 'IDENTIFIER'
<<EOF>>                return 'EOF'
/lex


/* syntactic grammar */
%start Program

%%

Program
    : PROGRAM IDENTIFIER SEMICOLON Declarations Block DOT EOF
        { $$ = { type: 'program', id: $2, declarations: $4, body: $5 }; }
    ;

Declarations
    : VAR VarDeclarations
        { $$ = $2; }
    | /* empty */
        { $$ = []; }
    ;

VarDeclarations
    : VarDeclaration
        { $$ = [$1]; }
    | VarDeclarations SEMICOLON VarDeclaration
        { $$ = $1.concat($3); }
    ;

VarDeclaration
    : IdentifierList COLON TypeSpecifier SEMICOLON
        { $$ = { type: 'variable_declaration', identifiers: $1, variableType: $3 }; }
    ;

Block
    : BEGIN StatementList END
        { $$ = { type: 'block', statements: $2 }; }
    ;

IdentifierList
    : IDENTIFIER
        { $$ = [$1]; }
    | IdentifierList COMMA IDENTIFIER
        { $$ = $1.concat($3); }
    ;

TypeSpecifier
    : INTEGER_TYPE
        { $$ = 'INTEGER'; }
    | REAL_TYPE
        { $$ = 'REAL'; }
    | BOOL_TYPE
        { $$ = 'BOOLEAN'; }
    | STRING_TYPE
        { $$ = 'STRING'; }
    | CHAR_TYPE
        { $$ = 'CHAR'; }
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
    : IDENTIFIER ASSIGN Expression SEMICOLON
        { $$ = { type: 'assignment', id: $1, expr: $3 }; }
    | WRITELN LPAREN Expression RPAREN SEMICOLON
        { $$ = { type: 'writeln', expr: $3 }; }
    ;

Expression
    : IDENTIFIER
        { $$ = { type: 'identifier', value: $1 }; }
    | NUMBER
        { $$ = { type: 'number', value: Number($1) }; }
    ;

%%

