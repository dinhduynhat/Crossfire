unit PublicStats;

interface

procedure checkStatus(ipStr: String);

implementation

uses Unit1, Methods, PublicVariables;

procedure checkStatus(ipStr: String);
Begin
  // 0: Unknown error
  // 1: Invalid name/password
  // 2: Login
  if loginStatus = 1 then
    console('[LoginServer]' + ' <' + ipStr + '>' + ' ' + 'connection:invalid name/password');
  if loginStatus = 2 then
    console('[LoginServer]' + ' <' + ipStr + '>' + ' ' + 'connection:login');
End;

end.
