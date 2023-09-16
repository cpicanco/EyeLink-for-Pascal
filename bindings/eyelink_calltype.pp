{
  EyeLink-for-Pascal
  Copyright (C) 2023 Carlos Rafael Fernandes Picanço.
  MIT License
}
// for calling conventions
// see https://www.freepascal.org/docs-html/prog/progse22.html
{$MACRO ON}

{$IFDEF Win64}
  {$ALIGN 16}
{$ELSEIF Win32}
  {$ALIGN 8}
{$ENDIF}

{$IFNDEF EYELINK_STATIC_LINK}
  {$DEFINE ELDLL := external EYELINK_DLL_NAME;}
{$ELSE}
  {$DEFINE ELDLL := external;}
{$ENDIF}

{$ifndef ELCALLTYPE}
  {$DEFINE ELCALLTYPE := winapi;}
{$endif}
