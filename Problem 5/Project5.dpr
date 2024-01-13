{$APPTYPE CONSOLE}
program Project5;
{
https://adventofcode.com/2022/day/5

They have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

In this example, there are three stacks of crates.
Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top.
Stack 2 contains three crates; from bottom to top, they are crates M, C, and D.
Stack 3 contains a single crate, P.

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2

                            [Z]                 [Z]                 [Z]
[D]                         [N]                 [N]                 [N]
[N] [C]                 [C] [D]         [M]     [D]                 [D]
[Z] [M] [P]             [M] [P]         [C]     [P]         [C] [M] [P]
 1   2   3           1   2   3           1   2   3           1   2   3

Initial stack configuration :

1  L N W T D
2  C P H
3  W P H N D G M J
4  C W S N T Q L
5  P H C N
6  T H N D M W Q B
7  M B R J G S L
8  Z N W G V B R T
9  W G D N P L

PART 1
After the rearrangement procedure completes, what crate ends up on top of each stack?

PART 2
Instead the crane lifts all crates at the same time, and places them down in the same order.
}

uses
  system.Classes,
  system.SysUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';

const
       Num_stacks = 9;

       Crate_stack : array [1..Num_stacks] of TArray<Char> =          (

                            ['L', 'N', 'W', 'T', 'D'               ],
                            ['C', 'P', 'H'                         ],
                            ['W', 'P', 'H', 'N', 'D', 'G', 'M', 'J'],
                            ['C', 'W', 'S', 'N', 'T', 'Q', 'L'     ],
                            ['P', 'H', 'C', 'N'                    ],
                            ['T', 'H', 'N', 'D', 'M', 'W', 'Q', 'B'],
                            ['M', 'B', 'R', 'J', 'G', 'S', 'L'     ],
                            ['Z', 'N', 'W', 'G', 'V', 'B', 'R', 'T'],
                            ['W', 'G', 'D', 'N', 'P', 'L'          ]
                                                                        );

type
  Stacks_type = array [1..Num_stacks] of TStack<char>;


procedure initialise_stacks( var St : Stacks_type );
begin
       for var i in [1..Num_stacks] do
       begin
             St[i]  := TStack<Char>.Create;
             for var ch in crate_stack[i]  do  St[i].Push(ch);
       end;
end;


procedure st_move( n:cardinal; var st1, st2 : TStack<Char> );
begin
       for var i := 1 to n do st2.Push( st1.Pop )
end;


procedure st_move2( n:cardinal; var st1, st2 : TStack<Char> );
begin
  var  st3 := TStack<Char>.Create;

       for var i := 1 to n do st3.Push( st1.Pop );
       for var i := 1 to n do st2.Push( st3.Pop );

       st3.Free;
end;



begin

       // Preliminaries

   var lines        : string;
   var a            : TArray<string>;
   var n, from, to_ : integer;
   var St, St2      : Stacks_type;

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 5 Data.txt');


       // Part 1

       initialise_stacks( St );

       for lines in sl do
       begin
              a    := lines.Split( [' '] );                            // 'move 1 from 2 to 1'   ->  ['move','1','from','2','to','1']
              n    := a[1].ToInteger;                                  //
              from := a[3].ToInteger;                                  //                        ->  ( 1, 2, 1 )
              to_  := a[5].ToInteger;                                  //

              st_move( n, st[ from ] , st[ to_ ] );                    //  ( st, tuple )      ->   stack movement
       end;

       write( 'Part 1 answer : ' );
       for var i in [1..Num_stacks] do  write( St[i].Peek, ' ' );
       writeln;
       writeln;


       // Part 2

       initialise_stacks( St2 );

       for lines in sl do
       begin
              a    := lines.Split( [' '] );
              n    := a[1].ToInteger;
              from := a[3].ToInteger;
              to_  := a[5].ToInteger;

              st_move2( n, st2[ from ] , st2[ to_ ] );

           // st_move2( st2, process(lines) );

       end;

       write( 'Part 2 answer : ' );
       for var i in [1..Num_stacks] do  write( St2[i].Peek, ' ' );
       writeln;


       readln;

   {   Part 1 answer : T W S G Q H N H L

       Part 2 answer : J N R S C D W P P    }
end.




