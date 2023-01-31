//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| Object getter/setter generator                                   |
//| ObjectAttr generates:                                            |
//| 1. private member m_property                                     |
//| 2. public method setProperty                                     |
//| 3. public method getProperty                                     |
//| ObjectAttrBool is specific to boolean type properties:           |
//| 1. private member m_isProperty                                   |
//| 2. public method setProperty                                     |
//| 3. public method isProperty                                      |
//| Use *Read or *Write versions for read only or write only         |
//| properties                                                       |
//+------------------------------------------------------------------+
#define ObjectAttr(Type, Name) \
public:\
   Type              Get##Name() {return m##Name;}\
   void              Set##Name(const Type value) {m##Name=value;}\
private:\
   Type              m##Name\

#define ObjectAttrRead(Type, Name) \
public:\
   Type              Get##Name() {return m##Name;}\
private:\
   Type              m##Name\

#define ObjectAttrWrite(Type, Name) \
public:\
   void              Set##Name(const Type value) {m##Name=value;}\
private:\
   Type              m##Name\

#define ObjectAttrBool(Name) \
public:\
   bool              Is##Name() {return mIs##Name;}\
   void              Set##Name(const bool value) {mIs##Name=value;}\
private:\
   bool              mIs##Name\

#define ObjectAttrBoolRead(Name) \
public:\
   bool              Is##Name() {return mIs##Public;}\
private:\
   bool              mIs##Name\

#define ObjectAttrBoolWrite(Name) \
public:\
   void              Set##Public(bool value) {mIs##Public=value;}\
private:\
   bool              m##Private\
   
#define ObjectAttrClass(Type, Name) \
public:\
   Type*              Get##Name() {return m##Name;}\
   void               Set##Name(Type& value) {m##Name=GetPointer(value);}\
private:\
   Type*              m##Name\
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define BEGIN_EXECUTE(Name) class __Execute##Name\
  {\
   public:__Execute##Name()\
     {
#define END_EXECUTE(Name) \
     }\
  }\
__execute##Name;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class __Type__
 {
public:
  static string      typename_modify(string tn)
   {
    int ptr_char_pos = StringFind(tn, "*");
    if(ptr_char_pos > 0)
      tn = StringSubstr(tn, 0, StringLen(tn) - 1);
    return tn;
   }
 };
 
 
 #define isInstance(VAR, VARTYPE) \
   (__Type__::typename_modify(typename(VAR)) == __Type__::typename_modify(typename(VARTYPE)))
 
 
/*
USAGE
Foo *foo_dynamic = new Foo();
Foo foo_static;

if(isinstance(foo_dynamic, Foo))
  Print("Pointers work");

if(isinstance(foo_static, Foo))
  Print("Static obj refs work");

if(!isinstance(1.23456, int))
  Print("implicitly cast double is not type int!");
*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+