//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             httakeProfitPrices://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

/*
TODO
implement TradeAllowed care inglobeaza toate chestiile intr o functie
LogLevel Implement
*/

#include <Mircea/_profitpoint/Mql/SymbolInfo.mqh>
#include <Mircea/_profitpoint/Mql/ErrorDescriptor.mqh>

#include <Mircea/_profitpoint/Common/String.mqh>
#include <Mircea/_profitpoint/Trade/TradeUtils.mqh>
#include <Mircea/_profitpoint/Include.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrade : public CObject
 {
                     ObjectAttr(int, LogLevel);
                     ObjectAttr(int, Magic);
                     ObjectAttr(string, Symbol);
                     ObjectAttr(int, Slippage);

                     ObjectAttr(int, Retries);
                     ObjectAttr(int, RetrySleepMsc);
  //ObjectAttrClass(CMql4TradeRequest, TradeRequest);
private:
  CError*            mError;
public:
                     CTrade();
                    ~CTrade() {delete mError;}

  long               SendOrder(const string symbol, const int operation, const double volume,
                               const double price, const double stopLoss, const double takeProfit, const string comment = NULL);

  long               SendOrder(const string symbol, const int operation, const double volume,
                               const double price, const int stopLoss, const int takeProfit, const string comment = NULL);

  template<typename T>
  long               Buy(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>
  long               Sell(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>
  long               BuyStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>
  long               SellStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>
  long               BuyLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>
  long               SellLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  template<typename T>

  long               Market(int operation, double lots, T stopLoss, T takeProfit, string comment, string symbol = NULL);
  template<typename T>
  long               Pending(int operation, double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL);

  bool               ModifyMarket(ulong ticket, double stopLoss, double takeProfit);  //TODO
  bool               ModifyMarket(ulong ticket, int stopLoss, int takeProfit); //TODO

  bool               ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0, datetime expiration = 0);//TODO
  bool               ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0, datetime expiration = 0);//TODO

  bool               CloseMarket(long ticket, int slippage = 0);//fully Close Market Order
  bool               CloseMarket(long ticket, double lots, int  slippage = 0);//partiallyClose Market Order
  bool               DeletePending(long ticket);//Delete Pending
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrade::CTrade()
 {
  mLogLevel = LOGGER_LEVEL_ERROR;
  mMagic = 0;
  mSymbol = NULL;
  mSlippage = 2;
  mRetries = 5;
  mRetrySleepMsc = 1000;
  mError = new CError();
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CTrade::SendOrder(const string symbol, const int operation, const double volume, const double price, const int stopLoss, const int takeProfit, const string comment = NULL)
 {
  double sl = (stopLoss > 0) ? CTradeUtils::TargetPrice(symbol, operation, price, -stopLoss) : 0.0;
  double tp = (takeProfit > 0) ? CTradeUtils::TargetPrice(symbol, operation, price, takeProfit) : 0.0;
  return SendOrder(symbol, operation, volume, price, sl, tp, comment);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CTrade::SendOrder(const string symbol, const int operation, const double volume, const double price, const double stopLoss, const double takeProfit, const string comment = NULL)
 {
  mError.ClearError();
  int ticket  = OrderSend(symbol, operation, volume, price, mSlippage, stopLoss, takeProfit, comment, mMagic);

  if(ticket < 0)
   {
    int lastErrorCode = GetLastError();
    mError.SetErrorCode(lastErrorCode);
    LOG_ERROR(StringFormat("[%i][%s] | Symbol: %s, Price: %s, Operation: %i, Volume: %s, StopLoss: %s, TakeProfit: %s",
                           lastErrorCode,
                           mError.GetErrorDescription(),
                           symbol,
                           DoubleToString(price, CSymbolInfo::GetDigits(symbol)),
                           operation,
                           DoubleToString(volume, CSymbolInfo::GetDigits(symbol)),
                           DoubleToString(stopLoss, CSymbolInfo::GetDigits(symbol)),
                           DoubleToString(takeProfit, CSymbolInfo::GetDigits(symbol))
                          ));
   }
  return ticket;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::ModifyMarket(ulong ticket, int stopLoss, int takeProfit)
 {
  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  if(!(stopLoss || takeProfit))
    return false;

  mError.ClearError();

  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select ticket[%d] for Market Order Modification, Error: %d:: %s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }

  double sl = (stopLoss > 0) ? CTradeUtils::TargetPrice(OrderSymbol(), OrderType(), OrderOpenPrice(), -stopLoss) : 0.0;
  double tp = (takeProfit > 0) ? CTradeUtils::TargetPrice(OrderSymbol(), OrderType(), OrderOpenPrice(), takeProfit) : 0.0;

  return ModifyMarket(ticket, sl, tp);
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::ModifyMarket(ulong ticket, double stopLoss, double takeProfit)
 {
  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  mError.ClearError();

  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for Market Order Modification, Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  int digits = CSymbolInfo::GetDigits(OrderSymbol());
  bool isSuccessfull = OrderModify((int)ticket, OrderOpenPrice(), NormalizeDouble(stopLoss, digits), NormalizeDouble(takeProfit, digits), 0);

  if(!isSuccessfull)
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Error modifying Market Order with ticket[%d], Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  return isSuccessfull;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::ModifyPending(ulong ticket, double stopLoss, double takeProfit, double price = 0.000000, datetime expiration = 0)
 {

  if(!CTradeUtils::IsTradingAllowed())
    return(false);
  mError.ClearError();

  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for pending Order Modification, Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  int digits = CSymbolInfo::GetDigits(OrderSymbol());
  bool isSuccessfull = OrderModify((int)ticket, price, NormalizeDouble(stopLoss, digits), NormalizeDouble(takeProfit, digits), 0);

  if(!isSuccessfull)
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Error modifying Pending Order with Ticket[%d], Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  return isSuccessfull;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::ModifyPending(ulong ticket, int stopLoss, int takeProfit, double price = 0.000000, datetime expiration = 0)
 {

  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  if(stopLoss == 0 && takeProfit == 0 && price == 0.0)
    return false;

  mError.ClearError();

  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for Pending Order Modification, Error: %d:: %s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }

  double sl = (stopLoss > 0) ? CTradeUtils::TargetPrice(OrderSymbol(), OrderType(), OrderOpenPrice(), -stopLoss) : 0.0;
  double tp = (takeProfit > 0) ? CTradeUtils::TargetPrice(OrderSymbol(), OrderType(), OrderOpenPrice(), takeProfit) : 0.0;

  return ModifyPending(ticket, sl, tp, price);
 }
//+------------------------------------------------------------------+
//|Aici pot sa returnez  ticketul nou dupa ce s-a facut partial close|
//+------------------------------------------------------------------+
bool CTrade::CloseMarket(long ticket, double lots, int slippage = 0)
 {
  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  mError.ClearError();
  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for Order Close, Error: %d:: %s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  bool isSuccessfull = OrderClose((int)ticket, lots, OrderClosePrice(), GetSlippage());
  if(!isSuccessfull)
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Error  closing Order with ticket[%d], Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }

//find OrderByClosedTiket - TODO
  return isSuccessfull;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::CloseMarket(long ticket, int slippage = 0)
 {
  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  mError.ClearError();
  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for Order Close, Error: %d:: %s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  bool isSuccessfull = OrderClose((int)ticket, OrderLots(), OrderClosePrice(), GetSlippage());
  if(!isSuccessfull)
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Error closing Order with ticket[%d], Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  return isSuccessfull;

 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrade::DeletePending(long ticket)
 {
  if(!CTradeUtils::IsTradingAllowed())
    return(false);

  mError.ClearError();
  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Could not select Ticket[%d] for Pending Delete, Error: %d:: %s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  bool isSuccessfull = OrderDelete((int)ticket);
  if(!isSuccessfull)
   {
    mError.SetErrorCode(GetLastError());
    LOG_ERROR(StringFormat("Error deleting Order with ticket[%d], Error: %d::%s", ticket, mError.GetErrorCode(), mError.GetErrorDescription()));
    return false;
   }
  return isSuccessfull;
 }
/*\
        BUY
*/
template<typename T>
long CTrade::Buy(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0 || !CAccount::AccountFreeMarginCheck(symbol, OP_BUY, lots))
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }

  return Market(OP_BUY, lots, stopLoss, takeProfit, comment, symbol);
 }
/*
        SELL
*/
template<typename T>
long CTrade::Sell(double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0 || !CAccount::AccountFreeMarginCheck(symbol, OP_SELL, lots))
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }
  return Market(OP_SELL, lots, stopLoss, takeProfit, comment, symbol);
 }
/*
        BUYSTOP
*/
template<typename T>
long CTrade::BuyStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0)
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }
  return Pending(OP_SELL, price, lots, stopLoss, takeProfit, comment, symbol);
 }
