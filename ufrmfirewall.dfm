object frmFirewall: TfrmFirewall
  Left = 358
  Top = 143
  Width = 1023
  Height = 768
  Caption = 'Firewall Rules 0.1 by erwan22@gmail.com'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 1015
    Height = 737
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Description'
        Width = 150
      end
      item
        Caption = 'ApplicationName'
        Width = 150
      end
      item
        Caption = 'ServiceName'
        Width = 100
      end
      item
        Caption = 'Protocol'
      end
      item
        Caption = 'LocalPorts'
      end
      item
        Caption = 'RemotePorts'
      end
      item
        Caption = 'LocalAddresses'
      end
      item
        Caption = 'RemoteAddresses'
      end
      item
        Caption = 'IcmpTypesAndCodes'
      end
      item
        Caption = 'Direction'
      end
      item
        Caption = 'Enabled'
      end
      item
        Caption = 'Edge'
      end
      item
        Caption = 'Action'
      end
      item
        Caption = 'Grouping'
        Width = 0
      end
      item
        Caption = 'InterfaceTypes'
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnCustomDrawItem = ListView1CustomDrawItem
  end
  object PopupMenu1: TPopupMenu
    Left = 440
    Top = 344
    object SaveListviewHTML1: TMenuItem
      Caption = 'Save Listview (HTML)'
      OnClick = SaveListviewHTML1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete Rule'
      OnClick = Delete1Click
    end
    object Add1: TMenuItem
      Caption = 'Add Rule'
      OnClick = Add1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Enablerule1: TMenuItem
      Caption = 'Enable rule'
      OnClick = Enablerule1Click
    end
    object Disablerule1: TMenuItem
      Caption = 'Disable rule'
      OnClick = Disablerule1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object DisableFirewall1: TMenuItem
      Caption = 'Disable Firewall'
      OnClick = DisableFirewall1Click
    end
    object EnableFirewall1: TMenuItem
      Caption = 'Enable Firewall'
      OnClick = EnableFirewall1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object StopService1: TMenuItem
      Caption = 'Stop Service'
      OnClick = StopService1Click
    end
    object StartService1: TMenuItem
      Caption = 'Start Service'
      OnClick = StartService1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object urnONlogging1: TMenuItem
      Caption = 'Turn ON logging (dropped)'
      OnClick = urnONlogging1Click
    end
    object urnOFFlogging1: TMenuItem
      Caption = 'Turn OFF logging (dropped)'
      OnClick = urnOFFlogging1Click
    end
    object OpenWindowsFirewallLogfile1: TMenuItem
      Caption = 'Open Windows Firewall Log file'
      OnClick = OpenWindowsFirewallLogfile1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object GetProfile1: TMenuItem
      Caption = 'Get Profile'
      OnClick = GetProfile1Click
    end
    object GetDefaultINBOUNDactionforcurrentprofile1: TMenuItem
      Caption = 'Get Default INBOUND action for current profile'
      OnClick = GetDefaultINBOUNDactionforcurrentprofile1Click
    end
    object GetDefaultOUTBOUNDactionforcurrentpfile1: TMenuItem
      Caption = 'Get Default OUTBOUND action for current profile'
      OnClick = GetDefaultOUTBOUNDactionforcurrentpfile1Click
    end
    object Getsglobaldefaultbehaviorregardinginboundtraffic1: TMenuItem
      Caption = 'Get global default INBOUND action for current profile'
      Visible = False
      OnClick = Getsglobaldefaultbehaviorregardinginboundtraffic1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object RestoreLocalFirewallDefaults1: TMenuItem
      Caption = 'Restore Local Firewall Defaults '
      OnClick = RestoreLocalFirewallDefaults1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 400
    Top = 344
  end
end
