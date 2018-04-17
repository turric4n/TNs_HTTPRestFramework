unit TNsRestFramework.Infrastructure.HTTPRouting;

interface

uses
  SynCommons,
  {$IFNDEF FPC}
    System.Generics.Collections,
    System.JSON.Serializers,
    System.SysUtils;
  {$ELSE}
    {$M+}
    sysutils,
    fgl;
  {$ENDIF}

type
  THTTPRoute = class
    private
      fcontrollername: string;
      fneedStaticController: Boolean;
      fstaticfilepath : string;
      frelativepath: string;
      {$IFNDEF FPC}
      fmethod : TArray<string>;
      {$ELSE}
      fmethod : TFPGList<string>;
      {$ENDIF}
      fisdefault: Boolean;
      procedure SetStaticFilePath(const Value: string);
    published
      property Name : string read fcontrollername write fcontrollername;
      property IsDefault : Boolean read fisdefault write fisdefault;
      property RelativePath : string read frelativepath write frelativepath;
      property needStaticController : Boolean read fneedStaticController write fneedStaticController;
      property Methods : TArray<string> read fmethod write fmethod;
      function isValidMethod(const Method : string) : Boolean;
  end;

implementation

procedure THTTPRoute.SetStaticFilePath(const Value: string);
begin
  fstaticfilepath := IncludeTrailingBackslash(Value);
end;

function THTTPRoute.isValidMethod(const Method: string): Boolean;
var
  str : string;
begin
  for str in Methods do
  begin
    Result := str = Method;
    if Result then Break;
  end;
end;

end.

