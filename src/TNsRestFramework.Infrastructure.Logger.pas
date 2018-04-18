unit TNsRestFramework.Infrastructure.Logger;

interface

uses
  {$IFNDEF FPC}
  Quick.Logger,
  Quick.Logger.Provider.Files,
  Quick.Logger.Provider.Console;
  {$ELSE}
  SynCommons,
  SynLog;
  {$ENDIF}

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

{$IFNDEF FPC}
constructor TLogger.Create;
begin
  //Add Log File and console providers
  Logger.Providers.Add(GlobalLogFileProvider);
  Logger.Providers.Add(GlobalLogConsoleProvider);
  //Configure provider options
  with GlobalLogFileProvider do
  begin
    FileName := '.\HTTPServer.log';
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

{$ELSE}


constructor TLogger.Create;
var
  i : Integer;
begin
  i := 1; // we need this to circumvent the FPC compiler :)
  // first, set the TSQLLog family parameters
  with TSynLog.Family do begin
    Level := LOG_VERBOSE;
    EchoToConsole := LOG_VERBOSE;
    //PerThreadLog := true;
    //HighResolutionTimeStamp := true;
    //AutoFlushTimeOut := 5;
    //OnArchive := EventArchiveZip;
  end;
end;

procedure TLogger.Log(const Line: string; Error: Boolean);
begin
  if error then TSynLog.Add.Log(sllStackTrace,Line)
  else TSynLog.Add.Log(sllInfo,Line);
end;

{$ENDIF}


end.
