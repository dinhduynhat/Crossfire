unit GameServerPacket;

interface

uses                                                                     
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math;

procedure vGameServerData(AThread: TIdPeerThread);

implementation

uses Unit1, Methods, PublicVariables, PublicStats, ServerPacket;

type ipType = array[1 .. 4] of Integer;

procedure vGameServerData(AThread: TIdPeerThread);
var i, j, k: Integer;
  a: array[1 .. 400] of Boolean;
  packet, header, sub_header, unk_header: String;
  Len, Fr1, Fr2, Len1, Len2, tTmp, exp, expb, gp, zp, fp, apsend, recvnamed, datanamed, lvl, id, tmp, kill, death,
  victory, defeat, gid, playerid, nTmp, weaponID, indexID, intTmp: Integer;
  sHeader: String;
  Items_Special, Items_Normal, bag, sI: Integer;
  index, itemid, itemsCount: String;
  indexM, itemM: String;
  itemsID: String;
  itemshop, indexop: Integer;
  no, item1, item2, item3: String;
  s, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21,
  s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, source, lStatus, ipStr, name,
  pw, tName, tPw, tNick, tNamed, tClan, tplayerid, expStr, gpStr, zpStr, fpStr, apsendStr,
  recvnamedStr, datanamedStr, HeaderTmp, lvlStr, nnTmp: String;
  sm, sm2: TStringStream;
  ext: Extended;
  idCrate, winnerD, itemWIN, playeR: String;
  t, ff, ff2: Boolean;
  usrFile, usrFile2: TextFile;
  l: TStrings;
  iniFile: TIniFile;
