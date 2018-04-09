unit TNsRestFramework.Infrastructure.HTTPController;

interface

uses
  SynCommons,
  SynCrtSock,
  System.IOUtils,
  System.SysUtils,
  System.Generics.Collections,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRequest,
  TNsRestFramework.Infrastructure.HTTPRouting;

type
  IController = interface ['{7D4ECE7A-4B07-4AB3-908C-A6F7F04C44D5}']
    function GetRoute : THTTPRoute;
    function ProcessRequest(Request : THTTPRestRequest) : Cardinal;
    function IsDefaultController : Boolean;
  end;

  IStaticController = interface ['{5002A4F4-EE7D-4980-854C-FBC1300D9762}']
    function CanIHandleThis(const Filename : string) : Boolean;
  end;

  THTTPController = class(TInterfacedObject, IController)
    protected
      fisdefault : Boolean;
      frequest : THTTPRestRequest;
      froute : THTTPRoute;
    public
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; virtual; abstract;
      function GetRoute : THTTPRoute;
      function IsDefaultController : Boolean;
  end;

  THTTPStaticController = class(THTTPController, IStaticController)
    protected
      fstaticextensions : TDictionary<string,string>;
      fstaticdirectory : string;
    public
      function CanIHandleThis(const Filename : String) : Boolean; virtual; abstract;
  end;

implementation

{ TMVCController }

function THTTPController.GetRoute: THTTPRoute;
begin
  Result := froute;
end;

function THTTPController.IsDefaultController: Boolean;
begin
  Result := fisdefault;
end;


end.
