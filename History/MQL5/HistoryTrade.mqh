//+------------------------------------------------------------------+
//|                                                 HistoryTrade.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"


#include <Mircea/_profitpoint/Common/JAson.mqh>
#include <Mircea/_profitpoint/Trade/TradeUtils.mqh>
#include <Mircea/_profitpoint/Trade/MQL5/PairedDealInfo.mqh>
#include <Mircea/_profitpoint/Trade/MQL5/HistoryPositionInfo.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CHistoryTrade: public CObject
  {

protected:

   ulong             mTicket; //unic DealTicket
   ulong             mDisplayTicket;//PositionId
   string            mSymbol;
   long              mMagic;
   int               mType;
   double            mPriceOpen;
   double            mPriceClose;
   double            mStopLoss;
   double            mTakePofit;
   double            mProfit;
   double            mSwap;
   double            mCommision;
   double            mVolume;
   datetime          mTimeOpen;
   datetime          mTimeClose;
   int               mPoints;

public:
                     CHistoryTrade() {};
   //CHistoryTrade(const ulong ticket);
                     CHistoryTrade(const ulong ticket, const ulong displayTicket, const string symbol, const long magic, const int type, const double price_open, const double price_close, const double stop_loss,
                 const double take_profit, const double profit, const double swap, const double commision, const double volume, const datetime time_open, const datetime time_close, const int points);
                    ~CHistoryTrade() {};

   static CHistoryTrade          *GetHistoryTrade(CPairedDealInfo &deal);
   static CHistoryTrade          *GetHistoryTrade(CHistoryPositionInfo &position);
   CJAVal                        toJson();
  };
//+------------------------------------------------------------------+
CJAVal CHistoryTrade::toJson(void)
  {
   int precision = 2;
   CJAVal json_historian_trade;
   int symbol_digits = (int) SymbolInfoInteger(mSymbol, SYMBOL_DIGITS);


   json_historian_trade["Ticket"]         = IntegerToString(mTicket);
   json_historian_trade["DisplayTicket"]  = IntegerToString(mDisplayTicket);
   json_historian_trade["Symbol"]         = mSymbol;
   json_historian_trade["Magic"]          = IntegerToString(mMagic);
   json_historian_trade["Type"]           = IntegerToString(mType);
   json_historian_trade["PriceOpen"]      = DoubleToString(mPriceOpen, symbol_digits);
   json_historian_trade["PriceClose"]     = DoubleToString(mPriceClose, symbol_digits);
   json_historian_trade["StopLoss"]       = DoubleToString(mStopLoss, symbol_digits);
   json_historian_trade["TakeProfit"]     = DoubleToString(mTakePofit, symbol_digits);
   json_historian_trade["Profit"]         = DoubleToString(mProfit, precision);
   json_historian_trade["Swap"]           = DoubleToString(mSwap, precision);
   json_historian_trade["Commision"]      = DoubleToString(mCommision, precision);
   json_historian_trade["Volume"]         = DoubleToString(mVolume, 2);
   json_historian_trade["TimeOpen"]       = TimeToString(mTimeOpen, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   json_historian_trade["TimeClose"]      = TimeToString(mTimeClose, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   json_historian_trade["Points"]      = IntegerToString(mPoints);

   return json_historian_trade;
  }

//+------------------------------------------------------------------+
static CHistoryTrade *CHistoryTrade::GetHistoryTrade(CHistoryPositionInfo &position)
  {
   CHistoryTrade *trade = new CHistoryTrade(
      position.Ticket(),
      position.Identifier(),
      position.Symbol(),
      position.Magic(),
      position.PositionType(),
      position.PriceOpen(),
      position.PriceClose(),
      position.StopLoss(),
      position.TakeProfit(),
      position.Profit(),
      position.Swap(),
      position.Commission(),
      position.Volume(),
      position.TimeOpen(),
      position.TimeClose(),
      (int) MathRound(CTradeUtils::FromAbsolutePriceToPoints(position.Symbol(), position.PriceOpen() - position.PriceClose()))
   );
   return trade;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static CHistoryTrade *CHistoryTrade::GetHistoryTrade(CPairedDealInfo &deal)
  {

   double pointsAbsoluteValue = CTradeUtils::ProfitAbsolutePriceDifference(deal.DealType(), deal.PriceOpen(), deal.PriceClose());
   int points = (int) CTradeUtils::FromAbsolutePriceToPoints(deal.Symbol(), pointsAbsoluteValue);

   CHistoryTrade *trade = new CHistoryTrade(
      deal.TicketClose(),
      deal.PositionId(),
      deal.Symbol(),
      deal.Magic(),
      deal.DealType(),
      deal.PriceOpen(),
      deal.PriceClose(),
      deal.StopLoss(),
      deal.TakeProfit(),
      deal.Profit(),
      deal.Swap(),
      deal.Commission(),
      deal.Volume(),
      deal.TimeOpen(),
      deal.TimeClose(),
      (int) MathRound(CTradeUtils::FromAbsolutePriceToPoints(deal.Symbol(), deal.PriceOpen() - deal.PriceClose()))
   );
   return trade;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrade::CHistoryTrade(const ulong ticket, const ulong displayTicket, const string symbol, const long magic, const
                                  int type, const double price_open, const double price_close,
                                  const double stop_loss, const double take_profit, const double profit,
                                  const double swap, const double commision, const double volume,
                                  const datetime time_open, const datetime time_close, const int points)
  {
   mTicket     = ticket;
   mDisplayTicket = displayTicket;
   mSymbol     = symbol;
   mMagic      = magic;
   mType       = type;
   mPriceOpen  = price_open;
   mPriceClose = price_close;
   mStopLoss   = stop_loss;
   mTakePofit  = take_profit;
   mProfit     = profit;
   mSwap       = swap;
   mCommision  = commision;
   mVolume     = volume;
   mTimeOpen   = time_open;
   mTimeClose  = time_close;
   mPoints     = points;
  }
//+------------------------------------------------------------------+
