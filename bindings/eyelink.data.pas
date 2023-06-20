{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.data;

{$mode ObjFPC}{$H+}

interface

uses eyelink.types;

const
  MISSING_DATA = -32768;
  MISSING = -32768;
  INaN = -32768;
  LEFT_EYE = 0;
  RIGHT_EYE = 1;
  LEFTEYEI = 0;
  RIGHTEYEI = 1;
  LEFT = 0;
  RIGHT = 1;
  BINOCULAR = 2;
  SAMPLE_LEFT = $8000;
  SAMPLE_RIGHT = $4000;
  SAMPLE_TIMESTAMP = $2000;
  SAMPLE_PUPILXY = $1000;
  SAMPLE_HREFXY = $0800;
  SAMPLE_GAZEXY = $0400;
  SAMPLE_GAZERES = $0200;
  SAMPLE_PUPILSIZE = $0100;
  SAMPLE_STATUS = $0080;
  SAMPLE_INPUTS = $0040;
  SAMPLE_BUTTONS = $0020;
  SAMPLE_HEADPOS = $0010;
  SAMPLE_TAGGED = $0008;
  SAMPLE_UTAGGED = $0004;
  SAMPLE_ADD_OFFSET = $0002;

type
  PISAMPLE = ^ISAMPLE;
  ISAMPLE = record
    time: UINT32;
    &type: INT16;
    flags: UINT16;
    px: array[0..1] of INT16;
    py: array[0..1] of INT16;
    hx: array[0..1] of INT16;
    hy: array[0..1] of INT16;
    pa: array[0..1] of UINT16;
    gx: array[0..1] of INT16;
    gy: array[0..1] of INT16;
    rx: INT16;
    ry: INT16;
    status: UINT16;
    input: UINT16;
    buttons: UINT16;
    htype: INT16;
    hdata: array[0..7] of INT16;
  end;

  PFSAMPLE = ^FSAMPLE;
  FSAMPLE = record
    time: UINT32;
    &type: INT16;
    flags: UINT16;
    px: array[0..1] of FLOAT;
    py: array[0..1] of FLOAT;
    hx: array[0..1] of FLOAT;
    hy: array[0..1] of FLOAT;
    pa: array[0..1] of FLOAT;
    gx: array[0..1] of FLOAT;
    gy: array[0..1] of FLOAT;
    rx: FLOAT;
    ry: FLOAT;
    status: UINT16;
    input: UINT16;
    buttons: UINT16;
    htype: INT16;
    hdata: array[0..7] of INT16;
  end;

  PDSAMPLE = ^DSAMPLE;
  DSAMPLE = record
    time: Double;
    _type: INT16;
    flags: UINT16;
    px: array[0..1] of FLOAT;
    py: array[0..1] of FLOAT;
    hx: array[0..1] of FLOAT;
    hy: array[0..1] of FLOAT;
    pa: array[0..1] of FLOAT;
    gx: array[0..1] of FLOAT;
    gy: array[0..1] of FLOAT;
    rx: FLOAT;
    ry: FLOAT;
    status: UINT16;
    input: UINT16;
    buttons: UINT16;
    htype: INT16;
    hdata: array[0..7] of INT16;
  end;

  PFSAMPLE_RAW = ^FSAMPLE_RAW;
  FSAMPLE_RAW = record
    struct_size: UINT32;
    raw_pupil: array[0..1] of FLOAT;
    raw_cr: array[0..1] of FLOAT;
    pupil_area: UINT32;
    cr_area: UINT32;
    pupil_dimension: array[0..1] of UINT32;
    cr_dimension: array[0..1] of UINT32;
    window_position: array[0..1] of UINT32;
    pupil_cr: array[0..1] of FLOAT;
    cr_area2: UINT32;
    raw_cr2: array[0..1] of FLOAT;
  end;

  PIEVENT = ^IEVENT;
  IEVENT = record
    time: UINT32;
    _type: INT16;
    read: UINT16;
    eye: INT16;
    sttime: UINT32;
    entime: UINT32;
    hstx: INT16;
    hsty: INT16;
    gstx: INT16;
    gsty: INT16;
    sta: UINT16;
    henx: INT16;
    heny: INT16;
    genx: INT16;
    geny: INT16;
    ena: UINT16;
    havx: INT16;
    havy: INT16;
    gavx: INT16;
    gavy: INT16;
    ava: UINT16;
    avel: INT16;
    pvel: INT16;
    svel: INT16;
    evel: INT16;
    supd_x: INT16;
    eupd_x: INT16;
    supd_y: INT16;
    eupd_y: INT16;
    status: UINT16;
  end;

  PFEVENT = ^FEVENT;
  FEVENT = record
    time: UINT32;
    &type: INT16;
    read: UINT16;
    eye: INT16;
    sttime: UINT32;
    entime: UINT32;
    hstx: float;
    hsty: float;
    gstx: float;
    gsty: float;
    sta: float;
    henx: float;
    heny: float;
    genx: float;
    geny: float;
    ena: float;
    havx: float;
    havy: float;
    gavx: float;
    gavy: float;
    ava: float;
    avel: float;
    pvel: float;
    svel: float;
    evel: float;
    supd_x: float;
    eupd_x: float;
    supd_y: float;
    eupd_y: float;
    status: UINT16;
  end;

  PDEVENT = ^DEVENT;
  DEVENT = record
    time: double;
    &type: INT16;
    read: UINT16;
    eye: INT16;
    sttime: double;
    entime: double;
    hstx: float;
    hsty: float;
    gstx: float;
    gsty: float;
    sta: float;
    henx: float;
    heny: float;
    genx: float;
    geny: float;
    ena: float;
    havx: float;
    havy: float;
    gavx: float;
    gavy: float;
    ava: float;
    avel: float;
    pvel: float;
    svel: float;
    evel: float;
    supd_x: float;
    eupd_x: float;
    supd_y: float;
    eupd_y: float;
    status: UINT16;
  end;

  PIMESSAGE = ^IMESSAGE;
  IMESSAGE = record
    time: UINT32;
    &type: INT16;
    length: UINT16;
    text: array[0..259] of byte;
  end;

  PDMESSAGE = ^DMESSAGE;
  DMESSAGE = record
    time: double;
    &type: INT16;
    length: UINT16;
    text: array[0..259] of byte;
  end;

  PIOEVENT = ^IOEVENT;
  IOEVENT = record
    time: UINT32;
    &type: INT16;
    data: UINT16;
  end;

  PDIOEVENT = ^DIOEVENT;
  DIOEVENT = record
    time: double;
    &type: INT16;
    data: UINT16;
  end;

  PALL_DATA = ^ALL_DATA;
  ALL_DATA = record
    case Integer of
      0: (ie: IEVENT);
      1: (im: IMESSAGE);
      2: (io: IOEVENT);
      3: (&is: ISAMPLE);
  end;

  PALLF_DATA = ^ALLF_DATA;
  ALLF_DATA = record
    case Integer of
      0: (fe: FEVENT);
      1: (im: IMESSAGE);
      2: (io: IOEVENT);
      3: (fs: FSAMPLE);
  end;

  PAALLD_DATA = ^ALLD_DATA;
  ALLD_DATA = record
    case Integer of
      0: (fe: DEVENT);
      1: (im: DMESSAGE);
      2: (io: DIOEVENT);
      3: (fs: DSAMPLE);
  end;

const
  SAMPLE_TYPE = 200;
  STARTPARSE = 1;
  ENDPARSE = 2;
  BREAKPARSE = 10;
  STARTBLINK = 3;
  ENDBLINK = 4;
  STARTSACC = 5;
  ENDSACC = 6;
  STARTFIX = 7;
  ENDFIX = 8;
  FIXUPDATE = 9;
  STARTSAMPLES = 15;
  ENDSAMPLES = 16;
  STARTEVENTS = 17;
  ENDEVENTS = 18;
  MESSAGEEVENT = 24;
  BUTTONEVENT = 25;
  INPUTEVENT = 28;
  LOST_DATA_EVENT = $3F;
  ISAMPLE_BUFFER = SAMPLE_TYPE;
  IEVENT_BUFFER = 66;
  IOEVENT_BUFFER = 8;
  IMESSAGE_BUFFER = 250;
  CONTROL_BUFFER = 36;
  ILINKDATA_BUFFER = CONTROL_BUFFER;
  READ_ENDTIME = $0040;
  READ_GRES = $0200;
  READ_SIZE = $0080;
  READ_VEL = $0100;
  READ_STATUS = $2000;
  READ_BEG = $0001;
  READ_END = $0002;
  READ_AVG = $0004;
  READ_PUPILXY = $0400;
  READ_HREFXY = $0800;
  READ_GAZEXY = $1000;
  READ_BEGPOS = $0008;
  READ_ENDPOS = $0010;
  READ_AVGPOS = $0020;
  FRIGHTEYE_EVENTS = $8000;
  FLEFTEYE_EVENTS = $4000;
  LEFTEYE_EVENTS = $8000;
  RIGHTEYE_EVENTS = $4000;
  BLINK_EVENTS = $2000;
  FIXATION_EVENTS = $1000;
  FIXUPDATE_EVENTS = $0800;
  SACCADE_EVENTS = $0400;
  MESSAGE_EVENTS = $0200;
  BUTTON_EVENTS = $0040;
  INPUT_EVENTS = $0020;
  EVENT_VELOCITY = $8000;
  EVENT_PUPILSIZE = $4000;
  EVENT_GAZERES = $2000;
  EVENT_STATUS = $1000;
  EVENT_GAZEXY = $0400;
  EVENT_HREFXY = $0200;
  EVENT_PUPILXY = $0100;
  FIX_AVG_ONLY = $0008;
  START_TIME_ONLY = $0004;
  PARSEDBY_GAZE = $00C0;
  PARSEDBY_HREF = $0080;
  PARSEDBY_PUPIL = $0040;

const
  ELNAMESIZE = 40;
  ELREMBUFSIZE = 420;
  ELINKADDRSIZE = 16;

type
  PELINKADDR = ^ELINKADDR;
  ELINKADDR = array[0..ELINKADDRSIZE-1] of Byte;

  PELINKNODE = ^ELINKNODE;
  ELINKNODE = record
    addr: ELINKADDR;
    name: array[0..ELNAMESIZE-1] of Char;
  end;

  PILINKDATA = ^ILINKDATA;
  ILINKDATA = record
    time: UINT32;
    version: UINT32;

    samrate: Word;
    samdiv: Word;

    prescaler: Word;
    vprescaler: Word;
    pprescaler: Word;
    hprescaler: Word;

    sample_data: Word;
    event_data: Word;
    event_types: Word;

    in_sample_block: Byte;
    in_event_block: Byte;
    have_left_eye: Byte;
    have_right_eye: Byte;

    last_data_gap_types: Word;
    last_data_buffer_type: Word;
    last_data_buffer_size: Word;

    control_read: Word;
    first_in_block: Word;

    last_data_item_time: UINT32;
    last_data_item_type: Word;
    last_data_item_contents: Word;

    last_data_item: ALL_DATA;

    block_number: UINT32;
    block_sample: UINT32;
    block_event: UINT32;

    last_resx: Word;
    last_resy: Word;
    last_pupil: array[0..1] of Word;
    last_status: Word;

    queued_samples: Word;
    queued_events: Word;

    queue_size: Word;
    queue_free: Word;

    last_rcve_time: UINT32;

    samples_on: Byte;
    events_on: Byte;

    packet_flags: Word;

    link_flags: Word;
    state_flags: Word;
    link_dstatus: Byte;
    link_pendcmd: Byte;
    reserved: Word;

    our_name: array[0..ELNAMESIZE-1] of Char;
    our_address: ELINKADDR;
    eye_name: array[0..ELNAMESIZE-1] of Char;
    eye_address: ELINKADDR;

    ebroadcast_address: ELINKADDR;
    rbroadcast_address: ELINKADDR;

    polling_remotes: Word;
    poll_responses: Word;
    nodes: array[0..3] of ELINKNODE;
  end;

const
  PUPIL_DIA_FLAG = $0001;
  HAVE_SAMPLES_FLAG = $0002;
  HAVE_EVENTS_FLAG = $0004;
  HAVE_LEFT_FLAG = $8000;
  HAVE_RIGHT_FLAG = $4000;
  DROPPED_SAMPLE = $8000;
  DROPPED_EVENT = $4000;
  DROPPED_CONTROL = $2000;
  DFILE_IS_OPEN = $80;
  DFILE_EVENTS_ON = $40;
  DFILE_SAMPLES_ON = $20;
  DLINK_EVENTS_ON = $08;
  DLINK_SAMPLES_ON = $04;
  DRECORD_ACTIVE = $01;
  COMMAND_FULL_WARN = $01;
  MESSAGE_FULL_WARN = $02;
  LINK_FULL_WARN = $04;
  FULL_WARN = $0F;
  LINK_CONNECTED = $10;
  LINK_BROADCAST = $20;
  LINK_IS_TCPIP = $40;
  LED_TOP_WARNING = $0080;
  LED_BOT_WARNING = $0040;
  LED_LEFT_WARNING = $0020;
  LED_RIGHT_WARNING = $0010;
  HEAD_POSITION_WARNING = $00F0;
  LED_EXTRA_WARNING = $0008;
  LED_MISSING_WARNING = $0004;
  HEAD_VELOCITY_WARNING = $0001;
  CALIBRATION_AREA_WARNING = $0002;
  MATH_ERROR_WARNING = $2000;
  INTERP_SAMPLE_WARNING = $1000;
  INTERP_PUPIL_WARNING = $8000;
  CR_WARNING = $0F00;
  CR_LEFT_WARNING = $0500;
  CR_RIGHT_WARNING = $0A00;
  CR_LOST_WARNING = $0300;
  CR_LOST_LEFT_WARNING = $0100;
  CR_LOST_RIGHT_WARNING = $0200;
  CR_RECOV_WARNING = $0C00;
  CR_RECOV_LEFT_WARNING = $0400;
  CR_RECOV_RIGHT_WARNING = $0800;
  HPOS_TOP_WARNING = $0080;
  HPOS_BOT_WARNING = $0040;
  HPOS_LEFT_WARNING = $0020;
  HPOS_RIGHT_WARNING = $0010;
  HPOS_WARNING = $00F0;
  HPOS_ANGLE_WARNING = $0008;
  HPOS_MISSING_WARNING = $0004;
  HPOS_DISTANCE_WARNING = $0001;
  TFLAG_MISSING = $4000;
  TFLAG_ANGLE = $2000;
  TFLAG_NEAREYE = $1000;
  TFLAG_CLOSE = $0800;
  TFLAG_FAR = $0400;
  TFLAG_T_TSIDE = $0080;
  TFLAG_T_BSIDE = $0040;
  TFLAG_T_LSIDE = $0020;
  TFLAG_T_RSIDE = $0010;
  TFLAG_E_TSIDE = $0008;
  TFLAG_E_BSIDE = $0004;
  TFLAG_E_LSIDE = $0002;
  TFLAG_E_RSIDE = $0001;

implementation

end.

