program lib_solusutil_tests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  System.SysUtils,
  DUnitTestRunner,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  SolusUtil.Strings in '..\..\src\SolusUtil.Strings.pas',
  SolusUtil.Strings.Test in 'SolusUtil.Strings.Test.pas',
  SolusUtil.Strings.Test.Consts in 'constants\SolusUtil.Strings.Test.Consts.pas',
  SolusUtil.Strings.Mask in '..\..\src\SolusUtil.Strings.Mask.pas',
  SolusUtil.Strings.Mask.Test in 'SolusUtil.Strings.Mask.Test.pas',
  SolusUtil.Strings.Abbreviate in '..\..\src\SolusUtil.Strings.Abbreviate.pas',
  SolusUtil.Strings.Abbreviate.Test in 'SolusUtil.Strings.Abbreviate.Test.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NunitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := True;
  isConsole := True;

{$IF DEFINED(DEBUG) AND DEFINED(MSWINDOWS)}
  isConsole := False;
{$ENDIF}
  try
    TDUnitX.CheckCommandLine;
    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;
    Runner.FailsOnNoAsserts := False;

    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      Logger := TDUnitXConsoleLogger.Create
        (TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      Runner.AddLogger(Logger);
    end;

    NunitLogger := TDUnitXXMLNUnitFileLogger.Create
      (TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NunitLogger);

    Results := Runner.Execute;
    if not Results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.
