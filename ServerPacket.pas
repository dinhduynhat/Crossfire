unit ServerPacket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure packet_login(AThread: TIdPeerThread; packet: String; sm: TStringStream; Len: Integer);
procedure packet_into_server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
procedure packet_player_data(AThread: TIdPeerThread);
procedure packet_exit(AThread: TIdPeerThread);
procedure packet_confirm_nickname(AThread: TIdPeerThread; sm:TStringStream; Len: Integer);
procedure packet_enter_nickname(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
procedure packet_game_player_data(AThread: TIdPeerThread);
procedure packet_back_to_server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
procedure packet_server_list(AThread: TIdPeerThread);
procedure packet_black_market(AThread: TIdPeerThread);
procedure packet_bought_item(AThread: TIdPeerThread; packet: String);
procedure packet_ping(AThread: TIdPeerThread);
procedure packet_newbiemission_item(AThread: TIdPeerThread; packet: String);
procedure packet_newbiemission(AThread: TIdPeerThread);
procedure packet_equip_item(AThread: TIdPeerThread);
procedure packet_clan(AThread: TIdPeerThread; packet: String; sub_header: String);
procedure packet_profile(AThread: TIdPeerThread);
procedure packet_connect_data(AThread: TIdPeerThread);
procedure packet_exchange_item(AThread: TIdPeerThread; packet: String);
procedure packet_change_team(AThread: TIdPeerThread; unk_header: String);
procedure packet_unk_header_01(AThread: TIdPeerThread);
procedure packet_refresh_zp(AThread: TIdPeerThread);
procedure packet_player_info(AThread: TIdPeerThread; sub_header: String);
procedure packet_coupons(AThread: TIdPeerThread);

implementation

uses Login, Into_Server, Player_Data, Exit, NickName, PlayerData, BackToServer,
     Server_List, BlackMarket, BuySystem, Ping, NewbieMission, EquipItem, Clan,
     Profile, Connect_Data, ExchangeItem, ChangeTeam, UnknownHeader, ZPSystem,
     PlayerInfo, Coupons;

procedure packet_login(AThread: TIdPeerThread; packet: String; sm: TStringStream; Len: Integer);
begin
  __Login(AThread, packet, sm, Len);
end;

procedure packet_into_server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
begin
  __Into_Server(AThread, sm, Len);
end;

procedure packet_player_data(AThread: TIdPeerThread);
begin
  __Player_Data(AThread);
end;

procedure packet_exit(AThread: TIdPeerThread);
begin
  __Exit(AThread);
end;

procedure packet_confirm_nickname(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
begin
  __Confirm_NickName(AThread, sm, Len);
end;

procedure packet_enter_nickname(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
begin
  __Enter_NickName(AThread, sm, Len);
end;

procedure packet_game_player_data(AThread: TIdPeerThread);
begin
  __Game_Player_Data(AThread);
end;

procedure packet_back_to_server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
begin
  __Back_To_Server(AThread, sm, Len);
end;

procedure packet_server_list(AThread: TIdPeerThread);
begin
  __Server_List(AThread);
end;

procedure packet_black_market(AThread: TIdPeerThread);
begin
  __Black_Market(AThread);
end;

procedure packet_bought_item(AThread: TIdPeerThread; packet: String);
begin
  __Bought_Item(AThread, packet);
end;

procedure packet_ping(AThread: TIdPeerThread);
begin
  __Ping(AThread);
end;

procedure packet_newbiemission_item(AThread: TIdPeerThread; packet: String);
begin
  __NewbieMission_Item(AThread, packet);
end;

procedure packet_newbiemission(AThread: TIdPeerThread);
begin
  __NewbieMission(AThread);
end;

procedure packet_equip_item(AThread: TIdPeerThread);
begin
  __Equip_Item(AThread);
end;

procedure packet_clan(AThread: TIdPeerThread; packet: String; sub_header: String);
begin
  __Clan(AThread, packet, sub_header);
end;

procedure packet_profile(AThread: TIdPeerThread);
begin
  __Profile(AThread);
end;

procedure packet_connect_data(AThread: TIdPeerThread);
begin
  __Connect_Data(AThread);
end;

procedure packet_exchange_item(AThread: TIdPeerThread; packet: String);
begin
  __Exchange_Item(AThread, packet);
end;

procedure packet_change_team(AThread: TIdPeerThread; unk_header: String);
begin
  __Change_Team(AThread, unk_header);
end;

procedure packet_unk_header_01(AThread: TIdPeerThread);
begin
  __unk_header_01(AThread);
end;

procedure packet_refresh_zp(AThread: TIdPeerThread);
begin
  __ZP_Refresh(AThread);
end;

procedure packet_player_info(AThread: TIdPeerThread; sub_header: String);
begin
  __Player_Info(AThread, sub_header);
end;

procedure packet_coupons(AThread: TIdPeerThread);
begin
  __Coupons(AThread);
end;

end.
