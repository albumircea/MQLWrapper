//+------------------------------------------------------------------+
//|                                                   SymbolInfo.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"


/*
TODO
NON Static functins for Instance
*/
#include "Account.mqh"
#include <Mircea/_profitpoint/Defines.mqh>
#include <Object.mqh>
#include <Mircea/_profitpoint/Common/Math.mqh>
#include <Mircea/_profitpoint/Logger.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymbolInfo final: public CObject
  {
                     ObjectAttr(string, Symbol);
public:
   static bool        IsSelected(string symbol)  {return SymbolInfoInteger(symbol, SYMBOL_SELECT) != 0;}
   static bool        IsVisible(string symbol)   {return SymbolInfoInteger(symbol, SYMBOL_VISIBLE) != 0;}

   //-- symbol info string
   static string      GetDescription(string symbol)    {return SymbolInfoString(symbol, SYMBOL_DESCRIPTION);}
   static string      GetPath(string symbol)           {return SymbolInfoString(symbol, SYMBOL_PATH);}
   static string      GetBaseCurrency(string symbol)   {return SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);}
   static string      GetProfitCurrency(string symbol) {return SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);}
   static string      GetMarginCurrency(string symbol) {return SymbolInfoString(symbol, SYMBOL_CURRENCY_MARGIN);}

   //-- trade mode
   static ENUM_SYMBOL_TRADE_MODE GetTradeMode(string symbol)   {return(ENUM_SYMBOL_TRADE_MODE)SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE);}
   static bool        IsTradeDisabled(string symbol)            {return GetTradeMode(symbol) == SYMBOL_TRADE_MODE_DISABLED;}
   static bool        IsTradeFully(string symbol)               {return GetTradeMode(symbol) == SYMBOL_TRADE_MODE_FULL;}
   static bool        IsTradeShortOnly(string symbol)           {return GetTradeMode(symbol) == SYMBOL_TRADE_MODE_SHORTONLY;}
   static bool        IsTradeLongOnly(string symbol)            {return GetTradeMode(symbol) == SYMBOL_TRADE_MODE_LONGONLY;}
   static bool        IsTradeCloseOnly(string symbol)           {return GetTradeMode(symbol) == SYMBOL_TRADE_MODE_CLOSEONLY;}

   static bool        SymbolExist_(string symbol);


   //-- execution mode
   static ENUM_SYMBOL_TRADE_EXECUTION GetTradeExecMode(string symbol) {return(ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);}
   static bool        IsTradeExecMarket(string symbol)                 {return GetTradeExecMode(symbol) == SYMBOL_TRADE_EXECUTION_MARKET;}
   static bool        IsTradeExecInstant(string symbol)                {return GetTradeExecMode(symbol) == SYMBOL_TRADE_EXECUTION_INSTANT;}
   static bool        IsTradeExecRequest(string symbol)                {return GetTradeExecMode(symbol) == SYMBOL_TRADE_EXECUTION_REQUEST;}
   static bool        IsTradeExecExchange(string symbol)               {return GetTradeExecMode(symbol) == SYMBOL_TRADE_EXECUTION_EXCHANGE;}

   static double      GetMarginInitial(string symbol)        {return SymbolInfoDouble(symbol, SYMBOL_MARGIN_INITIAL);}
   static double      GetMarginMaintenance(string symbol)    {return SymbolInfoDouble(symbol, SYMBOL_MARGIN_MAINTENANCE);}

   static double      GetSwapLong(string symbol)             {return SymbolInfoDouble(symbol, SYMBOL_SWAP_LONG);}
   static double      GetSwapShort(string symbol)            {return SymbolInfoDouble(symbol, SYMBOL_SWAP_SHORT);}


#ifdef __MQL5__
   static double      GetHedgedMargin1Lot(string symbol)     {return SymbolInfoDouble(symbol, SYMBOL_MARGIN_HEDGED);}
#endif

   //-- latest market info
   static double      GetBid(string symbol)                     {return SymbolInfoDouble(symbol, SYMBOL_BID);}
   static double      GetAsk(string symbol)                     {return SymbolInfoDouble(symbol, SYMBOL_ASK);}
   static double      GetMidPrice(string symbol)             {return (GetAsk(symbol) + GetBid(symbol)) / 2;}
   static bool        GetTick(string symbol, MqlTick &tick)  {return SymbolInfoTick(symbol, tick);}

   static double      GetTickSize(string symbol)             {return SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);}
   static double      GetTickValue(string symbol)            {return SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);}
   static double      GetContractSize(string symbol)         {return SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);}
   static double      GetContractFromLotSize(string symbol, double lotSize) {return lotSize * GetContractSize(symbol);}
   static double      GetLotSizeFromContract(string symbol, double contracts) {return (contracts / GetContractSize(symbol));}



   //-- basic trade info
   static double      GetPoint(string symbol)       {return SymbolInfoDouble(symbol, SYMBOL_POINT);}
   static double      GetPointValue(string symbol);
   static int         GetDigits(string symbol)      {return (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);}
   static int         GetSpread(string symbol)      {return (int)SymbolInfoInteger(symbol, SYMBOL_SPREAD);}
   static bool        IsSpreadFloat(string symbol)  {return SymbolInfoInteger(symbol, SYMBOL_SPREAD_FLOAT) != 0;};
   static int         GetStopLevel(string symbol)   {return(int)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);}
   static int         getFreezeLevel(string symbol) {return(int)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);}

   //-- lot info
   static double      GetMinLot(string symbol) {return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);}
   static double      GetLotStep(string symbol) {return SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);}
   static double      GetMaxLot(string symbol) {return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);}

   //-- utility methods
   static double      NormalizeLotsDown(string symbol, double lots) {return CMath::RoundDownToMultiple(lots, GetMinLot(symbol));}
   static double      NormalizePrice(string symbol, double price) {return NormalizeDouble(price, GetDigits(symbol));}

   static double      AddPoints(string symbol, double price, int points) {return NormalizeDouble(price + points * GetPoint(symbol), GetDigits(symbol));}
   static double      SubPoints(string symbol, double price, int points) {return NormalizeDouble(price - points * GetPoint(symbol), GetDigits(symbol));}


   //--- op%2==0 means a buy operation: OP_BUY OP_BUYLIMIT OP_BUYSTOP
   // OP_BUY       0 Buy operation
   // OP_SELL      1 Sell operation
   // OP_BUYLIMIT  2 Buy limit pending order
   // OP_SELLLIMIT 3 Sell limit pending order
   // OP_BUYSTOP   4 Buy stop pending order
   // OP_SELLSTOP  5 Sell stop pending order
   static double      PriceForOpen(string symbol, int op) {return DirectionBuy(op) ? GetAsk(symbol) : GetBid(symbol);}
   static double      priceForClose(string symbol, int op) {return DirectionBuy(op) ? GetBid(symbol) : GetAsk(symbol);}
   static int         Direction(int op) {return((op & 1) == 0) ? 1 : -1;}
   static bool        DirectionBuy(int op) {return(op & 1) == 0;}

   static double      GetMarginReqiredRaw(const string symbol, const double lots); //Not finished TODO

