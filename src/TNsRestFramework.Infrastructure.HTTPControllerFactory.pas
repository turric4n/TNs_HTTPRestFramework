unit TNsRestFramework.Infrastructure.HTTPControllerFactory;

interface

uses
  {$IFNDEF FPC}
  System.SysUtils,
  System.Generics.Collections,
  {$ELSE}
  Sysutils,
  fgl,
  {$ENDIF}
  TNsRestFramework.Infrastructure.HTTPController,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPRestRequest;

type
  IHTTPControllerHandler = interface['{8E24401C-372C-4255-AE34-51FC06DB8212}']
    {$IFNDEF FPC}
    function GetControllers : TList<IController>;
    {$ELSE}
    function GetControllers : TFPGList<IController>;
    {$ENDIF}
    function GetCurrentController(Request : THTTPRestRequest) : IController;
    procedure Add(Controller : IController);
    procedure Remove(Controller : IController);
  end;

  THTTPControllerHandler = class(TInterfacedObject, IHTTPControllerHandler)
    private
      {$IFNDEF FPC}
      fcontrollers : TList<IController>;
      {$ELSE}
      fcontrollers : TFPGList<IController>;
      {$ENDIF}
    public
      constructor Create;
      function GetCurrentController(Request : THTTPRestRequest) : IController;
      {$IFNDEF FPC}
      function GetControllers : TList<IController>;
      {$ELSE}
      function GetControllers : TFPGList<IController>;
      {$ENDIF}
      procedure Add(Controller : IController);
      procedure Remove(Controller : IController);
  end;

  THTTPControllerFactory = class
    private
      fhttpcontrollerhandler : IHTTPControllerHandler;
      constructor Create;
    public
      class procedure Init;
      class function GetFactory : THTTPControllerFactory;
      class function GetInstance : IHTTPControllerHandler;
  end;

implementation

var
  HTTPControllerFactory : THTTPControllerFactory;

constructor THTTPControllerFactory.Create;
begin
  fhttpcontrollerhandler := THTTPControllerHandler.Create;
end;


class function THTTPControllerFactory.GetFactory: THTTPControllerFactory;
begin
  if not Assigned(HTTPControllerFactory) then raise Exception.Create('HTTPControllerFactory not assigned!');
  Result := HTTPControllerFactory;
end;

class function THTTPControllerFactory.GetInstance : IHTTPControllerHandler;
begin
  if Assigned(HTTPControllerFactory) then
  Result := HTTPControllerFactory.fhttpcontrollerhandler;
end;

class procedure THTTPControllerFactory.Init;
begin
  if not Assigned(HTTPControllerFactory) then
  HTTPControllerFactory := THTTPControllerFactory.Create;
end;

{ THTTPControllerHandler }

procedure THTTPControllerHandler.Add(Controller: IController);
begin
  fcontrollers.Add(Controller);
end;

constructor THTTPControllerHandler.Create;
begin
  {$IFNDEF FPC}
  fcontrollers := TList<IController>.Create;
  {$ELSE}
  fcontrollers := TFPGList<IController>.Create;
  {$ENDIF}
end;

{$IFNDEF FPC}
function THTTPControllerHandler.GetControllers: TList<IController>;
begin
  Result := fcontrollers;
end;
{$ELSE}
function THTTPControllerHandler.GetControllers: TFPGList<IController>;
begin
  Result := fcontrollers;
end;
{$ENDIF}

function THTTPControllerHandler.GetCurrentController(Request : THTTPRestRequest) : IController;
var
  controller : IController;
  defaultcontroller : IController;
  route : THTTPRoute;
begin
  result := nil;
  defaultcontroller := nil;
  for controller in fcontrollers do
  begin
    route := controller.GetRoute;
    if controller.IsDefaultController then defaultcontroller := controller;
    if (route.RelativePath = '/') and (Request.Parameters[0] = '/') and (route.isValidMethod(Request.Method)) then
    begin
      Result := controller;
      Exit;
    end
    // Si el controlador se come / hay que mirar si puede servir esa extensión (solo en raíz!!!!)
    else if (Length(Request.Parameters) = 1) and (Supports(controller, IStaticController)) then
    begin
      if (controller as IStaticController).CanIHandleThis(Request.Parameters[Length(Request.Parameters) - 1]) then Result := controller      
    end
    else 
    begin
      if (string.CompareText(Request.Parameters[0], route.RelativePath) = 0) and (route.isValidMethod(Request.Method)) then
      begin
        Result := Controller;
        Exit;
      end;
    end;
  end;
  if Result = nil then raise Exception.Create('No controller found');
end;

procedure THTTPControllerHandler.Remove(Controller: IController);
begin
  fcontrollers.Remove(Controller);
end;

initialization
  HTTPControllerFactory := nil;

finalization
  if Assigned(HTTPControllerFactory) then HTTPControllerFactory.Free;
end.
