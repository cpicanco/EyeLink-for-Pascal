{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.classes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, eyelink.classes.calibration;

type

  TELConnection = (elcDLL, elcDevice, elcMock);

  { TEyeLink }

  TEyeLink = class(TComponent)
  private
    FCalibration : TEyeLinkCalibration;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Connect; overload;
    procedure Connect(ELConnection : TELConnection); overload;
    procedure InitializeExperimentGraphics;
    procedure InitializeCustomExperimentGraphics;
    procedure CloseExperimentGraphics;
    procedure DoTrackerSetup;
    procedure SetupGraphicHook;
    procedure Abort;
    //record_abort_hide_hook: TEyeLinkHookProcedure;
    //setup_image_display_hook: TEyeLinkHookSetupImageDisplayFunction;
    //image_title_hook: TEyeLinkHookImageTitleProcedure;
    //draw_image_line_hook: TEyeLinkHookDrawImageLineProcedure;
    //set_image_palette_hook: TEyeLinkHookSetImagePaletteProcedure;
    //exit_image_display_hook: TEyeLinkHookProcedure;
    //get_input_key_hook: TEyeLinkHookGetInputKeyFunction;
    //alert_printf_hook: TEyeLinkHookAlertProcedure;
  end;

implementation

uses Dialogs
  , SDL2
  , eyelink.core
  , eyelink.core.expt
  , eyelink.sdl2.expt
  , eyelink.classes.hook
  ;

{ TEyeLink }

constructor TEyeLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TEyeLink.Destroy;
begin
  inherited Destroy;
  close_eyelink_connection;
end;

const
  // mode -1, initializes the DLL but does not open a connection.
  EL_INITIALIZE_DLL = -1;

  // mode 0, opens a connection with the eye tracker;
  EL_INITIALIZE_DEVICE_CONNECTION = 0;

  // mode 1, will create a dummy connection for simulation;
  EL_INITIALIZE_MOCK_CONNECTION = 1;

procedure TEyeLink.Connect;
begin
  open_eyelink_connection(EL_INITIALIZE_DLL);
end;

procedure TEyeLink.Connect(ELConnection: TELConnection);
begin
  case ELConnection of
    elcDLL :
      open_eyelink_connection(EL_INITIALIZE_DLL);
    elcDevice :
      open_eyelink_connection(EL_INITIALIZE_DEVICE_CONNECTION);
    elcMock :
      open_eyelink_connection(EL_INITIALIZE_MOCK_CONNECTION);
  end;
end;

procedure TEyeLink.InitializeExperimentGraphics;
var
  display : DISPLAYINFO;
begin
	//display.width := Screen.Width;
	//display.height := Screen.Height;
	//display.bits := 32;
	//display.refresh := 60;
 // if SDL_Init(SDL_INIT_VIDEO) < 0 then Exit;
 // SDLWindow := SDL_CreateWindow('Stimulus Control',
 //   0, 0, Screen.Width, Screen.Height, SDL_WINDOW_FULLSCREEN);
 // SDLRenderer := SDL_CreateRenderer(@SDLWindow, -1, SDL_RENDERER_ACCELERATED);
 // SDL_SetRenderDrawColor(@SDLRenderer, 255, 0, 0, 255);
 // SDL_RenderClear(@SDLRenderer);
 // SDL_RenderPresent(@SDLRenderer);
 // if init_expt_window(SDLWindow, @display) = -1 then begin
 //	  exit_eyelink();

end;

procedure TEyeLink.InitializeCustomExperimentGraphics;
begin
  eyelink_set_tracker_setup_default(0);
  eyelink_start_setup;
end;

procedure TEyeLink.CloseExperimentGraphics;
begin
  close_expt_graphics;
end;

procedure TEyeLink.DoTrackerSetup;
var
  empty    : PChar = '';
  ontarget : PChar = '';
  ongood   : PChar = 'off';
  onbad    : PChar = 'off';

  target_foreground_color : TSDL_Color;
  target_background_color : TSDL_Color;

  i  : integer;
  j : integer;

begin
  target_foreground_color := RGB(0, 0, 0, 255);
  target_background_color := RGB(255, 255, 255, 255);
  //i := Screen.Width div 60; // Selects best size for calibration target
  //j := Screen.Width div 300; // Selects size for focal spot in target
  if(j < 2) then j := 2;
  // Sets diameter of target and of hole in middle of target
  set_target_size(i, j);
  // Sets target color and display background color
  set_calibration_colors(@target_foreground_color, @target_background_color);
  // Sets sounds for Setup menu (calibration, validation)
  set_cal_sounds(empty, empty, empty);
  // Sets sounds for drift correction
  set_dcorr_sounds(ontarget, ongood, onbad);

  //set_cal_target_surface();

  //set_cal_background_surface();
  // Performs camera setup, calibration, validation, etc.
  do_tracker_setup;

  //eyelink_set_tracker_setup_default(0);
  //eyelink_start_setup;
end;

procedure TEyeLink.SetupGraphicHook;
begin
  //setup_graphic_hook_functions(@EyeLinkHook);
end;

procedure TEyeLink.Abort;
var
  s1 : PAnsiChar = 'test.edf';
begin

end;

end.
