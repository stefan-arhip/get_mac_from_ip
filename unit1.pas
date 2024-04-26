unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  WinSock;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

function SendARP(DestIp: DWord; srcIP: DWord; pMacAddr: Pointer;
  PhyAddrLen: Pointer): DWORD; stdcall; external 'iphlpapi.dll';

implementation

{$R *.lfm}

function MySendARP(const IPAddress: string): string;
var
  DestIP: int64;
  MacAddr: array [0..5] of byte;
  MacAddrLen: int64;
  SendArpResult: cardinal;
begin
  DestIP := WinSock.Inet_Addr(pansichar(ansistring(IPAddress)));
  MacAddrLen := Length(MacAddr);
  SendArpResult := SendARP(DestIP, 0, @MacAddr, @MacAddrLen);
  if SendArpResult = 0 then
    Result := Format('%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X',
      [MacAddr[0], MacAddr[1], MacAddr[2],
      MacAddr[3], MacAddr[4], MacAddr[5]])
  else
    Result := 'Undetected';
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add(MySendARP(Edit1.Text));
end;

end.
