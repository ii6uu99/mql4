//+------------------------------------------------------------------+
//|                                           TrailingFiftyFifty.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iInterval = 240;     // временной интервал, через который (по возможности) переносится стоплосс, минут
extern   int      iTrlstep = 20;       // шаг трейлинга, пунктов
extern   bool     bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ ПО ВРЕМЕНИ                                              |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции, а также определить параметры трейлинга:|
//| временной интервал (минут), с которым производится перемещение   |
//| стоплосса, шаг стоплосса (пунктов), а также определить, следует  |
//| ли трейлинговать на участке стоплоссов                           |
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
   TrailingByTime(iTicket,iInterval,iTrlstep,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByTime(int ticket,int interval,int trlstep,bool trlinloss)
   {
      
   // проверяем переданные значения
   if ((ticket==0) || (interval<1) || (trlstep<1) || !OrderSelect(ticket,SELECT_BY_TICKET))
      {
      Print("Трейлинг функцией TrailingByTime() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      }
      
   double minpast; // кол-во полных минут от открытия позиции до текущего момента 
   double times2change; // кол-во интервалов interval с момента открытия позиции (т.е. сколько раз должен был быть перемещен стоплосс) 
   double newstop; // новое значение стоплосса (учитывая кол-во переносов, которые должны были иметь место)
   
   // определяем, сколько времени прошло с момента открытия позиции
   minpast = (TimeCurrent() - OrderOpenTime()) / 60;
      
   // сколько раз нужно было передвинуть стоплосс
   times2change = MathFloor(minpast / interval);
         
   // если длинная позиция (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // если тралим в убытке, то отступаем от стоплосса (если он не 0, если 0 - от открытия)
      if (trlinloss==true)
         {
         if (OrderStopLoss()==0) newstop = OrderOpenPrice() + times2change*(trlstep*Point);
         else newstop = OrderStopLoss() + times2change*(trlstep*Point); 
         }
      else
      // иначе - от курса открытия позиции
      newstop = OrderOpenPrice() + times2change*(trlstep*Point); 
         
      if (times2change>0)
         {
         if ((newstop>OrderStopLoss()) && (newstop<Bid- MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }
      
   // если короткая позиция (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      // если тралим в убытке, то отступаем от стоплосса (если он не 0, если 0 - от открытия)
      if (trlinloss==true)
         {
         if (OrderStopLoss()==0) newstop = OrderOpenPrice() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
         else newstop = OrderStopLoss() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
         }
      else
      newstop = OrderOpenPrice() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
                
      if (times2change>0)
         {
         if (((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice())) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         else
         if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      }      
   }
//+------------------------------------------------------------------+