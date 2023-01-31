//+------------------------------------------------------------------+
//|                                                IPositionInfo.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#ifdef __MQL4__
enum ENUM_POSITION_TYPE
 {
  POSITION_TYPE_BUY,
  POSITION_TYPE_SELL,
 };
#endif

interface IPositionInfo
 {

  virtual ulong             Ticket(void) const = 0;
  virtual datetime          Time(void) const = 0;
  virtual ulong             TimeMsc(void) const = 0;
  virtual datetime          TimeUpdate(void) const = 0;
  virtual ulong             TimeUpdateMsc(void) const = 0;
  virtual ENUM_POSITION_TYPE PositionType(void) const = 0;
  virtual string            TypeDescription(void) const = 0;
  virtual long              Magic(void) const = 0;
  virtual long              Identifier(void) const = 0;
//--- fast access methods to the double position propertyes
  virtual double            Volume(void) const = 0;
  virtual double            PriceOpen(void) const = 0;
  virtual double            StopLoss(void) const = 0;
  virtual double            TakeProfit(void) const = 0;
  virtual double            PriceCurrent(void) const = 0;
  virtual double            Commission(void) const = 0;
  virtual double            Swap(void) const = 0;
  virtual double            Profit(void) const = 0;
//--- fast access methods to the string position propertyes
  virtual string            Symbol(void) const = 0;
  virtual string            Comment(void) const = 0;



  virtual string            FormatType(string &str, const uint type) const = 0;
//--- methods for select position
  virtual bool              Select(const string symbol) = 0;
  virtual bool              SelectByMagic(const string symbol, const ulong magic) = 0;
  virtual bool              SelectByTicket(const ulong ticket) = 0;
  virtual bool              SelectByIndex(const int index) = 0;
//---
  virtual void              StoreState(void) = 0;
  virtual bool              CheckState(void) = 0;
 };
//+------------------------------------------------------------------+
