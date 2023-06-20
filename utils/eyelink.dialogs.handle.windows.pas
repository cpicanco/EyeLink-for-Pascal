{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.dialogs.handle.windows;

{$mode ObjFPC}{$H+}

interface

uses Windows;

  function GetWindowHandle : HWND;

implementation

function GetWindowHandle: HWND;
begin
  Result := GetActiveWindow;
end;

end.

