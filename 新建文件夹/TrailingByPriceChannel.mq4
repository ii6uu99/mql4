//+------------------------------------------------------------------+
//|                                       TrailingByPriceChannel.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iBars_n = 20;        // кол-во баров текущего графика, по которым строится ценовой канал
extern   int      iIndent = 3;         // отступ от тени бара, на котором размещается стоплосс

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ЦЕНВОМУ КАНАЛУ                                       |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| кол-во баров, среди которых (как при трейлинге по теням) опреде- |
//| ляется наиболее удалённый (лоу для нижней границы, хай - для     |
//| верхней), а также отступ в пунктах от границы при размещении     |
//| стоплосса.                                                       |
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
   TrailingByPriceChannel(iTicket,iBars_n,iIndent);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByPriceChannel(int iTicket,int iBars_n,int iIndent)
   {     
   
   // проверяем переданные значения
   if ((iBars_n<1) || (iIndent<0) || (iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)))
      {
      Print("Трейлинг функцией TrailingByPriceChannel() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      } 
   
   double   dChnl_max; // верхняя граница канала
   double   dChnl_min; // нижняя граница канала
   
   // определяем макс.хай и мин.лоу за iBars_n баров начиная с [1] (= верхняя и нижняя границы ценового канала)
   dChnl_max = High[iHighest(Symbol(),0,2,iBars_n,1)] + (iIndent+MarketInfo(Symbol(),MODE_SPREAD))*Point;
   dChnl_min = Low[iLowest(Symbol(),0,1,iBars_n,1)] - iIndent*Point;   
   
   // если длинная позиция, и её стоплосс хуже (ниже нижней границы канала либо не определен, ==0), модифицируем его
   if (OrderType()==OP_BUY)
      {
      if ((OrderStopLoss()<dChnl_min) && (dChnl_min<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dChnl_min,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
   
   // если позиция - короткая, и её стоплосс хуже (выше верхней границы канала или не определён, ==0), модифицируем его
   if (OrderType()==OP_SELL)
      {
      if (((OrderStopLoss()==0) || (OrderStopLoss()>dChnl_max)) && (dChnl_min>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dChnl_max,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
   }
//+------------------------------------------------------------------+