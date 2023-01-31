//+------------------------------------------------------------------+
//|                                                       String.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CString
 {
public:
  static int                  StringContains(string str, string substr) { return (StringFind(str, substr, 0) != -1);}
  static bool                 StringStartsWith(string str, string strStart);
  static bool                 StringEndsWith(string str, string strEnd);
  static string               StringJoin(const string &a[], string sep = " ");
  static string               IntegerToHexString(int value);
  static bool                 IsEmptyOrNull(string str);
 };
//+------------------------------------------------------------------+
static bool CString::IsEmptyOrNull(string str)
 {
  if(str == NULL || str == "")
    return true;
  return false;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CString::StringStartsWith(string str, string strStart)
 {
  int len = StringLen(str);
  int lenStart = StringLen(strStart);

  if(len < lenStart)
   {
    return false;
   }

  for(int i = 0; i < lenStart; i++)
   {
    if(StringGetCharacter(str, i) != StringGetCharacter(strStart, i))
     {
      return false;
     }
   }
  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CString::StringEndsWith(string str, string strEnd)
 {
  int len = StringLen(str);
  int lenEnd = StringLen(strEnd);

  if(len < lenEnd)
   {
    return false;
   }

  for(int i = 1; i <= lenEnd; i++)
   {
    if(StringGetCharacter(str, len - i) != StringGetCharacter(strEnd, lenEnd - i))
     {
      return false;
     }
   }
  return true;
 }
//+------------------------------------------------------------------+
//| Join a string array                                              |
//+------------------------------------------------------------------+
static string CString::StringJoin(const string &a[], string sep = " ")
 {
  int size = ArraySize(a);
  string res = "";
  if(size > 0)
   {
    res += a[0];
    for(int i = 1; i < size; i++)
     {
      res += sep + a[i];
     }
   }
  return res;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static string CString::IntegerToHexString(int value)
 {
  static const string digits = "0123456789ABCDEF";
  string hex = "00000000";
  int    digit, shift = 28;
  for(int i = 0; i < 8; i++)
   {
    digit = (value >> shift) & 0x0F;
    StringSetCharacter(hex, i, digits[digit]);
    shift -= 4;
   }
  return(hex);
 }
//+------------------------------------------------------------------+