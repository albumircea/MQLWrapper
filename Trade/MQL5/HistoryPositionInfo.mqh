//+------------------------------------------------------------------+
//|                                         CHistoryPositionInfo.mqh |
//+------------------------------------------------------------------+
#property description "A class for easy access to the closed position properties."
//--- include
#include <Arrays/ArrayLong.mqh>
#include <Generic/HashSet.mqh>
#include "DealInfo.mqh"
#include "HistoryOrderInfo.mqh"
//+------------------------------------------------------------------+
//| Class CHistoryPositionInfo.                                      |
//| Appointment: Class for access to history position info.          |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CHistoryPositionInfo : public CObject
  {
protected:
   ulong             m_curr_ticket;        // ticket of closed position
   CArrayLong        m_tickets;
   CDealInfo         m_curr_deal;
   bool              isRetailHedging;
public:
                     CHistoryPositionInfo(void);
                    ~CHistoryPositionInfo(void);
   //--- methods of access to protected data
   ulong             Ticket(void)           const
     {
      return(m_curr_ticket);
     }
   //--- fast access methods to the integer position properties
   datetime          TimeOpen(void);
   ulong             TimeOpenMsc(void);
   datetime          TimeClose(void);
   ulong             TimeCloseMsc(void);
   ENUM_POSITION_TYPE PositionType(void);
   string            TypeDescription(void);
   long              Magic(void);
   long              Identifier(void);
   ENUM_DEAL_REASON  OpenReason(void);
   ENUM_DEAL_REASON  CloseReason(void);
   //--- fast access methods to the double position properties
   double            Volume(void);
   double            PriceOpen(void);
   double            StopLoss(void) const;
   double            TakeProfit(void) const;
   double            PriceClose(void);
   double            Commission(void);
   double            Swap(void);
   double            Profit(void);
   //--- fast access methods to the string position properties
   string            Symbol(void);
   string            OpenComment(void);
   string            CloseComment(void);
   string            OpenReasonDescription(void);
   string            CloseReasonDescription(void);
   string            DealTickets(const string separator = " ");
   //--- info methods
   string            FormatType(string &str, const uint type) const;
   string            FormatReason(string &str, const uint reason) const;
   //--- methods for select position
   bool              HistorySelect(datetime from_date, datetime to_date);
   int               PositionsTotal(void) const;
   bool              SelectByTicket(const ulong ticket, const int logLevel=1);
   bool              SelectByIndex(const int index);

protected:
   bool              HistoryPositionSelect(const long position_id) const;
   bool              HistoryPositionCheck(const int log_level);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CHistoryPositionInfo::CHistoryPositionInfo(void) : m_curr_ticket(0), isRetailHedging(true)
  {
//--- account margin mode
   ENUM_ACCOUNT_MARGIN_MODE margin_mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   if(margin_mode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
      isRetailHedging = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CHistoryPositionInfo::~CHistoryPositionInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Get the opening time of the selected position                    |
//+------------------------------------------------------------------+
datetime CHistoryPositionInfo::TimeOpen(void)
  {
   datetime pos_time = 0;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_time = m_curr_deal.Time();
//---
   return(pos_time);
  }
//+------------------------------------------------------------------+
//| Get the opening time of the selected position in milliseconds    |
//+------------------------------------------------------------------+
ulong CHistoryPositionInfo::TimeOpenMsc(void)
  {
   ulong pos_time_msc = 0;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_time_msc = m_curr_deal.TimeMsc();
//---
   return(pos_time_msc);
  }
//+------------------------------------------------------------------+
//| Get the closing time of the selected position                    |
//+------------------------------------------------------------------+
datetime CHistoryPositionInfo::TimeClose(void)
  {
   datetime pos_time = 0;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(HistoryDealsTotal() - 1))
         pos_time = m_curr_deal.Time();
//---
   return(pos_time);
  }
//+------------------------------------------------------------------+
//| Get the closing time of the selected position in milliseconds    |
//+------------------------------------------------------------------+
ulong CHistoryPositionInfo::TimeCloseMsc(void)
  {
   ulong pos_time_msc = 0;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(HistoryDealsTotal() - 1))
         pos_time_msc = m_curr_deal.TimeMsc();
//---
   return(pos_time_msc);
  }
//+------------------------------------------------------------------+
//| Get the type of the selected position                            |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CHistoryPositionInfo::PositionType(void)
  {
   ENUM_POSITION_TYPE pos_type = WRONG_VALUE;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_type = (ENUM_POSITION_TYPE)m_curr_deal.DealType();
//---
   return(pos_type);
  }
//+------------------------------------------------------------------+
//| Get the type of the selected position as string                  |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::TypeDescription(void)
  {
   string str;
//---
   return(FormatType(str, PositionType()));
  }
//+------------------------------------------------------------------+
//| Get the magic number of the selected position                    |
//+------------------------------------------------------------------+
long CHistoryPositionInfo::Magic(void)
  {
   long pos_magic = WRONG_VALUE;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_magic = m_curr_deal.Magic();
//---
   return(pos_magic);
  }
//+------------------------------------------------------------------+
//| Get the identifier of the selected position                      |
//+------------------------------------------------------------------+
long CHistoryPositionInfo::Identifier(void)
  {
   long pos_id = WRONG_VALUE;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_id = m_curr_deal.PositionId();
//---
   return(pos_id);
  }
//+------------------------------------------------------------------+
//| Get the opening reason of the selected position                  |
//+------------------------------------------------------------------+
ENUM_DEAL_REASON CHistoryPositionInfo::OpenReason(void)
  {
   ENUM_DEAL_REASON pos_reason = WRONG_VALUE;
   long reason;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         if(m_curr_deal.InfoInteger(DEAL_REASON, reason))
            pos_reason = (ENUM_DEAL_REASON)reason;
//---
   return(pos_reason);
  }
//+------------------------------------------------------------------+
//| Get the closing reason of the selected position                  |
//+------------------------------------------------------------------+
ENUM_DEAL_REASON CHistoryPositionInfo::CloseReason(void)
  {
   ENUM_DEAL_REASON pos_reason = WRONG_VALUE;
   long reason;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(HistoryDealsTotal() - 1))
         if(m_curr_deal.InfoInteger(DEAL_REASON, reason))
            pos_reason = (ENUM_DEAL_REASON)reason;
//---
   return(pos_reason);
  }
