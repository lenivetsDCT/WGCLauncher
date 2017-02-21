unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Sockets;

type
  TStatus = class(tthread)
  private
    IP, Port: String;
  protected
    procedure execute; override;
  public
    property IPs: string read IP write IP;
    property Ports: string read Port write Port;
  end;

implementation

Uses Unit1;

procedure TStatus.execute;
Var
  TCP: TTcpClient;
begin
  TCP := TTcpClient.Create(nil);
  TCP.WaitForData(100);
  TCP.RemoteHost := IP;
  TCP.RemotePort := Port;
  TCP.Connect;
  if TCP.Connected = False then
    case StrToInt(Port) of
      27780:
        statrf := False;
      25565:
        statmc := False;
      27010:
        statcs := False;
    end
  else
    case StrToInt(Port) of
      27780:
        statrf := True;
      25565:
        statmc := True;
      27010:
        statcs := True;
    end;
  TCP.Disconnect;
  TCP.Destroy;
end;

end.
