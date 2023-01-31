//+------------------------------------------------------------------+
//|                                                   Subscriber.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include <Mircea/_profitpoint/Zmq/Zmq.mqh>
#include <Mircea/_profitpoint/Include.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSubscriber
 {
private:
  Context*           _zmqContext;
  Socket*            _zmqSubscriber;
  ZmqMsg             _zmqMsg;
  string             _server;
  bool               _isRunning;
public:
                     CSubscriber(const string server, Context& context, Socket& socket);
                    ~CSubscriber() {Disconnect();}

  bool               Connect();
  string             RecieveMessage();
private:
  bool               Disconnect();
  bool               Heartbeat(); // TODO check connection status from time to time <!>
 };
//+------------------------------------------------------------------+
void CSubscriber::CSubscriber(const string server, Context& context, Socket& socket)
 {
  _zmqContext = GetPointer(context);
  _zmqSubscriber = GetPointer(socket);
  _server = server;
  _isRunning = false;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSubscriber::RecieveMessage()
 {
  string message;
  _zmqSubscriber.recv(_zmqMsg, true);
  message = _zmqMsg.getData();
  return message;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSubscriber::Connect()
 {
  if(CString::IsEmptyOrNull(_server))
   {
    LOG_ERROR("Zmq Subscriber Server name not existent");
    return false;
   }
  if(_zmqSubscriber.connect(_server) != 1)
   {
    LOG_ERROR("Error: Unable to connect to the server, please check your server settings or restart terminal");
    Alert("Error: Unable to connect to the server, please check your server settings or restart terminal");
    return false;
   }
   
  _zmqSubscriber.subscribe("");

  LOG_INFO(StringFormat("Connected Subscriber Server: %s", _server));
  _isRunning = true;
  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSubscriber::Disconnect()
 {
  if(CString::IsEmptyOrNull(_server))
   {
    LOG_ERROR("Zmq Subscriber Server name not existent");
    return false;
   }

  if(_isRunning == true)
   {
    _zmqSubscriber.unsubscribe("");
    _zmqSubscriber.disconnect(_server);
   }

  LOG_INFO(StringFormat("Disconnected Subscriber Server: %s", _server));
  _isRunning = true;
  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSubscriber::Heartbeat()
 {
  return true;
 }
//+------------------------------------------------------------------+
