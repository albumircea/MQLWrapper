//+------------------------------------------------------------------+
//|                                                       Logger.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

/*
TODO
 - Add datetime to file logger
 - Pot sa fac cand am eroare la functii sa returnez {Retcode,erroare} si sa fac in lant treaba asta si pot sa fac chain si sa returnez si callstacku

 C:\Users\album\AppData\Roaming\MetaQuotes\Terminal\B2D2C5F3728E8E65B5A214395027FCD4\MQL5\Include\_profitpoint\Mql\ErrorDescriptor.mqh
*/


/*
https://www.mql5.com/en/code/35112

// You need to do the customization before the include statement

// Logger level customization
#define LOGGER_SET_DEBUG 1       // Print
#define LOGGER_SET_INFO  1|2     // Print and alert
#define LOGGER_SET_ERROR 1|2|4   // Print, alert and file write

// Logger prefix custmization
#define LOGGER_PREFIX __FILE__ + " | Line:" + IntegerToString(__LINE__) // [filename] | [Line number]

// Logger file name customization
#define LOGGER_FILENAME "backtest_debug.log"
#include <Logger.mqh>


*/
#include <Mircea/_profitpoint\Mql\ErrorDescriptor.mqh>
//#define LOG(text)  Print(__FILE__,"(",__LINE__,") :",text)
#define LOG_FAST(message) PrintFormat("---FAST_LOG--- %s, %i: %s", __FILE__, __LINE__, message)


//--- Logging format
// [time, except LOGGER_PRINT,LOGGER_ALERT] [level] [prefix] [message] [last error, only Logger::Error]

//--- Logging options
/*
You will not be able to able to use logging options
defines unless must be shifted to another header file that
must be included before this file
*/




#define LOGGER_PRINT    1     // print to log
#define LOGGER_ALERT    2     // trigger alert
#define LOGGER_FILE     4     // write to a file
#define LOGGER_NOTIFY   8     // send a notification


//--- Logging defaults - level configs
#ifndef LOGGER_SET_DEBUG
#define LOGGER_SET_DEBUG LOGGER_PRINT | LOGGER_FILE
#endif

#ifdef __MQL4__
#define FILE_EXTENSION ".mq4"
#else
#define FILE_EXTENSION ".mq5"
#endif

#ifndef LOGGER_SET_INFO
#define LOGGER_SET_INFO LOGGER_PRINT
#endif

#ifndef LOGGER_SET_ERROR
#define LOGGER_SET_ERROR LOGGER_PRINT | LOGGER_FILE
#endif

//--- Logging defaults - Prefix
#ifndef LOGGER_PREFIX_INFO
#define LOGGER_PREFIX_INFO StringFormat("[%s",__FILE__)
#endif

#ifndef LOGGER_PREFIX_DEBUG
#define LOGGER_PREFIX_DEBUG StringFormat("[%s::%s::%s]",__FILE__,__FUNCTION__,IntegerToString(__LINE__))
#endif

#ifndef LOGGER_PREFIX_ERROR
#define LOGGER_PREFIX_ERROR StringFormat("[%s::%s::%s]",__FILE__,__FUNCTION__,IntegerToString(__LINE__))
#endif

//--- Logging defaults - log file name
#ifndef LOGGER_FILENAME
#define LOGGER_FILENAME StringFormat("%s_%s.log", StringSubstr(__FILE__, 0, StringLen(__FILE__) - StringLen(FILE_EXTENSION)), _Symbol)
#endif

//--- logging levels
#define LOGGER_LEVEL_DEBUG 0
#define LOGGER_LEVEL_INFO  1
#define LOGGER_LEVEL_ERROR 3

//-- Easy Functions to use
#define  LOG_DEBUG(text)  CLogger::_Debug(LOGGER_PREFIX_DEBUG,text,LOGGER_FILENAME)
#define  LOG_INFO(text) CLogger::_Info(LOGGER_PREFIX_INFO,text, LOGGER_FILENAME)
#define  LOG_ERROR(text) CLogger::_Error(LOGGER_PREFIX_ERROR,text,LOGGER_FILENAME)
/*
TODO PASS BY REFERENCE la stringuri
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CLogger
 {
public:
  static void        _Debug(string prefix, string msg, string fileName);
  static void        _Info(string prefix, string msg, string fileName);
  static void        _Error(string prefix, string msg, string fileName);

private:
  static void        Log(int level, string msg, string fileName);
  static void        File(string fileName, string msg);
  static string      prepend_time(string msg);

 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CLogger::_Debug(string prefix, string msg, string fileName)
 {

  if((LOGGER_SET_DEBUG) != 0)
    Log(LOGGER_LEVEL_DEBUG, StringFormat("[DEBUG]| %s | %s", prefix, msg), fileName);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CLogger::_Info(string prefix, string msg, string fileName)
 {
  if((LOGGER_SET_INFO) != 0)
    Log(LOGGER_LEVEL_INFO, StringFormat("[INFO] | %s | %s", prefix, msg), fileName);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CLogger::_Error(string prefix, string msg, string fileName)
 {
  if((LOGGER_SET_ERROR) != 0)
    Log(LOGGER_LEVEL_ERROR, StringFormat("[ERROR] | %s | %s ", prefix, msg), fileName);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CLogger::Log(int level, string msg, string fileName)
 {
  int options;
  switch(level)
   {
    case LOGGER_LEVEL_DEBUG:
      options = LOGGER_SET_DEBUG;
      break;
    case LOGGER_LEVEL_INFO:
      options = LOGGER_SET_INFO;
      break;
    case LOGGER_LEVEL_ERROR:
      options = LOGGER_SET_ERROR;
      break;
    default:
      options = 0;
      break;
   }

  if((options & LOGGER_PRINT) == LOGGER_PRINT)
    Print(msg);

  if((options & LOGGER_ALERT) == LOGGER_ALERT)
    Alert(msg);

  if((options & LOGGER_FILE) == LOGGER_FILE)
    File(fileName, prepend_time(msg));

  if((options & LOGGER_NOTIFY) == LOGGER_NOTIFY)
    SendNotification(prepend_time(msg));
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CLogger::File(string fileNeme, string msg)
 {
  int handle = FileOpen(fileNeme, FILE_READ | FILE_WRITE | FILE_TXT);
  if(handle == INVALID_HANDLE)
   {
    Print("Logger Error: Log File Open Failed");
    return;
   }

  if(!FileSeek(handle, 0, SEEK_END))
   {
    Print("Logger Error: Log File Seek Failed");
    FileClose(handle);
    return;
   }

  if(FileWrite(handle, msg) == 0)
   {
    Print("Logger Error: Log File Write Failed");
    FileClose(handle);
    return;
   }
  FileClose(handle);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CLogger::prepend_time(string msg)
 {
  return TimeToString(TimeLocal(), TIME_DATE | TIME_SECONDS) + " | " + msg;
 }
//+------------------------------------------------------------------+
