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
    database: TFDTable;
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
    image: TFDTable;
    newsnewsId: TIntegerField;
    magmagNum: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private 宣言 }
    function makeTable(Sender: TObject): TJSONObject;
  public
    { Public 宣言 }
    procedure AddMagazine(id: integer; out Data: TJSONObject);
    procedure backNumber(id: integer; out Data: TJSONObject);
    function existsMail(mail: string): Boolean;
    function checkUserPassword(id: integer; password: string): Boolean;
    function createReaderId(Data: TJSONObject): integer;
    procedure deleteReaderId(Data: TJSONObject);
    function updateReaderId(Data: TJSONObject): Boolean;
    procedure custData(id: integer; Data: TJSONObject);
    procedure custView(id: integer; out Data: TJSONObject);
    procedure deleteMagazine(id: integer);
    procedure deleteNumber(id, num: integer);
    procedure deleteWriter(var id: integer);
    procedure getView(id, num: integer; out Data: TJSONObject); overload;
    procedure getView(id: integer; out Data: TJSONObject); overload;
    procedure viewList(id: integer; out Data: TJSONObject);
    procedure magazines(id: integer; out Data: TJSONObject);
    procedure magListAll(id: integer; out Data: TJSONObject);
    procedure magData(id: integer; out Data: TJSONObject);
    function magid(name: string): integer;
    procedure magIdOff(id, magid: integer);
    procedure magIdOn(id, magid: integer);
    procedure createMagId(id: integer; out Data: TJSONObject);
    procedure postMessage(id: integer; Data: TJSONObject);
    procedure createWriterId(Data: TJSONObject);
    procedure readerData(id: integer; out Data: TJSONObject);
    procedure titleView(id: integer;out Data: TJSONObject);
    procedure updateWriterId(id: integer; Data: TJSONObject);
    procedure userView(id: integer; out Data: TJSONObject);
    function loginReader(data: TJSONObject): integer;
    function loginWriter(data: TJSONObject): integer;
    procedure mainView(id: integer; out data: TJSONObject);
    procedure imageView(id: integer; out data: TJSONObject);
    function imageId(data: TJSONObject): integer;
  end;

var
  DataModule1: TDataModule1;

implementation

uses System.Variants, System.Generics.Collections;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

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
  Data := TJSONObject.Create;
  d := Data;
  mem := TStringList.Create;
  with FDQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select file,enabled from news where magId = :id order by lastDay;');
    Params.ParamByName('id').AsInteger := id;
    Open;
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

procedure TDataModule1.createMagId(id: integer; out Data: TJSONObject);
var
  i: integer;
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select MAX(magId) as count from mag;');
  FDQuery1.Open;
  i := FDQuery1.FieldByName('count').AsInteger + 1;
  mag.Append;
  mag.FieldByName('magId').AsInteger := id;
  mag.FieldByName('magNum').AsString := 'MAG'+i.ToString;
  mag.FieldByName('day').AsDateTime := Date;
  mag.FieldByName('lastDay').AsDateTime := Date;
  mag.FieldByName('magName').AsString := Data.Values['magName'].Value;
  mag.FieldByName('comment').AsString := Data.Values['comment'].Value;
  mag.FieldByName('enable').AsString := Data.Values['enable'].Value;
  mag.Post;
  magList.AppendRecord([id, i]);
end;

function TDataModule1.createReaderId(Data: TJSONObject): integer;
var
  i: integer;
  na, ma, pa: string;
