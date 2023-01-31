//+------------------------------------------------------------------+
//|                                                 PositionInfo.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include <Object.mqh>
#include "../Interfaces/IPositionInfo.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PositionsTotal()
 {
  return OrdersTotal();
 }

class CPositionInfoObj : public CObject {};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionInfoBase : public IPositionInfo {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionInfo : public CPositionInfoBase
 {
protected:
  ENUM_POSITION_TYPE m_type;
  double             m_volume;
  double             m_price;
  double             m_stop_loss;
  double             m_take_profit;

public:
                     CPositionInfo(void);
                    ~CPositionInfo(void);
  //--- fast access methods to the integer position propertyes
  ulong              Ticket(void) const override;
  datetime           Time(void) const override;
  ulong              TimeMsc(void) const override;
  datetime           TimeUpdate(void) const override;
  ulong              TimeUpdateMsc(void) const override;
  ENUM_POSITION_TYPE PositionType(void) const override;
  string             TypeDescription(void) const override;
  long               Magic(void) const override;
  long               Identifier(void) const override;
  //--- fast access methods to the double position propertyes
  double             Volume(void) const override;
  double             PriceOpen(void) const override;
  double             StopLoss(void) const override;
  double             TakeProfit(void) const override;
  double             PriceCurrent(void) const override;
  double             Commission(void) const override;
  double             Swap(void) const override;
  double             Profit(void) const override;
  //--- fast access methods to the string position propertyes
  string             Symbol(void) const override;
  string             Comment(void) const override;
  //--- access methods to the API MQL5 functions
  //bool              InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id,long &var) const;
  //bool              InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id,double &var) const;
  //bool              InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id,string &var) const;
  //--- info methods
  string             FormatType(string &str, const uint type) const override;

