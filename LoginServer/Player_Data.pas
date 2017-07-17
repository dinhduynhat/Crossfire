unit Player_Data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Player_Data(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

function getMsg: String;
begin
  Result:= '检测到进入游戏前外挂 (Hacktool has been detected [WPE.exe])';
end;

procedure checkHackTool(AThread: TIdPeerThread);
begin
  createPacket('011500');
  writeS(getMsg, getLen(getMsg));
  sendPacket(AThread);
end;

procedure __Player_Data(AThread: TIdPeerThread);
var i, tTmp, tmp: Integer;
  ext: Extended;
  ipStr, sHeader, s, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14: String;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  //checkHackTool(AThread);

  s:= HexToStr(IntToVHex(usrGPArr[tTmp], 8));                                 // Account GP
  s1:= nickNameArr[tTmp];                                                     // name????
  s2:= nickNameArr[tTmp];                                                     // Nickname
  s3:= HexToStr(IntToVHex(usrEXPArr[tTmp], 8));                               // EXP
  For i:= 0 to 99 do
  if explevel[i] > usrEXPArr[tTmp] then begin
  usrLVLArr[tTmp]:= i - 1;
  s4:= HexToStr(IntToVHex(usrLVLArr[tTmp], 8));                               // Level
  ext:= (usrEXPArr[tTmp] - explevel[i - 1])/explevel[i];
  s6:= HexToStr(IntToVHex(Floor(StrToFloat(FormatFloat('0.00', ext)) * 100),  // EXP Bar
  8));
  s7:= HexToStr(IntToVHex(explevel[i], 8));                                   // Next Level EXP
  break;
  end;
  s5:= HexToStr(IntToVHex(5, 8));                                             // Unknown
  s8:= HexToStr(IntToVHex(usrVictoryArr[tTmp], 8));                           // Victory
  s9:= HexToStr(IntToVHex(usrDefeatArr[tTmp], 8));                            // Defeat
  s10:= HexToStr(IntToVHex(usrKillArr[tTmp], 8));                             // Kill
  s11:= HexToStr(IntToVHex(usrDeathArr[tTmp], 8));                            // Death
  s13:= clanNameArr[tTmp];
  s14:= clanNameArr[tTmp];

  sHeader:= '00000000' + '73d6ebaa00';
  For i:= 1 to 10 do begin   // 10 Channels //
    sHeader:= sHeader + '005e01';                       // Channel Header //
    sHeader:= sHeader + IntToVHex(Channels[i], 32);     // Channel Player //
    if i <> 10 then
    sHeader:= sHeader + IntToVHex(i, 2);                // Channel //
  end;
  sHeader:= HexToStr(sHeader);

  tmp:= Length(s1);
  For i:= 1 to 14 - tmp do    // Add '00' to 14 digits //
    s1:= s1 + #0;

  tmp:= Length(s2);
  For i:= 1 to 16 - tmp do    // Add '00' to 16 digits //
    s2:= s2 + #0;

  For i:= 1 to hotNewCnt do begin
    s12:= s12 + 'ffff';
    s12:= s12 + hotNewArr[i].ID;
    if hotNewArr[i].Style = 'HOT' then
      s12:= s12 + '48' else
    if hotNewArr[i].Style = 'NEW' then
      s12:= s12 + '4E' else
    if hotNewArr[i].Style = 'DELETED' then
      s12:= s12 + '44';
    s12:= s12 + '00';
  end;
  For i:= 1 to 2494 - 102 - Length(s12) do
    s12:= s12 + '0';
  s12:= HexToStr(s12);

  sm:= TStringStream.Create(HexToStr(sendLoginMessage('into_server\custom\1_1.txt')) + s +
  HexToStr(sendLoginMessage('into_server\custom\1_2.txt')) + s3 + s4 + s5 + s6 + s7 + s8 + s9 + s10 + s11 +
  HexToStr(sendLoginMessage('into_server\custom\1_5.txt')) + s1 +
  HexToStr(sendLoginMessage('into_server\custom\1_3.txt')) + s2 +
  HexToStr(sendLoginMessage('into_server\custom\1_4.txt')) + sHeader +
  HexToStr(sendLoginMessage('into_server\custom\1_6.txt')) + s12 +
  HexToStr(sendLoginMessage('into_server\custom\1_7.txt')) +
  HexToStr(sendLoginMessage('into_server\1.txt')));
  AThread.Connection.WriteStream(sm);

  // FP
  createPacket('0a0c01');
  writeD(1);
  writeD(0);
  writeD(usrFPArr[tTmp]);
  writeD(0);
  writeD(0);
  writeD(0);
  writeD(0);
  writeD(0);
  writeD(0);
  writeD(0);
  writeH(0);
  writeI(0);
  sendPacket(AThread);

  createPacket('010900');
  writeD(1);
  sendPacket(AThread);

  lConsole(ipStr, 'Player data');
end;

end.
