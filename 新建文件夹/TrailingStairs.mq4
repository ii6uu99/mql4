//+------------------------------------------------------------------+
//|                                               TrailingStairs.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iTrldistance = 40;   // расстояние от текущего курса (пунктов), на котором включается трейлинг, пунктов
extern   int      iTrlstep = 10;       // "шаг" изменения стоплосса (пунктов) (не меньше 1)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ СТАНДАРТНЫЙ-СТУПЕНЧАСТЫЙ                                |
//| Советнику передаётся тикет позиции, расстояние от курса открытия,|
//| на котором трейлинг запускается (пунктов) и "шаг", с которым он  |
//| переносится (пунктов)                                            |
//| Пример: при +30 стоп на +10, при +40 - стоп на +20 и т.д.        |
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
   TrailingStairs(iTicket,iTrldistance,iTrlstep);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingStairs(int ticket,int trldistance,int trlstep)
   { 
   
   double nextstair; // ближайшее значение курса, при котором будем менять стоплосс

   // проверяем переданные значения
   if ((trldistance<MarketInfo(Symbol(),MODE_STOPLEVEL)) || (trlstep<1) || (trldistance<trlstep) || (ticket==0) || (!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)))
      {
      Print("Трейлинг функцией TrailingStairs() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      } 
   
   // если длинная позиция (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // расчитываем, при каком значении курса следует скорректировать стоплосс
      // если стоплосс ниже открытия или равен 0 (не выставлен), то ближайший уровень = курс открытия + trldistance + спрэд
      if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice()))
      nextstair = OrderOpenPrice() + trldistance*Point;
         
      // иначе ближайший уровень = текущий стоплосс + trldistance + trlstep + спрэд
      else
      nextstair = OrderStopLoss() + trldistance*Point;

      // если текущий курс (Bid) >= nextstair и новый стоплосс точно лучше текущего, корректируем последний
      if (Bid>=nextstair)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice()) && (OrderOpenPrice() + trlstep*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)) 
            {
            if (!OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + trlstep*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         if (!OrderModify(ticket,OrderOpenPrice(),OrderStopLoss() + trlstep*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }
      
   // если короткая позиция (OP_SELL)
   if (OrderType()==OP_SELL)
      { 
      // расчитываем, при каком значении курса следует скорректировать стоплосс
      // если стоплосс ниже открытия или равен 0 (не выставлен), то ближайший уровень = курс открытия + trldistance + спрэд
      if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice()))
      nextstair = OrderOpenPrice() - (trldistance + MarketInfo(Symbol(),MODE_SPREAD))*Point;
      
      // иначе ближайший уровень = текущий стоплосс + trldistance + trlstep + спрэд
      else
      nextstair = OrderStopLoss() - (trldistance + MarketInfo(Symbol(),MODE_SPREAD))*Point;
       
      // если текущий курс (Аск) >= nextstair и новый стоплосс точно лучше текущего, корректируем последний
      if (Ask<=nextstair)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice()) && (OrderOpenPrice() - (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }
      else
         {
         if (!OrderModify(ticket,OrderOpenPrice(),OrderStopLoss()- (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
         }
      }      
   }
//+------------------------------------------------------------------+