{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.core;

{$mode objfpc}{$H+}

{$I eyelink_calltype}

interface

uses eyelink.data, eyelink.types;

const
  // maximum number of characters in a command or message sent from the display to a DOS host
  LINK_SEND_MAX = 244;


{$IFDEF Windows}
  {$IFDEF CPU32BITS}
    EYELINK_DLL_NAME = 'eyelink_core.dll';
  {$ELSE}
    EYELINK_DLL_NAME = 'eyelink_core64.dll';
  {$ENDIF}
{$ENDIF}

{$IFDEF Linux}
  EYELINK_DLL_NAME = 'eyelink_core.so';
{$ENDIF}


const
  OK_RESULT = 0;
  NO_REPLY = 1000;
  LINK_TERMINATED_RESULT = -100;
  ABORT_RESULT = 27;
  UNEXPECTED_EOL_RESULT = -1;
  SYNTAX_ERROR_RESULT = -2;
  BAD_VALUE_RESULT = -3;
  EXTRA_CHARACTERS_RESULT = -4;
  LINK_INITIALIZE_FAILED = -200;
  CONNECT_TIMEOUT_FAILED = -201;
  WRONG_LINK_VERSION = -202;
  TRACKER_BUSY = -203;

//type
//  UINT16 = Word;
//  UINT32 = LongWord;
//  INT16 = SmallInt;

function open_eyelink_system(bufsize: UINT16; options: PChar): UINT16; ELCALLTYPE ELDLL
procedure eyelink_set_name(name: PChar); ELCALLTYPE ELDLL
procedure close_eyelink_system; ELCALLTYPE ELDLL
function current_time: UINT32; ELCALLTYPE ELDLL
function current_micro(var m: MICRO): UINT32; ELCALLTYPE ELDLL
function current_usec: UINT32; ELCALLTYPE ELDLL
procedure msec_delay(n: UINT32); ELCALLTYPE ELDLL
function current_double_usec: Double; ELCALLTYPE ELDLL

var
  eye_broadcast_address: ELINKADDR;
  rem_broadcast_address: ELINKADDR;
  our_address: ELINKADDR;

function eyelink_open_node(var node: ELINKADDR; busytest: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_open: INT16; ELCALLTYPE ELDLL
function eyelink_broadcast_open: INT16; ELCALLTYPE ELDLL
function eyelink_dummy_open: INT16; ELCALLTYPE ELDLL
function eyelink_close(send_msg: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_reset_clock(enable: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_is_connected: INT16; ELCALLTYPE ELDLL
function eyelink_quiet_mode(mode: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_poll_trackers: INT16; ELCALLTYPE ELDLL
function eyelink_poll_remotes: INT16; ELCALLTYPE ELDLL
function eyelink_poll_responses: INT16; ELCALLTYPE ELDLL
function eyelink_get_node(resp: INT16; data: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_node_send(var node: ELINKADDR; data: Pointer; dsize: UINT16): INT16; ELCALLTYPE ELDLL
function eyelink_node_receive(var node: ELINKADDR; data: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_send_command(text: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_command_result: INT16; ELCALLTYPE ELDLL
function eyelink_timed_command(msec: UINT32; text: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_last_message(buf: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_send_message(msg: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_node_send_message(var node: ELINKADDR; msg: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_send_message_ex(exectime: UINT32; msg: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_node_send_message_ex(exectime: UINT32; var node: ELINKADDR; msg: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_read_request(text: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_read_reply(buf: PChar): INT16; ELCALLTYPE ELDLL
function eyelink_request_time: UINT32; ELCALLTYPE ELDLL
function eyelink_node_request_time(var node: ELINKADDR): UINT32; ELCALLTYPE ELDLL
function eyelink_read_time: UINT32; ELCALLTYPE ELDLL
function eyelink_abort: INT16; ELCALLTYPE ELDLL
function eyelink_start_setup: INT16; ELCALLTYPE ELDLL
procedure eyelink_set_tracker_setup_default(mode: INT16); ELCALLTYPE ELDLL
function eyelink_in_setup: INT16; ELCALLTYPE ELDLL
function eyelink_target_check(var x, y: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_target_checkf(var x, y: Single): INT16; ELCALLTYPE ELDLL
function eyelink_accept_trigger: INT16; ELCALLTYPE ELDLL
function eyelink_driftcorr_start(x, y: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_driftcorr_startf(x, y: Single): INT16; ELCALLTYPE ELDLL
function eyelink_cal_result: INT16; ELCALLTYPE ELDLL
function eyelink_apply_driftcorr: INT16; ELCALLTYPE ELDLL
function eyelink_cal_message(msg: PChar): INT16; ELCALLTYPE ELDLL

const
  IN_DISCONNECT_MODE = 16384;
  IN_UNKNOWN_MODE = 0;
  IN_IDLE_MODE = 1;
  IN_SETUP_MODE = 2;
  IN_RECORD_MODE = 4;
  IN_TARGET_MODE = 8;
  IN_DRIFTCORR_MODE = 16;
  IN_IMAGE_MODE = 32;
  IN_USER_MENU = 64;
  IN_PLAYBACK_MODE = 256;

function eyelink_current_mode: INT16; ELCALLTYPE ELDLL

const
  EL_IDLE_MODE = 1;
  EL_IMAGE_MODE = 2;
  EL_SETUP_MENU_MODE = 3;
  EL_USER_MENU_1 = 5;
  EL_USER_MENU_2 = 6;
  EL_USER_MENU_3 = 7;
  EL_OPTIONS_MENU_MODE = 8;
  EL_OUTPUT_MENU_MODE = 9;
  EL_DEMO_MENU_MODE = 10;
  EL_CALIBRATE_MODE = 11;
  EL_VALIDATE_MODE = 12;
  EL_DRIFT_CORR_MODE = 13;
  EL_RECORD_MODE = 14;
  SCENECAM_ALIGN_MODE = 15;
  SCENECAM_DEPTH_MODE = 16;

function USER_MENU_NUMBER(mode: INT16): INT16; inline;

function eyelink_tracker_mode: INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_mode_ready(maxwait: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_user_menu_selection: INT16; ELCALLTYPE ELDLL

const
  SAMPLE_TYPE = 200;

function eyelink_position_prescaler: INT16; ELCALLTYPE ELDLL
function eyelink_reset_data(clear: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_in_data_block(samples, events: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_block_start(maxwait: UINT32; samples, events: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_get_next_data(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_get_last_data(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_newest_sample(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_get_float_data(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_get_all_float_data(buf: Pointer; bufferlen: Integer): INT16; ELCALLTYPE ELDLL
function eyelink_get_double_data(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_newest_float_sample(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_newest_double_sample(buf: Pointer): INT16; ELCALLTYPE ELDLL
function eyelink_eye_available: INT16; ELCALLTYPE ELDLL
function eyelink_sample_data_flags: UINT16; ELCALLTYPE ELDLL
function eyelink_event_data_flags: UINT16; ELCALLTYPE ELDLL
function eyelink_event_type_flags: UINT16; ELCALLTYPE ELDLL
function eyelink_data_count(samples, events: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_data(maxwait: UINT32; samples, events: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_get_sample(sample: Pointer): INT16; ELCALLTYPE ELDLL

const
  RECORD_FILE_SAMPLES = 1;
  RECORD_FILE_EVENTS = 2;
  RECORD_LINK_SAMPLES = 4;
  RECORD_LINK_EVENTS = 8;

function eyelink_data_switch(flags: UINT16): INT16; ELCALLTYPE ELDLL
function eyelink_data_start(flags: UINT16; lock: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_data_stop: INT16; ELCALLTYPE ELDLL
function eyelink_playback_start: INT16; ELCALLTYPE ELDLL
function eyelink_playback_stop: INT16; ELCALLTYPE ELDLL

const
  ELIMAGE_2 = 0;
  ELIMAGE_16 = 1;
  ELIMAGE_16P = 2;
  ELIMAGE_256 = 3;
  ELIMAGE_128HV = 4;
  ELIMAGE_128HVX = 5;

function eyelink_request_image(&type, xsize, ysize: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_image_status: INT16; ELCALLTYPE ELDLL
procedure eyelink_abort_image; ELCALLTYPE ELDLL
function eyelink_image_data(xsize, ysize, &type: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_get_line(buf: Pointer): INT16; ELCALLTYPE ELDLL

type
  IMAGE_PALDATA = record
    palette_id: Byte;
    ncolors: Byte;
    camera: Byte;
    threshold: Byte;
    flags: Word;
    image_number: Word;
    extra: array[0..9] of Byte;
    rfirst_color: Byte;
    rfirst_brite: Byte;
    rlast_color: Byte;
    rlast_brite: Byte;
    nspecial: INT16;
    spcolors: array[0..5] of record
      index: Byte;
      r: Byte;
      g: Byte;
      b: Byte;
    end;
  end;

function eyelink_get_palette(pal: Pointer): INT16; ELCALLTYPE ELDLL

const
  KB_PRESS = 10;
  KB_RELEASE = -1;
  KB_REPEAT = 1;

const
  NUM_LOCK_ON = $20;
  CAPS_LOCK_ON = $40;
  ALT_KEY_DOWN = $08;
  CTRL_KEY_DOWN = $04;
  SHIFT_KEY_DOWN = $03;
  KB_BUTTON = $FF00;
  F1_KEY = $3B00;
  F2_KEY = $3C00;
  F3_KEY = $3D00;
  F4_KEY = $3E00;
  F5_KEY = $3F00;
  F6_KEY = $4000;
  F7_KEY = $4100;
  F8_KEY = $4200;
  F9_KEY = $4300;
  F10_KEY = $4400;
  F11_KEY = $4500;
  F12_KEY = $4600;
  PAGE_UP = $4900;
  PAGE_DOWN = $5100;
  CURS_UP = $4800;
  CURS_DOWN = $5000;
  CURS_LEFT = $4B00;
  CURS_RIGHT = $4D00;
  ESC_KEY = $001B;
  ENTER_KEY = $000D;
  PLUS_KEY = $002B;
  MINUS_KEY = $002D;
  INSERT_KEY = $5200;
  DELETE_KEY = $5300;
  HOME_KEY = $4700;
  END_KEY = $4F00;
  BACKSPACE_KEY = $0008;
  PRINTSCR_KEY = $2A00;
  WMENU_KEY = $5D00;
  WLEFT_KEY = $5B00;
  WRIGHT_KEY = $5C00;

function eyelink_read_keybutton(var mods, state: INT16; var kcode: UINT16; var time: UINT32): UINT16; ELCALLTYPE ELDLL
function eyelink_send_keybutton(code, mods: UINT16; state: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_button_states: UINT16; ELCALLTYPE ELDLL
function eyelink_last_button_states(var time: UINT32): UINT16; ELCALLTYPE ELDLL
function eyelink_last_button_press(var time: UINT32): UINT16; ELCALLTYPE ELDLL
function eyelink_flush_keybuttons(enable_buttons: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_request_file_read(src: PChar): INT16; ELCALLTYPE ELDLL

const
  FILE_XFER_ABORTED = -110;
  FILE_CANT_OPEN = -111;
  FILE_NO_REPLY = -112;
  FILE_BAD_DATA = -113;
  FILEDATA_SIZE_FLAG = 999;
  FILE_BLOCK_SIZE = 512;

function eyelink_get_file_block(buf: Pointer; var offset: INT32): INT16; ELCALLTYPE ELDLL
function eyelink_request_file_block(offset: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_end_file_transfer: INT16; ELCALLTYPE ELDLL
function eyelink_get_tracker_version(c: PChar): INT16; ELCALLTYPE ELDLL
function eyelink2_mode_data(var sample_rate, crmode, file_filter, link_filter: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_mode_data(var sample_rate, crmode, file_filter, link_filter: INT16): INT16; ELCALLTYPE ELDLL
function eyelink_bitmap_packet(data: Pointer; size, seq: UINT16): INT16; ELCALLTYPE ELDLL
function eyelink_bitmap_ack_count: INT16; ELCALLTYPE ELDLL

const
  ABORT_BX = -32000;
  PAUSE_BX = -32001;
  DONE_BX = -32002;

procedure eyelink_set_tracker_node(var node: ELINKADDR); ELCALLTYPE ELDLL
function eyelink_tracker_double_usec: Double; ELCALLTYPE ELDLL
function eyelink_tracker_msec: UINT32; ELCALLTYPE ELDLL

function eyelink_double_usec_offset: Double; ELCALLTYPE ELDLL
function eyelink_msec_offset: UINT32; ELCALLTYPE ELDLL
function eyelink_time_offset: UINT32; inline;

function eyelink_wait_for_next_data(buf: PALLF_DATA; bufferlen: Integer; timeout: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_new_sample(buf: PISAMPLE; timeout: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_new_float_sample(buf: PFSAMPLE; timeout: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_new_double_sample(buf: PDSAMPLE; timeout: UINT32): INT16; ELCALLTYPE ELDLL
function eyelink_wait_for_command_result(timeout: UINT32): INT16; ELCALLTYPE ELDLL

type
  EYELINK_DATA_READY_NOTIFY = procedure(data: Integer);

function eyelink_set_data_ready_notify(notify_function: EYELINK_DATA_READY_NOTIFY): INT16; ELCALLTYPE ELDLL
function eyelink_get_data_ready_notify: EYELINK_DATA_READY_NOTIFY; ELCALLTYPE ELDLL

function eyelink_tracker_time: UINT32; inline;


implementation

function USER_MENU_NUMBER(mode: INT16): INT16;
begin
  Result := mode - 4;
end;

function eyelink_time_offset: UINT32;
begin
  Result := eyelink_msec_offset;
end;

function eyelink_tracker_time: UINT32;
begin
  Result := eyelink_tracker_msec;
end;

end.
