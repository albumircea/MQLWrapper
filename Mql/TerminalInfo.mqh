//+------------------------------------------------------------------+
//|                                                     Terminal.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

#include "MqlInfo.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTerminal
  {
public:

   static bool       IsStopped_() {return ::IsStopped();}
   static bool       IsConnected_() {return (bool) TerminalInfoInteger(TERMINAL_CONNECTED);}

   static bool       HasCommunityAccount() {return (bool)TerminalInfoInteger(TERMINAL_COMMUNITY_ACCOUNT);}
   static bool       IsCommunityConnected() {return (bool)TerminalInfoInteger(TERMINAL_COMMUNITY_CONNECTION);}
   static double     GetCommunityBalance() {return (bool)TerminalInfoDouble(TERMINAL_COMMUNITY_BALANCE);}

   static string     GetPath() {return TerminalInfoString(TERMINAL_PATH);}
   static string     GetDataPath() {return TerminalInfoString(TERMINAL_DATA_PATH);}
   static string     GetCommonDataPath() {return TerminalInfoString(TERMINAL_COMMONDATA_PATH);}

   static int        GetCpuCores() {return TerminalInfoInteger(TERMINAL_CPU_CORES);}
   static int        GetDiskSpace() {return TerminalInfoInteger(TERMINAL_DISK_SPACE);}
   static int        GetPhysicalMemory() {return TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL);}

   static int        GetTotalMemory() {return TerminalInfoInteger(TERMINAL_MEMORY_TOTAL);}
   static int        GetFreeMemory() {return TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE);}
   static int        GetUsedMemory() {return TerminalInfoInteger(TERMINAL_MEMORY_USED);}

   static int        GetTerminalBuild() {return TerminalInfoInteger(TERMINAL_BUILD);}
   static string     GetTerminalName() {return TerminalInfoString(TERMINAL_NAME);}
   static string     GetTerminalCompany() {return TerminalInfoString(TERMINAL_COMPANY);}
   static string     GetTerminalLanguage() {return TerminalInfoString(TERMINAL_LANGUAGE);}

   static bool       IsDllAllowed() {return (bool)TerminalInfoInteger(TERMINAL_DLLS_ALLOWED);}
   static bool       IsTradeAllowed_() {return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);}
   static bool       IsEmailEnabled() {return (bool)TerminalInfoInteger(TERMINAL_EMAIL_ENABLED);}
   static bool       IsFtpEnabled() {return (bool)TerminalInfoInteger(TERMINAL_FTP_ENABLED);}

   static bool       IsNotificationsEnabled() {return (bool)TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED);}
   static bool       HasMetaQuotesId() {return (bool)TerminalInfoInteger(TERMINAL_MQID);}
   static bool       Notify(string msg);
   static bool       Mail(string subject, string content);

   static int        GetScreenDpi() {return TerminalInfoInteger(TERMINAL_SCREEN_DPI);}
   static bool       IsX64() { return((bool)TerminalInfoInteger(TERMINAL_X64));  }


   static long       InfoInteger(const ENUM_TERMINAL_INFO_INTEGER prop_id) { return(TerminalInfoInteger(prop_id));}

   static string     InfoString(const ENUM_TERMINAL_INFO_STRING prop_id) { return(TerminalInfoString(prop_id));}

   static double     InfoDouble(const ENUM_TERMINAL_INFO_DOUBLE prop_id) { return(TerminalInfoDouble(prop_id));}


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTerminal::Notify(string msg)
  {
   int len = StringLen(msg);

   if(len == 0 || len > 255)
     {
      Alert("ERROR: [", __FUNCTION__, "] Notification message is empty or larger than 255 characters.");
      return false;
     }

   if(IsNotificationsEnabled() && HasMetaQuotesId())
     {
      bool success = SendNotification(msg);
      if(!success)
        {
         Alert("ERROR: [", __FUNCTION__, "] ", CMQLInfo::GetErrorMessage(CMQLInfo::GetLastError_()));
        }
      return success;
     }
   else
     {
      Alert("ERROR: [", __FUNCTION__, "] Notification is not enabled or MetaQuotes ID is not set.");
      return false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTerminal::Mail(string subject, string content)
  {
   if(CTerminal::IsEmailEnabled())
     {
      if(!SendMail(subject, content))
        {
         int code = CMQLInfo::GetLastError_();
         Alert(">>> Sending mail failed with error %d: %s", code, CMQLInfo::GetErrorMessage(code));
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
