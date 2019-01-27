program fwgui;

uses
  Forms,
  ufrmfirewall in 'ufrmfirewall.pas' {frmFirewall},
  storage in '..\sniffer_src\storage.pas',
  NetFwTypeLib_TLB in '..\..\..\..\..\..\..\Program Files (x86)\Borland\Delphi7\Imports\NetFwTypeLib_TLB.pas',
  firewall in 'firewall.pas',
  ufrmAddRule in 'ufrmAddRule.pas' {frmAddRule},
  ufrmlog in 'ufrmlog.pas' {frmLog},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFirewall, frmFirewall);
  Application.CreateForm(TfrmAddRule, frmAddRule);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
