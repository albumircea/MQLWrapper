//+------------------------------------------------------------------+
//|                                              CPairedDealInfo.mqh |
//|                                        Copyright © 2018, Amr Ali |
//|                             https://www.mql5.com/en/users/amrali |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Amr Ali"
#property link "https://www.mql5.com/en/users/amrali"
#property version "2.000"
#property description "A class for easy access to the paired deals properties."
//--- include
#include <Arrays/ArrayLong.mqh>
#include <Generic/HashMap.mqh>
#include <Mircea/_profitpoint/Logger.mqh>
#include <Mircea/_profitpoint/Trade/MQL5/DealInfo.mqh>
//+------------------------------------------------------------------+
//| Class CPairedDealInfo.                                           |
//| Appointment: Class to rebuild closed trades from history deals.  |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CPairedDealInfo : public CObject
  {
protected:
   ulong             m_curr_ticket_in;  // ticket of entry deal
   ulong             m_curr_ticket_out; // ticket of exit deal
   CArrayLong        m_tickets_in;
   CArrayLong        m_tickets_out;
   CHashMap<ulong, ulong> m_DealsIn;

public:
                     CPairedDealInfo(void);
                    ~CPairedDealInfo(void);
   //--- methods of access to protected data
   ulong             TicketOpen(void) const { return (m_curr_ticket_in); }
   ulong             TicketClose(void) const { return (m_curr_ticket_out); }
   //--- fast access methods to the integer deal properties
   datetime          TimeOpen(void) const;
   ulong             TimeOpenMsc(void) const;
   datetime          TimeClose(void) const;
   ulong             TimeCloseMsc(void) const;
   ENUM_DEAL_TYPE    DealType(void) const;
   string            TypeDescription(void) const;
   long              Magic(void) const;
   long              PositionId(void) const;
   long              OrderOpen(void) const;
   long              OrderClose(void) const;
   ENUM_DEAL_REASON  OpenReason(void) const;
   ENUM_DEAL_REASON  CloseReason(void) const;
   //--- fast access methods to the double deal properties
   double            Volume(void) const;
   double            PriceOpen(void) const;
   double            StopLoss(void) const;
   double            TakeProfit(void) const;
   double            PriceClose(void) const;
   double            Commission(void) const;
   double            Swap(void) const;
   double            Profit(void) const;
   //--- fast access methods to the string deal properties
   string            Symbol(void) const;
   string            OpenComment(void) const;
   string            CloseComment(void) const;
   string            OpenReasonDescription(void) const;
   string            CloseReasonDescription(void) const;
   //--- info methods
   string            FormatAction(string &str, const uint action) const;
   string            FormatReason(string &str, const uint reason) const;
   //--- method for select deals
   virtual bool      HistorySelect(datetime from_date, datetime to_date);
   int               Total(void) const;
   bool              SelectByTicket(const ulong ticket);
   bool              SelectByIndex(const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPairedDealInfo::CPairedDealInfo(void) : m_curr_ticket_in(0),
   m_curr_ticket_out(0)
  {
//--- account margin mode
   ENUM_ACCOUNT_MARGIN_MODE margin_mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   if(margin_mode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
     {
      Print(__FUNCTION__ + " > Error: no retail hedging!");
     }
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPairedDealInfo::~CPairedDealInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TIME"                               |
//+------------------------------------------------------------------+
datetime CPairedDealInfo::TimeOpen(void) const
  {
   return ((datetime)HistoryDealGetInteger(m_curr_ticket_in, DEAL_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TIME_MSC"                           |
//+------------------------------------------------------------------+
ulong CPairedDealInfo::TimeOpenMsc(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_in, DEAL_TIME_MSC));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TIME"                               |
//+------------------------------------------------------------------+
datetime CPairedDealInfo::TimeClose(void) const
  {
   return ((datetime)HistoryDealGetInteger(m_curr_ticket_out, DEAL_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TIME_MSC"                           |
//+------------------------------------------------------------------+
ulong CPairedDealInfo::TimeCloseMsc(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_out, DEAL_TIME_MSC));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TYPE"                               |
//+------------------------------------------------------------------+
ENUM_DEAL_TYPE CPairedDealInfo::DealType(void) const
  {
   return ((ENUM_DEAL_TYPE)HistoryDealGetInteger(m_curr_ticket_in, DEAL_TYPE));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TYPE" as string                     |
//+------------------------------------------------------------------+
string CPairedDealInfo::TypeDescription(void) const
  {
   string str;
//---
   return (FormatAction(str, DealType()));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_MAGIC"                              |
//+------------------------------------------------------------------+
long CPairedDealInfo::Magic(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_in, DEAL_MAGIC));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_POSITION_ID"                        |
//+------------------------------------------------------------------+
long CPairedDealInfo::PositionId(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_in, DEAL_POSITION_ID));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_ORDER"                              |
//+------------------------------------------------------------------+
long CPairedDealInfo::OrderOpen(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_in, DEAL_ORDER));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_ORDER"                              |
//+------------------------------------------------------------------+
long CPairedDealInfo::OrderClose(void) const
  {
   return (HistoryDealGetInteger(m_curr_ticket_out, DEAL_ORDER));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_REASON"                             |
//+------------------------------------------------------------------+
ENUM_DEAL_REASON CPairedDealInfo::OpenReason(void) const
  {
   return ((ENUM_DEAL_REASON)HistoryDealGetInteger(m_curr_ticket_in, DEAL_REASON));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_REASON"                             |
//+------------------------------------------------------------------+
ENUM_DEAL_REASON CPairedDealInfo::CloseReason(void) const
  {
   return ((ENUM_DEAL_REASON)HistoryDealGetInteger(m_curr_ticket_out, DEAL_REASON));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_VOLUME"                             |
//+------------------------------------------------------------------+
double CPairedDealInfo::Volume(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_PRICE"                              |
//+------------------------------------------------------------------+
double CPairedDealInfo::PriceOpen(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_in, DEAL_PRICE));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_SL"                                 |
//+------------------------------------------------------------------+
double CPairedDealInfo::StopLoss(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_SL));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_TP"                                 |
//+------------------------------------------------------------------+
double CPairedDealInfo::TakeProfit(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_TP));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_PRICE"                              |
//+------------------------------------------------------------------+
double CPairedDealInfo::PriceClose(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_PRICE));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_COMMISSION"                         |
//+------------------------------------------------------------------+
double CPairedDealInfo::Commission(void) const
  {
   double open_volume = HistoryDealGetDouble(m_curr_ticket_in, DEAL_VOLUME);
   double open_commission = HistoryDealGetDouble(m_curr_ticket_in, DEAL_COMMISSION);
   double close_volume = HistoryDealGetDouble(m_curr_ticket_out, DEAL_VOLUME);
   double close_commission = HistoryDealGetDouble(m_curr_ticket_out, DEAL_COMMISSION);

   if(open_volume == 0)
     {
      return 0;
     }
   double commission = close_commission + open_commission * (close_volume / open_volume);
   return (commission);
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_SWAP"                               |
//+------------------------------------------------------------------+
double CPairedDealInfo::Swap(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_SWAP));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_PROFIT"                             |
//+------------------------------------------------------------------+
double CPairedDealInfo::Profit(void) const
  {
   return (HistoryDealGetDouble(m_curr_ticket_out, DEAL_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_SYMBOL"                             |
//+------------------------------------------------------------------+
string CPairedDealInfo::Symbol(void) const
  {
   return (HistoryDealGetString(m_curr_ticket_in, DEAL_SYMBOL));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_COMMENT"                            |
//+------------------------------------------------------------------+
string CPairedDealInfo::OpenComment(void) const
  {
   return (HistoryDealGetString(m_curr_ticket_in, DEAL_COMMENT));
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_COMMENT"                            |
//+------------------------------------------------------------------+
string CPairedDealInfo::CloseComment(void) const
  {
   return (HistoryDealGetString(m_curr_ticket_out, DEAL_COMMENT));
  }
//+------------------------------------------------------------------+
//| Get the opening reason of the selected deal as string            |
//+------------------------------------------------------------------+
string CPairedDealInfo::OpenReasonDescription(void) const
  {
   string str;
//---
   return (FormatReason(str, OpenReason()));
  }
//+------------------------------------------------------------------+
//| Get the closing reason of the selected deal as string            |
//+------------------------------------------------------------------+
string CPairedDealInfo::CloseReasonDescription(void) const
  {
   string str;
//---
   return (FormatReason(str, CloseReason()));
  }
//+------------------------------------------------------------------+
//| Converts the type of a deal to text                              |
//+------------------------------------------------------------------+
string CPairedDealInfo::FormatAction(string &str, const uint action) const
  {
//--- clean
   str = "";
//--- see the type
   switch(action)
     {
      case DEAL_TYPE_BUY:
         str = "buy";
         break;
      case DEAL_TYPE_SELL:
         str = "sell";
         break;
      case DEAL_TYPE_BALANCE:
         str = "balance";
         break;
      case DEAL_TYPE_CREDIT:
         str = "credit";
         break;
      case DEAL_TYPE_CHARGE:
         str = "charge";
         break;
      case DEAL_TYPE_CORRECTION:
         str = "correction";
         break;
      case DEAL_TYPE_BONUS:
         str = "bonus";
         break;
      case DEAL_TYPE_COMMISSION:
         str = "commission";
         break;
      case DEAL_TYPE_COMMISSION_DAILY:
         str = "daily commission";
         break;
      case DEAL_TYPE_COMMISSION_MONTHLY:
         str = "monthly commission";
         break;
      case DEAL_TYPE_COMMISSION_AGENT_DAILY:
         str = "daily agent commission";
         break;
      case DEAL_TYPE_COMMISSION_AGENT_MONTHLY:
         str = "monthly agent commission";
         break;
      case DEAL_TYPE_INTEREST:
         str = "interest rate";
         break;
      case DEAL_TYPE_BUY_CANCELED:
         str = "canceled buy";
         break;
      case DEAL_TYPE_SELL_CANCELED:
         str = "canceled sell";
         break;
      default:
         str = "unknown deal type " + (string)action;
     }
//--- return the result
   return (str);
  }
//+------------------------------------------------------------------+
//| Get the property value "DEAL_REASON" as string                   |
//+------------------------------------------------------------------+
string CPairedDealInfo::FormatReason(string &str, const uint reason) const
  {
//--- clean
   str = "";
//--- see the reason
   switch(reason)
     {
      case DEAL_REASON_CLIENT:
         str = "client";
         break;
      case DEAL_REASON_MOBILE:
         str = "mobile";
         break;
      case DEAL_REASON_WEB:
         str = "web";
         break;
      case DEAL_REASON_EXPERT:
         str = "expert";
         break;
      case DEAL_REASON_SL:
         str = "sl";
         break;
      case DEAL_REASON_TP:
         str = "tp";
         break;
      case DEAL_REASON_SO:
         str = "so";
         break;
      case DEAL_REASON_ROLLOVER:
         str = "rollover";
         break;
      case DEAL_REASON_VMARGIN:
         str = "vmargin";
         break;
      case DEAL_REASON_SPLIT:
         str = "split";
         break;
      default:
         str = "unknown reason " + (string)reason;
         break;
     }
//--- return the result
   return (str);
  }
//+------------------------------------------------------------------+
//| Reconstruct deals from history upon selection                    |
//+------------------------------------------------------------------+
bool CPairedDealInfo::HistorySelect(datetime from_date = 0, datetime to_date = D'3000.01.01')
  {
//--- request the history of deals and orders for the specified period
   if(!::HistorySelect(from_date, to_date))
     {
      Print(__FUNCTION__ + " > Error: HistorySelect -> false. Error Code: ", GetLastError());
      return (false);
     }

//--- clear cached tickets on new requests to the history
   m_tickets_in.Shutdown();
   m_tickets_out.Shutdown();
   m_DealsIn.Clear();

//--- variable to hold the current deal object
   CDealInfo deal;

//--- now process the list of received deals
   int deals = HistoryDealsTotal();
   for(int i = 0; i < deals && !IsStopped(); i++)
      if(deal.SelectByIndex(i))
        {



         if(deal.DealType() == DEAL_TYPE_BALANCE)
           {
            m_tickets_in.Add(deal.Ticket());
            m_tickets_out.Add(deal.Ticket());
            continue;
           }
         //--- Entry deal: add to hash table <POS_ID, ticket>
         if(deal.Entry() == DEAL_ENTRY_IN)
           {
            //--- hash map of <pos_id, deal_in_ticket> pairs
            m_DealsIn.Add(deal.PositionId(), deal.Ticket());
           }
         else
            //--- Exit deal: get paired entry ticket from hash table by POS_ID
            if(deal.Entry() == DEAL_ENTRY_OUT || deal.Entry() == DEAL_ENTRY_OUT_BY)
              {
               ulong entry_ticket = 0;
               if(m_DealsIn.TryGetValue(deal.PositionId(), entry_ticket))
                 {
                  //--- Store the in/out tickets pair
                  m_tickets_in.Add(entry_ticket);   // deal_in ticket
                  m_tickets_out.Add(deal.Ticket()); // deal_out ticket
                 }
               else
                 {
                  Print(__FUNCTION__ + " > Error: no matching entry deal could be found!");
                  return (false);
                 }
              }
        }
      else
        {
         Print(__FUNCTION__ + " > Error: failed to select deal at index #", i);
         return (false);
        }
//---
   return (true);
  }
//+------------------------------------------------------------------+
//| Total                                                            |
//+------------------------------------------------------------------+
int CPairedDealInfo::Total(void) const
  {
   return (m_tickets_in.Total());
  }
//+------------------------------------------------------------------+
//| Select a history trade by its deal-out ticket number             |
//+------------------------------------------------------------------+
bool CPairedDealInfo::SelectByTicket(const ulong ticket)
  {
   if(HistoryDealSelect(ticket))
     {
      long deal_entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
      long position_id = HistoryDealGetInteger(ticket, DEAL_POSITION_ID);
      //---
      if(deal_entry == DEAL_ENTRY_OUT || deal_entry == DEAL_ENTRY_OUT_BY)
        {
         if(HistorySelectByPosition(position_id))
           {
            m_curr_ticket_in = HistoryDealGetTicket(0);
            m_curr_ticket_out = ticket;
            return (true);
           }
         else
            Print(__FUNCTION__ + " > Error: HistorySelectByPosition -> false. Error Code: ", GetLastError());
        }
      else
         Print(__FUNCTION__ + " > Error: invalid deal entry type.");
     }
   else
      Print(__FUNCTION__ + " > Error: invalid deal ticket number.");

//--- invalid selection
   m_curr_ticket_in = 0;
   m_curr_ticket_out = 0;
//---
   return (false);
  }
//+------------------------------------------------------------------+
//| Select a history trade by its position in the list               |
//| Note: The list of closed trades is ordered by close time.        |
//+------------------------------------------------------------------+
bool CPairedDealInfo::SelectByIndex(const int index)
  {
   ulong curr_pos_ticket = m_tickets_in.At(index);
//--- check
   if(curr_pos_ticket < LONG_MAX)
     {
      m_curr_ticket_in = curr_pos_ticket;
      m_curr_ticket_out = m_tickets_out.At(index);
      return (true);
     }
   else
      Print(__FUNCTION__ + " > Error: the index of selection is out of range.");

//--- invalid selection
   m_curr_ticket_in = 0;
   m_curr_ticket_out = 0;
//---
   return (false);
  }
//+------------------------------------------------------------------+
