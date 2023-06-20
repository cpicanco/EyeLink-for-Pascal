{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.version;

{$mode ObjFPC}{$H+}

interface

uses
  SysUtils, eyelink.core.expt;

function EyeLinkDLLVersion : string;

implementation

function EyeLinkDLLVersion: string;
var
  version: array[0..255] of Char;
begin
  eyelink_dll_version(version);
  Result := StrPas(version);
  Result := Result.Replace(',', '.', [rfReplaceAll]);
end;

end.

