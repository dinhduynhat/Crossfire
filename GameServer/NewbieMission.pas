unit NewbieMission;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __NewbieMission(AThread: TIdPeerThread);
procedure __NewbieMission_Item(AThread: TIdPeerThread; packet: String);

implementation

uses Methods, PublicVariables;

procedure __NewbieMission(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);

  sm:= TStringStream.Create(HexToStr('f1010001ce0001f2'));
  AThread.Connection.WriteStream(sm);
end;

procedure __NewbieMission_Item(AThread: TIdPeerThread; packet: String);
var tTmp: Integer;
  ipStr, s1, s2: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);

  if packet[17] + packet[18] = '00' then begin   // NEWBIE MISSION - GET M4A1 //
    s1:= IntToVHex(20, 8);         // INDEX //
    s2:= StrToHex('2010000701');   // SHOP ID //
    sm:= TStringStream.Create(HexToStr('f1c0000a1b020000000000000100010000000' +
    '0000000010000000000000002000000' + s1 + '82de751800000000000000000000000' + s2 +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000f2'));
    AThread.Connection.WriteStream(sm);
  end;
  if packet[17] + packet[18] = '01' then begin  // NEWBIE MISSION - GET D.E //
    s1:= IntToVHex(50, 8);         // INDEX //
    s2:= StrToHex('2010003001');   // SHOP ID //
    sm:= TStringStream.Create(HexToStr('f1c0000a1b020000000000000100020000000' +
    '0000000010000000000000002000000' + s1 + '7ce0751800000000000000000000000' + s2 +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000f2'));
    AThread.Connection.WriteStream(sm);
  end;
  if packet[17] + packet[18] = '02' then begin  // NEWBIE MISSION - GET D.E //
    s1:= IntToVHex(94, 8);         // INDEX //
    s2:= StrToHex('1010001601');   // SHOP ID //
    sm:= TStringStream.Create(HexToStr('f1c0000a1b020000000000000100030000000' +
    '0000000010000000000000002000000' + s1 + '82de751800000000000000000000000' + s2 +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000f2'));
    AThread.Connection.WriteStream(sm);
  end;
end;

end.
