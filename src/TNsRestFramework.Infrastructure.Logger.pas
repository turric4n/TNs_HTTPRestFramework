unit TNsRestFramework.Infrastructure.Logger;

interface

uses
  Quick.Logger,
  Quick.Logger.Provider.Files,
  Quick.Logger.Provider.Console,
  {$IFNDEF FPC}
  Quick.Logger.ExceptionHook
  {$ENDIF}
  ;

type
  ILogger = interface['{6A46B7B0-17C1-4855-B48F-477AE6EBF8FD}']
    procedure Log(const Line : string; Error : Boolean);
    {$IFNDEF FPC}
    function Providers : TLogProviderList;
    {$ENDIF}
  end;

  { TLogger }

  TLogger = class(TInterfacedObject, ILogger)
    public
      constructor Create;
      procedure Log(const Line : string; Error : Boolean);
      {$IFNDEF FPC}
      function Providers : TLogProviderList;
      {$ENDIF}
  end;

implementation

{ TLogger }

constructor TLogger.Create;
begin
  //Configure provider options
  with GlobalLogFileProvider do
  begin
    FileName := 'RemotePublishAPI.log';
    DailyRotate := False;
    MaxRotateFiles := 5;
    MaxFileSizeInMB := 200;
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

procedure TLogger.Log(const Line: string; Error: Boolean);
begin
  if error then Logger.Add(Line, etError)
  else Logger.Add(Line, etInfo);
end;

function TLogger.Providers: TLogProviderList;
begin
  Result := Logger.Providers;
end;



end.
