%{
#include <iostream>
#include <string>
#include <vector>

using namespace std;

// Deklaracja funkcji leksera
extern int yylex();
extern char *yytext;
void yyerror(const char *s);

// Struktura do przechowywania pseudokodu
vector<string> pseudocode;

// Funkcja do dodawania linii pseudokodu
void addPseudocode(const string& line) {
    pseudocode.push_back(line);
}
%}

%union {
    int ival;
    double dval;
    char *sval;
}

%token <ival> INTEGER_LITERAL
%token <dval> REAL_LITERAL
%token <sval> STRING_LITERAL IDENTIFIER BOOLEAN_LITERAL

%token PROGRAM VAR BEGIN END IF THEN ELSE WHILE DO FOR TO DOWNTO READLN WRITELN
%token INTEGER_TYPE REAL_TYPE STRING_TYPE BOOLEAN_TYPE
%token ASSIGN EQUAL NOT_EQUAL LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%token PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN LBRACKET RBRACKET SEMICOLON COLON COMMA DOT

%%

program: PROGRAM IDENTIFIER SEMICOLON block DOT
         { addPseudocode("PROGRAM " + string($2) + ";"); }
       ;

block: declarations compound_statement
       ;

declarations: var_declaration_part
            | /* empty */
            ;

var_declaration_part: VAR var_declarations SEMICOLON
                    { addPseudocode("VAR"); }
                  ;

var_declarations: identifier_list COLON type_specifier
                {
                    string type;
                    if ($3 == INTEGER_TYPE) type = "CAŁKOWITA";
                    else if ($3 == REAL_TYPE) type = "RZECZYWISTA";
                    else if ($3 == STRING_TYPE) type = "TEKST";
                    else if ($3 == BOOLEAN_TYPE) type = "LOGICZNA";
                    string identifiers;
                    // Tutaj trzeba by zaimplementować zbieranie identyfikatorów z $1
                    // Na potrzeby przykładu upraszczamy
                    identifiers = string($1); // To wymaga poprawy
                    addPseudocode("  " + identifiers + ": " + type + ";");
                }
                | var_declarations SEMICOLON identifier_list COLON type_specifier
                {
                    string type;
                    if ($5 == INTEGER_TYPE) type = "CAŁKOWITA";
                    else if ($5 == REAL_TYPE) type = "RZECZYWISTA";
                    else if ($5 == STRING_TYPE) type = "TEKST";
                    else if ($5 == BOOLEAN_TYPE) type = "LOGICZNA";
                    string identifiers;
                    identifiers = string($3); // To wymaga poprawy
                    addPseudocode("  " + identifiers + ": " + type + ";");
                }
                ;

identifier_list: IDENTIFIER
               { $$ = $1; }
               | identifier_list COMMA IDENTIFIER
               { $$ = string($1) + ", " + string($3); }
               ;

type_specifier: INTEGER_TYPE { $$ = INTEGER_TYPE; }
              | REAL_TYPE    { $$ = REAL_TYPE; }
              | STRING_TYPE  { $$ = STRING_TYPE; }
              | BOOLEAN_TYPE { $$ = BOOLEAN_TYPE; }
              ;

compound_statement: BEGIN statement_list END
                    { addPseudocode("BEGIN");
                      for (const auto& line : *((vector<string>*)$2)) {
                          addPseudocode("  " + line);
                      }
                      addPseudocode("END."); }
                  ;

statement_list: statement
                { $$ = new vector<string>{$1}; }
              | statement_list SEMICOLON statement
                { ((vector<string>*)$$)->push_back($3); }
              ;

statement: assignment_statement SEMICOLON { $$ = $1; }
         | if_statement SEMICOLON       { $$ = $1; }
         | while_statement SEMICOLON    { $$ = $1; }
         | for_statement SEMICOLON      { $$ = $1; }
         | readln_statement SEMICOLON   { $$ = $1; }
         | writeln_statement SEMICOLON  { $$ = $1; }
         | compound_statement           { $$ = "BEGIN ... END"; } // Uproszczenie
         ;

assignment_statement: IDENTIFIER ASSIGN expression
                      { $$ = string($1) + " := " + $3; }
                    ;

if_statement: IF condition THEN statement
              { $$ = "JEŻELI " + $2 + " TO\n  " + $4; }
            | IF condition THEN statement ELSE statement
              { $$ = "JEŻELI " + $2 + " TO\n  " + $4 + "\nINACZEJ\n  " + $6; }
            ;

while_statement: WHILE condition DO statement
                 { $$ = "DOPÓKI " + $2 + " WYKONAJ\n  " + $4; }
               ;

for_statement: FOR IDENTIFIER ASSIGN initial_value (TO | DOWNTO) final_value DO statement
               {
                   string direction = ($5 == TO) ? "DO" : "OD";
                   $$ = "DLA " + string($2) + " := " + $4 + " " + direction + " " + $6 + " WYKONAJ\n  " + $8;
               }
             ;

readln_statement: READLN LPAREN identifier_list RPAREN
                  {
                      string vars;
                      // Podobnie jak w deklaracjach, wymaga poprawy zbierania identyfikatorów
                      vars = string($3);
                      $$ = "CZYTAJ(" + vars + ")";
                  }
                | READLN
                  { $$ = "CZYTAJ()"; }
                ;

writeln_statement: WRITELN LPAREN write_argument_list RPAREN
                   { $$ = "PISZ(" + $3 + ")"; }
                 | WRITELN
                   { $$ = "PISZ()"; }
                 ;

write_argument_list: write_argument
                     { $$ = $1; }
                   | write_argument_list COMMA write_argument
                     { $$ = string($1) + ", " + $3; }
                   ;

write_argument: expression
                { $$ = $1; }
              | STRING_LITERAL
                { $$ = string($1); }
              ;

condition: expression
           { $$ = $1; }
         | expression EQUAL expression        { $$ = $1 + " = " + $3; }
         | expression NOT_EQUAL expression    { $$ = $1 + " <> " + $3; }
         | expression LESS_THAN expression    { $$ = $1 + " < " + $3; }
         | expression GREATER_THAN expression { $$ = $1 + " > " + $3; }
         | expression LESS_EQUAL expression   { $$ = $1 + " <= " + $3; }
         | expression GREATER_EQUAL expression{ $$ = $1 + " >= " + $3; }
         // Można dodać więcej operatorów logicznych (AND, OR, NOT)
         ;

expression: term
            { $$ = $1; }
          | expression PLUS term
            { $$ = $1 + " + " + $3; }
          | expression MINUS term
            { $$ = $1 + " - " + $3; }
          ;

term: factor
      { $$ = $1; }
    | term MULTIPLY factor
      { $$ = $1 + " * " + $3; }
    | term DIVIDE factor
      { $$ = $1 + " / " + $3; }
    ;

factor: IDENTIFIER
        { $$ = string($1); }
      | INTEGER_LITERAL
        { $$ = to_string($1); }
      | REAL_LITERAL
        { $$ = to_string($1); }
      | STRING_LITERAL
        { $$ = string($1); }
      | BOOLEAN_LITERAL
        { $$ = string($1); }
      | LPAREN expression RPAREN
        { $$ = "(" + $2 + ")"; }
      ;

%%

void yyerror(const char *s) {
    cerr << "Błąd składniowy: " << s << " w linii " << yylineno << endl;
}

int main() {
    yyparse(); // Rozpoczęcie parsowania
    cout << "Wygenerowany pseudokod:\n";
    for (const auto& line : pseudocode) {
        cout << line << endl;
    }
    return 0;
}


