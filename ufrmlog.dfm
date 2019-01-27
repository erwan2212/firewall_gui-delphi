object frmLog: TfrmLog
  Left = 315
  Top = 119
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Memo'
  ClientHeight = 482
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 456
    Width = 3
    Height = 13
    Alignment = taCenter
    Caption = '-'
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 609
    Height = 417
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object txtfilename: TEdit
    Left = 8
    Top = 8
    Width = 609
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Top = 112
  end
end
