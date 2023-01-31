//+------------------------------------------------------------------+
//|                                                  TradeFacade.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

/*
TODO

CloseMarket
ClosePartial
DeletePending

*/
#include <Object.mqh>


interface ITradeFacade
 {

  void               SetMagic(int magic) = 0;
  void               SetSymbol(string symbol) = 0;
  void               SetSlippage(int slippage) = 0;
  void               SetRetries(int retries) = 0;
  void               SetRetrySleepMsc(int mscTime) = 0;
  void               SetLogLevel(int logLevel) = 0;

  long               Buy(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               Sell(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               BuyStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               SellStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               BuyLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               SellLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL);
  long               Market(int operation, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL);
  long               Pending(int operation, double price, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL);

  long               Buy(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               Sell(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               BuyStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               SellStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               BuyLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               SellLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL);
  long               Market(int operation, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL);
  long               Pending(int operation, double price, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL);



  bool               ModifyMarket(ulong ticket, double stopLoss, double takeProfit);
  bool               ModifyMarket(ulong ticket, int stopLoss, int takeProfit);

  bool               ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0, datetime expiration = 0);
  bool               ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0, datetime expiration = 0);

  bool               CloseMarket(long ticket, int slippage = 0);  //fully Close Market Order
  bool               CloseMarket(long ticket, double lots, int  slippage = 0, string comment = NULL); //partiallyClose Market Order
  bool               DeletePending(long ticket) {return false;} //Delete Pending
 };
//+------------------------------------------------------------------+
