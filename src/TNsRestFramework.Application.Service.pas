unit TNsRestFramework.Application.Service;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  System.SysUtils,
  System.Types,
  System.IOUtils,
{$ELSE}
  Sysutils,
  Types,
  syncobjs,
  Quick.Files,
{$ENDIF}
{$IFNDEF MSWINDOWS}
  cthreads,
{$ENDIF}
  Quick.Commons,
  TNsRestFramework.Infrastructure.HTTPServerFactory,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestframework.Infrastructure.Config,
  TNsRestFramework.Infrastructure.Interfaces.Logger,
  TNsRestFramework.Infrastructure.Services.Logger;

type

  { TApplicationService }

  TApplicationService = class
  protected
    class procedure InitConfig(aConfig : TNsBaseConfig); virtual;
    class procedure InitLogging; virtual;
    class procedure InitControllers; virtual;
    class procedure InitServer(ListeningPort : Integer); virtual;
    class procedure ApplyConfig; virtual;
    class procedure OnConfigReloaded; virtual;
  public
    class procedure Init(ListeningPort : Integer; aConfig : TNsBaseConfig = nil); virtual;
    class procedure Stop; virtual;
  end;

implementation

{ TApplicationService }

class procedure TApplicationService.InitConfig(aConfig: TNsBaseConfig);
var
  configfilename : string;
begin
  configfilename := TPath.ChangeExtension(ParamStr(0),'config');
  if aConfig <> nil then RestFrameworkConfig := aConfig
    else RestFrameworkConfig := TNsBaseConfig.Create('',False);

  RestFrameworkConfig.Load;

  RestFrameworkConfig.Provider.OnConfigReloaded := OnConfigReloaded;
end;

class procedure TApplicationService.InitControllers;
begin
  THTTPControllerFactory.Init;
end;

class procedure TApplicationService.ApplyConfig;
begin
  Logger.SetLogConsoleConfig(RestFrameworkConfig.Logger.ConsoleLog);
  Logger.SetLogFileConfig(RestFrameworkConfig.Logger.FileLog);
  RestFrameworkConfig.Provider.ReloadIfFileChanged := RestFrameworkConfig.AutoReload;
end;

class procedure TApplicationService.Init(ListeningPort : Integer; aConfig : TNsBaseConfig = nil);
begin
  //Init
  InitConfig(aConfig);
  InitLogging;
  InitControllers;
  ApplyConfig;
  if aConfig <> nil then
  begin
    if aConfig.Port > 0 then InitServer(aConfig.Port)
    else InitServer(ListeningPort);
  end
  else
  begin
    InitServer(ListeningPort);
  end;
end;

class procedure TApplicationService.InitLogging;
begin
  TServiceLogger.Init;
end;

class procedure TApplicationService.InitServer(ListeningPort : Integer);
begin
  THTTPServerFactory.Init(ListeningPort);
  THTTPServerFactory.GetCurrent.Start;
  Logger.Info(Format('%s Server started on port %d',[GetAppName,ListeningPort]));
end;

class procedure TApplicationService.OnConfigReloaded;
begin
  Logger.Info('Config file was modified. Config will be reloaded!');
end;

class procedure TApplicationService.Stop;
begin
  //TO-DO Stop Service
  Logger.Info(GetAppName + ' Server Stopped');
end;

end.
