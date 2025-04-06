// kod JavaScript używający parsera
// Użyj:
//        node use_parser.js
//
// Oczywiście `jison` musi być zainstalowany.

const jison = require('jison');
const fs = require('fs');

const grammarContent = fs.readFileSync('pascal.jison', 'utf8');
const parser = new jison.Parser(grammarContent);

try {
    console.log("START:");
    const ast = parser.parse("PROGRAM test; BEGIN a := 5; WRITELN(a) END.");
    console.log(ast); // Abstrakcyjne drzewo składniowe (AST)
} catch (err) {
    console.error("Błąd parsowania:", err);
}