Begin
  ipStr:= AThread.Connection.Socket.Binding.PeerIP;
  tTmp:= getIPHex(ipStr);
  nTmp:= getNickNameHex(nickNameArr[tTmp]);
  //iniFile:= nil;

  sm:= TStringStream.Create('');
  AThread.Connection.ReadStream(sm, 1);      // F1
  AThread.Connection.ReadStream(sm, 2);      // Size
  AThread.Connection.ReadStream(sm, 2);      // Header
  AThread.Connection.ReadStream(sm, 1);      // Sub_header
  
  Len:= StrToInt('$' + StrToHex(sm.DataString[3] + sm.DataString[2])) + 7;

  For i:= 1 to Len - 6 do  // F2
    AThread.Connection.ReadStream(sm, 1);

  packet:= StringReplace(StrToHexCnt(sm, Len), ' ', '', [rfReplaceAll]);
  
  header:= packet[7] + packet[8] + packet[9] + packet[10];
  sub_header:= packet[11] + packet[12];
  unk_header:= packet[13] + packet[14];

  if MainForm.CheckBox1.Checked then begin
    dbg('Hex data:' + StrToHexCnt(sm, Length(sm.DataString)));
    console('<' + ipStr + '> header: 0x' + header + ' sub_header: 0x' + sub_header + ' unk_header: 0x' + unk_header);
    s:= StrToVisibleHex(sm, Len);
    console('<' + ipStr + '> data: ' + s);
  End;

  if (header = '01AB') and (sub_header = '00') then   // F1 04 00 01 AB 00 B7 //
    packet_ping(AThread);

  if header = '0A1B' then      // F1 04 00 0A 1B 01 01 //
    packet_newbiemission_item(AThread, packet);

  if header = '01CD' then      // F1 38 00 01 CD 00 00 //    // NEWBIE MISSION //
    packet_newbiemission(AThread);

  if header = '01F2' then      // F1 08 00 01 F2 00 0C //    // EQUIP ITEM //
    packet_equip_item(AThread);

  if header = '014B' then begin      // F1 08 00 01 4B 00 3C //    // INVITE //
    //Inc(botCount);
    //s1:= '[BOT]BOT' + IntToStr(botCount);
    s1:= '[DEV]CaioTST';
    For i:= 1 to 18 - Length(s1) do s1:= s1 + #0;

    sm:= TStringStream.Create(HexToStr('F1500101560000000000000000000000000000' +
    '0000000000010000000000000000006500000000000000DB0300008601000023000000500' +
    '0000004000000E5EF0300426F74205465616D730000000000000000000000000000000000' +
    '0C00020030000000' + StrToHex(s1) + '01' + '0000000100000001000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000001000000FFFFFFFF0' +
    '1000000180000000100000000000000000000000100000047616D654D6173746572730000' +
    '000000000000000000000000000C0002003000000000000000000000000000F2'));
    AThread.Connection.WriteStream(sm);
  end;

  if (header = '0136') and (sub_header = '00') then begin   // F1 28 00 01 36 00 00 //
    // JOIN ROOM //
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\RoomList.ini');
    s1:= iniFile.ReadString('ROOM1', 'Host', tNick);
    iniFile.Free;
    sm:= TStringStream.Create(HexToStr(sendLoginMessage('room\enterrom\1.txt')) + s1 +
    HexToStr(sendLoginMessage('room\enterrom\2.txt')));
    AThread.Connection.WriteStream(sm);
    // ENTROU UM PLAYER
    {iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\RoomList.ini');
    s1:= nickNameArr[tTmp];
    iniFile.WriteString('ROOM1', 'Player' + IntToStr(intTmp), s1);
    iniFile.Free;      }
    //send('room\enterrom\player.txt', AThread);
  end;

  if (header = '0A01') and (sub_header = '01') then begin   // F1 01 00 0A 01 01 00 //
    if unk_header = '01' then begin     // BACK TO ROOM //
      sm:= TStringStream.Create(HexToStr('f10c000a0102000000002c01000001000000f2'));
      AThread.Connection.WriteStream(sm);
    end;
    if unk_header = '02' then begin     // SHOP //
      sm:= TStringStream.Create(HexToStr('f10c0001a902000000002700000000006400f2'));
      AThread.Connection.WriteStream(sm);
      sm:= TStringStream.Create(HexToStr('f10c000a0102000000002c01000002000000f2'));
      AThread.Connection.WriteStream(sm);
    end;
    if unk_header = '03' then begin     // STORAGE //
      sm:= TStringStream.Create(HexToStr('f10c0001a902000000002600000000006400f2'));
      AThread.Connection.WriteStream(sm);
      sm:= TStringStream.Create(HexToStr('f10c000a0102000000002c01000003000000f2'));
      AThread.Connection.WriteStream(sm);
    end;
    if unk_header = '04' then begin     // BLACKMARKET //
      sm:= TStringStream.Create(HexToStr('f10c000a0102000000002c01000004000000f2'));           
      AThread.Connection.WriteStream(sm);
    end;
    if unk_header = '05' then begin     // POINT SHOP //
      sm:= TStringStream.Create(HexToStr('f10c000a0102000000002c01000005000000f2'));           
      AThread.Connection.WriteStream(sm);
    end;
  end;

  if header = '0134' then begin  // F1 98 00 01 34 00 00 //
    sm:= TStringStream.Create(HexToStr('f10c010135009cffffff' + '00' + '00000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000078000000f2'));
    AThread.Connection.WriteStream(sm);

    //Dec(Channels[playerArr[nTmp, 1]]);
    //connection[nTmp]:= nil;
    //connectionIP[nTmp]:= 0;

    {For i:= 1 to 400 do
      if Channels_player[playerArr[nTmp, 1], i] = nickNameArr[tTmp] then begin
        Channels_player[playerArr[nTmp, 1], i]:= '';
        playerArr[nTmp, 1]:= 0;
        Break;
      end;     }

    For i:= 107 to 107 + 26 * 2 - 1 do s3:= s3 + packet[i];
    For i:= Length(s3) downto 1 do if s3[i] = '0' then Delete(s3, Length(s3), 1) else Break;
    if odd(Length(s3)) then s3:= s3 + '0';

    s1:= HexToStr(s3);              // ROOM NAME //
    s2:= nickNameArr[tTmp];         // ROOM PLAYERNAME //
    s4:= packet[85] + packet[86];   // Objective //
    s5:= packet[93] + packet[94];   // KILLS / TIME //
    s6:= packet[57] + packet[58];   // MAXPLAYER //
    s8:= packet[65] + packet[66];   // MAP //
    s9:= packet[69] + packet[70];   // MODE //
    s10:= IntToVHex(1, 2);          // JOINED PLAYER //
    
    if s9 = '02' then begin    // C.E //
      if s4 = '01' then s7:= 'Kills' else
      if s4 = '02' then s7:= 'Time';
    end else
    if s9 = '0E' then begin
      if s4 = '00' then s7:= 'Round';
    end;

    gConsole(ipStr, Format('Create room [Name: %s] [Host: %s] [Mode: %s] [Map: %s] [Objective: %s] [%s: %s] [MaxPlayer: %s]',
    [s1, s2, s9, s8, s4, s7, IntToStr(HexToInt(s5)), IntToStr(HexToInt(s6))]));
    
    For i:= 1 to 80 - Length(s1) do s1:= s1 + #0;
    For i:= 1 to 14 - Length(s2) do s2:= s2 + #0;

    sHeader:= 'F1D4000152000000000000000101' + s9 + '00000000010000' + s4 + '000000' + s5 + '000000' +
    '0000' + s8 + '00' + s10 + '00' + s6 + '00000000000100000000000000000000000000000000000000000000' +
    '000000000000000000000000000000' + StrToHex(s2) +'020000000000' +
    '00000000' + StrToHex(s1) + '010000000000000000000000000000000000000000' +
    '0000000100FFFF000031000000F2';

    For i:= 1 to 400 do
      if Channels_player[playerArr[nTmp, 1], i] <> '' then begin
        sm:= TStringStream.Create(HexToStr(sHeader));
        connection[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])].Connection.WriteStream(sm);
      end;

    sHeader:= 'f1' + '7400' + '0151' + '00' + '01000000' + IntToVHex(usrLVLArr[tTmp], 8);
    For i:= 1 to 46 do sHeader:= sHeader + '00';
    sHeader:= sHeader + StrToHex(nickNameArr[tTmp]);
    For i:= 1 to 14 - Length(nickNameArr[tTmp]) do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'ffffffffffffffff';
    For i:= 1 to 40 do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'f2';
    
    For i:= 1 to 400 do
      if (Channels_player[playerArr[nTmp, 1], i] <> '') and (Channels_player[playerArr[nTmp, 1], i] <> nickNameArr[tTmp]) then begin
        sm:= TStringStream.Create(HexToStr(sHeader));
        connection[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])].Connection.WriteStream(sm);
      end;
      {// VIPS Count
      sm:= TStringStream.Create(HexToStr('F194000135009CFFFFFF000000000000000000000000' + '01' + '000000' + '4E05' +
      '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
      '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
      '000000000000000000000000000000000000000000000000F2'));
      AThread.Connection.WriteStream(sm);   }
      // BOTS Count
      send('bot\1.txt', AThread);
      send('bot\2.txt', AThread);
      send('bot\3.txt', AThread);
      send('bot\4.txt', AThread);
      // LOG
      iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\RoomList.ini');
      s7:= nickNameArr[tTmp];
      iniFile.WriteString('' + IntToStr(intTmp), 'Host', s7);
      iniFile.Free;
  end;

  if (header = '013E') and (sub_header = '00') and (unk_header = '01') then begin // F1 00 00 01 3E 00 F2 //
    //gConsole(ipStr, Format('Change room: [Room: %s] [Objective: %s] [ObjCount: %s]', ['01']));
  end;

  if header = '0200' then begin // F1 00 00 00 02 00 F2 //
  end;

  if header = '0117' then begin // F1 00 00 01 17 00 F2 //
    gConsole(ipStr, Format('Save Config', ['']));
  end;

  if (header = '0142') and (sub_header = '00') and (unk_header = '80') then begin  // F1 04 00 01 42 00 80 //
    usrStatusArr[tTmp]:= 'MODOBOT';
     { // UDP
      sm:= TStringStream.Create(HexToStr('f1000001a600f2'));
      AThread.Connection.WriteStream(sm);

      s1:= nickNameArr[tTmp];    // Nickname
      For i:= 1 to 13 - Length(s1) do s1:= s1 + #0;
      sm:= TStringStream.Create(HexToStr('f10e00015800' + StrToHex(s1) + '01f2'));
      AThread.Connection.WriteStream(sm);

      // Room
      sm:= TStringStream.Create(HexToStr('f10800014f000000' + '6b' + '0100000000f2'));
      AThread.Connection.WriteStream(sm);

      s2:= IntToVHex(30001, 4);     // PVP SERVER PORT
      s3:= IntToVHex(127, 2);       // PVP SERVER IP
      s3:= s3 + IntToVHex(0, 2);
      s3:= s3 + IntToVHex(0, 2);
      s3:= s3 + IntToVHex(1, 2);
      s4:= unk_header;

      sm:= TStringStream.Create(HexToStr('f11800014400' + s2 + '0000' + s3 + s4 + '00ffffffff00000000000000000000f2'));
      AThread.Connection.WriteStream(sm);

      gConsole(ipStr, 'Start room');        }
  end;

  if header = '0140' then begin  // F1 00 00 01 40 00 F2 //
    send('room\exit.txt', AThread, 2, 'Saiu da Sala');
    usrStatusArr[tTmp]:= 'LOBBY';
    send('channel\name.txt', AThread, 2, 'Voltou para o Canal (name-)');
    send('channel\room_list.txt', AThread, 2, 'Salas no Lobby');
  end;

  if header = '0142' then begin // F1 00 00 01 42 00 F2 //
      // UDP
      sm:= TStringStream.Create(HexToStr('f1000001a600f2'));
      AThread.Connection.WriteStream(sm);

      s1:= nickNameArr[tTmp];    // Nickname
      For i:= 1 to 13 - Length(s1) do s1:= s1 + #0;
      sm:= TStringStream.Create(HexToStr('f10e00015800' + StrToHex(s1) + '01f2'));
      AThread.Connection.WriteStream(sm);

      // Room
      sm:= TStringStream.Create(HexToStr('f10800014f000000' + '6b' + '0100000000f2'));
      AThread.Connection.WriteStream(sm);

      gConsole(ipStr, 'Start room');
      send('pvp\1.txt', AThread);
      send('pvp\2.txt', AThread);
      send('pvp\3.txt', AThread);
      send('pvp\4.txt', AThread);
      send('pvp\5.txt', AThread);
      send('pvp\6.txt', AThread);
      send('pvp\7.txt', AThread);
      send('pvp\8.txt', AThread);
      send('pvp\9.txt', AThread);
      send('pvp\10.txt', AThread);
      send('pvp\13.txt', AThread);
      send('pvp\14.txt', AThread);
      send('pvp\15.txt', AThread);
      send('pvp\16.txt', AThread);
      send('pvp\17.txt', AThread);
      send('pvp\18.txt', AThread);
      send('pvp\19.txt', AThread);
      send('pvp\20.txt', AThread);
      send('pvp\21.txt', AThread);
      send('pvp\22.txt', AThread);
      send('pvp\23.txt', AThread);
      send('pvp\24.txt', AThread);
      send('pvp\25.txt', AThread);
      send('pvp\26.txt', AThread);
      send('pvp\27.txt', AThread);
      send('pvp\28.txt', AThread);
      send('pvp\29.txt', AThread);
      send('pvp\30.txt', AThread);
      send('pvp\31.txt', AThread);
      send('pvp\32.txt', AThread);
      send('pvp\33.txt', AThread);
      send('pvp\34.txt', AThread);
      send('pvp\35.txt', AThread);
      send('pvp\36.txt', AThread);
      //send('pvp\11.txt', AThread);
      //s6:= unk_header;
      sm:= TStringStream.Create(HexToStr('F10800014F000000' + 'C800' + '00000000F2'));
      AThread.Connection.WriteStream(sm);
      sm:= TStringStream.Create(HexToStr('F118000144001B2F0000C63159417800FFFFFFFF00000400000000000000F2'));
      AThread.Connection.WriteStream(sm);

      {send('pvp\24.txt', AThread);
      send('pvp\25.txt', AThread);
      send('pvp\26.txt', AThread);
      send('pvp\27.txt', AThread);
      send('pvp\28.txt', AThread);
      send('pvp\29.txt', AThread);
      send('pvp\30.txt', AThread);
      send('pvp\31.txt', AThread);
      send('pvp\32.txt', AThread);
      send('pvp\33.txt', AThread);
      send('pvp\34.txt', AThread); }
      {send('pvp\35.txt', AThread);
      send('pvp\36.txt', AThread);
      send('pvp\37.txt', AThread);
      send('pvp\38.txt', AThread);
      send('pvp\39.txt', AThread);
      send('pvp\40.txt', AThread);
      send('pvp\41.txt', AThread);
      send('pvp\42.txt', AThread);
      send('pvp\43.txt', AThread);
      send('pvp\44.txt', AThread);
      send('pvp\45.txt', AThread);
      send('pvp\46.txt', AThread);
      send('pvp\47.txt', AThread);
      send('pvp\48.txt', AThread);
      send('pvp\49.txt', AThread);
      send('pvp\50.txt', AThread);
      send('pvp\51.txt', AThread);
      send('pvp\52.txt', AThread);
      send('pvp\53.txt', AThread);
      send('pvp\54.txt', AThread);
      send('pvp\55.txt', AThread);
      send('pvp\56.txt', AThread);
      send('pvp\57.txt', AThread);
      send('pvp\58.txt', AThread);
      send('pvp\59.txt', AThread);
      send('pvp\60.txt', AThread); }
  end;

  if header = '015B' then begin                   // FINISHED ROOM //
    s1:= '999999';      // GP GAINED
    s2:= '777777';      // EXP GAINED
    s3:= '155';         // KILL
    s4:= '45';          // BONUS
    s5:= '555';         // EXP BONUS
    sm:= TStringStream.Create(HexToStr('F1B800015B0007000800000000000000000000000000' + s1 +
    '0000' + s2 + '0000AF9000007A3600000F00000078450000680300005F0200000E000000390000000000000060000000' + s3 +
    '000000010000000000000000000000000000000000000000000000' + s4 +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000013000000' + s5 +
    '000000000000000000000000000000000000000000000000000011000000000000006800000000000000F2'));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '01C9' then begin // F1 00 00 01 C9 00 F2 //
    send('storage\weapons.txt', AThread, 2, 'Armas');
    send('storage\items.txt', AThread, 2, 'Items');
    send('storage\chars.txt', AThread, 2, 'Chars');
    send('storage\crates.txt', AThread, 2, 'Caixas');
    send('storage\bags.txt', AThread, 2, 'Bags');
    send('storage\1.txt', AThread);
  end;

  if header = '011E' then begin  // F1 00 00 01 1E 00 F2 //
    //send('channel\refresh_channel.txt', AThread, 2, 'Refresh Channel');
    send('into_server\header\1\2.txt', AThread);
    sHeader:= 'f1c80001250000';
    For i:= 1 to 10 do begin   // 10 Channels //
      sHeader:= sHeader + '005e01';                  // Channel Header //
      sHeader:= sHeader + IntToVHex(Channels[i], 32);        // Channel Player //
      if i <> 10 then
      sHeader:= sHeader + IntToVHex(i, 2);           // Channel //
    end;
    sHeader:= sHeader + 'f2';
    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '0121' then begin  // F1 00 00 01 21 00 F2 //
    // Channel nickname //
    sHeader:= 'f1' + 'c42b' + '0122' + '00' + IntToVHex(Channels[playerArr[nTmp, 1]], 8);

    For j:= 1 to Channels[playerArr[nTmp, 1]] do begin
      For i:= 1 to 400 do
        if (Channels_player[playerArr[nTmp, 1], i] <> '') and not a[i] then begin
          sHeader:= sHeader + IntToVHex(usrLVLArr[connectionIP[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])]], 8) + '00000000';
          sHeader:= sHeader + '2b09';            // UNKNOWN DATA //
          sHeader:= sHeader + '0000';     
          sHeader:= sHeader + IntToVHex(usrGIDArr[connectionIP[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])]], 8);        // User GID //
          For k:= 1 to 34 do sHeader:= sHeader + '00';
          sHeader:= sHeader + StrToHex(nickNameArr[connectionIP[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])]]);
          For k:= 1 to 14 - Length(nickNameArr[connectionIP[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])]]) do sHeader:= sHeader + '00';
          sHeader:= sHeader + 'ffffffffffffffff';
          For k:= 1 to 40 do sHeader:= sHeader + '00';
          a[i]:= True;
          Break;
        end;
    end;
    For i:= 1 to 11210 - Length(sHeader) div 2 do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'f2';

    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
    sm:= TStringStream.Create(HexToStr('f1' + '0000' + '0127' + '00' + 'f2'));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '01C8' then begin // F1 00 00 01 C9 00 F2 //
    send('into_server\header\1\3.txt', AThread);
  end;

  if header = '0132' then begin  // F1 00 00 01 32 00 F2 //
    // A player join channel //
    sHeader:= 'f1' + '7400' + '0151';
    For i:= 1 to 55 do sHeader:= sHeader + '00';
    sHeader:= sHeader + StrToHex(nickNameArr[tTmp]);
    For i:= 1 to 14 - Length(nickNameArr[tTmp]) do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'ffffffffffffffff';
    For i:= 1 to 40 do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'f2';

    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);

    send('channel\room_list.txt', AThread, 2, 'join channel (roomlist)');
    // Sistema de Comparecimento
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\User\' + usrNameArr[tTmp] + '.txt');
    atte:= iniFile.ReadString('User Data', 'ATTENDANCE', '1');
    if atte = '7' then iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Config\Attendance.cfg');
    s1:= iniFile.ReadString('Attendance', 'Item1', item1);
    s2:= iniFile.ReadString('Attendance', 'Item2', item1);
    s3:= iniFile.ReadString('Attendance', 'Item3', item1);
    s4:= iniFile.ReadString('Attendance', 'Item3', item1);
    s5:= iniFile.ReadString('Attendance', 'Item3', item1);
    s6:= iniFile.ReadString('Attendance', 'Item3', item1);
    s7:= iniFile.ReadString('Attendance', 'Item3', item1);
    s8:= iniFile.ReadString('Attendance', 'Item3', item1);
    iniFile.Free;

    For i:= 1 to MAXCount do
      if (connection[i] <> nil) and (atte <> '1') then begin

    sm:= TStringStream.Create(HexToStr('F1FD030A1A0300DF070C00040003000D001A000900C20300070000000100' +
    '00000000000000000000000000000000000000000000000000000000000000000B000000DF070C0005000400' +
    '0000000000000000' + StrToHex(s1) + '0001000000DF070C00060005000000000000000000' + StrToHex(s2) + '0001000000DF070C000000060000000000' +
    '00000000' + StrToHex(s3) + '0001000000DF070C0006000C000000000000000000' + StrToHex(s4) + '0000000000DF070C0000000D000000000000000000'
    + StrToHex(s5) + '0000000000DF070C00060013000000000000000000' + StrToHex(s6) + '0000000000DF070C0000001400000000000000000039303030' +
    '3035383630310000000000DF070C00040018000000000000000000' + StrToHex(s7) + '0001000000DF070C000500190000000000000000003930303030353838' +
    '30310001000000DF070C0006001A000000000000000000' + StrToHex(s8) + '0001000000DF070C0000001B000000000000000000393030303035383630310001' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000F2'));
    connection[i].Connection.WriteStream(sm);
      //
      //send('up\1.txt', AThread);
      //send('up\2.txt', AThread);
      send('up\3.txt', AThread, 2, 'up');
      //send('up\4.txt', AThread);
      //send('up\5.txt', AThread);
  end;
end;

  if header = '0123' then begin // F1 00 00 01 23 00 F2 //   // EXIT CHANNEL //
    send('channel\return_channel\1.txt', AThread, 2, 'exit channel ');

    Dec(Channels[playerArr[nTmp, 1]]);
    sHeader:= 'f1cc000124000000000000';
    For i:= 1 to 10 do begin   // 10 Channels //
      sHeader:= sHeader + '002c01';                       // Channel Header //
      sHeader:= sHeader + IntToVHex(Channels[i], 32);     // Channel Player //
      if i <> 10 then
      sHeader:= sHeader + IntToVHex(i, 2);                // Channel //
    end;
    sHeader:= sHeader + 'f2';
    sm:= TStringStream.Create(HexToStr(sHeader));
    AThread.Connection.WriteStream(sm);
    send('channel\return_channel\3.txt', AThread);
    send('channel\return_channel\4.txt', AThread);
    connection[nTmp]:= nil;
    connectionIP[nTmp]:= 0;

    For i:= 1 to 400 do
      if Channels_player[playerArr[nTmp, 1], i] = nickNameArr[tTmp] then begin
        Channels_player[playerArr[nTmp, 1], i]:= '';
        playerArr[nTmp, 1]:= 0;
        Break;
      end;

    sHeader:= 'f1' + '7400' + '0151' + '00' + '01000000' + IntToVHex(usrLVLArr[tTmp], 8);
    For i:= 1 to 46 do sHeader:= sHeader + '00';
    sHeader:= sHeader + StrToHex(nickNameArr[tTmp]);
    For i:= 1 to 14 - Length(nickNameArr[tTmp]) do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'ffffffffffffffff';
    For i:= 1 to 40 do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'f2';
    
    For i:= 1 to 400 do
      if Channels_player[playerArr[nTmp, 1], i] <> '' then begin
        sm:= TStringStream.Create(HexToStr(sHeader));
        connection[getNickNameHex(Channels_player[playerArr[nTmp, 1], i])].Connection.WriteStream(sm);
      end;
  end;

  if header = 'BF03' then begin // F1 00 00 BF 03 00 00 F2 //
    send('into_server\header\1\4.txt', AThread);
  end;

  if header = '01CF' then begin // F1 00 00 01 CF 00 F2 //
    send('character\use.txt', AThread);
    send('character\use1.txt', AThread);
  end;

  if header = '01AC' then begin
    sm:= TStringStream.Create(HexToStr('F1 04 00 01 AC 00 34 00 A2 01 F2'));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '0138' then begin
    sm:= TStringStream.Create(HexToStr('F1040001380001000500F2'));
    AThread.Connection.WriteStream(sm);
    sm:= TStringStream.Create(HexToStr('F108000139000000000001000500F2'));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '011F' then begin  // F1 18 00 01 1F 00 00 //   // JOIN CHANNEL //
    s1:= unk_header;
    sm:= TStringStream.Create(HexToStr('F1080001200000000000' + s1 + '000000F2'));
    AThread.Connection.WriteStream(sm);
    sHeader:= 'f1' + '7400' + '0151' + '00' + '00000000' + IntToVHex(usrLVLArr[tTmp], 8);
    For i:= 1 to 46 do sHeader:= sHeader + '00';
    sHeader:= sHeader + StrToHex(nickNameArr[tTmp]);
    For i:= 1 to 14 - Length(nickNameArr[tTmp]) do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'ffffffffffffffff';
    For i:= 1 to 40 do sHeader:= sHeader + '00';
    sHeader:= sHeader + 'f2';
    
    For i:= 1 to 400 do
      if Channels_player[StrToInt(s1) + 1, i] <> '' then begin
        sm:= TStringStream.Create(HexToStr(sHeader));
        connection[getNickNameHex(Channels_player[StrToInt(s1) + 1, i])].Connection.WriteStream(sm);
      end;
    connection[nTmp]:= AThread;
    connectionIP[nTmp]:= tTmp;
    For i:= 1 to 400 do
      if Channels_player[StrToInt(s1) + 1, i] = '' then begin
        Channels_player[StrToInt(s1) + 1, i]:= nickNameArr[tTmp];
        playerArr[nTmp, 1]:= StrToInt(s1) + 1;  // Join ??? Channel , Save //
        Break;
      end;
    Inc(Channels[StrToInt(s1) + 1]);
  end;

  if header = 'BF01' then begin  // F1 00 00 BF 01 9A F2 //
    send('server\2.txt', AThread);
    send('server\3.txt', AThread);
    send('server\4.txt', AThread);
    send('server\5.txt', AThread);
    send('server\6.txt', AThread);

   { iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Buddy\' + tName + '.ini');
    s1:= iniFile.ReadString('LIST', 'FriendCount', s1);
    s2:= iniFile.ReadString('FRIEND1', 'Name', s2);
    iniFile.Free;

    sm:= TStringStream.Create(HexToStr(''));
    AThread.Connection.WriteStream(sm);  }

    gConsole(ipStr, 'BuddyServer Desconnected!');
  end;

  if header = '01BB' then  // F1 00 00 01 BB 00 F2 //
    packet_coupons(AThread);

  if header = '01B4' then  // F1 00 00 01 B4 00 F2 //
    packet_black_market(AThread);

  if header = '0184' then begin // F1 00 00 01 84 00 00 F2 //
    sm:= TStringStream.Create(HexToStr('f10700c0012d5cfd5b06fffffff2'));
  end;

  if header = '017A' then begin // F1 04 00 01 0A 00 01 //
    sm:= TStringStream.Create(HexToStr('F10800017A007952000000000000F2'));
    AThread.Connection.WriteStream(sm);
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\storage\' + usrNameArr[tTmp] + '.txt');
    s1:= iniFile.ReadString('ITEM' + IntToStr(weaponID), 'Repair', '0');
    iniFile.Free;
    sm:= TStringStream.Create(HexToStr('F12000017B0000000000000000007952000000000000' +
    '6400000000000000' + s1 + '00000000000000F2'));
  end;

  if header = '010A' then begin // F1 04 00 01 0A 00 01 //
    send('back_to_serverlist.txt', AThread);
  end;

  if header = '01B6' then begin // F1 00 00 01 B6 00 F2 //
    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Spin.cfg');
    //s1:= iniFile.ReadString('INDEX', 'ITEM1' , itemid);
    iniFile.Free;
    s1:= '2010054901.3000000601.9000003301.2010006501.2010006801';

    sm:= TStringStream.Create(HexToStr('F1100001F1009BD40300000000000900000000000000F2F1B00201B700000000000300000042000000840000009100000000000000' + StrToHex(s1) +
    '000000000000000000000000' + '9F8601009F8601009F8601' + '000000000000000000D1DD0000000000007F50000000000000D6DD00000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' +
    '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000001000000000000001600000000000000F2'));
    AThread.Connection.WriteStream(sm);
  end;

  if header = '01D7' then begin // F1 00 00 01 D7 00 F2 //
    send('channel\data\1.txt', AThread);
    send('channel\data\2.txt', AThread);
    send('channel\data\3.txt', AThread);
  end;

  if header = '011A' then begin // F1 00 00 01 1A 00 F2 //
  end;

  if header = '017E' then begin // F1 00 00 01 7E 00 F2 //
    send('storage\resell\resell.txt', AThread, 2, 'Vendeu uma Arma');
    // resell
  end;

  if header = '01D3' then begin  // F1 00 00 01 D3 00 F2 //
    if usrStatusArr[tTmp] = 'LOGIN' then begin
      send('character\1.txt', AThread);
      send('character\2.txt', AThread);
      send('character\3.txt', AThread);
      send('character\4.txt', AThread);
      send('character\5.txt', AThread);
      send('character\6.txt', AThread);
      send('character\7.txt', AThread);
      send('character\8.txt', AThread);
      // send('into_server\5.txt', AThread);
      // send('into_server\6.txt', AThread);
      // send('into_server\10.txt', AThread);
      //send('into_server\9.txt', AThread, 2, 'into_server 6');
    end;
  end;

  if header = '0A1C' then  // F1 0D 00 0A 1C 01 0B //
    packet_player_info(AThread, sub_header);

  if header = '015D' then begin // F1 00 00 01 5D 00 F2 //
    send('profile\profile.txt', AThread);
    send('profile\player.txt', AThread);
  end;

  if header = '0A03' then begin // F1 00 00 01 BC 00 F2 //
    {iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\BlackMarket\Winners.cfg');
    intTmp:= 1;
    While iniFile.ReadString('TAB' + IntToStr(intTmp), 'Crate', '') <> '' do
    begin
      s1:= iniFile.ReadString('TAB' + IntToStr(intTmp), 'Crate', index);
      s2:= iniFile.ReadString('TAB' + IntToStr(intTmp), 'ItemWin', itemid);
      s3:= iniFile.ReadString('TAB' + IntToStr(intTmp), 'PlayerName', itemid);
      s4:= iniFile.ReadString('TAB' + IntToStr(intTmp), 'WinnersDisplay', index);
      sm:= TStringStream.Create(HexToStr('F124000A030200000000' + '01' +
      '00000001000000' + StrToHex(s2) + '00' + StrToHex(s3) + '0000000000F2'));
      AThread.Connection.WriteStream(sm);
      Inc(intTmp);
    end;
    iniFile.Free;
    gConsole(ipStr, 'Winners');  }
  end;

  if header = '1001' then
    packet_clan(AThread, packet, unk_header);
              
  if header = '0A0C' then begin // F1 01 00 0A 0C 00 0E F2 //
    send('F1 01 00 0A 0C 00 0E F2', AThread);
  end;

  if header = '0116' then begin // F1 01 00 01 16 00 0E F2 //
    {iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\Ranking\Rank.txt');
    intTmp:= 1;
    while iniFile.ReadString('PLAYER' + IntToStr(intTmp), 'Soldier', '') <> '' do
    begin
      s1:= iniFile.ReadString('PLAYER' + IntToStr(intTmp), 'Soldier', name);
      s2:= iniFile.ReadString('PLAYER' + IntToStr(intTmp), 'Wins', index);
      s3:= iniFile.ReadString('PLAYER' + IntToStr(intTmp), 'Losses', index);
      // + StrToHex(s1) +
      send('rank\1.txt', AThread);
      sm:= TStringStream.Create(HexToStr('F16B0D0116170000000000000000000000000000000000000000000000000000000000000000000000' + StrToHex(s1) +
      '004C2E00' + 'E500' + '000055000000' + '3A01' + '000017010000000B0A0000'));
      AThread.Connection.WriteStream(sm);
      //send('rank\1_2.txt', AThread);
      send('rank\2.txt', AThread);
      send('rank\3.txt', AThread);
      send('rank\4.txt', AThread);
    Inc(intTmp);
    iniFile.Free;
    end;   }
  end;

  if (header = '0182') and (sub_header = '82') then begin // F1 01 00 01 82 00 00 F2 //
    if unk_header = '82' then begin
      send('F1 08 00 01 82 00 F1 DB 00 00 00 00 00 00 F2', AThread);
      send('F1 08 00 01 83 00 00 00 00 00 64 00 00 00 F2', AThread);
    end;
  end;

  if (header = '01A9') and (sub_header = '01') then begin // F1 00 00 01 A9 01 F2 //
    if usrStatusArr[tTmp] = 'LOGIN' then begin
      usrStatusArr[tTmp]:= 'LOBBY';
      send('server\1.txt', AThread);
      send('heart\1.txt', AThread);
      send('heart\2.txt', AThread);
      send('heart\3.txt', AThread);
      send('heart\4.txt', AThread);
      send('heart\5.txt', AThread);
      send('heart\6.txt', AThread);
      send('heart\7.txt', AThread);
      send('heart\8.txt', AThread);
    end
    else if usrStatusArr[tTmp] = 'LOBBY' then begin
      send('server\shop-storage.txt', AThread, 2, 'Unknown header');
    end
    else if usrStatusArr[tTmp] = 'MODOBOT' then begin
      send('modo-bot.txt', AThread);
    end;
  end;

  if header = '0A1A' then begin
    send('into_server\3.txt', AThread, 2, 'into_server 3');
    {// RECV WEAPON
    s1:= '';
    sm:= TStringStream.Create(HexToStr('f1' + s2 + 'f2'));
    AThread.Connection.WriteStream(sm);

    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\config\ItemsList.cfg');
    s1:= iniFile.ReadString(IntToStr(intTmp), 'StorageID', 'C0001');
    s2:= iniFile.ReadString(IntToStr(intTmp), 'Name', HexToStr(s));
    iniFile.Free;

    iniFile:= TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\storage\' + usrNameArr[tTmp] + '.txt');
    s3:= iniFile.ReadString('Global', 'ItemCount', '0');
    intTmp:= StrToInt(s3);
    Inc(intTmp);
    iniFile.WriteString('Global', 'ItemCount', IntToStr(intTmp));
    iniFile.WriteString('ITEM' + IntToStr(intTmp), 'StorageID', s1);
    iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Repair', '100');
    iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Days', '29');
    iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Hours', '23');
    iniFile.WriteString('ITEM' + IntToStr(intTmp), 'Minutes', '59');
    iniFile.Free;
    gConsole(ipStr, Format('RECV Weapon: [%s]', [s5]));      }
  end;

  if header = '0A00' then  // F1 00 00 0A 00 00 F2 //
    packet_unk_header_01(AThread);

  if header = '0180' then  //  F1 00 00 01 80 00 F2 //
    packet_refresh_zp(AThread);

  if header = '013C' then  // F1 00 00 01 3C 00 F2 //
    packet_change_team(AThread, unk_header);

  if header = '01BD' then  // F1 00 00 01 BD 00 F2 //
    packet_exchange_item(AThread, packet);

  if header = '0178' then  // F1 90 00 01 78 00 01 //
    packet_bought_item(AThread, packet);

  if header = '0100' then  // F1 60 01 01 00 00 //
    packet_connect_data(AThread);

  if header = '0015' then  // F1 00 00 00 15 00 F2 //
    packet_profile(AThread);

  if header = '0002' then  // F1 68 02 00 02 00 CF //
    packet_server_list(AThread);

  if header = '0105' then  // F1 00 00 01 05 00 F2 //
    packet_back_to_server(AThread, sm, Len);

  if header = '015C' then  // F1 02 00 00 0F 00 01 F2 //
    packet_game_player_data(AThread);
  
  sm.Free;
end;

end.


