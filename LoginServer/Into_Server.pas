unit Into_Server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure __Into_Server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);

implementation

uses Methods, PublicVariables;

procedure __Into_Server(AThread: TIdPeerThread; sm: TStringStream; Len: Integer);
var i, tTmp, nTmp: Integer;
  ipStr, s, s1, source: String;
  usrFile2: TextFile;
  iniFile: TIniFile;
begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;

  tTmp:= getIPHex(ipStr);
  nTmp:= getNickNameHex(nickNameArr[tTmp]);

  s:= StringReplace(StrToHexCnt(sm, Len), ' ', '', [rfReplaceAll]);
  gConsole(ipStr, Format('join server %d', [StrToInt(s[13]) + StrToInt(s[14])]));
  s:= FormatDateTime('yyyymmddhhnnss', Now());

  source:= 'abcdefghi0123456789';
  Randomize;   s1:= '';
  For i:= 1 to 32 do
    s1:= s1 + source[Random(18) + 1];

  sm:= TStringStream.Create(HexToStr(sendLoginMessage('into_server_top')) + s +
  HexToStr(sendLoginMessage('into_server_middle')) + s1 +
  HexToStr(sendLoginMessage('into_server_buttom')));
  AThread.Connection.WriteStream(sm);

  iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\user\' + usrNameArr[tTmp] + '.txt');
  iniFile.WriteString('User Data', 'STATUS', ' ON');
  iniFile.Free;
  // Config Player
  if not FileExists(ExtractFileDir(ParamStr(0)) + '\PlayerConfig\' + usrNameArr[tTmp] + '.txt') then Begin
    AssignFile(usrFile2, ExtractFileDir(ParamStr(0)) + '\PlayerConfig\' + usrNameArr[tTmp] + '.txt');Rewrite(usrFile2);
    Writeln(usrFile2, '[CONFIG]');
    Writeln(usrFile2, 'Key_Forward=0');
    Writeln(usrFile2, 'Key_Backward= 0');
    Writeln(usrFile2, 'Key_Left= 0');
    Writeln(usrFile2, 'Key_Right= 0');
    Writeln(usrFile2, 'Key_Walk= 0');
    Writeln(usrFile2, 'Key_Jump= 0');
    Writeln(usrFile2, 'Key_Crouch= 0');
    Writeln(usrFile2, 'Key_DropWep= 0');
    Writeln(usrFile2, 'Key_Reload= 0');
    Writeln(usrFile2, 'Key_Fire= 0');
    Writeln(usrFile2, 'Key_SpecialAttack= 0');
    Writeln(usrFile2, 'Key_PreviousWep= 0');
    Writeln(usrFile2, 'Key_DefuseBomb= 0');
    Writeln(usrFile2, 'Key_SwitchBag= 0');
    Writeln(usrFile2, 'Key_MainWep= 0');
    Writeln(usrFile2, 'Key_SubWep= 0');
    Writeln(usrFile2, 'Key_Melee= 0');
    Writeln(usrFile2, 'Key_ThrownWep= 0');
    Writeln(usrFile2, 'Key_C4= 0');
    Writeln(usrFile2, 'Key_Group1= 0');
    Writeln(usrFile2, 'Key_Group2= 0');
    Writeln(usrFile2, 'Key_Group3= 0');
    Writeln(usrFile2, 'Mouse_Sensitivity= 0');
    Writeln(usrFile2, 'Block_Friend_Invitation= 0');
    Writeln(usrFile2, 'Block_Invitation= 0');
    Writeln(usrFile2, 'Block_Whisper= 0');
    Writeln(usrFile2, 'Invert_Y_Axis= 0');
    Writeln(usrFile2, 'CrossHair_Color= 0');
    Writeln(usrFile2, 'CrossHair_Style= 0');
    Writeln(usrFile2, 'Hand_Pos= 0');
    Writeln(usrFile2, 'Display_Method= 0');
    Writeln(usrFile2, 'Display_Achievement_Title= 0');
    Writeln(usrFile2, 'Macro_1= 0');
    Writeln(usrFile2, 'Macro_2= 0');
    Writeln(usrFile2, 'Macro_3= 0');
    Writeln(usrFile2, 'Macro_4= 0');
    CloseFile(usrFile2);
  end;
  usrLoginArr[nTmp]:= True;
end;

end.
