unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, taylorserie, mResult;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
   res: TResult;
   taylor: TTaylorSerie;
   x, e: Double;
   i,j : Integer;
begin
  StringGrid1.Clean;
  x := StrToFloat(Edit1.Text);
  e := StrToFloat(Edit2.Text);
  taylor := TTaylorSerie.create();
  if RadioButton1.Checked then
    res := taylor.sin(x,e);
  if RadioButton2.Checked then
    res := taylor.cos(x,e);
  //Memo1.Lines.Add('Precision: '+ IntToStr(taylor.getPresicion(e)));

  Memo1.Lines.Add(res.result);
  Memo1.Lines.add(IntToStr(Length(res.matrix))+ ' ' + IntToStr(Length(res.matrix[0])));
  StringGrid1.RowCount:= Length(res.matrix)+1;
  StringGrid1.ColCount:= Length(res.matrix[0])+1;

  for i:=0 to Length(res.matrix)-1 do
  begin
    for j:=0 to Length(res.matrix[0])-1 do
        StringGrid1.Cells[j,i+1] := res.matrix[i,j];
  end;


end;

end.

