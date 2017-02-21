unit loginU;

interface

uses
{$IFNDEF FPC} Windows, {$ELSE} LResources, {$ENDIF}
  SysUtils, Variants, Classes, IniFiles, Sockets, Dialogs;

type
  Tsesion = array [0 .. 3] of LongWord;
  TpData = array [0 .. 65336] of Byte;
  TfLogin = array [1 .. 13] of Byte;

  Tpacket = record
    data: TpData;
    size: Word;
    ptype: Word;
  end;

  TLoginPass = record
    login: string;
    password: string;
  end;

  TCryptedLoginPass = record
    login: string;
    password: string;
    FullLofin: TfLogin;
  end;

type
  TLogin = class
    function getWord(data: TpData; pos: Word): Word;
    function getLongWord(data: TpData; pos: Word): LongWord;
    function getByte(data: TpData; pos: Word): Byte;
    function cryptPL(PL: TLoginPass; pluskey, xorkey: Byte): TCryptedLoginPass;
    function formpacket(packet: string): Tpacket;
    function reverseType(packet: string): string;
    function buildsession(pack: Tpacket): Tsesion;
    function makeit(ip: LongWord; port: Word; login: TfLogin; id: LongWord;
      session: Tsesion; srvnum: Byte; ispremium: Byte): string;
    function login(login, password: string): boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Var
  ini: TIniFile;

implementation

Uses Unit1;

function TLogin.getWord(data: TpData; pos: Word): Word;
var
  str: string;
begin
  str := str + IntToHex(data[pos + 1], 2);
  str := str + IntToHex(data[pos], 2);
  Result := StrToInt('$' + str);
end;

function TLogin.getLongWord(data: TpData; pos: Word): LongWord;
var
  str: string;
begin
  str := str + IntToHex(data[pos + 3], 2);
  str := str + IntToHex(data[pos + 2], 2);
  str := str + IntToHex(data[pos + 1], 2);
  str := str + IntToHex(data[pos], 2);
  Result := StrToInt('$' + str);
end;

function TLogin.getByte(data: TpData; pos: Word): Byte;
begin
  Result := StrToInt('$' + IntToHex(data[pos], 2));
end;

function TLogin.cryptPL(PL: TLoginPass; pluskey, xorkey: Byte)
  : TCryptedLoginPass;
const
  maxPasswordLength: Byte = 12;
var
  aByte: Byte;
  i: Byte;
begin
  for i := 1 to maxPasswordLength + 1 do
  begin
    if i <= length(PL.login) then
      aByte := ord(PL.login[i])
    else
      aByte := 0;
    Result.FullLofin[i] := aByte;
    aByte := aByte + pluskey;
    aByte := aByte xor xorkey;
    Result.login := Result.login + IntToHex(aByte, 2);
  end;
  for i := 1 to maxPasswordLength + 1 do
  begin
    if i <= length(PL.password) then
      aByte := ord(PL.password[i])
    else
      aByte := 0;
    aByte := aByte + pluskey;
    aByte := aByte xor xorkey;
    Result.password := Result.password + IntToHex(aByte, 2);
  end;
end;

function TLogin.formpacket(packet: string): Tpacket;
var
  i, j: integer;
begin
  Result.size := round(length(packet) / 2);
  i := 0;
  j := 0;
  while i < length(packet) do
  begin
    Result.data[j] := StrToInt('$' + packet[i + 1] + packet[i + 2]);
    i := i + 2;
    j := j + 1;
  end;
  Result.ptype := StrToInt('$' + IntToHex(Result.data[3], 2) +
    IntToHex(Result.data[2], 2));
end;

function TLogin.reverseType(packet: string): string;
var
  i, j: integer;
begin
  i := length(packet);
  j := 0;
  while i > 0 do
  begin
    Result := Result + packet[i - 1] + packet[i];
    i := i - 2;
    j := j + 1;
  end;
end;

