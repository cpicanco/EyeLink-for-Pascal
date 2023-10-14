{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.classes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, sdl.app
  , eyelink.core.expt
  ;

type

  TELConnection = (elcDLL, elcDevice, elcMock);

  { TEyeLink }

  TEyeLink = class(TComponent)
  private
    FDisplay : DISPLAYINFO;
    FEyeLinkVersion : integer;
    FEyeLinkTrackerSoftwareVersion : integer;
    FDataFilename : string;
    FHostApp: TSDLApplication;
    FHostProgramName: string;
    FOutputFolder : string;
    //FCalibration : TEyeLinkCalibration;
    function Connect(ELConnection: TELConnection) : Int16;
    function DataFilenameIsValid : Boolean;
    function GetConnected: Boolean;
    procedure SetConnected(AValue: Boolean);
    procedure SetHostApp(AValue: TSDLApplication);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure InitializeLibrary;
    procedure InitializeLibraryAndConnectToDevice;
    procedure InitializeLibraryAndConnectToMockDevice;
    procedure InitializeCustomExperimentGraphics;
    procedure CloseExperimentGraphics;
    procedure DoTrackerSetup;
    procedure SetupGraphicHook;
    procedure Abort;
    procedure DataOpenFile;
    procedure DataRecordingStart;
    procedure DataRecordingStop;
    procedure DataReceiveFile;
    //record_abort_hide_hook: TEyeLinkHookProcedure;
    //setup_image_display_hook: TEyeLinkHookSetupImageDisplayFunction;
    //image_title_hook: TEyeLinkHookImageTitleProcedure;
    //draw_image_line_hook: TEyeLinkHookDrawImageLineProcedure;
    //set_image_palette_hook: TEyeLinkHookSetImagePaletteProcedure;
    //exit_image_display_hook: TEyeLinkHookProcedure;
    //get_input_key_hook: TEyeLinkHookGetInputKeyFunction;
    //alert_printf_hook: TEyeLinkHookAlertProcedure;
    property Connected : Boolean read GetConnected write SetConnected;
    property HostApp : TSDLApplication read FHostApp write SetHostApp;
  end;

implementation

uses
  SDL2
  , sdl.colors
  , eyelink.helpers
  , eyelink.version
  , eyelink.core
  , eyelink.sdl2.expt
  //, eyelink.classes.hook
  ;

const
  // initializes the DLL but does not open a connection.
  EL_INITIALIZE_DLL = -1;

  // opens a connection with the eye tracker;
  EL_INITIALIZE_DEVICE_CONNECTION = 0;

  // dummy connection for simulation;
  EL_INITIALIZE_MOCK_CONNECTION = 1;

{ TEyeLink }

constructor TEyeLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataFilename := 'TEST.EDF';
  FOutputFolder := 'c:\data\';
end;

destructor TEyeLink.Destroy;
begin
  close_eyelink_connection;
  inherited Destroy;
end;

procedure TEyeLink.InitializeLibrary;
begin
  Connect(elcDLL);
end;

procedure TEyeLink.InitializeLibraryAndConnectToDevice;
var
  LVersionString : array [0..49] of Char;
begin
  if Connect(elcDevice) < 0 then begin
    raise Exception.Create('Could not connect to device.');
  end;
  set_offline_mode();
  flush_getkey_queue;
  FEyeLinkVersion := eyelink_get_tracker_version(LVersionString);
  if FEyeLinkVersion = 3 then begin
    FEyeLinkTrackerSoftwareVersion :=
      EyeLinkTrackerSoftwareVersion(LVersionString);
  end;
end;

procedure TEyeLink.InitializeLibraryAndConnectToMockDevice;
begin
  Connect(elcMock);
end;

function TEyeLink.Connect(ELConnection: TELConnection) : Int16;
begin
  // defaults to 100.1.1.1
  // set_eyelink_address("100.1.1.7") for ip is different from default
  case ELConnection of
    elcDLL :
      Result := open_eyelink_connection(EL_INITIALIZE_DLL);
    elcDevice :
      Result := open_eyelink_connection(EL_INITIALIZE_DEVICE_CONNECTION);
    elcMock :
      Result := open_eyelink_connection(EL_INITIALIZE_MOCK_CONNECTION);
  end;
end;

function TEyeLink.DataFilenameIsValid: Boolean;
begin
  Result := True;
end;

function TEyeLink.GetConnected: Boolean;
begin
  Result := eyelink_is_connected() > 0;
end;

procedure TEyeLink.SetConnected(AValue: Boolean);
begin

end;

procedure TEyeLink.SetHostApp(AValue: TSDLApplication);
begin
  if FHostApp = AValue then Exit;
  FHostApp := AValue;
end;

procedure TEyeLink.InitializeCustomExperimentGraphics;
begin
  //eyelink_set_tracker_setup_default(0);
  //eyelink_start_setup;

end;

procedure TEyeLink.CloseExperimentGraphics;
begin
  close_expt_graphics;
end;

procedure TEyeLink.DoTrackerSetup;
var
  //empty    : PChar = '';
  //ontarget : PChar = '';
  //ongood   : PChar = 'off';
  //onbad    : PChar = 'off';
  //
  //i  : integer;
  //j : integer;
  LWindow : PSDL_Window;
begin
	FDisplay.width := FHostApp.Monitor.w;
	FDisplay.height := FHostApp.Monitor.h;
	FDisplay.bits := 32;
	FDisplay.refresh := 60;

  LWindow := FHostApp.Window;
  if init_expt_window(LWindow, @FDisplay) = -1 then
    raise Exception.Create('init_expt_window failed');

  //i := display.Width div 60; // Selects best size for calibration target
  //j := display.Width div 300; // Selects size for focal spot in target
  //if(j < 2) then j := 2;

  // Sets diameter of target and of hole in middle of target
  //set_target_size(i, j);
  // Sets target color and display background color
  set_calibration_colors(@clBlack, @clWhite);
  // Sets sounds for Setup menu (calibration, validation)
  //set_cal_sounds(empty, empty, empty);
  // Sets sounds for drift correction
  //set_dcorr_sounds(ontarget, ongood, onbad);

  //set_cal_target_surface();
  //set_cal_background_surface();

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

procedure TEyeLink.DataOpenFile;
var
  Monitor : TSDL_Rect;
  function HasHorizontalTarget : string;
  begin
    if FEyeLinkTrackerSoftwareVersion >= 4 then begin
      Result := ',HTARGET';
    end else begin
      Result := '';
    end;
  end;

begin
  Monitor := FHostApp.Monitor;
	if DataFilenameIsValid then begin
	  if open_data_file(FDataFilename.ToPchar) <> 0 then begin
		  alert_printf(
        'Cannot create an EDF file named %s.', FDataFilename.ToPchar);
      Exit;
    end;

	  eyecmd_printf(
      'add_file_preamble_text ''RECORDED BY %s'' ', FHostProgramName.ToPchar);
	end;

	eyecmd_printf('screen_pixel_coords = %ld %ld %ld %ld',
				 Monitor.x, Monitor.y, Monitor.w, Monitor.h);
	eyecmd_printf('sample_rate = 1000');					  // Set the intended sampling rate
	eyecmd_printf('calibration_type = HV13');                  // Setup calibration type

	eyemsg_printf('DISPLAY_COORDS %ld %ld %ld %ld',
				 Monitor.x, Monitor.y, Monitor.w, Monitor.h);

  if FDisplay.refresh > 40 then begin
	  eyemsg_printf('FRAMERATE %1.2f Hz.', FDisplay.refresh);
  end;

  if FEyeLinkVersion >= 2 then begin
    eyecmd_printf('select_parser_configuration 0');  // 0 = standard sensitivity
	  if FEyeLinkVersion = 2 then begin
		  eyecmd_printf('scene_camera_gazemap = NO');
	  end;
  end else begin
    eyecmd_printf('saccade_velocity_threshold = 35');
    eyecmd_printf('saccade_acceleration_threshold = 9500');
  end;
  // Select which events are saved in the EDF file. Include everything just in case
  eyecmd_printf(
    'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
  // Select which events are available online for gaze - contingent experiments. Include everything just in case
  eyecmd_printf(
    'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON,FIXUPDATE,INPUT');

  //Select which sample data is saved in EDF file or available online.Include everything just in case
  // Check tracker version and include 'HTARGET' to save head target sticker data for supported eye trackers
  eyecmd_printf(
    'file_sample_data  = LEFT,RIGHT,GAZE,HREF,PUPIL,AREA,GAZERES,BUTTON,STATUS%s,INPUT',
    HasHorizontalTarget.ToPchar);

  eyecmd_printf(
    'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS%s,INPUT',
    HasHorizontalTarget.ToPchar);

	eyecmd_printf('button_function 5 ''accept_target_fixation''');
end;

procedure TEyeLink.DataRecordingStart;
begin
  //start_recording
end;

procedure TEyeLink.DataRecordingStop;
begin

end;

procedure TEyeLink.DataReceiveFile;
begin
  //set_offline_mode(); // set offline mode so we can transfer file
  //pump_delay(1000); // delay so tracker is ready
  //eyecmd_printf('close_data_file');
  //if break_pressed()

  // make sure we created a file
  if Connected and DataFilenameIsValid then begin

    // tell EXPTSPPT to release window
    //close_expt_graphics();

    // transfer the file, ask for a local name
    receive_data_file(FDataFilename.ToPchar, FOutputFolder.ToPchar, 1);
  end;
  //open_output_folder()
end;

end.

