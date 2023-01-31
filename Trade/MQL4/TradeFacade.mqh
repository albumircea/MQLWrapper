//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include "../Interfaces/ITradeFacade.mqh";
#include  "Trade.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeFacade : public ITradeFacade //MQL4
 {
private:
  CTrade*            _trade;

public:
                     CTradeFacade(CTrade* trade = NULL) {_trade = (trade != NULL) ? trade : new CTrade();}
                    ~CTradeFacade() {SafeDelete(_trade);}

  void               SetMagic(int magic) override {_trade.SetMagic(magic);}
  void               SetSymbol(string symbol) override {_trade.SetSymbol(symbol);}
  void               SetSlippage(int slippage)override {_trade.SetSlippage(slippage);}
  void               SetRetries(int retries)override {_trade.SetRetries(retries);}
  void               SetRetrySleepMsc(int mscTime)override {_trade.SetRetrySleepMsc(mscTime);}
  void               SetLogLevel(int logLevel)override {_trade.SetLogLevel(logLevel);}

  long               Buy(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.Buy(lots, stopLoss, takeProfit, comment, symbol);}
  long               Sell(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)override {return _trade.Sell(lots, stopLoss, takeProfit, comment, symbol);}
  long               BuyStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.BuyStop(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               SellStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)override {return _trade.SellStop(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               BuyLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.BuyLimit(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               SellLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.SellLimit(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               Market(int operation, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL) override {return _trade.Market(operation, lots, stopLoss, takeProfit, comment, symbol);}
  long               Pending(int operation, double price, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL) override {return _trade.Pending(operation, price, lots, stopLoss, takeProfit, comment, symbol);}

  long               Buy(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override {return          _trade.Buy(lots, stopLoss, takeProfit, comment, symbol);}
  long               Sell(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.Sell(lots, stopLoss, takeProfit, comment, symbol);}
  long               BuyStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.BuyStop(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               SellStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.SellStop(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               BuyLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override  {return _trade.BuyLimit(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               SellLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override {return _trade.SellLimit(price, lots, stopLoss, takeProfit, comment, symbol);}
  long               Market(int operation, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)override {return _trade.Market(operation, lots, stopLoss, takeProfit, comment, symbol);}
  long               Pending(int operation, double price, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)override {return _trade.Pending(operation, price, lots, stopLoss, takeProfit, comment, symbol);}


  bool               ModifyMarket(ulong ticket, double stopLoss, double takeProfit) override {return  _trade.ModifyMarket(ticket, stopLoss, takeProfit);}
  bool               ModifyMarket(ulong ticket, int stopLoss, int takeProfit) override {return  _trade.ModifyMarket(ticket, stopLoss, takeProfit);}


  bool               ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0, datetime expiration = 0)override {return _trade.ModifyPending(ticket, stopLoss, takeProfit, price);}
  bool               ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0, datetime expiration = 0)override {return _trade.ModifyPending(ticket, stopLoss, takeProfit, price);}



  bool               CloseMarket(long ticket, int slippage = 0)override {return _trade.CloseMarket(ticket, slippage);} //fully Close Market Order
  bool               CloseMarket(long ticket, double lots, int  slippage = 0, string comment = NULL)override {return _trade.CloseMarket(ticket, lots, slippage);} //partiallyClose Market Order
  bool               DeletePending(long ticket)override {return _trade.DeletePending(ticket);} //Delete Pending
 };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