function TLogin.buildsession(pack: Tpacket): Tsesion;
var
  i, j: integer;
begin
  i := 11;
  j := 0;
  while i < pack.size - 1 do
  begin
    Result[j] := StrToInt('$' + IntToHex(pack.data[i + 3], 2) +
      IntToHex(pack.data[i + 2], 2) + IntToHex(pack.data[i + 1], 2) +
      IntToHex(pack.data[i], 2));
    i := i + 4;
    j := j + 1;
  end;
end;

function TLogin.makeit(ip: LongWord; port: Word; login: TfLogin; id: LongWord;
  session: Tsesion; srvnum: Byte; ispremium: Byte): string;
var
  i: Word;
begin
  Result := reverseType(IntToHex(ip xor $CB9C4B3A, 8));
  Result := Result + reverseType(IntToHex(port xor $4FB6, 4));
  for i := 1 to 12 do
    Result := Result + IntToHex(login[i], 2);
  Result := Result + '30';
  Result := Result + reverseType(IntToHex(id xor $6E65E0AF, 2));
  Result := Result + reverseType(IntToHex(session[0] xor $CFCF22E6, 8));
  Result := Result + reverseType(IntToHex(session[1] xor $5BBCDE6F, 8));
  Result := Result + reverseType(IntToHex(session[2] xor $ACDF5EDA, 8));
  Result := Result + reverseType(IntToHex(session[3] xor $BCCD1B37, 8));
  Result := Result + reverseType(IntToHex(srvnum xor $4B3A, 4));
  Result := Result + reverseType(IntToHex(id xor $C89C183A, 8));
  Result := Result + reverseType(IntToHex(ispremium xor $C89C183A, 8));
  Result := Result + '00000000D032';
end;

function TLogin.login(login, password: string): boolean;
var
  i, j: integer;
  data: TpData;
  packetStr: string;
  rpacketStr: string;
  pack: Tpacket;
  isfull: boolean;
  size: Word;
  pluskey: Byte;
  xorkey: Byte;
  PL: TLoginPass;
  plCrypted: TCryptedLoginPass;
  id: integer;
  ispremium: Byte;
  session: Tsesion;
  ipaddres: LongWord;
  port: Word;
  filedata: String;
  tmpfile: TFileStream;
  pi: TProcessInformation;
  si: TStartupInfo;
  tmpPacket: Tpacket;
  Mes1, mes2, mes3: String;
  TCP: TTcpClient;
