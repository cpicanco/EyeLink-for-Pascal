{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.w32.comp;

{$mode ObjFPC}{$H+}

{$I eyelink_calltype}

interface

uses
{$IFDEF Windows}
  Windows
{$ELSEIF Linux}
  X
{$ENDIF}
  ;

const
{$IFDEF Windows}
  {$IFDEF CPUX86}
    EYELINK_DLL_NAME = 'eyelink_w32_comp.dll';
  {$ELSE}
    EYELINK_DLL_NAME = 'eyelink_w32_comp64.dll';
  {$ENDIF}
{$ENDIF}

{$IFDEF Linux}
  EYELINK_DLL_NAME = 'eyelink_w32_comp64.so';
{$ENDIF}


{$IFDEF Linux}
type
  HWND = TWindow;
{$ENDIF}

function receive_data_file_dialog(src: LPSTR; dest: LPSTR; dest_is_path: INT16): INT32; ELCALLTYPE ELDLL
function edit_dialog(hw: HWND; title: LPSTR; msg: LPSTR; txt: LPSTR; maxsize: INT16): INT16; ELCALLTYPE ELDLL
function ask_session(hw: HWND; title: LPSTR; msg: LPSTR; path: LPSTR; pathmax: INT16; txt: LPSTR; maxsize: INT16): INT16; ELCALLTYPE ELDLL
function receive_data_file(src: LPSTR; dest: LPSTR; dest_is_path: INT16): INT32;

implementation

function receive_data_file(src: LPSTR; dest: LPSTR; dest_is_path: INT16): INT32;
begin
  Result := receive_data_file_dialog(src, dest, dest_is_path);
end;

end.

