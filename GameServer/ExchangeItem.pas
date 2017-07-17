unit ExchangeItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Exchange_Item(AThread: TIdPeerThread; packet: String);

implementation

uses Methods, PublicVariables;

procedure __Exchange_Item(AThread: TIdPeerThread; packet: String);
var tTmp, intTmp: Integer;
  ipStr, s, s1, s2, s3: String;
  sm: TStringStream;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  s:= packet[15] + packet[16] + packet[17] + packet[18];  // Index //
  intTmp:= HexToInt(s);
  sm:= TStringStream.Create(HexToStr('F1A80001BE0000000000' + StrToHex(s) + '0000F693C51300000000' + StrToHex(s1) +
  '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
  '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
  '0000000000000000000000000000000000000000000000000000000000F2'));
  AThread.Connection.WriteStream(sm);
  // Send Item
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\ItemsList.cfg');
  s1:= iniFile.ReadString(IntToStr(intTmp), 'ItemShopID', '');
  s2:= iniFile.ReadString(IntToStr(intTmp), 'StorageID', 'C0001');
  s3:= iniFile.ReadString(IntToStr(intTmp), 'Name', HexToStr(s));
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

  gConsole(ipStr, Format('Exchange Item [%s]', [s3]));

  send('blackmarket\coupons\1.txt', AThread);
  send('blackmarket\coupons\2.txt', AThread);
end;

end.
