unit Server_List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Server_List(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Server_List(AThread: TIdPeerThread);
var tTmp, i, id, k: Integer;
  ipStr, sHeader, s, tNick: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  sHeader:= 'F1A01F00030000000000';
  s:= StringReplace(StrToHex(tNick), ' ', '', [rfReplaceAll]);
  For i:= 1 to 16 - Length(s) div 2 do s:= s + '00';
  sHeader:= sHeader + s + 'CF649800000000000000000000000000000000' +
  '00000000000000F03F12000000';
  id:= 1;
  For i:= 1 to serverCount do
  begin
    sHeader:= sHeader + '00000000' + IntToVHex(ServerList[id].order, 4) +
    IntToVHex(ServerList[id].permission, 4) +
    IntToVHex(ServerList[id].minLevel, 4) +
    IntToVHex(ServerList[id].maxLevel, 4);
    sHeader:= sHeader + '00000000' + '000000000000000000000000';
    sHeader:= sHeader + IntToVHex(id, 4);
    s:= StringReplace(StrToHex(ServerList[id].name), ' ', '', [rfReplaceAll]);
    For k:= 1 to 34 - Length(s) div 2 do s:= s + '00';
    sHeader:= sHeader + s + IntToVHex(ServerList[id].port, 4) + '0000';
    sHeader:= sHeader + IntToVHex(ServerList[id].ip[1], 2) +
    IntToVHex(ServerList[id].ip[2], 2) +
    IntToVHex(ServerList[id].ip[3], 2) +
    IntToVHex(ServerList[id].ip[4], 2) + '540B0000';
    if ServerList[id].maintenance = 0 then
      sHeader:= sHeader + '00000000' else
      sHeader:= sHeader + 'FFFFFFFF';
    Inc(id);
  end;
  For i:= 1 to 8070 - Length(sHeader) div 2 do sHeader:= sHeader + '00';
  sHeader:= sHeader + '24 48 00 00 EB C7 5F 5F 40 E5 75 1D 39 71 71 71 6E CB 5B 33 17 5F 08 6C 01 00 00 00 00 00 00 00 F2';
  sm:= TStringStream.Create(HexToStr(sHeader));

  AThread.Connection.WriteStream(sm);
end;

end. 
