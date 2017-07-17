unit BlackMarket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Black_Market(AThread: TIdPeerThread);

implementation

uses Methods, PublicVariables;

procedure __Black_Market(AThread: TIdPeerThread);
var tTmp, indexID: Integer;
  ipStr, sHeader: String;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Crate\Crate_Items_List.txt');
  indexID:= 1;
  sHeader:= sHeader + 'F1180101B50085000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'CrateID', ''));
  sHeader:= sHeader + '000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'CrateNUM', ''));
  sHeader:= sHeader + '000000000000000D00000000000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Items_Wins', ''));
  sHeader:= sHeader + '00000100000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item1', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item2', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item3', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item4', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item5', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item6', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item7', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item8', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item9', ''));
  sHeader:= sHeader + '00000000000001000000' + StrToHex(iniFile.ReadString('CRATE' + IntToStr(indexID), 'Item10', ''));
  sHeader:= sHeader + '00000000000002000000' + '2D310033382E3500323030000000000000000000' + '39303030303033333031000000000000F2';
  Inc(indexID);
  iniFile.Free;
  send('blackmarket\list_1.txt', AThread);
  send('blackmarket\list_2.txt', AThread);
  send('blackmarket\list_3.txt', AThread);
  send('blackmarket\list_4.txt', AThread);
  send('blackmarket\list_5.txt', AThread);
  send('blackmarket\list_6.txt', AThread);
  send('blackmarket\list_7.txt', AThread);
  send('blackmarket\list_8.txt', AThread);
  send('blackmarket\list_9.txt', AThread);
  send('blackmarket\list_10.txt', AThread);
  send('blackmarket\list_11.txt', AThread);
  send('blackmarket\list_12.txt', AThread);
  send('blackmarket\list_13.txt', AThread);
  send('blackmarket\list_14.txt', AThread);
  send('blackmarket\list_15.txt', AThread);
  send('blackmarket\list_16.txt', AThread);
  send('blackmarket\list_17.txt', AThread);
  send('blackmarket\list_18.txt', AThread);
  send('blackmarket\list_19.txt', AThread);
  send('blackmarket\list_20.txt', AThread);
  send('blackmarket\list_21.txt', AThread);
  send('blackmarket\list_23.txt', AThread);
  send('blackmarket\list_24.txt', AThread);
  send('blackmarket\list_25.txt', AThread);
  send('blackmarket\list_26.txt', AThread);
  send('blackmarket\list_27.txt', AThread);
  send('blackmarket\list_28.txt', AThread);
  send('blackmarket\list_29.txt', AThread);
  send('blackmarket\list_31.txt', AThread);
  send('blackmarket\list_33.txt', AThread);
  send('blackmarket\list_34.txt', AThread);
  send('blackmarket\list_35.txt', AThread);
  send('blackmarket\list_36.txt', AThread);
  send('blackmarket\list_37.txt', AThread);
  send('blackmarket\list_38.txt', AThread);
  send('blackmarket\list_39.txt', AThread);
  send('blackmarket\list_40.txt', AThread);
  send('blackmarket\list_41.txt', AThread);
  send('blackmarket\list_43.txt', AThread);
  send('blackmarket\list_44.txt', AThread);
  send('blackmarket\list_45.txt', AThread);
  send('blackmarket\list_46.txt', AThread);
  send('blackmarket\list_47.txt', AThread);
  send('blackmarket\list_48.txt', AThread);
  send('blackmarket\list_49.txt', AThread);
  send('blackmarket\list_50.txt', AThread);
  send('blackmarket\list_51.txt', AThread);
  send('blackmarket\list_52.txt', AThread);
  send('blackmarket\list_53.txt', AThread);
  send('blackmarket\list_54.txt', AThread);
  send('blackmarket\list_55.txt', AThread);
  send('blackmarket\list_56.txt', AThread);
  send('blackmarket\list_57.txt', AThread);
  send('blackmarket\list_58.txt', AThread);
  send('blackmarket\list_59.txt', AThread);
  send('blackmarket\list_60.txt', AThread);
  send('blackmarket\list_61.txt', AThread);
  send('blackmarket\list_63.txt', AThread);
  send('blackmarket\list_64.txt', AThread);
  send('blackmarket\list_65.txt', AThread);
  send('blackmarket\list_66.txt', AThread);
  send('blackmarket\list_67.txt', AThread);
  send('blackmarket\list_68.txt', AThread);
  send('blackmarket\list_69.txt', AThread);
  send('blackmarket\list_71.txt', AThread);
  send('blackmarket\list_72.txt', AThread);
  send('blackmarket\list_74.txt', AThread);
  send('blackmarket\list_75.txt', AThread);
  send('blackmarket\list_76.txt', AThread);
  send('blackmarket\list_77.txt', AThread);
  send('blackmarket\list_78.txt', AThread);
  send('blackmarket\list_79.txt', AThread);
  send('blackmarket\list_80.txt', AThread);
  send('blackmarket\list_81.txt', AThread);
  send('blackmarket\list_82.txt', AThread);
  send('blackmarket\list_83.txt', AThread);
  send('blackmarket\list_84.txt', AThread);
  send('blackmarket\list_85.txt', AThread);
  send('blackmarket\list_86.txt', AThread);
  send('blackmarket\list_87.txt', AThread);
  send('blackmarket\list_88.txt', AThread);
  send('blackmarket\list_89.txt', AThread);
  send('blackmarket\list_90.txt', AThread);
  send('blackmarket\list_91.txt', AThread);
  send('blackmarket\list_92.txt', AThread);
  send('blackmarket\list_93.txt', AThread);
  send('blackmarket\list_95.txt', AThread);
  send('blackmarket\list_96.txt', AThread);
  send('blackmarket\list_97.txt', AThread);
  send('blackmarket\list_98.txt', AThread);
  send('blackmarket\list_99.txt', AThread);
  send('blackmarket\list_100.txt', AThread);
  send('blackmarket\list_101.txt', AThread);
  send('blackmarket\list_102.txt', AThread);
  send('blackmarket\list_104.txt', AThread);
  send('blackmarket\list_105.txt', AThread);
  send('blackmarket\list_106.txt', AThread);
  send('blackmarket\list_107.txt', AThread);
  send('blackmarket\list_108.txt', AThread);
  send('blackmarket\list_109.txt', AThread);
  send('blackmarket\list_110.txt', AThread);
  send('blackmarket\list_112.txt', AThread);
  send('blackmarket\list_113.txt', AThread);
  send('blackmarket\list_114.txt', AThread);
  send('blackmarket\list_115.txt', AThread);
  send('blackmarket\list_116.txt', AThread);
  send('blackmarket\list_117.txt', AThread);
  send('blackmarket\list_118.txt', AThread);
  send('blackmarket\list_119.txt', AThread);
  send('blackmarket\list_120.txt', AThread);
  send('blackmarket\list_121.txt', AThread);
  //send('blackmarket\list_122.txt', AThread);
  // Ticket List
  send('blackmarket\tickets_list\ticket_1.txt', AThread, 2, 'Ticket List 1');
  send('blackmarket\tickets_list\ticket_2.txt', AThread, 2, 'Ticket List 2');
  send('blackmarket\tickets_list\ticket_3.txt', AThread, 2, 'Ticket List 3');
end;

end. 
