unit U_dir_types;

interface
uses generics.Collections, Xml.XMLDoc, Xml.XMLIntf;

type
  TFile_tuple = record
       filename : string;
       filesize : cardinal;
       constructor create( name:string; fs:cardinal );
  end;

  TSubdir_tuple = record
       sub_name : string;
       sub_guid : TGuid;
       constructor create( name:string );                overload;
       constructor create( name:string; guid:TGuid );    overload;
  end;


  TDir_record = record
    private
       guid,
       par_guid  : TGuid;
    public
       name,
       parent    : string;
       file_size : cardinal;
       files     : TList<TFile_tuple>;
       subdirs   : TList<TSubdir_tuple>;
       constructor create( name_, parent_:string; par_guid_:TGuid );
       function    contains_dir ( s:string )      : boolean;
       function    add_file     ( f:TFile_tuple ) : boolean;
     //property    dir_id : TGuid read guid;
  end;

  TDirs_type = TDictionary< string, TDir_record >;


function  make_root : TDir_record;
procedure register_root( dirs:TDirs_type );

procedure process_cd  ( const dirs:tdirs_type; var cur_rec, par_rec:TDir_record;   cmd:string );
procedure process_dir ( var   dirs:tdirs_type;          var cur_rec:TDir_record;   new:string );
procedure process_file( var   dirs:tdirs_type;          var cur_rec:TDir_record; fname:string; fsize:integer );

var
  root : TDir_record;
  dirs : TDirs_type;


implementation
uses System.SysUtils;

type
  Tkey_str = string;


       // record methods

  constructor TFile_tuple.create( name:string; fs:cardinal );
  begin
       filename := name;
       filesize := fs;
  end;


  constructor TSubdir_tuple.create( name:string );
  begin
       sub_name := name;
       CreateGuid(sub_guid);
  end;


  constructor TSubdir_tuple.create( name:string; guid:TGuid );
  begin
       sub_name := name;
       sub_guid := guid;
  end;


  constructor TDir_record.create( name_,parent_:string; par_guid_:TGuid );
  begin
       name      := name_;
       parent    := parent_;
       file_size := 0;
       files     := TList<TFile_tuple>.Create;
       subdirs   := TList<TSubdir_tuple>.Create;
     //guid      := TGuid.Empty;
       par_guid  := par_guid_;
       CreateGUID(guid);
  end;


  function TDir_record.contains_dir( s:string ): boolean;
  begin
       result := false;
       for var sd in subdirs do
           if sd.sub_name = s then exit(true);
  end;


  function TDir_record.add_file( f:TFile_tuple ): boolean;
  begin
       result := true;
       if not files.Contains(f)   then begin
                                         files.Add(f);
                                         file_size := file_size + f.filesize;
                                       end
                                  else result := false;
  end;


       // make key

  function make_key( a,b,c:string ):string;                            overload;
  begin
        result := a+'-'+b+'-'+c;
  end;

  function  make_key( parent,child:Tdir_record ): string;              overload;
  begin
        result := parent.name+'-'+child.name+'-'+child.guid.ToString;
  end;


       // root

  function make_root : TDir_record;
  begin
        result := TDir_record.create( '/', '/', TGuid.Empty);
        result.par_guid := result.guid;
  end;

  procedure register_root( dirs:TDirs_type );
  begin
        dirs.Add ( make_key('/','/',root.guid.ToString), root );
  end;


       // functions

function match_parent_dir( const dirs:tdirs_type; var seek_rec_c, seek_rec_p : TDir_record;
                                                  const  cur_rec,    par_rec : TDir_record ) : boolean;
var
   sub_rec : TDir_record;
begin
   var cur_sub := Tsubdir_tuple.create( cur_rec.name, cur_rec.guid );
       if (seek_rec_c.name = par_rec.name) and
          (seek_rec_c.guid = par_rec.guid) then
                        exit(True)
       else
          for var sub in seek_rec_c.subdirs do
            begin
              var key := make_key( seek_rec_c.name, sub.sub_name, sub.sub_guid.ToString );
                  dirs.TryGetValue( key, sub_rec);
                  if match_parent_dir( dirs, sub_rec, seek_rec_c, cur_rec, par_rec) then
                     begin
                        seek_rec_p := seek_rec_c;
                        seek_rec_c := sub_rec;
                        exit(True);
                     end;
            end;
       exit(false);
end;


procedure move_to_parent_dir( const dirs:tdirs_type; var cur_rec, par_rec:TDir_record );
begin
   var seek_rec_p := root;
   var seek_rec_c := root;

       if match_parent_dir( dirs, seek_rec_c, seek_rec_p, cur_rec, par_rec)
       then
          begin
              cur_rec := seek_rec_c;
              par_rec := seek_rec_p;
          end
       else
          writeln('Move to parent - error.');
end;


procedure process_cd( const dirs:tdirs_type; var cur_rec,par_rec:TDir_record; cmd:string );          // there are non-unique directory names at different points in the tree
begin                                                                                                // $ cd place   or   $ ls
   var {}cd := cur_rec.name;

       if cmd = cd      then exit;
       if cmd = '..'    then begin
                             move_to_parent_dir(dirs, cur_rec, par_rec)
                        end
                        else begin
                             par_rec := cur_rec;
                             for var sub in cur_rec.subdirs do
                                  if sub.sub_name = cmd then
                                     begin
                                     var key := make_key( cur_rec.name, sub.sub_name, sub.sub_guid.ToString);
                                         dirs.TryGetValue( key, cur_rec);
                                         break;
                                     end;
                        end;

       {}writeln(#13#10+cmd+#13#10, ' : ',cd, '  ->  ', cur_rec.name);
end;




procedure process_dir( var dirs:tdirs_type; var cur_rec:TDir_record; new:string);                        // dir xyz
begin
       if not cur_rec.contains_dir( new ) then
               begin
                 var sub_rec := Tdir_record.create(new, cur_rec.name, cur_rec.guid);

                 var key     := make_key( cur_rec, sub_rec);
                 var sub     := TSubdir_tuple.create( sub_rec.name, sub_rec.guid );

                     dirs.Add(key, sub_rec);
                     cur_rec.subdirs.Add( sub );
               end;

       writeln('add dir : ', new);
end;


procedure process_file( var dirs:tdirs_type; var cur_rec:TDir_record; fname:string; fsize:integer);      // ddddd filename
begin
       cur_rec.add_file( TFile_tuple.create(fname, fsize) );

       writeln('add file : ', fname, ' : ', fsize);
end;


initialization

       dirs        := TDirs_type.Create;
       root        := make_root;
       register_root( dirs );

end.
