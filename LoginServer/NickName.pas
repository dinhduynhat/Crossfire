unit NickName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Confirm_NickName(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
procedure __Enter_NickName(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);

implementation

uses Methods, PublicVariables;

procedure __Enter_NickName(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
var i, tTmp: Integer;
  s, ipStr, name, tName, tPw: String;
  iniFile: TIniFile;
  t: Boolean;
  usrFile: TextFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  // Get nick name //
  s:= '';
  i:= 7;
  While i < Len - 1 do Begin
    if (sm.DataString[i] = #0) then Break;
    if ((ord(sm.DataString[i]) < 32) or (ord(sm.DataString[i]) > 126)) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #0#0) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #0#$B) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #$B#0) and
    (sm.DataString[i] <> #0) then begin
      s:= s + sm.DataString[i] + sm.DataString[i + 1];
      Inc(i);
    End else
    if (sm.DataString[i] <> #0) and (sm.DataString[i] <> #$B) then
      s:= s + sm.DataString[i];
    Inc(i);
  End;

  name:= s;
  if Length(name) < 3 then begin
    send('name_too_short', AThread, 1, 'Enter nick name: [' + name + '] is too short');
    Exit;
  End;

  t:= False;
  AssignFile(usrFile, 'user.txt');Reset(usrFile);
  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\nickname.cfg');
  While not Eof(usrFile) do Begin
    Readln(usrFile, tName);
    if StringReplace(tName, ' ', '', [rfReplaceAll]) = '' then Continue;
    if tName = usrNameArr[tTmp] then Continue;
    tPw:= Copy(tName, Pos(' ', tName) + 1, Length(tName));
    Delete(tName, Pos(' ', tName), Length(tName));
    if iniFile.ReadString('NICKNAME', tName, '') = name then begin
      t:= True;
      Break;
    end;
  End;
  iniFile.Free;
  CloseFile(usrFile);
  if t then
    send('name_in_use', AThread, 1, 'Enter nick name: [' + name + '] is in use') else
    send('name_available', AThread, 1, 'Enter nick name: [' + name + '] available');
end;

procedure __Confirm_NickName(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
var i, tTmp: Integer;
  s, ipStr, name: String;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  
  tTmp:= getIPHex(ipStr);

  s:= '';
  i:= 7;
  While i < Len - 1 do Begin
    if ((ord(sm.DataString[i]) < 32) or (ord(sm.DataString[i]) > 126)) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #0#0) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #0#$B) and
    (sm.DataString[i] + sm.DataString[i + 1] <> #$B#0) then begin
    s:= s + sm.DataString[i] + sm.DataString[i + 1];
    Inc(i);
    End else
    if (sm.DataString[i] <> #0) and (sm.DataString[i] <> #$B) then
    s:= s + sm.DataString[i];
    Inc(i);
  End;
  name:= s;

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\nickname.cfg');
  iniFile.WriteString('NICKNAME', usrNameArr[tTmp], name);
  iniFile.Free;
  usrStatusArr[tTmp]:= 'LOGIN';
  send('confirm_name', AThread, 1, 'Confirm nick name: [' + name + ']');
  nickNameArr[tTmp]:= name;
end;

end.
