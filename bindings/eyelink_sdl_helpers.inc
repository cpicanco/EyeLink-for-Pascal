{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
procedure Flip(x: PSDL_Surface);
function RGB(red, green, blue, alpha : Uint8) : TSDL_Color;
function SDLRGB(x: PSDL_Surface; y: TSDL_Color): Uint32;

type

  PCCDBS = ^TCCDBS;
  TCCDBS = record
    userdata: Pointer;
    buttons: array[0..255] of Char;
    internal: Pointer;
  end;

  TGetExButtonStatesFunction = function (accdbs: PCCDBS): Int32; WinAPi;

  function enable_external_calibration_device(buttonStatesfcn: TGetExButtonStatesFunction; config: PChar; userData: Pointer): Int32; ELCALLTYPE ELDLL

var
  CCDBS : TCCDBS;

implementation

function RGB(red, green, blue, alpha: Uint8): TSDL_Color;
begin
  Result.r := red;
  Result.g := green;
  Result.b := blue;
  {$IFDEF SDL} Result.unused := alpha;{$ENDIF}
  {$IFDEF SDL2}Result.a := alpha;     {$ENDIF}
end;

function SDLRGB(x: PSDL_Surface; y: TSDL_Color): Uint32;
begin
  Result := SDL_MapRGB(x^.format, y.r, y.g, y.b);
end;

procedure Flip(x: PSDL_Surface);
begin
{$IFDEF SDL}
  {$IFNDEF WIN64}
    while (SDL_FlipEx(x) < 0) do ;
  {$ELSE}
    while (SDL_Flip(x) < 0) do ;
  {$ENDIF}
{$ENDIF}
end;
