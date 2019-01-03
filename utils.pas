unit utils;

interface

uses windows,ComCtrls,sysutils;

Function ListView2HTML(const l:tlistview;title:string=''):string;

implementation

type
tagLVITEMA = packed record
   mask: UINT;
   iItem: Integer;
   iSubItem: Integer;
   state: UINT;
   stateMask: UINT;
   pszText: PAnsiChar;
   cchTextMax: Integer;
   iImage: Integer;
   lParam: lParam;
   iIndent: Integer;
   iGroupId: Integer;
   cColumns: UINT;
   puColumns: PUINT;
 end;
 TLVITEMA = tagLVITEMA;

const
LVM_FIRST =$1000;
LVM_GETHEADER = (LVM_FIRST + 31);
LVM_GETITEMCOUNT = (LVM_FIRST + 4);
LVM_GETITEMTEXT = (LVM_FIRST + 45);
LVM_GETITEMPOSITION = (LVM_FIRST + 16);
HDM_FIRST = $1200;
HDM_GETITEMCOUNT = (HDM_FIRST + 0);
LVIF_TEXT = $1;

function GetLVColumnCount(hnd:integer):integer;
var hheader:thandle;
begin
hHeader := SendMessage(hnd, LVM_GETHEADER, 0, 0);
result := SendMessage(hHeader, HDM_GETITEMCOUNT, 0, 0);
end;

function GetLVitemColor(hnd,item:integer):string;
var
tp:tpoint;
lColor:DWORD;
begin
result:='FFFFFF';
fillchar(tp,sizeof(tpoint),0);
if SendMessage(hnd ,LVM_GETITEMPOSITION  ,item,Longint(@tp))<>0 then
 begin
 lcolor:=0;
 lColor := GetPixel(GetWindowDC(hnd), tp.x+2, tp.y+2);
 result:=inttohex(lColor,6  );
 end;
end;

function GetLVitem(hnd,item,subitem:integer):string;
var
  lv:TLVITEMA ;
begin
//http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/listview/messages/lvm_getitemtext.asp
fillchar(lv,sizeof(lv),0);
//lv.iItem :=item;
lv.iSubItem :=subitem;
lv.cchTextMax := 1024;
getmem(lv.pszText ,lv.cchTextMax);
lv.mask :=LVIF_TEXT;
if SendMessage(hnd ,LVM_GETITEMTEXT ,item,Longint(@LV))<>0
 then result:=trim(lv.pszText)
 else result:='';
freemem(lv.pszText );
end;

Function ListView2HTML(const l:tlistview;title:string=''):string;
var
itemtext,style,lcolor,txt:string;
lvcolumncount,lvcount,i,j: integer;
begin
  txt:='';
  txt:=txt+'<html>'+#13#10;
  txt:=txt+'<body>'+#13#10;
  txt:=txt+'<head>'+#13#10;
  txt:=txt+'<link rel="stylesheet" type="text/css" href="style.css" />'+#13#10;
  txt:=txt+'</head>'+#13#10;

  if title<>'' then txt:=txt+'<h3>'+title+'</h3><hr>'+#13#10;

  txt := txt+'<table>'+#13#10;
  //first row=columns
  try
  txt:=txt+'<tr>'+#13#10;
  for i:=0 to l.Columns.Count -1
     do txt:=txt+'<td class="sub">'+l.Columns.Items [i].Caption+'</td>'+#13#10 ;
  txt := txt + '</tr>'+#13#10;
  except
  end;

  try
  lvcount:=SendMessage(l.Handle  ,LVM_GETITEMCOUNT ,0,0);
  lvcolumncount:=GetLVColumnCount(l.handle);
  //with l.Items do
  //begin
    for i := 0 to lvcount {count} - 1 do
    begin
    lcolor:=GetLVitemColor(l.Handle ,i);
    style:='default';
    if lcolor='8080FF' then style:='default-RED';
    if lcolor='80FF80' then style:='default-GREEN';
      txt:=txt+'<tr>'+#13#10;
      itemtext:=GetLVitem(l.Handle ,i,0);
      //txt := txt + '<td class="'+style+'">'+ itemtext +'&nbsp</td>'+#13#10;
      txt := txt + '<td class="'+style+'">'+ itemtext +'</td>'+#13#10;
      for j := 0 to lvcolumncount - 2 do
      begin
        //if l.Columns[i].Width>0 then
        itemtext:=GetLVitem(l.Handle ,i,j+1);
          //txt := txt + '<td class="'+style+'">' + itemtext +'&nbsp</td>'+#13#10;
          txt := txt + '<td class="'+style+'">' + itemtext +'</td>'+#13#10;
      end;
    txt := txt + '</tr>'+#13#10;
    end;
  //end;
  txt:=txt+'</table>'+#13#10;
  txt:=txt+'<hr/>'+#13#10;
  txt:=txt+'<br/>'+#13#10;
  txt:=txt+'<b>Report created by Erwan2212</b>'+#13#10;
  txt:=txt+'<br/>'+#13#10;
  txt:=txt+'<a href="http://erwan.labalec.fr/">Web Site</a>'+#13#10;
  txt:=txt+'<br/>'+#13#10;
  txt:=txt+'<a href="mailto:erwan2212@gmail.fr">Email</a>'+#13#10;
  //txt:=txt+'<br>'+#13#10;

  txt:=txt+'</body>'+#13#10;
  txt:=txt+'</html>'+#13#10;
  except
  //
  end;
result:=txt;
end;

end.
