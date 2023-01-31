//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

#property strict
//+------------------------------------------------------------------+
//| Wraps the AccountInfoInteger/Double/String                       |
//+------------------------------------------------------------------+
class CAccount
  {
public:
   static long        GetLogin() {return AccountInfoInteger(ACCOUNT_LOGIN);}

   static ENUM_ACCOUNT_TRADE_MODE GetTradeMode() {return(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);}
   static bool        IsReal() {return CAccount::GetTradeMode() == ACCOUNT_TRADE_MODE_REAL;}
   static bool        IsDemo_() {return CAccount::GetTradeMode() == ACCOUNT_TRADE_MODE_DEMO;}
   static bool        IsContest() {return CAccount::GetTradeMode() == ACCOUNT_TRADE_MODE_CONTEST;}
   static long        GetLeverage() {return AccountInfoInteger(ACCOUNT_LEVERAGE);}
   static int         GetMaximumPendingOrders() {return(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);}
   //--- if account allows trade
   static bool        IsTradeAllowed_() {return AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) != 0;}
   //--- if accaunt allows trade of expert advisors from the server side
   static bool        IsTradeExpertAllowed() {return AccountInfoInteger(ACCOUNT_TRADE_EXPERT) != 0;}

   static ENUM_ACCOUNT_STOPOUT_MODE GetStopoutMode() {return(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);}
   static bool        IsPercentStopout() {return CAccount::GetStopoutMode() == ACCOUNT_STOPOUT_MODE_PERCENT;}
   static bool        isCurrencyStopout() {return CAccount::GetStopoutMode() == ACCOUNT_STOPOUT_MODE_MONEY;}

   static string      GetClientName() {return AccountInfoString(ACCOUNT_NAME);}
   static string      GetServerName() {return AccountInfoString(ACCOUNT_SERVER);}
   static string      GetCurrency() {return AccountInfoString(ACCOUNT_CURRENCY);}
   static string      GetCompany() {return AccountInfoString(ACCOUNT_COMPANY);}

   static double      GetBalance() {return AccountInfoDouble(ACCOUNT_BALANCE);}
   static double      GetCredit() {return AccountInfoDouble(ACCOUNT_CREDIT);}
   static double      GetProfit() {return AccountInfoDouble(ACCOUNT_PROFIT);}
   static double      GetFloatingProfit() {return CAccount::GetEquity() - CAccount::GetCredit() - CAccount::GetBalance();}
   static double      GetEquity() {return AccountInfoDouble(ACCOUNT_EQUITY);}
   static double      GetMargin() {return AccountInfoDouble(ACCOUNT_MARGIN);}
   static double      GetFreeMargin() {return AccountInfoDouble(ACCOUNT_MARGIN_FREE);}

#ifdef __MQL4__
   static int         GetFreeMarginCalcMode() {return AccountFreeMarginMode();}
   
   //Returns free margin that remains after the specified order has been opened at the current price on the current account
   static double            AccountFreeMarginCheck(const string symbol, const int cmd, const double volume) {return ::AccountFreeMarginCheck(symbol, cmd, volume);}
#endif

#ifdef __MQL5__
   //Returns free margin that remains after the specified order has been opened at the current price on the current account
   static double             AccountFreeMarginCheck(const string symbol, const int cmd, const double volume)
     {
      double margin;
      return(::OrderCalcMargin(
                (ENUM_ORDER_TYPE)cmd, symbol, volume,
                ::SymbolInfoDouble(symbol, (cmd ==::ORDER_TYPE_BUY) ? ::SYMBOL_ASK : ::SYMBOL_BID), margin) ?
             ::AccountInfoDouble(::ACCOUNT_MARGIN_FREE) - margin : -1);
     }
#endif

   static double      GetMarginLevel() {return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);}
   static double      GetMarginCallLevel() {return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);}
   static double      GetMarginStopoutLevel() {return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);}
  };

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
