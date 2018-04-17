unit TNsRestFramework.Infrastructure.HTTPServer;

interface

uses
  System.SysUtils,
  SynCrtSock,
  SynCommons,
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
      fhttpserver : THttpServer;
      function ProcessRequest(Ctxt: THttpServerRequest) : Cardinal;
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
  fhttpserver := THttpServer.Create(Port, nil, nil, 'CDI', 32);
  fhttpserver.OnRequest := ProcessRequest;
end;

destructor TCustomHTTPServer.Destroy;
begin
  fhttpserver.Free;
end;

function TCustomHTTPServer.ProcessRequest(Ctxt: THttpServerRequest): Cardinal;
var
  controller : IController;
  request : THTTPRestRequest;
begin
  request := THTTPRestRequest.Create(Ctxt);
  try
    try
      Result := THTTPControllerFactory.GetInstance.GetCurrentController(request).ProcessRequest(request);
    except
      on e : Exception do
      begin
        TLoggerFactory.GetInstance.Log(e.Message, True);
        Ctxt.OutContentType := 'text/plain';
        Ctxt.OutContent := e.Message;
        Result := 404;
      end;
    end;
  finally
    request.Free;
  end;
end;

procedure TCustomHTTPServer.Start;
begin
  //
end;

procedure TCustomHTTPServer.Stop;
begin
  //
end;

end.
