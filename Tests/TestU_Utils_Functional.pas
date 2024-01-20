unit TestU_Utils_Functional;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework,
  generics.Collections,
  system.classes,
  system.sysutils,
  U_Utils_Functional_Copy;

type
  // Test methods for class UFP

  TestUFP = class(TTestCase)
  published
    procedure TestList_Map;
    procedure TestList_Map1;
    procedure TestList_Reduce;
    procedure TestList_Filter;
    procedure TestCompose;
    procedure TestCompose3;
    procedure TestString_Map;
  end;

implementation


procedure TestUFP.TestList_Map;
var
  f  : TFunc<string,integer>;
begin
  var L := TStringList.Create;
      L.CommaText := '123, 2';
      f := function (s:string):integer  begin exit( s.ToInteger ) end;

  var L2 := UFP.List_Map<integer>(L, f);

  var ReturnValue := ( L2[0] = 123 ) and ( L2[1] = 2 );

      L.Free;
      L2.Free;
end;


procedure TestUFP.TestList_Map1;
var
  f  : TFunc<integer,integer>;
begin
  var L := TList<Integer>.Create( [1,2,3,4] );
      f := function (x:integer):integer  begin exit( x*x ) end;

  var L2 := UFP.List_Map<integer,integer>(L, f);

  var ReturnValue := ( L2[0] =  1 ) and
                     ( L2[1] =  4 ) and
                     ( L2[2] =  9 ) and
                     ( L2[3] = 16 ) and ( L2.Count = 4 );
      L.Free;
      L2.Free;
end;


procedure TestUFP.TestString_Map;
var
  f  : TFunc<string,integer,string>;
begin
  var S := 'Balls';
      f := function (s:string; i:integer):string
              begin
                 if i=1 then exit( s[i] ) else exit( s[i-1]+s[i] )
              end;

  var L2 := UFP.String_Map<string>(S, f);

  var ReturnValue := ( L2[0] = 'B'  ) and
                     ( L2[1] = 'Ba' ) and
                     ( L2[2] = 'al' ) and
                     ( L2[3] = 'll' ) and
                     ( L2[4] = 'ls' ) and ( L2.Count = 5 );
      L2.Free;
end;


procedure TestUFP.TestList_Reduce;
var
  f  : TFunc<integer,integer,integer>;
begin
  var L := TList<Integer>.Create( [1,2,3,4] );
      f := function (x,y:integer):integer  begin exit( Max(x,y) ) end;

  var I := UFP.List_Reduce<integer>(L, f);

  var ReturnValue := ( I = 4 );

      L.Free;
end;


procedure TestUFP.TestList_Filter;
var
  f  : TPredicate<integer>;
begin
  var L := TList<Integer>.Create( [1,2,3,4] );
      f := function (x:integer):boolean  begin exit( x>2 ) end;

  var L2 := UFP.List_Filter<integer>(L, f);

  var ReturnValue := ( L2[0] = 3 ) and ( L2[1] = 4 ) and ( L2.Count = 2 );

      L.Free;
      L2.Free;
end;


procedure TestUFP.TestCompose;
var
  f  : TFunc<string, integer>;
  g  : TFunc<integer,integer>;
begin
  var L := TStringList.Create;
      L.CommaText := '1, 2, 3, 4';
      f := function (s:string) :integer  begin exit( s.ToInteger ) end;
      g := function (x:integer):integer  begin exit( x*x ) end;

  var fn:= UFP.Compose<string,integer,integer>(f,g);

  var L2 := UFP.List_Map<integer>( L, fn );

  var ReturnValue := ( L2[0] =  1 ) and
                     ( L2[1] =  4 ) and
                     ( L2[2] =  9 ) and
                     ( L2[3] = 16 ) and ( L2.Count = 4 );
      L.Free;
      L2.Free;
end;


procedure TestUFP.TestCompose3;
var
  f  : TFunc<string, integer>;
  g  : TFunc<integer,integer>;
  h  : TFunc<Integer,string >;
begin
  var L := TStringList.Create;
      L.CommaText := '1, 2, 3, 4';
      f := function (s:string) :integer  begin exit ( s.ToInteger ) end;
      g := function (x:integer):integer  begin exit ( x*x )         end;
      h := function (x:integer):string   begin exit ( x.ToString )  end;

  var fn:= UFP.Compose3<string,integer,integer,string>(f,g,h);

  var L2 := UFP.List_Map<string>( L, fn );

  var ReturnValue := ( L2[0] =  '1' ) and
                     ( L2[1] =  '4' ) and
                     ( L2[2] =  '9' ) and
                     ( L2[3] = '16' ) and ( L2.Count = 4 );
      L.Free;
      L2.Free;
end;



initialization
  // Register any test cases with the test runner
  RegisterTest(TestUFP.Suite);
end.

