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
  system.SysUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';

type
       range_str = string;

       range_rec= record
          a, b : cardinal;
       end;


type
       r_str_tuple =  UFP.tuple<range_str, range_str>;
       range_tuple =  UFP.tuple<range_rec, range_rec>;

const
       rng_nil  : range_rec = ();



function split_pairs( s:string ) : r_str_tuple;
begin
   var arr        := s.split( [','] );
       result.fst := arr[0];
       result.snd := arr[1];
end;


function make_range( rs:range_str ) : range_rec;
begin
   var arr      := rs.Split( ['-'] );
       result.a := arr[0].ToInteger;
       result.b := arr[1].ToInteger;
end;


function make_ranges( rst:r_str_tuple ) : range_tuple;
begin
       result.fst := make_range( rst.fst );
       result.snd := make_range( rst.snd );
end;


// predicates

function contained_in ( rt:range_tuple ) : boolean;
begin
       result := false;

       if (rt.snd.a <= rt.fst.a) and (rt.snd.b >= rt.fst.b) then exit( true );
       if (rt.fst.a <= rt.snd.a) and (rt.fst.b >= rt.snd.b) then exit( true );
end;


function brackets( r:Range_rec; i:cardinal ) : boolean;
begin
       if (r.a > i) or (r.b < i)  then exit( false )
                                  else exit( true )
end;


function overlap ( rt:range_tuple ) : boolean;
begin
       result := false;

       if brackets( rt.fst, rt.snd.a ) then exit( true );
       if brackets( rt.fst, rt.snd.b ) then exit( true );
       if brackets( rt.snd, rt.fst.a ) then exit( true );
       if brackets( rt.snd, rt.fst.b ) then exit( true );
end;



begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 4 Data.txt');


       // Part 1

   var rng_str_pairs := { Map (sl, split_pairs)              }    UFP.List_Map < r_str_tuple > (sl, split_pairs);

   var range_pairs   := { Map (rng_str_pairs, make_ranges)   }    UFP.List_Map < r_str_tuple, range_tuple > (rng_str_pairs, make_ranges);

   var contains      := { Filter (range_pairs, contained_in) }    UFP.List_Filter < range_tuple > (range_pairs, contained_in);

       writeln;
       writeln( 'Part 1 answer : ', contains.Count);


       // Part 2

   var overlaps      := { Filter (range_pairs, overlap)      }    UFP.List_Filter < range_tuple > (range_pairs, overlap);

       writeln;
       writeln( 'Part 2 answer : ', overlaps.Count);


       readln;
end.



//   for var x in overlaps do begin var s :=  x.fst.a.ToString + '-' + x.fst.b.ToString + ':' +
//                                            x.snd.a.ToString + '-' + x.snd.b.ToString;
//                                  write( s:20 );
//                            end;
//                            writeln;

