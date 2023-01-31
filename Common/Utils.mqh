//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"



#include <WinUser32.mqh>
#import "user32.dll"
int             GetAncestor(int, int);
#import


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtils
 {
public:
  static void        EnableHistory();
 };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static void CUtils::EnableHistory(void)
 {

#ifdef __MQL4__
#define GA_ROOT 2
#define MT4_WMCMD_ALL_HISTORY 33058  //All History
  int main  = GetAncestor(WindowHandle(Symbol(), Period()), GA_ROOT);
  int res   = PostMessageA(main, WM_COMMAND, MT4_WMCMD_ALL_HISTORY, 0);
#endif


#ifdef __MQL5__
  if(!HistorySelect(0, D'3000.01.01'))
    LOG_ERROR("Could not load all History");
#endif
 }
//+------------------------------------------------------------------+
