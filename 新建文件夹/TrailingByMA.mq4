//+------------------------------------------------------------------+
//|                                           TrailingByFractals.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iTmfrm;              // период графика, на котором строится МА (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int      iMAPeriod = 21;      // период МА (не меньше 2)
extern   int      iMAShift = 0;        // сдвиг индикатора относительно ценового графика
extern   int      iMAMethod = 0;       // метод усреднения (0 - MODE_SMA, 1 - MODE_EMA, 2 - MODE_SMMA, 3 - MODE_LWMA);
extern   int      iApplPrice = 0;      // используемая цена (0 - PRICE_CLOSE, 1 - PRICE_OPEN, 2 - PRICE_HIGH, 3 - PRICE_LOW, 4 - PRICE_MEDIAN, 5 - PRICE_TYPICAL, 6 - PRICE_WEIGHTED)
extern   int      iShift = 1;          // индекс получаемого значения из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад)
extern   int      iIndent = 3;         // отступ от тени бара, на котором размещается стоплосс

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО СКОЛЬЗЯЩЕМУ СРЕДНЕМУ                                 |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| таймфрейм, на котором строится скользящее среднее, его параметры |
//| (период, сдвиг относительно графика, метод построения, тип цены, |
//| по которой считается, на каком баре считываем значение), а также |
//| отступ (пунктов) от среднего, на котором устанавливается стоплосс|
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
   TrailingByMA(iTicket,iTmfrm,iMAPeriod,iMAShift,iMAMethod,iApplPrice,iShift,iIndent);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByMA(int iTicket,int iTmFrme,int iMAPeriod,int iMAShift,int MAMethod,int iApplPrice,int iShift,int iIndent)
   {     
   
   // проверяем переданные значения
   if ((iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)) || ((iTmFrme!=1) && (iTmFrme!=5) && (iTmFrme!=15) && (iTmFrme!=30) && (iTmFrme!=60) && (iTmFrme!=240) && (iTmFrme!=1440) && (iTmFrme!=10080) && (iTmFrme!=43200)) ||
   (iMAPeriod<2) || (MAMethod<0) || (MAMethod>3) || (iApplPrice<0) || (iApplPrice>6) || (iShift<0) || (iIndent<0))
      {
      Print("Трейлинг функцией TrailingByMA() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      } 

   double   dMA; // значение скользящего среднего с переданными параметрами
   
   // определим значение МА с переданными функции параметрами
   dMA = iMA(Symbol(),iTmFrme,iMAPeriod,iMAShift,MAMethod,iApplPrice,iShift);
         
   // если длинная позиция, и её стоплосс хуже значения среднего с отступом в iIndent пунктов, модифицируем его
   if (OrderType()==OP_BUY)
      {
      if ((OrderStopLoss()<dMA-iIndent*Point) && (dMA-iIndent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dMA-iIndent*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
   
   // если позиция - короткая, и её стоплосс хуже (выше верхней границы канала или не определён, ==0), модифицируем его
   if (OrderType()==OP_SELL)
      {
      if (((OrderStopLoss()==0) || (OrderStopLoss()>dMA+(MarketInfo(Symbol(),MODE_SPREAD)+iIndent)*Point)) && (dMA+(MarketInfo(Symbol(),MODE_SPREAD)+iIndent)*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dMA+(MarketInfo(Symbol(),MODE_SPREAD)+iIndent)*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
   }
//+------------------------------------------------------------------+