begin
  TCP := TTcpClient.Create(nil);
  ini := TIniFile.Create(cfg + '\CookieLConfig.ini');
  TCP.WaitForData(50);
  PL.login := login;
  PL.password := password;
  TCP.Disconnect;
  TCP.RemoteHost := '176.36.205.12';
  TCP.RemotePort := '10001';
  TCP.Connect;
  if TCP.Connected then
  begin
    packetStr := '0500150CFF';
    pack := formpacket(packetStr);
    TCP.SendBuf(pack.data, pack.size);
    // Memo1.Lines.Add('Send: '+packetStr);
    TCP.ReceiveBuf(data, 65536);
    size := getWord(data, 0);
    rpacketStr := '';
    for i := 0 to size - 1 do
      rpacketStr := rpacketStr + IntToHex(data[i], 2);
    pack := formpacket(rpacketStr);
    // Memo1.Lines.Add('Recv: '+rpacketStr);
    if pack.ptype = $D15 then
    begin
      pluskey := getWord(pack.data, 4) + 1;
      xorkey := getWord(pack.data, 5) + 3;
      plCrypted := cryptPL(PL, pluskey, xorkey);
      packetStr := '1F001503' + plCrypted.login + plCrypted.password + '00';
      pack := formpacket(packetStr);
      TCP.SendBuf(pack.data, pack.size);
      // Memo1.Lines.Add('Send: '+packetStr);
      TCP.ReceiveBuf(data, 65536);
      size := getWord(data, 0);
      rpacketStr := '';
      for i := 0 to size - 1 do
        rpacketStr := rpacketStr + IntToHex(data[i], 2);
      pack := formpacket(rpacketStr);
      // Memo1.Lines.Add('Recv: '+rpacketStr);
      if pack.ptype = $415 then
      begin
        if pack.data[4] = $00 then
        begin
          // id:=StrToInt('$'+IntToHex(pack.data[8],2)+IntToHex(pack.data[7],2)+IntToHex(pack.data[6],2)+IntToHex(pack.data[5],2));
          id := getLongWord(pack.data, 5);
          ispremium := getLongWord(pack.data, 9);
          packetStr := '0800150500000000';
          pack := formpacket(packetStr);
          TCP.SendBuf(pack.data, pack.size);
          // Memo1.Lines.Add('Send: '+packetStr);
          TCP.ReceiveBuf(data, 65536);
          size := getWord(data, 0);
          rpacketStr := '';
          for i := 0 to size - 1 do
            rpacketStr := rpacketStr + IntToHex(data[i], 2);
          pack := formpacket(rpacketStr);
          // Memo1.Lines.Add('Recv: '+rpacketStr);
          { if pack.ptype=$615 then
            begin
            if pack.data[4]=$00 then
            begin
            size:=StrToInt('$'+IntToHex(data[1],2)+IntToHex(data[0],2));
            size:=size+StrToInt('$'+IntToHex(data[6],2)+IntToHex(data[5],2));
            rpacketStr:='';
            for i := 0 to size-1 do rpacketStr:=rpacketStr+IntToHex(data[i],2);
            pack:=formpacket(rpacketStr);
            end;
            end; }
          packetStr := '060015070000';
          pack := formpacket(packetStr);
          TCP.SendBuf(pack.data, pack.size);
          // Memo1.Lines.Add('Send: '+packetStr);
          TCP.ReceiveBuf(data, 65536);
          size := getWord(data, 0);
          rpacketStr := '';
          for i := 0 to size - 1 do
            rpacketStr := rpacketStr + IntToHex(data[i], 2);
          pack := formpacket(rpacketStr);
          // Memo1.Lines.Add('Recv: '+rpacketStr);
          if pack.ptype = $815 then
          begin
            // ipaddres:=getLongWord(pack.data,5);
            tmpPacket := formpacket('B024CD0C'); // 176.36.205.12
            ipaddres := getLongWord(tmpPacket.data, 0);
            port := getWord(pack.data, 9);
            // Memo1.Lines.Add('Serv: '+IntToHex(ipaddres,2)+':'+IntToHex(port,2));
            session := buildsession(pack);
            for j := 0 to length(session) - 1 do
              // Memo1.Lines.Add('Sesi:  '+inttostr(session[j]));
              filedata := makeit(ipaddres, port, plCrypted.FullLofin, id,
                session, $00, ispremium);
            pack := formpacket(filedata);
            /// ////////////////////////////{ÇÀÏÓÑÊ ÏÐÎÖÅÑÑÀ}/////////////////////////////
            Mes1 := ini.ReadString('Dir', 'RF', ' ');
            mes2 := Mes1 + '\System\DefaultSet.tmp';
            mes3 := Mes1 + '\RF_Online.bin';
            tmpfile := TFileStream.Create(mes2, fmCreate);
            tmpfile.WriteBuffer(pack, pack.size);
            tmpfile.Free;
            if CreateProcess(PChar(mes3), nil, nil, nil, False,
              CREATE_DEFAULT_ERROR_MODE, nil, (PChar(Mes1)), si, pi) then
              Result := True;
          end;
        end
        else
        begin
          ShowMessage('Îøèáêà àâòîðèçàöèè');
        end;
      end;
    end;
    TCP.Disconnect;
    TCP.Destroy;
    ini.Destroy;
  end;
end;

end.
