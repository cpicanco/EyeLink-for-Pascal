{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.dialogs.handle.linux;

{$mode ObjFPC}{$H+}

interface

uses
  eyelink.dialogs, XLib;

type

  function GetWindowHandle : HWND;

implementation

function GetWindowHandle: HWND;
var
  display: PDisplay;
  focus: HWND;
  revert: Integer;
begin
  Result := 0;

  // Open the display
  display := XOpenDisplay(nil);
  if display = nil then
  begin
    // Handle display open error
    Exit;
  end;

  // Get the window currently having the input focus
  XGetInputFocus(display, @focus, @revert);

  // Ensure the returned focus window is valid
  if focus <> 0 then
    Result := focus;

  // Close the display
  XCloseDisplay(display);
end;

end.