  //--- methods for select position
  bool               Select(const string symbol) override;
  bool               SelectByMagic(const string symbol, const ulong magic)override;
  bool               SelectByTicket(const ulong ticket)override;
  bool               SelectByIndex(const int index)override;
  //---
  void               StoreState(void)override;
  bool               CheckState(void)override;
 };
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionInfo::CPositionInfo(void) : m_type(WRONG_VALUE),
   m_volume(0.0),
   m_price(0.0),
   m_stop_loss(0.0),
   m_take_profit(0.0) {
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionInfo::~CPositionInfo(void) {
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TICKET"                         |
//+------------------------------------------------------------------+
ulong CPositionInfo::Ticket(void) const {
   return((ulong)OrderTicket());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME"                           |
//+------------------------------------------------------------------+
datetime CPositionInfo::Time(void) const {
   return((datetime)OrderOpenTime());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_MSC"                       |
//+------------------------------------------------------------------+
ulong CPositionInfo::TimeMsc(void) const {
   return((ulong)OrderOpenTime());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_UPDATE"                    |
//+------------------------------------------------------------------+
datetime CPositionInfo::TimeUpdate(void) const {
   return((datetime)OrderOpenTime());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_UPDATE_MSC"                |
//+------------------------------------------------------------------+
ulong CPositionInfo::TimeUpdateMsc(void) const {
   return((ulong)OrderOpenTime());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE"                           |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CPositionInfo::PositionType(void) const {
   return((ENUM_POSITION_TYPE)OrderType());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE" as string                 |
//+------------------------------------------------------------------+
string CPositionInfo::TypeDescription(void) const {
   string str;
//---
   return(FormatType(str, PositionType()));
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_MAGIC"                          |
//+------------------------------------------------------------------+
long CPositionInfo::Magic(void) const {
   return(OrderMagicNumber());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_IDENTIFIER"                     |
//+------------------------------------------------------------------+
long CPositionInfo::Identifier(void) const {
   return(OrderTicket());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_VOLUME"                         |
//+------------------------------------------------------------------+
double CPositionInfo::Volume(void) const {
   return(OrderLots());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_OPEN"                     |
//+------------------------------------------------------------------+
double CPositionInfo::PriceOpen(void) const {
   return(OrderOpenPrice());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SL"                             |
//+------------------------------------------------------------------+
double CPositionInfo::StopLoss(void) const {
   return(OrderStopLoss());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TP"                             |
//+------------------------------------------------------------------+
double CPositionInfo::TakeProfit(void) const {
   return(OrderTakeProfit());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_CURRENT"                  |
//+------------------------------------------------------------------+
double CPositionInfo::PriceCurrent(void) const {
   return -1;
   return(OrderType() == ORDER_TYPE_BUY ? Bid : Ask);
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_COMMISSION"                     |
//+------------------------------------------------------------------+
double CPositionInfo::Commission(void) const {
   return(OrderCommission());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SWAP"                           |
//+------------------------------------------------------------------+
double CPositionInfo::Swap(void) const {
   return(OrderSwap());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PROFIT"                         |
//+------------------------------------------------------------------+
double CPositionInfo::Profit(void) const {
   return(OrderProfit());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SYMBOL"                         |
//+------------------------------------------------------------------+
string CPositionInfo::Symbol(void) const {
   return(OrderSymbol());
}
//+------------------------------------------------------------------+
//| Get the property value "POSITION_COMMENT"                        |
//+------------------------------------------------------------------+
string CPositionInfo::Comment(void) const {
   return(OrderComment());
}
/*
//+------------------------------------------------------------------+
//| Access functions PositionGetInteger(...)                         |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id,long &var) const
  {
   return(PositionGetInteger(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetDouble(...)                          |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id,double &var) const
  {
   return(PositionGetDouble(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetString(...)                          |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id,string &var) const
  {
   return(PositionGetString(prop_id,var));
  }

  */
//+------------------------------------------------------------------+
//| Converts the position type to text                               |
//+------------------------------------------------------------------+
string CPositionInfo::FormatType(string &str, const uint type) const {
//--- see the type
   switch(type) {
   case POSITION_TYPE_BUY:
      str = "buy";
      break;
   case POSITION_TYPE_SELL:
      str = "sell";
      break;
   default:
      str = "unknown position type " + (string)type;
   }
//--- return the result
   return(str);
}


/*
//+------------------------------------------------------------------+
//| Access functions PositionSelect(...)                             |
//+------------------------------------------------------------------+
bool CPositionInfo::Select(const string symbol)
  {
   return(PositionSelect(symbol));
  }
//+------------------------------------------------------------------+
//| Access functions PositionSelect(...)                             |
//+------------------------------------------------------------------+
bool CPositionInfo::SelectByMagic(const string symbol,const ulong magic)
  {
   bool res=false;
   uint total=PositionsTotal();
//---
   for(uint i=0; i<total; i++)
     {
      string position_symbol=PositionGetSymbol(i);
      if(position_symbol==symbol && magic==PositionGetInteger(POSITION_MAGIC))
        {
         res=true;
         break;
        }
     }
//---
   return(res);
  }
  */
//+------------------------------------------------------------------+
//| Access functions PositionSelectByTicket(...)                     |
//+------------------------------------------------------------------+
bool CPositionInfo::SelectByTicket(const ulong ticket) {
   return OrderSelect((int) ticket, SELECT_BY_TICKET, MODE_TRADES);
   return(ticket > 0);
}

//+------------------------------------------------------------------+
//| Select a position on the index                                   |
//+------------------------------------------------------------------+
bool CPositionInfo::SelectByIndex(const int index) {
   if(OrderSelect(index, SELECT_BY_POS, MODE_TRADES)) {
      int type = OrderType();
      if(type < 2) {
         return(true);
      }
   }
   return(false);
}
//+------------------------------------------------------------------+
//| Stored position's current state                                  |
//+------------------------------------------------------------------+
void CPositionInfo::StoreState(void) {
   m_type       = PositionType();
   m_volume     = Volume();
   m_price      = PriceOpen();
   m_stop_loss  = StopLoss();
   m_take_profit = TakeProfit();
}
//+------------------------------------------------------------------+
//| Check position change                                            |
//+------------------------------------------------------------------+
bool CPositionInfo::CheckState(void) {
   if(m_type == PositionType()  &&
         m_volume == Volume()      &&
         m_price == PriceOpen()    &&
         m_stop_loss == StopLoss() &&
         m_take_profit == TakeProfit())
      return(false);
//---
   return(true);
}
//+------------------------------------------------------------------+