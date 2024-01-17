unit U_dir_types;

interface
uses generics.Collections;

type
  TFile_tuple = record
       filename : string;
       filesize : cardinal;
       constructor create( name:string; fs:cardinal);
  end;

  TDir_record = record
       name,
       parent,
       parpar    : string;
       file_size : cardinal;
       files     : TList<TFile_tuple>;
       subdirs   : TList<string>;
       constructor create( name, parent, parpar:string );
       function    add_dir ( s:string )      : boolean;
       function    add_file( f:TFile_tuple ) : boolean;
  end;

  TDirs_type = TDictionary< string, TDir_record >;


procedure process_cd  ( dirs:tdirs_type; var cur_dir, par_dir, parpar_dir, cmd:string );
procedure process_dir ( dirs:tdirs_type; var cur_dir, par_dir, new:string );
procedure process_file( dirs:tdirs_type;     cur_dir:string; siz:integer; fn:string   );



implementation

type
  Tkey_str = string;

       // record methods

  constructor TFile_tuple.create( name:string; fs:cardinal );
  begin
       filename := name;
       filesize := fs;
  end;


  constructor TDir_record.create( name,parent,parpar:string );
  begin
       name      := name;
       parent    := parent;
       parpar    := parpar;
       file_size := 0;
       files     := TList<TFile_tuple>.Create;
       subdirs   := TList<string>.Create;
  end;

  function TDir_record.add_dir( s:string ): boolean;
  begin
       result := true;
       if not subdirs.Contains(s) then subdirs.Add(s)
                                  else result := false;
  end;

  function TDir_record.add_file( f:TFile_tuple ): boolean;
  begin
       result := true;
       if not files.Contains(f)   then files.Add(f)
                                  else result := false;
  end;



       // functions

procedure add_to_dir( var dirs:tdirs_type; cur_dir, par_dir, new:string);
begin
   var key := cur_dir + '-' + new;
       dirs.Add(key, Tdir_record.create(new, cur_dir, par_dir))
end;


procedure process_cd( dirs:tdirs_type; var cur_dir,                            // there are non-unique directory names at different points in the tree
                                           par_dir,
                                           parpar_dir, cmd:string );
begin                                                                          // $ cd place   or   $ ls
   var {}cd := cur_dir;

   var     key := par_dir + '-' + cur_dir;
   var dir_rec : TDir_record;

       dirs.TryGetValue( key, dir_rec);

       if cmd = cur_dir then exit;
       if cmd = '..'    then begin
                             cur_dir := par_dir;                              // should always be able to move up
                             par_dir := parpar_dir;
                          parpar_dir := '';                                   // * bug * really need to search down from root with this approach
                        end
                        else begin
                          parpar_dir := par_dir;
                             par_dir := cur_dir;
                             cur_dir := cmd;
                        end;

       {}writeln(cd, '  ->  ', cur_dir);
end;


procedure process_dir( dirs:tdirs_type; var cur_dir, par_dir, new:string); // dir xyz
begin
   var dir_rec : TDir_record;
   var key     : Tkey_str :=  par_dir + '-' + cur_dir;

       if dirs.TryGetValue(key, dir_rec) then
            if dir_rec.add_dir( new ) then
               add_to_dir(dirs, cur_dir, par_dir, new);

       writeln('add dir : ', new);
end;


procedure process_file( dirs:tdirs_type; cur_dir:string; siz:integer; fn:string   );     // ddddd filename
begin
   var dir_rec :  TDir_record;
   var      ft := TFile_tuple.create(fn, siz);

       if dirs.TryGetValue(cur_dir, dir_rec) then dir_rec.add_file( ft );

       writeln('add file : ', fn, ' : ', siz);
end;




end.
