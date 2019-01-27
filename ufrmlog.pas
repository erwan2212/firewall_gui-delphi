unit ufrmlog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmLog = class(TForm)
    Memo1: TMemo;
    txtfilename: TEdit;
    Timer1: TTimer;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure read;

  public
    { Public declarations }
    //filename:string;
    procedure close;
    procedure open;
  end;

var
  frmLog: TfrmLog;
  h:thandle;
  prevcount:integer;

implementation

{$R *.dfm}

//GetFileInformationByHandle(h, &info) can be used to retrieve filesize

procedure TfrmLog.read;
var
b:boolean;
bytesread:cardinal;
buf:array[0..4096-1] of char;
begin
while 1=1 do
  begin
  fillchar(buf,sizeof(buf),0);
  b:= ReadFile(h, Buf, sizeof(buf), bytesread, nil);
  if( b=false) or (bytesread=0) then break;
  memo1.Lines.Add(buf);
  end;
end;

procedure TfrmLog.open;
begin
if txtfilename.Text ='' then exit;
try
h:=thandle(-1);
h:=CreateFile(pchar(txtfilename.Text),GENERIC_READ ,
  FILE_SHARE_READ or FILE_SHARE_WRITE or file_share_delete, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
if h=thandle(-1) then raise exception.Create('invalid handle');
timer1.Enabled :=true;
except
on e:exception do showmessage(e.Message );
end;
end;

procedure TfrmLog.close;
begin
try
timer1.Enabled :=false;
sleep(1000);
closehandle(h);
except
on e:exception do showmessage(e.Message );
end;
end;



procedure TfrmLog.Timer1Timer(Sender: TObject);
begin
try
read;
if memo1.Lines.Count <> prevcount then
  begin
  SendMessage(Memo1.Handle, EM_LINESCROLL, 0,Memo1.Lines.Count);
  label1.Caption :='last update '+TimeToStr ( now);
  end;
prevcount:=memo1.lines.count;
except
on e:exception do begin timer1.enabled:=false;showmessage (e.Message );end;
end;
end;

procedure TfrmLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
close;
action:=cafree;
end;

end.
