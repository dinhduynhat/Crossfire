unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Login(AThread: TIdPeerThread; packet: String; sm: TStringStream; Len: Integer);

implementation

uses Methods, PublicVariables, PublicStats;

procedure __Login(AThread: TIdPeerThread; packet: String; sm: TStringStream; Len: Integer);
var i, id, k: Integer;
  header, sub_header, unk_header: String;
  Fr1, Fr2, Len1, Len2, tTmp, nTmp, exp, gp, zp, fp, apsend, victory, defeat, kill,
  death, gid, expb: Integer;
  ipStr, s, name, pw, tName, tPw, tNick, tNamed, sHeader, tClan: String;
  t, ff, ff2: Boolean;
  usrFile, usrFile2: TextFile;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);
  nTmp:= getNickNameHex(nickNameArr[tTmp]);

  t:= False;ff:= False;ff2:=False;Fr1:= 0;Fr2:= 0;Len1:=0;Len2:=0;
  loginStatus:= 1;
  // Get usrname & password //
  s:= StrToVisibleHex(sm, Len);
  For i:= 1 to Length(s) do Begin
    if (s[i]<>'.') and not t then Begin
      if not ff then Begin
        Fr1:= i;
        ff:= True;
      end;
      inc(Len1);
      if s[i+1]='.' then
        t:= True;
    End Else
    if (s[i]<>'.') and t then begin
      if not ff2 then begin
        Fr2:= i;
        ff2:= True;
      End;
      Inc(Len2);
      if s[i+1]='.' then
        Break;
    end;
  End;
  name:= Copy(s, Fr1, Len1);
  pw:= Copy(s, Fr2, Len2);

  AssignFile(usrFile, 'user.txt');Reset(usrFile);
  Try
    While not Eof(usrFile) do Begin
      Readln(usrFile, tName);
      if StringReplace(tName, ' ', '', [rfReplaceAll]) = '' then Continue;

      tPw:= Copy(tName, Pos(' ', tName) + 1, Length(tName));
      Delete(tName, Pos(' ', tName), Length(tName));
      iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\nickname.cfg');
      tNick:= iniFile.ReadString('NICKNAME', tName, '');
      iniFile.Free;
      if not DirectoryExists('user') then ForceDirectories('user');
      if not FileExists(ExtractFileDir(ParamStr(0)) + '\user\' + tName + '.txt') then Begin
        AssignFile(usrFile2, ExtractFileDir(ParamStr(0)) + '\user\' + tName + '.txt');Rewrite(usrFile2);
        Writeln(usrFile2, '[User Data]');
        Inc(LatestGID);
        Writeln(usrFile2, 'GID = ' + IntToStr(LatestGID));
        iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\GID.cfg');
        iniFile.WriteString('GID', 'LatestGID', IntToStr(LatestGID));
        iniFile.Free;
        
        iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\DefaultSettings.cfg');
        Writeln(usrFile2, 'EXP = ' + iniFile.ReadString('Settings', 'DefaultEXP', '0'));
        Writeln(usrFile2, 'GP = ' + iniFile.ReadString('Settings', 'DefaultGP', '40000'));
        Writeln(usrFile2, 'ZP = ' + iniFile.ReadString('Settings', 'DefaultZP', '0'));
        Writeln(usrFile2, 'FP = ' + iniFile.ReadString('Settings', 'DefaultFP', '0'));
        Writeln(usrFile2, 'KILL = ' + iniFile.ReadString('Settings', 'DefaultKILL', '0'));
        Writeln(usrFile2, 'DEATH = ' + iniFile.ReadString('Settings', 'DefaultDEATH', '0'));
        Writeln(usrFile2, 'VICTORY = ' + iniFile.ReadString('Settings', 'DefaultVICTORY', '0'));
        Writeln(usrFile2, 'DEFEAT = ' + iniFile.ReadString('Settings', 'DefaultDEFEAT', '0'));
        Writeln(usrFile2, 'ATTENDANCE = ' + iniFile.ReadString('Settings', 'DefaultATTENDANCE', '0'));
        CloseFile(usrFile2);
        iniFile.Free;
      end;

      if (LowerCase(tName) = LowerCase(name)) and (pw = tPw) then Begin
        nickNameArr[tTmp]:= tNick;
        usrNameArr[tTmp]:= tName;

        iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\user\' + tName + '.txt');
        exp:= StrToInt(iniFile.ReadString('User Data', 'EXP', '0'));
        gp:= StrToInt(iniFile.ReadString('User Data', 'GP', '0'));
        zp:= StrToInt(iniFile.ReadString('User Data', 'ZP', '0'));
        fp:= StrToInt(iniFile.ReadString('User Data', 'FP', '0'));
        tNamed:= iniFile.ReadString('User Data', 'FriendNamed', '');
        apsend:= StrToInt(iniFile.ReadString('User Data', 'APPosted', '0'));
        kill:= StrToInt(iniFile.ReadString('User Data', 'KILL', '0'));
        death:= StrToInt(iniFile.ReadString('User Data', 'DEATH', '0'));
        victory:= StrToInt(iniFile.ReadString('User Data', 'VICTORY', '0'));
        defeat:= StrToInt(iniFile.ReadString('User Data', 'DEFEAT', '0'));
        tClan:= iniFile.ReadString('User Data', 'CLAN', tClan);
        gid:= StrToInt(iniFile.ReadString('User Data', 'GID', '100000000'));
        iniFile.Free;

        usrEXPArr[tTmp]:= exp;
        usrGPArr[tTmp]:= gp;
        usrZPArr[tTmp]:= zp;
        usrFPArr[tTmp]:= fp;
        usrAPSendArr[tTmp]:= apsend;
        usrKillArr[tTmp]:= kill;
        usrDeathArr[tTmp]:= death;
        usrVictoryArr[tTmp]:= victory;
        usrDefeatArr[tTmp]:= defeat;
        usrGIDArr[tTmp]:= gid;
        clanNameArr[tTmp]:= tClan;
        playerNamedArr[tTmp]:= tNamed;
        usrStatusArr[tTmp]:= 'LOGIN';
        loginStatus:= 2;

        if tNick = '' then begin
          loginStatus:= 3;
          lConsole(ipStr, 'login with name: ' + name + ' password: ' + pw + ' (new charapter)');
        end else
        if usrLoginArr[nTmp] then begin
          loginStatus:= 4;
          lConsole(ipStr, 'login with name: ' + name + ' password: ' + pw + ' nickname: ' + tNick + ' (logined)');
        end else
          lConsole(ipStr, 'login with name: ' + name + ' password: ' + pw + ' nickname: ' + tNick);
        Break;
      End;
    End;
  Finally
    CloseFile(usrFile);
    if (loginStatus <> 2) and (loginStatus <> 3) and (loginStatus <> 4) then begin
      loginStatus:= 1;
      lConsole(ipStr, 'login with name: ' + name + ' password: ' + pw);
    end;
  End;

  if loginStatus = 1 then begin
    send('bad_login', AThread);
  end;
  if loginStatus = 2 then begin
    send('success_login', AThread);
    //send('F10000000700F2', AThread);
    sHeader:= 'F1A01F00010000000000';
    s:= StringReplace(StrToHex(tNick), ' ', '', [rfReplaceAll]);
    For i:= 1 to 16 - Length(s) div 2 do s:= s + '00';
    sHeader:= sHeader + s + IntToVHex(usrGIDArr[tTmp], 8) + '000000000000000000000000000000' +
    '00000000000000F03F12000000';
    id:= 1;
    For i:= 1 to serverCount do
    begin
      sHeader:= sHeader + '00000000' + IntToVHex(ServerList[id].order, 4) +
      IntToVHex(ServerList[id].permission, 4) +
      IntToVHex(ServerList[id].minLevel, 4) +
      IntToVHex(ServerList[id].maxLevel, 4);
      sHeader:= sHeader + '00000000' + '000000000000000000000000';
      sHeader:= sHeader + IntToVHex(id, 4);
      s:= StringReplace(StrToHex(ServerList[id].name), ' ', '', [rfReplaceAll]);
      For k:= 1 to 34 - Length(s) div 2 do s:= s + '00';
      sHeader:= sHeader + s + IntToVHex(ServerList[id].port, 4) + '0000';
      sHeader:= sHeader + IntToVHex(ServerList[id].ip[1], 2) +
      IntToVHex(ServerList[id].ip[2], 2) +
      IntToVHex(ServerList[id].ip[3], 2) +
      IntToVHex(ServerList[id].ip[4], 2) + '540B0000';
      if ServerList[id].maintenance = 0 then
        sHeader:= sHeader + '00000000' else
        sHeader:= sHeader + 'FFFFFFFF';
      Inc(id);
    end;
    For i:= 1 to 8070 - Length(sHeader) div 2 do sHeader:= sHeader + '00';
    sHeader:= sHeader + '24 48 00 00 EB C7 5F 5F 40 E5 75 1D 39 71 71 71 6E CB 5B 33 17 5F 08 6C 01 00 00 00 00 00 00 00 F2';
    sm:= TStringStream.Create(HexToStr(sHeader));

    AThread.Connection.WriteStream(sm);
  end;
  if loginStatus = 3 then begin
    send('success_login', AThread);

    sHeader:= 'F1A01F00010006000000';
    s:= StringReplace(StrToHex(tNick), ' ', '', [rfReplaceAll]);
    For i:= 1 to 16 - Length(s) div 2 do s:= s + '00';
    sHeader:= sHeader + s + IntToVHex(usrGIDArr[tTmp], 8) + '000000000000000000000000000000' +
    '00000000000000F03F12000000';
    id:= 1;
    For i:= 1 to serverCount do
    begin
      sHeader:= sHeader + '00000000' + IntToVHex(ServerList[id].order, 4) +
      IntToVHex(ServerList[id].permission, 4) +
      IntToVHex(ServerList[id].minLevel, 4) +
      IntToVHex(ServerList[id].maxLevel, 4);
      sHeader:= sHeader + '00000000' + '000000000000000000000000';
      sHeader:= sHeader + IntToVHex(id, 4);
      s:= StringReplace(StrToHex(ServerList[id].name), ' ', '', [rfReplaceAll]);
      For k:= 1 to 34 - Length(s) div 2 do s:= s + '00';
      sHeader:= sHeader + s + IntToVHex(ServerList[id].port, 4) + '0000';
      sHeader:= sHeader + IntToVHex(ServerList[id].ip[1], 2) +
      IntToVHex(ServerList[id].ip[2], 2) +
      IntToVHex(ServerList[id].ip[3], 2) +
      IntToVHex(ServerList[id].ip[4], 2) + '540B0000';
      if ServerList[id].maintenance = 0 then
        sHeader:= sHeader + '00000000' else
        sHeader:= sHeader + 'FFFFFFFF';
      Inc(id);
    end;
    For i:= 1 to 8070 - Length(sHeader) div 2 do sHeader:= sHeader + '00';
    sHeader:= sHeader + '24 48 00 00 EB C7 5F 5F 40 E5 75 1D 39 71 71 71 6E CB 5B 33 17 5F 08 6C 01 00 00 00 00 00 00 00 F2';
    sm:= TStringStream.Create(HexToStr(sHeader));

    AThread.Connection.WriteStream(sm);
    usrStatusArr[tTmp]:= 'ENTERNICKNAME';
  end;
  if loginStatus = 4 then begin
    sHeader:= 'f1a01f0001000200000000000000000000000000000000000000';
    sHeader:= sHeader + IntToVHex(usrGIDArr[tTmp], 8);
    For i:= 1 to 8094 - Length(sHeader) div 2 do sHeader:= sHeader + '00';
    sHeader:= sHeader + '0100000000000000f2';

    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
  end;
  checkStatus(ipStr);
end;

end.
