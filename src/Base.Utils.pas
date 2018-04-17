unit Base.Utils;

interface

uses
  System.SysUtils, SynCommons;

type

  TUtils = class
    public
      class procedure Cout(aText : string);
      class procedure Error(aText : string);
  end;

implementation

class procedure TUtils.Cout(aText: string);
begin
  Writeln(aText);
end;

class procedure TUtils.Error(aText: string);
begin
  //ILog.Log(sllError, AText);
end;

	
end.