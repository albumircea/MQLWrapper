//+------------------------------------------------------------------+
//|                                      PositionPartiallyClosed.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

#include <Arrays/ArrayLong.mqh>

#include "DealInfo.mqh"
#include "HistoryOrderInfo.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionPartiallyClosed
  {

private:
   long                    _currentPositionId;//Identifier
   long                   _dealIn;
   CArrayLong              _dealsOut;

public:
                     CPositionPartiallyClosed() {}
                    ~CPositionPartiallyClosed() {}


   void                GetDealsOut(long &copyArray[]) {_dealsOut.ToArray(copyArray);}
   long               GetDealIn() {return _dealIn;}
   long               GetLastDealOut() {return _dealsOut.At(_dealsOut.Total() - 1);}

   long             GetCurrentTicketOut();
   long             GetBeforeTicketOut();



public:
   bool              SelectByTicket(const long positionId);
   bool              HistoryPositionSelect(const long positionId);
protected:
   bool              IsPositionFullyClosed();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CPositionPartiallyClosed::GetCurrentTicketOut(void)
  {
   return _dealsOut.At(_dealsOut.Total() - 1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CPositionPartiallyClosed::GetBeforeTicketOut(void)
  {
   if(_dealsOut.Total() <= 1)
      return _currentPositionId;
   else
      return _dealsOut.At(_dealsOut.Total() - 2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionPartiallyClosed::SelectByTicket(const long positionId)
  {
   if(HistoryPositionSelect(positionId))
     {
      if(!IsPositionFullyClosed())
        {
         _currentPositionId = positionId;
         _dealsOut.Sort();
         return(true);
        }
     }
   _dealIn = 0;
   _currentPositionId = 0;
   _dealsOut.Shutdown();
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionPartiallyClosed::HistoryPositionSelect(const long positionId)
  {
   if(!HistorySelectByPosition(positionId))
     {
      Print(__FUNCTION__ + " > Error: HistorySelectByPosition -> false. Error Code: ", GetLastError());
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| check that the currently selected position is fully closed       |
//+------------------------------------------------------------------+
bool CPositionPartiallyClosed::IsPositionFullyClosed()
  {
   CDealInfo deal;
//--- the first check - surely has to be one IN and one or more OUT
   int deals = HistoryDealsTotal();
   if(deals < 2)
      return(false);

   double pos_open_volume = 0;
   double pos_close_volume = 0;
   for(int j = 0; j < deals; j++)
     {
      if(deal.SelectByIndex(j))
        {
         if(deal.Entry() == DEAL_ENTRY_IN)
           {
            pos_open_volume = deal.Volume();
            _dealIn =(long) deal.Ticket();
           }
         else
            if(deal.Entry() == DEAL_ENTRY_OUT || deal.Entry() == DEAL_ENTRY_OUT_BY)
              {
               pos_close_volume += deal.Volume();
               _dealsOut.Add(deal.Ticket());
              }
        }
      else
        {
         Print(__FUNCTION__ + " > Error: failed to select deal at index #", j);
         return(false);
        }
     }
//--- the second check - the total volume of IN minus OUT has to be equal to zero
//--- If a position is still open, it will not be displayed in the history.
   if(MathAbs(pos_open_volume - pos_close_volume) > 0.00001 || _dealsOut.Total() >= 2)
     {
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
