unit Test_UFP_Tests_DUnitX;

interface

uses
  DUnitX.TestFramework;


type
  TResult = (resOK,resWarn,resError);
  TResultSet = set of TResult;

type
  [TestFixture]
  TestUFP = class
  public
//    [Setup]     procedure Setup;
//    [TearDown]  procedure TearDown;
//    [Test]      procedure Test1;

//    Test with TestCase Attribute to supply parameters.
//    [TestCase('C','InputA;[resWarn,resError]', ';')]
//             procedure TestList_Map1(Input:string; ExpectedResult: TResultSet);

    [Test]
    [TestCase('A1', '1,2,3,4,5,6;    1; 5; 6', ';')]
    [TestCase('A2',       '123,2;  123; 1; 2', ';')]
             procedure TestList_Map( commatext:string; firstval, n, nthval:integer );
    [Test]
    [TestCase('B',  '[1,2,3,4]', ';')]
             procedure TestList_Map1( Input:TArray<Integer> );
    [Test]
    [TestCase('C1', '[1,2,3,4];4', ';')]
    [TestCase('C2', '[9,2,0,7];9', ';')]
    [TestCase('C3', '[9,11,-1,23,0,16,0,0];23', ';')]
             procedure TestList_Reduce( Input:TArray<Integer>; _Max:integer );
    [Test]
             procedure TestList_Filter;
    [Test]
             procedure TestCompose;
    [Test]
             procedure TestCompose3;
    [Test]
             procedure TestString_Map;
  end;

implementation
uses
  generics.Collections,
  system.classes,
  system.sysutils,
  U_Utils_Functional;



procedure TestUFP.TestList_Map( commatext:string; firstval, n, nthval:integer );
var
  f  : TFunc<string,integer>;
begin
  var L := TStringList.Create;
      L.CommaText := commatext;
      f := function (s:string):integer  begin exit( s.ToInteger ) end;

  var L2 := UFP.List_Map<integer>(L, f);

  var ReturnValue := ( L2[0] = firstval ) and ( L2[n] = nthval );

      Assert.IsTrue( ReturnValue );
      L.Free;
      L2.Free;
end;


procedure TestUFP.TestList_Map1( Input:TArray<Integer> );           //  (Input:string; ExpectedResult: TResultSet);
var
  f  : TFunc<integer,integer>;
begin
  var L := TList<Integer>.Create( Input );                          //  [1,2,3,4] );
      f := function (x:integer):integer  begin exit( x*x ) end;

  var L2 := UFP.List_Map<integer,integer>(L, f);

  var ReturnValue := ( L2[0] =  1 ) and
                     ( L2[1] =  4 ) and
                     ( L2[2] =  9 ) and
                     ( L2[3] = 16 ) and ( L2.Count = 4 );
      Assert.IsTrue( ReturnValue );
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
      Assert.IsTrue( ReturnValue );
      L2.Free;
end;


procedure TestUFP.TestList_Reduce( Input:TArray<Integer>; _Max:integer );
var
  f  : TFunc<integer,integer,integer>;
begin
  var L := TList<Integer>.Create( Input );
      f := function (x,y:integer):integer  begin exit( Max(x,y) ) end;

  var ReturnValue := UFP.List_Reduce<integer>(L, f);

      Assert.AreEqual( ReturnValue, _Max );
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

      Assert.IsTrue( ReturnValue );
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
      Assert.IsTrue( ReturnValue );
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
      g := function (x:integer):integer  begin exit (     x*x     ) end;
      h := function (x:integer):string   begin exit ( x.ToString  ) end;

  var fn:= UFP.Compose3<string,integer,integer,string>(f,g,h);

  var L2 := UFP.List_Map<string>( L, fn );

  var ReturnValue := ( L2[0] =  '1' ) and
                     ( L2[1] =  '4' ) and
                     ( L2[2] =  '9' ) and
                     ( L2[3] = '16' ) and ( L2.Count = 4 );
      Assert.IsTrue( ReturnValue );
      L.Free;
      L2.Free;
end;



initialization
  TDUnitX.RegisterTestFixture(TestUFP);

end.
