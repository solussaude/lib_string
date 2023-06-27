unit SolusUtil.Date;

interface

type
  TSolusDate = class
  private
    class var FSync: TDateTime;
    class procedure SetSync(const AValue: TDateTime); static;

  public
    class function SysDate: TDateTime;
    class function TruncSysDate: TDate;

    class function SysTime: TTime;

    class property Sync: TDateTime write SetSync;
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils;

class procedure TSolusDate.SetSync(const AValue: TDateTime);
begin
  TSolusDate.FSync := Now - AValue;
end;

class function TSolusDate.SysDate: TDateTime;
begin

  Result := Now - FSync;
end;

class function TSolusDate.TruncSysDate: TDate;
begin
  Result := Trunc(Date - FSync);
end;

class function TSolusDate.SysTime: TTime;
begin
  Result := Self.SysDate.GetTime;
end;

initialization

TSolusDate.Sync := Now;

end.
