
unit umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,registry,
  Dialogs, StdCtrls, ComCtrls,shellapi,ActiveX,    ComObj, Menus,firewall,NetFwTypeLib_TLB,utils;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    SaveListviewHTML1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    DisableFirewall1: TMenuItem;
    OpenDialog1: TOpenDialog;
    EnableFirewall1: TMenuItem;
    GetProfile1: TMenuItem;
    GetDefaultINBOUNDactionforcurrentprofile1: TMenuItem;
    GetDefaultOUTBOUNDactionforcurrentpfile1: TMenuItem;
    RestoreLocalFirewallDefaults1: TMenuItem;
    N4: TMenuItem;
    Enablerule1: TMenuItem;
    Disablerule1: TMenuItem;
    Getsglobaldefaultbehaviorregardinginboundtraffic1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    OpenWindowsFirewallLogfile1: TMenuItem;
    Add1: TMenuItem;
    urnONlogging1: TMenuItem;
    urnOFFlogging1: TMenuItem;
    procedure SaveListviewHTML1Click(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure Delete1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure DisableFirewall1Click(Sender: TObject);
    procedure EnableFirewall1Click(Sender: TObject);
    procedure GetProfile1Click(Sender: TObject);
    procedure GetDefaultINBOUNDactionforcurrentprofile1Click(
      Sender: TObject);
    procedure GetDefaultOUTBOUNDactionforcurrentpfile1Click(
      Sender: TObject);
    procedure RestoreLocalFirewallDefaults1Click(Sender: TObject);
    procedure Enablerule1Click(Sender: TObject);
    procedure Disablerule1Click(Sender: TObject);
    procedure Getsglobaldefaultbehaviorregardinginboundtraffic1Click(
      Sender: TObject);
    procedure OpenWindowsFirewallLogfile1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure urnONlogging1Click(Sender: TObject);
    procedure urnOFFlogging1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Procedure EnumerateFirewallRules;
  public
    { Public declarations }
  end;

type
TCustomSortStyle = (cssAlphaNum, cssNumeric, cssDateTime,cssAlphaIP);
TLvSortOrder=array[0..4] of Boolean; // High[LvSortOrder] = Number of Lv Columns

//const FW_AUTHORIZEDAPPLICATION_CLASS_NAME = 'HNetCfg.FwAuthorizedApplication';

var
  Form1: TForm1;
  LvSortOrder: array[0..4] of Boolean;
  LvSortStyle: TCustomSortStyle;

implementation

uses ufrmAddRule, Ufrmmemo;

{$R *.dfm}

  function CustomSortProc(Item1, Item2: TListItem; SortColumn: Integer): Integer; stdcall;
var
  s1, s2: string;
  i1, i2: Integer;
  r1, r2: Boolean;
  d1, d2: TDateTime;

  { Helper functions }

  function IsValidNumber(AString : string; var AInteger : Integer): Boolean;
  var
    Code: Integer;
  begin
    Val(AString, AInteger, Code);
    Result := (Code = 0);
  end;

  function IsValidDate(AString : string; var ADateTime : TDateTime): Boolean;
  begin
    Result := True;
    try
      ADateTime := StrToDateTime(AString);
    except
      ADateTime := 0;
      Result := False;
    end;
  end;

  function CompareDates(dt1, dt2: TDateTime): Integer;
  begin
    if (dt1 > dt2) then Result := 1
    else
      if (dt1 = dt2) then Result := 0
    else
      Result := -1;
  end;

  function CompareNumeric(AInt1, AInt2: Integer): Integer;
  begin
    if AInt1 > AInt2 then Result := 1
    else
      if AInt1 = AInt2 then Result := 0
    else
      Result := -1;
  end;

begin
  Result := 0;

  if (Item1 = nil) or (Item2 = nil) then Exit;

  case SortColumn of
    -1 :
    { Compare Captions }
    begin
      s1 := Item1.Caption;
      s2 := Item2.Caption;
    end;
    else
    { Compare Subitems }
    begin
      s1 := '';
      s2 := '';
      { Check Range }
      if (SortColumn < Item1.SubItems.Count) then
        s1 := Item1.SubItems[SortColumn];
      if (SortColumn < Item2.SubItems.Count) then
        s2 := Item2.SubItems[SortColumn]
    end;
  end;

  { Sort styles }

  case LvSortStyle of
    cssAlphaNum : Result := lstrcmp(PChar(s1), PChar(s2));
    cssNumeric  : begin
                    r1 := IsValidNumber(s1, i1);
                    r2 := IsValidNumber(s2, i2);
                    Result := ord(r1 or r2);
                    if Result <> 0 then
                      Result := CompareNumeric(i2, i1);
                  end;
    cssDateTime : begin
                    r1 := IsValidDate(s1, d1);
                    r2 := IsValidDate(s2, d2);
                    Result := ord(r1 or r2);
                    if Result <> 0 then
                      Result := CompareDates(d1, d2);
                  end;
   {
    cssAlphaIp: begin
                    r1 := IsValidNumber(inttostr(ntohl(string2ip(s1))), i1);
                    r2 := IsValidNumber(inttostr(ntohl(string2ip(s2))), i2);
                    Result := ord(r1 or r2);
                    if Result <> 0 then
                      Result := CompareNumeric(i2, i1);
                end;
    }
  end;

  { Sort direction }

  if LvSortOrder[SortColumn + 1] then
    Result := - Result;
end;


//This code enumerates Windows Firewall rules using the Microsoft Windows Firewall APIs.
Procedure TForm1.EnumerateFirewallRules;
Const
  NET_FW_PROFILE2_DOMAIN  = 1;
  NET_FW_PROFILE2_PRIVATE = 2;
  NET_FW_PROFILE2_PUBLIC  = 4;

  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_IP_PROTOCOL_UDP = 17;
  NET_FW_IP_PROTOCOL_ICMPv4 = 1;
  NET_FW_IP_PROTOCOL_ICMPv6 = 58;
 
  NET_FW_RULE_DIR_IN = 1;
  NET_FW_RULE_DIR_OUT = 2;
 
  NET_FW_ACTION_BLOCK = 0;
  NET_FW_ACTION_ALLOW = 1;
 
var
 CurrentProfiles : Integer;
 fwPolicy2       : OleVariant;
 RulesObject     : OleVariant;
 rule            : OleVariant;
 oEnum           : IEnumvariant;
 iValue          : LongWord;
 li:TListItem ;
begin
ListView1.Clear ;
  // Create the FwPolicy2 object.
  fwPolicy2   := CreateOleObject('HNetCfg.FwPolicy2');
  RulesObject := fwPolicy2.Rules;
  CurrentProfiles := fwPolicy2.CurrentProfileTypes;
 
//  if (CurrentProfiles AND NET_FW_PROFILE2_DOMAIN)<>0 then   Writeln('Domain Firewall Profile is active');

//  if ( CurrentProfiles AND NET_FW_PROFILE2_PRIVATE )<>0 then  Writeln('Private Firewall Profile is active');

//  if ( CurrentProfiles AND NET_FW_PROFILE2_PUBLIC )<>0 then   Writeln('Public Firewall Profile is active');
 
//  Writeln('Rules:');
 
  oEnum         := IUnknown(Rulesobject._NewEnum) as IEnumVariant;
  while oEnum.Next(1, rule, iValue) = 0 do
  begin
    if (rule.Profiles And CurrentProfiles)<>0 then
    begin
    li:=ListView1.Items.Add ;
        li.Caption:=(rule.Name);
        
        li.SubItems.Add (rule.Description);
        li.SubItems.Add(rule.ApplicationName);
        li.SubItems.Add(rule.ServiceName);

        Case rule.Protocol of
           NET_FW_IP_PROTOCOL_TCP    : li.SubItems.Add('TCP');
           NET_FW_IP_PROTOCOL_UDP    : li.SubItems.Add('UDP');
           NET_FW_IP_PROTOCOL_ICMPv4 : li.SubItems.Add('ICMPv4');
           NET_FW_IP_PROTOCOL_ICMPv6 : li.SubItems.Add('ICMPv6');
        Else                           li.SubItems.Add(VarToStr(rule.Protocol));
        End;
 

        if (rule.Protocol = NET_FW_IP_PROTOCOL_TCP) or (rule.Protocol = NET_FW_IP_PROTOCOL_UDP) then
        begin
          li.SubItems.Add(rule.LocalPorts);
          li.SubItems.Add(rule.RemotePorts);
          li.SubItems.Add(rule.LocalAddresses);
          li.SubItems.Add(rule.RemoteAddresses);
        end
        else
        begin
          li.SubItems.Add('');
          li.SubItems.Add('');
          li.SubItems.Add('');
          li.SubItems.Add('');
        end;

        if (rule.Protocol = NET_FW_IP_PROTOCOL_ICMPv4) or (rule.Protocol = NET_FW_IP_PROTOCOL_ICMPv6) then
          li.SubItems.Add(rule.IcmpTypesAndCodes)
          else li.SubItems.Add('');

        Case rule.Direction of
            NET_FW_RULE_DIR_IN :  li.SubItems.Add('In');
            NET_FW_RULE_DIR_OUT:  li.SubItems.Add('Out');
        End;
 
        li.SubItems.Add(VarToStr(rule.Enabled));
        li.SubItems.Add(VarToStr(rule.EdgeTraversal));
 
        Case rule.Action of
           NET_FW_ACTION_ALLOW : li.SubItems.Add('Allow');
           NET_FW_ACTION_BLOCk : li.SubItems.Add('Block');
        End;
 
 
        li.SubItems.Add(rule.Grouping);
        li.SubItems.Add(rule.InterfaceTypes);

    end;
    rule:=Unassigned;
  end;
 
 
end;

procedure TForm1.SaveListviewHTML1Click(Sender: TObject);
var
bytesWritten: integer;
f: TFileStream;
txt:string;
begin
//SaveListViewHTML(ListView1,ExtractFilePath (application.ExeName)+'rules.html'  );
  txt:=ListView2HTML(ListView1,'firewall rules');
  // save text
  f := TFileStream.Create(ExtractFilePath (application.ExeName)+'rules.html', fmCreate or fmOpenWrite);
  try
    bytesWritten := f.Write(txt[1], Length(txt));
    if bytesWritten=0 then ;
  finally
    FreeAndNil(f);
  end;
end;

procedure TForm1.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
const
  //cStripe = $CCFFCC;  // colour of alternate list items
  cstripe = $E5E5E5;
begin
  if odd(item.Index) then
    // odd list items have green background
    Sender.Canvas.Brush.Color := cstripe
  else
    // even list items have window colour background
    Sender.Canvas.Brush.Color := clWindow;

end;



procedure TForm1.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var i:byte;  
begin
if Column.Index = 0 then
    LvSortStyle := cssAlphaIP
  else
    LvSortStyle := cssAlphaNum;

  { Call the CustomSort method }
  TListView(sender).CustomSort(@CustomSortProc, Column.Index -1);
  for i:=0 to TListView(sender).Columns.Count -1 do
    begin if i<>column.index then LvSortOrder[i]:=false;end;
  { Set the sort order for the column}
  LvSortOrder[Column.Index] := not LvSortOrder[Column.Index];
end;

procedure TForm1.Delete1Click(Sender: TObject);
var
app:string;
begin
if ListView1.Selected =nil then exit;
app:=ListView1.Selected.caption;
//app:=ListView1.Selected.SubItems [1];
if messageboxa(0,pchar('Delete '+ app+'?'),'fw gui',MB_YESNO )=ID_YES then
  begin
  //appname pour nt6 - filename pour nt5
  //CoInitialize(nil);
  try
  DeleteFromWinFirewallNT6(app);
  EnumerateFirewallRules;
  except
  on e:exception do showmessage(e.Message );
  end;
  //CoUninitialize;
  end;
end;

procedure TForm1.Refresh1Click(Sender: TObject);
begin
EnumerateFirewallRules ;
end;


procedure TForm1.DisableFirewall1Click(Sender: TObject);
var
PolicyObject: Variant;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_DOMAIN) := FALSE;
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_PRIVATE) := FALSE;
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_PUBLIC) := FALSE;
showmessage('Done');
except
on e:exception do showmessage(e.Message );
end;
end;



