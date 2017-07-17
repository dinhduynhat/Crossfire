unit LoginServerPacket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure vLoginServerData(AThread: TIdPeerThread);

implementation

uses Unit1, Methods, ServerPacket, PublicVariables;

procedure vLoginServerData(AThread: TIdPeerThread);
var i, Len, tTmp, nTmp: Integer;
  packet, header, sub_header, unk_header, s, ipStr, msg, sHeader: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  tTmp:= getIPHex(ipStr);
  nTmp:= getNickNameHex(nickNameArr[tTmp]);

  sm:= TStringStream.Create('');
  AThread.Connection.ReadStream(sm, 1);      // F1
  AThread.Connection.ReadStream(sm, 2);      // Size
  AThread.Connection.ReadStream(sm, 2);      // Header
  AThread.Connection.ReadStream(sm, 1);      // Sub_header

  Len:= StrToInt('$' + StrToHex(sm.DataString[3] + sm.DataString[2])) + 7;

  For i:= 1 to Len - 6 do  // F2
    AThread.Connection.ReadStream(sm, 1);

  packet:= StringReplace(StrToHexCnt(sm, Len), ' ', '', [rfReplaceAll]);

  header:= packet[7] + packet[8] + packet[9] + packet[10];
  sub_header:= packet[11] + packet[12];
  unk_header:= packet[13] + packet[14];

  if MainForm.CheckBox1.Checked then begin
    dbg('Hex data:' + StrToHexCnt(sm, Length(sm.DataString)));
    s:= StrToVisibleHex(sm, Len);
    console('<' + ipStr + '> header: 0x' + header + ' sub_header: 0x' + sub_header + ' unk_header: 0x' + unk_header);
    console('<' + ipStr + '> data: ' + s);
  End;

  if header = '0000' then  // F1 88 01 00 00 //
    packet_login(AThread, packet, sm, Len);

  if header = '000F' then  // F1 02 00 00 0F 00 01 F2 //
    packet_into_server(AThread, sm, Len);

  if header = '0011' then begin  // F1 04 00 00 11 00 01 00 00 00 F2 //
    if unk_header = '00' then
      packet_exit(AThread);
    if unk_header = '01' then
      packet_player_data(AThread);
  end;

  if header = '0008' then  // F1 0D 00 00 08 00 //
    packet_confirm_nickname(AThread, sm, Len);

  if header = '000A' then  // F1 0D 00 00 0A 00 //
    packet_enter_nickname(AThread, sm, Len);

  if header = '000C' then begin                   // CONFIRM LOGIN //
    usrLoginArr[nTmp]:= False;
    sm:= TStringStream.Create(HexToStr('f10000010300f2'));
    connectData[nTmp].Connection.WriteStream(sm);
    sm:= TStringStream.Create(HexToStr('f10000000d00f2'));
    AThread.Connection.WriteStream(sm);
  end;
end;

end.
