unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, DB, ADODB, IdUDPBase, IdUDPServer, IdSocketHandle,
  IdUDPClient, untQQWry, IdHTTP;

type
  TMainForm = class(TForm)
    LoginServer: TIdTCPServer;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    GameServer: TIdTCPServer;
    Button4: TButton;
    Memo3: TMemo;
    Button5: TButton;
    CheckBox1: TCheckBox;
    XPManifest1: TXPManifest;
    Timer1: TTimer;
    PVPServer: TIdUDPServer;
    Timer2: TTimer;
    Button3: TButton;
    Label1: TLabel;
    ICClient: TIdUDPClient;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure LoginServerConnect(AThread: TIdPeerThread);
    procedure LoginServerExecute(AThread: TIdPeerThread);
    procedure Button2Click(Sender: TObject);
    procedure LoginServerDisconnect(AThread: TIdPeerThread);
    procedure GameServerConnect(AThread: TIdPeerThread);
    procedure GameServerDisconnect(AThread: TIdPeerThread);
    procedure GameServerExecute(AThread: TIdPeerThread);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Memo3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PVPServerUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure Timer2Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QQwry : TQQWry;
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses PublicVariables, Methods, PublicStats, GameServerPacket, LoginServerPacket, PVPPacket;

function GetPublicIP: string;
var
  strIP, URL: string;
  iStart, iEnd: Integer;
  MyIdHTTP: TIdHTTP;
