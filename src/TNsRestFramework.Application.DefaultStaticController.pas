unit TNsRestFramework.Application.DefaultStaticController;

interface

uses
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils;

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
  ext : string;
begin
  ext := string(Filename).Substring(Filename.LastIndexOf('.'));
  Result := fstaticextensions.ContainsKey(ext);
end;

constructor TRestDefaultStaticController.Create;
begin
  fisdefault := False;
  fstaticdirectory := '.\statics';
  fstaticextensions := TDictionary<string,string>.Create;
  InitStaticTypes;
  froute := THTTPRoute.Create;
  froute.Name := 'statics';
  froute.IsDefault := True;
  froute.RelativePath := 'statics';
  froute.Methods := ['GET', 'POST'];
  froute.needStaticController := True;
end;

function TRestDefaultStaticController.GetContentType(const strFile: string): string;
begin
  fstaticextensions.TryGetValue(strFile.Substring(strFile.LastIndexOf('.')), Result);
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
    fs := TStringStream.Create;
    try
      fs.LoadFromFile(Path);
      Request.HTTPContext.OutContent := fs.DataString;
      Request.HTTPContext.OutContentType := GetContentType(Path);
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


