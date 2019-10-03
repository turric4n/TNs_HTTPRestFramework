unit TNsRestFramework.Infrastructure.Config;

interface

uses
  Classes,
  SysUtils,
  {$IFDEF FPC}
  Generics.Collections,
  fpjson,
  Quick.Files,
  {$ELSE}
  System.Generics.Collections,
  System.IOUtils,
  {$ENDIF}
  Quick.Config.Json,
  Quick.Logger;

type

  { TBaseConfig }

  TConsoleLogConfig = record
    LogLevel : TLogLevel;
    Enabled : Boolean;
  end;

  TFileLogConfig = record
    LogLevel : TLogLevel;
    FileName : string;
    RotateSizeInMB : Integer;
    RotateEveryDay : Boolean;
    MaxRotatedFiles : Integer;
    RotationFolder : string;
    Enabled : Boolean;
  end;

  TLoggerConfig = record
    ConsoleLog : TConsoleLogConfig;
    FileLog : TFileLogConfig;
  end;

  TNsBaseConfig = class(TAppConfigJson)
  private
    fHost : string;
    fPort : Integer;
    fLogger : TLoggerConfig;
    fAutoReload : Boolean;
  public
    procedure DefaultValues; override;
    property Logger : TLoggerConfig read fLogger write fLogger;
  published
    property Host : string read fHost write fHost;
    property Port : Integer read fPort write fPort;
    property AutoReload : Boolean read fAutoReload write fAutoReload;
  end;

  TNsConfigClass = class of TNsBaseConfig;

var

  RestFrameworkConfig : TNsBaseConfig;


implementation

{ TNsBaseConfig }

procedure TNsBaseConfig.DefaultValues;
begin
  inherited;
  Host := '127.0.0.1';
  Port := 8580;
  fLogger.ConsoleLog.LogLevel := LOG_ALL;
  fLogger.ConsoleLog.Enabled := True;
  
  fLogger.FileLog.LogLevel := LOG_ALL;
  fLogger.FileLog.FileName := TPath.ChangeExtension(ParamStr(0),'log');
  fLogger.FileLog.MaxRotatedFiles := 10;
  fLogger.FileLog.RotateSizeInMB := 20;
  fLogger.FileLog.RotateEveryDay := False;
  fLogger.FileLog.RotationFolder := 'logs';
  fLogger.FileLog.Enabled := True;

  fAutoReload := False;
end;

end.

