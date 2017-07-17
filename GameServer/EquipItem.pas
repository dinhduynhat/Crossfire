unit EquipItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Equip_Item(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Equip_Item(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  sm:= TStringStream.Create(HexToStr('f1010001f30001f2'));
  AThread.Connection.WriteStream(sm);
end;

end. 
