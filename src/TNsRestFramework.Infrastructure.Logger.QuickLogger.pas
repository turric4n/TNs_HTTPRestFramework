unit TNsRestFramework.Infrastructure.Logger.QuickLogger;

interface

//Uses QuickLogger and QuickLib from my fellow Exilon. You need to grab from here : https://github.com/exilon/QuickLogger and https://github.com/exilon/QuickLib

uses
  SysUtils,
  TNsRestFramework.Infrastructure.Interfaces.Logger,
  {$IFNDEF FPC}
  Quick.Logger.UnhandledExceptionHook,
  System.Generics.Collections,
  {$ENDIF}
  Quick.Logger,
  Quick.Logger.Provider.Files,
  Quick.Logger.Provider.Console,
  TNsRestFramework.Infrastructure.Config;

type

  { TQuickLogger }

  TQuickLogger = class(TInterfacedObject, ILogger)
  private
    procedure SetLogConsoleConfig(aConfig : TConsoleLogConfig);
    procedure SetLogFileConfig(aConfig : TFileLogConfig);
  public
    constructor Create;
    procedure Info(const Line : string); overload;
    procedure Info(const Line : string; Values : array of const); overload;
    procedure Error(const Line : string); overload;
    procedure Error(const Line : string; Values : array of const); overload;
    procedure Warning(const Line : string); overload;
    procedure Warning(const Line : string; Values : array of const); overload;
    procedure Success(const Line : string); overload;
    procedure Success(const Line : string; Values : array of const); overload;
    procedure Critical(const Line : string); overload;
    procedure Critical(const Line : string; Values : array of const); overload;
    procedure Debug(const Line : string); overload;
    procedure Debug(const Line : string; Values : array of const); overload;
    function Providers : TLogProviderList;
    function GetProviderByName(const aName : string) : TLogProviderBase;
  end;

implementation

{ TLogger }

constructor TQuickLogger.Create;
begin
  //Configure provider options
  with GlobalLogFileProvider do
  begin
    DailyRotate := False;
    MaxRotateFiles := 5;
    MaxFileSizeInMB := 20;
    LogLevel := LOG_ALL;
    Enabled := False;
  end;
  with GlobalLogConsoleProvider do
  begin
    LogLevel := LOG_DEBUG;
    ShowEventColors := True;
    Enabled := True;
  end;
  //Add Log File and console providers
  Logger.Providers.Add(GlobalLogFileProvider);
  Logger.Providers.Add(GlobalLogConsoleProvider);
  Logger.RedirectOwnErrorsToProvider := GlobalLogFileProvider;
  Logger.WaitForFlushBeforeExit := 30;
end;

procedure TQuickLogger.Info(const Line: string);
begin
  Logger.Add(Line, TEventType.etInfo);
end;

procedure TQuickLogger.Error(const Line: string);
begin
  Logger.Add(Line,TEventType.etError);
end;

procedure TQuickLogger.Warning(const Line: string);
begin
  Logger.Add(Line,TEventType.etWarning);
end;

procedure TQuickLogger.Success(const Line: string);
begin
  Logger.Add(Line,TEventType.etSuccess);
end;

procedure TQuickLogger.Critical(const Line: string);
begin
  Logger.Add(Line,TEventType.etCritical);
end;

procedure TQuickLogger.Debug(const Line: string);
begin
  Logger.Add(Line,TEventType.etDebug);
end;

procedure TQuickLogger.Critical(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etCritical);
end;

procedure TQuickLogger.Debug(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etDebug);
end;

procedure TQuickLogger.Error(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etError);
end;

function TQuickLogger.GetProviderByName(const aName: string): TLogProviderBase;
var
  provider : ILogProvider;
begin
  for provider in Logger.Providers do
  begin
    if CompareText(provider.GetName.ToLower,aName.ToLower) = 0 then Exit(TLogProviderBase(provider));
  end;
end;

procedure TQuickLogger.Info(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etInfo);
end;

procedure TQuickLogger.SetLogLevel(aLevel: TNsLogLevel);
var
  loglevel : TLogLevel;
begin
  Logger.Add(Line,Values,TEventType.etSuccess);
end;

procedure TQuickLogger.Warning(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etWarning);
end;

procedure TQuickLogger.Success(const Line: string; Values: array of TVarRec);
begin
  Result := Logger.Providers;
end;

procedure TQuickLogger.SetLogConsoleConfig(aConfig: TConsoleLogConfig);
begin
  GlobalLogConsoleProvider.LogLevel := aConfig.LogLevel;
  GlobalLogConsoleProvider.Enabled := aConfig.Enabled;
end;

procedure TQuickLogger.SetLogFileConfig(aConfig: TFileLogConfig);
begin
  GlobalLogFileProvider.FileName := aConfig.FileName;
  GlobalLogFileProvider.MaxFileSizeInMB := aConfig.RotateSizeInMB;
  GlobalLogFileProvider.DailyRotate := aConfig.RotateEveryDay;
  GlobalLogFileProvider.MaxRotateFiles := aConfig.MaxRotatedFiles;
  GlobalLogFileProvider.RotatedFilesPath := aConfig.RotationFolder;
  GlobalLogFileProvider.LogLevel := aConfig.LogLevel;
  GlobalLogFileProvider.Enabled := aConfig.Enabled;
end;


end.
