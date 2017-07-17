unit PlayerInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Player_Info(AThread: TIdPeerThread; sub_header: String);

implementation

uses Methods, PublicVariables;

procedure __Player_Info(AThread: TIdPeerThread; sub_header: String);
var tTmp, weaponID, intTmp: Integer;
  ipStr, sHeader, s1, s2, itemsid, index, s3: String;
  sm: TStringStream;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);
  
  if sub_header = '01' then begin
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\storage\' + usrNameArr[tTmp] + '.txt');
    sHeader:= '00000000' + IntToVHex(StrToInt(iniFile.ReadString('Global', 'ItemCount', '0')), 8);
    weaponID:= 1;
    while iniFile.ReadString('ITEM' + IntToStr(weaponID), 'StorageID', '') <> '' do begin
      sHeader:= sHeader + '0000000000000000000000';
      sHeader:= sHeader + StrToHex(iniFile.ReadString('ITEM' + IntToStr(weaponID), 'StorageID', 'C0001'));
      sHeader:= sHeader + '00000000000000';
      sHeader:= sHeader + '00' + IntToVHex(weaponID, 2) +'6c72' + '9f860100';
      sHeader:= sHeader + '00' + 'b80b0c00' + IntToVHex(StrToInt(iniFile.ReadString('ITEM' + IntToStr(weaponID), 'Days', '0')), 4) +
      IntToVHex(StrToInt(iniFile.ReadString('ITEM' + IntToStr(weaponID), 'Hours', '0')), 4) +
      IntToVHex(StrToInt(iniFile.ReadString('ITEM' + IntToStr(weaponID), 'Minutes', '0')), 4) +
      '0000' + IntToVHex(StrToInt(iniFile.ReadString('ITEM' + IntToStr(weaponID), 'Repair', '0')), 8) + '00000000' + '9f860100';
      Inc(weaponID);
    end;
    iniFile.Free;
    sHeader:= sHeader + '00000000';
    sHeader:= 'f1' + IntToVHex(Length(sHeader) div 2, 4) + '01c900' + sHeader + 'f2';
    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
    //send('storage\chars.txt', AThread, 2, 'Chars');
    //send('storage\items.txt', AThread, 2, 'Chars');
    // ------------------------------ CHARACTER ------------------------------------------------------ \\
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Storage\Characters\' + usrNameArr[tTmp] + '.txt');
    intTmp:= 1;
    sHeader:= '00000000' + IntToVHex(StrToInt(iniFile.ReadString('Global', 'ItemCount', '0')), 8);
    While iniFile.ReadString('CHAR' + IntToStr(intTmp), 'ItemShopID', '') <> '' do
    begin
      s1:= iniFile.ReadString('CHAR' + IntToStr(intTmp), 'ItemShopID', itemsid);
      s2:= iniFile.ReadString('CHAR' + IntToStr(intTmp), 'StorageID', index);
      s3:= iniFile.ReadString('CHAR' + IntToStr(intTmp), 'CharUse', index);
      sm:= TStringStream.Create(HexToStr('F1CC0001C9000200000001000000' + StrToHex(s1) + '00' + StrToHex(s2) +
      '00000000000000000000000000000000B80B0C001F0017003B0000009F860100000000009F860100' + 'FAFFFFFFFFFFFF7FF9' + 'FFFFFFFFFFFF7F' +
      '00000000000000000000000000000000' + '0000000000000000' + '0000000000000000' + 'C9FFFFFFFFFFFF7F' + '000000000000000000000000000000000000000000000000' +
      '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000C9FFFFFFF2'));
      AThread.Connection.WriteStream(sm);
      Inc(intTmp);
    end;
    iniFile.Free;
    gConsole(ipStr, 'Chars');
    // ------------------------------------------------------------------------------------ \\
    send('storage\bags.txt', AThread, 2, 'Bags');
    send('storage\1.txt', AThread);
    //send('2.txt', AThread);
  end;
end;

end.
