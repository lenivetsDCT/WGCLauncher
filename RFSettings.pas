unit RFSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, vg_controls, vg_scene, vg_textbox, IniFiles, LoginU;

type
  TForm2 = class(TForm)
    vgScene1: TvgScene;
    Root1: TvgBackground;
    HudWindow1: TvgHudWindow;
    HudLabel1: TvgHudLabel;
    HudComboTextBox1: TvgHudComboTextBox;
    HudComboTextBox2: TvgHudComboTextBox;
    HudLabel2: TvgHudLabel;
    HudCheckBox1: TvgHudCheckBox;
    HudCheckBox2: TvgHudCheckBox;
    HudCheckBox3: TvgHudCheckBox;
    HudComboTextBox3: TvgHudComboTextBox;
    HudComboTextBox4: TvgHudComboTextBox;
    HudButton2: TvgHudButton;
    procedure HudButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
Var
  Mesto: String;
  ini2: TIniFile;
begin
  Mesto := ini.ReadString('Dir', 'RF', ' ');
  ini2 := TIniFile.Create(Mesto + '\R3Engine.ini');
  HudComboTextBox1.Text := ini2.ReadString('RenderState', 'ScreenXSize', ' ');
  HudComboTextBox2.Text := ini2.ReadString('RenderState', 'ScreenYSize', ' ');
  if ini2.ReadString('Sound', 'Sound', ' ') = 'TRUE' then
    HudCheckBox1.IsChecked := True
  else
    HudCheckBox1.IsChecked := False;

  if ini2.ReadString('Sound', 'Music', ' ') = 'TRUE' then
    HudCheckBox2.IsChecked := True
  else
    HudCheckBox2.IsChecked := False;

  if ini2.ReadString('RenderState', 'bFullScreen', ' ') = 'TRUE' then
    HudCheckBox3.IsChecked := True
  else
    HudCheckBox3.IsChecked := False;

  HudComboTextBox3.Text := ini2.ReadString('RenderState', 'TextureDetail', ' ');

  HudComboTextBox4.Text := ini2.ReadString('RenderState', 'ShadowDetail', ' ');
end;

procedure TForm2.HudButton2Click(Sender: TObject);
Var
  Mesto: String;
  ini2: TIniFile;
begin
  Mesto := ini.ReadString('Dir', 'RF', ' ');
  ini2 := TIniFile.Create(Mesto + '\R3Engine.ini');
  ini2.WriteString('RenderState', 'ScreenXSize', HudComboTextBox1.Text);
  ini2.WriteString('RenderState', 'ScreenYSize', HudComboTextBox2.Text);

  if HudCheckBox1.IsChecked = True then
    ini2.WriteString('Sound', 'Sound', 'TRUE')
  else
    ini2.WriteString('Sound', 'Sound', 'FALSE');

  if HudCheckBox2.IsChecked = True then
    ini2.WriteString('Sound', 'Music', 'TRUE')
  else
    ini2.WriteString('Sound', 'Music', 'FALSE');

  if HudCheckBox3.IsChecked = True then
    ini2.WriteString('RenderState', 'bFullScreen', 'TRUE')
  else
    ini2.WriteString('RenderState', 'bFullScreen', 'FALSE');

  if HudComboTextBox3.Text <> 'Качество текстур' then
    ini2.WriteString('RenderState', 'TextureDetail', HudComboTextBox3.Text);

  if HudComboTextBox4.Text <> 'Качество теней' then
    ini2.WriteString('RenderState', 'ShadowDetail', HudComboTextBox4.Text);
Form2.Hide;
end;

end.
