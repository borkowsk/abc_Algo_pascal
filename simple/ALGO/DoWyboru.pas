Program DoWyboru; 
var 
   x:integer; 
Begin 
  writeln('Podaj liczbę od 1 do 5!'); 
  readln(x); 
  Case x of 
    1: 
      writeln('1 program'); 
    z: 
      writeln('2 programy'); 
    3: 
      writeln('3 programy '); 
    4: 
      writeln('4 programy'); 
    5: 
      writeln('5 programów '); 
  else 
    writeln('Miało być od 1 do 5!!!'); 
  end; 
end.
