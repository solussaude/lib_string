unit SolusUtil.Strings;

interface

type
  TSolusString = class
  public
    class function RandomText(const ALength: Integer; const AType: Integer = 3): string;
    class function InClause(const AList: array of string; const AField: string; const APutQuotes: Boolean = False): string;

    class function OnlyChars(const AStr: string): string; overload;
    class function OnlyChars(const AStr: string; const AChars: string): string; overload;

    class function OnlyNumbers(const AStr: string): string;

    class function Normalize(const AStr: string): string;
    class function ContainsInvalidChars(const AStr: string; const AInvalidChars: string = '*§.''/()_#-\`´|:ªº"°~!@$%^&+=;?€[]{}"¿'): Boolean;
    class function StrEqual(const AStr: string; const AValues: array of string; const AUpper: Boolean = True): Boolean;
  end;

implementation

uses
  System.StrUtils,
  System.SysUtils;

// Valida se o texto contém caracteres inválidos
class function TSolusString.ContainsInvalidChars(const AStr, AInvalidChars: string): Boolean;
{TODO: adicionar teste}
begin
  Result := False;

  for var LI: Integer := 1 to AStr.Length do
  begin
    if AInvalidChars.Contains(AStr[LI]) then
    begin
      Exit(True);
    end;
  end;
end;

// Cria uma composição IN-SQL
class function TSolusString.InClause(const AList: array of string; const AField: string; const APutQuotes: Boolean): string;
var
  LLength: Integer;
  LAux: Integer;
  LQuote: string;
  LPutOr: Boolean;
begin
  Result := '';

  LLength := Length(AList);
  LAux := 0;

  LPutOr := False;
  LQuote := IfThen(APutQuotes, '''', '');

  if LLength > 1 then
  begin
    Result := AField + ' IN (';

    for var LI := 0 to LLength - 1 do
    begin
      if not AList[LI].IsEmpty then
      begin
        Result := Result + LQuote + AList[LI] + LQuote + ', ';

        Inc(LAux);

        if (LAux = 999) and (LI < LLength - 1) then
        begin
          LAux := 1;
          Result := Result.Substring(0, Result.Length - 2) + ') OR ' + AField + ' IN (';
          LPutOr := True;
        end;
      end;
    end;

    if LPutOr then
    begin
      Result := '(' + Result.Substring(0, Result.Length - 2) + '))';
    end
    else
    begin
      Result := Result.Substring(0, Result.Length - 2) + ')';
    end;
  end
  else if LLength = 1 then
  begin
    LAux := 1;

    if not AList[0].IsEmpty then
    begin
      Result := AField + ' = ' + LQuote + AList[0] + LQuote;
    end
    else
    begin
      Result := AField + ' = ' + LQuote + '0' + LQuote;
    end;
  end;

  if LAux = 0 then
  begin
    Result := AField + ' = ' + LQuote + '0' + LQuote;
  end;
end;

// Substitui os caracteres com acento, cedilha, etc.
class function TSolusString.Normalize(const AStr: string): string;
var
  LOriginal: string;
  LModified: string;
  LIndex: Integer;
begin
  Result := AStr;
  LOriginal := 'ÇçÁÉÍÓÚÀÈÌÒÙÃÕÂáéíóúàèìòùãõêÊºª"';
  LModified := 'CcAEIOUAEIOUAOAaeiouaeiouaoeEoa ';

  for var LI: Integer := 1 to AStr.Length do
  begin
    LIndex := Pos(AStr[LI], LOriginal);

    if LIndex > 0 then
    begin
      Result[LI] := LModified[LIndex];
    end;
  end;
end;

// Retorna apenas os caracteres do texto, dado que foram informados os caracteres
// desejados na comparação
class function TSolusString.OnlyChars(const AStr, AChars: string): string;
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
class function TSolusString.OnlyChars(const AStr: string): string;
begin
  Result := Self.OnlyChars(AStr, 'abcdefghijklmnopqrstuvxywzABCDEFGHIJKLMNOPQRSTUVXYWZ1234567890');
end;

class function TSolusString.OnlyNumbers(const AStr: string): string;
begin
  Result := Self.OnlyChars(AStr, '1234567890');
end;

// Gera um texto aleatório
class function TSolusString.RandomText(const ALength, AType: Integer): string;
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

// Verifica se o texto está contido no vetor informado
class function TSolusString.StrEqual(const AStr: string; const AValues: array of string; const AUpper: Boolean): Boolean;
var
  LStr: string;
begin
  Result := False;
  LStr := IfThen(AUpper, AStr.ToUpper, AStr).Trim;

  for var LI: Integer := 0 to High(AValues) do
  begin
    if LStr = IfThen(AUpper, AValues[LI].ToUpper, AValues[LI]).Trim then
    begin
      Exit(True);
    end;
  end;
end;

end.
