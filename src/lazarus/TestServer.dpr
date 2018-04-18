program TestServer;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$APPTYPE CONSOLE}

{$R *.res}

uses
{$IFnDEF FPC}
  System.SysUtils,
{$ELSE}
  SysUtils,
{$ENDIF}
  TNsRestFramework.Application.Service,
  TTestServer.Controllers;

begin
  try
    TApplicationService.Init('6060');
    Writeln('HTTP Server is listening at port 6060. Press a Key to stop service');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
