{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.dialogs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
  , SysUtils
  {$IFDEF Windows}
  , eyelink.dialogs.handle.windows
  {$ELSEIF Linux}
  , eyelink.dialogs.handle.linux
  {$ENDIF}
  ;

  function EyeLinkEditDialog : Boolean;

implementation

uses dialogs, eyelink.w32.comp;

function EyeLinkEditDialog: Boolean;
const
  ENTER = 0;
  ESCAPE = 1;
  ALTF4 = -1;
var
  LTitle, LMessage, LText : PChar;
begin
  LTitle := 'Titulo'; // no unicode allowed
  LMessage := 'No Unicode allowed';
  LText := 'Joao'; // no unicode allowed
  Result := edit_dialog(GetWindowHandle,
    LTitle, LMessage, LText, 255) = ENTER;
end;

end.

