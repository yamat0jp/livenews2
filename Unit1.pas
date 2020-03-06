unit Unit1;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef;

type
  TDataModule1 = class(TDataModule)
    index: TFDTable;
    FDTable2: TFDTable;
    indexTable: TFDTable;
    reader: TFDTable;
    magList: TFDTable;
    MagazineConnection: TFDConnection;
    FDQuery1: TFDQuery;
    news: TFDTable;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    writer: TFDTable;
    writerwriterId: TIntegerField;
    writerwriter: TWideStringField;
    writermail: TWideStringField;
    writerpassword: TWideStringField;
    magListwriterId: TIntegerField;
    magListmagId: TIntegerField;
    newsmagId: TIntegerField;
    newsno: TIntegerField;
    newsday: TDateField;
    newschanged: TBooleanField;
    newsenabled: TBooleanField;
    readerreaderId: TIntegerField;
    readerreader: TWideStringField;
    readermail: TWideStringField;
    readerpassword: TWideStringField;
    indexTablereaderId: TIntegerField;
    indexTablemagId: TIntegerField;
    mag: TFDTable;
    magmagId: TIntegerField;
    magmagName: TWideStringField;
    magcomment: TWideStringField;
    magday: TDateField;
    maglastDay: TDateField;
    magenable: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private 宣言 }
    function makeTable(Sender: TObject): TJSONObject;
  public
    { Public 宣言 }
    procedure AddMagazine(id: integer; out Data: TJSONObject);
    procedure backNumber(id: integer; out Data: TJSONObject);
    function checkUserPassword(id: integer; password: string): Boolean;
    procedure createReaderId(Data: TJSONObject);
    procedure custData(id: integer; data: TJSONObject);
    procedure custView(id: integer; out Data: TJSONObject);
    procedure deleteMagazine(id: integer);
    procedure deleteNumber(id, num: integer);
    procedure deleteUser(id: integer);
    procedure getView(id, num: integer; out Data: TJSONObject); overload;
    procedure getView(id: integer; out Data: TJSONObject); overload;
    procedure magazines(id: integer; out Data: TJSONObject);
    procedure magListAll(out data: TJSONObject);
    procedure magData(id: integer; out Data: TJSONObject);
    function magid(name: string): integer;
    procedure magIdOff(id, magid: integer);
    procedure magIdOn(id, magid: integer);
    procedure createMagId(id: integer; out data: TJSONObject);
    procedure postMessage(id: integer; Data: TJSONObject);
    procedure createWriterId(Data: TJSONObject);
    procedure readuserData(id: integer; out Data: TJSONObject);
    procedure titleView(id: integer; Data: TJSONObject);
    procedure updateWriterId(id: integer; Data: TJSONObject);
    procedure userView(id: integer; out Data: TJSONObject);
  end;

var
  DataModule1: TDataModule1;

implementation

uses System.Variants, System.Generics.Collections;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.AddMagazine(id: integer; out Data: TJSONObject);
var
  i: integer;
  na, com: string;
begin
  FDQuery1.Open('select MAX(magId) as id from mag;');
  i := FDQuery1.FieldByName('id').AsInteger + 1;
  na := Data.Values['magName'].Value;
  com := Data.Values['comment'].Value;
  mag.AppendRecord([i, na, com, Date, Date, true]);
  magList.AppendRecord([id, i]);
end;

procedure TDataModule1.backNumber(id: integer; out Data: TJSONObject);
const
  con = 'この記事は公開制限があります.';
var
  d: TJSONObject;
  mem: TStringList;
  blob: TStream;
begin
  with FDQuery1.Params do
  begin
    Clear;
    ParamByName('id').AsInteger := id;
  end;
  Data := TJSONObject.Create;
  d := Data;
  mem := TStringList.Create;
  with FDQuery1 do
  begin
    Open('select file,enabled from news where magId = :id order by day;');
    First;
    while Eof = false do
    begin
      blob := CreateBlobStream(FieldByName('text'), bmRead);
      mem.LoadFromStream(blob);
      if FieldByName('enabled').AsBoolean = true then
        d.AddPair('text', mem.Text)
      else
        d.AddPair('text', con);
      blob.Free;
      Next;
    end;
  end;
  mem.Free;
