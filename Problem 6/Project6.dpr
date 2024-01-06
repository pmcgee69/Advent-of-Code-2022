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

PART 1
How many characters need to be processed before the first start-of-packet marker is detected?

PART 2

}

uses
  system.Classes,
  system.SysUtils,
  generics.Collections,
  U_Utils_Functional in '..\U_Utils_Functional.pas';

const
  window_size = 4;


function check_window( s:string; i:integer ) : boolean;
begin
      if i < window_size then exit( false );

      result := true;                                          //     1  2  3  4
  var start := i - window_size +1;                             //   1 x  .  .  .
                                                               //   2    x  .  .
      for var j := start to i-1 do                             //   3       x  .
          for var k := j+1 to i do                             //   4          x
              if  s[j] = s[k] then exit( false );
end;


{
       Here are a few more examples:

       bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
       nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
       nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg : first marker after character 10
       zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw  : first marker after character 11

       windows := UFP.String_Map<Boolean>( 'bvwbjplbgvbhsrlpgdmjqwftvncz',      check_window );
       windows := UFP.String_Map<Boolean>( 'nppdvjthqldpwncqszvftbrmjlhg',      check_window );
       windows := UFP.String_Map<Boolean>( 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', check_window );
       windows := UFP.String_Map<Boolean>( 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',  check_window );
}
begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 6 Data.txt');

       // Part 1

   var windows := UFP.String_Map<Boolean>( sl.Text, check_window );

       for var i := 1 to windows.Count do

           if windows[i-1] then write(i:6);

       writeln;


       // Part 2




       readln;

   {   Part 1 answer :

       Part 2 answer :    }
end.




