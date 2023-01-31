//+------------------------------------------------------------------+
//| Module: Lang/Error.mqh                                           |
//| This file is part of the mql4-lib project:                       |
//|     https://github.com/dingmaotu/mql4-lib                        |
//|                                                                  |
//| Copyright 2016-2017 Li Ding <dingmaotu@126.com>                  |
//|                                                                  |
//| Licensed under the Apache License, Version 2.0 (the "License");  |
//| you may not use this file except in compliance with the License. |
//| You may obtain a copy of the License at                          |
//|                                                                  |
//|     http://www.apache.org/licenses/LICENSE-2.0                   |
//|                                                                  |
//| Unless required by applicable law or agreed to in writing,       |
//| software distributed under the License is distributed on an      |
//| "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,     |
//| either express or implied.                                       |
//| See the License for the specific language governing permissions  |
//| and limitations under the License.                               |
//+------------------------------------------------------------------+
#property strict
#include <Mircea/_profitpoint/Defines.mqh>
//+------------------------------------------------------------------+
//| Error code and description combo                                 |
//+------------------------------------------------------------------+
struct ErrorDescriptor
 {
public:
  int                code;
  string             description;
 };
//+------------------------------------------------------------------+
//| Table of predefined errors                                       |
//+------------------------------------------------------------------+
static ErrorDescriptor ErrorDescriptorTable[] =
 {
#ifdef __MQL5__
   {0, "The operation completed successfully "},
   {4001, "Unexpected internal error"},
   {4002, "Wrong parameter in the inner call of the client terminal function"},
   {4003, "Wrong parameter when calling the system function"},
   {4004, "Not enough memory to perform the system function"},
   {4005, "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes"},
   {4006, "Array of a wrong type, wrong size, or a damaged object of a dynamic array"},
   {4007, "Not enough memory for the relocation of an array, or an attempt to change the size of a static array"},
   {4008, "Not enough memory for the relocation of string"},
   {4009, "Not initialized string"},
   {4010, "Invalid date and/or time"},
   {4011, "Requested array size exceeds 2 GB"},
   {4012, "Wrong pointer"},
   {4013, "Wrong type of pointer"},
   {4014, "Function is not allowed for call"},
   {4015, "The names of the dynamic and the static resource match"},
   {4016, "Resource with this name has not been found in EX5"},
   {4017, "Unsupported resource type or its size exceeds 16 Mb"},
   {4018, "The resource name exceeds 63 characters"},
   {4019, "Overflow occurred when calculating math function "},
//--- Charts
   {4101, "Wrong chart ID"},
   {4102, "Chart does not respond"},
   {4103, "Chart not found"},
   {4104, "No Expert Advisor in the chart that could handle the event"},
   {4105, "Chart opening error"},
   {4106, "Failed to change chart symbol and period"},
   {4107, "Error value of the parameter for the function of working with charts"},
   {4108, "Failed to create timer"},
   {4109, "Wrong chart property ID"},
   {4110, "Error creating screenshots"},
   {4111, "Error navigating through chart"},
   {4112, "Error applying template"},
   {4113, "Subwindow containing the indicator was not found"},
   {4114, "Error adding an indicator to chart"},
   {4115, "Error deleting an indicator from the chart"},
   {4116, "Indicator not found on the specified chart"},
//--- Graphical Objects
   {4201, "Error working with a graphical object"},
   {4202, "Graphical object was not found"},
   {4203, "Wrong ID of a graphical object property"},
   {4204, "Unable to get date corresponding to the value"},
   {4205, "Unable to get value corresponding to the date"},
//--- MarketInfo
   {4301, "Unknown symbol"},
   {4302, "Symbol is not selected in MarketWatch"},
   {4303, "Wrong identifier of a symbol property"},
   {4304, "Time of the last tick is not known (no ticks)"},
   {4305, "Error adding or deleting a symbol in MarketWatch"},
//--- History Access
   {4401, "Requested history not found"},
   {4402, "Wrong ID of the history property"},
   {4403, "Exceeded history request timeout"},
   {4404, "Number of requested bars limited by terminal settings"},
   {4405, "Multiple errors when loading history"},
   {4407, "Receiving array is too small to store all requested data"},
//--- Global_Variables
   {4501, "Global variable of the client terminal is not found"},
   {4502, "Global variable of the client terminal with the same name already exists"},
   {4503, "Global variables were not modified"},
   {4504, "Cannot read file with global variable values"},
   {4505, "Cannot write file with global variable values"},
   {4510, "Email sending failed"},
   {4511, "Sound playing failed"},
   {4512, "Wrong identifier of the program property"},
   {4513, "Wrong identifier of the terminal property"},
   {4514, "File sending via ftp failed"},
   {4515, "Failed to send a notification"},
   {4516, "Invalid parameter for sending a notification – an empty string or NULL has been passed to the SendNotification() function"},
   {4517, "Wrong settings of notifications in the terminal (ID is not specified or permission is not set)"},
   {4518, "Too frequent sending of notifications"},
   {4519, "FTP server is not specified"},
   {4520, "FTP login is not specified"},
   {4521, "File not found in the MQL5\\Files directory to send on FTP server"},
   {4522, "FTP connection failed"},
   {4523, "FTP path not found on server"},
   {4524, "FTP connection closed"},
//--- Custom Indicator Buffers
   {4601, "Not enough memory for the distribution of indicator buffers"},
   {4602, "Wrong indicator buffer index"},
//--- Custom Indicator Properties
   {4603, "Wrong ID of the custom indicator property"},
//--- Account
   {4701, "Wrong account property ID"},
   {4751, "Wrong trade property ID"},
   {4752, "Trading by Expert Advisors prohibited"},
   {4753, "Position not found"},
   {4754, "Order not found"},
   {4755, "Deal not found"},
   {4756, "Trade request sending failed"},
   {4758, "Failed to calculate profit or margin"},
//--- Indicators
   {4801, "Unknown symbol"},
   {4802, "Indicator cannot be created"},
   {4803, "Not enough memory to add the indicator"},
   {4804, "The indicator cannot be applied to another indicator"},
   {4805, "Error applying an indicator to chart"},
   {4806, "Requested data not found"},
   {4807, "Wrong indicator handle"},
   {4808, "Wrong number of parameters when creating an indicator"},
   {4809, "No parameters when creating an indicator"},
   {4810, "The first parameter in the array must be the name of the custom indicator"},
   {4811, "Invalid parameter type in the array when creating an indicator"},
   {4812, "Wrong index of the requested indicator buffer"},
//--- Depth of Market
   {4901, "Depth Of Market can not be added"},
   {4902, "Depth Of Market can not be removed"},
   {4903, "The data from Depth Of Market can not be obtained"},
   {4904, "Error in subscribing to receive new data from Depth Of Market"},
//--- File Operations
   {5001, "More than 64 files cannot be opened at the same time"},
   {5002, "Invalid file name"},
   {5003, "Too long file name"},
   {5004, "File opening error"},
   {5005, "Not enough memory for cache to read"},
   {5006, "File deleting error"},
   {5007, "A file with this handle was closed, or was not opening at all"},
   {5008, "Wrong file handle"},
   {5009, "The file must be opened for writing"},
   {5010, "The file must be opened for reading"},
   {5011, "The file must be opened as a binary one"},
   {5012, "The file must be opened as a text"},
   {5013, "The file must be opened as a text or CSV"},
   {5014, "The file must be opened as CSV"},
   {5015, "File reading error"},
   {5016, "String size must be specified, because the file is opened as binary"},
   {5017, "A text file must be for string arrays, for other arrays - binary"},
   {5018, "This is not a file, this is a directory"},
   {5019, "File does not exist"},
   {5020, "File can not be rewritten"},
   {5021, "Wrong directory name"},
   {5022, "Directory does not exist"},
   {5023, "This is a file, not a directory"},
   {5024, "The directory cannot be removed"},
   {5025, "Failed to clear the directory (probably one or more files are blocked and removal operation failed)"},
   {5026, "Failed to write a resource to a file"},
   {5027, "Unable to read the next piece of data from a CSV file (FileReadString, FileReadNumber, FileReadDatetime, FileReadBool), since the end of file is reached"},
//--- String Casting
   {5030, "No date in the string"},
   {5031, "Wrong date in the string"},
   {5032, "Wrong time in the string"},
   {5033, "Error converting string to date"},
   {5034, "Not enough memory for the string"},
   {5035, "The string length is less than expected"},
   {5036, "Too large number, more than ULONG_MAX"},
   {5037, "Invalid format string"},
   {5038, "Amount of format specifiers more than the parameters"},
   {5039, "Amount of parameters more than the format specifiers"},
   {5040, "Damaged parameter of string type"},
   {5041, "Position outside the string"},
   {5042, "0 added to the string end, a useless operation"},
   {5043, "Unknown data type when converting to a string"},
   {5044, "Damaged string object"},
//--- Operations with Arrays
   {5050, "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only"},
   {5051, "The receiving array is declared as AS_SERIES, and it is of insufficient size"},
   {5052, "Too small array, the starting position is outside the array"},
   {5053, "An array of zero length"},
   {5054, "Must be a numeric array"},
   {5055, "Must be a one-dimensional array"},
   {5056, "Timeseries cannot be used"},
   {5057, "Must be an array of type double"},
   {5058, "Must be an array of type float"},
   {5059, "Must be an array of type long"},
   {5060, "Must be an array of type int"},
   {5061, "Must be an array of type short"},
   {5062, "Must be an array of type char"},
   {5063, "String array only"},
//--- Operations with OpenCL
   {5100, "OpenCL functions are not supported on this computer"},
   {5101, "Internal error occurred when running OpenCL"},
   {5102, "Invalid OpenCL handle"},
   {5103, "Error creating the OpenCL context"},
   {5104, "Failed to create a run queue in OpenCL"},
   {5105, "Error occurred when compiling an OpenCL program"},
   {5106, "Too long kernel name (OpenCL kernel)"},
   {5107, "Error creating an OpenCL kernel"},
   {5108, "Error occurred when setting parameters for the OpenCL kernel"},
   {5109, "OpenCL program runtime error"},
   {5110, "Invalid size of the OpenCL buffer"},
   {5111, "Invalid offset in the OpenCL buffer"},
   {5112, "Failed to create an OpenCL buffer"},
   {5113, "Too many OpenCL objects"},
   {5114, "OpenCL device selection error"},
//--- Operations with WebRequest
   {5200, "Invalid URL"},
   {5201, "Failed to connect to specified URL"},
   {5202, "Timeout exceeded"},
   {5203, "HTTP request failed"},
//--- Custom Symbols
   {5300, "A custom symbol must be specified"},
   {5301, "The name of the custom symbol is invalid. The symbol name can only contain Latin letters without punctuation, spaces or special characters (may only contain \".\", \"_\", \"&\" and \"#\"). It is not recommended to use characters <, >, :, \", /,\\, |, ?, *."},
   {5302, "The name of the custom symbol is too long. The length of the symbol name must not exceed 32 characters including the ending 0 character"},
   {5303, "The path of the custom symbol is too long. The path length should not exceed 128 characters including \"Custom\\\", the symbol name, group separators and the ending 0"},
   {5304, "A custom symbol with the same name already exists"},
   {5305, "Error occurred while creating, deleting or changing the custom symbol"},
   {5306, "You are trying to delete a custom symbol selected in Market Watch"},
   {5307, "An invalid custom symbol property"},
   {5308, "A wrong parameter while setting the property of a custom symbol"},
   {5309, "A too long string parameter while setting the property of a custom symbol"},
   {5310, "Ticks in the array are not arranged in the order of time"},
//--- Trade Server Returned Errors
   {10004, "Requote"},
   {10006, "Request rejected"},
   {10007, "Request canceled by trader"},
   {10008, "Order placed"},
   {10009, "Request completed"},
   {10010, "Only part of the request was completed"},
   {10011, "Request processing error"},
   {10012, "Request canceled by timeout"},
   {10013, "Invalid request"},
   {10014, "Invalid volume in the request"},
   {10015, "Invalid price in the request"},
   {10016, "Invalid stops in the request"},
   {10017, "Trade is disabled"},
   {10018, "Market is closed"},
   {10019, "There is not enough money to complete the request"},
   {10020, "Prices changed"},
   {10021, "There are no quotes to process the request"},
   {10022, "Invalid order expiration date in the request"},
   {10023, "Order state changed"},
   {10024, "Too frequent requests"},
   {10025, "No changes in request"},
   {10026, "Autotrading disabled by server"},
   {10027, "Autotrading disabled by client terminal"},
   {10028, "Request locked for processing"},
   {10029, "Order or position frozen"},
   {10030, "Invalid order filling type"},
   {10031, "No connection with the trade server"},
   {10032, "Operation is allowed only for live accounts"},
   {10033, "The number of pending orders has reached the limit"},
   {10034, "The volume of orders and positions for the symbol has reached the limit"},
   {10035, "Incorrect or prohibited order type"},
   {10036, "Position with the specified POSITION_IDENTIFIER has already been closed"},
   {10038, "A close volume exceeds the current position volume"},
   {10039, "A close order already exists for a specified position"},
   {10040, "The number of open positions simultaneously present on an account can be limited by the server settings"},
   {10041, "The pending order activation request is rejected, the order is canceled"},
   {10042, "The request is rejected, because the \"Only long positions are allowed\" rule is set for the symbol (POSITION_TYPE_BUY)"},
   {10043, "The request is rejected, because the \"Only short positions are allowed\" rule is set for the symbol (POSITION_TYPE_SELL)"},
   {10044, "The request is rejected, because the \"Only position closing is allowed\" rule is set for the symbol"},
//--- User-Defined Errors
   {65536, "User defined errors start with this code"}
#else
//--- trade server errors
   {0,   "no error"},
   {1,   "no error, trade conditions not changed"},
   {2,   "common error"},
   {3,   "invalid trade parameters"},
   {4,   "trade server is busy"},
   {5,   "old version of the client terminal"},
   {6,   "no connection with trade server"},
   {7,   "not enough rights"},
   {8,   "too frequent requests"},
   {9,   "malfunctional trade operation (never returned error)"},
   {64,  "account disabled"},
   {65,  "invalid account"},
   {128, "trade timeout"},
   {129, "invalid price"},
   {130, "invalid stops"},
   {131, "invalid trade volume"},
   {132, "market is closed"},
   {133, "trade is disabled"},
   {134, "not enough money"},
   {135, "price changed"},
   {136, "off quotes"},
   {137, "broker is busy (never returned error)"},
   {138, "requote"},
   {139, "order is locked"},
   {140, "long positions only allowed"},
   {141, "too many requests"},
   {145, "modification denied because order is too close to market"},
   {146, "trade context is busy"},
   {147, "expirations are denied by broker"},
   {148, "amount of open and pending orders has reached the limit"},
   {149, "hedging is prohibited"},
   {150, "prohibited by FIFO rules"},
//--- mql4 errors
   {4000, "no error (never generated code)"},
   {4001, "wrong function pointer"},
   {4002, "array index is out of range"},
   {4003, "no memory for function call stack"},
   {4004, "recursive stack overflow"},
   {4005, "not enough stack for parameter"},
   {4006, "no memory for parameter string"},
   {4007, "no memory for temp string"},
   {4008, "non-initialized string"},
   {4009, "non-initialized string in array"},
   {4010, "no memory for array\' string"},
   {4011, "too long string"},
   {4012, "remainder from zero divide"},
   {4013, "zero divide"},
   {4014, "unknown command"},
   {4015, "wrong jump (never generated error)"},
   {4016, "non-initialized array"},
   {4017, "dll calls are not allowed"},
   {4018, "cannot load library"},
   {4019, "cannot call function"},
   {4020, "expert function calls are not allowed"},
   {4021, "not enough memory for temp string returned from function"},
   {4022, "system is busy (never generated error)"},
   {4023, "dll-function call critical error"},
   {4024, "internal error"},
   {4025, "out of memory"},
   {4026, "invalid pointer"},
   {4027, "too many formatters in the format function"},
   {4028, "parameters count is more than formatters count"},
   {4029, "invalid array"},
   {4030, "no reply from chart"},
   {4050, "invalid function parameters count"},
   {4051, "invalid function parameter value"},
   {4052, "string function internal error"},
   {4053, "some array error"},
   {4054, "incorrect series array usage"},
   {4055, "custom indicator error"},
   {4056, "arrays are incompatible"},
   {4057, "global variables processing error"},
   {4058, "global variable not found"},
   {4059, "function is not allowed in testing mode"},
   {4060, "function is not confirmed"},
   {4061, "send mail error"},
   {4062, "string parameter expected"},
   {4063, "integer parameter expected"},
   {4064, "double parameter expected"},
   {4065, "array as parameter expected"},
   {4066, "requested history data is in update state"},
   {4067, "internal trade error"},
   {4068, "resource not found"},
   {4069, "resource not supported"},
   {4070, "duplicate resource"},
   {4071, "cannot initialize custom indicator"},
   {4072, "cannot load custom indicator"},
   {4073, "no history data"},
   {4074, "not enough memory for history data"},
   {4075, "not enough memory for indicator"},
   {4099, "end of file"},
   {4100, "some file error"},
   {4101, "wrong file name"},
   {4102, "too many opened files"},
   {4103, "cannot open file"},
   {4104, "incompatible access to a file"},
   {4105, "no order selected"},
   {4106, "unknown symbol"},
   {4107, "invalid price parameter for trade function"},
   {4108, "invalid ticket"},
   {4109, "trade is not allowed in the expert properties"},
   {4110, "longs are not allowed in the expert properties"},
   {4111, "shorts are not allowed in the expert properties"},
   {4200, "object already exists"},
   {4201, "unknown object property"},
   {4202, "object does not exist"},
   {4203, "unknown object type"},
   {4204, "no object name"},
   {4205, "object coordinates error"},
   {4206, "no specified subwindow"},
   {4207, "graphical object error"},
   {4210, "unknown chart property"},
   {4211, "chart not found"},
   {4212, "chart subwindow not found"},
   {4213, "chart indicator not found"},
   {4220, "symbol select error"},
   {4250, "notification error"},
   {4251, "notification parameter error"},
   {4252, "notifications disabled"},
   {4253, "notification send too frequent"},
   {4260, "ftp server is not specified"},
   {4261, "ftp login is not specified"},
   {4262, "ftp connect failed"},
   {4263, "ftp connect closed"},
   {4264, "ftp change path error"},
   {4265, "ftp file error"},
   {4266, "ftp error"},
   {5001, "too many opened files"},
   {5002, "wrong file name"},
   {5003, "too long file name"},
   {5004, "cannot open file"},
   {5005, "text file buffer allocation error"},
   {5006, "cannot delete file"},
   {5007, "invalid file handle (file closed or was not opened)"},
   {5008, "wrong file handle (handle index is out of handle table)"},
   {5009, "file must be opened with FILE_WRITE flag"},
   {5010, "file must be opened with FILE_READ flag"},
   {5011, "file must be opened with FILE_BIN flag"},
   {5012, "file must be opened with FILE_TXT flag"},
   {5013, "file must be opened with FILE_TXT or FILE_CSV flag"},
   {5014, "file must be opened with FILE_CSV flag"},
   {5015, "file read error"},
   {5016, "file write error"},
   {5017, "string size must be specified for binary file"},
   {5018, "incompatible file (for string arrays-TXT, for others-BIN)"},
   {5019, "file is directory, not file"},
   {5020, "file does not exist"},
   {5021, "file cannot be rewritten"},
   {5022, "wrong directory name"},
   {5023, "directory does not exist"},
   {5024, "specified file is not directory"},
   {5025, "cannot delete directory"},
   {5026, "cannot clean directory"},
   {5027, "array resize error"},
   {5028, "string resize error"},
   {5029, "structure contains strings or dynamic arrays"}
#endif
 };
//+------------------------------------------------------------------+
//| Binary search error description                                  |
//+------------------------------------------------------------------+
string ErrorDescription(int errorCode)
 {
  int size = ArraySize(ErrorDescriptorTable);
  int begin = 0, end = size - 1, mid = -1;
  while(begin <= end)
   {
    mid = (begin + end) / 2;
    if(ErrorDescriptorTable[mid].code < errorCode)
     {
      mid++;
      begin = mid;
      continue;
     }
    else
      if(ErrorDescriptorTable[mid].code > errorCode)
       {
        end = mid - 1;
        continue;
       }
      else
       {
        break;
       }
   }
  if(mid == -1)
    return "Unknown error";
  else
    return ErrorDescriptorTable[mid].description;
 }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CError
 {
                     ObjectAttr(int, ErrorCode);
public:
                     CError() {mErrorCode = 0;}
                    ~CError() {}
  void               ClearError() {SetErrorCode(0);}
  string             GetErrorDescription() {return ErrorDescription(mErrorCode);}
 };

//+------------------------------------------------------------------+
