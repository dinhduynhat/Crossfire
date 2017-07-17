unit Methods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles;

type
  TIPList=Array of String;

function StrToHex(AStr: string): string;
function StrToHexCnt(sm: TStringStream; Len: Integer): string;
function StrToVisibleHex(sm: TStringStream; Len: Integer): string;
procedure dbg(Str: String);
procedure lConsole(ipStr, msg: string);
procedure gConsole(ipStr, msg: string);
procedure send(sendMsg: string; AThread: TIdPeerThread; tDbg: Integer = 0; msg: string = '');
function getIPHex(ipStr: String): Integer;
procedure console(str: String);
function sendLoginMessage(status: String): AnsiString;
function HexToInt(hex: AnsiString): integer;
function HexToStr(str: AnsiString): AnsiString;
function IntToVHex(number: Integer; digits: Integer): string;
function getNicknameHex(nickName: String): Integer;
procedure pvpConsole(ipStr, msg: String);
function GetLocalName():String;
function ComputerIP(ComputerName:String):String;
Function GetLocalIp(InternetIP:boolean):String;
function getMacAddr: String;
function getIP: TIPList;
function getLen(s: String): Integer;

//---------------------------------------------------------------------------------------------------------//
//                                        Packet Methods                                                   //
//---------------------------------------------------------------------------------------------------------//
procedure writeC(data: Integer; len: Integer);         // Custom Digits //                 // Int //
procedure writeH(data: Integer);                       // 4 Digits //                      // Int //
procedure writeD(data: Int64);                         // 8 Digits //                      // Int //
procedure writeI(data: Integer);                       // 2 Digits //                 // ShortInt //
procedure writeS(data: string; len: Integer);          // Custom Digits //              // String //
procedure sendPacket(AThread: TIdPeerThread);          // Send packet //
procedure createPacket(header: string);                // Create packet //
procedure finishPacket;                                // Finish packet //
function getPacket: String;                            // Get Packet //
function getHeader: String;                            // Get Header //
//---------------------------------------------------------------------------------------------------------//

implementation

uses Unit1;

var _packet, _header: String;

function getPacket: String;
begin
  Result:= _packet;
end;

function getHeader: String;
begin
  Result:= _header;
end;

procedure finishPacket;
begin
  _packet:= 'f1' + IntToVHex(Length(_packet) div 2, 4) + _header + _packet + 'f2';
end;

function getLen(s: String): Integer;
begin
  Result:= Length(s) + 2;
end;

procedure createPacket(header: string);
begin
  _packet:= '';
  _header:= header;
end;

procedure sendPacket(AThread: TIdPeerThread);
var sm: TStringStream;
begin
  finishPacket;
  sm:= TStringStream.Create(HexToStr(_packet));
  AThread.Connection.WriteStream(sm);
end;

procedure writeS(data: string; len: Integer);
var i: Integer;
begin
  _packet:= _packet + StrToHex(data);
  For i:= 1 to len - Length(data) do _packet:= _packet + '00';
end;

procedure writeI(data: Integer);
begin
  _packet:= _packet + IntToVHex(data, 2);
end;


procedure writeD(data: Int64);
begin
  _packet:= _packet + IntToVHex(data, 8);
end;

procedure writeH(data: Integer);
begin
  _packet:= _packet + IntToVHex(data, 4);
end;

procedure writeC(data: Integer; len: Integer);
begin
  _packet:= _packet + IntToVHex(data, len);
end;

function GetLocalName():String;
   var
   CNameBuffer    :    PChar;
   CLen    :    ^DWord;
begin
   GetMem(CNameBuffer,255);
   New(CLen);
   CLen^:=    255;
   if GetComputerName(CNameBuffer,CLen^) then
     result:=CNameBuffer
   else
     result:='';
   FreeMem(CNameBuffer,255);
   Dispose(CLen);
end;

function ComputerIP(ComputerName:String):String;
var phe:pHostEnt;
     w:TWSAData;
     ip_address:longint;
     p:^longint;
     ipstr:string;
begin
if WSAStartup(2,w)<>0 then exit;
phe:=gethostbyname(pchar(ComputerName));
if phe<>nil then
   begin
    p:=pointer(phe^.h_addr_list^);
    ip_address:=p^;
    ip_address:=ntohl(ip_address);
    ipstr:=IntToStr(ip_address shr 24)+'.'+IntToStr((ip_address shr 16) and $ff)
     +'.'+IntToStr((ip_address shr 8) and $ff)+'.'+IntToStr(ip_address and $ff);
    Result :=ipstr;
   end;
