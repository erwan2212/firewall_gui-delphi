program fwgui;

uses
  Forms,
  umain in 'umain.pas' {Form1},
  storage in '..\sniffer_src\storage.pas',
  NetFwTypeLib_TLB in '..\..\..\..\..\..\..\Program Files (x86)\Borland\Delphi7\Imports\NetFwTypeLib_TLB.pas',
  firewall in 'firewall.pas',
  ufrmAddRule in 'ufrmAddRule.pas' {frmAddRule},
  Ufrmmemo in 'Ufrmmemo.pas' {frmMemo},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmAddRule, frmAddRule);
  Application.CreateForm(TfrmMemo, frmMemo);
  Application.Run;
end.
