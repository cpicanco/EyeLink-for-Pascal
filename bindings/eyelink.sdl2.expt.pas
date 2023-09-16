{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.sdl2.expt;

{$mode ObjFPC}{$H+}

{$I eyelink_calltype}

interface

{$IFDEF SDL}
  {$ERROR sdl should not be used with sdl2_expt.h}
{$ENDIF}

uses
  SDL2, eyelink.core.expt;

const
  {$IFDEF Windows}
    {$IFDEF Win32}
      EYELINK_DLL_NAME = 'eyelink_core_graphics_sdl2.dll';
    {$ELSE}
      EYELINK_DLL_NAME = 'eyelink_core_graphics_sdl2x64.dll';
    {$ENDIF}
  {$ENDIF}

  {$IFDEF Linux}
    EYELINK_DLL_NAME = 'eyelink_core_graphics_sdl2x64.so';
  {$ENDIF}

var
  SCREEN_LEFT: Integer = 0;
  SCREEN_TOP: Integer = 0;
  SCREEN_RIGHT: Integer = 0;
  SCREEN_BOTTOM: Integer = 0;
  SCRHEIGHT: Integer = 0;
  SCRWIDTH: Integer = 0;

type
  PDISPLAYINFO = ^DISPLAYINFO;
  PSDL_Color = ^TSDL_Color;

procedure set_calibration_colors(fg, bg: PSDL_Color); ELCALLTYPE ELDLL
procedure set_target_size(diameter, holesize: UInt16); ELCALLTYPE ELDLL
procedure set_cal_sounds(ontarget, ongood, onbad: PChar); ELCALLTYPE ELDLL
procedure set_dcorr_sounds(ontarget, ongood, onbad: PChar); ELCALLTYPE ELDLL
function set_camera_image_position(left, top, right, bottom: Int16): Int16; ELCALLTYPE ELDLL
function get_current_display_information(var csw, csh, ccd: Int32): Int32; ELCALLTYPE ELDLL
procedure get_display_information(di: PDISPLAYINFO); ELCALLTYPE ELDLL
function init_expt_window(var window: PSDL_Window; info: PDISPLAYINFO): Int16; ELCALLTYPE ELDLL
procedure close_expt_graphics; ELCALLTYPE ELDLL
procedure get_expt_window(var window: PSDL_Window); ELCALLTYPE ELDLL
function sdl_bitmap_save_and_backdrop(hbm: PSDL_Surface; xs, ys, width, height: Int16; fname, path: PChar; sv_options, xd, yd, bx_options: Int16): Int32; ELCALLTYPE ELDLL
function sdl_bitmap_to_backdrop(hbm: PSDL_Surface; xs, ys, width, height, xd, yd: Int16; bx_options: UInt16): Int32; ELCALLTYPE ELDLL
function sdl_bitmap_save(hbm: PSDL_Surface; xs, ys, width, height: Int16; fname, path: PChar; sv_options: Int16): Int32; ELCALLTYPE ELDLL
procedure set_cal_target_surface(surface: PSDL_Surface); ELCALLTYPE ELDLL
procedure set_cal_background_surface(surface: PSDL_Surface); ELCALLTYPE ELDLL
procedure reset_background_surface; ELCALLTYPE ELDLL
procedure disable_custombackground_on_imagemode; ELCALLTYPE ELDLL
function set_cal_animation_target(aviName: PChar; playCount, options: Int32): Int32; ELCALLTYPE ELDLL
procedure set_cal_font(fontPath: PChar; size: Int32); ELCALLTYPE ELDLL

{$I eyelink_sdl_helpers.inc}

end.

