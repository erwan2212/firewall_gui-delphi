//check https://docs.microsoft.com/en-us/windows/desktop/api/netfw/nn-netfw-inetfwpolicy2

//about edge traversal : https://serverfault.com/questions/89824/windows-advanced-firewall-what-does-edge-traversal-mean
//"allow packets from other subnets"

//https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc730690(v=ws.10)
{
Firewall rules are applied with the following precedence:
Allow this firewall rule to override block rules
Block connection
Allow connection
Default profile behavior (allow connection or block connection, as specified on the Profile tab of the Windows Firewall with Advanced Security Properties dialog)
}


unit firewall;

interface

uses windows,Variants,ComObj,NetFwTypeLib_TLB;

procedure AddFirewallExceptionIcmp(rulename,IcmpTypesAndCodes:widestring;
  const dir:NET_FW_RULE_DIRECTION_=NET_FW_RULE_DIR_IN;
  const action:NET_FW_ACTION_=NET_FW_ACTION_ALLOW);

procedure DeleteFromWinFirewallNT6(const RuleName: wideString);
procedure AddFirewallExceptionNT6(const Caption, AppPath: wideString;
    const dir:NET_FW_RULE_DIRECTION_=NET_FW_RULE_DIR_IN;
    const action:NET_FW_ACTION_=NET_FW_ACTION_ALLOW;
    const protocol:NET_FW_IP_PROTOCOL_=NET_FW_IP_PROTOCOL_ANY;
    const ports_or_IcmpTypesAndCodes:widestring='');

const
  NET_FW_IP_PROTOCOL_ICMPv4 = 1;
  NET_FW_IP_PROTOCOL_ICMPv6 = 58;    

implementation

//*********************************************************************************
function IsWindowsNT6: Boolean;
var
	Version: TOsversionInfo;
begin
  Version.dwOSVersionInfoSize := SizeOf(Version);
	GetVersionEx(Version);
	Result := (Version.dwPlatformId=VER_PLATFORM_WIN32_NT)  and (Version.dwMajorVersion  >= 6);
end;

procedure AddFirewallExceptionNT6(const Caption, AppPath: wideString;
    const dir:NET_FW_RULE_DIRECTION_=NET_FW_RULE_DIR_IN;
    const action:NET_FW_ACTION_=NET_FW_ACTION_ALLOW;
    const protocol:NET_FW_IP_PROTOCOL_=NET_FW_IP_PROTOCOL_ANY;
    const ports_or_IcmpTypesAndCodes:widestring='');
var
  Profile: Integer;
  Policy2: OleVariant;
  RObject: OleVariant;
  NewRule: OleVariant;
begin
  //Profile := NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC or NET_FW_PROFILE2_DOMAIN;
  if caption='' then exit;
  Profile :=NET_FW_PROFILE2_ALL;
  Policy2 := CreateOleObject('HNetCfg.FwPolicy2');
  RObject := Policy2.Rules;
  NewRule := CreateOleObject('HNetCfg.FWRule');
  NewRule.Name        := Caption;
  NewRule.Description := Caption;
  if apppath<>'' then NewRule.ApplicationName := AppPath;
  NewRule.direction:=dir;
  NewRule.Protocol := protocol;
  if (protocol=NET_FW_IP_PROTOCOL_TCP) or (protocol=NET_FW_IP_PROTOCOL_UDP) then
  begin
  if (ports_or_IcmpTypesAndCodes<>'') and (dir=NET_FW_RULE_DIR_IN) then
    begin
    NewRule.localports:=ports_or_IcmpTypesAndCodes;
    end;
  if (ports_or_IcmpTypesAndCodes<>'') and (dir=NET_FW_RULE_DIR_OUT) then
    begin
    NewRule.RemotePorts:=ports_or_IcmpTypesAndCodes;
    end;
  end;
  if protocol=NET_FW_IP_PROTOCOL_ICMPv4 then NewRule.IcmpTypesAndCodes:=ports_or_IcmpTypesAndCodes;
  NewRule.Enabled := True;
  NewRule.Grouping := '';
  NewRule.Profiles := Profile;
  NewRule.Action := action;
  RObject.Add(NewRule);
end;

procedure AddFirewallExceptionIcmp(rulename,IcmpTypesAndCodes:widestring;
  const dir:NET_FW_RULE_DIRECTION_=NET_FW_RULE_DIR_IN;
  const action:NET_FW_ACTION_=NET_FW_ACTION_ALLOW);
var
	FirewallObject: Variant;
	FirewallManager: Variant;
	FirewallProfile: Variant;
	PolicyObject: Variant;
	NewRule: Variant;
