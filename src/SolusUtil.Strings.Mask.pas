unit SolusUtil.Strings.Mask;

interface

type
  TSolusStringMask = class abstract
  public
    class function CEP(const AStr: string): string;
    class function CNPJ(const AStr: string): string;
    class function CPF(const AStr: string): string;
    class function Document(const AStr: string): string;

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

// Formata um CEP - XX.XXX-XX
class function TSolusStringMask.CEP(const AStr: string): string;
var
  LCEP: string;
begin
  LCEP := TSolusString.OnlyNumbers(AStr);
  Result := AStr;

  if LCEP.Length = 8 then
  begin
    Result := LCEP.Substring(0, 2) + '.' + LCEP.Substring(2, 3) + '-' + LCEP.Substring(5);
  end;
end;

// Formata um CNPJ - XX.XXX.XXX/XXXX-XX
class function TSolusStringMask.CNPJ(const AStr: string): string;
var
  LCNPJ: string;
  LLength: Integer;
begin
  LCNPJ := TSolusString.OnlyNumbers(AStr);
  LLength := LCNPJ.Length;
  Result := AStr;

  if LLength < 14 then
  begin
    Result := LCNPJ.PadLeft(14 - LLength, '0');
  end;

  if LLength = 14 then
  begin
    Result := LCNPJ.Substring(0, 2) + '.' + LCNPJ.Substring(2, 3) + '.' + LCNPJ.Substring(5, 3) + '/' + LCNPJ.Substring(8, 4) + '-' + LCNPJ.Substring(12);
  end;
end;

// Formata um CPF - XXX.XXX.XXX-XX
class function TSolusStringMask.CPF(const AStr: string): string;
var
  LCPF: string;
begin
  LCPF := TSolusString.OnlyNumbers(AStr);
  Result := AStr;

  if LCPF.Length = 11 then
  begin
    Result := LCPF.Substring(0, 3) + '.' + LCPF.Substring(3, 3) + '.' + LCPF.Substring(6, 3) + '-' + LCPF.Substring(9);
  end;
end;

// Formata um CNPJ ou um CPF, identificado pelo tamanho do texto
class function TSolusStringMask.Document(const AStr: string): string;
var
  LDocument: string;
begin
  LDocument := TSolusString.OnlyNumbers(AStr);

  if LDocument.Length <= 11 then
  begin
    Result := Self.CPF(LDocument);
  end
  else
  begin
    Result := Self.CNPJ(LDocument);
  end;
end;

// Mascara uma CEP para omitir dados sensíveis
class function TSolusStringMask.HideCEP(const AStr: string): string;
begin
  Result := TSolusString.OnlyNumbers(AStr);

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '.XXX-XXX';
  end;
end;

// Mascara uma CNPJ para omitir dados sensíveis
class function TSolusStringMask.HideCNPJ(const AStr: string): string;
begin
  Result := TSolusString.OnlyNumbers(AStr);

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '.XXX.XXX/XXXX-XX';
  end;
end;

// Mascara uma CPF para omitir dados sensíveis
class function TSolusStringMask.HideCPF(const AStr: string): string;
begin
  Result := AStr.Trim;

  if Result.Length >= 3 then
  begin
    Result := Result.Substring(0, 3) + '.XXX.XXX-XX';
  end;
end;

// Mascara uma data para omitir dados sensíveis
class function TSolusStringMask.HideDate(const AStr: string): string;
begin
  Result := AStr.Trim;

  if Result.Length >= 2 then
  begin
    Result := Result.Substring(0, 2) + '/XX/XXXX';
  end;
end;

// Mascara um e-mail para omitir dados sensíveis
class function TSolusStringMask.HideEmail(const AStr: string): string;
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
