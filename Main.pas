unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    pSite: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    timer: TTimer;
    lStat: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
    procedure Create_Matrix();
    procedure kick_start();
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  anz_led : integer;
  wahrscheinlichkeit : integer;
  aAlter : Array[1..10000] of integer;
  aSoll : Array[1..10000] of integer;

implementation

{$R *.dfm}

procedure TForm1.kick_start();
var
  an_aus, i, proz_anz : integer;
begin
  //Entf�rben
  for i := 1 to anz_led do
  begin
    TPanel(FindComponent('Panel'+IntToStr(i))).Color := clBtnFace;
  end;

  proz_anz := Trunc((anz_led / 100) * wahrscheinlichkeit);

  //Damit auch alle gef�rbt werden
  While proz_anz > 0 do
  begin
    for i := 1 to anz_led do
    begin
      //Random Zahl zwischen inklusive 1 und 100
      an_aus := Random(99)+1;
      //Raum nach Eingabe
      if ((an_aus >= 1) and (an_aus <= wahrscheinlichkeit)) then
      begin
        TPanel(FindComponent('Panel'+IntToStr(i))).Color := clRed;
        proz_anz := proz_anz - 1;
        if proz_anz = 0 then
          Exit;
      end;
    end;
  end;
end;

procedure TForm1.timerTimer(Sender: TObject);
var
  i : integer;
  n0, n1, n2, n3, n4, n5, n6, n7, n8, summe : integer;
begin

  TPanel(FindComponent('Panel'+IntToStr(1500))).Color := clRed;
  TPanel(FindComponent('Panel'+IntToStr(1501))).Color := clRed;
  TPanel(FindComponent('Panel'+IntToStr(1623))).Color := clRed;
  TPanel(FindComponent('Panel'+IntToStr(1624))).Color := clRed;
  Form1.Refresh;

  for i := 1 to anz_led do
  begin
    //Nachbarn Status f�llen
    //Haupt-Zelle
    if TPanel(FindComponent('Panel'+IntToStr(i))).Color = clRed then
        n0 := 1   //Haupt-Zelle lebt
      else
        n0 := 0;  //Haupt-Zelle tot

    //Oben Links
    if i - 124 <= 0 then
      n1 := 0     //Wenn kein nachbar, dann tot
    else
      if TPanel(FindComponent('Panel'+IntToStr(i-124))).Color = clRed then
        n1 := 1   //Nachbar lebt
      else
        n1 := 0;  //Nachbar tot

    //Oben
    if i - 123 <= 0 then
      n2 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i-123))).Color = clRed then
        n2 := 1   //Nachbar lebt
      else
        n2 := 0;  //Nachbar tot

    //Oben Rechts
    if i - 122 <= 0 then
      n3 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i-122))).Color = clRed then
        n3 := 1   //Nachbar lebt
      else
        n3 := 0;  //Nachbar tot

    //Links
    if i - 1 <= 0 then
      n4 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i-1))).Color = clRed then
        n4 := 1   //Nachbar lebt
      else
        n4 := 0;  //Nachbar tot

    //Rechts
    if i + 1 > anz_led then
      n5 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i+1))).Color = clRed then
        n5 := 1   //Nachbar lebt
      else
        n5 := 0;  //Nachbar tot

    //Unten Links
    if i + 122 > anz_led then
      n6 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i+122))).Color = clRed then
        n6 := 1   //Nachbar lebt
      else
        n6 := 0;  //Nachbar tot

    //Unten
    if i + 123 > anz_led then
      n7 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i+123))).Color = clRed then
        n7 := 1   //Nachbar lebt
      else
        n7 := 0;  //Nachbar tot

    //Unten Rechts
    if i + 124 > anz_led then
      n8 := 0
    else
      if TPanel(FindComponent('Panel'+IntToStr(i+124))).Color = clRed then
        n8 := 1   //Nachbar lebt
      else
        n8 := 0;  //Nachbar tot

    summe := n1+n2+n3+n4+n5+n6+n7+n8;

    //Alter hochz�hlen
    aAlter[i] := aAlter[i] + 1;

    //Regel 1 TOT durch Einsamkeit
    if summe <= 1 then
    begin
      aSoll[i] := 0;
      aAlter[i] := 0;
    end;

    //Regel 2 BELEBUNG durch Freunde (nur wenn noch nicht lebendig)
    if ((summe = 3) and (n0 = 0)) then
    begin
      aSoll[i] := 1;
      aAlter[i] := 0;
    end;


    //Regel 3 TOT durch �berbev�lkerung
    if summe > 3 then
    begin
      aSoll[i] := 0;
      aAlter[i] := 0;
    end;

    //Regel 4 TOT durch ALTER
    if aAlter[i] > 50 then
    begin
      aSoll[i] := 0;
      aAlter[i] := 0;
    end;
  end;

  //Array anzeigen
  for i := 1 to anz_led do
  begin
    if aSoll[i] = 0 then
      TPanel(FindComponent('Panel'+IntToStr(i))).Color := ClBtnFace
    else
      TPanel(FindComponent('Panel'+IntToStr(i))).Color := clRed;
  end;
  Form1.Refresh;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  lStat.Color := clGreen;
  lStat.Caption := 'Berechnungen laufen';
  timer.Enabled := true;
end;

procedure TForm1.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ShowMessage('df');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  lStat.Color := clRed;
  lStat.Caption := 'Berechnungen gestopt';
  timer.Enabled := false;
end;

procedure TForm1.Create_Matrix();
var
  Panel : TPanel;
  i, left, top, width, height, add_left, add_top : integer;
begin
  left := 5;
  top := 5;
  width := 7;
  height := 7;

  for i := 1 to 9000 do
  begin
    Panel := TPanel.Create(Self);
    Panel.Parent := Self;
    Panel.Left := left;
    Panel.Top := top;
    Panel.Width := width;
    Panel.Height := height;
    Panel.Name := 'Panel'+IntToStr(i);
    Panel.Caption := '';
    Panel.ParentBackground := false;

    //Pos neu Setzen
    left := TPanel(FindComponent('Panel'+IntToStr(i))).left + 5 + width;
    //L�nge Setzen
    if not ((left) <= Form1.Width-(150+width)) then
    begin
      left := 5;
      //Zeilen Setzen
      if ((top) <= Form1.Height-(50+height)) then
        top := TPanel(FindComponent('Panel'+IntToStr(i))).top + 5 + height
      else
        break;
    end;
  end;
  anz_led := i;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  //nur zahlen
  if not (Key in ['0'..'9', Char(VK_BACK)]) and not (Key = #13) then
    Key := #0;

  if Key = #13 then
  begin
    wahrscheinlichkeit := StrToInt(Edit1.Text);
    if (wahrscheinlichkeit < 1) or (wahrscheinlichkeit > 100) then
    begin
      ShowMessage('Bitte eine Zahl zwischen 1 und 100 eingeben');
      Edit1.Text := '';
      Edit1.SetFocus;
      Exit;
    end;
    kick_start();
  end;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  //nur zahlen
  if not (Key in ['0'..'9', Char(VK_BACK)]) and not (Key = #13) then
    Key := #0;

  if Key = #13 then
  begin
    timer.Interval := StrToInt(Edit2.Text);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ParentBackground := false;
  lStat.Color := clRed;
  Edit2.Text := IntToStr(1000);
  timer.Interval := 1000;
  lStat.Caption := 'Berechnungen gestopt';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Create_Matrix();
end;

end.