begin
	try
		if IsWindowsNT6() then
		begin
			// create new inbound firewall exception:
			PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
			NewRule := CreateOleObject('HNetCfg.FWRule');
			NewRule.Name := rulename ;
			NewRule.Protocol := NET_FW_IP_PROTOCOL_ICMPv4;
      newrule.IcmpTypesAndCodes:=IcmpTypesAndCodes;
      NewRule.Direction := dir;
			NewRule.Action := action;
			NewRule.Enabled := True;
			PolicyObject.Rules.Add(NewRule);
		end
		else
		begin
			FirewallObject := CreateOleObject('HNetCfg.FwAuthorizedApplication');
			FirewallObject.Name := rulename ;
			FirewallObject.Scope := NET_FW_SCOPE_ALL;
			FirewallObject.IpVersion := NET_FW_IP_PROTOCOL_ICMPv4;
			FirewallObject.Enabled := True;

			FirewallManager := CreateOleObject('HNetCfg.FwMgr');

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_STANDARD);
			FirewallProfile.AuthorizedApplications.Add(FirewallObject);

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_DOMAIN);
			FirewallProfile.AuthorizedApplications.Add(FirewallObject);
		end;
	except
	end;
end;

procedure AddFirewallExceptionXP(AppName, FileName: string);
var
	FirewallObject: Variant;
	FirewallManager: Variant;
	FirewallProfile: Variant;
	PolicyObject: Variant;
	NewRule: Variant;
begin
	try
			FirewallObject := CreateOleObject('HNetCfg.FwAuthorizedApplication');
			FirewallObject.ProcessImageFileName := FileName;
			FirewallObject.Name := AppName;
			FirewallObject.Scope := NET_FW_SCOPE_ALL;
			FirewallObject.IpVersion := NET_FW_IP_VERSION_ANY;
			FirewallObject.Enabled := True;

			FirewallManager := CreateOleObject('HNetCfg.FwMgr');

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_STANDARD);
			FirewallProfile.AuthorizedApplications.Add(FirewallObject);

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_DOMAIN);
			FirewallProfile.AuthorizedApplications.Add(FirewallObject);
	except
	end;
end;

procedure DeleteFromWinFirewallNT6(const RuleName: wideString);
var
  Profile: Integer;
  Policy2: OleVariant;
  RObject: OleVariant;
  policy3: INetFwPolicy2;
begin
  //Profile := NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC or NET_FW_PROFILE2_DOMAIN;
  Profile :=NET_FW_PROFILE2_ALL;
  //policy3 := INetFwPolicy2(CreateOleObject( 'HNetCfg.FwPolicy2' ));
  //policy3.Rules.Remove(rulename);
  Policy2 := CreateOleObject('HNetCfg.FwPolicy2');
  RObject := Policy2.Rules;
  RObject.Remove(RuleName);
end;

//xp & vista=HNetCfg.FwMgr
procedure DeleteFromWinFirewall(AppName: widestring);
var
	FirewallManager: Variant;
	FirewallProfile: Variant;
	PolicyObject: Variant;
begin
	try
		if IsWindowsNT6() then
		begin
			PolicyObject := CreateOleObject('HNetCfg.FwPolicy2');
			PolicyObject.Rules.Remove(AppName);
		end
		else
		begin
			FirewallManager := CreateOleObject('HNetCfg.FwMgr');

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_STANDARD);
			FireWallProfile.AuthorizedApplications.Remove(AppName);

			FirewallProfile := FirewallManager.LocalPolicy.GetProfileByType(NET_FW_PROFILE_DOMAIN);
			FireWallProfile.AuthorizedApplications.Remove(AppName);
		end;
	except
	end;
end;

procedure DeleteFromWinFirewallXP(ApplicationFilename: widestring);
var
  fwMgr: Variant;
  Profile: Variant;
  FirewallActive: Boolean;
  ServiceActive: Boolean;
  ExceptionsAllowed: Boolean;
begin
  {
  FirewallActive := IsFirewallActive;
  ServiceActive := IsFirewallServiceActive;
  ExceptionsAllowed := FirewallExceptionsAllowed;

  if not ServiceActive
  or not FirewallActive
  or (FirewallActive and not ExceptionsAllowed) then
    Exit;
  }
  fwMgr := CreateOleObject('HNetCfg.FwMgr');

  Profile := fwMgr.LocalPolicy.CurrentProfile;
  Profile.AuthorizedApplications.Remove(ApplicationFilename);

  Profile := Unassigned;
  fwMgr := Unassigned;
end;


end.
