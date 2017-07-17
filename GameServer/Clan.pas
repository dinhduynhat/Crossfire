unit Clan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Clan(AThread: TIdPeerThread; packet: String; sub_header: String);

implementation

uses Methods, PublicVariables;

procedure __Clan(AThread: TIdPeerThread; packet: String; sub_header: String);
var tTmp, i, j: Integer;
  ipStr, s, sHeader, s1, s2, s3, s4, s5, s6, s7: String;
  sm: TStringStream;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);

  if sub_header = '5D' then        // F1 00 00 10 01 5D F2 //
    send('channel\4.txt', AThread) else
  if sub_header = '0D' then begin  // F1 00 00 10 01 0D F2 //   // CLAN LIST //
    sm:= TStringStream.Create(HexToStr('f1600210010e03000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000fd55000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000045545f4d59434c414e0055f2'));
    AThread.Connection.WriteStream(sm);
    gConsole(ipStr, 'Clan');
  end;
  if sub_header = '5B' then begin  // F1 00 00 10 01 5B F2 //   // VIEW CLAN - COUNT //
    sm:= TStringStream.Create(HexToStr('f1080010015c01000000' + '4bf00000' + 'f2'));
    AThread.Connection.WriteStream(sm);
    gConsole(ipStr, 'View clan');
  end;
  if sub_header = '05' then begin  // F1 10 00 10 01 05 01 //   // VIEW CLAN //
    s1:= packet[11] + packet[12] + packet[13] + packet[14];   // PAGE //
    sHeader:= '01000027' + s1 + '03000000' + '00000000';
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Clan\ClanList.ini');
    s2:= iniFile.ReadString('Global', 'ClanCount', '0');
    if StrToInt(s2) > 3 then s2:= '3';
    For i:= 1 to StrToInt(s2) do begin           // Show the latest 3 Clans //
       sHeader:= sHeader + IntToVHex(StrToInt(iniFile.ReadString('Clan' + IntToStr(i), 'ID', '0')), 8);
       sHeader:= sHeader + '00000000' + '34a5a200' + '0100' + '0100' + '14000000' + '00000000' +
       '00000000' + '00000000' + '01000000';
       s3:= StrToHex(iniFile.ReadString('Clan' + IntToStr(i), 'Description', 'Invalid clan description.'));
       sHeader:= sHeader + s3;
       For j:= 1 to 221 - Length(s3) div 2 do sHeader:= sHeader + '00';
       s4:= iniFile.ReadString('Clan' + IntToStr(i), 'CreateTime', '2000-00-00');
       s5:= iniFile.ReadString('Clan' + IntToStr(i), 'Time', '08:00:00');
       sHeader:= sHeader + StrToHex(s4[1] + s4[2] + s4[3] + s4[4] + s4[6] + s4[7] + s4[9] + s4[10] +
       s5[1] + s5[2] + s5[4] + s5[5] + s5[7] + s5[8]) + '00';
       s6:= StrToHex(iniFile.ReadString('Clan' + IntToStr(i), 'Creator', 'Invalid'));
       sHeader:= sHeader + s6;  // Creator //
       gConsole(ipStr, IntToStr(Length(s6)));
       For j:= 1 to 13 - Length(s6) div 2 do sHeader:= sHeader + '00';
       s7:= StrToHex(iniFile.ReadString('Clan' + IntToStr(i), 'Name', 'Invalid Clan'));
       sHeader:= sHeader + s7;
       For j:= 1 to 28 - Length(s7) div 2 do sHeader:= sHeader + '00';
       For j:= 1 to 279 do sHeader:= sHeader + '00';
    end;
    iniFile.Free;
    sHeader:= 'f1' + IntToVHex(Length(sHeader) div 2, 4) + '100106' + sHeader + 'f2';

    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
    gConsole(ipStr, 'View clan');
  end;
end;

end.
