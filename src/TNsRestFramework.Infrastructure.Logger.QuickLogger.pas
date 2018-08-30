unit TNsRestFramework.Infrastructure.Logger.QuickLogger;

interface

//Uses QuickLogger and QuickLib from my fellow Exilon. You need to grab from here : https://github.com/exilon/QuickLogger and https://github.com/exilon/QuickLib

uses
  TNsRestFramework.Infrastructure.Interfaces.Logger,
  {$IFNDEF FPC}
  Quick.Logger.ExceptionHook,
  {$ENDIF}
  Quick.Logger,
  Quick.Logger.Provider.Files,
  Quick.Logger.Provider.Console;

type

  { TQuickLogger }

  TQuickLogger = class(TInterfacedObject, ILogger)
  public
    constructor Create;
    procedure Info(const Line : string); overload;
    procedure Info(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    procedure Error(const Line : string); overload;
    procedure Error(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    procedure Warning(const Line : string); overload;
    procedure Warning(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    procedure Success(const Line : string); overload;
    procedure Success(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    procedure Critical(const Line : string); overload;
    procedure Critical(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    procedure Debug(const Line : string); overload;
    procedure Debug(const Line : string; Values : array of {$IFDEF FPC}const{$ELSE}TVarRec{$ENDIF}); overload;
    {$IFNDEF FPC}
    function Providers : TLogProviderList;
    {$ENDIF}
    procedure SetRotation(aRotationSizeInMB: Integer; aRotateEveryDay: Boolean; aMaxRotatedFiles: Integer; const aRotationFolder : string);
    procedure SetLogLevel(aLevel : TNsLogLevel);
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
    Enabled := True;
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

procedure TQuickLogger.Info(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etInfo);
end;

procedure TQuickLogger.SetLogLevel(aLevel: TNsLogLevel);
var
  loglevel : TLogLevel;
begin
  case aLevel of
    lvBASIC : loglevel := LOG_BASIC;
    lvONLYERRORS : loglevel := LOG_ONLYERRORS;
    lvALL : loglevel := LOG_ALL;
  end;
  GlobalLogFileProvider.LogLevel := loglevel;
  GlobalLogConsoleProvider.LogLevel := loglevel;
end;

procedure TQuickLogger.SetRotation(aRotationSizeInMB: Integer; aRotateEveryDay: Boolean; aMaxRotatedFiles: Integer; const aRotationFolder : string);
begin
  GlobalLogFileProvider.MaxFileSizeInMB := aRotationSizeInMB;
  GlobalLogFileProvider.DailyRotate := aRotateEveryDay;
  GlobalLogFileProvider.MaxRotateFiles := aMaxRotatedFiles;
  GlobalLogFileProvider.RotatedFilesPath := aRotationFolder;
end;

procedure TQuickLogger.Success(const Line: string; Values: array of TVarRec);
begin
  Logger.Add(Line,Values,TEventType.etSuccess);
end;

procedure TQuickLogger.Warning(const Line: string; Values: array of const);
begin
  Logger.Add(Line,Values,TEventType.etWarning);
end;

end.
