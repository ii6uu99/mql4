//+------------------------------------------------------------------+
//|                                                      RAD library |
//|                                      Copyright 2012, Octaviarius |
//|                                                                  |
//+------------------------------------------------------------------+
#ifndef RAD_H
#define RAD_H

//! @authors Octaviarius, GoldMoney
//! @license GPL v.2
/* TODO:

*/

#include <Files/FileTxt.mqh>
#include <Files/FileBin.mqh>

#define RAD_IGNORE_VALUE     INT_MIN
#define RAD_RESET_VALUE      INT_MAX

#define RAD_VERSIONMAJOR     2
#define RAD_VERSIONMINOR     16
#define RAD_DESCRIPTION      "Library of rapidly application development for MQL4 language"
#define RAD_LICENSE          "GPL v.2"

#import "wininet.dll"
int InternetAttemptConnect(int x);
int HttpQueryInfoW(int hRequest,int dwInfoLevel,uchar  &lpvBuffer[],int  &lpdwBufferLength,int  &lpdwIndex);
int InternetOpenW(string  &sAgent,int lAccessType,string  &sProxyName,string  &sProxyBypass,int lFlags);
int InternetOpenUrlW(int hInternet,string  &lpszUrl,string  &lpszHeaders,int dwHeadersLength,uint dwFlags,int dwContext);
int InternetReadFile(int hFile,uchar  &sBuffer[],int lNumBytesToRead,int  &lNumberOfBytesRead);
int InternetCloseHandle(int hInet);
#import

#define FLAG_PRAGMA_NOCACHE         0x00000100
#define FLAG_RELOAD                 0x80000000
#define HTTP_QUERY_CONTENT_LENGTH   5
#define DOWNLOADING_BYTES           10240

static string __tmp_string;

//! ���������� ������ � ������ �������
#define RAD_DEBUG_SECTION                  if(__rad_lib_params.is_debug)


#define RAD_LOG_ASSERT(str) { \
   if(__rad_lib_params.is_log) \
         __rad_lib_params.log_file.WriteString(string(TimeCurrent())+":> "+str+"\n"); \
}

//! ����� � ������� ���������� � �������� � ������ �������
#define RAD_DEBUG_ASSERT(assert_num, assert_text)  \
   if(__rad_lib_params.is_debug){ \
      Print(__tmp_string="DEBUG:"+\
            "  "+__FILE__+\
            "  "+__FUNCTION__+\
            "  line:"+string(__LINE__)+\
            "  assert#"+string(assert_num)+\
            ":>  "+assert_text); \
   RAD_LOG_ASSERT(__tmp_string); \
}

//!����� � ������� ���������� � ��������
#define RAD_ASSERT(assert_num, assert_text) { \
   Print(__tmp_string="ASSERT:"+\
            "  "+__FUNCTION__+\
            "  assert#"+string(assert_num)+\
            ":>  "+assert_text); \
   RAD_LOG_ASSERT(__tmp_string); \
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ERadAssert 
{
   miaSymbol=0,
   miaLow,
   miaHigh,
   miaTime,
   miaBid,
   miaAsk,
   miaPoint,
   miaDigits,
   miaSpread,
   miaStopLevel,
   miaLotSize,
   miaTickSize,
   miaTickValue,
   miaSwapLong,
   miaSwapShort,
   miaStarting,
   miaExpiration,
   miaTradeAllowed,
   miaMinLot,
   miaLotStep,
   miaMaxLot,
   miaSwapType,
   miaProfitCalcMode,
   miaMarginCalcMode,
   miaMarginInit,
   miaMarginMaintenance,
   miaMarginHedged,
   miaMarginRequired,
   miaFreezeLevel,

   accBalance,
   accEquity,
   accCredit,
   accCompany,
   accNumber,
   accName,
   accProfit,
   accLeverage,

   mql4TickCount,
   mql4Version,
   mql4Description,
   mql4License,

   mql4_ASSERT_ALL
};
//! ����� ����� � ����� ����� �������
enum EOrderTypeMask
{
   omNone=0,
   //! �������
   omBuy=(1<<OP_BUY),
   //! �������
   omSell=(1<<OP_SELL),
   //! ���������� ����� buystop
   omBuyStop=(1<<OP_BUYSTOP),
   //! ���������� ����� sellstop
   omSellStop=(1<<OP_SELLSTOP),
   //! ���������� ����� buylimit
   omBuyLimit=(1<<OP_BUYLIMIT),
   //! ���������� ����� selllimit
   omSellLimit=(1<<OP_SELLLIMIT),
   //! ������ �� �������
   omBuys=(omBuy|omBuyStop|omBuyLimit),
   //! ������ �� �������
   omSells=(omSell|omSellStop|omSellLimit),
   //! ���������� ������ buy
   omBuysPended=(omBuyStop|omBuyLimit),
   //! ���������� ������ sell
   omSellsPended=(omSellStop|omSellLimit),
   //! ���������� ������
   omActive=(omBuy|omSell),
   //! ���������� ������
   omPended=(omBuysPended|omSellsPended),
   //! ��� 
   omAll=(omBuys|omSells),

   //! ��� Trades
   omPoolTrades=(1<<(6+0)),
   //! ��� History
   omPoolHistory=(1<<(6+1)),
   //! ��� ����
   omPoolAll=(omPoolTrades|omPoolHistory),

