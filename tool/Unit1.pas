unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TForm2 = class(TForm)
    NewstableConnection: TFDConnection;
    FDTable1: TFDTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDTable1magId: TIntegerField;
    FDTable1magNum: TWideStringField;
    FDTable1magName: TWideStringField;
    FDTable1comment: TWideStringField;
    FDTable1day: TDateField;
    Panel1: TPanel;
    Button1: TButton;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTable1lastDay: TDateField;
    FDTable1enable: TBooleanField;
    Button2: TButton;
    FDTable2: TFDTable;
    FDTable2writerId: TIntegerField;
    FDTable2magId: TIntegerField;
    Button3: TButton;
    FDTable3: TFDTable;
    FDTable3writerId: TIntegerField;
    FDTable3writer: TWideStringField;
    FDTable3mail: TWideStringField;
    FDTable3password: TWideStringField;
    Edit1: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  i, j: Integer;
begin
  FDQuery1.Open;
  j:=FDQuery1.FieldByName('id').AsInteger+1;
  for i := 1 to 100 do
  begin
    FDTable1.AppendRecord([j,'MG'+j.ToString,'jiro'+j.ToString,'this is comment',Date,Date,true]);
    inc(j);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if (FDTable3.Bof = true)and(FDTable3.Eof = true) then
    FDTable3.AppendRecord([1,'masasi','mail','pass']);
  FDTable1.First;
  while FDTable1.Eof = false do
  begin
    FDTable2.AppendRecord([1,FDTable1.FieldByName('magid').AsInteger]);
    FDTable1.Next;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  while FDTable1.Eof = false do
    FDTable1.Delete;
  while FDTable2.Eof = false do
    FDTable2.Delete;
end;

end.
