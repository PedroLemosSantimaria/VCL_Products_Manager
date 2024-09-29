object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 598
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 472
    Top = 19
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 632
    Top = 19
    Width = 34
    Height = 15
    Caption = 'Label2'
  end
  object ListView1: TListView
    Left = 778
    Top = 0
    Width = 250
    Height = 598
    Align = alRight
    Columns = <>
    TabOrder = 0
    ExplicitLeft = 312
    ExplicitTop = 88
    ExplicitHeight = 150
  end
  object Edit1: TEdit
    Left = 472
    Top = 40
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 632
    Top = 40
    Width = 121
    Height = 23
    TabOrder = 2
    Text = 'Edit2'
  end
  object Button1: TButton
    Left = 576
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 678
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
  end
  object Button3: TButton
    Left = 472
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 5
  end
  object NetHTTPClient1: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    OnAuthEvent = NetHTTPClient1AuthEvent
    Left = 432
    Top = 544
  end
end
