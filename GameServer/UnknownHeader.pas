unit UnknownHeader;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __unk_header_01(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __unk_header_01(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  send('server\zp.txt', AThread);
end;

end.
