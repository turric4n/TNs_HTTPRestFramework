unit TNsRestFramework.Application.SumController;

interface

uses
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController,
  System.SysUtils,
  System.Classes;

type
  TRestSumController = class(THTTPController)
    public
      constructor Create;
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
  end;

implementation

var
  SumController : TRestSumController;


{ TRestSumController }

constructor TRestSumController.Create;
begin
  fisdefault := True;
  froute := THTTPRoute.Create;
  froute.Name := 'sum';
  froute.IsDefault := True;
  froute.RelativePath := 'sum';
  froute.Methods := ['GET', 'POST'];
end;

function TRestSumController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
var
  x : Integer;
  y : Integer;
  sum : Integer;
begin
  sum := 0;
  for x := 1 to High(Request.Parameters) do
  begin
    if TryStrToInt(Request.Parameters[x], y) then sum := sum + y;
  end;
  Request.HTTPContext.OutContent := IntToStr(sum);
end;

initialization
  SumController := TRestSumController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(SumController);
end.
