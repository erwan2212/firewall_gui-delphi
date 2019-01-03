unit ufrmAddRule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmAddRule = class(TForm)
    txtappname: TEdit;
    Button1: TButton;
    txtrulename: TEdit;
    GroupBox1: TGroupBox;
    rbin: TRadioButton;
    rbout: TRadioButton;
    GroupBox2: TGroupBox;
    rballow: TRadioButton;
    rbblock: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    Button3: TButton;
    GroupBox3: TGroupBox;
    rbtcp: TRadioButton;
    rbudp: TRadioButton;
    rbany: TRadioButton;
    GroupBox4: TGroupBox;
    txtports: TEdit;
    OpenDialog1: TOpenDialog;
    rbicmp: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure rbinClick(Sender: TObject);
    procedure rboutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddRule: TfrmAddRule;

implementation

{$R *.dfm}

function RandomString(const ALength: Integer): String;
var
  i: Integer;
  LCharType: Integer;
begin
  Result := '';
  for i := 1 to ALength do
  begin
    LCharType := Random(3);
    case LCharType of
      0: Result := Result + Chr(ord('a') + Random(26));
      1: Result := Result + Chr(ord('A') + Random(26));
      2: Result := Result + Chr(ord('0') + Random(10));
    end;
  end;
end;

procedure TfrmAddRule.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute =false then exit;
txtappname.Text :=OpenDialog1.FileName ;
if rbin.Checked
  then txtrulename.text :=ExtractFileName(txtappname.Text)+' - INBOUND'
  else txtrulename.text :=ExtractFileName(txtappname.Text)+' - OUTBOUND';
end;

procedure TfrmAddRule.rbinClick(Sender: TObject);
begin
if txtappname.Text<>'' then txtrulename.text :=ExtractFileName(txtappname.Text)+' - INBOUND';
end;

procedure TfrmAddRule.rboutClick(Sender: TObject);
begin
if txtappname.Text<>'' then txtrulename.text :=ExtractFileName(txtappname.Text)+' - OUTBOUND';
end;

procedure TfrmAddRule.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action:=cafree;
end;

procedure TfrmAddRule.FormShow(Sender: TObject);
begin
Randomize ;
txtrulename.Text :=RandomString(8);
end;

end.
