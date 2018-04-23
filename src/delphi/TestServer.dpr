program TestServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
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