//+------------------------------------------------------------------+
//| Get the volume of the selected position                          |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::Volume(void)
  {
   double pos_volume = WRONG_VALUE;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_volume = m_curr_deal.Volume();
//---
   return(pos_volume);
  }
//+------------------------------------------------------------------+
//| Get the opening price of the selected position                   |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::PriceOpen(void)
  {
   double pos_price = WRONG_VALUE;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_price = m_curr_deal.Price();
//---
   return(pos_price);
  }
//+------------------------------------------------------------------+
//| Get the Stop Loss price of the selected position                 |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::StopLoss(void) const
  {
   double pos_stoploss = WRONG_VALUE;
   long reason;
   CHistoryOrderInfo m_curr_order;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_order.SelectByIndex(HistoryOrdersTotal() - 1))
         if(m_curr_order.InfoInteger(ORDER_REASON, reason))
            if(reason == ORDER_REASON_SL)
               pos_stoploss = m_curr_order.PriceOpen();
            else
               if(m_curr_order.SelectByIndex(0))
                  pos_stoploss = m_curr_order.StopLoss();
//---
   return(pos_stoploss);
  }
//+------------------------------------------------------------------+
//| Get the Take Profit price of the selected position               |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::TakeProfit(void) const
  {
   double pos_takeprofit = WRONG_VALUE;
   long reason;
   CHistoryOrderInfo m_curr_order;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_order.SelectByIndex(HistoryOrdersTotal() - 1))
         if(m_curr_order.InfoInteger(ORDER_REASON, reason))
            if(reason == ORDER_REASON_TP)
               pos_takeprofit = m_curr_order.PriceOpen();
            else
               if(m_curr_order.SelectByIndex(0))
                  pos_takeprofit = m_curr_order.TakeProfit();
//---
   return(pos_takeprofit);
  }
//+------------------------------------------------------------------+
//| Get the closing price of the selected position                   |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::PriceClose(void)
  {
   double pos_cprice = WRONG_VALUE;
   double sumVolTemp = 0;
   double sumMulTemp = 0;
//--- if valid selection
   if(m_curr_ticket)
      for(int i = 0; i < HistoryDealsTotal(); i++)
         if(m_curr_deal.SelectByIndex(i))
            if(m_curr_deal.Entry() == DEAL_ENTRY_OUT || m_curr_deal.Entry() == DEAL_ENTRY_OUT_BY)
              {
               sumVolTemp += m_curr_deal.Volume();
               sumMulTemp += m_curr_deal.Price() * m_curr_deal.Volume();
               pos_cprice = sumMulTemp / sumVolTemp;
              }
//---
   return(pos_cprice);
  }
//+------------------------------------------------------------------+
//| Get the amount of commission of the selected position            |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::Commission(void)
  {
   double pos_commission = 0;
//--- if valid selection
   if(m_curr_ticket)
      for(int i = 0; i < HistoryDealsTotal(); i++)
         if(m_curr_deal.SelectByIndex(i))
            pos_commission += m_curr_deal.Commission();
//---
   return(pos_commission);
  }
