{$APPTYPE CONSOLE}
program Project2;

{
Suppose you were given the following strategy guide:

A Y
B X
C Z

This strategy guide predicts and recommends the following:

    In the first round, your opponent will choose Rock (A), and you should choose Paper (Y).
    This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).

    In the second round, your opponent will choose Paper (B), and you should choose Rock (X).
    This ends in a loss for you with a score of 1 (1 + 0).

    The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.

    In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

What would your total score be if everything goes exactly according to your strategy guide?
}


uses
  system.Classes,
  system.StrUtils,
  U_Utils_Functional in '..\U_Utils_Functional.pas';


type

  opp = (A,B,C);                    // rock, paper, scissors : 1, 2, 3
  we  = (X,Y,Z);

var
  Val_opp : array [opp] of integer = (1,2,3);
  Val_we  : array [we ] of integer = (1,2,3);

type
  res_type    =  UFP.tuple<integer,integer>;



function transform_to_tuple( s:string ) : res_type;
begin
  case ord(s[1]) of
       ord('A') : result.fst := Val_opp[A];
       ord('B') : result.fst := Val_opp[B];
       ord('C') : result.fst := Val_opp[C];
  end;
  case ord(s[3]) of
       ord('X') : result.sec := Val_we [X];
       ord('Y') : result.sec := Val_we [Y];
       ord('Z') : result.sec := Val_we [Z];
  end;
end;


function score ( r:res_type ) : integer;
begin
   case (r.sec - r.fst) of             // same choice = draw,  "1 ahead" (mod 3) = win, "1 behind" (mod 3) = lose
          0 : result := 3;
       1,-2 : result := 6;
      -1, 2 : result := 0;
   end;
   result := result + r.sec;
end;


function myreaction( r:res_type ) : res_type;
var   we : integer;
begin
  case r.sec of
       1 : we := r.fst - 1;        // lose
       2 : we := r.fst;            // draw
       3 : we := r.fst + 1;        // win
  end;
  if we < 1  then  inc(we,3);      // mod 3
  if we > 3  then  dec(we,3);

  result.fst := r.fst;
  result.sec := we;
end;



begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 2 Data.txt');

   var elflist  :=  { Map (sl, transform_to_tuple) }    UFP.List_Map < res_type > (sl, transform_to_tuple );


       // Part 1

   var scores1  :=  { Map (elflist, score) }            UFP.List_Map < res_type, integer > (elflist, score );

   var total1   :=  { Reduce (scores1, Sum) }           UFP.List_Reduce<integer> ( scores1, Sum );

       writeln;
       writeln( 'Part 1 answer : ', total1);


       // Part 2

   var elflist2 :=  { Map (elflist, myreaction) }       UFP.List_Map < res_type, res_type > (elflist, myreaction );

   var scores2  :=  { Map (elflist2, score) }           UFP.List_Map < res_type, integer  > (elflist2, score );

   var total2   :=  { Reduce (scores2, Sum) }           UFP.List_Reduce<integer> ( scores2, Sum );

       writeln;
       writeln( 'Part 2 answer : ', total2);

       readln;
end.


