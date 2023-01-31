//+------------------------------------------------------------------+
//|                                              HistoryPosition.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"


#include <Arrays/ArrayObj.mqh>
#include <Mircea/_profitpoint/History/MQL5/HistoryTrade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CHistoryTrades
  {


public :
   CArrayObj          *m_history_trades;



public:
                     CHistoryTrades() {m_history_trades = new CArrayObj(); m_history_trades.FreeMode(true); };
                    ~CHistoryTrades() {Destoy();}
   void               Destoy();


   CArrayObj          *getHistoryTrades() {return m_history_trades;}
   bool               reserveArraySize(const int size) {return m_history_trades.Reserve(size);};
   int                totalArraySize() {return m_history_trades.Total();};
   int                availableArraySize() {return m_history_trades.Available();};




   void               enableAllHistory(void);
   void               ingestHistorianTrades(string deals_or_positins);
   CJAVal             getJsonList();
   void               saveTradesToFile(string fileName);
   void               printAllTrades();
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
      //m_history_trades.At(i).toJson();
      //json_list.Add(
     }


   return json_list;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrades::Destoy(void)
  {
   m_history_trades.Shutdown();
   delete m_history_trades;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrades::ingestHistorianTrades(string deals_or_positins)
  {
   m_history_trades.Clear();


   if(deals_or_positins == "positions")
     {
      CHistoryPositionInfo position;

      if(!position.HistorySelect())
         return;

      int totalPositions = position.PositionsTotal();

      for(int index = 0; index < totalPositions; index++)
        {

         if(!position.SelectByIndex(index))
            continue;

         CHistoryTrade *tradeToAdd = CHistoryTrade::GetHistoryTrade(position);
         m_history_trades.Add(tradeToAdd);
        }
     }


   if(deals_or_positins == "deals")
     {

      CPairedDealInfo deal;

      if(!deal.HistorySelect())
         return;

      int totalDeals = deal.Total();

      for(int index = 0; index < totalDeals; index++)
        {

         if(!deal.SelectByIndex(index))
            continue;

         CHistoryTrade *tradeToAdd = CHistoryTrade::GetHistoryTrade(deal);
         m_history_trades.Add(tradeToAdd);
        }
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrades::enableAllHistory(void)
  {
   if(!HistorySelect(0, D'3000.01.01'))
      LOG_ERROR("Could not load all History");
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
   string str = getJsonList().Serialize();

   FileWriteString(handle, str);
   FileClose(handle);
  }
//+------------------------------------------------------------------+
