unit SolusUtil.Strings.Test;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestSolusStrings = class
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

    [TestCase('Should replace invalid character',
      'ÇçÁÉÍÓÚÀÈÌÒÙÃÕÂáéíóúàèìòùãõêÊºª,CcAEIOUAEIOUAOAaeiouaeiouaoeEoa')]
    procedure ShouldNormalizeCharacter(AInputString: String;
      AOutputString: String);

    [TestCase('Should create a sql clause equal 0 with quotes', '-1')]
    [TestCase('Should create a sql clause equal A with quotes', '0')]
    [TestCase('Should create a in sql clause of A and B with quotes', '1')]
    [TestCase('Should create a sql clause equal 1 without quotes', '2')]
    [TestCase('Should create a in sql clause of 1 and 2 without quotes', '3')]
    [TestCase('Should create a in sql clause from 0 to 999 without quotes', '4')]
    [TestCase('Should create a in sql clause from 0 to 999 with quotes', '5')]
    procedure ShouldCreateAInClause(AInput: Integer);

    [TestCase('The text "PEDRINHO" exists in array, but I''ll search per "pedrinho", using "ForceUpper"', '0')]
    [TestCase('The text "PEDRINHO" exists in array, but I''ll search per "pedrinho", without "ForceUpper"', '1')]
    [TestCase('The text "pedrinho" don''t exists in array, and I''ll search using "ForseUpper"', '2')]
    [TestCase('The text "pedrinho" don''t exists in array, and I''ll search without "ForseUpper"', '3')]
    [TestCase('The text "PEDRINHO" exists in array, but I''ll search per "PEDRINHO", without "ForceUpper"', '4')]
    procedure ShouldFindStringInArray(AInput: Integer);
  end;

implementation

uses
  System.SysUtils,
  SolusUtil.Strings,
  SolusUtil.Strings.Test.Consts;

{ TTestSolusStrings }

procedure TTestSolusStrings.ShouldRemoveChar(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusString.OnlyNumbers(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestSolusStrings.ShouldSpecialCharacters(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusString.OnlyChars(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestSolusStrings.ShouldFindStringInArray(AInput: Integer);
var
  LExpectReturn, LFunctionReturn, LForceUpperCase: Boolean;

  LStringToFind: String;
  LArrayInput: array of string;
begin

  LForceUpperCase := True;
  LExpectReturn := True;

  { Arrange }
  case AInput of
    0:
      begin
        LArrayInput := ['PEDRINHO', 'MATHEUS', 'CAROL'];
        LStringToFind := 'pedrinho';
        LForceUpperCase := True;

        LExpectReturn := True;
      end;
    1:
      begin
        LArrayInput := ['PEDRINHO', 'MATHEUS', 'CAROL'];
        LStringToFind := 'pedrinho';
        LForceUpperCase := False;

        LExpectReturn := False;
      end;
    2:
      begin
        LArrayInput := ['MATHEUS', 'CAROL'];
        LStringToFind := 'pedrinho';
        LForceUpperCase := True;

        LExpectReturn := False;
      end;
    3:
      begin
        LArrayInput := ['MATHEUS', 'CAROL'];
        LStringToFind := 'pedrinho';
        LForceUpperCase := False;

        LExpectReturn := False;
      end;
    4:
      begin
        LArrayInput := ['PEDRINHO', 'MATHEUS', 'CAROL'];
        LStringToFind := 'PEDRINHO';
        LForceUpperCase := False;

        LExpectReturn := True;
      end;
  end;

  LFunctionReturn := TSolusString.StrEqual(LStringToFind,
    LArrayInput, LForceUpperCase);

  { Assert }
  Assert.AreEqual(LExpectReturn, LFunctionReturn);
end;

procedure TTestSolusStrings.ShouldCreateAInClause(AInput: Integer);
var
  LStringFromFunction: String;

  LArrayOfInput: TArray<string>;
  LColumn: String;
  LPutQuotes: Boolean;
  LExpectedString: String;

begin
  LColumn := 'COLUNA';
  LPutQuotes := True;
  LArrayOfInput := TArray<string>.Create();

  { Arrange }
  case AInput of
    0:
      begin
        LArrayOfInput := ['A'];
        LExpectedString := 'COLUNA = ''A''';
      end;
    1:
      begin
        LArrayOfInput := ['A', 'B'];
        LExpectedString := 'COLUNA IN (''A'', ''B'')';
      end;
    2:
      begin
        LArrayOfInput := ['1'];
        LPutQuotes := false;
        LExpectedString := 'COLUNA = 1';
      end;
    3:
      begin
        LArrayOfInput := ['1', '2'];
        LPutQuotes := false;
        LExpectedString := 'COLUNA IN (1, 2)';
      end;
    4:
      begin
        LArrayOfInput := LIST_MORE_THAN_999_NUMBER;
        LPutQuotes := false;
        LExpectedString := CLAUSE_MORE_THAN_999_NUMBER;
      end;
    5:
      begin
        LArrayOfInput := LIST_MORE_THAN_999_NUMBER;
        LPutQuotes := true;
        LExpectedString := CLAUSE_MORE_THAN_999_STRING;
      end;

  else
    LArrayOfInput := [];
    LExpectedString := 'COLUNA = ''0''';
  end;

  { Act }
  LStringFromFunction := TSolusString.InClause(LArrayOfInput, LColumn,
    LPutQuotes);

  { Assert }
  Assert.AreEqual(LExpectedString, LStringFromFunction);
end;

procedure TTestSolusStrings.ShouldKeepSelectedChars(AInputString, AKeepChars,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusString.OnlyChars(AInputString, AKeepChars);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestSolusStrings.ShouldNormalizeCharacter(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusString.Normalize(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

initialization

TDUnitX.RegisterTestFixture(TTestSolusStrings);

end.
