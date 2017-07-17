unit Connect_Data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Connect_Data(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Connect_Data(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  send('connect_data_01', AThread, 2, 'User into server: [' + nickNameArr[tTmp] + ']');
end;

end.
