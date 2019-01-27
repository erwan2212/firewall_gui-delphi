object frmAddRule: TfrmAddRule
  Left = 736
  Top = 104
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Add Rule'
  ClientHeight = 382
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Rule Name'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 52
    Height = 13
    Caption = 'Application'
  end
  object txtappname: TEdit
    Left = 8
    Top = 64
    Width = 337
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 352
    Top = 64
    Width = 33
    Height = 17
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object txtrulename: TEdit
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 96
    Width = 337
    Height = 57
    Caption = 'Direction'
    TabOrder = 3
    object rbin: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'INBOUND'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbinClick
    end
    object rbout: TRadioButton
      Left = 128
      Top = 24
      Width = 113
      Height = 17
      Caption = 'OUTBOUND'
      TabOrder = 1
      OnClick = rboutClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 160
    Width = 337
    Height = 57
    Caption = 'Action'
    TabOrder = 4
    object rballow: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'ALLOW'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbblock: TRadioButton
      Left = 128
      Top = 24
      Width = 113
      Height = 17
      Caption = 'BLOCK'
      TabOrder = 1
    end
  end
  object btnOK: TButton
    Left = 8
    Top = 352
    Width = 105
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button3: TButton
    Left = 232
    Top = 352
    Width = 113
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 224
    Width = 337
    Height = 57
    Caption = 'Protocol'
    TabOrder = 7
    object rbtcp: TRadioButton
      Left = 96
      Top = 24
      Width = 57
      Height = 17
      Caption = 'TCP'
      TabOrder = 0
    end
    object rbudp: TRadioButton
      Left = 168
      Top = 24
      Width = 73
      Height = 17
      Caption = 'UDP'
      TabOrder = 1
    end
    object rbany: TRadioButton
      Left = 16
      Top = 24
      Width = 57
      Height = 17
      Caption = 'ANY'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object rbicmp: TRadioButton
      Left = 248
      Top = 24
      Width = 73
      Height = 17
      Caption = 'ICMP'
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 288
    Width = 337
    Height = 57
    Caption = 'Ports() or IcmpTypesAndCodes'
    TabOrder = 8
    object txtports: TEdit
      Left = 8
      Top = 24
      Width = 321
      Height = 21
      TabOrder = 0
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 360
    Top = 24
  end
end