procedure TForm1.EnableFirewall1Click(Sender: TObject);
var
PolicyObject: Variant;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_DOMAIN) := true;
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_PRIVATE) := true;
PolicyObject.FirewallEnabled(NET_FW_PROFILE2_PUBLIC) := true;
showmessage('Done');
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.GetProfile1Click(Sender: TObject);
var
PolicyObject: Variant;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
case  PolicyObject.CurrentProfileTypes of
      NET_FW_PROFILE2_DOMAIN:showmessage('NET_FW_PROFILE2_DOMAIN');
      NET_FW_PROFILE2_PRIVATE:showmessage('NET_FW_PROFILE2_PRIVATE');
      NET_FW_PROFILE2_PUBLIC:showmessage('NET_FW_PROFILE2_PUBLIC');
      else showmessage(PolicyObject.CurrentProfileTypes);
end;
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.GetDefaultINBOUNDactionforcurrentprofile1Click(
  Sender: TObject);
var
PolicyObject: Variant;
action,CurrentProfileType:integer;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
CurrentProfileType:=  PolicyObject.CurrentProfileTypes;
action:=PolicyObject.DefaultInboundAction[CurrentProfileType];
case action of
NET_FW_ACTION_BLOCK :showmessage('NET_FW_ACTION_BLOCK');
NET_FW_ACTION_ALLOW :showmessage('NET_FW_ACTION_ALLOW');
else showmessage(inttostr(action));
end;//case
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.GetDefaultOUTBOUNDactionforcurrentpfile1Click(
  Sender: TObject);
