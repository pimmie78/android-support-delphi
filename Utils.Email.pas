unit Utils.Email;

interface

uses
  System.Classes;

type
  TEmailUtils = class
  public
    class function Send(
      aSender: String;
      aRecipient: String;
      aSubject: String;
      aBody: String;
      aAttachmentsArray: array of String): Boolean;
  end;

implementation

uses
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.Os,
  Androidapi.Helpers,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Provider,
  Androidapi.JNI.JavaTypes,
  AndroidApi.JNIBridge,
  FMX.Helpers.Android,
  System.SysUtils, System.IOUtils, Android.Support.v4;

{ TEmailUtils }

class function TEmailUtils.Send(aSender, aRecipient, aSubject, aBody: String; aAttachmentsArray: array of String): Boolean;
var
  Intent: JIntent;
  recipients: TJavaObjectArray<JString>;
  path: String;
  f: JFile;
  uris: JArrayList;
  uri: JNet_Uri;
  I: Integer;
begin
  Result:=True;

  try
    aBody:=StringReplace(aBody, #13, sLineBreak, [rfReplaceAll]);

    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND_MULTIPLE);
    recipients := TJavaObjectArray<JString>.Create(1);
    recipients.Items[0] := StringToJString(aRecipient);
    Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, recipients);
    Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(aSubject));
    Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(aBody));

    if (Length(aAttachmentsArray) > 0) then
    begin
      uris:= TJArrayList.Create;

      for I := 0 to Length(aAttachmentsArray)-1 do
      begin
        path:=aAttachmentsArray[I];
        if TFile.Exists(path) then
        begin
          f := TJFile.JavaClass.init(StringToJString(path));
          uri := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, StringToJString('com.mydomain.fileprovider'), f);
          //TJnet_Uri.JavaClass.fromFile(f);

          uris.Add(uri);
        end;
      end;

      Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
      Intent.putParcelableArrayListExtra(TJIntent.JavaClass.EXTRA_STREAM, Uris);
    end;

    Intent.setType(StringToJString('vnd.android.cursor.dir/email'));

    TAndroidHelper.Activity.startActivityForResult(
      TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('Send with which email app?')),
      0);
  except
    on E: Exception do
    begin
      Result:=False;
    end;
  end;
end;

end.
