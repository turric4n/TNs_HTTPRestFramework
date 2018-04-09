unit TNsRestFramework.Infrastructure.HTTPControllerFactory;

interface

uses
  System.SysUtils,
  TNsRestFramework.Infrastructure.HTTPController,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  System.Generics.Collections;

type
  IHTTPControllerHandler = interface['{8E24401C-372C-4255-AE34-51FC06DB8212}']
    function GetControllers : TList<IController>;
    function GetCurrentController(Request : THTTPRestRequest) : IController;
    procedure Add(Controller : IController);
    procedure Remove(Controller : IController);
  end;

  THTTPControllerHandler = class(TInterfacedObject, IHTTPControllerHandler)
    private
      fcontrollers : TList<IController>;
    public
      constructor Create;
      function GetCurrentController(Request : THTTPRestRequest) : IController;
      function GetControllers : TList<IController>;
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
  if Assigned(HTTPControllerFactory) then
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
  fcontrollers := TList<IController>.Create;
end;

function THTTPControllerHandler.GetControllers: TList<IController>;
begin
  Result := fcontrollers;
end;

function THTTPControllerHandler.GetCurrentController(Request : THTTPRestRequest) : IController;
var
  controller : IController;
  defaultcontroller : IController;
  route : THTTPRoute;
  methodurl : string;
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
      if (Request.Parameters[0] = route.RelativePath) and (route.isValidMethod(Request.Method)) then
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
