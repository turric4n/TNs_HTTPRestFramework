unit TNsRestFramework.Application.SumController;

interface

uses
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController,
  TNsRestFramework.Infrastructure.LoggerFactory,
  {$IFNDEF FPC}
  System.SysUtils,
  System.Classes;
  {$ELSE}
  SysUtils,
  Classes;
  {$ENDIF}

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
  inherited;
  fisdefault := True;
  froute.Name := 'sum';
  froute.IsDefault := True;
  froute.RelativePath := 'sum';
  froute.AddMethod('GET');
  froute.AddMethod('POST');
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
  Result := 200;
  Request.HTTPContext.OutContent := IntToStr(sum);
end;

initialization
  SumController := TRestSumController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(SumController);
end.
