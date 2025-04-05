program Testowy;
var
  licznik: integer;
  pi: real;
  imie: string;
begin
  licznik := 0;
  pi := 3.14;
  imie := "Jan";
  writeln('Witaj, ', imie);
  licznik := licznik + 1;
  if licznik < 5 then
    writeln('Licznik jest mniejszy od 5')
  else
    writeln('Licznik nie jest mniejszy od 5');
  while licznik < 3 do
  begin
    writeln('W pętli while: ', licznik);
    licznik := licznik + 1;
  end;
  for licznik := 1 to 2 do
    writeln('W pętli for: ', licznik);
  readln;
end.
