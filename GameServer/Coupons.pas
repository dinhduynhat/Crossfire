unit Coupons;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Coupons(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Coupons(AThread: TIdPeerThread);
var tTmp: Integer;
  ipStr, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
  s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, index, itemsid, item1: String;
  sm: TStringStream;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s1:= iniFile.ReadString('LIST1', 'ITEM1', itemsid);
  s2:= iniFile.ReadString('LIST1', 'ITEM2', index);
  s3:= iniFile.ReadString('LIST1', 'ITEM3', item1);
  iniFile.Free;
  // ID: 15
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s5:= iniFile.ReadString('LIST2', 'ITEM1' , itemsid);
  s6:= iniFile.ReadString('LIST2', 'ITEM2' , index);
  s7:= iniFile.ReadString('LIST2', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 20
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s8:= iniFile.ReadString('LIST3', 'ITEM1' , itemsid);
  s9:= iniFile.ReadString('LIST3', 'ITEM2' , index);
  s10:= iniFile.ReadString('LIST3', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 30
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s11:= iniFile.ReadString('LIST4', 'ITEM1' , itemsid);
  s12:= iniFile.ReadString('LIST4', 'ITEM2' , index);
  s13:= iniFile.ReadString('LIST4', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 50
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s14:= iniFile.ReadString('LIST5', 'ITEM1' , itemsid);
  s15:= iniFile.ReadString('LIST5', 'ITEM2' , index);
  s16:= iniFile.ReadString('LIST5', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 70
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s17:= iniFile.ReadString('LIST6', 'ITEM1' , itemsid);
  s18:= iniFile.ReadString('LIST6', 'ITEM2' , index);
  s19:= iniFile.ReadString('LIST6', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 80
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s20:= iniFile.ReadString('LIST7', 'ITEM1' , itemsid);
  s21:= iniFile.ReadString('LIST7', 'ITEM2' , index);
  s22:= iniFile.ReadString('LIST7', 'ITEM3' , item1);
  iniFile.Free;
  // ID: 100
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Coupons\Coupons_List.cfg');
  s23:= iniFile.ReadString('LIST8', 'ITEM1' , itemsid);
  s24:= iniFile.ReadString('LIST8', 'ITEM2' , index);
  s25:= iniFile.ReadString('LIST8', 'ITEM3' , item1);
  iniFile.Free;

  sm:= TStringStream.Create(HexToStr('F1640101BC0008000000010000000A000000' + StrToHex(s1) + '00' + StrToHex(s2) +
  '00' + StrToHex(s3) + '00000000020000000F000000' + StrToHex(s5) + '00' + StrToHex(s6) + '00' + StrToHex(s7) + '000000000300000014000000' + StrToHex(s8) +
  '00' + StrToHex(s9) + '00' + StrToHex(s10) + '00000000040000001E000000' + StrToHex(s11) + '00' + StrToHex(s12) + '00' + StrToHex(s13) + '000000000500000032000000' + StrToHex(s14) +
  '00' + StrToHex(s15) + '00' + StrToHex(s16) + '0000000006000000460000' +
  '00' + StrToHex(s17) + '00' + StrToHex(s18) + '00' + StrToHex(s19) + 
  '000000000700000050000000' + StrToHex(s20) + '00' + StrToHex(s21) + '00' + StrToHex(s22) + '000000000800000064000000' + StrToHex(s23) + '00' + StrToHex(s24) +
  '00' + StrToHex(s25) + '00000000F2'));
  AThread.Connection.WriteStream(sm);
  //send('blackmarket\coupons\coupons_list.txt', AThread, 2, 'Coupon List');
end;

end.
