unit Exit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Exit(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Exit(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr, sHeader: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  sHeader:= 'f1' + '0400' + '001200' + '00000000' + 'f2';
  sm:= TStringStream.Create(HexToStr(sHeader));
  AThread.Connection.WriteStream(sm);

  if nickNameArr[tTmp] = '' then
    lConsole(ipStr, Format('Exit game without enter nickname [%s]', [usrNameArr[tTmp]])) else
    lConsole(ipStr, Format('Exit game [%s]', [nickNameArr[tTmp]]));
end;

end.

