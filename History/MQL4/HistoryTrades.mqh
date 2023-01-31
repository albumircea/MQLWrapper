//+------------------------------------------------------------------+
//|                                                HistoryTrades.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

/*
TODO
sa pot filtra dupa ordertype EXECUTION/LIMIT/STOP/ALL
https://www.mql5.com/en/forum/213003 -> Ca sa imi fac extend la CArrayObj pentru obiectul meu :)
*/

#include <Arrays/ArrayObj.mqh>
#include <Mircea/_profitpoint/History/MQL4/HistoryTrade.mqh>
#include <Mircea/_profitpoint/Logger.mqh>


#include <WinUser32.mqh>
#import "user32.dll"
int             GetAncestor(int, int);
#import


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CHistoryTrades
 {
public :
  CArrayObj          *m_history_trades;

public:
                     CHistoryTrades() {m_history_trades = new CArrayObj(); m_history_trades.FreeMode(true); };
                    ~CHistoryTrades() {m_history_trades.Shutdown(); delete m_history_trades; }

  int                enableAllHistory(void);
  void               ingestHistorianTrades();
  CJAVal             getJsonList();
  void               saveTradesToFile(string fileName = "Transactions");

 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CJAVal CHistoryTrades::getJsonList(void)
 {
  CJAVal json_list;
  for(int i = 0; i < m_history_trades.Total(); i++)
   {
    CHistoryTrade *history_trade = m_history_trades.At(i);
    json_list.Add(history_trade.toJson());
   }
  return json_list;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrades::ingestHistorianTrades()
 {
  m_history_trades.Clear();

  for(int index = 0; index < OrdersHistoryTotal(); index++)
   {
    if(!OrderSelect(index, SELECT_BY_POS, MODE_HISTORY))
      continue;

    if(OrderType() != 0 && OrderType() != 1 && OrderType() != 6)
      continue;



    CHistoryTrade *trade_to_add = CHistoryTrade::getHistoryTradeByTicket(OrderTicket());

    if(trade_to_add == NULL)
      continue;

    m_history_trades.Add(trade_to_add);
   }
 }
/*
https://www.mql5.com/ru/forum/110207/page5#401551
Spy++ Visual Studio ?
*/
int CHistoryTrades::enableAllHistory(void)
 {
#define GA_ROOT 2
#define MT4_WMCMD_ALL_HISTORY 33058  //All History
  int main  = GetAncestor(WindowHandle(Symbol(), Period()), GA_ROOT);
  int res   = PostMessageA(main, WM_COMMAND, MT4_WMCMD_ALL_HISTORY, 0);
  return res;
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrades::saveTradesToFile(string fileName = "Transactions")
 {
  string file = StringFormat("%s.json", fileName);
  int handle = FileOpen(file, FILE_WRITE);
  if(handle == INVALID_HANDLE)
   {
    PrintFormat("%s: error#%i", __FUNCTION__, _LastError);
    return;
   }
  FileWriteString(handle, getJsonList().Serialize());
  FileClose(handle);
 }
//+------------------------------------------------------------------+
