unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, vg_layouts, vg_controls, vg_tabcontrol, vg_scene, vg_extctrls,
  vg_objects, vg_dbctrls, vg_textbox, ExtCtrls, Sockets, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze, Unit2, Unit3, loginU, Tlhelp32, FileCtrl,
  IniFiles, ShellApi, SHlObj, RFSettings;

const
  MY_MESS = WM_USER + 100;

type
  TForm1 = class(TForm)
    vgScene1: TvgScene;
    Root1: TvgBackground;
    HudTabControl1: TvgHudTabControl;
    HudTabItem1: TvgHudTabItem;
    Layout1: TvgLayout;
    HudTabItem2: TvgHudTabItem;
    Layout2: TvgLayout;
    HudTabItem3: TvgHudTabItem;
    Layout3: TvgLayout;
    HudTabItem4: TvgHudTabItem;
    Layout4: TvgLayout;
    DBImage1: TvgDBImage;
    Brush1: TvgBrushObject;
    Brush2: TvgBrushObject;
    Brush3: TvgBrushObject;
    DBImage2: TvgDBImage;
    CompoundTextBox1: TvgCompoundTextBox;
    CompoundTextBox2: TvgCompoundTextBox;
    HudButton1: TvgHudButton;
    HudButton2: TvgHudButton;
    HudButton3: TvgHudButton;
    HudTextBox1: TvgHudTextBox;
    DBImage3: TvgDBImage;
    DBImage4: TvgDBImage;
    HudButton4: TvgHudButton;
    HudButton5: TvgHudButton;
    DBImage6: TvgDBImage;
    HudButton6: TvgHudButton;
    HudLabel2: TvgHudLabel;
    ToolBar1: TvgToolBar;
    CloseButton1: TvgCloseButton;
    ProgressBar1: TvgProgressBar;
    HudLabel1: TvgHudLabel;
    HudButton7: TvgHudButton;
    ColorButton1: TvgColorButton;
    IdAntiFreeze1: TIdAntiFreeze;
    HudLabel3: TvgHudLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    ColorButton2: TvgColorButton;
    ColorButton3: TvgColorButton;
    Timer3: TTimer;
    Timer4: TTimer;
    DBImage5: TvgDBImage;
    HudButton8: TvgHudButton;
    procedure Root1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ToolBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure DBImage1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure HudButton4Click(Sender: TObject);
    procedure MyProgress(var msg: TMessage); message MY_MESS;
    procedure fileget(FileURL: String; FileFold: String);
    procedure HudButton3Click(Sender: TObject);
    procedure HudButton6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure status(IPs, PORTs: String);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure HudButton1Click(Sender: TObject);
    function KillTask(ExeFileName: string): Integer;
    procedure HudButton7Click(Sender: TObject);
    procedure RFStart;
    procedure DBImage5Click(Sender: TObject);
    function GetSpecialPath(CSIDL: Word): string;
    procedure HudButton2Click(Sender: TObject);
    procedure CompoundTextBox2TextBoxKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure HudButton8Click(Sender: TObject);
    procedure HudButton5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  thl: boolean;
  Speeed: TLargeInteger;
  statrf, statmc, statcs: boolean;
  mestoRF, mestoAI, cfg: String;

implementation

{$R *.dfm}

Var
  Login: TLogin;

function TForm1.GetSpecialPath(CSIDL: Word): string;
var
  s: string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true) then
    s := '';
  result := PChar(s);
end;

function TForm1.KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TForm1.fileget(FileURL: String; FileFold: String);
Var
  d: TDownLoader;
begin
  d := TDownLoader.Create(true);
  d.Priority := tpHigher;
  d.URL := FileURL;
  d.ToFolder := FileFold;
  d.FreeOnTerminate := true;
  d.Resume;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  status('176.36.205.12', '25565');
  cfg := GetSpecialPath($28);
  ini := TIniFile.Create(cfg + '\CookieLConfig.ini');
  HudTextBox1.Text := ini.ReadString('Dir', 'RF', '');
  mestoRF := ini.ReadString('Dir', 'RF', '');
  CompoundTextBox1.TextBox.Text := ini.ReadString('Dir', 'login', '');
end;

