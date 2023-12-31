﻿{$APPTYPE CONSOLE}
program Project3;
{
https://adventofcode.com/2022/day/3

For example, suppose you have the following list of contents from six rucksacks:

vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw

    The first rucksack contains the items vJrwpWtwJgWrhcsFMMfFFhFp, which means its first compartment contains the items vJrwpWtwJgWr, while the second compartment contains the items hcsFMMfFFhFp. The only item type that appears in both compartments is lowercase p.
    The second rucksack's compartments contain jqHRNqRjqzjGDLGL and rsFMfFZSrLrFZsSL. The only item type that appears in both compartments is uppercase L.
    The third rucksack's compartments contain PmmdzqPrV and vPwwTWBwg; the only common item type is uppercase P.
    The fourth rucksack's compartments only share item type v.
    The fifth rucksack's compartments only share item type t.
    The sixth rucksack's compartments only share item type s.

To help prioritize item rearrangement, every item type can be converted to a priority:

    Lowercase item types a through z have priorities 1 through 26.
    Uppercase item types A through Z have priorities 27 through 52.

In the above example, the priority of the item type that appears in both compartments of each rucksack is 16 (p), 38 (L), 42 (P), 22 (v), 20 (t), and 19 (s); the sum of these is 157.

Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?
}

uses
  system.Classes,
  system.StrUtils,
  system.SysUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';

type
  alpha1 = 'a'..'z';
  alpha2 = 'A'..'Z';

  items  = set of char;

const
  Val_1 : array [alpha1] of integer = ( 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26);
  Val_2 : array [alpha2] of integer = (27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52);


type
  res_type =  UFP.tuple <string, string>;
  tri_type =  UFP.triple<string, string, string>;

const
  tri_nil  : tri_type = ();



function transform_to_tuple( s:string ) : res_type;
begin
   var      l := length(s) div 2;
   result.fst :=  leftstr(s,l);
   result.snd := rightstr(s,l);
end;


function find_common( r:res_type ) : char;
var left : items;
begin
   left := [];
   result := '*';
   for var ch in r.fst do  left := left + [ch];
   for var ch in r.snd do  if ch in left then result := ch;
end;



function group_by_triples( sl:TStringlist ) : TList< tri_type >;
begin
   result := TList< tri_type >.Create;
   var i := 0;
   while i < sl.Count do begin
       var t:tri_type := tri_nil;
           t.fst      := sl[i];   inc(i);
           t.snd      := sl[i];   inc(i);
           t.thd      := sl[i];   inc(i);
       result.Add(t);
   end;
end;


function find_common2( t:tri_type ) : char;
var left, mid : items;
          ch  : char;
begin
   left := [];
   mid  := [];
   result := '*';
   for ch in t.fst do  left := left + [ch];
   for ch in t.snd do  if ch in left then mid    := mid + [ch];
   for ch in t.thd do  if ch in mid  then result := ch;
end;



function calc_priority( ch:char ) : integer;
begin
  if ch > 'Z' then result := val_1[ch]        // lowercase
              else result := val_2[ch]        // uppercase
end;



begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 3 Data.txt');


       // Part 1    -  the shortest way

   var priority  :=  { Map (  sl,   calc_priority ⃝ find_common ⃝ transform_to_tuple  ) }

                       UFP.List_Map < integer > ( sl,   UFP.Compose3                <string, res_type, char, integer>
                                                          ( transform_to_tuple,   // string   -> res_type
                                                            find_common,          // res_type -> char
                                                            calc_priority )       // char     -> integer
                                                );

   var total1    :=  { Reduce (priority, Sum)       }

                     UFP.List_Reduce<integer> ( priority, Sum );

       writeln;
       writeln( 'Part 1 answer : ', total1);


       // Part 2

   var triples  :=   { GroupBy triples (sl)         } group_by_triples( sl );

       priority :=   { Map (  triples,   calc_priority ⃝ find_common2  ) }

                     UFP.List_Map <tri_type, integer>
                                  ( triples,          UFP.Compose               <tri_type, char, integer>
                                                         ( find_common2,      // tri_type -> char
                                                           calc_priority )    // char
                                  );

   var total2   :=   { Reduce (priority, Sum)       }

                     UFP.List_Reduce<integer> ( priority, Sum );

       writeln;
       writeln( 'Part 2 answer : ', total2);


       readln;
end.


// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

writeln(' Part 1 in 3 steps ')

(*
   var rucksacks :=  { Map (sl, transform_to_tuple) }    UFP.List_Map < res_type > (sl, transform_to_tuple );

   var common    :=  { Map (rucksacks, find_common) }    UFP.List_Map <res_type, char>  (rucksacks, find_common);

   var priority  :=  { Map (common, calc_priority)  }    UFP.List_Map <char, integer>   (common, calc_priority );
*)


writeln(' Part 1 explicitly defining a triple composition of functions ')

(*
   var fn        :=  UFP.Compose3                        <string, res_type, char, integer>  (
                            transform_to_tuple,
                            find_common,
                            calc_priority );

   var priority  :=  UFP.List_Map < integer > (sl,  fn  );
*)


writeln(' Part 1 partially applying the generic functions first ')
(*
   var map_fn := function ( sl: tstringlist; f : TFunc<string,integer> ) : TList <Integer>
                 begin
                   result := UFP.List_Map< integer > ( sl, f )
                 end;

   var comp3  := function ( f : TFunc< string  , res_type >;
                            g : TFunc< res_type, char     >;
                            h : TFunc< char    , integer  > ) : TFunc <string, integer>
                 begin
                   result :=   UFP.Compose3 <string, res_type, char, integer>  (f,g,h);
                 end;


   var priority  :=  { Map (  sl,   calc_priority ⃝ find_common ⃝ transform_to_tuple  ) }

                       map_fn( sl, comp3( transform_to_tuple,  find_common,  calc_priority ) );
*)





// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

writeln(' Part 2 in 2 steps')

(*
   var common2  :=   { Map (triples, find_common2)  }    UFP.List_Map <tri_type, char>  (triples, find_common2);

       priority :=   { Map (common2, calc_priority) }    UFP.List_Map <char, integer>   (common2, calc_priority );
*)


writeln(' Part 2 explicitly defining a composition of functions')

(*
   var fn       :=   UFP.Compose               <tri_type, char, integer> (
                            find_common2,
                            calc_priority );

       priority :=   UFP.List_Map <tri_type, integer> (triples, fn);
*)


// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

