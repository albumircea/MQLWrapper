//+------------------------------------------------------------------+
//|                                                   TradeUtils.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

/*
TODO
ToString
ToJson
implement Order :OrderBase
isBE
isPartiaClosed
etc
*/

#include <Object.mqh>
#include <Mircea/_profitpoint/Logger.mqh>
#include <Mircea/_profitpoint/Defines.mqh>
#include <Mircea/_profitpoint/Common/JAson.mqh>
#include <Mircea/_profitpoint/Mql/Account.mqh>
#include <Mircea/_profitpoint/Mql/TerminalInfo.mqh>
#include <Mircea/_profitpoint/Mql/SymbolInfo.mqh>
#include <Mircea/_profitpoint/Common/String.mqh>


#ifdef  __MQL4__
const string OrderTypeString[] = {"buy", "sell", "buy limit", "sell limit", "buy stop", "sell stop", "balance"};
const string ORDER_FROM_STR = "from #";
const string ORDER_PARTIAL_CLOSE_STR = "partial close";
const string ORDER_CLOSE_HEDGE_BY_STR = "close hedge by #";
#endif

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeUtils
 {
private:
  static ENUM_SYMBOL_INFO_DOUBLE ST[2];
  static ENUM_SYMBOL_INFO_DOUBLE ET[2];
  static int         DT[2];
public:
  static int         Direction(int type) {return DT[type & 1];}

  static double      FromPointsToAbsolutePrice(string symbol, int points) {return points * SymbolInfoDouble(symbol, SYMBOL_POINT);}
  static double      FromAbsolutePriceToPoints(string symbol, double absolutePrice) {return absolutePrice / SymbolInfoDouble(symbol, SYMBOL_POINT);}

  static string      FormatPrice(string symbol, double price) {return DoubleToString(price, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));}
  static double      NormalizePrice(string symbol, double price) {return NormalizeDouble(price, (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS));}

  static double      StartPrice(string symbol, int type) {return SymbolInfoDouble(symbol, ST[type & 1]);}
  static double      EndPrice(string symbol, int type) {return SymbolInfoDouble(symbol, ET[type & 1]);}

  static double      ProfitAbsolutePriceDifference(int type, double startPrice, double endPrice) {return Direction(type) * (endPrice - startPrice);}
  static double      TargetPrice(int type, double startPrice, double priceProfitAbsolute) {return startPrice + Direction(type) * priceProfitAbsolute;}
  static double      TargetPrice(string symbol, int type, double startPrice, int profitPoints) {return startPrice + Direction(type) * FromPointsToAbsolutePrice(symbol, profitPoints);}

  static double      MathAbsPriceDifference(const double priceA, const double priceB) {return MathAbs(priceA - priceB);}

  static bool        IsTradingAllowed();
  static bool        ValidateVolume(const double volume, const string symbol);
  static bool        ValidatePrice(const string symbol, const int type, double &openPrice, double allowedPriceDeviationPercentage = 0.1);



  static bool         IsBreakEven(int type, double entry, double stopLoss) {return (stopLoss != 0 && ProfitAbsolutePriceDifference(type, entry, stopLoss));}

 };
//+------------------------------------------------------------------+
static ENUM_SYMBOL_INFO_DOUBLE CTradeUtils::ST[2] = {SYMBOL_ASK, SYMBOL_BID};
static ENUM_SYMBOL_INFO_DOUBLE CTradeUtils::ET[2] = {SYMBOL_BID, SYMBOL_ASK};
static int CTradeUtils::DT[2] = {1, -1};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CTradeUtils::IsTradingAllowed()
 {

  if(IsStopped())
   {
    LOG_ERROR(StringFormat("Forced Shutdown, could not execute operation", 0));
    return false;
   }

  if(!CTerminal::IsTradeAllowed_())
   {
    Alert(">>> Error: please allow EA trading in Terminal settings!");
    return false;
   }

  if(!CMQLInfo::IsTradeAllowed_())
   {
    Alert(">>> Error: please allow trading in EA settings!");
    return false;
   }

  if(!CMQLInfo::IsTesting_())
   {
    if(!CAccount::IsTradeExpertAllowed())
     {
      Alert(StringFormat(">>> Error: your server %s does not allow EA trading!", CAccount::GetServerName()));
      return false;
     }
    if(!CAccount::IsTradeAllowed_())
     {
      Alert(StringFormat(">>> Error：your account %s does not allow EA trading!", CAccount::GetLogin()));
      return false;
     }
   }
  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CTradeUtils::ValidatePrice(const string symbol, const int type, double &openPrice, double allowedPriceDeviationPercentage = 0.1)
 {
//LOGGING
  double deviation = (allowedPriceDeviationPercentage / 100);
  double startPrice = StartPrice(symbol, type);
  double stopLevel = FromPointsToAbsolutePrice(symbol, CSymbolInfo::GetStopLevel(symbol));

  if(type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL)
   {
    double priceDifference = CTradeUtils::MathAbsPriceDifference(openPrice, startPrice);
    if((priceDifference / startPrice) < deviation)
     {
      openPrice = startPrice;
      return true;
     }
   }

  if(type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_BUY_STOP)
   {
    if(openPrice > (startPrice + stopLevel))
      return true;
   }

  if(type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_BUY_LIMIT)
   {
    if(openPrice < (startPrice + stopLevel))
      return true;
   }

  return false;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradeUtils::ValidateVolume(const double volume, const string symbol)
 {
  LOG_ERROR("NotImplemented");
  return false;
 }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