end;

function TDataModule1.checkUserPassword(id: integer; password: string): Boolean;
begin
  result := writer.Lookup('id', id, 'password') = password;
end;

procedure TDataModule1.createMagId(id: integer; out data: TJSONObject);
var
  i: integer;
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select MAX(magId) as count from mag;');
  FDQuery1.Open;
  i:=FDQuery1.FieldByName('count').AsInteger+1;
  mag.Append;
  mag.FieldByName('magId').AsInteger:=i;
  mag.FieldByName('day').AsDateTime:=Date;
  mag.FieldByName('lastDay').AsDateTime:=Date;
  mag.FieldByName('magName').AsString:=data.Values['magName'].Value;
  mag.FieldByName('comment').AsString:=data.Values['comment'].Value;
  mag.FieldByName('enable').AsString:=data.Values['enable'].Value;
  mag.Post;
  magList.AppendRecord([id,i]);
end;

procedure TDataModule1.createReaderId(Data: TJSONObject);
var
  i: integer;
  na, ma, pa: string;
begin
  FDQuery1.Open('select MAX(readerid) as id from reader;');
  i := FDQuery1.FieldByName('id').AsInteger + 1;
  na := Data.Values['name'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  reader.AppendRecord([i, na, ma, pa]);
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
const
  tmp = 'create table if not exists ';
begin
//  FDQuery1.ExecSQL(tmp+'index(no int primary key, magId int, readerId int, writeId int);');
  FDQuery1.ExecSQL(tmp+'mag(magId int primary key, magName varchar(20), comment varchar(50), day date, lastDay date, enable bool);');
  FDQuery1.ExecSQL(tmp+'writer(writerId int primary key, writer varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL(tmp+'reader(readerId int primary key, reader varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL(tmp+'news(magId int, no int, day date, changed bool, enabled bool, primary key (magId,no));');
  FDQuery1.ExecSQL(tmp+'indexTable(readerId int, magId int, primary key (readerId,magId));');
  FDQuery1.ExecSQL(tmp+'magList(writerId int, magId int, primary key (writerId,magId));');
//  index.Open;
  mag.Open;
  writer.Open;
  reader.Open;
  news.Open;
  indexTable.Open;
  magList.Open;
end;

procedure TDataModule1.deleteMagazine(id: integer);
  procedure main(DB: string);
  begin
    FDQuery1.Open(Format('select * from %s where magId = :id;', [DB]));
    FDQuery1.First;
    while FDQuery1.Eof = false do
      FDQuery1.Delete;
  end;

begin
  if mag.Locate('magId', id) = true then
  begin
    mag.Delete;
    FDQuery1.Params.Clear;
    FDQuery1.Params.ParamByName('id').AsInteger := id;
    main('news');
    main('database');
    main('indexTable');
  end;
end;

procedure TDataModule1.deleteNumber(id, num: integer);
begin
  if news.Locate('magId;newsId', VarArrayOf([id, num])) = true then
    news.Delete;
end;

procedure TDataModule1.deleteUser(id: integer);
var
  i: integer;
  list: TList<integer>;
begin
  FDQuery1.Params.Clear;
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open('select * from maglist where userid = :id;');
  list := TList<integer>.Create;
  while FDQuery1.Eof = false do
  begin
    list.Add(FDQuery1.FieldByName('magid').AsInteger);
    FDQuery1.Delete;
  end;
  for i in list do
    deleteMagazine(i);
  list.Free;
end;

procedure TDataModule1.readuserData(id: integer; out Data: TJSONObject);
var
  i: Integer;
begin
  if reader.Locate('readerid', id) = true then
  begin
    Data := TJSONObject.Create;
    for i := 1 to reader.Fields.Count-1 do
      Data.AddPair(reader.Fields[i].FieldName, reader.Fields[i].AsString);
  end;
end;

procedure TDataModule1.userView(id: integer; out Data: TJSONObject);
var
  i: integer;
  list: TList<integer>;
begin
  Data := TJSONObject.Create;
  list := TList<integer>.Create;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from indexTable where readerid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  while FDQuery1.Eof = false do
    list.Add(FDQuery1.FieldByName('magid').AsInteger);
  for i in list do
    titleView(i, Data);
  list.Free;
end;

procedure TDataModule1.custData(id: integer; data: TJSONObject);
var
  i: Integer;
begin
  if writer.Locate('writerid',id) = true then
  begin
    data.AddPair('name',writer.FieldByName('writer').AsString);
    data.AddPair('mail',writer.FieldByName('mail').AsString);
  end;
end;

procedure TDataModule1.custView(id: integer; out Data: TJSONObject);
var
  i: integer;
  list: TList<integer>;
begin
  Data := TJSONObject.Create;
  list := TList<integer>.Create;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from maglist where readerid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  while FDQuery1.Eof = false do
  begin
    list.Add(FDQuery1.FieldByName('magid').AsInteger);
    FDQuery1.Next;
  end;
  for i in list do
    titleView(i, Data);
  list.Free;
end;

procedure TDataModule1.getView(id, num: integer; out Data: TJSONObject);
begin
  with FDQuery1.SQL do
  begin
    Clear;
    Add('select updated,day,file from news');
    Add(' where magId = :id and newsId = :num');
    Add(' order by day;');
  end;
  with FDQuery1.Params do
  begin
    ParamByName('id').AsInteger := id;
    ParamByName('num').AsInteger := num;
  end;
  FDQuery1.Open;
  Data := makeTable(FDQuery1);
end;

procedure TDataModule1.getView(id: integer; out Data: TJSONObject);
begin
  with FDQuery1.SQL do
  begin
    Clear;
    Add('select updated,day,file from indexTable,news');
    Add(' where readerId = :id and indexTable.magId = news.magId');
    Add(' and enabled = true order by day;');
  end;
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  Data := makeTable(FDQuery1);
end;

procedure TDataModule1.magData(id: integer; out Data: TJSONObject);
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from mag where magid = :id;');
  FDQuery1.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  if FDQuery1.FieldByName('enable').AsBoolean = true then
  begin
    Data := TJSONObject.Create;
    Data.AddPair('name', FDQuery1.FieldByName('magName').AsString);
    Data.AddPair('comment', FDQuery1.FieldByName('comment').AsString);
    Data.AddPair('day', FDQuery1.FieldByName('day').AsString);
    Data.AddPair('last', FDQuery1.FieldByName('lastDay').AsString);
    FDQuery1.Open('select COUNT(*) as count do mag where magid = :id;');
    Data.AddPair('count', FDQuery1.FieldByName('count').AsString);
  end;
end;

function TDataModule1.magid(name: string): integer;
begin
  result := mag.Lookup('magname', name, 'magid');
end;

procedure TDataModule1.magIdOff(id, magid: integer);
begin
  if indexTable.Locate('readerId;magId', VarArrayOf([id, magid])) = true then
    indexTable.Delete;
end;

procedure TDataModule1.magIdOn(id, magid: integer);
begin
  if (writer.Locate('readerid', id) = true) and (mag.Locate('magid', magid) = true)
  then
    indexTable.AppendRecord([id, magid]);
end;

procedure TDataModule1.magListAll(out data: TJSONObject);
var
  i: Integer;
  js: TJSONObject;
  ar: TJSONArray;
  val: TJSONValue;
begin
  mag.First;
  ar:=TJSONArray.Create;
  while mag.Eof = false do
  begin
      js:=TJSONObject.Create;
      js.AddPair('magName',mag.FieldByName('magName').AsString);
      js.AddPair('comment',mag.FieldByName('comment').AsString);
      js.AddPair('day',mag.FieldByName('day').AsString);
      js.AddPair('lastDay',mag.FieldByName('lastDay').AsString);
      ar.Add(js);
    mag.Next;
  end;
  data:=TJSONObject.Create;
  if ar.Count > 0 then
    data.AddPair('items',ar)
  else
    data.AddPair('items',TJSONFalse.Create);
  if mag.FieldByName('enable').AsBoolean = true then
    val:=TJSONTrue.Create
  else
    val:=TJSONFalse.Create;
  data.AddPair('enable',val);
end;

procedure TDataModule1.magazines(id: integer; out Data: TJSONObject);
var
  d: TJSONObject;
  val: TJSONValue;
  ar: TJSONArray;
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from maglist where writerid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  ar:=TJSONArray.Create;
  while FDQuery1.Eof = false do
  begin
    magData(FDQuery1.FieldByName('magId').AsInteger, d);
    ar.Add(d);
    FDQuery1.Next;
  end;
  if ar.Count = 0 then
  begin
    ar.Free;
    val:=TJSONFalse.Create;
  end
  else
    val:=ar;
  Data := TJSONObject.Create;
  data.AddPair('mag',val);
end;

function TDataModule1.makeTable(Sender: TObject): TJSONObject;
var
  blob: TStream;
  mem: TStringList;
begin
  result := TJSONObject.Create;
  mem := TStringList.Create;
  with Sender as TFDQuery do
  begin
    First;
    while Eof = false do
    begin
      if FieldByName('updated').AsBoolean = true then
        result.AddPair('hint', Format('この記事は更新されました:(%s)日.',
          [FieldByName('day').AsString]));
      blob := CreateBlobStream(FieldByName('file'), bmRead);
      mem.LoadFromStream(blob);
      blob.Free;
      result.AddPair('text', mem.Text);
      Next;
    end;
  end;
  mem.Free;
end;

procedure TDataModule1.postMessage(id: integer; Data: TJSONObject);
var
  i: integer;
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select MAX(newsId) as id from news where magId = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  if FDQuery1.RecordCount > 0 then
  begin
    i := FDQuery1.FieldByName('id').AsInteger + 1;
    news.AppendRecord([id, i, false, Date, Data.Values['file'], true]);
  end;
end;

procedure TDataModule1.createWriterId(Data: TJSONObject);
var
  i: integer;
  na, ma, pa: string;
begin
  ma := Data.Values['mail'].Value;
  if writer.Locate('mail', ma) = false then
  begin
    FDQuery1.Open('select MAX(writerId) as id from writer;');
    i := FDQuery1.FieldByName('id').AsInteger+1;
    na := Data.Values['name'].Value;
    ma := Data.Values['mail'].Value;
    pa := Data.Values['password'].Value;
    writer.AppendRecord([i, na, ma, pa]);
  end;
end;

procedure TDataModule1.titleView(id: integer; Data: TJSONObject);
var
  d: TJSONObject;
  i: integer;
begin
  d := Data;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from mag where magid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  with FDQuery1 do
    while Eof = false do
    begin
      for i := 0 to Fields.Count - 1 do
        d.AddPair(Fields[i].FieldName, Fields[i].AsString);
      Next;
    end;
end;

procedure TDataModule1.updateWriterId(id: integer; Data: TJSONObject);
var
  na, ma, pa: string;
begin
  na := Data.ParseJSONValue('writer').Value;
  ma := Data.ParseJSONValue('mail').Value;
  pa := Data.ParseJSONValue('password').Value;
  with DataModule1.writer do
  begin
    FieldByName('writerId').AsInteger := id;
    FieldByName('writer').AsString := na;
    FieldByName('mail').AsString := ma;
    FieldByName('password').AsString := pa;
  end;
end;

end.
