unit ZPSystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __ZP_Refresh(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __ZP_Refresh(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  sm:= TStringStream.Create(HexToStr('f10400018100' + IntToVHex(usrZPArr[tTmp], 8) + 'f2'));
  AThread.Connection.WriteStream(sm);
end;

end.
