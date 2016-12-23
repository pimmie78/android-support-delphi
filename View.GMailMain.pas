unit View.GMailMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions;

type
  TForm2 = class(TForm)
    btnSend: TButton;
    Memo1: TMemo;
    ActionList1: TActionList;
    ShowShareSheetAction1: TShowShareSheetAction;
    btnTest1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnTest1Click(Sender: TObject);
  private
    fAttachmentFilename: String;
    procedure CreateTestFile;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  Androidapi.IOUtils,
  Androidapi.Helpers,
  Utils.Email, Android.Support.v4;

{ TForm2 }

procedure TForm2.btnSendClick(Sender: TObject);
begin
  if TEmailUtils.Send('test@test.com', 'test@test.com', 'Test email', 'Hi Chris,'+sLineBreak+'This is a test email!', [fAttachmentFilename]) then
    Memo1.Lines.Add('Sent successfully')
  else
    Memo1.Lines.Add('Not sent');
end;

procedure TForm2.btnTest1Click(Sender: TObject);
  var
//    nm: JNotificationManagerCompat;
//    i: Integer;
//    b: Boolean;
    bmp: TBitmap;
begin
  bmp:=TBitmap.Create;
  try
    bmp:=btnSend.MakeScreenshot;
    ShowShareSheetAction1.TextMessage:='Test email';
    ShowShareSheetAction1.Bitmap:=bmp;
    ShowShareSheetAction1.Execute;
  finally
    bmp.Free;
  end;
end;

procedure TForm2.CreateTestFile;
  var
    SL: TStringList;
begin
  if TFile.Exists(fAttachmentFilename) then
    Exit;

  SL:=TStringList.Create;
  try
    SL.Text:='This is a test file that does all sorts of sample things';
    SL.SaveToFile(fAttachmentFilename);
  finally
    SL.Free;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  fAttachmentFilename:=TPath.Combine(GetFilesDir, 'Attachments/testattach.txt');
  if not TDirectory.Exists(ExtractFilePath(fAttachmentFilename)) then
    ForceDirectories(ExtractFilePath(fAttachmentFilename));
  Memo1.Lines.Add('Attachment: '+fAttachmentFilename);
  CreateTestFile;
end;

end.
