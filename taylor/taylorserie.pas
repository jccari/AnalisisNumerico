unit TaylorSerie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, math, mResult;

type
    TStringMatrix = array of array of string;

type
  TTaylorSerie = class
    private
      serie: TStringList;

      function factorial(a: Integer): Integer;
    public
      constructor create();

      function exp(number: Double; e: Double): TStringList;
      function sin(x: Double; e: Double): TResult;
      function cos(x: Double; e: Double): TResult;
      function ln(x: Double; e: Double): TResult;
      function arctanh(x: Double; e: Double): TResult;

      function radToGrad(x: Double): double;
      function getPresicion(error: Double): Integer;
      function getZerosStr(precision: Integer): string;
      function getSign(grades: double): Integer;
  end;

implementation

constructor TTaylorSerie.create();
begin
end;

function TTaylorSerie.factorial(a: Integer): Integer;
var
  i: Integer;
  res: Integer;
begin
  if( a=0) then
      Result := 1
  else
  begin
    if a<3 then
       Result:=a
    else
    begin
      res:=2;
      for i:=3 to a do
          res := res*i;
      Result:= res;
    end;
  end;
end;

function TTaylorSerie.exp(number: Double; e: Double): TStringList;
var
  //suma: Double;
  eAbs: Double;
  xn, xni, xnOld: Double;
  i: Integer;
  listSerie: TStringList;
begin
  listSerie := TStringList.create;
  eAbs:=1000;
  xn:= power(number,i)/factorial(i); // this is the first iteration
  xnOld:= xn;
  i:= 1;       /// it starts in the first iteration
  while( eAbs < e) do
  begin
    listSerie.Append(FloatToStr(xn));
    xni:= power(number,i)/factorial(i);
    xn := xn + xni;
    eAbs:= xn-xnOld;
    i:= i+1;
    xnOld:= xn;
  end;

  Result := listSerie;
end;

function TTaylorSerie.sin(x: double; e: double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  sign:=getSign(x);

  x := trunc(x) mod (180);
  x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( power(-1,k)/factorial(2*k+1)) * power(x,2*k+1);
  res := res + xn;
  SetLength(resMatrix,1,3);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( power(-1,k)/factorial(2*k+1)) * power(x,2*k+1);
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,3);
    resMatrix[k,0] := IntToStr(k);
    //resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,1] := FloatToStr(sign*res);
    resMatrix[k,2] := FloatToStr(eAbs);
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  Result.result := FloatToStr(sign*res);
  //Result.result := FloatToStr( res );
  Result.matrix := resMatrix;
end;

function TTaylorSerie.cos(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  sign:=getSign(x);

  x := trunc(x) mod (180);
  x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( power(-1,k)/factorial(2*k)) * power(x,2*k);
  res := res + xn;
  SetLength(resMatrix,1,3);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( power(-1,k)/factorial(2*k)) * power(x,2*k);
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,3);
    resMatrix[k,0] := IntToStr(k);
    //resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,1] := FloatToStr(sign*res);
    resMatrix[k,2] := FloatToStr(eAbs);
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  Result.result := FloatToStr( sign*res );
  //Result.result := FloatToStr( res );
  Result.matrix := resMatrix;
end;

function TTaylorSerie.ln(x: Double; e: Double): TResult;
begin

end;

function TTaylorSerie.arctanh(x: Double; e: Double): TResult;
begin

end;

////
function TTaylorSerie.radToGrad(x: double): double;
begin
  Result:= x*pi/180;
end;

function TTaylorSerie.getPresicion(error: Double): Integer;
var
  digits: Integer;
  eString: string;
begin
     eString:= FloatToStr(error);
     //AnsiPos('.',eString);
     Result := AnsiPos('1',eString)-AnsiPos('.',eString)-1;
end;

//DupeString function needs srtutils library
function TTaylorSerie.getZerosStr(precision: Integer): string;
begin
  Result := DupeString('0',precision);
  Result := '0.'+Result;
end;

function TTaylorSerie.getSign(grades: double): Integer;
begin
  grades := trunc(grades) mod (360);
  if ( grades < 180 ) then
     Result:= 1
  else
      Result := -1;
end;

end.

