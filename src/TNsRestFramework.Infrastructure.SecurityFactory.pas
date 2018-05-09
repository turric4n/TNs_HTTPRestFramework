unit TNsRestFramework.Infrastructure.SecurityFactory;

interface

uses
  {$IFNDEF FPC}
  System.SyncObjs;
  {$ELSE}
  SyncObjs;
  {$ENDIF}

type

  { TSecurityFactory }


  TSecurityFactory = class
    protected
      fsecurityhandler : ICustomHTTPServer;
    public
      class procedure Init(const SecurityFile : string);
      class function GetCurrent : ICustomHTTPServer;
      destructor Destroy; override;
  end;

implementation

{ TSecurityFactory }

class procedure TSecurityFactory.Init(const SecurityFile: string);
begin

end;

class function TSecurityFactory.GetCurrent: ICustomHTTPServer;
begin

end;

destructor TSecurityFactory.Destroy;
begin
  inherited Destroy;
end;

end;
