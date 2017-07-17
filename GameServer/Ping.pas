unit Ping;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Ping(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Ping(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  sm:= TStringStream.Create(HexToStr('f1040001ac00b7f44b00f2'));             // Ping packet //
  AThread.Connection.WriteStream(sm);
  gConsole(ipStr, 'Ping');
end;

end. 
