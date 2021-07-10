//+------------------------------------------------------------------+
//|                                           TrailingByFractals.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iTmfrm;              // период графика, на котором определяются фракталы (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int      iFrktl_bars = 5;     // кол-во баров во фрактале
extern   int      iIndent = 3;         // отступ от тени бара, на котором размещается стоплосс
extern   bool     bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ФРАКТАЛАМ                                            |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| таймфрейм, по фракталам которого производится трейлинг, кол-во   |
//| баров в фрактале, отступ от экстремума (пунктов) при размещении  |
//| стоплосса, а также следует ли тралить в зоне убытков (bTrlinloss)|
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
   TrailingByFractals(iTicket,iTmfrm,iFrktl_bars,iIndent,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByFractals(int ticket,int tmfrm,int frktl_bars,int indent,bool trlinloss)
   {
   int i, z; // counters
   int extr_n; // номер ближайшего экстремума frktl_bars-барного фрактала 
   double temp; // служебная переменная
   int after_x, be4_x; // свечей после и до пика соответственно
   int ok_be4, ok_after; // флаги соответствия условию (1 - неправильно, 0 - правильно)
   int sell_peak_n, buy_peak_n; // номера экстремумов ближайших фракталов на продажу (для поджатия дл.поз.) и покупку соответсвенно   
   
   // проверяем переданные значения
   if ((frktl_bars<=3) || (indent<0) || (ticket==0) || ((tmfrm!=1) && (tmfrm!=5) && (tmfrm!=15) && (tmfrm!=30) && (tmfrm!=60) && (tmfrm!=240) && (tmfrm!=1440) && (tmfrm!=10080) && (tmfrm!=43200)) || (!OrderSelect(ticket,SELECT_BY_TICKET)))
      {
      Print("Трейлинг функцией TrailingByFractals() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      } 
   
   temp = frktl_bars;
      
   if (MathMod(frktl_bars,2)==0)
   extr_n = temp/2;
   else                
   extr_n = MathRound(temp/2);
      
   // баров до и после экстремума фрактала
   after_x = frktl_bars - extr_n;
   if (MathMod(frktl_bars,2)!=0)
   be4_x = frktl_bars - extr_n;
   else
   be4_x = frktl_bars - extr_n - 1;    
   
   // если длинная позиция (OP_BUY), находим ближайший фрактал на продажу (т.е. экстремум "вниз")
   if (OrderType()==OP_BUY)
      {
      // находим последний фрактал на продажу
      for (i=extr_n;i<iBars(Symbol(),tmfrm);i++)
         {
         ok_be4 = 0; ok_after = 0;
         
         for (z=1;z<=be4_x;z++)
            {
            if (iLow(Symbol(),tmfrm,i)>=iLow(Symbol(),tmfrm,i-z)) 
               {
               ok_be4 = 1;
               break;
               }
            }
            
         for (z=1;z<=after_x;z++)
            {
            if (iLow(Symbol(),tmfrm,i)>iLow(Symbol(),tmfrm,i+z)) 
               {
               ok_after = 1;
               break;
               }
            }            
         
         if ((ok_be4==0) && (ok_after==0))                
            {
            sell_peak_n = i; 
            break;
            }
         }
     
      // если тралить в убытке
      if (trlinloss==true)
         {
         // если новый стоплосс лучше имеющегося (в т.ч. если стоплосс == 0, не выставлен)
         // а также если курс не слишком близко, ну и если стоплосс уже не был перемещен на рассматриваемый уровень         
         if ((iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point>OrderStopLoss()) && (iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      // если тралить только в профите, то
      else
         {
         // если новый стоплосс лучше имеющегося И курса открытия, а также не слишком близко к текущему курсу
         if ((iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point>OrderStopLoss()) && (iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point>OrderOpenPrice()) && (iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),iLow(Symbol(),tmfrm,sell_peak_n)-indent*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }
      
   // если короткая позиция (OP_SELL), находим ближайший фрактал на покупку (т.е. экстремум "вверх")
   if (OrderType()==OP_SELL)
      {
      // находим последний фрактал на продажу
      for (i=extr_n;i<iBars(Symbol(),tmfrm);i++)
         {
         ok_be4 = 0; ok_after = 0;
         
         for (z=1;z<=be4_x;z++)
            {
            if (iHigh(Symbol(),tmfrm,i)<=iHigh(Symbol(),tmfrm,i-z)) 
               {
               ok_be4 = 1;
               break;
               }
            }
            
         for (z=1;z<=after_x;z++)
            {
            if (iHigh(Symbol(),tmfrm,i)<iHigh(Symbol(),tmfrm,i+z)) 
               {
               ok_after = 1;
               break;
               }
            }            
         
         if ((ok_be4==0) && (ok_after==0))                
            {
            buy_peak_n = i;
            break;
            }
         }        
      
      // если тралить в убытке
      if (trlinloss==true)
         {
         if (((iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point<OrderStopLoss()) || (OrderStopLoss()==0)) && (iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }      
      // если тралить только в профите, то
      else
         {
         // если новый стоплосс лучше имеющегося И курса открытия
         if ((((iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point<OrderStopLoss()) || (OrderStopLoss()==0))) && (iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point<OrderOpenPrice()) && (iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),iHigh(Symbol(),tmfrm,buy_peak_n)+(indent+MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }      
   }
//+------------------------------------------------------------------+