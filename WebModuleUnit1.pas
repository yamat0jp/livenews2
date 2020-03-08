unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd;

type
  TWebModule1 = class(TWebModule)
    readerTop: TPageProducer;
    top: TPageProducer;
    writerTop: TPageProducer;
    writerData: TPageProducer;
    backnumber: TPageProducer;
    mainView: TPageProducer;
    writerpage: TPageProducer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writeMagAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1selectionAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writerDataAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1readerDataAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1detailAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writerTopAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1loginAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1logoutAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1mainViewAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1imageAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1readerTopAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1login2Action(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writerpageAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { private êÈåæ }
    writerId: integer;
    readerId: integer;
  public
    { public êÈåæ }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

uses SynMustache, SynCommons, System.JSON, Unit1, System.NetEncoding;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

var
  mustache: TSynMustache;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  DataModule1.magListAll(readerId, data);
  if readerId = 0 then
    data.AddPair('id', TJSONFalse.Create)
  else
    data.AddPair('id', TJSONTrue.Create);
  if Request.QueryFields.Values['op'] <> '' then
    data.AddPair('comment', '2èdìoò^Ç≈Ç∑ÅBìoò^Ç…é∏îsÇµÇ‹ÇµÇΩÅB')
  else
    data.AddPair('comment', TJSONFalse.Create);
  mustache := TSynMustache.Parse(top.Content);
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := mustache.RenderJSON(data.ToJSON);
  data.Free;
end;

procedure TWebModule1.WebModule1detailAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  DataModule1.backnumber(Request.QueryFields.Values['id'], data);
  Response.ContentType := 'text/html;charset=utf-8';
  mustache := TSynMustache.Parse(backnumber.Content);
  Response.Content := mustache.RenderJSON(data.ToString);
end;

procedure TWebModule1.WebModule1imageAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  id: integer;
  data: TJSONObject;
  mem: TMemoryStream;
  raw: TBytes;
begin
  data := TJSONObject.Create;
  data.AddPair('id', TJSONNumber.Create(Request.QueryFields.Values['id']));
  data.AddPair('number', TJSONNumber.Create(Request.QueryFields.Values['num']));
  id := DataModule1.imageId(data);
  DataModule1.imageView(id, data);
  mem := TMemoryStream.Create;
  raw := TNetEncoding.Base64.DecodeStringToBytes(data.Values['data'].Value);
  mem.WriteBuffer(raw, Length(raw));
  mem.Position := 0;
  Finalize(raw);
  Response.ContentType := 'jpeg/image';
  Response.ContentStream := mem;
end;

procedure TWebModule1.WebModule1login2Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  data:=TJSONObject.Create;
  data.AddPair('mail',Request.ContentFields.Values['mail']);
  data.AddPair('password',Request.ContentFields.Values['password']);
  writerId:=DataModule1.loginWriter(data);
  Response.SendRedirect('/writer/page');
end;

procedure TWebModule1.WebModule1loginAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  data := TJSONObject.Create;
  with Request.ContentFields do
  begin
    data.AddPair('mail', Values['mail']);
    data.AddPair('password', Values['password']);
  end;
  readerId := DataModule1.loginReader(data);
  data.Free;
  Handled := false;
end;

procedure TWebModule1.WebModule1logoutAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  readerId := 0;
  writerId := 0;
  Handled := false;
end;

procedure TWebModule1.WebModule1mainViewAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  Response.ContentType := 'text/html;charset=utf-8';
  DataModule1.mainView(readerId, data);
  mustache := TSynMustache.Parse(mainView.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1readerDataAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data, d: TJSONObject;
  num: TJSONNumber;
begin
  with Request.ContentFields do
  begin
    data := TJSONObject.Create;
    data.AddPair('id', TJSONNumber.Create(readerId));
    data.AddPair('name', Values['reader']);
    data.AddPair('mail', Values['mail']);
    data.AddPair('password', Values['password']);
  end;
  case Request.MethodType of
    mtGet:
      if readerId = 0 then
      begin
        Handled := false;
        Exit;
      end;
    mtPut:
      if DataModule1.checkUserPassword(readerId, data.Values['password'].Value)
        = true then
      begin
        data.RemovePair('password');
        data.AddPair('password', Request.ContentFields.Values['new']);
        DataModule1.updateReaderId(data);
      end;
    mtPost:
      begin
        readerId := DataModule1.createReaderId(data);
        if readerId = 0 then
        begin
          Response.SendRedirect('/top?op=1#message');
          Exit;
        end;
      end;
    mtDelete:
      with Request.ContentFields do
      begin
        num := TJSONNumber.Create(readerId);
        data.AddPair('id', num);
        DataModule1.deleteReaderId(data);
        num.Free;
      end;
  end;
  data.Free;
  Response.ContentType := 'text/html;charset=utf-8';
  DataModule1.userView(readerId, data);
  DataModule1.readerData(readerId, d);
  data.AddPair('reader', d);
  mustache := TSynMustache.Parse(readerTop.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1readerTopAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  Response.ContentType := 'text/html;charset=utf-8';
  DataModule1.getView(readerId, data);
  mustache := TSynMustache.Parse(mainView.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1selectionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  id: integer;
begin
  id := DataModule1.magid(Request.ContentFields.Values['name']);
  case Request.MethodType of
    mtPost:
      DataModule1.magIdOn(readerId, id);
    mtDelete:
      DataModule1.magIdOff(readerId, id);
  end;
  Handled := false;
end;

procedure TWebModule1.WebModule1writeMagAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  data := TJSONObject.Create;
  data.AddPair('magName', Request.ContentFields.Values['name']);
  data.AddPair('comment', Request.ContentFields.Values['comment']);
  data.AddPair('day', Request.ContentFields.Values['day']);
  data.AddPair('enable', TJSONTrue.Create);
  DataModule1.createMagId(writerId, data);
  data.Free;
  Response.SendRedirect('/writer/top');
end;

procedure TWebModule1.WebModule1writerDataAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  with Request.ContentFields do
  begin
    data := TJSONObject.Create;
    data.AddPair('mail', Values['mail']);
    data.AddPair('password', Values['password']);
  end;
  case Request.MethodType of
    mtGet:
      if writerId = 0 then
      begin
        Handled := false;
        Exit;
      end;
    mtPost:
      if Request.ContentFields.Values['_method'] = 'delete' then
        DataModule1.deleteWriter(writerId)
      else if DataModule1.existsMail(data.Values['mail'].Value) = false then
      begin
        data.AddPair('name', Request.ContentFields.Values['writer']);
        if Request.ContentFields.Values['_method'] = 'put' then
          DataModule1.updateWriterId(writerId, data)
        else
          DataModule1.createWriterId(data);
      end
      else
        { ÉÅÅ[ÉãÉAÉhÉåÉXÇÃ2èdìoò^ };
    mtPut:
      DataModule1.updateWriterId(writerId, data);
    mtDelete:
      DataModule1.deleteWriter(writerId);
  end;
  data.Free;
  data := TJSONObject.Create;
  DataModule1.custData(writerId, data);
  Response.ContentType := 'text/html;charset=utf-8';
  mustache := TSynMustache.Parse(writerData.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
  data.Free;
end;

procedure TWebModule1.WebModule1writerpageAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  Response.ContentType:='text/html;charset=utf-8';
  data:=TJSONObject.Create;
  if writerId = 0 then
    data.AddPair('login',TJSONFalse.Create)
  else
    data.AddPair('login',TJSONTrue.Create);
  mustache:=TSynMustAche.Parse(writerpage.Content);
  Response.Content:=mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1writerTopAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  data := TJSONObject.Create;
  DataModule1.magazines(writerId, data);
  Response.ContentType := 'text/html;charset=utf-8';
  mustache := TSynMustache.Parse(writerTop.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
  data.Free;
end;

end.
