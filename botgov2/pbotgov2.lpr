{
 pbotgov2.lpr -- demo of internet's bot

  Copyright (C) 2013 Leonardo Valdes Arteaga (eolandro)

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  Leonardo Valdes Arteaga leonardo.valdes@eolansoft.net

}

program pbotgov2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,
  fphttpclient,fpjson,jsonparser;
  { you can add units after this }

type

  { BotGov2 }

  BotGov2 = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ BotGov2 }

procedure BotGov2.DoRun;
var
  ErrorMsg: String;
  F : String; // cadena con la respuesta del servidor /#/ string with response of server
  Vars : TStrings; // cadena con parametros post /#/ string with post parameters
  url : string; // jeje obvio /#/ obviously
  x : integer;  // contador simple /#/ simple counter
  vend : boolean; // secure of while loop
  u : string;

  z : integer;// contador simple /#/ simple counter

  P : TJSONParser; // see comment at the end this source file
  D : TJSONObject; // ver el comentario al final de este codigo fuente




begin

  z:=0;
  vend:=true;
  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
    With TFPHTTPClient.Create(Nil) do
    begin
    F:='';
    try
      Vars:=TstringList.Create;
      try
         Vars.Add('envio={"data":"Hello_Server"}');
         url:='http://eolansoft.net/unstable/botgo/response.php';
         F:= FormPost(url,vars);
      finally
        Vars.Free;
      end;
    finally
    end;
    end;
    { para el protocolo http el mensaje empieza con caracter null
      y finaliza con CRLF+CRLF

      the http protocol starts with null character and ends with CRLF+CRLF
    }
    //writeln(f);
    x:=1;
    while vend do begin
        if ord(F[x])=ord('{') then begin
        vend:=false;
        //writeln(x);
        end;
        if x= 100 then
        vend:=false;
        x:=x+1;
    end;

    z:=1;
    vend:=true;
    while vend do begin
        if ord(F[z])=ord('}') then begin
        vend:=false;
        //writeln(z);
        end;
        if z= 100 then
        vend:=false;
        z:=z+1;
    end;
    u:=copy(f,x-1,z-x+1);
    writeln(u);

    P:=TJSONParser.Create(u);
      try
      D:=P.Parse as TJSONObject;
      Writeln('Top : ',D.Strings['resp']);
      D.free;
      Finally
    P.free;
  end;


  // stop program loop
  Terminate;
end;

constructor BotGov2.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor BotGov2.Destroy;
begin
  inherited Destroy;
end;

procedure BotGov2.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: BotGov2;
begin
  Application:=BotGov2.Create(nil);
  Application.Title:='BotGov2!';
  Application.Run;
  Application.Free;
end.
{
Var
  P : TJSONParser;
  S : String;
  D : TJSONObject;

begin
  P:=TJSONParser.Create('{ "top": 10, "left": 20}');
  try
    D:=P.Parse as TJSONObject;
    Writeln('Top : ',D.Integers['top']);
    Writeln('Left : ',D.Integers['left']);
    D.free;
  Finally
    P.free;
  end;
end;
}

