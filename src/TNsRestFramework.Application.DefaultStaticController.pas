unit TNsRestFramework.Application.DefaultStaticController;

interface

uses
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController,
  {$IFNDEF FPC}
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;
  {$ELSE}
  Classes,
  fgl,
  sysutils;
  {$ENDIF}

type
  TRestDefaultStaticController = class(THTTPStaticController)
    private
      procedure InitStaticTypes;
      function GetContentType(const strFile : string) : string;
      function GetFilePath(Request : THTTPRestRequest) : string;
      function ReturnFile(const Path : string; Request : THTTPRestRequest) : Cardinal;
    public
      constructor Create;
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
      function CanIHandleThis(const Filename : String) : Boolean; override;
  end;

var
  DefaultStaticController : IController;

const
  STATICTYPES = '.jpg:image/jpeg,.png:image/png,.ico:image/x-icon,.html:text/html,.css:text/css,.js:application/javascript';

implementation

{ TMVCDefaultController }

function TRestDefaultStaticController.CanIHandleThis(const Filename: String): Boolean;
var
  ext, dta : string;
  a : Integer;
begin
  ext := string(Filename).Substring(Filename.LastIndexOf('.'));
  {$IFNDEF FPC}
  Result := fstaticextensions.ContainsKey(ext);
  {$ELSE}
  Result := fstaticextensions.TryGetData(ext, dta);
  {$ENDIF}
end;

constructor TRestDefaultStaticController.Create;
begin
  inherited;
  fisdefault := False;
  fstaticdirectory := '.\statics';
  {$IFNDEF FPC}
  fstaticextensions := TDictionary<string,string>.Create;
  {$ELSE}
  fstaticextensions := TFPGMap<string,string>.Create;
  {$ENDIF}
  InitStaticTypes;
  froute.Name := 'statics';
  froute.IsDefault := True;
  froute.RelativePath := 'statics';
  froute.AddMethod('GET');
  froute.AddMethod('POST');
  froute.needStaticController := True;
end;

function TRestDefaultStaticController.GetContentType(const strFile: string): string;
begin
  {$IFNDEF FPC}
  fstaticextensions.TryGetValue(strFile.Substring(strFile.LastIndexOf('.')), Result);
  {$ELSE}
  fstaticextensions.TryGetData(strFile.Substring(strFile.LastIndexOf('.')), Result);
  {$ENDIF}
end;

function TRestDefaultStaticController.GetFilePath(Request: THTTPRestRequest) : string;
var
  parameter : string;
  x : Integer;
  path : string;
begin
  for parameter in Request.Parameters do
  begin
    if Request.Path = froute.RelativePath then
    begin
      //Descartamos el primer parametro porque es el mismo que el controlador y no nos vale para el path
      if x > 0 then Request.Path := Request.Path + IncludeTrailingBackslash(string(parameter).Remove(string(parameter).IndexOf('?')));
      Inc(x);
    end;
  end;
  if Request.Path = '' then Result := Request.Parameters[High(Request.Parameters)];
  Result := IncludeTrailingPathDelimiter(fstaticdirectory) + Result;
end;

procedure TRestDefaultStaticController.InitStaticTypes;
var
  str : string;
  str2 : TArray<string>;
begin
  for str in STATICTYPES.Split([',']) do
  begin
    str2 := str.Split([':']);
    fstaticextensions.Add(str2[0], str2[1]);
  end;
end;

function TRestDefaultStaticController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
begin
  Result := ReturnFile(GetFilePath(Request), Request);
end;

function TRestDefaultStaticController.ReturnFile(const Path : string; Request : THTTPRestRequest) : Cardinal;
var
  fs : TStringStream;
begin
  try
    if not FileExists(Path) then raise Exception.Create('File not found');
    {$IFNDEF FPC}
    fs := TStringStream.Create;
    {$ENDIF}
    try
      {$IFDEF FPC}
      fs := TStringStream.Create(Path);
      {$ELSE}
      fs.LoadFromFile(Path);
      {$ENDIF}
      Request.ResponseInfo.ContentText := fs.DataString;
      Request.ResponseInfo.ContentType := GetContentType(Path);
      Result := 200;
    finally
      if fs <> nil then fs.Free;
    end;
  except
    on e : Exception do raise Exception.Create(e.Message);
  end;
end;

initialization
  DefaultStaticController := TRestDefaultStaticController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(DefaultStaticController);

end.


