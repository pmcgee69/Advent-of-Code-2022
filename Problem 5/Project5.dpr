{$APPTYPE CONSOLE}
program Project5;
{
https://adventofcode.com/2022/day/5



}

uses
  system.Classes,
  system.StrUtils,
  system.SysUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';
{
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
}





// predicates




begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 5 Data.txt');


       // Part 1

//   var rng_str_pairs := { Map (sl, split_pairs)              }    UFP.List_Map < r_str_tuple > (sl, split_pairs);
//
//   var range_pairs   := { Map (rng_str_pairs, make_ranges)   }    UFP.List_Map < r_str_tuple, range_tuple > (rng_str_pairs, make_ranges);
//
//   var contains      := { Filter (range_pairs, contained_in) }    UFP.List_Filter < range_tuple > (range_pairs, contained_in);

       writeln;
//       writeln( 'Part 1 answer : ', contains.Count);


       // Part 2

//   var overlaps      := { Filter (range_pairs, overlap)      }    UFP.List_Filter < range_tuple > (range_pairs, overlap);

       writeln;
//       writeln( 'Part 2 answer : ', overlaps.Count);


       readln;
end.



//   for var x in overlaps do begin var s :=  x.fst.a.ToString + '-' + x.fst.b.ToString + ':' +
//                                            x.snd.a.ToString + '-' + x.snd.b.ToString;
//                                  write( s:20 );
//                            end;
//                            writeln;

