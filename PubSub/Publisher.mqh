//+------------------------------------------------------------------+
//|                                                    Publisher.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


#include <Mircea/_profitpoint/Zmq/Zmq.mqh>
#include <Mircea/_profitpoint/Include.mqh>

class CPublisher
 {

public:
  Context*           _zmqContext;
  Socket*             _zmqPublisher;
  string             _server;
  bool               _isRunning;
public:
                     CPublisher(const string server,Context &context, Socket& socket);
                    ~CPublisher() {Stop();}


  bool               Publish(const string &message);
  bool               Start();
private:
  bool               Stop();
 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublisher::CPublisher(const string server ,Context &context, Socket& socket)
 {
  _zmqContext = GetPointer(context);
  _zmqPublisher = GetPointer(socket);
  _server = server;
  _isRunning = false;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPublisher::Start()
 {
  if(CString::IsEmptyOrNull(_server))
   {
    LOG_ERROR("Zmq Publisher Server name not existent");
    return false;
   }
  if(_zmqPublisher.bind(_server) != 1)
   {
    LOG_ERROR("Error: Unable to bind, please check your server settings");
    return false;
   }
  LOG_INFO(StringFormat("Load Publisher Server: %s", _server));
  _isRunning = true;
  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPublisher::Stop()
 {
  if(CString::IsEmptyOrNull(_server))
    return false;

  if(_isRunning == true)
    _zmqPublisher.unbind(_server);

  LOG_INFO(StringFormat("Publisher %s stopped", _server));

  return true;
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPublisher::Publish(const string &message)
 {
  if(CString::IsEmptyOrNull(message))
    return false;

  ZmqMsg zmqReplyMsg(message);

  int result = _zmqPublisher.send(zmqReplyMsg);

  return (result == 1) ? true : false;
 }
//+------------------------------------------------------------------+
