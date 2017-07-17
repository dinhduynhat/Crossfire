unit PublicVariables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

const MAXCount = 10000;

type ipType = array[1 .. 4] of Integer;

type serverType = record
  name: String;
  ip: ipType;
  order, port, minLevel, maxLevel, permission, maintenance: Integer;
end;

type itemType = record
  ID, Style: String;
end;

var
  loginStatus, onlinePlayer, hotNewCnt, serverCount, latestGID: Integer;
  tmpWidth: Integer;
  nickNameArr, playerNamedArr, clanNameArr: Array[0 .. MAXCount] of String;
  usrStatusArr: Array[0 .. MAXCount] of String;
  usrLevelBArr: Array[0 .. MAXCount] of Integer;
  usrNameArr: Array[0 .. MAXCount] of String;
  usrEXPArr, usrGPArr, usrZPArr, usrFPArr, usrAPSendArr, usrRecvNamedArr, usrDataNamedArr, usrKillArr, usrDeathArr,
  usrVictoryArr, usrDefeatArr, usrGIDArr, usrLVLArr: Array[0 .. MAXCount] of Integer;
  usrBolArr: Array[0 .. MAXCount, 0 .. MAXCount] of Integer;
  usrLoginArr: array[0 .. MAXCount] of Boolean;
  usrQUANTArr, usrITEM1Arr, usrITEM2Arr, usrITEM3Arr: Array[0 .. MAXCount] of Integer;

  gp_gained_gp_crate: array[1..22] of Integer = (100,100,1000,1000,100,100,1000,100,
  10000,100,1000,100,5000,100,1000,1000,1000,10000,5000,20000,5000,10000);
  gp_gained_zp_crate: array[1..22] of Integer = (100,100,1000,1000,100,100,1000,100,
  10000,100,1000,100,5000,100,1000,1000,1000,10000,5000,20000,5000,10000);

  items_win: array[1..3] of Integer = (2010056801,2010056401,2010056001);

  exp_room_gained: array[1..3] of Integer = (323, 1256, 10004);
  gp_room_gained: array[1..3] of Integer = (56, 302, 1245);
  // Ratio x10
  special_exp_room_gained: array[1..3] of Integer = (10032, 55503, 1000056);
  special_gp_room_gained: array[1..3] of Integer = (1032, 5502, 11036);

  explevel: array[0 .. 99] of Integer = (0, 457, 913, 1825, 3193, 5017, 7297, 10032,
  13225, 17785, 23941, 33061, 43093, 51037, 65893, 78661, 92341, 106933, 122437,
  138853, 156181, 174421, 193573, 213637, 234613, 256501, 279301, 326725, 375973,
  427045, 479941, 534661, 591205, 649573, 709765, 771781, 835621, 901285, 968773,
  1038085, 1109221, 1182181, 1256965, 1412005, 1492261, 1574341, 1658245, 1743973,
  1831525, 1920901, 2057701, 2057701, 2197237, 2339509, 2484517, 2632261, 2782741,
  2935957, 3091909, 3465372, 3673536, 3885177, 4100295, 4318890, 4540962, 4766511,
  5028198, 5319183, 5614500, 5914149, 6218130, 6526500, 6839202, 7156236, 7578036,
  8026911, 8481771, 8964561, 9475851, 10016211, 10586211, 11186421, 11817411, 12479751,
  13174011, 13900761, 14660571, 15454011, 16281651, 17144061, 18041811, 18975471,
  19945611, 20952801, 21997611, 23080611, 24202371, 25363461, 26564451, 30000000);
  servers_player_count: array[1 .. 2] of Integer = (50, 0);

  // Weapon Types //
  SHOTGUN: Integer = 0;
  SMG: Integer = 1;
  RIFLE: Integer = 2;
  SNIPER_RIFLE: Integer = 3;
  MG: Integer = 4;
  PISTOL: Integer = 5;
  KNIFE: Integer = 6;
  GRENADE: Integer = 7;

  ServerList: array[1 .. 100] of serverType;
  Channels: array[1 .. 10] of Integer = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  Channels_player: array[1 .. 10, 1 .. 400] of String;
  playerArr: array[1 .. MAXCOUNT, 1 .. 5] of Integer;
  hotNewArr: array[1 .. 100] of itemType;
  connection: array[1 .. MAXCOUNT] of TIdPeerThread;
  connectData: array[1 .. MAXCOUNT] of TIdPeerThread;
  connectionIP: array[1 .. MAXCOUNT] of Integer;
  botCount: Integer;
  announcements: string;
  atte: string;
  PlayerID: string;
  itemshop: Integer;
  Room_player: array[1 .. 16] of String;
  pvpTmp: Integer;
  logs: Boolean;

implementation

end.