end;

function getIP: TIPList;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
const
  BufferSize=64;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : PAnsiChar;
  I : Integer;
  GInitData : TWSADATA;
begin
  WSAStartup($101, GInitData);
  getMem(Buffer,BufferSize);
  GetHostName(Buffer, BufferSize);
  phe :=GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
     Inc(I);
  end;
  setLength(result,I);
  for I := low(result) to high(result) do
    result[i]:=StrPas(inet_ntoa(pptr^[I]^));
  freeMem(Buffer);
  WSACleanup;
end;

Function SendARP(DestIP:in_addr;
                  srcIP:in_addr;
                  pMacAddr:pointer;
                  PhyAddrLen:pointer):DWord; StdCall; External 'Iphlpapi.dll';
 
function getMacAddr: String;
var
  ipList:TIPList;
  ipLong:LongInt;
  ipD,ipS:in_addr;
  Mac:Array[0..5]of Byte;
  //MacLen:integer;
  //Error:Integer;
  I:Integer;
  Line:String;
begin
  ipList:=getIP;
  //MacLen:=length(Mac);
  Result:= '| ';
  for I := low(ipList) to high(ipList) do
  begin
    ipLong:=inet_addr(PAnsiChar(AnsiString(ipList[I])));
    ipD.S_addr:=ipLong;
    ipS.S_addr:=0;
    //Error:=SendARP(ipD,ipS,@Mac,@MacLen);
    Line:=ipList[i]+' >> '+
        format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x',
          [mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]]);
    Result:= Result + Line + ' | ';
  end;
end;

Function GetLocalIp(InternetIP:boolean):String;
   type
     TaPInAddr = Array[0..10] of PInAddr;
     PaPInAddr = ^TaPInAddr;
   var
     phe: PHostEnt;
     pptr: PaPInAddr;
     Buffer: Array[0..63] of Char;
     I: Integer;
     GInitData: TWSAData;
     IP: String;
begin
     Screen.Cursor := crHourGlass;
     try
       WSAStartup($101, GInitData);
       IP:='0.0.0.0';
       GetHostName(Buffer, SizeOf(Buffer));
       phe := GetHostByName(buffer);
       if phe = nil then
       begin
         ShowMessage(IP);
         Result:=IP;
         Exit;
       end;
       pPtr := PaPInAddr(phe^.h_addr_list);
       if InternetIP then
         begin
           I := 0;
           while pPtr^[I] <> nil do
             begin
               IP := inet_ntoa(pptr^[I]^);
               Inc(I);
             end;
         end
       else
         IP := inet_ntoa(pptr^[0]^);
       WSACleanup;
       Result:=IP;//????????ip?????ip
     finally
       Screen.Cursor := crDefault;
     end;
end;

procedure pvpConsole(ipStr, msg: String);
begin
  console('[PVPServer]' + ' <' + ipStr + '>' + ' (' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now()) + ') ' + msg);
end;

function getNicknameHex(nickName: String): Integer;
var i: Integer;
begin
  Result:= 0;
  For i:= 1 to Length(nickName) do
    Inc(Result, Ord(nickName[i]));
end;

function StrToHex(AStr: string): string;
var
  i: Integer;
  ch:char;
begin
  Result:= '';
  for i:=1 to length(AStr)  do
  begin
    ch:= AStr[i];
    Result:= Result + SysUtils.IntToHex(Ord(ch),2);
  end;
end;

function StrToVisibleHex(sm: TStringStream; Len: Integer): string;
var i: Integer;
begin
  Result:= '';
  For i:= 1 to Len do
  Begin
    if (ord(sm.DataString[i]) < 32) or (ord(sm.DataString[i]) > 126) then
      Result:= Result + '.' else
      Result:= Result + sm.DataString[i];
  End;                       
end;

function StrToHexCnt(sm: TStringStream; Len: Integer): string;
var i: Integer;
  f: Boolean;
begin
  Result:= '';
  f:= False;
  for i:= 1 to Len do
    if not f then
    Begin
      Result:= Result + StrToHex(sm.DataString[i]);
      f:= True;
    end else
      Result:= Result + ' ' + StrToHex(sm.DataString[i]);
end;

procedure dbg(Str: String);
Begin
  MainForm.Memo3.Lines.Add(Str);
end;