/*
        SELLSTOP
*/
template<typename T>
long CTrade::SellStop(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0)
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }
  return Pending(OP_SELL, price, lots, stopLoss, takeProfit, comment, symbol);
 }



template<typename T>
long CTrade::BuyLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0)
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }
  return Pending(OP_SELL, price, lots, stopLoss, takeProfit, comment, symbol);
 }
/*
        SELLSTOP
*/
template<typename T>
long CTrade::SellLimit(double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  mError.ClearError();

  if(!CTradeUtils::IsTradingAllowed())
    return(-1);

  if(CString::IsEmptyOrNull(symbol))
    symbol = (CString::IsEmptyOrNull(GetSymbol())) ? _Symbol : GetSymbol();

  if(lots <= 0.0)
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_VOLUME);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }
  return Pending(OP_SELL, price, lots, stopLoss, takeProfit, comment, symbol);
 }
template<typename T>
long CTrade::Market(int operation, double lots, T stopLoss, T takeProfit, string comment, string symbol)
 {

  if(operation != ORDER_TYPE_BUY && operation != ORDER_TYPE_SELL)
   {
    mError.SetErrorCode(ERR_INVALID_TRADE_PARAMETERS);
    LOG_ERROR(mError.GetErrorDescription());
    return(-1);
   }


  int retry = 0;
  long ticket = 0;
  while(retry < GetRetries())
   {
    double priceOpen = NormalizeDouble((operation == OP_BUY) ? CSymbolInfo::GetAsk(symbol) : ((operation == OP_SELL) ? CSymbolInfo::GetBid(symbol) : 0.0), CSymbolInfo::GetDigits(symbol));
    ticket = SendOrder(symbol, operation, lots, priceOpen, stopLoss, takeProfit, comment);
    if(ticket > 0)
      return ticket;
    if(mError.GetErrorCode() == ERR_REQUOTE || mError.GetErrorCode() == ERR_PRICE_CHANGED || mError.GetErrorCode() == ERR_OFF_QUOTES)
     {
      Sleep(mRetrySleepMsc);
      LOG_INFO("> > > Retrying Market Order");
      retry++;
      RefreshRates();
     }
    else
      break;
   }
  return ticket;
 }
