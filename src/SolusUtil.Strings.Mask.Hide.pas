unit SolusUtil.Strings.Mask.Hide;

interface

type
  TSolusStringMaskHide = class abstract
  public
    class function HideCEP(const AStr: string): string;
    class function HideCNPJ(const AStr: string): string;
    class function HideCPF(const AStr: string): string;
    class function HideDate(const AStr: string): string;
    class function HideEmail(const AStr: string): string;
  end;

implementation

uses
  SolusUtil.Strings,
  System.StrUtils,
  System.SysUtils;

// Mascara uma CEP para omitir dados sensíveis
class function TSolusStringMaskHide.HideCEP(const AStr: string): string;
begin
  Result := TSolusString.OnlyNumbers(AStr);

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '.XXX-XXX';
  end;
end;

// Mascara uma CNPJ para omitir dados sensíveis
class function TSolusStringMaskHide.HideCNPJ(const AStr: string): string;
begin
  Result := TSolusString.OnlyNumbers(AStr);

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '.XXX.XXX/XXXX-XX';
  end;
end;

// Mascara uma CPF para omitir dados sensíveis
class function TSolusStringMaskHide.HideCPF(const AStr: string): string;
begin
  Result := AStr.Trim;

  if Result.Length >= 3 then
  begin
    Result := Result.Substring(0, 3) + '.XXX.XXX-XX';
  end;
end;

// Mascara uma data para omitir dados sensíveis
class function TSolusStringMaskHide.HideDate(const AStr: string): string;
begin
  Result := AStr.Trim;

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '/XX/XXXX';
  end;
end;

// Mascara um e-mail para omitir dados sensíveis
class function TSolusStringMaskHide.HideEmail(const AStr: string): string;
var
  LUsername: string;
  LMailServer: string;
  LSybomPosition: Integer;
begin
  Result := AStr.Trim;
  LSybomPosition := Pos('@', Result);

  if LSybomPosition > 0 then
  begin
    LUsername := Result.Substring(0, LSybomPosition - 1);
    LMailServer := Result.Substring(LSybomPosition);

    if LUsername.Length > 5 then
    begin
      LUsername := LUsername.Substring(0, 4) + DupeString('*', LUsername.Length - 4);
    end
    else
    begin
      LUsername := LUsername.Substring(0, 2) + DupeString('*', LUsername.Length - 2);
    end;

    Result := LUsername + '@' + LMailServer;
  end;
end;

end.