//+------------------------------------------------------------------+
//| Get the amount of swap of the selected position                  |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::Swap(void)
  {
   double pos_swap = 0;
//--- if valid selection
   if(m_curr_ticket)
      for(int i = 0; i < HistoryDealsTotal(); i++)
         if(m_curr_deal.SelectByIndex(i))
            pos_swap += m_curr_deal.Swap();
//---
   return(pos_swap);
  }
//+------------------------------------------------------------------+
//| Get the amount of profit of the selected position                |
//+------------------------------------------------------------------+
double CHistoryPositionInfo::Profit(void)
  {
   double pos_profit = 0;
//--- if valid selection
   if(m_curr_ticket)
      for(int i = 0; i < HistoryDealsTotal(); i++)
         if(m_curr_deal.SelectByIndex(i))
            if(m_curr_deal.Entry() == DEAL_ENTRY_OUT || m_curr_deal.Entry() == DEAL_ENTRY_OUT_BY)
               pos_profit += m_curr_deal.Profit();
//---
   return(pos_profit);
  }
//+------------------------------------------------------------------+
//| Get the symbol name of the selected position                     |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::Symbol(void)
  {
   string pos_symbol = NULL;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_symbol = m_curr_deal.Symbol();
//---
   return(pos_symbol);
  }
//+------------------------------------------------------------------+
//| Get the opening comment of the selected position                 |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::OpenComment(void)
  {
   string pos_comment = NULL;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(0))
         pos_comment = m_curr_deal.Comment();
//---
   return(pos_comment);
  }
//+------------------------------------------------------------------+
//| Get the closing comment of the selected position                 |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::CloseComment(void)
  {
   string pos_comment = NULL;
//--- if valid selection
   if(m_curr_ticket)
      if(m_curr_deal.SelectByIndex(HistoryDealsTotal() - 1))
         pos_comment = m_curr_deal.Comment();
//---
   return(pos_comment);
  }
//+------------------------------------------------------------------+
//| Get the opening reason of the selected position as string        |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::OpenReasonDescription(void)
  {
   string str;
//---
   return(FormatReason(str, OpenReason()));
  }
//+------------------------------------------------------------------+
//| Get the closing reason of the selected position as string        |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::CloseReasonDescription(void)
  {
   string str;
//---
   return(FormatReason(str, CloseReason()));
  }
//+------------------------------------------------------------------+
//| Get all the deal tickets of the selected position as string      |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::DealTickets(const string separator = " ")
  {
   string str_deals = "";
//--- if valid selection
   if(m_curr_ticket)
      for(int i = 0; i < HistoryDealsTotal(); i++)
         if(m_curr_deal.SelectByIndex(i))
           {
            if(str_deals != "")
               str_deals += separator;
            str_deals += (string)m_curr_deal.Ticket();
           }
//---
   return(str_deals);
  }