var
PolicyObject: Variant;
action,CurrentProfileType:integer;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
CurrentProfileType:=  PolicyObject.CurrentProfileTypes;
action:=PolicyObject.DefaultOutboundAction[CurrentProfileType];
case action of
NET_FW_ACTION_BLOCK :showmessage('NET_FW_ACTION_BLOCK');
NET_FW_ACTION_ALLOW :showmessage('NET_FW_ACTION_ALLOW');
else showmessage(inttostr(action));
end;//case
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.RestoreLocalFirewallDefaults1Click(Sender: TObject);
var
PolicyObject: Variant;
ret:hresult;
begin
if messageboxa(0,'Are you sure?','FW GUI', mb_YesNo)=id_no then exit;
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
ret:=PolicyObject.RestoreLocalFirewallDefaults;
if ret=S_OK then showmessage('ok') else showmessage('not ok:'+inttostr(ret));
EnumerateFirewallRules;
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.Enablerule1Click(Sender: TObject);
var
PolicyObject: Variant;
rule:olevariant;
app:string;
begin
app:=ListView1.Selected.caption;
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
rule := PolicyObject.Rules.Item(app); // Name of your rule here
rule.Enabled := true;
EnumerateFirewallRules ;
except
on e:exception do showmessage(e.Message );
end;


