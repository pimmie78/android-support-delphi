program GMailTest;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.GMailMain in 'View.GMailMain.pas' {Form2},
  Utils.Email in 'Utils.Email.pas',
  FMX.MediaLibrary.Android in 'FMX.MediaLibrary.Android.pas',
  Android.Support.v4 in 'Android.Support.v4.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
