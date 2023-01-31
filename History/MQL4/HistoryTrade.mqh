//+------------------------------------------------------------------+
//|                                                 HistoryTrade.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Object.mqh>
#include <Mircea/_profitpoint/Common/JAson.mqh>
#include <Mircea/_profitpoint/Trade/TradeUtils.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CHistoryTrade: public CObject
 {

protected:
  ulong              m_ticket;
  ulong              m_display_ticket;
  string             m_symbol;
  int                m_magic;
  int                m_type;
  double             m_price_open;
  double             m_price_close;
  double             m_stop_loss;
  double             m_take_profit;
  double             m_profit;
  double             m_swap;
  double             m_commision;
  double             m_volume;
  datetime           m_time_open;
  datetime           m_time_close;
  int                m_points;

  //Exotic
  /*
  BuyProfitPoints= (OrderClosePrice()-OrderOpenPrice())  / marketinfo(point) ; -> points won
  SellProfitPoints=OrderOpenPrice()-OrderClosePrice()    / marketinfo(point) ; -> points won
  */

public:
                     CHistoryTrade() {};
                     CHistoryTrade(const ulong ticket, const ulong displayTicket, const string symbol, const int magic, const int type, const double price_open, const double price_close, const double stop_loss,
                const double take_profit, const double profit, const double swap, const double commision, const double volume, const datetime time_open, const datetime time_close, const int points);
                    ~CHistoryTrade() {};


  static CHistoryTrade        *getHistoryTradeByTicket(const ulong ticket);
  CJAVal                      toJson();



 };




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CJAVal CHistoryTrade::toJson(void)
 {
  int precision = 2;
  CJAVal json_historian_trade;
  int symbol_digits = (int) MarketInfo(m_symbol, MODE_DIGITS);
  json_historian_trade["Ticket"] = IntegerToString(m_ticket);
  json_historian_trade["DisplayTicket"] = IntegerToString(m_ticket);
  json_historian_trade["Symbol"] = m_symbol;
  json_historian_trade["Magic"] = IntegerToString(m_magic);
  json_historian_trade["Type"] = IntegerToString(m_type);
  json_historian_trade["PriceOpen"] = DoubleToString(m_price_open, symbol_digits);
  json_historian_trade["PriceClose"] = DoubleToString(m_price_close, symbol_digits);
  json_historian_trade["StopLoss"] = DoubleToString(m_stop_loss, symbol_digits);
  json_historian_trade["TakeProfit"] = DoubleToString(m_take_profit, symbol_digits);
  json_historian_trade["Profit"] = DoubleToString(m_profit, precision);
  json_historian_trade["Swap"] = DoubleToString(m_swap, precision);
  json_historian_trade["Commision"] = DoubleToString(m_commision, precision);
  json_historian_trade["Volume"] = DoubleToString(m_volume, 2);
  json_historian_trade["TimeOpen"] = TimeToString(m_time_open, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
  json_historian_trade["TimeClose"] = TimeToString(m_time_close, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
  json_historian_trade["Points"]    = IntegerToString(m_points);

  return json_historian_trade;
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static CHistoryTrade *CHistoryTrade::getHistoryTradeByTicket(const ulong ticket)
 {

  if(ticket < 0)
    return NULL;

  if(!OrderSelect((int)ticket, SELECT_BY_TICKET, MODE_HISTORY))
    return NULL;

//eliminate limit and stop orders
  if(OrderType() >= 2 && OrderType() <= 5)
    return NULL;



  double pointsAbsoluteValue = CTradeUtils::ProfitAbsolutePriceDifference(OrderType(), OrderOpenPrice(), OrderClosePrice());
  int points = (int) CTradeUtils::FromAbsolutePriceToPoints(OrderSymbol(), pointsAbsoluteValue);



  CHistoryTrade *trade = new CHistoryTrade(
    OrderTicket(),
    OrderTicket(),
    OrderSymbol(),
    OrderMagicNumber(),
    OrderType(),
    OrderOpenPrice(),
    OrderClosePrice(),
    OrderStopLoss(),
    OrderTakeProfit(),
    OrderProfit(),
    OrderSwap(),
    OrderCommission(),
    OrderLots(),
    OrderOpenTime(),
    OrderCloseTime(),
    points
  );

  return trade;
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CHistoryTrade::CHistoryTrade(const ulong ticket, const ulong displayTicket, const string symbol, const int magic, const
                                  int type, const double price_open, const double price_close,
                                  const double stop_loss, const double take_profit, const double profit,
                                  const double swap, const double commision, const double volume,
                                  const datetime time_open, const datetime time_close, const int points)
 {
  m_ticket = ticket;
  m_display_ticket = displayTicket;
  m_symbol = symbol;
  m_magic = magic;
  m_type = type;
  m_price_open = price_open;
  m_price_close = price_close;
  m_stop_loss = stop_loss;
  m_take_profit = take_profit;
  m_profit = profit;
  m_swap = swap;
  m_commision = commision;
  m_volume = volume;
  m_time_open = time_open;
  m_time_close = time_close;
  m_points = points;
 }
//+------------------------------------------------------------------+
