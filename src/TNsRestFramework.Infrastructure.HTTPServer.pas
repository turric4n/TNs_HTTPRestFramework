unit TNsRestFramework.Infrastructure.HTTPServer;

interface

uses
  {$IFNDEF FPC}
  System.SysUtils,
  {$ELSE}
  sysutils,
  {$ENDIF}
  IdHTTPServer,
  IdContext,
  IdCustomHTTPServer,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPController,
  TNsRestFramework.Infrastructure.LoggerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest;

type
  ICustomHTTPServer = interface['{C37325D0-6014-42C1-8E13-DBD29338D67E}']
    procedure Start;
    procedure Stop;
  end;

  TCustomHTTPServer = class(TInterfacedObject, ICustomHTTPServer)
    private
      fhttpserver : TIdHTTPServer;
      procedure ProcessRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    public
      procedure Start;
      procedure Stop;
      constructor Create(const Port : string);
      destructor Destroy;
  end;

implementation

{ TCustomHTTPServer }

constructor TCustomHTTPServer.Create(const Port : string);
begin
  fhttpserver := TIdHTTPServer.Create(nil);
  fhttpserver.DefaultPort := Port.ToInteger;
  fhttpserver.ServerSoftware := 'Test server';
  fhttpserver.OnCommandGet := ProcessRequest;
end;

destructor TCustomHTTPServer.Destroy;
begin
  fhttpserver.Free;
end;

procedure TCustomHTTPServer.ProcessRequest(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  controller : IController;
  request : THTTPRestRequest;
begin
  request := THTTPRestRequest.Create(AContext,ARequestInfo,AResponseInfo);
  try
    try
      AResponseInfo.ResponseNo := THTTPControllerFactory.GetInstance.GetCurrentController(request).ProcessRequest(request);
    except
      on e : Exception do
      begin
        TLoggerFactory.GetInstance.Log(e.Message, True);
        AResponseInfo.ContentType := 'text/plain';
        AResponseInfo.ContentText := e.Message;
        AResponseInfo.ResponseNo := 404;
      end;
    end;
  finally
    request.Free;
  end;
end;

procedure TCustomHTTPServer.Start;
begin
  Self.fhttpserver.Active := True;
end;

procedure TCustomHTTPServer.Stop;
begin
  Self.fhttpserver.Active := False;
end;

end.
