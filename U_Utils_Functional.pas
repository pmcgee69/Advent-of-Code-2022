unit U_Utils_Functional;

interface
uses generics.Collections, system.SysUtils, system.classes;

  type
    UFP = record

      class function List_Map    <U>   ( L : TStringList; f : TFunc<string,U> ) : TList<U>;    overload;   static;

      class function List_Map    <T,U> ( L : TList<T>;    f : TFunc<T,U> )      : TList<U>;    overload;   static;

      class function List_Reduce <T>   ( L : TList<T>;    f : TFunc<T,T,T> )    : T;                       static;

      class function List_Filter <T>   ( L : TList<T>;    f : TPredicate<T> )   : TList<T>;                static;

      class function Compose  <T,U,V>  ( f : TFunc<T,U>;  g : TFunc<U,V> )      : TFunc<T,V>;              static;

      class function Compose3 <T,U,V,W>( f : TFunc<T,U>;
                                         g : TFunc<U,V>;  h : TFunc<V,W> )      : TFunc<T,W>;              static;

      class function String_Map  <U>   ( const s : string;f : TFunc<string, integer, U> ) : TList<U>;      static;


      type
        tuple <A,B>   = record fst : A; snd : B;          end;
        triple<A,B,C> = record fst : A; snd : B; thd : C; end;

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


   class function UFP.List_Map<U> ( L : TStringList; f : TFunc<string,U> ) : TList<U>;
   begin
     var L2 : TList<U> := TList<U>.create;

         for var T_ in L do L2.Add( f(T_) );

         result := L2;
   end;


   class function UFP.String_Map<U> ( const s : string; f : TFunc<string, integer, U> ) : TList<U>;
   begin
     var L2 : TList<U> := TList<U>.create;

         for var i := 1 to length(s) do L2.Add( f(s, i) );

         result := L2;
   end;


   class function UFP.List_Reduce<T> ( L : TList<T>; f : TFunc<T,T,T> ) : T;
   begin
         result := default(T);

         for var t_ in L do result := f(t_, result);
   end;



   class function UFP.List_Filter<T> ( L : TList<T>; f : TPredicate<T> ) : TList<T>;
   begin
     var L2 : TList<T> := TList<T>.create;

         for var T_ in L do if f(T_) then L2.Add(T_);

         result := L2;
   end;



   class function UFP.Compose <T,U,V> ( f : TFunc<T,U>; g : TFunc<U,V> ) : TFunc<T,V>;
   begin
         result := function( _t : T ) : V
                   begin
                      result := g( f( _t ) )
                   end;
   end;



   class function UFP.Compose3 <T,U,V,W> ( f : TFunc<T,U>; g : TFunc<U,V>; H : TFunc<V,W> ) : TFunc<T,W >;
   begin
         result := function( _t : T ) : W
                   begin
                      result := h( g( f( _t ) ) )
                   end;
   end;



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   function SafeStrToInt(   s : string ) : integer;   begin  if s='' then exit(0) else exit(s.ToInteger)  end;

   function StringToInt (   s : string ) : integer;   begin  exit( s.ToInteger ) end;

   function Sum         ( i,j : integer) : integer;   begin  exit( i+j )         end;

   function Max         ( i,j : integer) : integer;   begin  if i<j then exit(j) else exit(i)  end;



end.




