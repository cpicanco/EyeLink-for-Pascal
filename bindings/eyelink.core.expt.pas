{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.core.expt;

{$mode ObjFPC}{$H+}

{$I eyelink_calltype}

interface

uses
  eyelink.core, eyelink.data, eyelink.types;

const
  CURS_UP       = $4800;  { Cursor up key. }
  CURS_DOWN     = $5000;  { Cursor down key. }
  CURS_LEFT     = $4B00;  { Cursor left key. }
  CURS_RIGHT    = $4D00;  { Cursor right key. }

  ESC_KEY       = $001B;  { Escape key. }
  ENTER_KEY     = $000D;  { Return key. }

  PAGE_UP       = $4900;  { Page up key. }
  PAGE_DOWN     = $5100;  { Page down key. }
  JUNK_KEY      = 1;      { Junk key to indicate untranslatable key. }
  TERMINATE_KEY = $7FFF;  { Returned by getkey if program should exit. }

type
   {
    This structure holds information on the display.

    This structure holds information on the display
      Call get_display_information() to fill this with data
      Check mode before running experiment!
   }
  DISPLAYINFO = record
    left: INT32; { left of display }
    top: INT32; { top of display }
    right: INT32; { right of display }
    bottom: INT32; { bottom of display }
    width: INT32; { width of display }
    height: INT32; { height of display }
    bits: INT32; { bits per pixel }

    { total entries in palette (0 if not indexed display mode) }
    palrsvd: INT32;

    { number of static entries in palette (0 if not indexed display mode) }
    palsize: INT32;

    pages: INT32; { pages supported }
    refresh: FLOAT; { refresh rate in Hz }

    { 0 if Windows 9x/Me,
      1 if Windows NT,
      2 if Windows 2000,
      3 if Windows XP/Vista/7,
      4 if Windows 10}
    winnt: INT32;
  end;

  {
  Initializes the EyeLink library,
  and opens a connection to the EyeLink tracker.

  Remarks
    By setting <mode> to be 1, the connection can be simulated for
    debugging purposes. Only timing operations and simple tests should
    be done in simulation mode, and theWindows TCP/IP system must be
    installed. This function is intended for networks where a single
    tracker is connected to the network.

  Parameter
    mode = Mode of connection:
      • 0, opens a connection with the eye tracker;
      • 1, will create a dummy connection for simulation;
      • -1, initializes the DLL but does not open a connection.
  Returns
    0 if success, else error code

  Example

    // This program illustrates the use of open_eyelink_connection()
    #include <eyelink.h>
    // Sets the EyeLink host address, if tracker IP address is different
    // from the default "100.1.1.1"
    if (set_eyelink_address("100.1.1.7"))
    return -1;
    //Initializes EyeLink library, and opens connection to the tracker
    if(open_eyelink_connection(0))
    return -1;
    ...
    // Code for the setup, recording, and cleanups
    close_eyelink_connection(); // disconnect from tracker

  }
  function open_eyelink_connection(mode: INT16): INT16; ELCALLTYPE ELDLL

  {
  Closes any connection to the eye tracker, and closes the link.

  Remarks
    NEW (v2.1): Broadcast connections can be closed, but not to
    affect the eye tracker. If a non-broadcast (primary) connection
    is closed, all broadcast connections to the tracker are also closed.
  }
  procedure close_eyelink_connection; ELCALLTYPE ELDLL
  function set_eyelink_address(addr: PAnsiChar): INT16; ELCALLTYPE ELDLL
  function set_eyelink_tcp_only(arg: INT16): INT16; ELCALLTYPE ELDLL
  function set_application_priority(priority: INT32): INT32; ELCALLTYPE ELDLL
  function key_message_pump: INT16; ELCALLTYPE ELDLL
  procedure pump_delay(delay: UINT32); ELCALLTYPE ELDLL
  procedure flush_getkey_queue; ELCALLTYPE ELDLL
  function read_getkey_queue: UINT16; ELCALLTYPE ELDLL
  function echo_key: UINT16; ELCALLTYPE ELDLL
  function getkey: UINT16; ELCALLTYPE ELDLL
  function getkey_with_mod(unicode: PUINT16): UINT32; ELCALLTYPE ELDLL
  function eyecmd_printf(const fmt: PAnsiChar): INT16; varargs; ELCALLTYPE ELDLL
  function eyemsg_printf(const fmt: PAnsiChar): INT16; varargs; ELCALLTYPE ELDLL
  function eyemsg_printf_ex(exectime: UINT32; const
    fmt: PAnsiChar): INT16; varargs; ELCALLTYPE ELDLL

  const
    DONE_TRIAL = 0;
    TRIAL_OK = 0;
    REPEAT_TRIAL = 1;
    SKIP_TRIAL = 2;
    ABORT_EXPT = 3;
    TRIAL_ERROR = -1;

  {
  Starts the EyeLink tracker recording,
  sets up link for data reception if enabled.

  Remarks
    Recording may take 10 to 30 milliseconds to begin from this command.
    The function also waits until at least one of all requested link data
    types have been received. If the return value is not zero, return the
    result as the trial result code.

  Parameters
    file_samples
      If 1, writes samples to EDF file. If 0, disables sample recording.

    file_events
      If 1, writes events to EDF file. If 0, disables event recording.

    link_samples
      If 1, sends samples through link. If 0, disables link sample access.

    link_events
      If 1, sends events through link. If 0, disables link event access.

  Returns
    0 if successful, else trial return code.

  Example
    // This program illustrates the use of start_recording(), stop_recording(),
    checking_recording(),
    // and check_record_exit()
    #include <eyelink.h>
    // Starts data recording to EDF file
    // Records samples and events to EDF file only in this example
    // Returns error code if failed
    error = start_recording(1,1,0,0);
    if(error != 0) return error;
    // Sets up for realtime execution
    begin_realtime_mode(100);
    ...
    // Display drawing code here
    // Trial loop
    while(1)
    {
    // Checks if recording aborted
    if((error=check_recording())!=0) return error;
    ...
    // Other code for display updates, timing, key or button
    // response handling
    }
    // Ensures we release realtime lock
    end_realtime_mode();
    // Records additional 100 msec of data
    pump_delay(100);
    // halt recording, return when tracker finished mode switch
    stop_recording();
    while(getkey()); // dump any accumulated key presses
    // Call this at the end of the trial, to handle special conditions
    return check_record_exit();
  }
  function start_recording(file_samples, file_events,
    link_samples, link_events: INT16): INT16; ELCALLTYPE ELDLL

  {
  Check if we are recording: if not, report an error. Call this function while
  recording. It will return 0 if recording is still in progress, or an error
  code if not. It will also handle the EyeLink Abort menu by calling
  record_abort_handler(). Any errors returned by this function should be
  returned by the trial function. On error, this will disable realtime mode and
  restore the heuristic.

  Returns
    TRIAL_OK (0) if no error.
    REPEAT_TRIAL, SKIP_TRIAL, ABORT_EXPT, TRIAL_ERROR if recording aborted.

  Example
    See start_recording;
  }
  function check_recording: INT16; ELCALLTYPE ELDLL

  {
  Stops recording, resets EyeLink data mode.

  Remarks
    Call 50 to 100 msec after an event occurs that ends the trial. This
    function waits for mode switch before returning.

  Example
    See start_recording;
  }
  procedure stop_recording; ELCALLTYPE ELDLL
  procedure set_offline_mode; ELCALLTYPE ELDLL
  function check_record_exit: INT16; ELCALLTYPE ELDLL
  procedure exit_calibration; ELCALLTYPE ELDLL


  {
  Switches the EyeLink tracker to the Setup menu, from which camera setup,
  calibration, validation, drift correction, and configuration may be performed.
  Pressing the ’ESC’ key on the tracker keyboard will exit the Setup menu and
  return from this function. Calling exit_calibration() from an event handler
  will cause any call to do_tracker_setup() in progress to return immediately.

  Returns
    Always 0.

  Example
    // This program shows an example of using the do_tracker_setup()
    #include <eyelink.h>
    // Colors used for drawing calibration target and background
    COLORREF target_foreground_color = RGB(0,0,0);
    COLORREF target_background_color = RGB(255,255,255);
    int i = SCRWIDTH/60; // Selects best size for calibration target
    int j = SCRWIDTH/300; // Selects size for focal spot in target
    if(j < 2) j = 2;
    // Sets diameter of target and of hole in middle of target
    set_target_size(i, j);
    // Sets target color and display background color
    set_calibration_colors(target_foreground_color,
    target_background_color);
    // Sets sounds for Setup menu (calibration, validation)
    set_cal_sounds("", "", "");
    // Sets sounds for drift correction
    set_dcorr_sounds("", "off", "off");
    // Performs camera setup, calibration, validation, etc.
    do_tracker_setup();
    ...
    // Code for running the trials

  }
  function do_tracker_setup: INT16; ELCALLTYPE ELDLL


  function do_drift_correct(x, y, draw, allow_setup: INT16): INT16; ELCALLTYPE ELDLL
  function do_drift_correctf(x, y: FLOAT; draw, allow_setup: INT16): INT16; ELCALLTYPE ELDLL
  function target_mode_display: INT16; ELCALLTYPE ELDLL
  function image_mode_display: INT16; ELCALLTYPE ELDLL
  procedure alert_printf(fmt: PAnsiChar); varargs; ELCALLTYPE ELDLL
  function receive_data_file(src, dest: PAnsiChar; dest_is_path: INT16): INT32; ELCALLTYPE ELDLL
  function receive_data_file_feedback(src, dest: PAnsiChar; dest_is_path: INT16; progress: TEyeLinkSendReceiveProcedure): INT32; ELCALLTYPE ELDLL
  function receive_data_file_feedback_v2(src, dest: PAnsiChar; dest_is_path: INT16; progress: TEyeLinkSendReceiveProcedure): INT32; ELCALLTYPE ELDLL
  function send_data_file_feedback(src, dest: PAnsiChar; dest_is_path: INT16; progress: TEyeLinkSendReceiveProcedure): INT32; ELCALLTYPE ELDLL
  function send_data_file_mem(src, fname: PAnsiChar; file_size: Integer; progress: TEyeLinkSendReceiveProcedure): INT32; ELCALLTYPE ELDLL
  function send_data_file(src, dest: PAnsiChar; dest_is_path: INT16): INT32; ELCALLTYPE ELDLL
  function open_data_file(name: PAnsiChar): INT16; ELCALLTYPE ELDLL
  function close_data_file: INT16; ELCALLTYPE ELDLL
  function escape_pressed: INT16; ELCALLTYPE ELDLL
  function break_pressed: INT16; ELCALLTYPE ELDLL
  procedure terminal_break(assert: INT16); ELCALLTYPE ELDLL
  function application_terminated: INT16; ELCALLTYPE ELDLL

  {
  Sets the application priority and cleans up pending Windows activity to place
  the application in realtime mode. This could take up to 100 milliseconds,
  depending on the operation system, to set the application priority. Use the

  \c &lt;delay&gt;

  value to set the minimum time this function takes, so that this function can
  act as a useful delay.

Remarks
  UnderWindows Vista and later, the application need to be run as
  "Run as Administrator" to get realtime priorities.

  Under Linux, the application need to be run as root to get realtime
  priorities. @param delay Minimum delay in milliseconds (should be about 100).

Example
  // This program shows the use of begin_realtime_mode() and end_realtime_mode()
  #include <eyelink.h>
  int error;
  // Start data recording to EDF file, BEFORE DISPLAYING STIMULUS
  error = start_recording(1,1,1,1);
  if(error != 0) return error; // return error code if failed
  // Records for 100 msec before displaying stimulus
  // Sets up for realtime execution (minimum delays)
  begin_realtime_mode(100);
  ...
  // Code for drawing, updating display and process trial loop
  // including timing, key or button response handling
  // Exits realtime execution mode
  end_realtime_mode();
  ...
  // Code for trial clean up and exiting
  end_realtime_mode()
  }
  procedure begin_realtime_mode(delay: UINT32); ELCALLTYPE ELDLL

  {
  Returns the application to a priority slightly above normal, to end realtime
  mode. This function should execute rapidly, but there is the possibility
  that Windows will allow other tasks to run after this call, causing delays of
  1-20 milliseconds.

  Remarks
    Warning: This function has little or no effect under Windows 95/98/Me.
  }
  procedure end_realtime_mode; ELCALLTYPE ELDLL
  procedure set_high_priority; ELCALLTYPE ELDLL
  procedure set_normal_priority; ELCALLTYPE ELDLL
  function in_realtime_mode: INT32; ELCALLTYPE ELDLL
  procedure eyelink_enable_extended_realtime; ELCALLTYPE ELDLL

type
  PEYECOLOR = ^EYECOLOR;
  EYECOLOR = record
    red: byte;
    green: byte;
    blue: byte;
    unused: byte;
  end;

  PEYEPALETTE = ^EYEPALETTE;
  EYEPALETTE = record
    ncolors: Integer;
    colors: PEYECOLOR;
  end;

  PEYEPIXELFORMAT = ^EYEPIXELFORMAT;
  EYEPIXELFORMAT = record
    colorkey: byte;
    Rmask: INT32;
    Gmask: INT32;
    Bmask: INT32;
    Amask: INT32;
    palette: PEYEPALETTE;
  end;

  PEYEBITMAP = ^EYEBITMAP;
  EYEBITMAP = record
    w: INT32;
    h: INT32;
    pitch: INT32;
    depth: INT32;
    pixels: Pointer;
    format: PEYEPIXELFORMAT;
  end;

  IMAGETYPE = (
    JPEG,
    PNG,
    GIF,
    BMP,
    XPM
  );

function eyelink_get_error(id: Integer; function_name: PChar): PChar; ELCALLTYPE ELDLL
procedure splice_fname(fname, path: PChar; ffname: PChar); ELCALLTYPE ELDLL
function check_filename_characters(name: PChar): Integer; ELCALLTYPE ELDLL
function file_exists(path: PChar): Integer; ELCALLTYPE ELDLL
function create_path(path: PChar; create, is_dir: SmallInt): Integer; ELCALLTYPE ELDLL
function el_bitmap_save_and_backdrop(hbm: PEYEBITMAP; xs, ys, width, height: SmallInt; fname, path: PChar; sv_options: SmallInt; xd, yd: SmallInt; xferoptions: Word): Integer; ELCALLTYPE ELDLL
function el_bitmap_to_backdrop(hbm: PEYEBITMAP; xs, ys, width, height: SmallInt; xd, yd: SmallInt; xferoptions: Word): Integer; ELCALLTYPE ELDLL
function el_bitmap_save(hbm: PEYEBITMAP; xs, ys, width, height: SmallInt; fname, path: PChar; sv_options: SmallInt): Integer; ELCALLTYPE ELDLL

const
  KEYINPUT_EVENT = $1;
  MOUSE_INPUT_EVENT = $4;
  MOUSE_MOTION_INPUT_EVENT = $5;
  MOUSE_BUTTON_INPUT_EVENT = $6;

const
  ELKMOD_NONE = $0000;
  ELKMOD_LSHIFT = $0001;
  ELKMOD_RSHIFT = $0002;
  ELKMOD_LCTRL = $0040;
  ELKMOD_RCTRL = $0080;
  ELKMOD_LALT = $0100;
  ELKMOD_RALT = $0200;
  ELKMOD_LMETA = $0400;
  ELKMOD_RMETA = $0800;
  ELKMOD_NUM = $1000;
  ELKMOD_CAPS = $2000;
  ELKMOD_MODE = $4000;

type
  KeyInput = record
    _type: byte;
    state: byte;
    key: UINT16;
    modifier: UINT16;
    unicode: UINT16;
  end;

  MouseMotionEvent = record
    _type: byte;
    which: byte;
    state: byte;
    x: UINT16;
    y: UINT16;
    xrel: UINT16;
    yrel: UINT16;
  end;

  MouseButtonEvent = record
    _type: byte;
    which: byte;
    button: byte;
    state: byte;
    x: UINT16;
    y: UINT16;
  end;

  PInputEvent = ^InputEvent;
  InputEvent = record
    case byte of
      0: ( _type: byte );
      1: ( key: KeyInput );
      2: ( motion: MouseMotionEvent );
      3: ( button: MouseButtonEvent );
  end;

type
  TEyeLinkHookProcedure = procedure; ELCALLTYPE
  TEyeLinkHookDisplayFunction = function(width, height: INT16): INT16; ELCALLTYPE
  TEyeLinkHookSetupFunction = function: INT16; ELCALLTYPE
  TEyeLinkHookSetupImageDisplayFunction = function(width, height: INT16): INT16; ELCALLTYPE
  TEyeLinkHookImageTitleProcedure = procedure(threshold: INT16; cam_name: PChar); ELCALLTYPE
  TEyeLinkHookDrawImageLineProcedure = procedure(width, line, totlines: INT16; pixels: PByte); ELCALLTYPE
  TEyeLinkHookSetImagePaletteProcedure = procedure(ncolors: INT16; r, g, b: PByte); ELCALLTYPE
  TEyeLinkHookDrawCalibrationTargetProcedure = procedure(x, y: INT16); ELCALLTYPE
  TEyeLinkHookErrorProcedure = procedure(error: INT16); ELCALLTYPE
  TEyeLinkHookGetInputKeyFunction = function(event: PInputEvent): INT16; ELCALLTYPE
  TEyeLinkHookAlertProcedure = procedure(const text: PChar); ELCALLTYPE

  PHOOKFCNS = ^HOOKFCNS;
  HOOKFCNS = record
    setup_cal_display_hook: TEyeLinkHookSetupFunction;
    exit_cal_display_hook: TEyeLinkHookProcedure;
    record_abort_hide_hook: TEyeLinkHookProcedure;
    setup_image_display_hook: TEyeLinkHookSetupImageDisplayFunction;
    image_title_hook: TEyeLinkHookImageTitleProcedure;
    draw_image_line_hook: TEyeLinkHookDrawImageLineProcedure;
    set_image_palette_hook: TEyeLinkHookSetImagePaletteProcedure;
    exit_image_display_hook: TEyeLinkHookProcedure;
    clear_cal_display_hook: TEyeLinkHookProcedure;
    erase_cal_target_hook: TEyeLinkHookProcedure;
    draw_cal_target_hook: TEyeLinkHookDrawCalibrationTargetProcedure;
    cal_target_beep_hook: TEyeLinkHookProcedure;
    cal_done_beep_hook: TEyeLinkHookErrorProcedure;
    dc_done_beep_hook: TEyeLinkHookErrorProcedure;
    dc_target_beep_hook: TEyeLinkHookProcedure;
    get_input_key_hook: TEyeLinkHookGetInputKeyFunction;
    alert_printf_hook: TEyeLinkHookAlertProcedure;
  end;

type
  EL_CAL_BEEP = (
    EL_DC_DONE_ERR_BEEP = -2,
    EL_CAL_DONE_ERR_BEEP = -1,
    EL_CAL_DONE_GOOD_BEEP = 0,
    EL_CAL_TARG_BEEP = 1,
    EL_DC_DONE_GOOD_BEEP = 2,
    EL_DC_TARG_BEEP = 3
  );

type
  TEyeLinkHookUserDataFunction =
    function(userData: Pointer): INT16; ELCALLTYPE
  TEyeLinkHookSetupImageDisplayFunction2 =
    function(userData: Pointer; width, height: INT16): INT16; ELCALLTYPE
  TEyeLinkHookImageTitleFunction =
      function(userData: Pointer; title: PChar): INT16; ELCALLTYPE
  TEyeLinkHookDrawImageFunction =
    function(userData: Pointer; width, height: INT16; pixels: PByte): INT16; ELCALLTYPE
  TEyeLinkHookDrawCalibrationTargetFunction =
    function(userData: Pointer; x, y: FLOAT): INT16; ELCALLTYPE
  TEyeLinkHookPlayTargetBeepFunction =
    function(userData: Pointer; beep_type: EL_CAL_BEEP): INT16; ELCALLTYPE
  TEyeLinkHookGetInputKeyFunction2 =
    function(userData: Pointer; event: PInputEvent): INT16; ELCALLTYPE
  TEyeLinkHookAlertFunction =
    function(userData: Pointer; msg: PChar): INT16; ELCALLTYPE

  PHOOKFCNS2 = ^HOOKFCNS2;
  HOOKFCNS2 = record
    major: Integer;
    minor: Integer;
    userData: Pointer;
    setup_cal_display_hook: TEyeLinkHookUserDataFunction;
    exit_cal_display_hook: TEyeLinkHookUserDataFunction;
    setup_image_display_hook: TEyeLinkHookSetupImageDisplayFunction2;
    image_title_hook: TEyeLinkHookImageTitleFunction;
    draw_image: TEyeLinkHookDrawImageFunction;
    exit_image_display_hook: TEyeLinkHookUserDataFunction;
    clear_cal_display_hook: TEyeLinkHookUserDataFunction;
    erase_cal_target_hook: TEyeLinkHookUserDataFunction;
    draw_cal_target_hook: TEyeLinkHookDrawCalibrationTargetFunction;
    play_target_beep_hook: TEyeLinkHookPlayTargetBeepFunction;
    get_input_key_hook: TEyeLinkHookGetInputKeyFunction2;
    alert_printf_hook: TEyeLinkHookAlertFunction;
    reserved1: Integer;
    reserved2: Integer;
    reserved3: Integer;
    reserved4: Integer;
  end;

TEyeLinkHookSetWriteImageFunction =
  function(outfilename: PChar; format: Integer; bitmap: PEYEBITMAP): Integer; ELCALLTYPE

procedure setup_graphic_hook_functions(hooks: PHOOKFCNS); ELCALLTYPE ELDLL
function get_all_hook_functions: PHOOKFCNS; ELCALLTYPE ELDLL
function setup_graphic_hook_functions_V2(
  hooks: PHOOKFCNS2): INT16; ELCALLTYPE ELDLL
function get_all_hook_functions_V2: PHOOKFCNS; ELCALLTYPE ELDLL
function set_write_image_hook(hookfn: TEyeLinkHookSetWriteImageFunction;
  options: Integer): Integer; ELCALLTYPE ELDLL
function eyelink_peep_input_event(event: PInputEvent;
  mask: Integer): Integer; ELCALLTYPE ELDLL
function eyelink_get_input_event(event: PInputEvent;
  mask: Integer): Integer; ELCALLTYPE ELDLL
function eyelink_peep_last_input_event(event: PInputEvent;
  mask: Integer): Integer; ELCALLTYPE ELDLL
procedure eyelink_flush_input_event; ELCALLTYPE ELDLL
function eyelink_initialize_mapping(left: FLOAT; top: FLOAT; right: FLOAT;
  bottom: FLOAT): INT32; ELCALLTYPE ELDLL
function eyelink_href_to_gaze(var xp, yp: FLOAT;
  sample: PFSAMPLE): INT32; ELCALLTYPE ELDLL
function eyelink_gaze_to_href(var xp, yp: FLOAT;
  sample: PFSAMPLE): INT32; ELCALLTYPE ELDLL
function eyelink_href_angle(x1, y1, x2, y2: FLOAT): FLOAT; ELCALLTYPE ELDLL
procedure eyelink_href_resolution(x, y: FLOAT;
  var xres, yres: FLOAT); ELCALLTYPE ELDLL
function get_image_xhair_data(var x: array of INT16;
  var y: array of INT16; var xhairs_on: INT16): Integer; ELCALLTYPE ELDLL
function eyelink_get_extra_raw_values(s: PFSAMPLE;
  rv: PFSAMPLE_RAW): Integer; ELCALLTYPE ELDLL
function eyelink_get_extra_raw_values_v2(s: PFSAMPLE; eye: Integer;
  rv: PFSAMPLE_RAW): Integer; ELCALLTYPE ELDLL

const
  FIVE_SAMPLE_MODEL = 1;
  NINE_SAMPLE_MODEL = 2;
  SEVENTEEN_SAMPLE_MODEL = 3;
  EL1000_TRACKER_MODEL = 4;

function eyelink_calculate_velocity_x_y(slen: Integer;
  var xvel, yvel: array of FLOAT;
  vel_sample: PFSAMPLE): Integer; ELCALLTYPE ELDLL
function eyelink_calculate_velocity(slen: Integer; var vel: array of FLOAT;
  vel_sample: PFSAMPLE): Integer; ELCALLTYPE ELDLL
function eyelink_calculate_overallvelocity_and_acceleration(slen: Integer;
  var vel, acc: array of FLOAT; vel_sample: PFSAMPLE): Integer; ELCALLTYPE ELDLL
function timemsg_printf(t: UINT32; fmt: PChar): INT16; ELCALLTYPE ELDLL
function open_message_file(fname: PChar): Integer; ELCALLTYPE ELDLL
procedure close_message_file; ELCALLTYPE ELDLL

const
  CR_HAIR_COLOR = 1;
  PUPIL_HAIR_COLOR = 2;
  PUPIL_BOX_COLOR = 3;
  SEARCH_LIMIT_BOX_COLOR = 4;
  MOUSE_CURSOR_COLOR = 5;

type
  PCrossHairInfo = ^CrossHairInfo;
  TEyeLinkDrawLineProcedure =
    procedure(dt: PCrossHairInfo; x1, y1, x2, y2, colorindex: Integer); ELCALLTYPE
  TEyeLinkDrawLozengeProcedure =
    procedure(dt: PCrossHairInfo; x, y, w, h, colorindex: Integer); ELCALLTYPE
  TEyeLinkGetMouseStateProcedure =
    procedure(dt: PCrossHairInfo; var x, y, state: Integer); ELCALLTYPE
  CrossHairInfo = record
    majorVersion: Shortint;
    minorVersion: Shortint;
    w: Integer;
    h: Integer;
    privatedata: Pointer;
    userdata: Pointer;
    drawLine: TEyeLinkDrawLineProcedure;
    drawLozenge: TEyeLinkDrawLozengeProcedure;
    getMouseState: TEyeLinkGetMouseStateProcedure;
    reserved1: Integer;
    reserved2: Integer;
    reserved3: Integer;
    reserved4: Integer;
  end;


procedure eyelink_draw_cross_hair(chi: PCrossHairInfo); ELCALLTYPE ELDLL
procedure eyelink_dll_version(c: PChar); ELCALLTYPE ELDLL
procedure eyelink_set_special_keys(terminate_key_mask: Integer;
  terminate_key: Integer; break_key_mask: Integer;
  break_key: Integer; case_sensitive: Integer); ELCALLTYPE ELDLL

implementation

end.