//+------------------------------------------------------------------+
//| Converts the position type to text                               |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::FormatType(string &str, const uint type) const
  {
//--- clean
   str = "";
//--- see the type
   switch(type)
     {
      case POSITION_TYPE_BUY :
         str = "BUY";
         break;
      case POSITION_TYPE_SELL:
         str = "SELL";
         break;
      default                :
         str = "TYPE_UNKNOWN " + (string)type;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_REASON" as string                   |
//+------------------------------------------------------------------+
string CHistoryPositionInfo::FormatReason(string &str, const uint reason) const
  {
//--- clean
   str = "";
//--- see the reason
   switch(reason)
     {
      case DEAL_REASON_CLIENT  :
         str = "CLIENT";
         break;
      case DEAL_REASON_MOBILE  :
         str = "MOBILE";
         break;
      case DEAL_REASON_WEB     :
         str = "WEB";
         break;
      case DEAL_REASON_EXPERT  :
         str = "EXPERT";
         break;
      case DEAL_REASON_SL      :
         str = "STOP_LOSS";
         break;
      case DEAL_REASON_TP      :
         str = "TAKE_PROFIT";
         break;
      case DEAL_REASON_SO      :
         str = "SO";
         break;
      case DEAL_REASON_ROLLOVER:
         str = "ROLLOVER";
         break;
      case DEAL_REASON_VMARGIN :
         str = "VMARGiN";
         break;
      case DEAL_REASON_SPLIT   :
         str = "SPLIT";
         break;
      default:
         str = "REASON UNKNOWN " + (string)reason;
         break;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Retrieve the history of closed positions for the specified period|
//+------------------------------------------------------------------+
bool CHistoryPositionInfo::HistorySelect(datetime from_date = 0, datetime to_date = D'3000.01.01')
  {
//--- request the history of deals and orders for the specified period
   if(!::HistorySelect(from_date, to_date))
     {
      Print(__FUNCTION__ + " > Error: HistorySelect -> false. Error Code: ", GetLastError());
      return(false);
     }
//--- clear all cached position ids on new requests to the history
   m_tickets.Shutdown();
//--- define a hashset to collect position IDs (with no duplicates)
   CHashSet<long>set_positions;
   long curr_pos_id;
//--- collect position ids of history deals into the hashset,
//--- handle the case when a position has multiple deals out.
   int deals = HistoryDealsTotal();
//---
   for(int i = deals - 1; i >= 0 && !IsStopped(); i--)
      if(m_curr_deal.SelectByIndex(i))
         if(m_curr_deal.Entry() == DEAL_ENTRY_OUT || m_curr_deal.Entry() == DEAL_ENTRY_OUT_BY)
            if(m_curr_deal.DealType() == DEAL_TYPE_BUY || m_curr_deal.DealType() == DEAL_TYPE_SELL)
               if((curr_pos_id = m_curr_deal.PositionId()) > 0)
                  set_positions.Add(curr_pos_id);
   long arr_positions[];
//--- copy the elements from the set to a compatible one-dimensional array
   set_positions.CopyTo(arr_positions, 0);
   ArraySetAsSeries(arr_positions, true);
//--- filter out all the open or partially closed positions.
//--- copy the remaining fully closed positions to the member array
   int positions = ArraySize(arr_positions);
   for(int i = 0; i < positions && !IsStopped(); i++)
      if((curr_pos_id = arr_positions[i]) > 0)
         if(HistoryPositionSelect(curr_pos_id))
            if(HistoryPositionCheck(0))
               if(!m_tickets.Add(curr_pos_id))
                 {
                  Print(__FUNCTION__ + " > Error: failed to add position ticket #", curr_pos_id);
                  return(false);
                 }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Return the number of closed positions for the specified period   |
//+------------------------------------------------------------------+
int CHistoryPositionInfo::PositionsTotal(void) const
  {
   return(m_tickets.Total());
  }
//+------------------------------------------------------------------+
//| Select position by its ticket or identifier for further operation |
//+------------------------------------------------------------------+
bool CHistoryPositionInfo::SelectByTicket(const ulong ticket, const int logLevel=1)
  {
   if(HistoryPositionSelect(ticket))
     {
      if(HistoryPositionCheck(logLevel))
        {
         m_curr_ticket = ticket;
         return(true);
        }
     }
//--- invalid selection
   m_curr_ticket = 0;
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Select position by its index in the list for further operation   |
//| Note: The list of closed positions are ordered by closing time.  |
//+------------------------------------------------------------------+
bool CHistoryPositionInfo::SelectByIndex(const int index)
  {
   ulong curr_pos_ticket = m_tickets.At(index);
   if(curr_pos_ticket < LONG_MAX)
     {
      if(HistoryPositionSelect(curr_pos_ticket))
        {
         m_curr_ticket = curr_pos_ticket;
         return(true);
        }
     }
   else
      Print(__FUNCTION__ + " > Error: the index of selection is out of range.");
//--- invalid selection
   m_curr_ticket = 0;
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Retrieve history of deals and orders for the specified position  |
//+------------------------------------------------------------------+
bool CHistoryPositionInfo::HistoryPositionSelect(const long position_id) const
  {
   if(!HistorySelectByPosition(position_id))
     {
      Print(__FUNCTION__ + " > Error: HistorySelectByPosition -> false. Error Code: ", GetLastError());
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| check that the currently selected position is fully closed       |
//+------------------------------------------------------------------+
bool CHistoryPositionInfo::HistoryPositionCheck(const int log_level)
  {
//--- the first check - surely has to be one IN and one or more OUT
   int deals = HistoryDealsTotal();
   if(deals < 2)
     {
      if(log_level > 0)
         Print(__FUNCTION__ + " > Error: the selected position is still open.");
      return(false);
     }
   double pos_open_volume = 0;
   double pos_close_volume = 0;
   for(int j = 0; j < deals; j++)
     {
      if(m_curr_deal.SelectByIndex(j))
        {
         if(m_curr_deal.Entry() == DEAL_ENTRY_IN)
            pos_open_volume = m_curr_deal.Volume();
         else
            if(m_curr_deal.Entry() == DEAL_ENTRY_OUT || m_curr_deal.Entry() == DEAL_ENTRY_OUT_BY)
               pos_close_volume += m_curr_deal.Volume();
        }
      else
        {
         Print(__FUNCTION__ + " > Error: failed to select deal at index #", j);
         return(false);
        }
     }
//--- the second check - the total volume of IN minus OUT has to be equal to zero
//--- If a position is still open, it will not be displayed in the history.
   if(MathAbs(pos_open_volume - pos_close_volume) > 0.00001)
     {
      if(log_level > 0)
         Print(__FUNCTION__ + " > Error: the selected position is not yet fully closed.");
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
