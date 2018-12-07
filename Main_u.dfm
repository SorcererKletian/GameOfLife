object Form2: TForm2
  Left = 600
  Top = 145
  Caption = 'Game of Life POGGERS'
  ClientHeight = 778
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 11
    Width = 53
    Height = 13
    Caption = 'Tamanho'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 248
    Top = 48
    Width = 80
    Height = 13
    Caption = 'Gera'#231#227'o Atual'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 248
    Top = 11
    Width = 95
    Height = 13
    Caption = 'Gera'#231#227'o M'#225'xima'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 489
    Top = 11
    Width = 88
    Height = 13
    Caption = 'Velocidade(ms)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 70
    Width = 700
    Height = 700
    TabOrder = 0
  end
  object btnGenerate: TButton
    Left = 8
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Generate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnGenerateClick
  end
  object edtTamanho: TEdit
    Left = 70
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 2
    OnExit = edtTamanhoExit
  end
  object btnStartStop: TButton
    Left = 116
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnStartStopClick
  end
  object edtGeracao: TEdit
    Left = 349
    Top = 45
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 4
  end
  object edtGeracaoMaxima: TEdit
    Left = 349
    Top = 8
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 5
  end
  object edtSpeed: TEdit
    Left = 583
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object chkAutoContraste: TCheckBox
    Left = 489
    Top = 47
    Width = 127
    Height = 17
    Caption = 'Alto Contraste'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = chkAutoContrasteClick
  end
  object Timer: TTimer
    Interval = 200
    OnTimer = TimerTimer
    Left = 680
    Top = 40
  end
end
