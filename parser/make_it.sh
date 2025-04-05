#!/bin/bash
# Kompilacja parsera.

set -e
echo -e $COLOR1"Running flex..."$COLERR
flex pascal.l
echo -e $COLOR1"... done."$NORMCO
#exit 1

echo -e $COLOR1"Running bison.."$COLERR
bison -d pascal.y
echo -e $COLOR1"... done."$NORMCO
exit 2

g++ -o translator y.tab.cpp lex.yy.c -lfl