   //! ������ �������
   omEverything=(omAll|omPoolAll)
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TRadLibParams 
{
   //! ������� �����
   ulong tick_count;

   //! ��� ���������
   string program_name;
   //! ���������� �� ���������(��� ������������� ����� Symbol() )
   string symbol;
   //! ���������������
   int slippage;
   //! ���������� ����� �� ���������
   int magic;

   //! ���� �������� BUY
   color color_buy_open;
   //! ���� �������� SELL
   color color_sell_open;
   //! ���� �������� BUY
   color color_buy_close;
   //! ���� �������� SEL
   color color_sell_close;
   //! ���� ���������� BUY
   color color_buy_modify;
   //! ���� ����������� SELL
   color color_sell_modify;
   //! ���� ��������
   color color_delete;

   //! �������� �������
   bool is_debug;
   //! ��������� ������� ����
   bool is_log;
   //! ��� �����
   string log_file_path;
   //! ���-����
   CFileTxt log_file;

   //! �������� (%)
   double equity_breakdown;

};

TRadLibParams __rad_lib_params;

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ������� ��������������� ���������� //////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

/// �������������
int RAD_VersionMajor()    { return RAD_VERSIONMAJOR; }
int RAD_VersionMinor()    { return RAD_VERSIONMINOR; }
string RAD_VersionString()   { return string(RAD_VERSIONMAJOR) + "." + string(RAD_VERSIONMINOR); }
string RAD_Description()     { return RAD_DESCRIPTION; }
string RAD_License()         { return RAD_LICENSE; }

/// ��������� ������� � ������������
void RAD_DebugEnable()    { __rad_lib_params.is_debug = true;   RAD_ASSERT(0, "DEBUGGING ENABLED"); }
void RAD_DebugDisable()   { __rad_lib_params.is_debug = false;  RAD_ASSERT(0, "DEBUGGING DISABLED");  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RAD_LogEnable() 
{
                              if(__rad_lib_params.log_file.Open(__rad_lib_params.log_file_path,FILE_READ|FILE_WRITE)<0)
{
                                 __rad_lib_params.is_log=false;
                                 RAD_ASSERT(0,"Logging is not enabled!");
                                 return false;
                              }
                              __rad_lib_params.is_log=true;
                              __rad_lib_params.log_file.Seek(0, SEEK_END);
                              RAD_ASSERT(1,"Logging is enabled!");
                              return true; 
}
bool RAD_LogDisable() { __rad_lib_params.is_log=false; __rad_lib_params.log_file.Close(); RAD_ASSERT(0,"Logging is disabled!"); return true;}
/// �������
bool RAD_setLogName(string value) 
{
   __rad_lib_params.log_file_path=value;
   if(__rad_lib_params.is_log)
{
      __rad_lib_params.log_file.Close();
      if(__rad_lib_params.log_file.Open(value, FILE_WRITE) < 0) return false;
   }

   return true;
}

bool RAD_setProgramName(string value) { __rad_lib_params.program_name = value; return true; }
bool RAD_setSymbol(string value)      { __rad_lib_params.symbol = value; return true; }
bool RAD_setMagic(int value)          { __rad_lib_params.magic = value; return true; }
bool RAD_setSlippage(int value)       { __rad_lib_params.slippage = value; return true; }

bool RAD_setColorBuyOpen(color value)    { __rad_lib_params.color_buy_open = value; return true; }
bool RAD_setColorBuyClose(color value)   { __rad_lib_params.color_buy_close = value; return true; }
bool RAD_setColorSellOpen(color value)   { __rad_lib_params.color_sell_open = value; return true; }
bool RAD_setColorSellClose(color value)  { __rad_lib_params.color_sell_close = value; return true; }
bool RAD_setColorBuyModify(color value)  { __rad_lib_params.color_buy_modify = value; return true; }
bool RAD_setColorSellModify(color value) { __rad_lib_params.color_sell_modify = value; return true; }
bool RAD_setColorDelete(color value)     { __rad_lib_params.color_delete = value; return true; }

bool RAD_setEquityBreakdown(double value) { if(value<0 || value>100) return false; __rad_lib_params.equity_breakdown=value; return true; }


/// �������
string RAD_LogName()         { return __rad_lib_params.log_file.FileName(); }
string RAD_ProgramName()     { return __rad_lib_params.program_name; }
string RAD_Symbol()          { return __rad_lib_params.symbol; }
int RAD_Magic()              { return __rad_lib_params.magic; }
int RAD_Slippage()           { return __rad_lib_params.slippage; }

color RAD_ColorBuyOpen()     { return __rad_lib_params.color_buy_open; }
color RAD_ColorBuyClose()    { return __rad_lib_params.color_buy_close; }
color RAD_ColorSellOpen()    { return __rad_lib_params.color_sell_open; }
color RAD_ColorSellClose()   { return __rad_lib_params.color_sell_close; }
color RAD_ColorBuyModify()   { return __rad_lib_params.color_buy_modify; }
color RAD_ColorSellModify()  { return __rad_lib_params.color_sell_modify; }
color RAD_ColorDelete()      { return __rad_lib_params.color_delete; }

ulong RAD_TickCount() { return __rad_lib_params.tick_count; }

double RAD_EquityBreakdown() { return __rad_lib_params.equity_breakdown; }
/// ���������� ��������

//========================/ RAD_onInit /=====================================================
//! ������������� ����������
void RAD_onInit() 
{
   __rad_lib_params.tick_count=0;

   __rad_lib_params.program_name="";
   __rad_lib_params.symbol=Symbol();
   __rad_lib_params.slippage=3;
   __rad_lib_params.magic=0;

   __rad_lib_params.color_buy_open=clrBlue;
   __rad_lib_params.color_sell_open = clrGreen;
   __rad_lib_params.color_buy_close = clrRed;
   __rad_lib_params.color_sell_close= clrRed;
   __rad_lib_params.color_delete=clrRed;
   __rad_lib_params.color_buy_modify=clrYellow;
   __rad_lib_params.color_sell_modify=clrYellow;

   __rad_lib_params.is_debug=false;
   __rad_lib_params.is_log=false;
   __rad_lib_params.log_file_path="RAD_LogFile.log";

   __rad_lib_params.equity_breakdown=100.0;
};

//========================/ RAD_onDeinit /=====================================================
//! ��������������� ����������
void RAD_onDeinit() {  };
//========================/ RAD_onTick /=====================================================
//! ��������� �� ����
void RAD_onTick() 
{

   //��������� �����
   __rad_lib_params.tick_count++;

   //������������
   MathSrand(int(GetMicrosecondCount()^GetTickCount()));

   //�������� ���� ������ ��� ���������� ��������
   if(CalcEquityBreakdown()>=__rad_lib_params.equity_breakdown)
{
      RAD_ASSERT(0,"!!!Upon reaching breakdown "+string(__rad_lib_params.equity_breakdown)+" !!!  CLOSING ORDERS...");
      CloseOrders(omActive);
   }

}
//========================/ RAD_Assert /=====================================================
//! ����� � ������� ��������� ������� ���������� ������
void RAD_Assert(
   //! ����� �������
   ERadAssert assert,
   //! ����������
   string symbol=NULL
)
{

   string str;
   bool fl=true;

   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;

   switch(assert)
{
      case mql4_ASSERT_ALL:
         fl=false;

      case miaSymbol:      RAD_ASSERT(0,"SYMBOL: "+symbol); if(fl) break;
      case miaLow:         RAD_ASSERT(1,"DAY PRICE LOW: "+(string)MarketInfoLow(symbol));  if(fl) break;
      case miaHigh:        RAD_ASSERT(2, "DAY PRICE HIGH: " + (string)MarketInfoHigh(symbol));  if(fl) break;
      case miaTime:        RAD_ASSERT(3, "LAST PRICE TIME: " + (string)MarketInfoTime(symbol));  if(fl) break;
      case miaBid:         RAD_ASSERT(4, "PRICE BID: " + (string)MarketInfoBid(symbol));  if(fl) break;
      case miaAsk:         RAD_ASSERT(5, "PRICE ASK: " + (string)MarketInfoAsk(symbol));  if(fl) break;
      case miaPoint:       RAD_ASSERT(6,"POINT: "+(string)MarketInfoPoint(symbol));  if(fl) break;
      case miaDigits:      RAD_ASSERT(7, "DIGITS: " + (string)MarketInfoDigits(symbol));  if(fl) break;
      case miaSpread:      RAD_ASSERT(8, "SPREAD: " + (string)MarketInfoSpread(symbol));  if(fl) break;
      case miaStopLevel:   RAD_ASSERT(9,"MINIMUM STOPLEVEL: "+(string)MarketInfoStopLevel(symbol));  if(fl) break;
      case miaLotSize:     RAD_ASSERT(10,"LOT SIZE: "+(string)MarketInfoLotSize(symbol));  if(fl) break;
      case miaTickSize:    RAD_ASSERT(11,"TICK SIZE: "+(string)MarketInfoTickSize(symbol));  if(fl) break;
      case miaTickValue:   RAD_ASSERT(12,"TICK VALUE: "+(string)MarketInfoTickValue(symbol));    if(fl) break;
      case miaSwapLong:    RAD_ASSERT(13,"SWAP LONG: "+(string)MarketInfoSwapLong(symbol));  if(fl) break;
      case miaSwapShort:   RAD_ASSERT(14,"SWAP SHORT: "+(string)MarketInfoSwapShort(symbol));  if(fl) break;
      case miaStarting:    RAD_ASSERT(15,"FUTURES STARTING: "+(string)MarketInfoStarting(symbol));  if(fl) break;
      case miaExpiration:  RAD_ASSERT(16,"FUTURES EXPIRATION: "+(string)MarketInfoExpiration(symbol));  if(fl) break;
      case miaTradeAllowed:RAD_ASSERT(17,"TRADE ALLOWED: "+(string)MarketInfoTradeAllowed(symbol));  if(fl) break;
      case miaMinLot:      RAD_ASSERT(18,"LOT MINIMUM: "+(string)MarketInfoMinLot(symbol));  if(fl) break;
      case miaLotStep:     RAD_ASSERT(19,"LOT STEP: "+(string)MarketInfoLotStep(symbol));  if(fl) break;
      case miaMaxLot:      RAD_ASSERT(20,"LOT MAXIMUM: "+(string)MarketInfoMaxLot(symbol));  if(fl) break;
      case miaSwapType:    switch(MarketInfoSwapType(symbol))
{
                              case 0: str = "points"; break;
                              case 1: str = "base currency"; break;
                              case 2: str = "procents"; break;
                              case 3: str = "margin currency"; break;
                           }
                           RAD_ASSERT(21,"SWAP TYPE: "+str);
                           if(fl) break;
      case miaProfitCalcMode: switch(MarketInfoProfitCalcMode(symbol))
{
                                 case 0: str = "Forex"; break;
                                 case 1: str = "CFD"; break;
                                 case 2: str = "Futures"; break;
                              }
                              RAD_ASSERT(22,"PROFIT CALC MODE: "+str);
                              if(fl) break;
      case miaMarginCalcMode: switch(MarketInfoMarginCalcMode(symbol))
{
                                 case 0: str = "Forex"; break;
                                 case 1: str = "CFD"; break;
                                 case 2: str = "Futures"; break;
                                 case 3: str = "CFD indexes"; break;
                              }
                              RAD_ASSERT(23,"MARGIN CALC MODE: "+str);
                              if(fl) break;
      case miaMarginInit:        RAD_ASSERT(24,"MARGIN INIT: "+(string)MarketInfoMarginInit(symbol));  if(fl) break;
      case miaMarginMaintenance: RAD_ASSERT(25,"MARGIN MAINTENENCE: "+(string)MarketInfoMarginMaintenance(symbol));  if(fl) break;
      case miaMarginHedged:      RAD_ASSERT(26,"MARGIN HEDGED: "+(string)MarketInfoMarginHedged(symbol));  if(fl) break;
      case miaMarginRequired:    RAD_ASSERT(27,"MARGIN REQUIRED: "+(string)MarketInfoMarginRequired(symbol));  if(fl) break;
      case miaFreezeLevel:       RAD_ASSERT(28,"FREEZE LEVEL: "+(string)MarketInfoFreezeLevel(symbol));        if(fl) break;
      case mql4TickCount:  RAD_ASSERT(29,"TICK COUNTER: "+(string)__rad_lib_params.tick_count);        if(fl) break;

      case accBalance:     RAD_ASSERT(30,"ACCOUNT BALANCE: "+(string)AccountBalance()); if(fl) break;
      case accEquity:      RAD_ASSERT(31, "ACCOUNT EQUITY: " + (string)AccountEquity()); if(fl) break;
      case accCredit:      RAD_ASSERT(32, "ACCOUNT CREDIT: " + (string)AccountCredit()); if(fl) break;
      case accCompany:     RAD_ASSERT(33,"ACCOUNT COMPANY: "+AccountCompany()); if(fl) break;
      case accNumber:      RAD_ASSERT(34,"ACCOUNT NUMBER: "+(string)AccountNumber()); if(fl) break;
      case accName:        RAD_ASSERT(35,"ACCOUNT NAME: "+AccountName()); if(fl) break;
      case accProfit:      RAD_ASSERT(36,"ACCOUNT PROFIT: "+(string)AccountProfit()); if(fl) break;
      case accLeverage:    RAD_ASSERT(37,"ACCOUNT LEVERAGE: "+(string)AccountLeverage()); if(fl) break;

      case mql4Version:    RAD_ASSERT(38,"MQL4 LIBRARY VERSION: "+RAD_VersionString()); if(fl) break;
      case mql4Description:   RAD_ASSERT(39,"MQL4 LIBRARY DESCRIPTION: "+RAD_Description()); if(fl) break;
      case mql4License:    RAD_ASSERT(40,"MQL4 LIBRARY LICENSE: "+RAD_License()); if(fl) break;

   };

}
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// �������� �������������� /////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////


//=============================/ DateToSeconds /=============================================
//! �������������� ���� � �������. 
//! @return ���������� ����� � ��������
ulong   DateToSeconds(
   //! �������
   int seconds=0,
   //! ������
   int minutes=0,
   //! ����
   int hour=0,
   //! ���
   int day=0,
   //! ������
   int month=0,
   //! ���
   int year=0
)
{
   MqlDateTime time;
   time.sec = seconds;
   time.min = minutes;
   time.hour= hour;
   time.day = day;
   time.mon = month;
   time.year= year;
   return StructToTime(time);
};
//=============================/ TimeToSeconds /=============================================
//! �������������� ������� ����� � ������� � ������ ���. 
//! @return ���������� ����� � ��������
ulong   DaytimeToSeconds(
   //! �������
   int seconds=0,
   //! ������
   int minutes=0,
   //! ����
   int hour=0
)
{
   return (hour * 3600 + minutes * 60 + seconds) % 86400;
};
//=============================/ PointsToCurrency /=============================================
//! ����������� ������� � ������ ��������. 
//! @return ���������� ��������� � ������ ��������
double   PointsToCurrency(
   //! ���������� ������� ������ ���������
   int points=1,
   //! �����
   double lots=1.0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return points * lots * MarketInfoPoint(symbol) * MarketInfoTickValue(symbol) / MarketInfoTickSize(symbol);
};
//=============================/ CurrencyToPoints /================================================
//! ����������� ������ � ������. 
//! @return ���������� ���������� �������
double   CurrencyToPoints(
   //! ������ � ������
   double cost,
   //! �����
   double lots=1.0,
   //! ����������
   string symbol=NULL
)
{

   if(lots==0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return cost * MarketInfoTickSize(symbol) / (lots * MarketInfoPoint(symbol) * MarketInfoTickValue(symbol));
};
//=============================/ CurrencyToLot /================================================
//! ����������� ������ � ������ ����. 
//! @return ���������� ������ ����
double   CurrencyToLot(
   //! ������ � ������
   double cost,
   //! ������
   int points=1,
   //! ����������
   string symbol=NULL
)
{
   if(points<=0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;

   return MathAbs(cost) * MarketInfoTickSize(symbol) / (double(points) * MarketInfoPoint(symbol) * MarketInfoTickValue(symbol));
};
//=============================/ PriceToCurrency /=============================================
//! ����������� ���� ����������� � ������ ��������. 
//! @return ���������� ��������� � ������ ��������
double   PriceToCurrency(
   //! ���������� ������� ������ ���������
   double price,
   //! �����
   double lots=1.0,
   //! ����������
   string symbol=NULL
)
{
   if(price*lots==0.0)
      return 0.0;
   return price * lots * MarketInfoTickValue(symbol) / MarketInfoTickSize(symbol);
};
//=============================/ CurrencyToPrice /================================================
//! ����������� ������ � ���� �����������. 
//! @return ���������� ���� �����������
double   CurrencyToPrice(
   //! ������ � ������
   double cost,
   //! �����
   double lots=1.0,
   //! ����������
   string symbol=NULL
)
{

   if(cost*lots==0.0)
      return 0.0;
   return NormalizeDouble(cost * MarketInfoTickSize(symbol) /  (MarketInfoTickValue(symbol) * lots), (int)MarketInfoDigits(symbol));
};
//========================/ PointToPrice /=====================================================
//! ����������� ���������� ������� � ���� �����������.
//! @return ���������� ���� ��� �������� ��� �����������
double   PointToPrice(
   //! ���������� ������� �����������
   int points=1,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return NormalizeDouble(points * MarketInfoPoint(symbol), (int)MarketInfoDigits(symbol));
};
//==========================/ PriceToPoints /===================================================
//! ����������� ���� ��� �������� ��� ����������� � ���������� �������
//! @return ���������� ������
double   PriceToPoints(
   //! ����
   double price=0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return price / MarketInfoPoint(symbol);
};
//=======================/ BuyPriceSL /======================================================
//! ���������� �������� ��� �������
//! @return ���������� �������������� ���� ������ ��������	
double   BuyPriceSL(
   //! ������.
   int points,
   //! ������������� ����. ���� ����� ����, �� ��������� Bid
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = BuyPriceOpen(symbol);
   return NormalizeDouble(price - points * MarketInfoPoint(symbol), MarketInfoDigits(symbol));
};
//=======================/ BuyPointsSL /======================================================
//! ���������� �������� � ������� ��� �������
//! @return ���������� ������ ���������
int   BuyPointsSL(
   //! ������� ���� ���������
   double price_sl,
   //! ������������� ����. ���� ����� ����, �� ��������� Bid
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(price_sl==0.0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = BuyPriceOpen(symbol);
   return int((price - price_sl) / MarketInfoPoint(symbol));
};
//=======================/ BuyPriceTP /======================================================
//! ���������� ����������� ��� �������
//! @return ���������� �������������� ���� ������ �����������	
double   BuyPriceTP(
   //! ������� ���� �����������
   int points,
   //! ������������� ����. ���� ����� ����, �� ��������� Ask
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = BuyPriceOpen(symbol);
   return NormalizeDouble(price + points * MarketInfoPoint(symbol), MarketInfoDigits(symbol));
};
//=======================/ BuyPointsTP /======================================================
//! ���������� ����������� � ������� ��� �������
//! @return ���������� ������ �����������	
int   BuyPointsTP(
   //! ������.
   double price_tp,
   //! ������������� ����. ���� ����� ����, �� ��������� Ask
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(price_tp==0.0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = BuyPriceOpen(symbol);
   return int((price_tp - price) / MarketInfoPoint(symbol));
};
//===========================/ BuyPriceOpen /==================================================
//! ������� ���� �������� �������.
//! @return ���������� ������� ���� �����������
double   BuyPriceOpen(
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return MarketInfoAsk(symbol);
};
//===========================/ BuyPriceClose /==================================================
//! ������� ���� �������� �������.
//! @return ���������� ������� ���� �����������
double   BuyPriceClose(
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return MarketInfoBid(symbol);
};
//=========================/ SellPriceSL /====================================================
//! ���������� �������� ��� �������
//! @return ���������� �������������� ���� ������ ��������
double   SellPriceSL(
   //! ������.
   int points,
   //! ������������� ����. ���� ����� ����, �� ��������� Ask
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = SellPriceOpen(symbol);
   return NormalizeDouble(price + points * MarketInfoPoint(symbol), (int)MarketInfoDigits(symbol));
};
//=========================/ SellPointsSL /====================================================
//! ���������� �������� � ������� ��� �������
//! @return ���������� ������ ���������
int   SellPointsSL(
   //! ������� ���� ���������
   double price_sl,
   //! ������������� ����. ���� ����� ����, �� ��������� Ask
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(price_sl==0.0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = SellPriceOpen(symbol);
   return int((price_sl - price) / MarketInfoPoint(symbol));
};
//==========================/ SellPriceTP /===================================================
//! ���������� ����������� ��� �������
//! @return ���������� �������������� ���� ������ �����������
double   SellPriceTP(
   //! ������.
   int points,
   //! ������������� ����. ���� ����� ����, �� ��������� Bid
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = SellPriceOpen(symbol);
   return NormalizeDouble(price - points * MarketInfoPoint(symbol), (int)MarketInfoDigits(symbol));
};
//==========================/ SellPointsTP /===================================================
//! ���������� ����������� �������� ��� �������
//! @return ���������� ������ �����������
int   SellPointsTP(
   //! ������.
   double price_tp,
   //! ������������� ����. ���� ����� ����, �� ��������� Bid
   double price=0.0,
   //! ����������
   string symbol=NULL
)
{
   if(price_tp==0.0)
      return 0;
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(price == 0.0)
      price = SellPriceOpen(symbol);
   return int((price - price_tp) / MarketInfoPoint(symbol));
};
//===========================/ SellPriceOpen /==================================================
//! ������� ���� �������� �������.
//! @return ���������� ������� ���� �����������
double   SellPriceOpen(
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return MarketInfoBid(symbol);
};
//===========================/ SellPriceClose /==================================================
//! ������� ���� �������� �������.
//! @return ���������� ������� ���� �����������
double   SellPriceClose(
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   return MarketInfoAsk(symbol);
};
//===========================/ SellPriceClose /==================================================
//! ������� ���� �������� �������.
//! @return ���������� ������� ���� �����������
double   NormalizeLot(
   //! ���
   double lot
)
{
   static double min = MarketInfoMinLot();
   static double max = MarketInfoMaxLot();
   static double step= MarketInfoLotStep();


   if(lot<min && lot!=0)
      return min;
   if(lot>max && lot!=0)
      return max;

   lot=int(lot/step)*step;

   return lot;
};
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ���������� �������� /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////


//=====================/ isNewBar /========================================================
//! ��������� ��������� ������ ����
bool isNewBar(
   //! ������
   ENUM_TIMEFRAMES tf=PERIOD_CURRENT
)
{

   static ulong last_ticks=0;
   static datetime last_time=0;
   bool condition;

   condition=((TimeCurrent()-last_time>=PeriodSeconds(tf)) || 
(TimeCurrent()%PeriodSeconds(tf)==0)) && 
(last_time!=TimeCurrent());

   if(condition)
{
      last_ticks= __rad_lib_params.tick_count;
      last_time = TimeCurrent();
   }

   return (last_ticks == __rad_lib_params.tick_count);
}
//=====================/ isDayTimeFilter /========================================================
//! ���������� �� �������
bool isDayTimeFilter(
   //! ������ ������
   ulong start_session,
   //! ����� ������
   ulong stop_session
)
{
   ulong curr=TimeCurrent()%86400;
   start_session= start_session%86400;
   stop_session = stop_session%86400;

   RAD_DEBUG_ASSERT(0,"CURRENT:"+string(curr)+" START:"+string(start_session)+" STOP:"+string(stop_session));

   return   ((curr >= start_session) && (curr < stop_session)) ||
            !((curr>= start_session) ||(curr < stop_session));
}
//===========================/ BarTimeLeft /==================================================
//! ����� � �������� �� �������� ����
//! @return ���������� ����� �� �������� ���� � ���.
datetime BarTimeLeft(
   //! ���������
   ENUM_TIMEFRAMES tf=PERIOD_CURRENT,
   //! ����������
   string symbol=NULL
)
{
   return (datetime)(PeriodSeconds(tf) - MathMod(MarketInfo(symbol, MODE_TIME), PeriodSeconds(tf)));
}
//========================/ CountOrders /=====================================================
//! ������������ ������
//! @return ���������� ���������� �������
int CountOrders(
   //! ����� ������ ����� (�� ��������� �� ���� ����� �� ���� �����)
   ulong mask=omEverything,
   //! ���������� �����
   int magic=0,
   //! ����������
   string symbol=NULL)
{
   int cnt=0;
   int ticket=0;
   int i;

   //������� �� ���� �������
   if((mask  &omPoolTrades)!=0)
      for(i=OrdersTotal()-1; i>=0; i--)
         cnt+=isOrderFilter(GetTicket(i,omPoolTrades),mask,magic,symbol);

   //������� �� ���� ������������
   if((mask  &omPoolHistory)!=0)
      for(i=OrdersHistoryTotal()-1; i>=0; i--)
         cnt+=isOrderFilter(GetTicket(i,omPoolHistory),mask,magic,symbol);

   return cnt;
}
//==========================/ CalcEquityBreakdown /===================================================
//! ����������� ������� ������� �������� �� �������
//! @return ���������� ������� ������������� ������� �������� ������� (%)
double CalcEquityBreakdown()
{
   double breakdown=100.0 *(1.0-AccountEquity()/AccountBalance());

   if(breakdown < 0.0)        return 0.0;
   else if(breakdown > 100.0) return 100.0;

   return breakdown;
}
//==========================/ CalcBreakeven /===================================================
//! ����������� ������� ��������� ��� ������
//! @return ���������� ������� ���������
double CalcBreakeven(
   //! ����� ������
   int ticket,
   //! ������� � ������ � �������
   int excess=0
)
{

   double loss_level;

   if(OrderSelect(ticket,SELECT_BY_TICKET)==false)
      return 0.0;

   loss_level=CurrencyToPrice(OrderCommission()+OrderSwap(),OrderLots(),OrderSymbol())-PointToPrice(excess,OrderSymbol());

   if(isOrderType(OrderType(),omBuys))
      return OrderOpenPrice() - loss_level;
   else
      return OrderOpenPrice() + loss_level;

   return 0.0;
}
//==========================/ CalcLastLosses /===================================================
//! ������������ ������ ��������� ��������� �������
//! @return ���������� ������ � ������ ��������
double CalcLastLosses(
   //! ���������� ��������� ��������� ������� (���� ����� -1, �� ����� ������ �������� �������; ���� 0, �� ��� ���������, ���� ������ 0, �� ��������� count �������)
   int count,
   //! ���������� �����
   int magic,
   //! ����������
   string symbol=NULL
)
{
   double loss=0.0;
   double losses=0.0;
   int i;

   if(count>0)
      count++;

   for(i=OrdersHistoryTotal()-1; i>=0; i--)
{
      if(isOrderFilter(GetTicket(i,omPoolHistory),omAll|omPoolHistory,magic,symbol)==false)
         continue;

      loss=OrderProfit()+OrderCommission()+OrderSwap();

      //��� ������ �������
      if(count==-1)
{
         if(loss>0.0)
            break;

      }else if(count==0){
         if(loss>0.0)
            continue;

      }else if(count>0){
         if(count==1)
            break;
         count--;
      }

      losses+=loss;

   }//for

  return losses;
}
//==========================/ CalcLastProfits /===================================================
//! ������������ ������ ��������� ��������� �������
//! @return ���������� ������ � ������ ��������
double CalcLastProfits(
   //! ���������� ��������� ���������� ������� (���� ����� -1, �� ����� ������ �������� �������; ���� 0, �� ��� ���������, ���� ������ 0, �� ��������� count �������)
   int count,
   //! ���������� �����
   int magic,
   //! ����������
   string symbol=NULL
)
{
   double profit=0.0;
   double profits=0.0;
   int i;

   if(count>0)
      count++;

   for(i=OrdersHistoryTotal()-1; i>=0; i--)
{
      if(isOrderFilter(GetTicket(i,omPoolHistory),omAll|omPoolHistory,magic,symbol)==false)
         continue;

      profit=OrderProfit()+OrderCommission()+OrderSwap();

      //��� ������ �������
      if(count==-1)
{
         if(profit<0.0)
            break;

      }else if(count==0){
         if(profit<0.0)
            continue;

      }else if(count>0){
         if(count==1)
            break;
         count--;
      }

      profits+=profit;

   }//for

  return profits;
}
//========================/ PriceApplying /=====================================================
//! �������� ���
//! @return �������� ��������� ���� ����
double PriceApplying(
   //! ��������
   int idx=0,
   //! ��� ����
   ENUM_APPLIED_PRICE apply=PRICE_CLOSE,
   //! ����������
   string symbol=NULL,
   //! ������
   ENUM_TIMEFRAMES tf=PERIOD_CURRENT
)
{

   switch(apply)
{
      case PRICE_CLOSE :
         return iClose(symbol, tf, idx);
      case PRICE_OPEN:
         return iOpen(symbol, tf, idx);
      case PRICE_HIGH:
         return iHigh(symbol, tf, idx);
      case PRICE_LOW:
         return iLow(symbol, tf, idx);
      case PRICE_MEDIAN:
         return (iClose(symbol, tf, idx) + iOpen(symbol, tf, idx)) * 0.5;
      case PRICE_TYPICAL:
         return (iClose(symbol, tf, idx) + iHigh(symbol, tf, idx) + iLow(symbol, tf, idx)) / 3.0;
      case PRICE_WEIGHTED:
         return (iClose(symbol, tf, idx) + iOpen(symbol, tf, idx) + iHigh(symbol, tf, idx) + iLow(symbol, tf, idx)) * 0.25;
   };//switch 

   return 0.0;
}
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ������ � �������� ///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////



//=============================/ isOrderType /=============================================
//! ���������� �������������� � ������ ����� �������
bool isOrderType(
   //! ��� ������
   int op,
   //! ����� ��� ��������
   ulong order_mask
)
{
   return (1<<op) & order_mask & ((1<<6)-1);
}
//=============================/ OrderTypeToString /=============================================
//! ����� �������� ��������
string OrderTypeToString(
   //! ��� ������
   int op
)
{
   switch(op)
{
      case OP_BUY:
         return "BUY";

      case OP_SELL:
         return "SELL";

      case OP_BUYSTOP:
         return "BUY_STOP";

      case OP_SELLSTOP:
         return "SELL_STOP";

      case OP_BUYLIMIT:
         return "BUY_LIMIT";

      case OP_SELLLIMIT:
         return "SELL_LIMIT";
   }

   return "undefined type";
}
//=============================/ isOrderClosed /=============================================
//! ���������� ������ �� ������ �����
bool isOrderClosed(
   //! ����� ������. ���� ����� ����, �� ����������� ������� ���������
   int ticket=0
)
{
   if((ticket != 0) &&
      (ticket != OrderTicket()) &&
(OrderSelect(ticket,SELECT_BY_TICKET)==false)
)
      return true;
   return (OrderCloseTime() != 0.0);
}
//=============================/ isOrderFilter /=============================================
//! ���������� �������������� ������ � ������ ��������
bool isOrderFilter(
   //! ����� ������. ���� ����� ����, �� ����������� ������� ���������
   int ticket=0,
   //! �������� �� ����� ����� �������. ����������� ������� ����(�� ��������� ��� ����)
   ulong mask=omAll|omPoolAll,
   //! �������� �� ����������� �����. ���� ����� ����, �� �������� �����
   int magic=0,
   //! �������� �� �����������. @warning ���� ����� NULL, �� ��� �������� �� �����������, ����� �������� ����
   string symbol=NULL
) 
{

   //����� �� ������
   if((ticket != 0) &&
      (ticket != OrderTicket()) &&
(OrderSelect(ticket,SELECT_BY_TICKET)==false))
      return false;

   //�������� �� �������
   if(symbol!=NULL && OrderSymbol()!=symbol)
      return false;

   //�������� �� ����������� �����
   if(magic!=0 && OrderMagicNumber()!=magic)
      return false;

   //�������� �� ����� ���� ������
   if(isOrderType(OrderType(),mask)==false)
      return false;

   //�������� �� ����
   if((bool)(mask  &omPoolAll)==0)
      return false;

   if(!(bool(mask  &omPoolTrades) && (OrderCloseTime()==0)))
      if(!(bool(mask  &omPoolHistory) && (OrderCloseTime()!=0)))
         return false;


   return true;
}
//==========================/ GetTicket /===================================================
//! ���������� ����� ������ �� ��� �������
//! @return �����
int GetTicket(
   //! ����� �������
   int position,
   //! ����� ���� (�� ��������� Trades)
   EOrderTypeMask mask=omPoolTrades
)
{
   int pool=0;

   if((bool)(mask  &omPoolTrades))
{
      if(OrderSelect(position,SELECT_BY_POS,MODE_TRADES)==true)
         return OrderTicket();
   }else if((bool)(mask  &omPoolHistory)){
      if(OrderSelect(position,SELECT_BY_POS,MODE_HISTORY)==true)
         return OrderTicket();
   }

   return 0;
}
//========================/ FindOrders /=====================================================
//! ���� ������ �� �������
//! @return ���������� ���������� ��������� �������
int FindOrders(
   //! ���������
   int &tickets[],
   //! ����� ����
   int type_mask,
   //! ���������� �����
   int magic=0,
   //! ����������
   string symbol=NULL
)
{
   int i,count=0;

   if(bool(type_mask  &omPoolTrades))
      for(i=OrdersTotal()-1; i>=0; i--)
{
         if(!isOrderFilter(GetTicket(i,omPoolTrades),type_mask,magic,symbol))
            continue;
         ArrayAdd(tickets,OrderTicket(),16);
         count++;
      }

   if(bool(type_mask  &omPoolHistory))
      for(i=OrdersHistoryTotal()-1; i>=0; i--)
{
         if(!isOrderFilter(GetTicket(i,omPoolHistory),type_mask,magic,symbol))
            continue;
         ArrayAdd(tickets,OrderTicket(),16);
         count++;
      }

   return count;
}
//========================/ OpenOrder /=====================================================
//! ��������� ������������ ������
//! @return ���������� ����� ������
int OpenOrder(
   //! ��������
   ENUM_ORDER_TYPE op,
   //! ����� ������
   double lot,
   //! ���������� �����
   int magic,
   //! ���� ��������
   double price,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ������� ����������� � �������(���� 0, �� �����������)
   int takeprofit=0,
   //! ����������
   string symbol=NULL,
   //! ������� ������������� (���)
   ulong timeout=0,
   //! �����������
   string comment=NULL
)
{
   int ticket= 0;
   double sl = 0.0,tp = 0.0;
   int stoplevel;
   datetime expiration=0;
   color arrow;

   //����������� �������
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;

   //������������ ����
   lot=NormalizeLot(lot);

   //�������� �� �����������������
   if(AccountFreeMarginCheck(symbol,op,lot)<=0.0)
      return 0;

   //����������� ����������� �����
   if(magic<0)
      magic=__rad_lib_params.magic;

   //����������� ���� �������
   stoplevel=MarketInfoStopLevel(symbol);

   if((stoploss>0) && (stoploss<stoplevel))
      stoploss=stoplevel+1;

   if((takeprofit>0) && (takeprofit<stoplevel))
      takeprofit=stoplevel+1;

   //����������� ��������
   if(timeout != 0)
     expiration= TimeCurrent()+(datetime)timeout;

   //������������ ����
   price=NormalizeDouble(price,MarketInfoDigits(symbol));


   switch(op)
{

      case OP_BUY:
         price=BuyPriceOpen(symbol);
      case OP_BUYSTOP:
      case OP_BUYLIMIT:
         if(stoploss>0)
            sl=BuyPriceSL(stoploss,price,symbol);
         if(takeprofit>0)
            tp=BuyPriceTP(takeprofit,price,symbol);

         arrow=__rad_lib_params.color_buy_open;

         break;


      case OP_SELL:
         price=SellPriceOpen(symbol);
      case OP_SELLSTOP:
      case OP_SELLLIMIT:
         if(stoploss>0)
            sl=SellPriceSL(stoploss,price,symbol);
         if(takeprofit>0)
            tp = SellPriceTP(takeprofit, price, symbol);
         arrow = __rad_lib_params.color_sell_open;
         break;

      default:
         return -1;
   }//switch

   RAD_DEBUG_ASSERT(0,OrderTypeToString(op)+"  SYM:"+symbol+" LOT:"+string(lot)+" PRICE:"+
            string(price)+" SL:"+string(sl)+" TP:"+string(tp)+" EXPIRE:"+string(expiration))

   ticket=OrderSend(symbol,
                        op,
                        lot,
                        price,
                        __rad_lib_params.slippage,
                        sl,
                        tp,
                        comment,
                        magic,
                        expiration,
                        arrow);

   return ticket;
}
//========================/ MoveOrderStoplevels /=====================================================
//!������������� ����-������ ������
//! @return ���������� true � ������ ������
bool MoveOrderStoplevels(
   //! ����� ������
   int ticket,
   //! ������� ��������
   int stoploss,
   //! ������� �����������
   int takeprofit
)
{
   double sl=0.0,tp=0.0;

   // ���� �� ����� �����?
   if(isOrderClosed(ticket))
      return false;

   // ��������� ����������� �������   
   if(stoploss==RAD_IGNORE_VALUE)
      sl=OrderStopLoss();
   else if(stoploss==RAD_RESET_VALUE)
      sl=0.0;
   else if(isOrderType(OrderType(),omBuys))
      sl=BuyPriceSL(stoploss,OrderOpenPrice(),OrderSymbol());
   else
      sl=SellPriceSL(stoploss,OrderOpenPrice(),OrderSymbol());

   if(takeprofit==RAD_IGNORE_VALUE)
      tp=OrderTakeProfit();
   else if(takeprofit==RAD_RESET_VALUE)
      tp=0.0;
   else if(isOrderType(OrderType(),omBuys))
      tp=BuyPriceTP(takeprofit,OrderOpenPrice(),OrderSymbol());
   else
      tp=SellPriceTP(stoploss,OrderOpenPrice(),OrderSymbol());

   double stopdist=MarketInfoStopLevel(OrderSymbol());
   double point = MarketInfoPoint(OrderSymbol());
   double buypr = BuyPriceClose(OrderSymbol());
   double sellpr= SellPriceClose(OrderSymbol());

   // �������� �� ������������ ������
   if(isOrderType(OrderType(),omBuys))
{
      if(((buypr - stopdist * point <= stoploss )) ||
         ((buypr + stopdist * point >= takeprofit )) )
         return false;

   }else{
      if(((sellpr + stopdist * point >= stoploss )) ||
         ((sellpr - stopdist * point <= takeprofit )) )
         return false;
   };

   return OrderModify(OrderTicket(), OrderOpenPrice(), sl, tp, OrderExpiration());
}
//========================/ CloseOrder /=====================================================
//! ��������� ����� ��� ������� ����������
//! @return ���������� ���������� �������� �������
bool CloseOrder(
   //! �����
   int ticket
)
{

   if(isOrderClosed(ticket))
      return false;

   switch(OrderType())
{
      //�������� �� �������
      case OP_BUY : 
{
         if(OrderClose(OrderTicket(),OrderLots(),BuyPriceClose(),__rad_lib_params.slippage,__rad_lib_params.color_buy_close)==false)
            return false;
         break;
      }

         //�������� �� �������
         case OP_SELL : 
{
            if(OrderClose(OrderTicket(),OrderLots(),SellPriceClose(),__rad_lib_params.slippage,__rad_lib_params.color_sell_close)==false)
               return false;
            break;
         }

         case OP_BUYLIMIT :
         case OP_SELLLIMIT :
         case OP_BUYSTOP :
         case OP_SELLSTOP : 
{
            if(OrderDelete(OrderTicket(),__rad_lib_params.color_delete)==false)
               return false;
            break;
         }
      }//switch
   return true;
}
//========================/ CloseOrders /=====================================================
//! ��������� ��� �������� ������ � ���������
//! @return ���������� ���������� �������� �������
int CloseOrders(
   //! ����� ������ �����
   EOrderTypeMask mask=omAll,
   //! ���������� �����
   int magic=0,
   //! ����������
   string symbol=NULL
)
{
   int i;
   int close_cnt=0;

   mask|=omPoolTrades;

   for(i=OrdersTotal()-1; i>=0; i--)
{

      if(!isOrderFilter(GetTicket(i,omPoolTrades),mask,magic,symbol))
         continue;
      if(CloseOrder(OrderTicket())==false)
         continue;

      close_cnt++;
   }//for

   return close_cnt;
};
//========================/ ModifyOrder /=====================================================
//! ��������� ������������ ������, ����-������ � ���� ����������� ��������
//! @return ���������� ����� ������
bool ModifyOrder(
   //! ����� ������
   int ticket,
   //! ����� ����
   double price=RAD_IGNORE_VALUE,
   //! ������� ��������� � ���� �����������
   double stoploss=RAD_IGNORE_VALUE,
   //! ������� ����������� � �������
   double takeprofit=RAD_IGNORE_VALUE,
   //! �������
   ulong timeout=RAD_IGNORE_VALUE
)
{
   datetime ex;
   int op;
   string sym;

   if(isOrderClosed(ticket))
      return false;

   op=OrderType();

   //����� ��������
   if(timeout==RAD_IGNORE_VALUE)
      ex=OrderExpiration();
   else if(timeout==RAD_RESET_VALUE)
      ex=0;
   else
      if(ulong(TimeCurrent()-OrderOpenTime())<timeout)
         ex=OrderOpenTime()+datetime(timeout);
      else
         ex=OrderExpiration();

   //����
   if(price == RAD_IGNORE_VALUE || price <= 0 || price == RAD_RESET_VALUE || isOrderType(op, omActive))
      price = OrderOpenPrice();


   //��������
   if(stoploss == RAD_RESET_VALUE)
      stoploss = 0.0;
   else if(stoploss==RAD_IGNORE_VALUE)
      stoploss=OrderStopLoss();

   //����������
   if(takeprofit == RAD_RESET_VALUE)
      takeprofit = 0.0;
   else if(takeprofit==RAD_IGNORE_VALUE)
      takeprofit=OrderTakeProfit();

   if((OrderOpenPrice()==price) && 
(OrderStopLoss()==stoploss) && 
      (OrderTakeProfit() == takeprofit) &&
      (OrderExpiration() == ex))
      return true;

   RAD_DEBUG_ASSERT(0,OrderTypeToString(op)+" PRICE:"+
            string(price)+" SL:"+string(stoploss)+" TP:"+string(takeprofit)+" EXPIRE:"+string(ex))

   if(isOrderType(op,omBuys))
      return OrderModify(ticket, price, stoploss, takeprofit, ex, __rad_lib_params.color_buy_modify);
   else
      return OrderModify(ticket, price, stoploss, takeprofit, ex, __rad_lib_params.color_sell_modify);

}
//========================/ OpenBuy /=====================================================
//! ��������� BUY ������
//! @return ���������� ����� ������
int OpenBuy(
   //! ����� ������
   double lot,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ������� ����������� � �������(���� 0, �� �����������)
   int takeprofit=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   return OpenOrder(OP_BUY, lot, magic, 0.0, stoploss, takeprofit, symbol, timeout, comment);
}
//========================/ OpenBuyProfit /=====================================================
//! ��������� BUY ������ � ������� ������� �������
//! @return ���������� ����� ������
int OpenBuyProfit(
   //! ����
   double risk,
   //! �������
   double profit,
   //! ��������
   int stoploss=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{

   double lot;
   int tp;

   lot=NormalizeLot(LotOnRisk(risk,symbol));
   if(lot<MarketInfoMinLot(symbol))
      return -1;

   tp=(int)CurrencyToPoints(profit,lot,symbol);

   return OpenBuy(lot, stoploss, tp, timeout, comment, magic, symbol);

}
//========================/ OpenBuyPended /=====================================================
//! ��������� ���������� BUY ������
//! @return ���������� ����� ������
int OpenBuyPended(
   //! ����
   double price,
   //! ����� ������
   double lot,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ������� ����������� � �������(���� 0, �� �����������)
   int takeprofit=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   double ask=MarketInfoAsk(symbol);

   if(price>ask)
      return OpenOrder(OP_BUYSTOP, lot, magic, price, stoploss, takeprofit, symbol, timeout, comment);
   else if(price<ask)
      return OpenOrder(OP_BUYLIMIT, lot, magic, price, stoploss, takeprofit, symbol, timeout, comment);
   return 0;
}
//========================/ OpenBuyCompensation /=========================================
//! ��������� BUY �����, ������� ������������ ����� ���������� ������� ����������� ����������
//! @return ���������� ����� ������
int OpenBuyCompensation(
   //! ���� (%)
   double risk,
   //! �����������
   double profitfactor,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(magic<0)
      magic=__rad_lib_params.magic;
   double profit=MathAbs(CalcLastLosses(-1,magic,symbol))*profitfactor;
   RAD_DEBUG_ASSERT(0,"COMPENSATION LOSS:"+string(profit));
   return OpenBuyProfit(risk, profit, stoploss, timeout, comment, magic, symbol);
}
//========================/ OpenSell /=====================================================
//! ��������� SELL ������
//! @return ���������� ����� ������
int OpenSell(
   //! ����� ������
   double lot,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ������� ����������� � �������(���� 0, �� �����������)
   int takeprofit=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   return OpenOrder(OP_SELL, lot, magic, 0.0, stoploss, takeprofit, symbol, timeout, comment);
}
//========================/ OpenSellProfit /=====================================================
//! ��������� SELL ������ � ������� ������� �������
//! @return ���������� ����� ������
int OpenSellProfit(
   //! ����
   double risk,
   //! �������
   double profit,
   //! ��������
   int stoploss=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   double lot;
   int tp;

   lot=NormalizeLot(LotOnRisk(risk,symbol));
   if(lot<MarketInfoMinLot(symbol))
      return -1;

   tp=(int)CurrencyToPoints(profit,lot,symbol);

   return OpenSell(lot, stoploss, tp, timeout, comment, magic, symbol);
}
//========================/ OpenSellPended /=====================================================
//! ��������� ���������� SELL ������
//! @return ���������� ����� ������
int OpenSellPended(
   //! ����
   double price,
   //! ����� ������
   double lot,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ������� ����������� � �������(���� 0, �� �����������)
   int takeprofit=0,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL,
   //! ���������� �����
   int magic=-1,
   //! ����������
   string symbol=NULL
)
{
   double bid=MarketInfoBid(symbol);

   if(price>bid)
      return OpenOrder(OP_SELLLIMIT, lot, magic, price, stoploss, takeprofit, symbol, timeout, comment);
   else if(price<bid)
      return OpenOrder(OP_SELLSTOP, lot, magic, price, stoploss, takeprofit, symbol, timeout, comment);
   return 0;
}
//========================/ OpenSellCompensation /=========================================
//! ��������� SELL �����, ������� ������������ ����� ���������� ������� ����������� ����������
//! @return ���������� ����� ������
int OpenSellCompensation(
   //! ���� (%)
   double risk,
   //! �����������
   double profitfactor,
   //! ���������� �����
   int magic,
   //! ������� ��������� � �������(���� 0, �� �����������)
   int stoploss=0,
   //! ����������
   string symbol=NULL,
   //! ���� �������� ������ (0 - ������������)
   ulong timeout=0,
   //! �����������
   string comment=NULL
)
{
   if(symbol == NULL)
      symbol = __rad_lib_params.symbol;
   if(magic<0)
      magic=__rad_lib_params.magic;

   double profit=MathAbs(CalcLastLosses(-1,magic,symbol))*profitfactor;
   RAD_DEBUG_ASSERT(0,"COMPENSATION LOSS:"+string(profit));
   return OpenSellProfit(risk, profit, stoploss, timeout, comment, magic, symbol);
}
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ���������� ������� //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// 

//========================/ LotOnRisk /=====================================================
//! ���������� ������������� ����, ���������������� ����������� ����� � %
double   LotOnRisk(
   //! ���� (%)
   double perc_risk,
   //! ����������
   string symbol=NULL
)
{
   double marginreq=MarketInfoMarginRequired(symbol);

   if(marginreq==0)
      return 0.0;

   return NormalizeLot(0.01 * perc_risk * AccountFreeMargin() / marginreq);
};
//========================/ LotOnMartingale /=====================================================
//! ���������� ������������� ����, ���������������� ����������� ����� � %
double   LotOnMartingale(
   //! ������� ���
   double lot_base,
   //! ���������� ����������
   double lot_exp,
   //! �������
   int stage
)
{
   if((lot_base<=0) || (lot_exp<=0.0))
      return 0.0;

   if(stage==0)
      return lot_base;
   else
      return lot_base * MathPow(lot_exp, stage);
}
//========================/ LotOnFibo /=====================================================
//! ���������� ������������� ����, ���������������� ����������� ����� � %
double   LotOnFibo(
   //! ������� ���
   double lot_base,
   //! �������
   int stage
)
{
   if((lot_base<=0) || (stage<0))
      return 0.0;

   double tmp,last=lot_base;

   while(--stage>0)
{
      tmp=lot_base;
      lot_base+=last;
      last=tmp;
   }

   return lot_base;

}
//========================/ LotOnOptimum /=====================================================
//! ���������� ����, �������� ���������� ������������� ������� � �������� ��������
double   LotOnOptimum(
   //! ����������� ���������� ����
   double risk_max,
   //! �����������
   double profitfactor,
   //! ������ �������� ����
   int points,
   //! ������� ����� ��������� ������� �������
   int losses_count,
   //! ���������� �����
   int magic,
   //! ����������
   string symbol
)
{

   double profit;
   double max_lot;
   double lot;

   max_lot= LotOnRisk(risk_max,symbol);
   profit = profitfactor * MathAbs(CalcLastLosses(losses_count,magic,symbol));

   lot=CurrencyToLot(profit,points,symbol);

   return (lot > max_lot) ? max_lot : lot;

}
//=======================/ MarginRequired /======================================================

/*!
	����������� ����������� ���-�� ��������� ������� ��� �������� �������
	symbol - ����������
	lots - ������ ����
	���������� ����� � ������ ��������
*/
double MarginRequired(string symbol=NULL,double lots=1)
{
   string first;      // ������ ������,	 �������� EUR
   string second;      // ������ ������,	 �������� USD
   string postfix;    // ��������, �������� .ecn
   string curr_base;  // ������ ��������,  �������� USD
   int leverage;      // ��������� �����,  �������� 100
   int contract;     // ������ ���������, �������� 100000
   double bid;         // ���� ���

   if(symbol == NULL)
      symbol = Symbol();

   first=StringSubstr(symbol,0,3);
   second=StringSubstr(symbol,3,3);
   postfix=StringSubstr(symbol,6);
   curr_base=AccountCurrency();

   leverage =       (int)AccountLeverage();
   contract =       (int)MarketInfo(symbol,MODE_LOTSIZE);
   bid=MarketInfo(symbol,MODE_BID);

   // �������� ������� ������
   if(bid<=0 || contract<=0)
{
      Comment("no market information for '",symbol,"'");
      return 0.0;
   }

   // ��������� ����� ������� �������� - ��� �������
   if(first==curr_base)
      return contract*lots/leverage;         // USDxxx
   if(second==curr_base)
      return contract*bid*lots/leverage;      // xxxUSD

   // ��������� ������� ������, ���� ������ �������������� ����� ������ ��������
   string base=curr_base+first+postfix;         // USDxxx

   if((bid=MarketInfo(base,MODE_BID))>0)
      return contract / bid * lots / leverage;

   // ��������� ��������
   base=first+curr_base+postfix;               // xxxUSD

   if((bid=MarketInfo(base,MODE_BID))>0)
      return contract * bid * lots / leverage;

   //��� ����������� ������� �����������
   Print("can not convert '",symbol,"'");
   return 0.0;
}
//=====================/ FlipQuote /========================================================
//! �������������� ��������� (�������� EURUSD -> USDEUR)
//! @return ���������� ����������� ���������.
string FlipQuote(
   //! ����������
   string symbol=NULL
)
{

   if(symbol == NULL)
      symbol = Symbol();
   return StringConcatenate(StringSubstr(symbol, 3, 3), StringSubstr(symbol, 0, 3), StringSubstr(symbol, 6));
}
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ��������� ��������� /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////




//==========================/ TrailToBreakeven /===================================================
//! ��������� ����� � ���������
bool TrailingToBreakeven(
   //! ����� ������
   int ticket,
   //! ������� � ������ � �������
   int excess=0
)
{

   double be=CalcBreakeven(ticket,excess);

   if(be==0.0 || isOrderClosed(ticket))
      return false;

   if(be==OrderStopLoss())
      return true;

   if(isOrderType(OrderType(),omBuys))
{
         if(be>BuyPriceClose())
            return false;
   }else{
      if(be<SellPriceClose())
            return false;
   }

   return OrderModify(ticket, OrderOpenPrice(), be, OrderTakeProfit(), OrderExpiration());
}
//========================/ TrailingDistance /=====================================================
//! �������� �� ���������
bool TrailingDistance(
   //! �����
   int ticket,
   //! ������ ���������
   int start,
   //! ���������� �� �����
   int distance,
   //! ��� ���������
   int step=1,
   //! �������� � ���� �������
   bool is_losses=false
)
{
   double sl,pr;

   if(isOrderClosed(ticket))
      return false;

   sl=OrderStopLoss();

   if(isOrderType(OrderType(),omBuy))
{
      pr=BuyPriceClose(OrderSymbol());

      if(PriceToPoints(pr-OrderOpenPrice(),OrderSymbol())<start)
         if(is_losses==false)
            return false;

      if((OrderStopLoss()==0.0) || 
(pr-OrderStopLoss()>PointToPrice(distance+step,OrderSymbol())))
         sl=pr-PointToPrice(distance,OrderSymbol());

      return OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration(), __rad_lib_params.color_buy_modify);

   }else if(isOrderType(OrderType(),omSell)){
      pr=SellPriceClose(OrderSymbol());

      if(PriceToPoints(OrderOpenPrice()-pr,OrderSymbol())<start)
         if(is_losses==false)
            return false;

      if((OrderStopLoss()==0.0) || 
(OrderStopLoss()-pr>PointToPrice(distance+step,OrderSymbol())))
         sl=pr+PointToPrice(distance,OrderSymbol());

      return OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), OrderExpiration(), __rad_lib_params.color_sell_modify);
   }

   return false;
}
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ���������� ����������� ����������� //////////////////////
///////////////////////////////////////////////////////////////////////////////////////////



//=============================/ ColorRGBA /=============================================
//! �������� �����
//! @return ���������� ����
color ColorRGBA(uchar red,uchar green,uchar blue,uchar alpha=255)
{
   return color(red | (green<<8) | (blue << 16) | (alpha << 24));
}
//=============================/ ColorRGBA /=============================================
//! �������� �����
//! @return ���������� ����
color ColorRGBA(double red,double green,double blue,double alpha=1.0)
{
   return color(uint(red) | (uint(green * 255.0)<<8) | (uint(blue *255.0) << 16) | (uint(alpha * 255.0) << 24));
}
//=============================/ MathRandomDouble /=============================================
//! ��������� ���������� ������������� ����� � ��������� 
//! @return ���������� ��������� �����
double MathRandomDouble(
   //! ����������� ��������
   double min,
   //! ������������ ��������
   double max
)
{
   double ret=MathSqrt(double(ulong(MathRand())*ulong(MathRand())) *(1.0/(32767.0*32767.0)));
   return min + ret * (max - min);
}
//=============================/ MathRandomLong /=============================================
//! �������������� �������� ������� � �������. 
//! @return ���������� ����� � ��������
long MathRandomLong(
   //! ����������� ��������
   long min,
   //! ������������ ��������
   long max
)
{
   return (long)MathRandomDouble(min, max);
}
//=============================/ MathSwap /=============================================
//! ����� ����������. 
template<typename T>
void MathSwap(T &l,T &r)
{
   T tmp=l;
   l = r;
   r = tmp;
}
//=============================/ MathSign /=============================================
//! ����� ����������. 
template<typename T>
int MathSign(const T &val)
{
   if(val < T(0)) return -1;
   else return +1;
}
//=============================/ MathMax /=============================================
template<typename T>
T MathMax(T v1,T v2,T v3)
{
   return MathMax(v1, MathMax(v2, v3));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T MathMax(T v1,T v2,T v3,T v4)
{
   return MathMax(v1, MathMax(v2, MathMax(v3,v4)));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T MathMax(T v1,T v2,T v3,T v4,T v5)
{
   return MathMax(v1, MathMax(v2, MathMax(v3,MathMax(v4, v5))));
}
//=============================/ MathMin /=============================================
template<typename T>
T MathMin(T v1,T v2,T v3)
{
   return MathMin(v1, MathMin(v2, v3));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T MathMin(T v1,T v2,T v3,T v4)
{
   return MathMin(v1, MathMin(v2, MathMin(v3,v4)));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T MathMin(T v1,T v2,T v3,T v4,T v5)
{
   return MathMin(v1, MathMin(v2, MathMin(v3,MathMin(v4, v5))));
}
//=============================/ MathDiscrete /=============================================
template<typename T>
T MathDiscrete(T value,T step)
{
   return (step == 0) ? value : T(long(value / step)) * step;
}
//=============================/ MathConstrain /=============================================
template<typename T>
T MathConstrain(T value,T min,T max)
{
   return (value < min) ? min : (value > max) ? max : value;
}
//=============================/ MathMA /=============================================
double MathMALinear(const double &array[],int period,int method,int pos)
{
   double val,sum=0,w=0;
   int i,k;
   int len=ArraySize(array);

   switch(method)
{

      case 0:
{

         for(i=0,k=pos; i<period; i++,k++)
{
            if(i>=len)
               break;

            val = array[k];
            sum = (period - i) * val;
            w+=(period-i);
         }

         return sum / w;
      };


   }

   return 0.0;
}
//=============================/ StringTrimBoth /=============================================
//! �������� ������� � ����� ������
string StringTrimBoth(const string str)
{
   return StringTrimLeft(StringTrimRight(str));
}
//===============================================================================
int StringFindHtmlTag(const string str,int pos,string tag,string &out[],int max_founds=-1)
{
   int taglen=StringLen(tag);
   int nest;
   int p1=0,p2=0;
   int founds=0;

   ArrayResize(out,0);

   while(pos>=0)
{

      pos=StringFind(str,"<"+tag,pos);
      if(pos<0) break;

      pos=StringFind(str,">",pos);
      if(pos<0) break;

      //������� ����� �������
      p1=pos+1;

      //����� ������������ ����
      nest=1;
      while(nest>0)
{
         pos=StringFind(str,tag,pos+1);
         if(pos<0) break;

         if(StringSubstr(str,pos-2,2)=="</")
            nest--;
         else if(StringSubstr(str,pos-1,1)=="<")
            nest++;
      }

      if(pos<0) break;

      p2=pos-2;

      //�������� � ������
      ArrayAdd(out,StringSubstr(str,p1,p2-p1),16);
      if(++founds>=max_founds && max_founds>0)
         break;

   }

   return founds;

}
//=============================/ StringFindNumbers /=============================================
//! ����� �����
int StringFindNumbers(
   const string &str,
   string &numbers[]
)
{

   string words[];
   ushort ch;

   ArrayResize(numbers,0);

   StringSplit(str,' ',words);

   for(int i=0; i<ArraySize(words); i++)
{
      ch=StringGetChar(words[i],0);
      if(ch>='0' && ch<='9')
         ArrayAdd(numbers,words[i],8);
   }

   return ArraySize(numbers);

}
//=============================/ StringTrimBoth /=============================================
//! �������� ������� � ����� ������
string StringConcat(const string &str[])
{
   string tmp;
   for(int i=0; i<ArraySize(str); i++)
      tmp+=str[i];
   return tmp;
}
//=============================/ ArrayAdd /=============================================
//! ���������� �������� � ������
template<typename T>
void ArrayAdd(
   //! ������
   T &array[],
   //! ����������� �������
   const T elem,
   //! ������ ����������
   int reserve=0
)
{
   int size=ArraySize(array);
   if(!(bool)ArrayResize(array, size+1, reserve))  return;
   array[size]=elem;
}
//! ���������� �������� � ������
template<typename T>
void ArrayAdd(
   //! ������
   T &array[],
   //! ����������� �������
   const T &elem,
   //! ������ ����������
   int reserve=0
)
{
   int size=ArraySize(array);
   if(!(bool)ArrayResize(array, size+1, reserve))  return;
   array[size]=elem;
}
//=============================/ ArrayAdd /=============================================
//! ���������� ������� � �������
template<typename T>
void ArrayAdd(
   //! ������
   T &array[],
   //! ����������� �������
   const  T &array_add[],
   //! ������ ����������
   int reserve=0
)
{
   int i,j;
   int size1 = ArraySize(array);
   int size2 = ArraySize(array_add);
   ArrayResize(array,size1+size2,reserve);
   for(i=size1,j=0; j<size2; i++,j++)
      array[i]=array_add[j];

}
//=============================/ ArrayDelElement /=============================================
//! �������� �������� �� �������
template<typename T>
void ArrayDel(
   //! ������
   T &array[],
   //! ��������� �������
   int pos,
   //! �����
   int length=1
)
{
   int size=ArraySize(array);
   int i,j;
   for(i=pos,j=pos+length; j<size; i++,j++)
      array[i]=array[j];
   ArrayResize(array,size-length);
}
//=============================/ ArrayMaxValue /=============================================
//! ����� ������������� ��������
template<typename T>
T ArrayMaxValue(const T &array[],int pos=0,int length=-1)
{
   if(length<0)
      length=WHOLE_ARRAY;
  return array[ArrayMaximum(array, length, pos)];
}
//=============================/ ArrayMinValue /=============================================
//! ����� ������������ ��������
template<typename T>
T ArrayMinValue(const T &array[],int pos=0,int length=-1)
{
   if(length<0)
      length=WHOLE_ARRAY;
  return array[ArrayMinimum(array, length, pos)];
}
//=============================/ ArrayLast /=============================================
//! ���������� ������� � �������
template<typename T>
T ArrayLast(const T &array[])
{
   return array[ArraySize(array)-1];
}
//=============================/ ArrayLast /=============================================
//! ���������� ������� � �������
template<typename T>
T ArrayFirst(const T &array[])
{
   return array[0];
}
//=============================/ ArrayToString /=============================================
template<typename T>
string ArrayToString(
   //! ������
   const T &array[],
   //! ������
   int pos,
   //! �����
   int length=-1,
   //! �����������
   string delimeter=" "
)
{
   int last=(length<0) ? ArraySize(array) : length+pos;
   string str;

   for(int i=pos; i<last; i++)
      str+=string(array[i])+delimeter;

   return str;
}
//=============================/ ArrayToString /=============================================
template<typename T>
bool ArrayEmpty(
   //! ������
   const T &array[]
)
{
   return bool(ArraySize(array));
}
//=============================/ ArrayReverse /=============================================
template<typename T>
void ArrayReverse(
   //! ������
   T &array[]
)
{
   int i,j;

   for(i=0,j=ArraySize(array)-1; i<j; i++,j--)
      MathSwap(array[i],array[j]);
}
//========================/ SymbolCurrencyBase /=====================================================
//! ������� ������ ����������� 
string SymbolCurrencyBase(string symbol=NULL)
{
   return SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
}
//========================/ SymbolCurrencyProfit /=====================================================
//! ������ �������
string SymbolCurrencyProfit(string symbol=NULL)
{
   return SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
}
//========================/ SymbolCurrencyMargin /=====================================================
//! ������ � ������� ����������� ��������� ��������
string SymbolCurrencyMargin(string symbol=NULL)
{
   return SymbolInfoString(symbol, SYMBOL_CURRENCY_MARGIN);
}
//========================/ SymbolCurrencyDescription /=====================================================
//! ��������� �������� �������
string SymbolCurrencyDescription(string symbol=NULL)
{
   return SymbolInfoString(symbol, SYMBOL_DESCRIPTION);
}
//========================/ MarketInfoLow /=====================================================
//! ����������� ������� ����
double MarketInfoLow(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_LOW);
}
//========================/ MarketInfoHigh /=====================================================
//! ������������ ������� ����
double MarketInfoHigh(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_HIGH);
}
//========================/ MarketInfoTime /=====================================================
//! ����� ����������� ��������� ���������
datetime MarketInfoTime(
   //! ����������
   string symbol=NULL
)
{
   return (datetime)MarketInfo(symbol, MODE_TIME);
}
//========================/ MarketInfoBid /=====================================================
//! ��������� ����������� ���� �����������
double MarketInfoBid(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_BID);
}
//========================/ MarketInfoAsk /=====================================================
//! ��������� ����������� ���� �������
double MarketInfoAsk(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_ASK);
}
//========================/ MarketInfoPoint /=====================================================
//! ������ ������ � ������ ���������
double MarketInfoPoint(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_POINT);
}
//========================/ MarketInfoDigits /=====================================================
//! ���������� ���� ����� ������� � ���� �����������
int MarketInfoDigits(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_DIGITS);
}
//========================/ MarketInfoSpread /=====================================================
//! ����� � �������
int MarketInfoSpread(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_SPREAD);
}
//========================/ MarketInfoStopLevel /=====================================================
//! ���������� ���������� ������� ����-�����/����-������� � �������
int MarketInfoStopLevel(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_STOPLEVEL);
}
//========================/ MarketInfoLotSize /=====================================================
//! ������ ��������� � ������� ������ �����������
int MarketInfoLotSize(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_LOTSIZE);
}
//========================/ MarketInfoTickValue /=====================================================
//! ������ ������������ ��������� ���� ����������� � ������ ��������
double MarketInfoTickValue(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_TICKVALUE);
}
//========================/ MarketInfoTickSize /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoTickSize(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_TICKSIZE);
}
//========================/ MarketInfoSwapLong /=====================================================
//! ������ ����� ��� ������� �� �������
double MarketInfoSwapLong(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_SWAPLONG);
}
//========================/ MarketInfoSwapShort /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoSwapShort(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_SWAPSHORT);
}
//========================/ MarketInfoStarting /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
datetime MarketInfoStarting(
   //! ����������
   string symbol=NULL
)
{
   return (datetime)MarketInfo(symbol, MODE_STARTING);
}
//========================/ MarketInfoExpiration /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
datetime MarketInfoExpiration(
   //! ����������
   string symbol=NULL
)
{
   return (datetime)MarketInfo(symbol, MODE_EXPIRATION);
}
//========================/ MarketInfoTradeAllowed /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
bool MarketInfoTradeAllowed(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_TRADEALLOWED);
}
//========================/ MarketInfoMinLot /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoMinLot(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MINLOT);
}
//========================/ MarketInfoLotStep /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoLotStep(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_LOTSTEP);
}
//========================/ MarketInfoMaxLot /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoMaxLot(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MAXLOT);
}
//========================/ MarketInfoSwapType /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
int MarketInfoSwapType(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_SWAPTYPE);
}
//========================/ MarketInfoProfitCalcMode /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
int MarketInfoProfitCalcMode(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_PROFITCALCMODE);
}
//========================/ MarketInfoMarginCalcMode /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
int MarketInfoMarginCalcMode(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_MARGINCALCMODE);
}
//========================/ MarketInfoMarginInit /=====================================================
//! ����������� ��� ��������� ���� ����������� � �������
double MarketInfoMarginInit(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MARGININIT);
}
//========================/ MarketInfoMarginMaintenance /=====================================================
//! �����, ��������� � ���������� ������� � ������� �� 1 ���
double MarketInfoMarginMaintenance(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MARGINMAINTENANCE);
}
//========================/ MarketInfoMarginHedged /=====================================================
//! ������� ������������ � ������ ��������
double MarketInfoMarginHedged(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MARGINHEDGED);
}
//========================/ MarketInfoMarginRequired /=====================================================
//! ������ ��������� �������, ����������� ��� �������� 1 ���� �� �������
double MarketInfoMarginRequired(
   //! ����������
   string symbol=NULL
)
{
   return MarketInfo(symbol, MODE_MARGINREQUIRED);
}
//========================/ MarketInfoFreezeLevel /=====================================================
//! ������� ��������� ������� � �������
int MarketInfoFreezeLevel(
   //! ����������
   string symbol=NULL
)
{
   return (int)MarketInfo(symbol, MODE_FREEZELEVEL);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////������ � �����////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


//===============================================================================
long DownloadPage(
   //! �����
   string addr,
   //! ������ �� ������   
   string &page,
   //! ����� ��������
   int retry_count=0,
   //! ����� ����� ���������
   int retry_pause=5
) 
{

   long ret=0;
   int retry;

   // �������� ��������� DLL
   if(!IsDllsAllowed()) 
{
      ret=-1;
      RAD_DEBUG_ASSERT(0,"DLL �� ���������. �������� ����������� �������� DLL");
      return ret;
   }

   for(retry=0; retry<=retry_count; retry++)
{

      //�������� ����������
      if(InternetAttemptConnect(0)!=0) 
{
         ret=-2;
         RAD_DEBUG_ASSERT(1,"��������-���������� �� ���������");
         continue;
      }

      // �������� ������
      string UserAgent="Mozilla/4.0 (compatible; MSIE 10; Windows NT 6.1)";
      string nill = "";
      int Session = InternetOpenW(UserAgent, 0, nill, nill, 0);

      if(Session<=0) 
{
         RAD_DEBUG_ASSERT(2,"������ ���������");
         InternetCloseHandle(Session);
         ret=-3;
         continue;
      }

      // �������� ��������
      int hURL= InternetOpenUrlW(Session, addr, nill, 0, FLAG_RELOAD|FLAG_PRAGMA_NOCACHE, 0);
      if(hURL<=0) 
{
         ret=-4;
         RAD_DEBUG_ASSERT(3,"���������� ��������");
         continue;
      }

      // ������ ��������		
      uchar ch[];
      ArrayResize(ch,DOWNLOADING_BYTES);
      int dwBytes;
      page="";
      while(InternetReadFile(hURL,ch,DOWNLOADING_BYTES,dwBytes)) 
{
         if(dwBytes<=0)
            break;
         page+=CharArrayToString(ch,0,dwBytes,CP_UTF8);
      }

      // ���������� ����������
      InternetCloseHandle(hURL);

      RAD_DEBUG_ASSERT(4,"������ ����������� ������ �� ��������� "+string(StringLen(page)));
      ret=StringLen(page);
      break;
   }//while

   return ret;
}
//===============================================================================
long DownloadFile(
   //! �����
   string addr,
   //! ������ �� ������   
   const string filename,
   //! ����� ��������
   int retry_count=0,
   //! ����� ����� ���������
   int retry_pause=5
) 
{

   long ret=0;
   long retry;
   long bytes=0;

   // �������� ��������� DLL
   if(!IsDllsAllowed()) 
{
      ret=-1;
      RAD_DEBUG_ASSERT(0,"DLL �� ���������. �������� ����������� �������� DLL");
      return ret;
   }

   for(retry=0; retry<=retry_count; retry++)
{

      //�������� ����������
      if(InternetAttemptConnect(0)!=0) 
{
         ret=-2;
         RAD_DEBUG_ASSERT(1,"��������-���������� �� ���������");
         continue;
      }

      // �������� ������
      string UserAgent="Mozilla/4.0 (compatible; MSIE 10; Windows NT 6.1)";
      string nill = "";
      int Session = InternetOpenW(UserAgent, 0, nill, nill, 0);

      if(Session<=0) 
{
         RAD_DEBUG_ASSERT(2,"������ ���������");
         InternetCloseHandle(Session);
         ret=-3;
         continue;
      }

      // �������� ��������
      int hURL= InternetOpenUrlW(Session, addr, nill, 0, FLAG_RELOAD|FLAG_PRAGMA_NOCACHE, 0);
      if(hURL<=0) 
{
         ret=-4;
         RAD_DEBUG_ASSERT(3,"���������� ��������");
         continue;
      }

      // �������� �����
      uchar ch[];
      ArrayResize(ch,DOWNLOADING_BYTES);
      int dwBytes;

      CFileBin file;

      if(file.Open(filename,FILE_WRITE|FILE_REWRITE)<0)
         return 0;

      while(InternetReadFile(hURL,ch,DOWNLOADING_BYTES,dwBytes)) 
{
         if(dwBytes<=0)
            break;
         bytes+=dwBytes;
         file.WriteCharArray(ch,0,dwBytes);
      }
      file.Close();

      // ���������� ����������
      InternetCloseHandle(hURL);

      RAD_DEBUG_ASSERT(4,"������ ����������� ������ �� ��������� "+string(ret));
      break;
   }//while

   return ret;

}

#undef RAD_VERSIONMAJOR   
#undef RAD_VERSIONMINOR    
#undef RAD_DESCRIPTION      
#undef RAD_LICENSE       

#undef FLAG_PRAGMA_NOCACHE 
#undef FLAG_RELOAD 
#undef HTTP_QUERY_CONTENT_LENGTH 

#endif 
//+------------------------------------------------------------------+