procedure lConsole(ipStr, msg: string);
Begin
  console('[LoginServer]' + ' <' + ipStr + '>' + ' (' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now()) + ') ' + msg);
end;

procedure gConsole(ipStr, msg: string);
Begin
  console('[GameServer]' + ' <' + ipStr + '>' + ' (' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now()) + ') ' + msg);
end;

procedure send(sendMsg: string; AThread: TIdPeerThread; tDbg: Integer = 0; msg: string = '');
var sm: TStringStream;
Begin
  if tDbg = 1 then lConsole(AThread.Connection.Socket.Binding.PeerIP, msg) else
  if tDbg = 2 then gConsole(AThread.Connection.Socket.Binding.PeerIP, msg);
  sm:= TStringStream.Create(HexToStr(sendLoginMessage(sendMsg)));
  AThread.Connection.WriteStream(sm);
  sm.Free;
end;

function getIPHex(ipStr: String): Integer;
var ttTmp: String;
  i: Integer;
begin
  Result:= 0;
  ttTmp:= StringReplace(ipStr, '.', '', [rfReplaceAll]);
  For i:= 1 to Length(ttTmp) do
    Inc(Result, Ord(ttTmp[i]));
end;

procedure console(str: String);
begin
  MainForm.Memo1.Lines.Add(str);
end;

// message //
Function sendLoginMessage(status: String): AnsiString;
var
  packet, packetfile: TextFile;
  name, pkt, pktf: AnsiString;
Begin
  if Pos('.', status) <> 0 then
  begin
    AssignFile(packetFile, ExtractFileDir(ParamStr(0)) + '\packet\' + status);Reset(packetFile);
    Readln(packetFile, pktf);
    CloseFile(packetFile);
  end Else
  Begin
    AssignFile(packet, 'packet.txt');Reset(packet);
    While not Eof(packet) do
    Begin
      Readln(packet, name);
      pkt:= Copy(name, pos(' ', name) + 1, length(name));
      Delete(name, pos(' ', name), length(name));
      if name = status then
      begin
        AssignFile(packetfile, ExtractFileDir(ParamStr(0)) + '\' + pkt);Reset(packetfile);
        Readln(packetFile, pktf);
        CloseFile(packetfile);
        Break;
      end;
    End;                        
    CloseFile(packet);
  End;

  Result:= pktf;
End;

function HexToInt(hex: AnsiString): integer;
  var
    i: integer;
    function Ncf(num, f: integer): integer;
    var
      i: integer;
    begin
      Result := 1;
      if f = 0 then exit;
      for i := 1 to f do
        result := result * num;
    end;
function HexCharToInt(HexToken: char): integer;
    begin
      if HexToken > #97 then
        HexToken := Chr(Ord(HexToken) - 32);
      Result := 0;
      if (HexToken > #47) and (HexToken < #58) then { chars 0....9 }
        Result := Ord(HexToken) - 48
      else if (HexToken > #64) and (HexToken < #71) then { chars A....F }
        Result := Ord(HexToken) - 65 + 10;
    end;
 begin
    result := 0;
    hex := ansiuppercase(trim(hex));
    if hex = '' then
      exit;
    for i := 1 to length(hex) do
      result := result + HexCharToInt(hex[i]) * ncf(16, length(hex) - i);
  end;

function HexToStr(str: AnsiString): AnsiString;
var
  s, t: AnsiString;
  i, j, k: integer;
begin
  {$HINTS OFF}
  str:= StringReplace(str, ' ', '', [rfReplaceAll]);
  s := '';
  i := 1;
  while i < length(str) do begin
    t := str[i] + str[i + 1];
    k:= hextoint(t);
    if k = 0 then begin s:= s + #0; inc(i, 2); Continue; End;
    //if k < 21 then k:= 46;
    //if k > 126 then k:= 46;
    s := s + chr(k);
    i := i + 2;
  end;
  result := s;
end;

function IntToVHex(number: Integer; digits: Integer): string;
var s: string;
  i, num: Integer;
begin
  Result:= '';
  num:= 0;
  s:= IntToHex(number, 2);
  if length(s) mod 2 <> 0 then s:= '0' + s;
  for i:= Length(s) downto 1 do
  begin
    Inc(num);
    if num mod 2 = 0 then
      Result:= Result + Copy(s, Length(s) - num + 1, 2);
  end;
  For i:= 1 to digits - Length(Result) do Result:= Result + '0';
end;

end.
