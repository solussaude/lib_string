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
      '0!1@2#3$4%56ии7&8*&(9)_+,0123456789')]
    [TestCase('Do not remove number', '0123456789,0123456789')]
    procedure ShouldRemoveChar(AExpectedString, AActualString: String);

    [TestCase('Remove special characters',
      '0!1@2#3$4%56ии7&8*&(9)_+,0123456789')]
    [TestCase('Deve remover caracteres especiais', 'ABC!@##$%и&*()_,ABC')]
    procedure ShouldSpecialCharacters(AExpectedString, AActualString: String);

    [TestCase('Keep all characters', 'ABC,BCA,ABC')]
    [TestCase('Should remover number', 'ABC123,1CBCA,ABC1')]
    [TestCase('Shold keep the dot and the letter C', 'ABC.123,.C,C.')]
    procedure ShouldKeepSelectedChars(AExpectedString, AKeepChars,
      AActualString: String);

  end;

implementation

uses
  System.SysUtils,
  Strings.Libary;

{ TTestStringsLibrary }

procedure TTestStringsLibrary.ShouldRemoveChar(AExpectedString,
  AActualString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyNumbers(AExpectedString);

  { Assert }
  Assert.AreEqual(AActualString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldSpecialCharacters(AExpectedString,
  AActualString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyChars(AExpectedString);

  { Assert }
  Assert.AreEqual(AActualString, LStringFromFunction);
end;

procedure TTestStringsLibrary.ShouldKeepSelectedChars(AExpectedString,
  AKeepChars, AActualString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TStringUtil.OnlyChars(AExpectedString, AKeepChars);

  { Assert }
  Assert.AreEqual(AActualString, LStringFromFunction);
end;

initialization

TDUnitX.RegisterTestFixture(TTestStringsLibrary);

end.
