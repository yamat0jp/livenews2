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
    DB: TFDTable;
    reader: TFDTable;
    MagazineConnection: TFDConnection;
    FDQuery1: TFDQuery;
    news: TFDTable;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    writer: TFDTable;
    writerwriterId: TIntegerField;
    writerwriter: TWideStringField;
    writermail: TWideStringField;
    writerpassword: TWideStringField;
    readerreaderId: TIntegerField;
    readerreader: TWideStringField;
    readermail: TWideStringField;
    readerpassword: TWideStringField;
    mag: TFDTable;
    magmagId: TIntegerField;
    magmagName: TWideStringField;
    magcomment: TWideStringField;
    magday: TDateField;
    maglastDay: TDateField;
    magenable: TBooleanField;
    image: TFDTable;
    magmagNum: TWideStringField;
    dbserial: TIntegerField;
    dbmagId: TIntegerField;
    dbreaderId: TIntegerField;
    dbwriterId: TIntegerField;
    newsmagId: TIntegerField;
    newsnewsId: TIntegerField;
    newsday: TDateField;
    newschanged: TBooleanField;
    newsenabled: TBooleanField;
    newsfiles: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private 宣言 }
    function makeTable(Sender: TObject): TJSONObject;
  public
    { Public 宣言 }
    procedure AddMagazine(id: integer; out Data: TJSONObject);
    procedure backNumber(num: string; out Data: TJSONObject);
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
    function titleView(magid, writerId: integer; out Data: TJSONObject)
      : Boolean;
    procedure updateWriterId(id: integer; Data: TJSONObject);
    procedure userView(id: integer; out Data: TJSONObject);
    function loginReader(Data: TJSONObject): integer;
    function loginWriter(Data: TJSONObject): integer;
    procedure mainView(id: integer; out Data: TJSONObject);
    procedure imageView(id: integer; out Data: TJSONObject);
    function imageId(Data: TJSONObject): integer;
    procedure zipFile(magNum: string; stream: TStream);
  end;

var
  DataModule1: TDataModule1;

implementation

uses System.Variants, System.Generics.Collections, System.Zip,
  System.NetEncoding, System.AnsiStrings;

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
  DB.AppendRecord([id, i, 0]);
end;

procedure TDataModule1.backNumber(num: string; out Data: TJSONObject);
const
  con = 'この記事は公開制限があります.';
var
  d: TJSONObject;
  ar: TJSONArray;
  mem: TStringList;
  blob: TStream;
begin
  if mag.Locate('magNum', num) = false then
    Exit;
  Data := TJSONObject.Create;
  ar := TJSONArray.Create;
  Data.AddPair('data', ar);
  mem := TStringList.Create;
  with FDQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select files,enabled from news where magId = :id order by day;');
    ParamByName('id').AsInteger := mag.FieldByName('magId').AsInteger;
    Open;
    while Eof = false do
    begin
      d := TJSONObject.Create;
      ar.Add(d);
      blob := CreateBlobStream(FieldByName('files'), bmRead);
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
  mag.FieldByName('magNum').AsString := 'MAG' + i.ToString;
  mag.FieldByName('day').AsDateTime := Date;
  mag.FieldByName('lastDay').AsDateTime := Date;
  mag.FieldByName('magName').AsString := Data.Values['magName'].Value;
  mag.FieldByName('comment').AsString := Data.Values['comment'].Value;
  mag.FieldByName('enable').AsString := Data.Values['enable'].Value;
  mag.Post;
  DB.AppendRecord([id, i, 0]);
end;

function TDataModule1.createReaderId(Data: TJSONObject): integer;
var
  i: integer;
  na, ma, pa: string;
