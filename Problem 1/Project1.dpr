{$APPTYPE CONSOLE}
program Project1;

{
One important consideration is food - in particular, the number of Calories each Elf is carrying (your puzzle input).
The Elves take turns writing down the number of Calories contained by the various meals, snacks, rations, etc. that they've brought with them, one item per line.
Each Elf separates their own inventory from the previous Elf's inventory (if any) by a blank line.

For example, suppose the Elves finish writing their items' Calories and end up with the following list:

1000
2000
3000

4000

5000
6000

7000
8000
9000

10000

This list represents the Calories of the food carried by five Elves:

    The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
    The second Elf is carrying one food item with 4000 Calories.
    The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
    The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
    The fifth Elf is carrying one food item with 10000 Calories.

In case the Elves get hungry and need extra snacks, they need to know which Elf to ask:
 - they'd like to know how many Calories are being carried by the Elf carrying the most Calories.
In the example above, this is 24000 (carried by the fourth Elf).

Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
}

uses
  System.SysUtils,
  system.Classes,
  generics.Collections,
  U_Utils_Functional in 'U_Utils_Functional.pas';

   //spring.container;


  function IntToStr ( s  :string ) : integer;   begin  exit( s.ToInteger ) end;

  function Sum      ( i,j:integer) : integer;   begin  exit( i+j )         end;

  function Max      ( i,j:integer) : integer;   begin  if i<j then exit(j) else exit(i)  end;



begin

   // Preliminaries

   var sl := TStringList.create;
       sl.LineBreak := #13+#10+#13+#10;
       sl.LoadFromFile('..\..\Prob 1 Data.txt');


   var A := TList< TStringList >.Create;                           //
       for var s in sl do begin                                    //   List of stringlists
           var sl_ := TStringList.Create;                          //
               sl_.AddStrings( s.Split( [#13+#10] ) );             //
               A.Add(sl_);                                         //
       end;                                                        //


   var B := TList< TList<Integer> >.Create;                        //
       for var a_ in A do                                          //   list of List<integer>
           B.Add(   UFP.List_Map<integer> ( a_, IntToStr )  );     //


  // Part 1

   var C := TList< integer >.Create;                               //
       for var b_ in B do                                          //    List of integer
           C.add(   UFP.List_Reduce<integer> ( b_, Sum )    );     //

   writeln;
   writeln(         UFP.List_Reduce<integer> ( C, Max )  );        //  max list entry
   writeln;


  // Part 2

   C.Sort;
   begin
        var tot := 0;
        for var i:= C.Count-1 downto C.Count-3 do begin            // top 3 entries
            writeln( C[i] );
            tot := tot + C[i];
        end;
        writeln( tot );
   end;


{
   for var i in C do begin
       write(i:8);
//       for var x in B[i].ToArray do write(x,',');
//       writeln;
//       writeln(A[i].commatext, ',');
//       writeln(sl[i]);
   end;
   writeln;
}
   readln;
end.
