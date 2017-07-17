unit Profile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Profile(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Profile(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  //send('profile\player.txt', AThread, 2, 'Profile: [' + nickNameArr[tTmp] + ']');
  //send('profile\profile.txt', AThread);
  send('profile_01.txt', AThread);
end;

end.
