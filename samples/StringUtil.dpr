program StringUtil;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Strings.Libary in '..\src\Strings.Libary.pas';

var
  LStr1: String;
  LStr2: String;
  LStr3: String;
  LStr4: String;
  LStr5: String;

begin
  LStr1 := TStringUtil.Crypt('Oracle', 'Delphi');
  LStr2 := TStringUtil.RandomText(10, 4);
  LStr3 := TStringUtil.OnlyChars('Console Application 2023');
  LStr4 := TStringUtil.OnlyChars('DELPHI2023', 'ABCDEFGHIJKLMNOPQRSTUVXYWZ');
  LStr5 := TStringUtil.OnlyNumbers('Solus 2023');

  Assert(LStr1 = 'sN]_PY', 'String Util: Crypt');
  Assert(LStr2 = 'abSkoIqitw', 'String Util: RandomText');
  Assert(LStr3 = 'ConsoleApplication2023', 'String Util: OnlyChars');
  Assert(LStr4 = 'DELPHI', 'String Util: OnlyChars');
  Assert(LStr5 = '2023', 'String Util: OnlyNumbers');

end.
