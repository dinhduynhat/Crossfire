object MainForm: TMainForm
  Left = 1103
  Top = 501
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CrossFire Emulator'
  ClientHeight = 463
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 440
    Width = 74
    Height = 13
    Caption = 'Online Player: 0'
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 625
    Height = 417
    TabStop = False
    Color = clWindowText
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = '@Microsoft YaHei UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = Memo1Change
    OnKeyDown = Memo1KeyDown
  end
  object Button1: TButton
    Left = 16
    Top = 424
    Width = 105
    Height = 33
    Caption = 'Start (&S)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = '????'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = False
    OnClick = Button1Click
    OnKeyDown = Button1KeyDown
  end
  object Button2: TButton
    Left = 144
    Top = 424
    Width = 99
    Height = 33
    Caption = 'Stop (&T)'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = '????'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TabStop = False
    OnClick = Button2Click
    OnKeyDown = Button2KeyDown
  end
  object Button4: TButton
    Left = 488
    Top = 424
    Width = 129
    Height = 33
    Caption = '> Developer (&D)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = '????'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    TabStop = False
    OnClick = Button4Click
    OnKeyDown = Button4KeyDown
  end
  object Memo3: TMemo
    Left = 624
    Top = 0
    Width = 481
    Height = 417
    TabStop = False
    Color = clNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = '????'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
    OnKeyDown = Memo3KeyDown
  end
  object Button5: TButton
    Left = 984
    Top = 425
    Width = 113
    Height = 32
    Caption = '< Standard (&R)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = '????'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    TabStop = False
    OnClick = Button5Click
    OnKeyDown = Button5KeyDown
  end
  object CheckBox1: TCheckBox
    Left = 784
    Top = 428
    Width = 129
    Height = 22
    TabStop = False
    Caption = 'Debug mode'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = '@Microsoft YaHei'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnKeyDown = CheckBox1KeyDown
  end
  object Button3: TButton
    Left = 264
    Top = 424
    Width = 99
    Height = 33
    Caption = 'ANNU Test'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = '????'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    TabStop = False
    OnClick = Timer2Timer
  end
  object LoginServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = LoginServerConnect
    OnExecute = LoginServerExecute
    OnDisconnect = LoginServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 40
    Top = 376
  end
  object GameServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = GameServerConnect
    OnExecute = GameServerExecute
    OnDisconnect = GameServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 80
    Top = 376
  end
  object XPManifest1: TXPManifest
    Left = 200
    Top = 376
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 160
    Top = 376
  end
  object PVPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = PVPServerUDPRead
    Left = 120
    Top = 376
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 240
    Top = 376
  end
  object ICClient: TIdUDPClient
    Port = 0
    Left = 280
    Top = 376
  end
end
