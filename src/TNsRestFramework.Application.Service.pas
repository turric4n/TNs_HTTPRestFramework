unit TNsRestFramework.Application.Service;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  System.SysUtils,
  System.Types,
{$ELSE}
  Sysutils,
  Types,
  syncobjs,
{$ENDIF}
{$IFNDEF MSWINDOWS}
  cthreads,
{$ENDIF}
  TNsRestFramework.Infrastructure.HTTPServerFactory,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.Services.Logger;

type

  { TApplicationService }

  TApplicationService = class
    private
      class procedure InitLogging;
      class procedure InitControllers;
      class procedure InitServer(ListeningPort : string);
    public
      class procedure Init(ListeningPort : string);
      class procedure Stop;
  end;

implementation

{ TApplicationService }

class procedure TApplicationService.InitControllers;
begin
  THTTPControllerFactory.Init;
end;

class procedure TApplicationService.Init(ListeningPort : string);
begin
  //Init
  InitLogging;
  InitControllers;
  InitServer(ListeningPort);
end;

class procedure TApplicationService.InitLogging;
begin
  TServiceLogger.Init;
  Logger.Info('TNs Server init');
end;

class procedure TApplicationService.InitServer(ListeningPort : string);
begin
  THTTPServerFactory.Init(ListeningPort);
  THTTPServerFactory.GetCurrent.Start;
end;

class procedure TApplicationService.Stop;
begin
  //TO-DO Stop Service
  Logger.Info('TNs Server Stopped');
end;

end.
