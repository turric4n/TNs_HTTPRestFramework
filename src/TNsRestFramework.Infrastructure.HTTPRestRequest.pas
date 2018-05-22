unit TNsRestFramework.Infrastructure.HTTPRestRequest;

interface

uses
  {$IFNDEF FPC}
  System.SysUtils,
  System.Classes,
  {$ELSE}
  Sysutils,
  Classes,
  {$ENDIF}
  IdHTTPServer,
  IdContext,
  IdCustomHTTPServer,
  TNsRestFramework.Infrastructure.HTTPRequest;

type
  THTTPRestRequest = class(THTTPRequest)
    private
      fcontext : TIdContext;
      fincontent : string;
      fRequestInfo : TIdHTTPRequestInfo;
      fResponseInfo : TIdHTTPResponseInfo;
    public
      constructor Create(aContext : TIdContext; aRequestInfo : TIdHTTPRequestInfo; aResponseInfo : TIdHTTPResponseInfo);
      property HTTPContext : TIdContext read fcontext write fcontext;
      property RequestInfo : TIdHTTPRequestInfo read fRequestInfo write fRequestInfo;
      property ResponseInfo : TIdHTTPResponseInfo read fResponseInfo write fResponseInfo;
      property InContent : string read FInContent;
  end;

implementation

{ TIRespository }

constructor THTTPRestRequest.Create(aContext : TIdContext; aRequestInfo : TIdHTTPRequestInfo; aResponseInfo : TIdHTTPResponseInfo);
var
  stringstream : TStringStream;
begin
  fRequestInfo := aRequestInfo;
  fResponseInfo := aResponseInfo;
  fcontext := aContext;
  if Assigned(aRequestInfo.PostStream) then
  begin
    {$IFNDEF FPC}
    stringstream := TStringStream.Create;
    {$ELSE}
    stringstream := TStringStream.Create('');
    {$ENDIF}
    try
      stringstream.CopyFrom(aRequestInfo.PostStream, aRequestInfo.PostStream.Size);
      fincontent := stringstream.DataString;
    finally
      stringstream.Free;
    end;
  end;
  fparameters := string(fRequestInfo.URI).Substring(1).Split(['/']);
  if Length(fparameters) = 0 then
  begin
    SetLength(fparameters, 1);
    fparameters[0] := '/';
  end;
  fmethod := fRequestInfo.Command;
  BruteURL := fRequestInfo.URI;
end;

end.

