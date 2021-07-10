//+------------------------------------------------------------------+
//|                                            TrailingByShadows.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/"

extern   int   iTicket;             // уникальный номер (тикет) открытой позиции
extern   int   iTmfrm;              // период, по барам которого следует тралить (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int   iBars_n = 3;         // кол-во баров, по которым следует тралить
extern   int   iIndent = 3;         // отступ от тени бара, на котором размещается стоплосс
extern   bool  bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ТЕНЯМ N СВЕЧЕЙ                                       |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| количество баров, по теням которых необходимо трейлинговать      |
//| (от 1 и больше) и отступ (пунктов) - расстояние от макс. (мин.)  |
//| свечи, на которое переносится стоплосс (от 0), переключатель     |
//| trlinloss указывает, следует ли трейлинговать на участке         |
//| "стоплосс-курс открытия позиции.                                 |
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
   TrailingByShadows(iTicket,iTmfrm,iBars_n,iIndent,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByShadows(int ticket,int tmfrm,int bars_n, int indent,bool trlinloss)
   {  
   
   int i; // counter
   double new_extremum;
   
   // проверяем переданные значения
   if ((bars_n<1) || (indent<0) || (ticket==0) || ((tmfrm!=1) && (tmfrm!=5) && (tmfrm!=15) && (tmfrm!=30) && (tmfrm!=60) && (tmfrm!=240) && (tmfrm!=1440) && (tmfrm!=10080) && (tmfrm!=43200)) || (!OrderSelect(ticket,SELECT_BY_TICKET)))
      {
      Print("Трейлинг функцией TrailingByShadows() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      } 
   
   // если длинная позиция (OP_BUY), находим минимум bars_n свечей
   if (OrderType()==OP_BUY)
      {
      for(i=1;i<=bars_n;i++)
         {
         if (i==1) new_extremum = iLow(Symbol(),tmfrm,i);
         else 
         if (new_extremum>iLow(Symbol(),tmfrm,i)) new_extremum = iLow(Symbol(),tmfrm,i);
         }         
      
      // если тралим и в зоне убытков
      if (trlinloss==true)
         {
         // если найденное значение "лучше" текущего стоплосса позиции, переносим 
         if ((((new_extremum - indent*Point)>OrderStopLoss()) || (OrderStopLoss()==0)) && (new_extremum - indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum - indent*Point,OrderTakeProfit(),OrderExpiration()))            
         Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      else
         {
         // если новый стоплосс не только лучше предыдущего, но и курса открытия позиции
         if ((((new_extremum - indent*Point)>OrderStopLoss()) || (OrderStopLoss()==0)) && ((new_extremum - indent*Point)>OrderOpenPrice()) && (new_extremum - indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum-indent*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
      
   // если короткая позиция (OP_SELL), находим минимум bars_n свечей
   if (OrderType()==OP_SELL)
      {
      for(i=1;i<=bars_n;i++)
         {
         if (i==1) new_extremum = iHigh(Symbol(),tmfrm,i);
         else 
         if (new_extremum<iHigh(Symbol(),tmfrm,i)) new_extremum = iHigh(Symbol(),tmfrm,i);
         }         
           
      // если тралим и в зоне убытков
      if (trlinloss==true)
         {
         // если найденное значение "лучше" текущего стоплосса позиции, переносим 
         if ((((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderStopLoss()) || (OrderStopLoss()==0)) && (new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      else
         {
         // если новый стоплосс не только лучше предыдущего, но и курса открытия позиции
         if ((((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderStopLoss()) || (OrderStopLoss()==0)) && ((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderOpenPrice()) && (new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать ордер №",OrderTicket(),". Ошибка: ",GetLastError());
         }      
      }      
   }
//+------------------------------------------------------------------+