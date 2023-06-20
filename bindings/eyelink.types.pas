{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.types;

{$mode ObjFPC}{$H+}

interface

type

  TEyeLinkSendReceiveProcedure = procedure(size, received: Cardinal);

  FLOAT = Single;

  MICRO = record
    msec: INT32;
    usec: INT16;
  end;

implementation

end.
