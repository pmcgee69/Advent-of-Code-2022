{$APPTYPE CONSOLE}
program Project7;
{
https://adventofcode.com/2022/day/7

The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files).
The outermost directory is called /.

Within the terminal output, lines that begin with $ are commands you executed.

  cd     means change directory. This changes which directory is the current directory, but the specific result depends on the argument:
  cd x   moves in one level: it looks in the current directory for the directory named x and makes it the current directory.
  cd ..  moves out one level: it finds the directory that contains the current directory, then makes that directory the current directory.
  cd /   switches the current directory to the outermost directory, /.

  ls     means list. It prints out all of the files and directories immediately contained by the current directory:
         123 abc means that the current directory contains a file named abc with size 123.
         dir xyz means that the current directory contains a directory named xyz.

Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

- / (dir)
     - a (dir)
         - e (dir)
             - i (file, size=584)
         - f     (file, size=29116)
         - g     (file, size=2557)
         - h.lst (file, size=62596)
     - b.txt (file, size=14848514)
     - c.dat (file, size=8504156)
     - d     (dir)
         - j     (file, size=4060174)
         - d.log (file, size=8033020)
         - d.ext (file, size=5626152)
         - k     (file, size=7214296)


$ cd /
$ ls
  dir a
  14848514 b.txt
  8504156  c.dat
  dir d

$ cd a
$ ls
  dir e
  29116    f
  2557     g
  62596    h.lst

$ cd e
$ ls
  584      i

$ cd ..
$ cd ..
$ cd d
$ ls
  4060174  j
  8033020  d.log
  5626152  d.ext
  7214296  k
}

// Planning
//
//   data structure ...   Dict < string, record >   ...   Size.  List of (file, size) .  List of string.   Parent.
//
//   finite state machine :   cd  - add ?  move current
//                        :   ls  - add dirs or files
//

uses
  system.Classes,
  system.SysUtils,
  generics.Collections,
  U_dir_types in 'U_dir_types.pas';

type
       Line_mode = (input, output);


       // main

begin

       // Preliminaries

   var sl := TStringList.create;
       sl.LoadFromFile('..\..\Prob 7 Data.txt');

       // Part 1

// var dirs        := TDirs_type.Create;
//     root        := make_root;
//     register_root( dirs );
   var mode        := input;
   var current_dir := root;
   var parent_dir  := root;

{
       writeln(root.file_size);
       root.file_size := 100;
       writeln(root.file_size);
   var x : TDir_record;
   var k := '/-'+'/-'+root.dir_id.ToString;
       dirs.Items[k] := root;
       dirs.TryGetValue( k, x);
       writeln(x.file_size);
}
       for var s in sl do begin

           var text := s.Split( [' '] );                       //  $ cd place   or   $ ls
                                                               //  dir xyz      or   ddddd filename
               if text[0]='$' then mode := input
                              else mode := output;

               case mode of
                    input :   if text[1]='cd'  then  process_cd  ( dirs, current_dir, parent_dir, text[2] );

                    output :  if text[0]='dir' then  process_dir ( dirs, current_dir, text[1] )
                                               else  process_file( dirs, current_dir, text[1], text[0].ToInteger );
               end;
       end;


       writeln;

       for var dir in dirs do  writeln( dir.Value.file_size );




       // Part 2


       writeln;


       readln;

   {   Part 1 answer :  _

       Part 2 answer :  _  }
end.

  //TSub_dirs = TList<string>;

{

$ cd /
$ ls
dir hdwsmn
dir lmlsvqsw
dir rlfgcqz
dir sjq
dir tpnspw
$ cd hdwsmn
$ ls
dir mrrqnc
dir qst
dir rlfgcqz
$ cd mrrqnc
$ ls
227398 rwhw
$ cd ..
$ cd qst
$ ls
152795 bblss.hnl
dir lvs
$ cd lvs
$ ls
81813 jwvtjgjb.sss
$ cd ..

}