template<typename T>
long CTrade::Pending(int operation, double price, double lots, T stopLoss, T takeProfit, string comment = NULL, string symbol = NULL)
 {
  double _price = NormalizeDouble(price, CSymbolInfo::GetDigits(symbol));
  return SendOrder(symbol, operation, lots, _price, stopLoss, takeProfit, comment);
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeBuilder
 {
private:
  int                _logLevel;
  int                _magic;
  string             _symbol;
  int                _slippage;
  int                _retries;
  int                _retrySleepMsc;

private:
  static CTradeBuilder* uniqueInstance;

public:
                     CTradeBuilder() {}
                    ~CTradeBuilder() {}

  CTrade*              Build();

  CTradeBuilder*      WithSymbol(string symbol) {_symbol = symbol; return GetPointer(this);}
  CTradeBuilder*      WithMagic(int magic) {_magic = magic; return GetPointer(this);}
  CTradeBuilder*      WithSlippage(int slippage) {_slippage = slippage; return GetPointer(this);}


 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrade* CTradeBuilder::Build()
 {

  CTrade *trade = new CTrade();

  if(_logLevel > 0)
    trade.SetLogLevel(_logLevel);

  if(_magic != 0)
    trade.SetMagic(_magic);

  if(!CString::IsEmptyOrNull(_symbol))
    trade.SetSymbol(_symbol);

  if(_slippage > 0)
    trade.SetSlippage(_slippage);
  return GetPointer(trade);
 }
//+------------------------------------------------------------------+
