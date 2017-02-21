unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, IdHTTP, IdComponent, Forms, ShellApi;

type
  TDownLoader = class(tthread)
  private
    FToFolder: string;
    FURL: string;
    iCounterPerSec: TLargeInteger;
    tStart, tCurrent: TLargeInteger;
  protected
    procedure execute; override;
  public
    Speeed: TLargeInteger;
    property URL: string read FURL write FURL;
    property ToFolder: string read FToFolder write FToFolder;
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  end;

implementation

Uses Unit1;

procedure TDownLoader.execute;
var
  http: TIdHTTP;
  str: TFileStream;
begin
  http := TIdHTTP.Create(nil);
  http.OnWork := IdHTTP1Work;
  http.OnWorkEnd := IdHTTP1WorkEnd;
  http.OnWorkBegin := IdHTTP1WorkBegin;
  ForceDirectories(ExtractFileDir(ToFolder));
  str := TFileStream.Create(ToFolder, fmCreate);
  try
    http.Get(URL, str);
  finally
    http.Free;
    str.Free;
  end;
end;

procedure TDownLoader.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  PostMessage(Application.MainForm.Handle, MY_MESS, 1, AWorkCount);
  QueryPerformanceCounter(tCurrent);
  Unit1.Speeed := Round((AWorkCount / 1024) /
    ((tCurrent - tStart) / iCounterPerSec));
end;

procedure TDownLoader.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  QueryPerformanceFrequency(iCounterPerSec);
  PostMessage(Application.MainForm.Handle, MY_MESS, 0, AWorkCountMax);
  // Вывод размера файла.
  Unit1.Form1.HudLabel1.Text := floatToStrf((AWorkCountMax / 1048576), fffixed,
    8, 3) + 'Мб';
  QueryPerformanceCounter(tStart);
  Unit1.thl := True;
  Unit1.Form1.Timer1.Enabled := True;
end;

procedure TDownLoader.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  PostMessage(Application.MainForm.Handle, MY_MESS, 1, 0);
  Unit1.thl := False;
  Unit1.Form1.Timer1.Enabled := False;
  Unit1.Form1.HudLabel3.Text := '';
  Unit1.Form1.HudLabel1.Text := 'Готово !';
  ShellExecute(Handle, nil, PChar(ToFolder), nil, nil, SW_RESTORE);
end;

end.