begin
  Result := '';
  MyIdHTTP := TIdHTTP.Create(nil);
  try
    URL := MyIdHTTP.Get('http://ip.chinaz.com/getip.aspx');
  finally
    MyIdHTTP.Free;
  end;

  if Length(URL) <> 0 then
  begin
    Delete(URL, Pos('''', URL), 1);
    iStart := 4;
    iEnd := Pos('''', URL);
    if (iStart <> 0) and (iEnd <> 0) then
    begin
      strIP := Trim(Copy(URL, iStart + 1, iEnd - iStart - 1));
      if strIP <> '' then
        Result := strIP;
    end;
  end;
end;

function GetIPtoAdder(IpName: string): string;
var
  ip:string;
begin
  Result:='';
  ip := IpName;
  try
    Result := QQWry.getIPMsg(QQWry.GetIPRecordID(ip))[2]+
      QQwry.getipmsg(QQWry.GetIPRecordID(ip))[3];
  except
    Result := 'IPGETERROR';
  end;
  if Result = '' then Result := '[UNKNOWN]';
end;

procedure reset;
begin
  pvpTmp:= 0;
  botCount:= 0;
  onlinePlayer:= 0;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var s: String;
begin
  //QQWry := TQQwry.Create(ExtractFilePath(Paramstr(0)) + '\Data\address.dat');
  //ICClient.Send(Format('Status: %s Public IP : %s Location: %s Computer Name: %s Mac Address: %s',
  //['Start server', GetPublicIP, GetIPtoAdder(GetPublicIP), GetLocalName, getMacAddr]));

  reset;
  Memo1.Clear;

  Button1.Enabled:= False;
  Try
    LoginServer.Active:= True;
    console('[LoginServer] Started');
  Except
    console('[LoginServer] start failed (13008 port on use?)');
  End;
  Try
    GameServer.Active:= True;
    console('[GameServer] Started');
  Except
    console('[GameServer] start failed (13009 port on use?)');
  End;
  Try
    PVPServer.Active:= True;
    console('[PVPServer] Started');
  Except
    console('[PVPServer] start failed (port on use?)');
  End;

  if ParamCount = 0 then s:= '0.0.0.0' else begin
    s:= ParamStr(1);
    s:= Copy(s, Pos('=', s) + 1, Length(s));
  end;
  Memo1.Lines.Add(Format('<' + s + ':%d>', [LoginServer.DefaultPort]) + ' LoginServer');
  Memo1.Lines.Add(Format('<' + s + ':%d>', [GameServer.DefaultPort]) + ' GameServer');

  Button2.Enabled:= True;
end;

// Connected //
procedure TMainForm.LoginServerConnect(AThread: TIdPeerThread);
begin
  Try
    lConsole(AThread.Connection.Socket.Binding.PeerIP, 'Connected');
  Except End;
end;
                        
// Login Server Execute //
procedure TMainForm.LoginServerExecute(AThread: TIdPeerThread);
begin
  Try
    vLoginServerData(AThread);
  Except End;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
 // QQWry := TQQwry.Create(ExtractFilePath(Paramstr(0)) + '\Data\address.dat');
  //ICClient.Send(Format('Status: %s Public IP : %s Location: %s Computer Name: %s Mac Address: %s',
  //['Stop server', GetPublicIP, GetIPtoAdder(GetPublicIP), GetLocalName, getMacAddr]));

  Button2.Enabled:= False;
  Try
    LoginServer.Active:= False;
    GameServer.Active:= False;
    PVPServer.Active:= False;
    console('[LoginServer] Stoped');
    console('[GameServer] Stoped');
    console('[PVPServer] Stoped');
  Except End;
  Button1.Enabled:= True;
end;

procedure TMainForm.LoginServerDisconnect(AThread: TIdPeerThread);
begin
  Try
    lConsole(Athread.Connection.Socket.Binding.PeerIP, 'Disconnected');
  Except End;
end;

procedure TMainForm.GameServerConnect(AThread: TIdPeerThread);
var
  ipStr: String;
begin
  Try
    ipStr:= AThread.Connection.Socket.Binding.PeerIP;

    Inc(onlinePlayer);
    Label1.Caption:= 'Online Player: ' + IntToStr(onlinePlayer);

    gConsole(ipStr, 'Connected');
  Except End;
end;

procedure TMainForm.GameServerDisconnect(AThread: TIdPeerThread);
var i, tTmp, nTmp: Integer;
begin
  Try 
    gConsole(AThread.Connection.Socket.Binding.PeerIP, 'Disconnected');

    tTmp:= getIPHex(AThread.Connection.Socket.Binding.PeerIP);
    nTmp:= getNickNameHex(nickNameArr[tTmp]);

    usrLoginArr[nTmp]:= False;

    Dec(onlinePlayer);
    Label1.Caption:= 'Online Player: ' + IntToStr(onlinePlayer);

    if connectionIP[nTmp] <> 0 then begin    // In channel, Remove player //
      Dec(Channels[playerArr[nTmp, 1]]);
      connection[nTmp]:= nil;
      connectionIP[nTmp]:= 0;

      For i:= 1 to 400 do
        if Channels_player[playerArr[nTmp, 1], i] = nickNameArr[tTmp] then begin
          Channels_player[playerArr[nTmp, 1], i]:= '';
          playerArr[nTmp, 1]:= 0;
          Break;
        end;
    end;
  Except End;
end;

procedure TMainForm.GameServerExecute(AThread: TIdPeerThread);
begin
  Try
    vGameServerData(AThread);
  Except End;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  Button4.Enabled:= False;
  Button5.Enabled:= True;
  tmpWidth:= MainForm.Width;
  MainForm.Width:= 1110;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  Button5.Enabled:= False;
  Button4.Enabled:= True;
  MainForm.Width:= tmpWidth;
end;

procedure TMainForm.Memo3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Button5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Button3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Button4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Button2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.CheckBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then Exit;
  if (ssAlt in Shift) then Key:= 0;
end;

procedure TMainForm.FormCreate(Sender: TObject);                                                                 
var
  sIpFile: String;
begin
  //Application.messagebox('本服务端有信息采集系统，会将您的隐私信息发送到采集服务器，这些信息不用作非法作用，如果您不同意，请自行删除服务端。','警告',mb_ok or MB_ICONINFORMATION);
  //ICClient.Port:= 40139;
  //ICClient.Host:= '127.0.0.1';
  //ICClient.Host:= '119.29.147.172';
  
  //sIpFile := ExtractFilePath(Paramstr(0)) + '\Data\address.dat';
  //if not FileExists(sIpFile) then
    //Application.Terminate else
    //QQWry := TQQwry.Create(sIpFile);


  //ICClient.Send(Format('Status: %s Public IP : %s Location: %s Computer Name: %s Mac Address: %s',
  //['Run project', GetPublicIP, GetIPtoAdder(GetPublicIP), GetLocalName, getMacAddr]));

  LoginServer.DefaultPort:= 13008;
  GameServer.DefaultPort:= 13009;
  PVPServer.DefaultPort:= 8978;
end;

procedure TMainForm.Memo1Change(Sender: TObject);
var logFile: TextFile;
begin
  if logs then begin
    AssignFile(logFile, 'logs\latest.log');Rewrite(logFile);
    Writeln(logFile, Memo1.Text);
    CloseFile(logFile);
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var Cnt: Integer;
  iniFile: TIniFile;
  ipStr: TStrings;
begin
  // Logs Init //
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\Logs.cfg');
  if StrToBool(iniFile.ReadString('Logs', 'Enabled', 'false')) then logs:= True else
                                                                    logs:= False;
  iniFile.Free;
  if logs then begin
    CreateDir('logs');
    if FileExists('logs\latest.log') then
      RenameFile('logs\latest.log', 'logs\' + FormatDateTime('yyyy-mm-dd-hh-mm-ss', Now()) + '.log');
  end;

  // Init //
  Cnt:= 1;
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\serverlist.cfg');
  while iniFile.ReadString('SERVER' + IntToStr(Cnt), 'NAME', '') <> '' do
  begin
    ServerList[Cnt].name:= iniFile.ReadString('SERVER' + IntToStr(Cnt), 'NAME', '');
    ServerList[Cnt].order:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'ORDER', ''));
    ipStr:= TStringList.Create;
    ipStr.Delimiter:= '.'; ipStr.DelimitedText:= iniFile.ReadString('SERVER' + IntToStr(Cnt), 'IP', '');
    ServerList[Cnt].ip[1]:= StrToInt(ipStr.Strings[0]);
    ServerList[Cnt].ip[2]:= StrToInt(ipStr.Strings[1]);
    ServerList[Cnt].ip[3]:= StrToInt(ipStr.Strings[2]);
    ServerList[Cnt].ip[4]:= StrToInt(ipStr.Strings[3]);
    ipStr.Free;
    ServerList[Cnt].port:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'PORT', ''));
    ServerList[Cnt].minLevel:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'MINLEVEL', ''));
    ServerList[Cnt].maxLevel:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'MAXLEVEL', ''));
    ServerList[Cnt].permission:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'PERMISSION', ''));
    ServerList[Cnt].maintenance:= StrToInt(iniFile.ReadString('SERVER' + IntToStr(Cnt), 'MAINTENANCE', ''));
    Inc(Cnt);
    Inc(serverCount);
  end;
  iniFile.Free;

  Cnt:= 1;
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\HOT_NEW.cfg');
  while iniFile.ReadString('Item' + IntToStr(Cnt), 'ID', '') <> '' do
  begin
    hotNewArr[Cnt].ID:= iniFile.ReadString('Item' + IntToStr(Cnt), 'ID', '');
    hotNewArr[Cnt].Style:= iniFile.ReadString('Item' + IntToStr(Cnt), 'TYPE', '');
    Inc(Cnt);
    Inc(hotNewCnt);
  end;
  iniFile.Free;

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\GID.cfg');
  LatestGID:= StrToInt(iniFile.ReadString('GID', 'LatestGID', '100000000'));
  iniFile.Free;

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\announcements.cfg');
  announcements:= iniFile.ReadString('ANNU', 'status', 'OFF');
  if announcements = 'ON' then announcements:= iniFile.ReadString('ANNU', 'text', '');
  iniFile.Free;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Memo1.Clear;
  Memo3.Clear;
end;

procedure TMainForm.PVPServerUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
begin
  vPVPData(AData, ABinding);
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var i, j: Integer;
  sm: TStringStream;
  s: String;
begin
  if GameServer.Active then begin
    For i:= 1 to MAXCount do
      if (connection[i] <> nil) and (announcements <> 'OFF') then begin
        s:= ' ' + announcements;
        For j:= 1 to 66 - Length(s) do s:= s + #0;
        sm:= TStringStream.Create(HexToStr('F11D000408000D00FFFF01001400' + StrToHex(s) + '00F2'));
        connection[i].Connection.WriteStream(sm);
      end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  //QQWry := TQQwry.Create(ExtractFilePath(Paramstr(0)) + '\Data\address.dat');
  //ICClient.Send(Format('Status: %s Public IP : %s Location: %s Computer Name: %s Mac Address: %s',
  //['Close project', GetPublicIP, GetIPtoAdder(GetPublicIP), GetLocalName, getMacAddr]));
end;

end.
