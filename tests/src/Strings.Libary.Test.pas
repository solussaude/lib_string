unit Strings.Libary.Test;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestStringsLibrary = class
  public
    [Test]
    [TestCase('Remove lower letters',
      '0abcde1fght2ijkl3mont45qrst6uv7wxy8z9,0123456789')]
    [TestCase('Remove upper letters',
      '0ABCDE1FGHT2IJKL3MONT45QRST6UV7WXY8Z9,0123456789')]
    [TestCase('Remove special characters',
      '0!1@2#3$4%56¨¨7&8*&(9)_+,0123456789')]
    [TestCase('Do not remove number', '0123456789,0123456789')]
    procedure ShouldRemoveChar(AInputString, AOutputString: String);

    [TestCase('Remove special characters',
      '0!1@2#3$4%56¨¨7&8*&(9)_+,0123456789')]
    [TestCase('Deve remover caracteres especiais', 'ABC!@##$%¨&*()_,ABC')]
    procedure ShouldSpecialCharacters(AInputString, AOutputString: String);

    [TestCase('Keep all characters', 'ABC,BCA,ABC')]
    [TestCase('Should remover number', 'ABC123,1CBCA,ABC1')]
    [TestCase('Shold keep the dot and the letter C', 'ABC.123,.C,C.')]
    procedure ShouldKeepSelectedChars(AInputString, AKeepChars,
      AOutputString: String);

    [TestCase('Should abbreviate "AVENIDA"', 'AVENIDA JOAO LUCAS FILHO,14,AV J. L. FILHO')]
    [TestCase('Should abbreviate "RUA"', 'rua maria filha dos santos,21,R M. F. DOS SANTOS')]
    [TestCase('Should abbreviate "CONDOMINIO"', 'CONDOMINIO RAFAEL LIMA SOBRINHO,19,COND R. L. SOBRINHO')]
    [TestCase('Should abbreviate "CONDOMÍNIO"', 'CONDOMÍNIO MARCIA SOUZA SOBRINHA,19,COND M. S. SOBRINHA')]
    [TestCase('Should abbreviate "BLOCO"', 'bloco marcelo claudio,16,BL M. CLAUDIO')]
    [TestCase('Should abbreviate "APARTAMENTO"', 'apartamento maria dos santos,18,APTO M. DOS SANTOS')]
    [TestCase('Should abbreviate "PRACA"', 'PRACA LEONARDO ARRANTES NETO,17,PC L. A. NETO')]
    [TestCase('Should abbreviate "PRAÇA"', 'PRAÇA JESSICA MENEQUEL NETA,18,PC J. M. NETA')]
    [TestCase('Should abbreviate "JARDIM"', 'JARDIM CLARICE JOANA MOREIRA,16,JD C. J. MOREIRA')]
    [TestCase('Should abbreviate "EDIFICIO"', 'EDIFICIO EMILY MARLENE MENDES,15,ED E. M. MENDES')]
    [TestCase('Should abbreviate "CORONEL"', 'CORONEL IAN ARTHUR PAULO,16,CRN IAN A. PAULO')]
    [TestCase('Should abbreviate "EXPEDICIONARIO"', 'EXPEDICIONARIO BERNARDO JOSÉ LUAN FARIAS,19,EXP B. J. L. FARIAS')]
    [TestCase('Should abbreviate "RODOVIA"', 'RODOVIA RAFAEL VICENTE DA ROSA,17,ROD R. V. DA ROSA')]
    procedure ShouldAbbreviateAddress(AInputString:String; ALength: Integer; AOutputString: String);

    [TestCase('Should abbreviate "Filho"', 'JOAO LUCAS FILHO,10,JOAO L. FH')]
    [TestCase('Should abbreviate "Filha"', 'maria filha dos santos,19,MARIA FH DOS SANTOS')]
    [TestCase('Should abbreviate "Sobrinho"', 'RAFAEL LIMA SOBRINHO,14,RAFAEL L. SB')]
    [TestCase('Should abbreviate "Sobrinha"', 'MARCIA SOUZA SOBRINHA,16,MARCIA S. SB')]
    [TestCase('Should abbreviate "Doutor"', 'doutor marcelo claudio,16,DR M. CLAUDIO')]
    [TestCase('Should abbreviate "Doutora"', 'doutora maria dos santos,16,DR M. DOS SANTOS')]
    [TestCase('Should abbreviate "Neto"', 'LEONARDO ARRANTES NETO,14,LEONARDO A. NT')]
    [TestCase('Should abbreviate "Neta"', 'JESSICA MENEQUEL NETA,15,JESSICA M. NT')]
    procedure ShouldAbbreviateName(AInputString:String; ALength: Integer; AOutputString: String);

  end;

implementation

uses
  System.SysUtils,
  Strings.Libary;

{ TTestStringsLibrary }

procedure TTestStringsLibrary.ShouldRemoveChar(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyNumbers(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldSpecialCharacters(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyChars(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldAbbreviateAddress(AInputString: String;
  ALength: Integer; AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.AbbreviateAddress(AInputString, ALength);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldAbbreviateName(AInputString: String;
  ALength: Integer; AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.AbbreviateName(AInputString, ALength);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldKeepSelectedChars(AInputString,
  AKeepChars, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyChars(AInputString, AKeepChars);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

initialization

TDUnitX.RegisterTestFixture(TTestStringsLibrary);

end.
