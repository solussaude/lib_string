unit SolusUtil.Strings.Abbreviate;

interface

uses
  System.Generics.Collections;

type
  TSolusStringAbbreviate = class
  private
    class function AbbreviateWords(const AStr: string; const ALength: Integer; const ADict: TDictionary<string, string>): string;

  public
    class function AbbreviateAddress(const AStr: string; const ALength: Integer): string;
    class function AbbreviateName(const AStr: string; const ALength: Integer): string;
  end;

implementation

uses
  System.SysUtils;

// Abrevia um endereço
class function TSolusStringAbbreviate.AbbreviateAddress(const AStr: string; const ALength: Integer): string;
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
class function TSolusStringAbbreviate.AbbreviateName(const AStr: string; const ALength: Integer): string;
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
class function TSolusStringAbbreviate.AbbreviateWords(const AStr: string; const ALength: Integer; const ADict: TDictionary<string, string>): string;
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

end.
