unit Strings.Libary;

interface

type
  TStringUtil = class
  public
    class function RandomText(const ALength: Integer; const AType: Integer = 3): string;

    class function OnlyChars(const AStr: string): string; overload;
    class function OnlyChars(const AStr: string; const AChars: string): string; overload;

    class function OnlyNumbers(const AStr: string): string;
  end;

implementation

uses
  System.SysUtils;

// Retorna apenas os caracteres do texto, dado que foram informados os caracteres
// desejados na comparação
class function TStringUtil.OnlyChars(const AStr, AChars: string): string;
begin
  Result := '';

  for var LI: Integer := 1 to AStr.Length do
  begin
    if AChars.Contains(AStr[LI]) then
    begin
      Result := Result + AStr[LI];
    end;
  end;
end;

// Retorna apenas os caracteres e números do texto
class function TStringUtil.OnlyChars(const AStr: string): string;
begin
  Result := Self.OnlyChars(AStr, 'abcdefghijklmnopqrstuvxywzABCDEFGHIJKLMNOPQRSTUVXYWZ1234567890');
end;

class function TStringUtil.OnlyNumbers(const AStr: string): string;
begin
  Result := Self.OnlyChars(AStr, '1234567890');
end;

// Gera um texto aleatório
class function TStringUtil.RandomText(const ALength, AType: Integer): string;
const
  TEXT_1: string = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TEXT_2: string = '1234567890abcdefghijklmnopqrstuvwxyz';
  TEXT_3: string = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TEXT_4: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TEXT_5: string = '1234567890';
  TEXT_6: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TEXT_7: string = 'abcdefghijklmnopqrstuvwxyz';
  TEXT_8: string = 'abcdef1234567890';
var
  LType: Integer;
begin
  Result := '';

  LType := AType;
  if (LType < 1) or (LType > 8) then
  begin
    LType := 3;
  end;

  for var LI: Integer := 1 to ALength do
  begin
    case LType of
      1:
        Result := Result + TEXT_1[Random(TEXT_1.Length) + 1];
      2:
        Result := Result + TEXT_2[Random(TEXT_2.Length) + 1];
      3:
        Result := Result + TEXT_3[Random(TEXT_3.Length) + 1];
      4:
        Result := Result + TEXT_4[Random(TEXT_4.Length) + 1];
      5:
        Result := Result + TEXT_5[Random(TEXT_5.Length) + 1];
      6:
        Result := Result + TEXT_6[Random(TEXT_6.Length) + 1];
      7:
        Result := Result + TEXT_7[Random(TEXT_7.Length) + 1];
      8:
        Result := Result + TEXT_8[Random(TEXT_8.Length) + 1];
    end;
  end;
end;

end.
