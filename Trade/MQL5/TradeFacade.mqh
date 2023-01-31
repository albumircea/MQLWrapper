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
#include <Mircea/_profitpoint/Logger.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeFacade : public ITradeFacade//MQL5
  {
private:
   CTrade*            _trade;
public:
                     CTradeFacade(CTrade* trade=NULL) {_trade = (trade != NULL) ? trade : new CTrade();}
                    ~CTradeFacade() {SafeDelete(_trade);}

   void               SetMagic(int magic) override {_trade.SetExpertMagicNumber(magic);}
   void               SetSymbol(string symbol) override {_trade.SetSymbol(symbol);}
   void               SetSlippage(int slippage)override {_trade.SetDeviationInPoints(slippage);}
   void               SetRetries(int retries)override {LOG_ERROR("FunctionNotSupported MQL5");}
   void               SetRetrySleepMsc(int mscTime)override {LOG_ERROR("FunctionNotSupported MQL5");}
   void               SetLogLevel(int logLevel)override {_trade.LogLevel((ENUM_LOG_LEVELS)logLevel);}

   long               Buy(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override;
   long               Sell(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)override;
   long               BuyStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override;
   long               SellStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)override;
   long               BuyLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override;
   long               SellLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL) override;
   long               Market(int operation, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL) override;
   long               Pending(int operation, double price, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL) override;

   long               Buy(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               Sell(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               BuyStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               SellStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               BuyLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               SellLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL) override;
   long               Market(int operation, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)override;
   long               Pending(int operation, double price, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)override;


   bool               ModifyMarket(ulong ticket, double stopLoss, double takeProfit) override;
   bool               ModifyMarket(ulong ticket, int stopLoss, int takeProfit) override;


   bool               ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0, datetime expiration = 0)override;
   bool               ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0, datetime expiration = 0)override;



   bool               CloseMarket(long ticket, int slippage = 0)override; //fully Close Market Order
   bool               CloseMarket(long ticket, double lots, int  slippage = 0, string comment = NULL)override; //partiallyClose Market Order
   bool               DeletePending(long ticket)override; //Delete Pending
  };