end;

procedure TForm1.Disablerule1Click(Sender: TObject);
var
PolicyObject: Variant;
rule:olevariant;
app:string;
begin
app:=ListView1.Selected.caption;
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
rule := PolicyObject.Rules.Item(app); // Name of your rule here
rule.Enabled := false;
EnumerateFirewallRules ;
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TForm1.Getsglobaldefaultbehaviorregardinginboundtraffic1Click(
  Sender: TObject);
var
PolicyObject: Variant;
action,CurrentProfileType:integer;
begin
try
PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
CurrentProfileType:=  PolicyObject.CurrentProfileTypes;
action:=PolicyObject.BlockAllInboundTraffic[CurrentProfileType];
case action of
NET_FW_ACTION_BLOCK :showmessage('NET_FW_ACTION_BLOCK');
NET_FW_ACTION_ALLOW :showmessage('NET_FW_ACTION_ALLOW');
else showmessage(inttostr(action));
end;//case
except
on e:exception do showmessage(e.Message );
end;
end;

Function ExpandEnvStrings(DirStr: String): String; 
Var EnvVariable : Array[0..512-1] Of Char; 
Begin 
Result := EmptyStr; 
ExpandEnvironmentStrings(PChar(DirStr), @EnvVariable, 512); 
Result := EnvVariable; 
End ;

procedure RegWriteInteger(path,key:string;value:integer);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_SET_VALUE);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE; // or HKEY_CURRENT_USER
    if reg.OpenKey(path, true) then
    try
      reg.WriteInteger (key, value);
    finally
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure TForm1.OpenWindowsFirewallLogfile1Click(Sender: TObject);
begin

//check
//HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy

