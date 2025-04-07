// kod JavaScript używający parsera
// Użyj:
//         node use_parser.js <ścieżka_do_pliku_pascal.pas>
//
// Oczywiście `jison` musi być zainstalowany.

const jison = require('jison');
const fs = require('fs');

// Sprawdź, czy podano argument z nazwą pliku
if (process.argv.length < 3) {
    console.error("Użycie: node use_parser.js <ścieżka_do_pliku_pascal.pas>");
    process.exit(1); // Zakończ program z kodem błędu
}

const pascalFilePath = process.argv[2];

try {
    const grammarContent = fs.readFileSync('pascal.jison', 'utf8');
    const parser = new jison.Parser(grammarContent);

    const pascalCode = fs.readFileSync(pascalFilePath, 'utf8');
    console.log("START:");
    console.log("Parsowany kod z pliku:", pascalCode);
    const ast = parser.parse(pascalCode);
    console.log(ast); // Abstrakcyjne drzewo składniowe (AST)
} catch (err) {
    console.error("Błąd parsowania:", err);
}


