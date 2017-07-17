unit ChangeTeam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;
  
procedure __Change_Team(AThread: TIdPeerThread; unk_header: String);

implementation

uses Methods, PublicVariables;

procedure __Change_Team(AThread: TIdPeerThread; unk_header: String);
var tTmp: Integer;
  ipStr, s1: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  s1:= unk_header;
  if s1 = '01' then begin
    sm:= TStringStream.Create(HexToStr('f10800013d000000000001000000f2'));
    AThread.Connection.WriteStream(sm);
  end;
  if s1 = '00' then begin
    sm:= TStringStream.Create(HexToStr('f10800013d000000000000000000f2'));
    AThread.Connection.WriteStream(sm);
  end;
end;

end.
