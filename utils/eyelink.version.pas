{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.version;

{$mode ObjFPC}{$H+}

interface

uses
  SysUtils, eyelink.core, eyelink.core.expt;

function EyeLinkDLLVersion : string;
function EyeLinkTrackerVersion : string;
function EyeLinkTrackerSoftwareVersion(AVersionString : PChar) : INT16;

implementation

function EyeLinkDLLVersion: string;
var
  version: array[0..255] of Char;
begin
  eyelink_dll_version(version);
  Result := StrPas(version);
  Result := Result.Replace(',', '.', [rfReplaceAll]);
end;

function EyeLinkTrackerVersion : string;
var
  VersionInformation : array[0..49] of Char;
begin
  eyelink_get_tracker_version(VersionInformation);
  Result := StrPas(VersionInformation);
end;

function EyeLinkTrackerSoftwareVersion(AVersionString : PChar) : INT16;
//var
//  ln : int16 = 0;
//  st : int16 = 0;
begin
  //ln = strlen(verstr);
  //while(ln>0 && verstr[ln -1]==' ') do begin
  //  verstr[--ln] = 0; // trim
  //end;
  //
  //// find the start of the version number
  //st = ln;
  //while(st>0 && verstr[st -1]!=' ') do begin
  //  st --;
  //end;
  //return atoi(&verstr[st]);
end;

end.