procedure TForm1.status(IPs, PORTs: String);
Var
  s: TStatus;
begin
  s := TStatus.Create(true);
  s.Priority := tpNormal;
  s.IPs := IPs;
  s.PORTs := PORTs;
  s.FreeOnTerminate := true;
  s.Resume;
end;

procedure TForm1.CompoundTextBox2TextBoxKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = 13) then
    RFStart;
end;

procedure TForm1.DBImage1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TForm1.DBImage5Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://WeGotCookies.Net', nil, nil, SW_Normal);
end;

procedure TForm1.Root1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  HudLabel3.Text := IntToStr(Speeed) + ' Кб/сек';
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if HudTabItem3.IsSelected = true then
  begin
    if statmc = true then
      ColorButton2.Color := '#FF3CBE0C'
    else
      ColorButton2.Color := '#FFBE210C';
    status('176.36.205.12', '25565');
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if HudTabItem4.IsSelected = true then
  begin
    if statcs = true then
      ColorButton3.Color := '#FF3CBE0C'
    else
      ColorButton3.Color := '#FFBE210C';
    status('176.36.205.12', '27010');
  end;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  if HudTabItem1.IsSelected = true then
  begin
    if statrf = true then
      ColorButton1.Color := '#FF3CBE0C'
    else
      ColorButton1.Color := '#FFBE210C';
    status('176.36.205.12', '27780');
  end;
end;

procedure TForm1.ToolBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TForm1.RFStart;
begin
  ini.WriteString('Dir', 'login', CompoundTextBox1.Value);
  if (ColorButton1.Color = '#FF3CBE0C') and (CompoundTextBox2.Value <> '') and
    (CompoundTextBox1.Value <> '') then
  begin
    if FileExists(mestoRF + '\RF_Online.bin') then
    begin
      KillTask('RF_Online.bin');
      if Login.Login(CompoundTextBox1.Value, CompoundTextBox2.Value) = true then
        Form1.Close;
    end
    else
      ShowMessage('Ошибка: Выберети папку клиента');
  end
  else
    ShowMessage('Ошибка: Вы не ввели данные');
end;

procedure TForm1.HudButton1Click(Sender: TObject);
begin
  RFStart;
end;

procedure TForm1.HudButton2Click(Sender: TObject);
begin
  if Form2.Visible <> true then
    Form2.Show;
end;

procedure TForm1.HudButton3Click(Sender: TObject);
begin
  if thl = false then
    fileget('http://wegotcookies.net/Downloads/RFO_GU_WGC_Client.exe',
      'C:\RFO_GU_WGC_Client.exe');
end;

procedure TForm1.HudButton4Click(Sender: TObject);
begin
  if thl = false then
    fileget('http://wegotcookies.net/Downloads/Minecraft.exe',
      'C:\Minecraft.exe');
end;

procedure TForm1.HudButton5Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'http://wegotcookies.net/index.php?option=com_comprofiler&task=registers',
    nil, nil, SW_Normal);
end;

procedure TForm1.HudButton6Click(Sender: TObject);
begin
  if thl = false then
    fileget('http://wegotcookies.net/Downloads/CSS.rar', 'C:\CSS.rar');
end;

procedure TForm1.HudButton7Click(Sender: TObject);
begin
  SelectDirectory('Выбери папку RF Online', 'd:\ , c:\', mestoRF);
  if FileExists(mestoRF + '\RF_Online.bin') then
  begin
    ini := TIniFile.Create(cfg + '\CookieLConfig.ini');
    ini.WriteString('Dir', 'RF', mestoRF);
    HudTextBox1.Text := mestoRF;
  end
  else
    HudTextBox1.Text := 'Папка RF выбранна не верно , отсуствует RF_Online.bin';
end;

procedure TForm1.HudButton8Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'http://wegotcookies.net/index.php?option=com_comprofiler&task=registers',
    nil, nil, SW_Normal);
end;

procedure TForm1.MyProgress(var msg: TMessage);
begin
  case msg.WParam of
    0:
      begin
        ProgressBar1.Max := msg.LParam;
        ProgressBar1.Value := 0;
      end;
    1:
      ProgressBar1.Value := msg.LParam;
  end;
end;

end.