try
//ShellExecute(0,'open','notepad.exe',pchar(ExpandEnvStrings('%systemroot%') + '\system32\LogFiles\Firewall\pfirewall.log'), nil, SW_SHOWNORMAL) ;
frmmemo:=tfrmmemo.create(application);
frmMemo.Show ;
frmMemo.txtfilename.Text :=ExpandEnvStrings('%systemroot%') + '\system32\LogFiles\Firewall\pfirewall.log';
frmMemo.open;
except
on e:exception do showmessage(e.Message );
end;

//if FileExists('%windir%\system32\logfiles\firewall\domainfirewall.log') then

end;

procedure TForm1.Add1Click(Sender: TObject);
var
ret:integer;
dir:NET_FW_RULE_DIRECTION_;
action:NET_FW_ACTION_;
protocol:NET_FW_IP_PROTOCOL_;
app_name,rule_name:widestring;
ports:string;
begin
frmaddrule:=tfrmaddrule.create(application);
ret:=frmaddrule.ShowModal ;
if (ret=mrcancel) or (ret<>mrok) then
  begin
  frmaddrule.Release  ;
  exit;
  end;
//
if frmaddrule.rbin.Checked  then dir:=NET_FW_RULE_DIR_IN else dir:=NET_FW_RULE_DIR_OUT;
if frmaddrule.rballow.Checked  then action:=NET_FW_ACTION_ALLOW else action:=NET_FW_ACTION_BLOCK;
if frmAddRule.rbtcp.Checked then protocol:=NET_FW_IP_PROTOCOL_TCP;
if frmAddRule.rbudp.Checked then protocol:=NET_FW_IP_PROTOCOL_UDP;
if frmAddRule.rbany.Checked then protocol:=NET_FW_IP_PROTOCOL_ANY;
if frmAddRule.rbicmp.Checked then protocol:=NET_FW_IP_PROTOCOL_ICMPv4;
app_name :=frmAddRule.txtappname.Text ;
rule_name :=frmAddRule.txtrulename.Text ;
if protocol<>NET_FW_IP_PROTOCOL_ANY then ports:=frmAddRule.txtports.Text ;
frmaddrule.Release  ;
//
try
//ports are separated with a comma
//icmptypesandcodes in the form type:code e.g 8:*
AddFirewallExceptionNT6(rule_name,app_name,dir,action,protocol,ports  );
EnumerateFirewallRules;
except
on e:exception do showmessage(e.Message );
end;

//
end;

procedure TForm1.urnONlogging1Click(Sender: TObject);
begin
{
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\Logging','LogDroppedPackets',1);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\Logging','LogSuccessfulConnections',1);

RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\Logging','LogDroppedPackets',1);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\Logging','LogSuccessfulConnections',1);

RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\Logging','LogDroppedPackets',1);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\Logging','LogSuccessfulConnections',1);
}
//netsh advfirewall set allprofiles logging filename « D:\WSFirewall\Logs\pfirewall.log«
//netsh advfirewall set currentprofile logging allowedconnections enable
//netsh advfirewall set currentprofile logging droppedconnections enable
//could not find how to perform the below programatically :(
//alternative : update registry, stop/start mpvsvc, disable/enable fw ... too radical
//PolicyVersion?
if ShellExecute(0,'open','netsh','advfirewall set currentprofile logging droppedconnections enable', nil, SW_HIDE) <32
  then showmessage('failed') else showmessage('Done');
end;

procedure TForm1.urnOFFlogging1Click(Sender: TObject);
begin
{
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\Logging','LogDroppedPackets',0);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\Logging','LogSuccessfulConnections',0);

RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\Logging','LogDroppedPackets',0);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\Logging','LogSuccessfulConnections',0);

RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\Logging','LogDroppedPackets',0);
RegWriteInteger('SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\Logging','LogSuccessfulConnections',0);
}
//netsh advfirewall set allprofiles logging filename « D:\WSFirewall\Logs\pfirewall.log«
//netsh advfirewall set currentprofile logging allowedconnections disable
//netsh advfirewall set currentprofile logging droppedconnections disable
if ShellExecute(0,'open','netsh','advfirewall set currentprofile logging droppedconnections disable', nil, SW_HIDE) <32
  then showmessage('failed') else showmessage('Done');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
try
    CoInitialize(nil);
    try
      EnumerateFirewallRules;
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        showmessage(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        showmessage(E.Classname+ ':'+ E.Message);
 end;
end;

end.
