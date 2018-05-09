unit TNsRestFramework.Infrastructure.Security;

interface

uses
  TNsRestFramework.Infrastructure.HTTPRequest,
  Classes,
  SysUtils,
  {$IFNDEF FPC}
  System.Generics.Collection,
  {$ELSE}
  fgl
  {$ENDIF}
  ;

type
  ENotAutorized = TExceptionClass;

  IHTTPSecurityHandler = interface ['{62D2702D-E1FB-44C1-BC91-908895EE3D61}']
    procedure AddCondition(const Origin : string; Access : Boolean);
    procedure Handle(Request : THTTPRequest);
  end;
  { TBaseHandler }

  TBaseHandler = class(TInterfacedObject, IHTTPSecurityHandler)
    private
      fconditions : TFPGMap<string, Boolean>;
    public
      constructor Create;
      procedure AddCondition(const Origin : string; Access : Boolean);
      procedure Handle(Request : THTTPRequest); virtual; abstract;
  end;

  { TAPIKeyHTTPHandler }

  TAPIKeyHTTPHandler = class(TBaseHandler)
    public
      procedure Handle(Request : THTTPRequest); override;
  end;

implementation

{ TBaseHandler }

constructor TBaseHandler.Create;
begin
  fconditions := TFPGMap.Create;
end;

procedure TBaseHandler.AddCondition(const Origin: string; Access: Boolean);
begin
  fconditions.Add(Origin, Access);
end;

{ TAPIKeyHTTPHandler }

procedure TAPIKeyHTTPHandler.Handle(Request: THTTPRequest);
var
  param : string;
begin
  for param in Request.Parameters do
  begin

  end;
end;

end.

