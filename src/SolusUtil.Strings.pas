unit SolusUtil.Strings;

interface

uses
  System.Generics.Collections;

type
  TSolusString = class
  private
    class function AbbreviateWords(const AStr: string; const ALength: Integer; const ADict: TDictionary<string, string>): string;

  public
    class function RandomText(const ALength: Integer; const AType: Integer = 3): string;
    class function InClause(const AList: array of string; const AField: string; const APutQuotes: Boolean = False): string;

    class function OnlyChars(const AStr: string): string; overload;
    class function OnlyChars(const AStr: string; const AChars: string): string; overload;

    class function OnlyNumbers(const AStr: string): string;

    class function AbbreviateAddress(const AStr: string; const ALength: Integer): string;
    class function AbbreviateName(const AStr: string; const ALength: Integer): string;

    class function Normalize(const AStr: string): string;
    class function ContainsInvalidChars(const AStr: string; const AInvalidChars: string = '*§.''/()_#-\`´|:ªº"°~!@$%^&+=;?€[]{}"¿'): Boolean;
    class function StrEqual(const AStr: string; const AValues: array of string; const AUpper: Boolean = True): Boolean;
  end;

implementation

uses
  System.StrUtils,
  System.SysUtils;

// Abrevia um endereço
class function TSolusString.AbbreviateAddress(const AStr: string; const ALength: Integer): string;
var
  LDict: TDictionary<string, string>;
begin
  LDict := TDictionary<string, string>.Create;
  try
    LDict.Add('AVENIDA', 'AV');
    LDict.Add('RUA', 'R');
    LDict.Add('CONDOMINIO', 'COND');
    LDict.Add('CONDOMÍNIO', 'COND');
    LDict.Add('BLOCO', 'BL');
    LDict.Add('ANDAR', 'AD');
    LDict.Add('APARTAMENTO', 'APTO');
    LDict.Add('PRACA', 'PC');
    LDict.Add('PRAÇA', 'PC');
    LDict.Add('JARDIM', 'JD');
    LDict.Add('EDIFICIO', 'ED');
    LDict.Add('CORONEL', 'CRN');
    LDict.Add('EXPEDICIONARIO', 'EXP');
    LDict.Add('RODOVIA', 'ROD');

    Result := Self.AbbreviateWords(AStr, ALength, LDict);
  finally
    LDict.DisposeOf;
  end;
end;

// Abrevia um nome
class function TSolusString.AbbreviateName(const AStr: string; const ALength: Integer): string;
var
  LDict: TDictionary<string, string>;
begin
  LDict := TDictionary<string, string>.Create;
  try
    LDict.Add('FILHO', 'FH');
    LDict.Add('FILHA', 'FH');
    LDict.Add('SOBRINHO', 'SB');
    LDict.Add('SOBRINHA', 'SB');
    LDict.Add('DOUTOR', 'DR');
    LDict.Add('DOUTORA', 'DR');
    LDict.Add('NETO', 'NT');
    LDict.Add('NETA', 'NT');

    Result := Self.AbbreviateWords(AStr, ALength, LDict);
  finally
    LDict.DisposeOf;
  end;
end;

// Abrevia um texto com base em um dicionário de abreviações
class function TSolusString.AbbreviateWords(const AStr: string; const ALength: Integer; const ADict: TDictionary<string, string>): string;
var
  LName: string;
  LN: Integer;
  LI: Integer;
  LLength: Integer;
  LNames: array of string;
begin
  Result := AStr.ToUpper.Trim;
  LName := Result + #32;

  LN := 0;
  LI := Pos(#32, Result);
  LLength := LName.Length;

  if (LLength > ALength) and (LI > 0) then
  begin
    for var LKey: string in ADict.Keys do
    begin
      LName := LName.Replace(LKey, ADict.Items[LKey]);
    end;

    LI := Pos(#32, LName);

    // Separa os nomes do texto
    while LI > 0 do
    begin
      SetLength(LNames, Length(LNames) + 1);
      LNames[LN] := LName.Substring(0, LI - 1).Trim;
      Delete(LName, 1, LI);

      LI := Pos(#32, LName);
      Inc(LN);
    end;

    if LN > 1 then
    begin
      // Abrevia a partir do segundo nome (exceto o último)
      for LI := LN - 2 downto 1 do
      begin
        // Contém mais de 3 letras? (ignorar "de", "da", "das", "do", "dos", etc.)
        if (LLength > ALength) and (LNames[LI].Length > 3) then
        begin
          LLength := LLength - LNames[LI].Length + 2;
          LNames[LI] := LNames[LI][1] + '.';
        end;
      end;

      Result := '';

      for LI := 0 to LN - 1 do
      begin
        if LNames[LI].Trim.Length > 0 then
        begin
          Result := Result + LNames[LI].Trim + #32;
        end;
      end;

      Result := Result.Trim.Substring(0, ALength);
    end;
  end;
end;

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
