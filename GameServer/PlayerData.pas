unit PlayerData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Game_Player_Data(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Game_Player_Data(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  send('playerdata\1.txt', AThread);
  send('playerdata\2.txt', AThread);
  send('playerdata\3.txt', AThread);
end;

end. 