#ifdef __MQL4__
   static double      GetMarginRequired(string symbol) {return MarketInfo(symbol, MODE_MARGINREQUIRED);}
   //-- Profit calculation mode. 0 - Forex; 1 - CFD; 2 - Futures
   static int         GetProfitCalcMode(string symbol) {return (int)SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE);}
   //-- Margin calculation mode. 0 - Forex; 1 - CFD; 2 - Futures; 3 - CFD for indices
   static int         GetMarginCalcMode(string symbol) {return(int)MarketInfo(symbol, MODE_MARGINCALCMODE);}

   static bool        IsCloseByAllowed(string symbol) {return(int)MarketInfo(symbol, MODE_CLOSEBY_ALLOWED) != 0;}

#else
   static double      GetMarginRequired(string symbol, double lots = 1.0, ENUM_ORDER_TYPE ordeType = ORDER_TYPE_BUY) {double margin; bool res = OrderCalcMargin(ordeType, symbol, lots, SymbolInfoDouble(symbol, SYMBOL_ASK), margin); return margin;}

   static ENUM_SYMBOL_CALC_MODE        GetCalcMode(string symbol) {return (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE);}

   //static int        GetMarginCalcMode(string symbol) {return(int)MarketInfo(symbol, MODE_MARGINCALCMODE);}
   //static bool       IsCloseByAllowed(string symbol) {return(int)MarketInfo(symbol, MODE_CLOSEBY_ALLOWED) != 0;}
private:

#endif
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static double CSymbolInfo::GetPointValue(string symbol)
  {
   double tickValue        = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   double point            = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double tickSize         = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);

   double ticksPerPoint    = tickSize  / point;
   double pointValue       = tickValue / ticksPerPoint;

   return pointValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static double CSymbolInfo::GetMarginReqiredRaw(const string symbol, const double lots) //Not finished
  {
   int leverage = (int) CAccount::GetLeverage();


#ifdef __MQL4__




   double marginRequiredLot = CSymbolInfo::GetMarginRequired(symbol);
   double marginAmmount = GetContractSize(symbol) * GetAsk(symbol);


   double marginPercentage = marginRequiredLot / marginAmmount * 100;


   return NormalizeDouble((lots * marginRequiredLot * leverage) / marginPercentage, 2);


#endif


#ifdef __MQL5__

   double marginRequired = CSymbolInfo::GetMarginRequired(symbol, lots, ORDER_TYPE_BUY);

   double marginRateInitial;
   double marginRateMaintainance;
   double marginRequiredRaw = 0;
   SymbolInfoMarginRate(symbol, ORDER_TYPE_BUY, marginRateInitial, marginRateMaintainance);

   if(marginRateInitial == 0)
     {
      LOG_ERROR("Margin Rate Initial is 0, cannot perform any actions [Divide by zero]");
      return 0;
     }

   ENUM_SYMBOL_CALC_MODE calcMode = GetCalcMode(symbol);
   switch(calcMode)
     {
      case SYMBOL_CALC_MODE_FOREX:
         marginRequiredRaw = marginRequired * leverage / marginRateInitial;
         return NormalizeDouble(marginRequiredRaw, 2);

      case SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE:
         marginRequiredRaw = marginRequired / marginRateInitial;
         return NormalizeDouble(marginRequiredRaw, 2);

      case SYMBOL_CALC_MODE_CFD://pot sa fac merge cu aia de mai sus daca imi dau filme
         marginRequiredRaw = marginRequired / marginRateInitial;
         return NormalizeDouble(marginRequiredRaw, 2);

      case SYMBOL_CALC_MODE_CFDINDEX://TODO
      case SYMBOL_CALC_MODE_CFDLEVERAGE://TODO
        {
         LOG_ERROR("Margin calc mode not implemented");
         break;
        }
      default:
        {
         PrintFormat("[ERROR] | Calc Mode Undefined [%s]", EnumToString(calcMode));
         return 0;
        }
     }
   return 0;
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolInfo::SymbolExist_(string symbol)
  {
#ifdef __MQL5__
   bool isCustom;
   return SymbolExist(symbol, isCustom);
#endif
#ifdef __MQL4__
   double bid = MarketInfo(symbol, MODE_BID);
   int err = GetLastError();
   if(err == 4106)
      return false;
   return true;
#endif
  }
//+------------------------------------------------------------------+
