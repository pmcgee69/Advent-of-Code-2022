unit U_Utils_Functional;

interface
uses generics.Collections, system.SysUtils, system.classes;

  type
    UFP = record

      class function List_Map    <U>   ( L : TStringList; f : TFunc<string,U> ) : TList<U>;    overload;   static;

      class function List_Map    <T,U> ( L : TList<T>;    f : TFunc<T,U> )      : TList<U>;    overload;   static;

      class function List_Reduce <T>   ( L : TList<T>;    f : TFunc<T,T,T> )    : T;                       static;

      type
        tuple <A,B>   = record fst : A; sec : B;          end;
        triple<A,B,C> = record fst : A; sec : B; thd : C; end;

    end;



  function SafeStrToInt(s : string)  : integer;

  function StringToInt (s : string ) : integer;

  function Sum      ( i,j : integer) : integer;

  function Max      ( i,j : integer) : integer;



implementation


   class function UFP.List_Map<T,U> ( L : TList<T>; f : TFunc<T,U> ) : TList<U>;
   begin
     var L2 : TList<U> := TList<U>.create;

         for var T_ in L do L2.Add( f(T_) );

     result := L2;
   end;


   class function UFP.List_Map<U>   ( L : TStringList; f : TFunc<string,U> ) : TList<U>;
   begin
     var L2 : TList<U> := TList<U>.create;

         for var T_ in L do L2.Add( f(T_) );

     result := L2;
   end;


   class function UFP.List_Reduce<T>   ( L : TList<T>; f : TFunc<T,T,T> ) : T;
   begin
         result := default(T);

         for var t_ in L do result := f(t_, result);
   end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   function SafeStrToInt(   s : string ) : integer;   begin  if s='' then exit(0) else exit(s.ToInteger)  end;

   function StringToInt (   s : string ) : integer;   begin  exit( s.ToInteger ) end;

   function Sum         ( i,j : integer) : integer;   begin  exit( i+j )         end;

   function Max         ( i,j : integer) : integer;   begin  if i<j then exit(j) else exit(i)  end;



end.




