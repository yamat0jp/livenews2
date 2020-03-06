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
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
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

uses SynMustache, SynCommons, System.JSON, Unit1;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

var
  mustache: TSynMustache;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  DataModule1.magListAll(data);
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
  DataModule1.backnumber(Request.QueryFields.Values['id'].ToInteger, data);
  Response.ContentType := 'text/html;charset=utf-8';
  mustache := TSynMustache.Parse(backnumber.Content);
  Response.Content := mustache.RenderJSON(data.ToString);
end;

procedure TWebModule1.WebModule1readerDataAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
  num: TJSONNumber;
begin
  with Request.ContentFields do
  begin
    data := TJSONObject.Create;
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
        DataModule1.updateReaderId(data);
    mtPost:
      DataModule1.createReaderId(data);
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
  mustache := TSynMustache.Parse(readerTop.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1selectionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  id: integer;
begin
  id := DataModule1.magid(Request.ContentFields.Values['name']);
  case Request.MethodType of
    mtGet:
      Handled := false;
    mtPost:
      DataModule1.magIdOn(readerId, id);
    mtDelete:
      DataModule1.magIdOff(readerId, id);
  end;
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
      else
      begin
        data.AddPair('name', Request.ContentFields.Values['writer']);
        if Request.ContentFields.Values['_method'] = 'put' then
          DataModule1.updateWriterId(writerId, data)
        else
          DataModule1.createWriterId(data);
      end;
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

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  readerId := 1;
  writerId := 1;
end;

end.
