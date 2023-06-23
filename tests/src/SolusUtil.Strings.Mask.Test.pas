unit SolusUtil.Strings.Mask.Test;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestStringsMask = class
  public
    [Test]
    [TestCase('Should hide, with a input masked','00.000.000,00.XXX-XXX')]
    [TestCase('Should hide, without a input masked', '00000000,00.XXX-XXX')]
    procedure ShouldHideCEP(AInputString, AOutputString: String);

    [TestCase('Should hide,  with a input masked', '00.000.000/0000-00,00.XXX.XXX/XXXX-XX')]
    [TestCase('Should hide, without a input masked', '00000000000000,00.XXX.XXX/XXXX-XX')]
    procedure ShouldHideCNPJ(AInputString, AOutputString: String);

    [TestCase('Should hide,  with a input masked', '000.000.000.00,000.XXX.XXX-XX')]
    [TestCase('Should hide, without a input masked', '00000000000,000.XXX.XXX-XX')]
    procedure ShouldHideCPF(AInputString, AOutputString: String);

    [TestCase('Should hide', '00/00/0000,00/XX/XXXX')]
    procedure ShouldHideDate(AInputString, AOutputString: String);

    [TestCase('Should hide', 'abcdefghi@email.com,abcd*****@email.com')]
    procedure ShouldHideEmail(AInputString, AOutputString: String);

    [TestCase('Should do nothing', '00.000.000,00.000-000')]
    [TestCase('Should masker', '00000000,00.000-000')]
    procedure ShouldMaskerCEP(AInputString, AOutputString: String);

    [TestCase('Should do nothing', '00.000.000/0000-00,00.000.000/0000-00')]
    [TestCase('Should masker', '00000000000000,00.000.000/0000-00')]
    procedure ShouldMaskerCNPJ(AInputString, AOutputString: String);

    [TestCase('Should do nothing', '000.000.000.00,000.000.000-00')]
    [TestCase('Should masker', '00000000000,000.000.000-00')]
    procedure ShouldMaskerCPF(AInputString, AOutputString: String);

    [TestCase('Should do nothing, is a CPF', '000.000.000.00,000.000.000-00')]
    [TestCase('Should masker, is a CPF', '00000000000,000.000.000-00')]
    [TestCase('Should do nothing, is a CNPJ', '00.000.000/0000-00,00.000.000/0000-00')]
    [TestCase('Should masker, is a CNPJ', '00000000000000,00.000.000/0000-00')]
    procedure ShouldMaskerDocument(AInputString, AOutputString: String);

  end;

implementation

uses
  SolusUtil.Strings.Mask;

{ TTestStringsMask }

procedure TTestStringsMask.ShouldHideCEP(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.HideCEP(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldHideCNPJ(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.HideCNPJ(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldHideCPF(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.HideCPF(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldHideDate(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.HideDate(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldHideEmail(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.HideEmail(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldMaskerCEP(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.CEP(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldMaskerCNPJ(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.CNPJ(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldMaskerCPF(AInputString, AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.CPF(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

procedure TTestStringsMask.ShouldMaskerDocument(AInputString,
  AOutputString: String);
var
  LStringFromFunction: String;
begin
  { Arrange } { Act }
  LStringFromFunction := TSolusStringMask.Document(AInputString);

  { Assert }
  Assert.AreEqual(AOutputString, LStringFromFunction);
end;

initialization

TDUnitX.RegisterTestFixture(TTestStringsMask);

end.
