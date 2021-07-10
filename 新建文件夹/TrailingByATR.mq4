//+------------------------------------------------------------------+
//|                                                TrailingByATR.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/"


extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iAtr_timeframe;      // период графика, на котором считается ATR (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int      iAtr1_period = 5;    // период первого ATR
extern   int      iAtr1_shift = 1;     // сдвиг первого ATR
extern   int      iAtr2_period = 36;   // период второго ATR
extern   int      iAtr2_shift = 1;     // сдвиг второго ATR
extern   double   dCoeff = 1;          // коэффициент, на который множим ATR, чтобы получить стоплосс (при coeff=1 стоп будер размещен на расстоянии в 1 ATR, при coeff=1.5 - на расстоянии в полтора ATR и т.д.)
extern   bool     bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ATR (Average True Range, Средний истинный диапазон)  |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| период АТR и коэффициент, на который умножается ATR. Т.о.        |
//| стоплосс "тянется" на расстоянии ATR х N от текущего курса;      |
//| перенос - на новом баре (т.е. от цены открытия очередного бара)  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {  
   return(0);
  }
  
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  { 
   TrailingByATR(iTicket,iAtr_timeframe,iAtr1_period,iAtr1_shift,iAtr2_period,iAtr2_shift,dCoeff,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByATR(int ticket,int atr_timeframe,int atr1_period,int atr1_shift,int atr2_period,int atr2_shift,double coeff,bool trlinloss)
   {
   // проверяем переданные значения   
   if ((ticket==0) || (atr1_period<1) || (atr2_period<1) || (coeff<=0) || (!OrderSelect(ticket,SELECT_BY_TICKET)) || 
   ((atr_timeframe!=1) && (atr_timeframe!=5) && (atr_timeframe!=15) && (atr_timeframe!=30) && (atr_timeframe!=60) && 
   (atr_timeframe!=240) && (atr_timeframe!=1440) && (atr_timeframe!=10080) && (atr_timeframe!=43200)) || (atr1_shift<0) || (atr2_shift<0))
      {
      Print("Трейлинг функцией TrailingByATR() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      }
   
   double curr_atr1; // текущее значение ATR - 1
   double curr_atr2; // текущее значение ATR - 2
   double best_atr; // большее из значений ATR
   double atrXcoeff; // результат умножения большего из ATR на коэффициент
   double newstop; // новый стоплосс
   
   // текущее значение ATR-1, ATR-2
   curr_atr1 = iATR(Symbol(),atr_timeframe,atr1_period,atr1_shift);
   curr_atr2 = iATR(Symbol(),atr_timeframe,atr2_period,atr2_shift);
   
   // большее из значений
   best_atr = MathMax(curr_atr1,curr_atr2);
   
   // после умножения на коэффициент
   atrXcoeff = best_atr * coeff;
              
   // если длинная позиция (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // откладываем от текущего курса (новый стоплосс)
      newstop = Bid - atrXcoeff;           
      
      // если trlinloss==true (т.е. следует тралить в зоне лоссов), то
      if (trlinloss==true)      
         {
         // если стоплосс неопределен, то тралим в любом случае
         if ((OrderStopLoss()==0) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // иначе тралим только если новый стоп лучше старого
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         // если стоплосс неопределен, то тралим, если стоп лучше открытия
         if ((OrderStopLoss()==0) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // если стоп не равен 0, то меняем его, если он лучше предыдущего и курса открытия
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }
      
   // если короткая позиция (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      // откладываем от текущего курса (новый стоплосс)
      newstop = Ask + atrXcoeff;
      
      // если trlinloss==true (т.е. следует тралить в зоне лоссов), то
      if (trlinloss==true)      
         {
         // если стоплосс неопределен, то тралим в любом случае
         if ((OrderStopLoss()==0) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // иначе тралим только если новый стоп лучше старого
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         // если стоплосс неопределен, то тралим, если стоп лучше открытия
         if ((OrderStopLoss()==0) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         // если стоп не равен 0, то меняем его, если он лучше предыдущего и курса открытия
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }      
   }


//+------------------------------------------------------------------+