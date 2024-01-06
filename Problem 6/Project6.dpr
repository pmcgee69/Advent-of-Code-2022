{$APPTYPE CONSOLE}
program Project6;
{
https://adventofcode.com/2022/day/6

The device will send your subroutine a datastream buffer (your puzzle input);
your subroutine needs to identify the first position where the four most recently received characters were all different.
Specifically, it needs to report the number of characters from the beginning of the buffer to the end of the first such four-character marker.

For example, suppose you receive the following datastream buffer:

mjqjpqmgbljsphdztnvjfqwrcgsmlb

The first time a marker appears is after the seventh character arrives.
Once it does, the last four characters received are jpqm, which are all different.
In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.

       Here are a few more examples:

       bvwbjplbgvbhsrlpgdmjqwftvncz      : first marker after character 5
       nppdvjthqldpwncqszvftbrmjlhg      : first marker after character 6
       nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg : first marker after character 10
       zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw  : first marker after character 11


PART 1
How many characters need to be processed before the first start-of-packet marker is detected?


A start-of-message marker is just like a start-of-packet marker, except it consists of 14 distinct characters rather than 4.

Here are the first positions of start-of-message markers for all of the above examples:

       mjqjpqmgbljsphdztnvjfqwrcgsmlb    : first marker after character 19
       bvwbjplbgvbhsrlpgdmjqwftvncz      : first marker after character 23
       nppdvjthqldpwncqszvftbrmjlhg      : first marker after character 23
       nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg : first marker after character 29
       zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw  : first marker after character 26

PART 2
How many characters need to be processed before the first start-of-message marker is detected?
}

uses
  system.Classes,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';



function check_window( window_size:integer; s:string; i:integer ) : boolean; inline;
begin
      if i < window_size then exit( false );

      result := true;                                          //     1  2  3  4
  var start := i - window_size +1;                             //   1 x  .  .  .
                                                               //   2    x  .  .
      for var j := start to i-1 do                             //   3       x  .
          for var k := j+1 to i do                             //   4          x
              if  s[j] = s[k] then exit( false );
end;


function check_window_4( s:string; i:integer ) : boolean;      // Partial Application of check_window function
begin
      result := check_window(4, s ,i)
end;


function check_window_14( s:string; i:integer ) : boolean;
begin
      result := check_window(14, s ,i)
end;


begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 6 Data.txt');


       // Part 1

   var windows := UFP.String_Map<Boolean>( sl.Text, check_window_4 );

       for var i := 1 to windows.Count do

           if windows[i-1] then begin writeln(i:6); break end;

       writeln;


       // Part 2

       windows := UFP.String_Map<Boolean>( sl.Text, check_window_14 );

       for var i := 1 to windows.Count do

           if windows[i-1] then begin writeln(i:6); break end;

       writeln;



       readln;

   {   Part 1 answer :  1134

       Part 2 answer :  2263  }
end.


{
       windows := UFP.String_Map<Boolean>( 'bvwbjplbgvbhsrlpgdmjqwftvncz',      check_window_4  );
       windows := UFP.String_Map<Boolean>( 'nppdvjthqldpwncqszvftbrmjlhg',      check_window_4  );
       windows := UFP.String_Map<Boolean>( 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', check_window_14 );
       windows := UFP.String_Map<Boolean>( 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',  check_window_14 );
}


