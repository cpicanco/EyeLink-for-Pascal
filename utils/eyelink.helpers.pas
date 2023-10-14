{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
unit eyelink.helpers;

{$mode ObjFPC}{$H+}

{$modeswitch TypeHelpers}

interface

uses
  Classes, SysUtils;

type
  { TEyeLinkStringHelper }

  TEyeLinkStringHelper = type helper(TStringHelper) for string
    function ToPchar : PChar;
  end;

implementation

{ TEyeLinkStringHelper }

function TEyeLinkStringHelper.ToPchar: PChar;
begin
  Result := PChar(Self);
end;

end.

