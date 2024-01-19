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
       parent    : string;
       file_size : cardinal;
       files     : TList<TFile_tuple>;
       subdirs   : TList<string>;
       constructor create( name_, parent_:string );
       function    add_dir ( s:string )      : boolean;
       function    add_file( f:TFile_tuple ) : boolean;
  end;

  TDirs_type = TDictionary< string, TDir_record >;


procedure process_cd  ( const dirs:tdirs_type; var cur_dir, par_dir, cmd:string );
procedure process_dir (       dirs:tdirs_type; var cur_dir, par_dir, new:string );
procedure process_file(       dirs:tdirs_type;     cur_dir:string; siz:integer; fn:string   );



implementation

type
  Tkey_str = string;


       // record methods

  constructor TFile_tuple.create( name:string; fs:cardinal );
  begin
       filename := name;
       filesize := fs;
  end;


  constructor TDir_record.create( name_,parent_:string );
  begin
       name      := name_;
       parent    := parent_;
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

function match_parent_dir( const dirs:tdirs_type; cur_rec,par_rec:TDir_record; var old_cur_dir, old_par_dir:string ) : boolean;
begin
       if (cur_rec.name = old_par_dir) and
           cur_rec.subdirs.Contains(old_cur_dir) then
           begin
                 old_cur_dir := cur_rec.name;
                 old_par_dir := par_rec.name;
                 exit(True);
           end
       else
           for var sub in cur_rec.subdirs do
           begin
             var sub_rec : TDir_record;
             var key := cur_rec.name + '-' + sub;
                 dirs.TryGetValue( key, sub_rec);
                 if match_parent_dir( dirs, sub_rec, cur_rec, old_cur_dir, old_par_dir) then exit(True);
           end;
       exit(false);
end;


procedure move_to_parent_dir( const dirs:tdirs_type; var old_cur_dir, old_par_dir:string );
begin
   var root_rec:  TDir_record;
       dirs.TryGetValue( '/-/', root_rec);
   var par_rec := root_rec;
   var cur_rec := root_rec;

       if not match_parent_dir( dirs, cur_rec, par_rec, old_cur_dir, old_par_dir) then
          writeln('Move to parent - error.');
end;



procedure add_to_dir( var dirs:tdirs_type; cur_dir, par_dir, new:string );
begin
   var key := cur_dir + '-' + new;
       dirs.Add(key, Tdir_record.create(new, cur_dir))
end;




procedure process_cd( const dirs:tdirs_type; var cur_dir,                      // there are non-unique directory names at different points in the tree
                                                 par_dir, cmd:string );        // $ cd place   or   $ ls
begin
   var {}cd := cur_dir;

   var     key := par_dir + '-' + cur_dir;
   var dir_rec : TDir_record;

       dirs.TryGetValue( key, dir_rec);

       if cmd = cur_dir then exit;
       if cmd = '..'    then begin
                             move_to_parent_dir(dirs, cur_dir, par_dir)
                        end
                        else begin
                             par_dir := cur_dir;
                             cur_dir := cmd;
                        end;

       {}writeln(#13#10+cmd+#13#10, ' : ',cd, '  ->  ', cur_dir);
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
