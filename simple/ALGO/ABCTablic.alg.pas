Program ABCTablic; 

Type 
   MojaTablica=array[1..10] of real; 
var 
   TabA,TabB:MojaTablica; 

Begin 
  TabA[1]:=10; {Przypisanie wartości elementu} 
  TabB:=TabA;   {Przypisanie całej tablicy – może wymagać żeby tablice były zadeklarowane za pomocą tego samego typu tablicowego a nie jak powyżej} 
  Writeln(TabB[1]); {Pobranie i wydrukowanie wartości elementu} 
End.
