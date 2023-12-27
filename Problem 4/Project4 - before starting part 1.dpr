{$APPTYPE CONSOLE}
program Project4;
{
https://adventofcode.com/2022/day/4

For example, consider the following list of section assignment pairs:

2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8

For the first few pairs, this list means:

    Within the first pair of Elves, the first Elf was assigned sections 2-4 (sections 2, 3, and 4), while the second Elf was assigned sections 6-8 (sections 6, 7, 8).
    The Elves in the second pair were each assigned two sections.
    The Elves in the third pair were each assigned three sections: one got sections 5, 6, and 7, while the other also got 7, plus 8 and 9.

This example list uses single-digit section IDs to make it easier to draw; your actual list might contain larger numbers. Visually, these pairs of section assignments look like this:

.234.....  2-4
.....678.  6-8

.23......  2-3
...45....  4-5

....567..  5-7
......789  7-9

.2345678.  2-8
..34567..  3-7

.....6...  6-6
...456...  4-6

.23456...  2-6
...45678.  4-8

Some of the pairs have noticed that one of their assignments fully contains the other. For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6. In pairs where one assignment fully contains the other, one Elf in the pair would be exclusively cleaning sections their partner will already be cleaning, so these seem like the most in need of reconsideration. In this example, there are 2 such pairs.

In how many assignment pairs does one range fully contain the other?
}

uses
  system.Classes,
  system.StrUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';

type
  range_str = string;

  range_rec= record
     a, b : cardinal;
  end;


type
  res_type  =  UFP.tuple <string, string>;
  range_tup =  UFP.tuple<range_rec, range_rec>;

const
  rng_nil  : range_rec = ();



//function transform_to_tuple( s:string ) : res_type;
//begin
//   var      l := length(s) div 2;
//   result.fst :=  leftstr(s,l);
//   result.sec := rightstr(s,l);
//end;



begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 3 Data.txt');


       // Part 1

   

 (*
   var rucksacks :=  { Map (sl, transform_to_tuple) }    UFP.List_Map < res_type > (sl, transform_to_tuple );

   var common    :=  { Map (rucksacks, find_common) }    UFP.List_Map <res_type, char>  (rucksacks, find_common);

       writeln;
       writeln( 'Part 1 answer : ', total1);


       // Part 2

   var triples  :=   { GroupBy triples (sl)         }    group_by_triples( sl );

   var common2  :=   { Map (triples, find_common2)  }    UFP.List_Map <tri_type, char>  (triples, find_common2);

       writeln;
       writeln( 'Part 2 answer : ', total2);
*)

       readln;
end.

