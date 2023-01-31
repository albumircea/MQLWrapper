//+------------------------------------------------------------------+
//|                                                      CMQLInfoInfo.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include  "ErrorDescriptor.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMQLInfo
 {
public:
  static int         GetLastError_() {return ::GetLastError();}
  static string      GetErrorMessage(int errorCode) {return ErrorDescription(errorCode);}

  //--- Adapted from stdlib.mq4 by using `StringSetCharacter` instead of `StringSetChar`
  static string      IntegerToHexString(int value);

  //--- Prefer Canvas/Canvas.mqh XRGB
  static int         RGB(int r, int g, int b) {return int(0xFF000000 | (uchar(r) << 16) | (uchar(g) << 8) | uchar(b));}

  //--- Prefer Lang/Number.mqh Double::IsEqual

  static bool        IsStopped_() {return ::IsStopped();}

  static int         GetCodePage() {return MQLInfoInteger(MQL_CODEPAGE);}
  static ENUM_PROGRAM_TYPE getProgramType() {return(ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE);}
  static bool        IsScript() {return CMQLInfo::getProgramType() == PROGRAM_SCRIPT;}
  static bool        IsExpert() {return CMQLInfo::getProgramType() == PROGRAM_EXPERT;}
  static bool        IsIndicator() {return CMQLInfo::getProgramType() == PROGRAM_INDICATOR;}
  static bool        IsDllAllowed() {return MQLInfoInteger(MQL_DLLS_ALLOWED) != 0;}
  static bool        IsTradeAllowed_() {return MQLInfoInteger(MQL_TRADE_ALLOWED) != 0;}
  static bool        IsSignalsAllowed() {return MQLInfoInteger(MQL_SIGNALS_ALLOWED) != 0;}
  static bool        IsDebug() {return MQLInfoInteger(MQL_DEBUG) != 0;}
  static bool        IsProfiling() {return MQLInfoInteger(MQL_PROFILER) != 0;}
  static bool        IsTesting_() {return MQLInfoInteger(MQL_TESTER) != 0;}
  static bool        IsOptimizing() {return MQLInfoInteger(MQL_OPTIMIZATION) != 0;}
  static bool        IsVisual() {return MQLInfoInteger(MQL_VISUAL_MODE) != 0;}
  static bool        IsFrameMode() {return MQLInfoInteger(MQL_FRAME_MODE) != 0;}
  static ENUM_LICENSE_TYPE getLicenseType() {return(ENUM_LICENSE_TYPE)MQLInfoInteger(MQL_LICENSE_TYPE);}
  static bool        IsFreeLicense() {return CMQLInfo::getLicenseType() == LICENSE_FREE;}
  static bool        IsDemoLicense() {return CMQLInfo::getLicenseType() == LICENSE_DEMO;}
  static bool        IsFullLicense() {return CMQLInfo::getLicenseType() == LICENSE_FULL;}
  static bool        IsTimeLicense() {return CMQLInfo::getLicenseType() == LICENSE_TIME;}

  static string      GetProgramName() {return MQLInfoString(MQL_PROGRAM_NAME);}
  static string      GetProgramPath() {return MQLInfoString(MQL_PROGRAM_PATH);}
 };
//+------------------------------------------------------------------+
