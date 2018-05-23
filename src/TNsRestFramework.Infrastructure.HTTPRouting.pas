unit TNsRestFramework.Infrastructure.HTTPRouting;

interface

uses
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

  { THTTPRoute }

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
      {$IFNDEF FPC}
      property Methods : TArray<string> read fmethod write fmethod;
      {$ELSE}
      property Methods : TFPGList<string> read fmethod write fmethod;
      {$ENDIF}
      procedure SetStaticFilePath(const Value: string);
    published
      property Name : string read fcontrollername write fcontrollername;
      property IsDefault : Boolean read fisdefault write fisdefault;
      property RelativePath : string read frelativepath write frelativepath;
      property needStaticController : Boolean read fneedStaticController write fneedStaticController;
      constructor Create;
      destructor Destroy; override;
      procedure AddMethod(const Method : string);
      function isValidMethod(const Method : string) : Boolean;
  end;

implementation

procedure THTTPRoute.SetStaticFilePath(const Value: string);
begin
  fstaticfilepath := IncludeTrailingPathDelimiter(Value);
end;

constructor THTTPRoute.Create;
begin
  {$IFDEF FPC}
     Methods := TFPGList<string>.Create;
  {$ENDIF}
end;

destructor THTTPRoute.Destroy;
begin
  {$IFDEF FPC}
     Methods.Free;
  {$ENDIF}
end;

procedure THTTPRoute.AddMethod(const Method: string);
begin
  {$IFNDEF FPC}
  Methods := Methods + [Method];
  {$ELSE}
  Methods.Add(Method);
  {$ENDIF}
end;

function THTTPRoute.isValidMethod(const Method: string): Boolean;
var
  str : string;
begin
  Result := False;
  for str in Methods do
  begin
    Result := str = Method;
    if Result then Break;
  end;
end;

end.

