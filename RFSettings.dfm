object Form2: TForm2
  Left = 871
  Top = 104
  BorderStyle = bsNone
  ClientHeight = 294
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object vgScene1: TvgScene
    Left = 0
    Top = 0
    Width = 235
    Height = 294
    Align = alClient
    Transparency = True
    ExplicitLeft = 16
    ExplicitTop = 16
    ExplicitWidth = 100
    ExplicitHeight = 100
    DesignSnapGridShow = False
    DesignSnapToGrid = False
    DesignSnapToLines = True
    object Root1: TvgBackground
      Align = vaClient
      Width = 235.000000000000000000
      Height = 294.000000000000000000
      object HudWindow1: TvgHudWindow
        Align = vaClient
        Width = 235.000000000000000000
        Height = 294.000000000000000000
        HitTest = False
        TabOrder = 1
        ShowSizeGrip = False
        Font.Style = vgFontBold
        TextAlign = vgTextAlignNear
        Text = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1075#1088#1072#1092#1080#1082#1080
        object HudLabel1: TvgHudLabel
          Position.Point = '(18,39)'
          Width = 95.000000000000000000
          Height = 15.000000000000000000
          TabOrder = 1
          Font.Family = 'Arial'
          Font.Size = 12.000000000000000000
          TextAlign = vgTextAlignCenter
          VertTextAlign = vgTextAlignCenter
          Text = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' :'
        end
        object HudComboTextBox1: TvgHudComboTextBox
          Position.Point = '(19,59)'
          Width = 94.000000000000000000
          Height = 19.000000000000000000
          Resource = 'hudcombotextboxstyle'
          TabOrder = 2
          ReadOnly = False
          ItemHeight = 19.000000000000000000
          ItemIndex = -1
          Items.strings = (
            '800'
            '960'
            '1024'
            '1152'
            '1280'
            '1366'
            '1400'
            '1600')
          ListBoxResource = 'hudcombolistboxstyle'
          Text = 'X'
        end
        object HudComboTextBox2: TvgHudComboTextBox
          Position.Point = '(119,59)'
          Width = 94.000000000000000000
          Height = 19.000000000000000000
          Resource = 'hudcombotextboxstyle'
          TabOrder = 3
          ReadOnly = False
          ItemHeight = 19.000000000000000000
          ItemIndex = -1
          Items.strings = (
            '600'
            '640'
            '720'
            '960'
            '1024'
            '1080'
            '1280'
            '1440'
            '1600')
          ListBoxResource = 'hudcombolistboxstyle'
          Text = 'Y'
        end
        object HudLabel2: TvgHudLabel
          Position.Point = '(62,87)'
          Width = 113.000000000000000000
          Height = 17.000000000000000000
          TabOrder = 4
          Font.Family = 'Arial'
          Font.Size = 12.000000000000000000
          TextAlign = vgTextAlignCenter
          VertTextAlign = vgTextAlignCenter
          Text = #1042#1082#1083'/'#1042#1099#1082#1083#1102#1095#1080#1090#1100
        end
        object HudCheckBox1: TvgHudCheckBox
          Position.Point = '(152,108)'
          Width = 61.000000000000000000
          Height = 14.000000000000000000
          TabOrder = 5
          IsChecked = False
          TextAlign = vgTextAlignNear
          Text = #1047#1074#1091#1082#1080
        end
        object HudCheckBox2: TvgHudCheckBox
          Position.Point = '(152,128)'
          Width = 70.000000000000000000
          Height = 19.000000000000000000
          TabOrder = 6
          IsChecked = False
          TextAlign = vgTextAlignNear
          Text = #1052#1091#1079#1099#1082#1072
        end
        object HudCheckBox3: TvgHudCheckBox
          Position.Point = '(19,113)'
          Width = 100.000000000000000000
          Height = 19.000000000000000000
          TabOrder = 7
          IsChecked = False
          TextAlign = vgTextAlignNear
          Text = #1055#1086#1083#1085#1099#1081' '#1101#1082#1088#1072#1085
        end
        object HudComboTextBox3: TvgHudComboTextBox
          Position.Point = '(19,163)'
          Width = 171.000000000000000000
          Height = 22.000000000000000000
          Resource = 'hudcombotextboxstyle'
          TabOrder = 8
          ReadOnly = True
          ItemHeight = 19.000000000000000000
          ItemIndex = -1
          Items.strings = (
            '0'
            '1'
            '3')
          ListBoxResource = 'hudcombolistboxstyle'
          Text = #1050#1072#1095#1077#1089#1090#1074#1086' '#1090#1077#1082#1089#1090#1091#1088
        end
        object HudComboTextBox4: TvgHudComboTextBox
          Position.Point = '(21,197)'
          Width = 124.000000000000000000
          Height = 22.000000000000000000
          Resource = 'hudcombotextboxstyle'
          TabOrder = 9
          ReadOnly = True
          ItemHeight = 19.000000000000000000
          ItemIndex = -1
          Items.strings = (
            '0'
            '1'
            '3')
          ListBoxResource = 'hudcombolistboxstyle'
          Text = #1050#1072#1095#1077#1089#1090#1074#1086' '#1090#1077#1085#1077#1081
        end
        object HudButton2: TvgHudButton
          Position.Point = '(82,247)'
          Width = 86.000000000000000000
          Height = 23.000000000000000000
          OnClick = HudButton2Click
          TabOrder = 10
          StaysPressed = False
          IsPressed = False
          Font.Size = 12.000000000000000000
          TextAlign = vgTextAlignCenter
          Text = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        end
      end
    end
  end
end
