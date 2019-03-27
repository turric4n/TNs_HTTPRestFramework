unit TNsRestFramework.Infrastructure.Interfaces.Logger;

interface

uses
  Quick.Logger,
  TNsRestFramework.Infrastructure.Config;

type

  ILogger = interface['{6A46B7B0-17C1-4855-B48F-477AE6EBF8FD}']
    procedure Info(const Line : string); overload;
    procedure Info(const Line : string; Values : array of const); overload;
    procedure Error(const Line : string); overload;
    procedure Error(const Line : string; Values : array of const); overload;
    procedure Warning(const Line : string); overload;
    procedure Warning(const Line : string; Values : array of const); overload;
    procedure Success(const Line : string); overload;
    procedure Success(const Line : string; Values : array of const); overload;
    procedure Critical(const Line : string); overload;
    procedure Critical(const Line : string; Values : array of const); overload;
    procedure Debug(const Line : string); overload;
    procedure Debug(const Line : string; Values : array of const); overload;
    procedure SetLogConsoleConfig(aConfig : TConsoleLogConfig);
    procedure SetLogFileConfig(aConfig : TFileLogConfig);
    function Providers : TLogProviderList;
    function GetProviderByName(const aName : string) : TLogProviderBase;
  end;

implementation

end.
