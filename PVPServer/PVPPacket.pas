unit PVPPacket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer, XPMan, WinSock,
  ExtCtrls, IniFiles, Math, IdSocketHandle;

procedure vPVPData(AData: TStream; ABinding: TIdSocketHandle);

implementation

uses Unit1, Methods, PublicVariables;

procedure vPVPData(AData: TStream; ABinding: TIdSocketHandle);
var
  sm: TStringStream;
  packet, ipStr: String;
begin
  ipStr:= ABinding.PeerIP;

  sm:= TStringStream.Create('');
  try
    sm.CopyFrom(AData, AData.Size);

    packet:= StringReplace(LowerCase(StrToHexCnt(sm, Length(sm.DataString))), ' ', '', [rfReplaceAll]);
    pvpConsole(ipStr, 'data: ' + packet);

    //Inc(pvpTmp);
    {if pvpTmp div 90 <> 0 then
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\' + IntToStr(pvpTmp+1 mod 90) + '.txt'))) else
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\' + IntToStr(pvpTmp) + '.txt')));
           }
    {if packet = 'c7d919990200000000000000000000000000000000007d0000' then begin // Spawn Point //
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\1.txt')));
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\2.txt')));
    end;
    if packet = '91050000' then begin
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\1.txt')));
      MainForm.PVPServer.Send(ABinding.PeerIP, ABinding.PeerPort, HexToStr(sendLoginMessage('pvp_new\2.txt')));
    end; }
  finally
    sm.Free;
  end;
end;

end.
