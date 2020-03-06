unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd;

type
  TWebModule1 = class(TWebModule)
    readerTop: TPageProducer;
    top: TPageProducer;
    writerTop: TPageProducer;
    writerData: TPageProducer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1readerTopAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1registAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writerTopAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModule1writeMagAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1selectionAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1writerDataAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { private éŒ¾ }
    writerId: integer;
    userId: integer;
  public
    { public éŒ¾ }
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

procedure TWebModule1.WebModule1readerTopAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  if userId = 0 then
  begin
    Handled := false;
    Exit;
  end;
  Response.ContentType := 'text/html;charset=utf-8';
  DataModule1.userView(userId, data);
  mustache := TSynMustache.Parse(readerTop.Content);
  Response.Content := mustache.RenderJSON(data.ToJSON);
end;

procedure TWebModule1.WebModule1registAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  case Request.MethodType of
    mtPOST:
      with Request.ContentFields do
      begin
        data := TJSONObject.Create;
        data.AddPair('mail', Values['mail']);
        data.AddPair('password', Values['password']);
        data.AddPair('name', Values['reader']);
        DataModule1.createReaderId(data);
        data.Free;
        Response.SendRedirect('/reader/top');
      end;
  end;
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
    mtPOST:
      DataModule1.magIdOn(userId, id);
    mtDelete:
      DataModule1.magIdOff(userId, id);
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
  WebModule1writerTopAction(Sender, Request, Response, Handled);
end;

procedure TWebModule1.WebModule1writerDataAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  if writerId > 0 then
  begin
    case Request.MethodType of
      mtPOST:
        with Request.ContentFields do
        begin
          data := TJSONObject.Create;
          data.AddPair('mail', Values['mail']);
          data.AddPair('password', Values['password']);
          data.AddPair('name', Values['writer']);
          DataModule1.createWriterId(data);
          data.Free;
        end;
      mtPut:
        begin
          data := TJSONObject.Create;
          with Request.ContentFields do
          begin
            data.AddPair('writer', Values['name']);
            data.AddPair('mail', Values['mail']);
            data.AddPair('password', Values['password']);
          end;
          DataModule1.updateWriterId(writerId, data);
          data.Free;
        end;
    end;
    data:=TJSONObject.Create;
    DataModule1.custData(writerId,data);
    Response.ContentType := 'text/html;charset=utf-8';
    mustache:=TSynMustache.Parse(writerData.Content);
    Response.Content := mustache.RenderJSON(data.ToString);
    data.Free;
  end
  else
    Handled := false;
end;

procedure TWebModule1.WebModule1writerTopAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  data: TJSONObject;
begin
  if writerId = 0 then
  begin
    Handled := false;
    Exit;
  end;
  DataModule1.magazines(writerId, data);
  Response.ContentType := 'text/html;charset=utf-8';
  mustache := TSynMustache.Parse(writerTop.Content);
  Response.Content := mustache.RenderJSON(data.Value);
  data.Free;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  userId := 1;
  writerId := 1;
end;

end.
