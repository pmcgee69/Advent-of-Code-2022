program Project_UFP_Tests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

//{$IFDEF CONSOLE_TESTRUNNER}
//{$APPTYPE CONSOLE}
//{$ENDIF}


uses
  DUnitTestRunner,
  TestU_Utils_Functional in 'TestU_Utils_Functional.pas',
  U_Utils_Functional in '..\U_Utils_Functional.pas';


{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

