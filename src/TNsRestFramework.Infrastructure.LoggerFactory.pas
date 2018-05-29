unit TNsRestFramework.Infrastructure.LoggerFactory;

interface

uses
  {$IFNDEF FPC}
  System.SyncObjs,
  System.SysUtils,
  {$ELSE}
  Sysutils,
  {$ENDIF}
  TNsRestFramework.Infrastructure.Interfaces.Logger,
  TNsRestFramework.Infrastructure.Logger.QuickLogger;

type
  TLoggerFactory = class
  public
    class function CreateLogger : ILogger;
  end;

implementation

{ TLoggerFactory }

class function TLoggerFactory.CreateLogger : ILogger;
begin
  Result := TQuickLogger.Create;
end;

end.

