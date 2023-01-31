//+------------------------------------------------------------------+
//|                                                 TradeManager.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict



/*
Sa elimin TradeFacade din constructor sa pun new in cnstructoir

sa ofer functii pentru SetMagic si celalalte chestii pentru Trade
si asa pot sa renung si la TradeBuilder

sa raman doar cu TradeManager care face cam tot ce este nevoie cu o singura instanta

*/


#include "Interfaces/ITradeManager.mqh"

#ifdef __MQL4__
#include "MQL4/TradeFacade.mqh"
#endif

#ifdef __MQL5__
#include "MQL5/TradeFacade.mqh"
#endif



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeManager
 {
private:
  ITradeFacade*       _tradeFacade;


public:

                     CTradeManager(ITradeFacade* facade = NULL) {_tradeFacade = (facade != NULL) ? facade : new CTradeFacade();}
                    ~CTradeManager() {SafeDelete(_tradeFacade);}

  void               SetMagic(int magic) {_tradeFacade.SetMagic(magic);}
  void               SetSymbol(string symbol) {_tradeFacade.SetSymbol(symbol);}
  void               SetSlippage(int slippage) {_tradeFacade.SetSlippage(slippage);}
  void               SetRetries(int retries) {_tradeFacade.SetRetries(retries);}
  void               SetRetrySleepMsc(int mscTime) {_tradeFacade.SetRetrySleepMsc(mscTime);}
  void               SetLogLevel(int logLevel) {_tradeFacade.SetLogLevel(logLevel);}


  template<typename T>
  long               Buy(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.Buy(lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               Sell(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.Sell(lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               BuyStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.BuyStop(price, lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               SellStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.SellStop(price, lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               BuyLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.BuyLimit(price, lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               SellLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL) {return _tradeFacade.SellLimit(price, lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               Market(int operation, double lots, T stopLoss, T takeProfit, string comment, string symbol = NULL) {return _tradeFacade.Market(operation, lots, stopLoss, takeProfit, comment, symbol);}

  template<typename T>
  long               Pending(int operation, double price, double lots, T stopLoss, T takeProfit, string comment, string symbol = NULL) {return _tradeFacade.Pending(operation, price, lots, stopLoss, takeProfit, comment, symbol);}


  template<typename T>
  bool               ModifyMarket(ulong ticket, T stopLoss, T takeProfit) {return _tradeFacade.ModifyMarket(ticket, stopLoss, takeProfit);}
  template<typename T>
  bool               ModifyPending(ulong ticket, T stopLoss, T takeProfit, double price = 0, datetime expiration = 0) { return _tradeFacade.ModifyPending(ticket, stopLoss, takeProfit, price, expiration);}

  bool               CloseMarket(long ticket, int slippage = 0) {return _tradeFacade.CloseMarket(ticket, slippage);} //fully Close Market Order
  bool               CloseMarket(long ticket, double lots, int  slippage = 0, string comment = NULL) {return _tradeFacade.CloseMarket(ticket, lots, slippage, comment);} //partiallyClose Market Order
  bool               DeletePending(long ticket) {return _tradeFacade.DeletePending(ticket);} //Delete Pending

 };
//+------------------------------------------------------------------+