begin
  na := Data.Values['name'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if reader.Locate('mail',ma) = false then
  begin
    FDQuery1.Open('select MAX(readerid) as id from reader;');
    i := FDQuery1.FieldByName('id').AsInteger + 1;
    reader.AppendRecord([i, na, ma, pa]);
    result:=i;
  end
  else
    result:=0;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
const
  tmp = 'create table if not exists ';
begin
//  FDQuery1.ExecSQL(tmp+'database(number int primary key, magId int, readerId int, writeId int);');
  FDQuery1.ExecSQL
    (tmp + 'mag(magId int primary key, magNum varchar(10), magName varchar(20), comment varchar(50), day date, lastDay date, enable bool);');
  FDQuery1.ExecSQL
    (tmp + 'writer(writerId int primary key, writer varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL
    (tmp + 'reader(readerId int primary key, reader varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL
    (tmp + 'news(magId int, newsId int, day date, changed bool, enabled bool, primary key (magId,newsId));');
  FDQuery1.ExecSQL
    (tmp + 'indexTable(readerId int, magId int, primary key (readerId,magId));');
  FDQuery1.ExecSQL
    (tmp + 'magList(writerId int, magId int, primary key (writerId,magId));');
  FDQuery1.ExecSQL(tmp+'image(id int primary key, writerId int, number int, name varchar(20), data text);');
//  database.Open;      シャッフル可能にするため通し番号を付けたほうが良いらしい
  mag.Open;
  writer.Open;
  reader.Open;
  news.Open;
  indexTable.Open;
  magList.Open;
  image.Open;
end;

procedure TDataModule1.deleteMagazine(id: integer);
  procedure main(Sender: TObject);
  begin
    with Sender as TFDTable do
      while Locate('magid',id) = true do
        Delete;
  end;

begin
  if mag.Locate('magId',id) = true then
    mag.Delete;
  main(news);
//  main(database);
  main(indexTable);
end;

procedure TDataModule1.deleteNumber(id, num: integer);
begin
  if news.Locate('magId;newsId', VarArrayOf([id, num])) = true then
    news.Delete;
end;

procedure TDataModule1.deleteReaderId(Data: TJSONObject);
var
  id: integer;
  na, ma, pa: string;
begin
  id := Data.Values['id'].Value.ToInteger;
  na := Data.Values['reader'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if reader.Locate('readerid;reader;mail;password', VarArrayOf([id, na, ma, pa])
    ) = true then
    reader.Delete;
  while indexTable.Locate('readerid',id) = true do
    indexTable.Delete;
end;

procedure TDataModule1.deleteWriter(var id: integer);
begin
  if writer.Locate('writerid',id) = true then
    writer.Delete;
  while magList.Locate('writerid',id) = true do
  begin
    deleteMagazine(magList.FieldByName('magid').AsInteger);
    magList.Delete;
  end;
  id:=0;
end;

function TDataModule1.existsMail(mail: string): Boolean;
begin
  result := (writer.Locate('mail',mail) = true)or(reader.Locate('mail',mail) = true);
end;

procedure TDataModule1.readerData(id: integer; out Data: TJSONObject);
begin
  if reader.Locate('readerid', id) = true then
  begin
    Data := TJSONObject.Create;
    Data.AddPair('name', reader.FieldByName('reader').AsString);
    Data.AddPair('mail', reader.FieldByName('mail').AsString);
  end;
end;

procedure TDataModule1.userView(id: integer; out Data: TJSONObject);
var
  i: integer;
  list: TList<integer>;
  ar: TJSONArray;
  d: TJSONObject;
begin
  list := TList<integer>.Create;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from indexTable where readerid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  while FDQuery1.Eof = false do
  begin
    list.Add(FDQuery1.FieldByName('magid').AsInteger);
    FDQuery1.Next;
  end;
  ar:=TJSONArray.Create;
  for i in list do
  begin
    titleView(i, d);
    ar.Add(d);
  end;
  list.Free;
  Data := TJSONObject.Create;
  data.AddPair('mag',ar);
end;

procedure TDataModule1.viewList(id: integer; out Data: TJSONObject);
begin

end;

procedure TDataModule1.custData(id: integer; Data: TJSONObject);
begin
  if writer.Locate('writerid', id) = true then
  begin
    Data.AddPair('name', writer.FieldByName('writer').AsString);
    Data.AddPair('mail', writer.FieldByName('mail').AsString);
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

function TDataModule1.imageId(data: TJSONObject): integer;
var
  writerId, number: integer;
begin
  writerId:=data.Values['id'].Value.ToInteger;
  number:=data.Values['number'].Value.ToInteger;
  if image.Locate('writerId;number',VarArrayOf([writerId,number])) = true then
    result:=image.FieldByName('id').AsInteger;
end;

procedure TDataModule1.imageView(id: integer; out data: TJSONObject);
begin
  data:=TJSONObject.Create;
  if image.Locate('id',id) = true then
  begin
    data.AddPair('name',image.FieldByName('name').AsString);
    data.AddPair('data',image.FieldByName('data').AsString);
  end;
end;

function TDataModule1.loginReader(data: TJSONObject): integer;
var
  ma,pa: string;
begin
  ma:=Data.Values['mail'].Value;
  pa:=Data.Values['password'].Value;
  if reader.Locate('mail;password',VarArrayOf([ma,pa])) = true then
    result:=reader.FieldByName('readerid').AsInteger
  else
    result:=0;
end;

function TDataModule1.loginWriter(data: TJSONObject): integer;
var
  ma,pa: string;
begin
  ma:=Data.Values['mail'].Value;
  pa:=Data.Values['password'].Value;
  if writer.Locate('mail;password',VarArrayOf([ma,pa])) = true then
    result:=writer.FieldByName('writerid').AsInteger
  else
    result:=0;
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
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('select COUNT(*) as count from indextable where magid = :id;');
    FDQuery1.ParamByName('id').AsInteger:=id;
    FDQuery1.Open;
    Data.AddPair('count', FDQuery1.FieldByName('count').AsString);
  end;
end;

function TDataModule1.magid(name: string): integer;
var
  v: Variant;
begin
  v:=mag.Lookup('magNum', name, 'magid');
  if VarIsNull(v) = true then
    result:=0
  else
    result :=v;
end;

procedure TDataModule1.magIdOff(id, magid: integer);
begin
  if indexTable.Locate('readerId;magId', VarArrayOf([id, magid])) = true then
    indexTable.Delete;
end;

procedure TDataModule1.magIdOn(id, magid: integer);
begin
  if (reader.Locate('readerid', id) = true) and
    (mag.Locate('magid', magid) = true) then
    indexTable.AppendRecord([id, magid]);
end;

procedure TDataModule1.magListAll(id: integer;out Data: TJSONObject);
var
  js: TJSONObject;
  ar: TJSONArray;
  val: TJSONValue;
  i: integer;
  v: Variant;
begin
  mag.First;
  ar := TJSONArray.Create;
  FDQuery1.Open('select magId,COUNT(*) as count from indexTable group by magId');
  while mag.Eof = false do
  begin
    i:=mag.FieldByName('magId').AsInteger;
    v:=FDQuery1.Lookup('magId',i,'count');
    if VarIsNull(v) = true then
      v:=0;
    js := TJSONObject.Create;
    js.AddPair('magNum',mag.FieldByName('magNum').AsString);
    js.AddPair('magName', mag.FieldByName('magName').AsString);
    js.AddPair('comment', mag.FieldByName('comment').AsString);
    js.AddPair('day', mag.FieldByName('day').AsString);
    js.AddPair('lastDay', mag.FieldByName('lastDay').AsString);
    js.AddPair('count',v);
    v:=magList.Lookup('magId',i,'writerId');
    v:=writer.Lookup('writerId',v,'writer');
    if VarIsNull(v) = true then
      js.AddPair('writer',TJSONFalse.Create)
    else
      js.AddPair('writer',v);
    if (id = 0)or(indexTable.Locate('readerId;magid',VarArrayOf([id,i])) = false) then
      js.AddPair('fun',TJSONFalse.Create)
    else
      js.AddPair('fun',TJSONTrue.Create);
    ar.Add(js);
    mag.Next;
  end;
  Data := TJSONObject.Create;
  if ar.Count > 0 then
    Data.AddPair('items', ar)
  else
    Data.AddPair('items', TJSONFalse.Create);
  if mag.FieldByName('enable').AsBoolean = true then
    val := TJSONTrue.Create
  else
    val := TJSONFalse.Create;
  Data.AddPair('enable', val);
end;

procedure TDataModule1.mainView(id: integer; out data: TJSONObject);
begin
  data:=TJSONObject.Create;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from news,magId where news.magId = magName.magId');
  FDQuery1.SQL.Add(' and magId = :id order by day;');
  FDQUery1.Params.ParamByName('id').AsInteger:=id;
  while FDQUery1.Eof = false do
  begin
    if FDQuery1.FieldByName('enebled').AsBoolean = true then
    begin
      if FDQuery1.FieldByName('changed').AsBoolean = true then
        data.AddPair('changed',TJSONTrue.Create);
      data.AddPair('',FDQuery1.FieldByName('').AsString);
    end;
    FDQuery1.Next;
  end;
end;

procedure TDataModule1.magazines(id: integer; out Data: TJSONObject);
var
  d: TJSONObject;
  val: TJSONValue;
  ar: TJSONArray;
  list: TList<integer>;
  i: integer;
begin
  d:=data;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from maglist where writerid = :id;');
  FDQuery1.Params.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  ar := TJSONArray.Create;
  list:=TList<integer>.Create;
  while FDQuery1.Eof = false do
  begin
    list.Add(FDQuery1.FieldByName('magId').AsInteger);
    FDQuery1.Next;
  end;
  for i in list do
  begin
    magData(i,d);
    ar.Add(d);
  end;
  list.Free;
  if ar.Count = 0 then
  begin
    ar.Free;
    val := TJSONFalse.Create;
  end
  else
    val := ar;
  Data := TJSONObject.Create;
  Data.AddPair('mag', val);
end;

function TDataModule1.makeTable(Sender: TObject): TJSONObject;
var
  day: string;
  blob: TStream;
  mem: TStringList;
  ar: TJSONArray;
  d: TJSONObject;
begin
  ar:=TJSONArray.Create;
  mem := TStringList.Create;
  with Sender as TFDQuery do
  begin
    First;
    while Eof = false do
    begin
      d:=TJSONObject.Create;
      ar.Add(d);
      day := FieldByName('day').AsString;
      if FieldByName('updated').AsBoolean = true then
        d.AddPair('hint', Format('この記事は更新されました:(%s)日.',[day]));
      blob := CreateBlobStream(FieldByName('file'), bmRead);
      mem.LoadFromStream(blob);
      blob.Free;
      d.AddPair('text',mem.Text);
      d.AddPair('day',day);
      Next;
    end;
  end;
  mem.Free;
  result := TJSONObject.Create;
  result.AddPair('news',ar);
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
    i := FDQuery1.FieldByName('id').AsInteger + 1;
    na := Data.Values['name'].Value;
    ma := Data.Values['mail'].Value;
    pa := Data.Values['password'].Value;
    writer.AppendRecord([i, na, ma, pa]);
  end;
end;

procedure TDataModule1.titleView(id: integer;out Data: TJSONObject);
var
  d: TJSONObject;
  i: integer;
begin
  Data:=TJSONObject.Create;
  d:=Data;
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

function TDataModule1.updateReaderId(Data: TJSONObject): Boolean;
var
  na, ma, pa: string;
begin
  na:=Data.Values['reader'].Value;
  ma:=Data.Values['mail'].Value;
  pa:=data.Values['password'].Value;
  if reader.Locate('id',data.Values['id'].Value.ToInteger) = true then
  with reader do
  begin
    Edit;
    FieldByName('reader').AsString:=na;
    FieldByName('mail').AsString:=ma;
    FieldByName('password').AsString:=pa;
    Post;
    result:=true;
  end
  else
    result:=false;
end;

procedure TDataModule1.updateWriterId(id: integer; Data: TJSONObject);
var
  na, ma, pa: string;
begin
  na := Data.Values['name'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  with writer do
  begin
    Edit;
    FieldByName('writerId').AsInteger := id;
    FieldByName('writer').AsString := na;
    FieldByName('mail').AsString := ma;
    FieldByName('password').AsString := pa;
    Post;
  end;
end;

end.
