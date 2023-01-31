//+------------------------------------------------------------------+
//|                                                ITradeManager.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Mircea/_profitpoint/Include.mqh>
#include <Mircea/_profitpoint/Defines.mqh>


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
interface ITradeManager
 {
public:
  long            Buy();
  long            Sell();

  long            BuyLimit();
  long            SellLimit();

  long            BuyStop();
  long            SellStop();

  long            Market();
  long            Pending();


 };
//+------------------------------------------------------------------+
