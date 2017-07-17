unit BuySystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Bought_Item(AThread: TIdPeerThread; packet: String);

implementation

uses Methods, PublicVariables;

procedure __Bought_Item(AThread: TIdPeerThread; packet: String);
var i, tTmp, intTmp: Integer;
  ipStr, sHeader, s, s1, s2, s4, s6, s5, s7, s3: String;
  iniFile: TIniFile;
  sm: TStringStream;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  {s:= StringReplace(StrToHexCnt(sm, Len), ' ', '', [rfReplaceAll]);
  if s[21] + s[22] + s[23] + s[24] = '5705' then  gConsole(ipStr, 'buy character [SWAT]');
  if s[21] + s[22] + s[23] + s[24] = '5B05' then  gConsole(ipStr, 'buy character [OMOH]');
  if s[21] + s[22] + s[23] + s[24] = '6005' then  gConsole(ipStr, 'buy character [SAS]');

  iniFile:= iniFile.Create(ExtractFileDir(ParamStr(0)) + '\character.ini');
  iniFile.WriteString('CHARACTER', usrNameArr[tTmp], 'yes');
  iniFile.Free;   }

  sHeader:= 'f1' + '5801' + '017900' + '00000000' + '01000000' +
  packet[21] + packet[22] + packet[23] + packet[24];     // Item Index //
  For i:= 1 to 30 do sHeader:= sHeader + '00';
  For i:= 85 to 104 do sHeader:= sHeader + packet[i];    // Item ID //
  For i:= 1 to 78 do sHeader:= sHeader + '00';
  sHeader:= sHeader + '18935F18';                        // Verify code //
  For i:= 1 to 212 do sHeader:= sHeader + '00';
  sHeader:= sHeader + 'f2';
  For i:= 85 to 104 do s:= s + packet[i];

  s1:= packet[23] + packet[24] + packet[21] + packet[22];  // Index //
  intTmp:= HexToInt(s1);

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\ItemsList.cfg');
  s2:= iniFile.ReadString(IntToStr(intTmp), 'StorageID', 'C0001');
  s4:= iniFile.ReadString(IntToStr(intTmp), 'Price', '0 GP');
  s6:= Copy(s4, 1, Pos(' ', s4) - 1);
  if s4[Length(s4) - 1] + s4[Length(s4)] = 'GP' then Dec(usrGPArr[tTmp], StrToInt(s6));
  if s4[Length(s4) - 1] + s4[Length(s4)] = 'ZP' then Dec(usrZPArr[tTmp], StrToInt(s6));
  //if s4[Length(s4) - 1] + s4[Length(s4)] = 'FP' then Dec(usrFPArr[tTmp], StrToInt(s6));
  s5:= iniFile.ReadString(IntToStr(intTmp), 'Name', HexToStr(s));
  s7:= iniFile.ReadString(IntToStr(intTmp), 'ItemShopID', '');
  iniFile.Free;

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\user\' + usrNameArr[tTmp] + '.txt');
  iniFile.WriteString('User Data', 'GP', IntToStr(usrGPArr[tTmp]));
  iniFile.WriteString('User Data', 'ZP', IntToStr(usrZPArr[tTmp]));
  //iniFile.WriteString('User Data', 'FP', IntToStr(usrFPArr[tTmp]));
  iniFile.Free;

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\storage\' + usrNameArr[tTmp] + '.txt');
  s3:= iniFile.ReadString('Global', 'ItemCount', '0');
  intTmp:= StrToInt(s3);
  Inc(intTmp);
  iniFile.WriteString('Global', 'ItemCount', IntToStr(intTmp));
  iniFile.WriteString('ITEM' + IntToStr(intTmp), 'StorageID', s2);
  iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Repair', '100');
  iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Days', '29');
  iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Hours', '23');
  iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Minutes', '59');
  iniFile.Free;

  sm:= TStringStream.Create(HexToStr(sHeader));
  AThread.Connection.WriteStream(sm);

  gConsole(ipStr, Format('bought item [%s]', [s5]));
end;

end.