//+------------------------------------------------------------------+
//|                                  BUY DBL                         |
//+------------------------------------------------------------------+
long CTradeFacade::Buy(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.Buy(lots, symbol, 0, stopLoss, takeProfit, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _dealTicket = (long)_trade.ResultDeal();
   return _dealTicket;
  }
//+------------------------------------------------------------------+
//|                                  BUY INT                         |
//+------------------------------------------------------------------+
long CTradeFacade::Buy(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return Buy(lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  SELL DBL                        |
//+------------------------------------------------------------------+
long CTradeFacade::Sell(double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.Sell(lots, symbol, 0, stopLoss, takeProfit, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _dealTicket = (long)_trade.ResultDeal();
   return _dealTicket;
  }
//+------------------------------------------------------------------+
//|                                  SELL INT                        |
//+------------------------------------------------------------------+
long CTradeFacade::Sell(double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return Sell(lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  BUY_STOP DBL                    |
//+------------------------------------------------------------------+
long CTradeFacade::BuyStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.BuyStop(lots, price, symbol, stopLoss, takeProfit, 0, 0, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _orderTicket = (long)_trade.ResultOrder();
   return _orderTicket;
  }
//+------------------------------------------------------------------+
//|                                  BUY_STOP INT                    |
//+------------------------------------------------------------------+
long CTradeFacade::BuyStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return BuyStop(price, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  SELL_STOP DBL                   |
//+------------------------------------------------------------------+
long CTradeFacade::SellStop(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.SellStop(lots, price, symbol, stopLoss, takeProfit, 0, 0, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _orderTicket = (long)_trade.ResultOrder();
   return _orderTicket;
  }
//+------------------------------------------------------------------+
//|                                  SELL_STOP INT                   |
//+------------------------------------------------------------------+
long CTradeFacade::SellStop(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return SellStop(price, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  BUY_LIMIT DBL                   |
//+------------------------------------------------------------------+
long CTradeFacade::BuyLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.BuyLimit(lots, price, symbol, stopLoss, takeProfit, 0, 0, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _orderTicket = (long)_trade.ResultOrder();
   return _orderTicket;
  }
//+------------------------------------------------------------------+
//|                                  BUY_LIMIT INT                   |
//+------------------------------------------------------------------+
long CTradeFacade::BuyLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return BuyLimit(price, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  SELL_LIMIT DBL                  |
//+------------------------------------------------------------------+
long CTradeFacade::SellLimit(double price, double lots, double stopLoss, double takeProfit, string comment = NULL, string symbol = NULL)
  {
   if(!_trade.SellLimit(lots, price, symbol, stopLoss, takeProfit, 0, 0, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _orderTicket = (long)_trade.ResultOrder();
   return _orderTicket;
  }
//+------------------------------------------------------------------+
//|                                  SELL_LIMIT INT                  |
//+------------------------------------------------------------------+
long CTradeFacade::SellLimit(double price, double lots, int stopLoss, int takeProfit, string comment = NULL, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return SellLimit(price, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  MARKET  DBL                     |
//+------------------------------------------------------------------+
long CTradeFacade::Market(int operation, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)
  {
   ENUM_ORDER_TYPE cmd = (ENUM_ORDER_TYPE) operation;
   if(!_trade.PositionOpen(symbol, cmd, lots, 0, stopLoss, takeProfit, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _dealTicket = (long)_trade.ResultDeal();
   return _dealTicket;
  }
//+------------------------------------------------------------------+
//|                                  MARKET  INT                     |
//+------------------------------------------------------------------+
long CTradeFacade::Market(int operation, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return Market(operation, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  PENDING DBL                     |
//+------------------------------------------------------------------+
long CTradeFacade::Pending(int operation, double price, double lots, double stopLoss, double takeProfit, string comment, string symbol = NULL)
  {
   ENUM_ORDER_TYPE cmd = (ENUM_ORDER_TYPE) operation;
   if(!_trade.OrderOpen(symbol, cmd, lots, 0.0, price, stopLoss, takeProfit, ORDER_TIME_GTC, 0, comment))
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return (-1);
     }
   long _orderTicket = (long)_trade.ResultOrder();
   return _orderTicket;
  }
//+------------------------------------------------------------------+
//|                                  PENDING INT                     |
//+------------------------------------------------------------------+
long CTradeFacade::Pending(int operation, double price, double lots, int stopLoss, int takeProfit, string comment, string symbol = NULL)
  {
   double sl = 0;
   double tp = 0;
   return Pending(operation, price, lots, sl, tp, comment, symbol);
  }
//+------------------------------------------------------------------+
//|                                  MODIFY MARKET DBL               |
//+------------------------------------------------------------------+
bool CTradeFacade::ModifyMarket(ulong ticket, double stopLoss, double takeProfit)
  {
   bool isSuccessfull = _trade.PositionModify(ticket, stopLoss, takeProfit);

   if(!isSuccessfull)
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return isSuccessfull;
     }
   return isSuccessfull;
  }
//+------------------------------------------------------------------+
//|                                  MODIFY MARKET INT               |
//+------------------------------------------------------------------+
bool CTradeFacade::ModifyMarket(ulong ticket, int stopLoss, int takeProfit)
  {
   double sl = 0;
   double tp = 0;
   return ModifyMarket(ticket, sl, tp);
  }
//+------------------------------------------------------------------+
//|                                  MODIFY PENDING INT              |
//+------------------------------------------------------------------+
bool CTradeFacade::ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0.000000, datetime expiration = 0)
  {
   bool isSuccessfull = _trade.OrderModify(ticket, price, stopLoss, takeProfit, ORDER_TIME_GTC, expiration, 0);

   if(!isSuccessfull)
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return isSuccessfull;
     }
   return isSuccessfull;
  }
//+------------------------------------------------------------------+
//|                                  MODIFY PENDING INT              |
//+------------------------------------------------------------------+
bool CTradeFacade::ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0.000000, datetime expiration = 0)
  {
   double sl = 0;
   double tp = 0;
   return ModifyPending(ticket, sl, tp, price, expiration);
  }
//+------------------------------------------------------------------+
//|                                  CLOSE PARTIAL                   |
//+------------------------------------------------------------------+
bool CTradeFacade::CloseMarket(long ticket, double lots, int slippage = 0, string comment = NULL)
  {
   bool isSuccessfull = _trade.PositionClosePartial(ticket, lots, slippage, comment);

   if(!isSuccessfull)
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return isSuccessfull;
     }
   return isSuccessfull;
  }
//+------------------------------------------------------------------+
//|                                  CLOSE FULL                      |
//+------------------------------------------------------------------+
bool CTradeFacade::CloseMarket(long ticket, int slippage = 0)
  {
   return _trade.PositionClose(ticket, slippage);
  }
//+------------------------------------------------------------------+
//|                                  DELETE PENDING                  |
//+------------------------------------------------------------------+
bool CTradeFacade::DeletePending(long ticket)
  {
   bool isSuccessfull =  _trade.OrderDelete(ticket);

   if(!isSuccessfull)
     {
      int errorCode = (int)_trade.ResultRetcode();
      LOG_ERROR(StringFormat("Error[%d]::[%s]", errorCode, ErrorDescription(errorCode)));
      return isSuccessfull;
     }
   return isSuccessfull;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
