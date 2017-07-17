program Emulator;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  PublicVariables in 'PublicVariables.pas',
  Methods in 'Methods.pas',
  PublicStats in 'PublicStats.pas',
  GameServerPacket in 'GameServer\GameServerPacket.pas',
  PVPPacket in 'PVPServer\PVPPacket.pas',
  ServerPacket in 'ServerPacket.pas',
  LoginServerPacket in 'LoginServer\LoginServerPacket.pas',
  Login in 'LoginServer\Login.pas',
  Into_Server in 'LoginServer\Into_Server.pas',
  Player_Data in 'LoginServer\Player_Data.pas',
  Exit in 'LoginServer\Exit.pas',
  NickName in 'LoginServer\NickName.pas',
  PlayerData in 'GameServer\PlayerData.pas',
  BackToServer in 'GameServer\BackToServer.pas',
  Server_List in 'GameServer\Server_List.pas',
  CompileOptions in 'CompileOptions.pas',
  BlackMarket in 'GameServer\BlackMarket.pas',
  BuySystem in 'GameServer\BuySystem.pas',
  Ping in 'GameServer\Ping.pas',
  NewbieMission in 'GameServer\NewbieMission.pas',
  EquipItem in 'GameServer\EquipItem.pas',
  Clan in 'GameServer\Clan.pas',
  Profile in 'GameServer\Profile.pas',
  Connect_Data in 'GameServer\Connect_Data.pas',
  ExchangeItem in 'GameServer\ExchangeItem.pas',
  ChangeTeam in 'GameServer\ChangeTeam.pas',
  UnknownHeader in 'GameServer\UnknownHeader.pas',
  ZPSystem in 'GameServer\ZPSystem.pas',
  PlayerInfo in 'GameServer\PlayerInfo.pas',
  Coupons in 'GameServer\Coupons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CrossFire Emulator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