begin
  na := Data.Values['name'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if reader.Locate('mail', ma) = false then
  begin
    FDQuery1.Open('select MAX(readerid) as id from reader;');
    i := FDQuery1.FieldByName('id').AsInteger + 1;
    reader.AppendRecord([i, na, ma, pa]);
    result := i;
  end
  else
    result := 0;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
const
  tmp = 'create table if not exists ';
begin
  FDQuery1.ExecSQL
    (tmp + 'db(serial int primary key, magId int, readerId int, writerId int);');
  FDQuery1.ExecSQL
    (tmp + 'mag(magId int primary key, magNum varchar(10), magName varchar(20), comment varchar(50), day date, lastDay date, enable bool);');
  FDQuery1.ExecSQL
    (tmp + 'writer(writerId int primary key, writer varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL
    (tmp + 'reader(readerId int primary key, reader varchar(20), mail varchar(20), password varchar(20));');
  FDQuery1.ExecSQL
    (tmp + 'news(magId int, newsId int, files text, day date, changed bool, enabled bool, primary key (magId,newsId));');
  FDQuery1.ExecSQL
    (tmp + 'image(magId int, newsId int, writerId int, name varchar(20), data text, primary key (magId,newsId));');
  DB.Open;
  mag.Open;
  writer.Open;
  reader.Open;
  news.Open;
  image.Open;
end;

procedure TDataModule1.deleteMagazine(id: integer);
begin
  if mag.Locate('magId', id) = true then
    mag.Delete;
  while news.Locate('magid', id) = true do
    news.Delete;
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
  while DB.Locate('readerid', id) = true do
    DB.Delete;
end;

procedure TDataModule1.deleteWriter(var id: integer);
begin
  if writer.Locate('writerid', id) = true then
    writer.Delete;
  while DB.Locate('writerid', id) = true do
  begin
    deleteMagazine(DB.FieldByName('magid').AsInteger);
    DB.Delete;
  end;
  id := 0;
end;

function TDataModule1.existsMail(mail: string): Boolean;
begin
  result := (writer.Locate('mail', mail) = true) or
    (reader.Locate('mail', mail) = true);
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
  ar: TJSONArray;
  d: TJSONObject;
begin
  ar := TJSONArray.Create;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from db where readerid = :id;');
  FDQuery1.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  with FDQuery1 do
    while Eof = false do
    begin
      if titleView(FieldByName('magid').AsInteger, FieldByName('writerId')
        .AsInteger, d) = true then
        ar.Add(d);
      Next;
    end;
  Data := TJSONObject.Create;
  Data.AddPair('mag', ar);
end;

procedure TDataModule1.viewList(id: integer; out Data: TJSONObject);
begin

end;

procedure TDataModule1.zipFile(magNum: string; stream: TStream);
var
  Zip: TZipFIle;
  ziph: TZipHeader;
  list: TStringList;
  name, str, str2, s, s2: string;
  id, i, j: integer;
  v: Variant;
  bytes: TBytes;
begin
  v := mag.Lookup('magNum', magNum, 'magId');
  if VarIsNull(v) = true then
    Exit;
  with FDQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select MAX(newsId) as id from news where magId = :id;');
    ParamByName('id').AsInteger := v;
    Open;
    id := FieldByName('id').AsInteger;
  end;
  Zip := TZipFIle.Create;
  list := TStringList.Create;
  Zip.Open(stream, zmRead);
  for name in Zip.FileNames do
  begin
    s := name;
    i := Length(s);
    j := LastDelimiter('/', s);
    str := Copy(s, j + 1, i);
    Delete(s, j, i);
    str2 := Copy(s, LastDelimiter('/', s), i);
    if (str = '/images') and (str2 <> '') then
    begin
      Zip.Read(name, bytes);
      image.AppendRecord([id, id, str2,
        TNetEncoding.Base64.EncodeBytesToString(bytes)]);
    end
    else if ((str = 'style') or (str = 'text')) and (str2 <> '') then
    begin
      Zip.Read(name, stream, ziph);
      list.LoadFromStream(stream);
      stream.Free;
      if str = 'text' then
        for i := 0 to list.Count - 1 do
          if Pos('../images/', list[i]) > 0 then
          begin
            s2 := Format('/images?id=%d&name=', [id]);
            list[i] := ReplaceText(list[i], '../images/', s2);
          end
          else if Pos('../style/', list[i]) > 0 then
          begin
            s2 := Format('/style?id=%d&name=', [id]);
            list[i] := ReplaceText(list[i], '../style/', s2);
          end;
      image.AppendRecord([id, id, str2, list.Text]);
    end;
    list.LoadFromStream(stream);
  end;
  list.Free;
  Zip.Free;
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
  d: TJSONObject;
  ar: TJSONArray;
begin
  Data := TJSONObject.Create;
  ar := TJSONArray.Create;
  with FDQuery1 do
  begin
    SQL.Clear;
    SQL.Add('select * from db where readerid = :id;');
    ParamByName('id').AsInteger := id;
    Open;
    while Eof = false do
    begin
      d := TJSONObject.Create;
      if titleView(FieldByName('magid').AsInteger, FieldByName('writerId')
        .AsInteger, d) = true then
        ar.Add(d);
      Next;
    end;
  end;
  Data.AddPair('mag', ar);
end;

procedure TDataModule1.getView(id, num: integer; out Data: TJSONObject);
begin
  with FDQuery1.SQL do
  begin
    Clear;
    Add('select changed,day,file from news');
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
  if id = 0 then
    Exit;
  with FDQuery1.SQL do
  begin
    Clear;
    Add('select magName,writer,changed,news.day,files from db,news,mag,writer');
    Add(' where db.readerId = :id and db.magId = mag.magId and db.magId = news.magId');
    Add(' and db.writerId = writer.writerId and enabled = true order by news.day;');
  end;
  FDQuery1.ParamByName('id').AsInteger := id;
  FDQuery1.Open;
  Data := makeTable(FDQuery1);
end;

function TDataModule1.imageId(Data: TJSONObject): integer;
var
  writerId, number: integer;
begin
  writerId := Data.Values['id'].Value.ToInteger;
  number := Data.Values['number'].Value.ToInteger;
  if image.Locate('writerId;number', VarArrayOf([writerId, number])) = true then
    result := image.FieldByName('id').AsInteger;
end;

procedure TDataModule1.imageView(id: integer; out Data: TJSONObject);
begin
  Data := TJSONObject.Create;
  if image.Locate('id', id) = true then
  begin
    Data.AddPair('name', image.FieldByName('name').AsString);
    Data.AddPair('data', image.FieldByName('data').AsString);
  end;
end;

function TDataModule1.loginReader(Data: TJSONObject): integer;
var
  ma, pa: string;
begin
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if reader.Locate('mail;password', VarArrayOf([ma, pa])) = true then
    result := reader.FieldByName('readerid').AsInteger
  else
    result := 0;
end;

function TDataModule1.loginWriter(Data: TJSONObject): integer;
var
  ma, pa: string;
begin
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if writer.Locate('mail;password', VarArrayOf([ma, pa])) = true then
    result := writer.FieldByName('writerid').AsInteger
  else
    result := 0;
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
    FDQuery1.SQL.Add
      ('select COUNT(*) as count from db where magid = :id and readerid <> 0;');
    FDQuery1.ParamByName('id').AsInteger := id;
    FDQuery1.Open;
    Data.AddPair('count', FDQuery1.FieldByName('count').AsString);
  end;
end;

function TDataModule1.magid(name: string): integer;
var
  v: Variant;
begin
  v := mag.Lookup('magNum', name, 'magid');
  if VarIsNull(v) = true then
    result := 0
  else
    result := v;
end;

procedure TDataModule1.magIdOff(id, magid: integer);
begin
  if DB.Locate('readerId;magId', VarArrayOf([id, magid])) = true then
    DB.Delete;
end;

procedure TDataModule1.magIdOn(id, magid: integer);
var
  i: integer;
  v: Variant;
begin
  v := DB.Lookup('magId', magid, 'writerId');
  if VarIsNull(v) = true then
    v := 0;
  FDQuery1.Open('select MAX(serial) as ser from db;');
  i := FDQuery1.FieldByName('ser').AsInteger + 1;
  DB.AppendRecord([i, v, magid, id]);
end;

procedure TDataModule1.magListAll(id: integer; out Data: TJSONObject);
var
  js: TJSONObject;
  ar: TJSONArray;
  val: TJSONValue;
  i: integer;
  v: Variant;
begin
  mag.First;
  ar := TJSONArray.Create;
  FDQuery1.Open
    ('select magId,COUNT(*) as count from db where readerId <> 0 group by magId');
  while mag.Eof = false do
  begin
    i := mag.FieldByName('magId').AsInteger;
    v := FDQuery1.Lookup('magId', i, 'count');
    if VarIsNull(v) = true then
      v := 0;
    js := TJSONObject.Create;
    js.AddPair('magNum', mag.FieldByName('magNum').AsString);
    js.AddPair('magName', mag.FieldByName('magName').AsString);
    js.AddPair('comment', mag.FieldByName('comment').AsString);
    js.AddPair('day', mag.FieldByName('day').AsString);
    js.AddPair('lastDay', mag.FieldByName('lastDay').AsString);
    js.AddPair('count', v);
    v := DB.Lookup('magId', i, 'writerId');
    v := writer.Lookup('writerId', v, 'writer');
    if VarIsNull(v) = true then
      js.AddPair('writer', TJSONFalse.Create)
    else
      js.AddPair('writer', v);
    if (id = 0) or (DB.Locate('readerId;magid', VarArrayOf([id, i])) = false)
    then
      js.AddPair('fun', TJSONFalse.Create)
    else
      js.AddPair('fun', TJSONTrue.Create);
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

procedure TDataModule1.mainView(id: integer; out Data: TJSONObject);
begin
  Data := TJSONObject.Create;
  with FDQuery1.SQL do
  begin
    Clear;
    Add('select nagName,writer,text,day,changed from db,news,mag,writer');
    Add(' where db.newsId = news.newsId and db.magId = mag.magId and');
    Add(' db.writerId = writer.writerId and db.reader.id = :id order by day;');
  end;
  FDQuery1.ParamByName('id').AsInteger := id;
  Data := makeTable(FDQuery1);
end;

procedure TDataModule1.magazines(id: integer; out Data: TJSONObject);
var
  d: TJSONObject;
  val: TJSONValue;
  ar: TJSONArray;
begin
  ar := TJSONArray.Create;
  DB.Filter := 'writerid = ' + id.ToString + ' and readerid = 0';
  DB.Filtered := true;
  try
    DB.First;
    while DB.Eof = false do
    begin
      d := TJSONObject.Create;
      magData(DB.FieldByName('magid').AsInteger, d);
      ar.Add(d);
      DB.Next;
    end;
  finally
    DB.Filtered := false;
  end;
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
  ar := TJSONArray.Create;
  mem := TStringList.Create;
  with Sender as TFDQuery do
  begin
    First;
    while Eof = false do
    begin
      d := TJSONObject.Create;
      ar.Add(d);
      day := FieldByName('day').AsString;
      if FieldByName('changed').AsBoolean = true then
        d.AddPair('hint', Format('この記事は更新されました:(%s)日.', [day]));
      blob := CreateBlobStream(FieldByName('files'), bmRead);
      mem.LoadFromStream(blob);
      blob.Free;
      d.AddPair('magName', FieldByName('magName').AsString);
      d.AddPair('writer', FieldByName('writer').AsString);
      d.AddPair('text', mem.Text);
      d.AddPair('day', day);
      Next;
    end;
  end;
  mem.Free;
  result := TJSONObject.Create;
  result.AddPair('mag', ar);
end;

procedure TDataModule1.postMessage(id: integer; Data: TJSONObject);
var
  i: integer;
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select MAX(newsId) as id from news where magId = :id;');
  FDQuery1.ParamByName('id').AsInteger := id;
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

function TDataModule1.titleView(magid, writerId: integer;
  out Data: TJSONObject): Boolean;
var
  i: integer;
  v: Variant;
begin
  result := false;
  if writerId = 0 then
    Exit;
  v := writer.Lookup('writerId', writerId, 'writer');
  if VarIsNull(v) = true then
    v := 'no one';
  if mag.Locate('magid', magid) = true then
  begin
    Data := TJSONObject.Create;
    Data.AddPair('writer', v);
    for i := 0 to mag.Fields.Count - 1 do
      Data.AddPair(mag.Fields[i].FieldName, mag.Fields[i].AsString);
    result := true;
  end;
end;

function TDataModule1.updateReaderId(Data: TJSONObject): Boolean;
var
  na, ma, pa: string;
begin
  na := Data.Values['reader'].Value;
  ma := Data.Values['mail'].Value;
  pa := Data.Values['password'].Value;
  if reader.Locate('id', Data.Values['id'].Value.ToInteger) = true then
    with reader do
    begin
      Edit;
      FieldByName('reader').AsString := na;
      FieldByName('mail').AsString := ma;
      FieldByName('password').AsString := pa;
      Post;
      result := true;
    end
  else
    result := false;
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
