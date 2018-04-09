unit TNsRestFramework.Infrastructure.HTTPRestRequest;

interface

uses
  System.SysUtils,
  SynCommons,
  SynCrtSock,
  TNsRestFramework.Infrastructure.HTTPRequest;

type
  THTTPRestRequest = class(THTTPRequest)
    private
      fcontext : THttpServerRequest;
    public
      constructor Create(HTTPServerRequest : THttpServerRequest);
      property HTTPContext : THttpServerRequest read fcontext write fcontext;
  end;

implementation

{ TIRespository }

constructor THTTPRestRequest.Create(HTTPServerRequest : THttpServerRequest);
begin
  fcontext := HTTPServerRequest;
  fparameters := string(fcontext.URL).Substring(1).Split(['/']);
  if Length(fparameters) = 0 then
  begin
    SetLength(fparameters, 1);
    fparameters[0] := '/';
  end;
  fmethod := fcontext.Method;
  BruteURL := fcontext.URL;
end;

end.

