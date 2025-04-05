#!/bin/bash
# Kompilacja parsera.

set -e
flex pascal.l

exit 1

bison -d pascal.y
g++ -o translator y.tab.cpp lex.yy.c -lfl
