unit TNsRestFramework.Infrastructure.Config;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  {$IFDEF FPC}
  fpjson
  {$ELSE}
  {$ENDIF}
  ;

type
  IConfigHandler = Interface ['{8365F9D0-DCAE-4D4D-8571-F80FA38AF133}']
    function Load;
    function Save;
  end;

  TBaseConfigHandler = class(TInterfacedObject, IConfigHandler)
    private
  end;

  { TDiskConfig }

  TDiskConfig = class(TBaseConfigHandler)

  end;


implementation

end.

