//+------------------------------------------------------------------+
//|                                                     KillLoss.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   double   dSpeedCoeff = 1;     // коэффициент усиления, определяющий, как быстро движется стоплосс навстречу курсу в зоне лоссов

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ KillLoss                                                |
//| Применяется на участке лоссов. Суть: стоплосс движется навстречу |
//| курсу со скоростью движения курса х коэффициент (dSpeedCoeff).   |
//| При этом коэффициент можно "привязать" к скорости увеличения     |
//| убытка - так, чтобы при быстром росте лосса потерять меньше. При |
//| коэффициенте = 1 стоплосс сработает ровно посредине между уров-  |
//| нем стоплосса и курсом на момент запуска функции, при коэфф.>1   |
//| точка встречи курса и стоплосса будет смещена в сторону исход-   |
//| ного положения курса, при коэфф.<1 - наоборот, ближе к исходно-  |
//| му стоплоссу.                                                    |
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
   KillLoss(iTicket,dSpeedCoeff);
   return(0);
  }
//+------------------------------------------------------------------+

void KillLoss(int iTicket,double dSpeedCoeff)
   {   
   // проверяем переданные значения
   if ((iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)) || (dSpeedCoeff<0.1))
      {
      Print("Трейлинг функцией KillLoss() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      }           
      
   double dStopPriceDiff; // расстояние (пунктов) между курсом и стоплоссом   
   double dToMove; // кол-во пунктов, на которое следует переместить стоплосс   
   // текущий курс
   double dBid = MarketInfo(OrderSymbol(),MODE_BID);
   double dAsk = MarketInfo(OrderSymbol(),MODE_ASK);      
   
   // текущее расстояние между курсом и стоплоссом
   if (OrderType()==OP_BUY) dStopPriceDiff = dBid - OrderStopLoss();
   if (OrderType()==OP_SELL) dStopPriceDiff = (OrderStopLoss() + MarketInfo(OrderSymbol(),MODE_SPREAD)*MarketInfo(OrderSymbol(),MODE_POINT)) - dAsk;                  
   
   // проверяем, если тикет != тикету, с которым работали раньше, запоминаем текущее расстояние между курсом и стоплоссом
   if (GlobalVariableGet("zeticket")!=iTicket)
      {
      GlobalVariableSet("sldiff",dStopPriceDiff);      
      GlobalVariableSet("zeticket",iTicket);
      }
   else
      {                                   
      // итак, у нас есть коэффициент ускорения изменения курса
      // на каждый пункт, который проходит курс в сторону лосса, 
      // мы должны переместить стоплосс ему на встречу на dSpeedCoeff раз пунктов
      // (например, если лосс увеличился на 3 пункта за тик, dSpeedCoeff = 1.5, то
      // стоплосс подтягиваем на 3 х 1.5 = 4.5, округляем - 5 п. Если подтянуть не 
      // удаётся (слишком близко), ничего не делаем.            
      
      // кол-во пунктов, на которое приблизился курс к стоплоссу с момента предыдущей проверки (тика, по идее)
      dToMove = (GlobalVariableGet("sldiff") - dStopPriceDiff) / MarketInfo(OrderSymbol(),MODE_POINT);
      
      // записываем новое значение, но только если оно уменьшилось
      if (dStopPriceDiff<GlobalVariableGet("sldiff"))
      GlobalVariableSet("sldiff",dStopPriceDiff);
      
      // дальше действия на случай, если расстояние уменьшилось (т.е. курс приблизился к стоплоссу, убыток растет)
      if (dToMove>0)
         {       
         // стоплосс, соответственно, нужно также передвинуть на такое же расстояние, но с учетом коэфф. ускорения
         dToMove = MathRound(dToMove * dSpeedCoeff) * MarketInfo(OrderSymbol(),MODE_POINT);                 
      
         // теперь проверим, можем ли мы подтянуть стоплосс на такое расстояние
         if (OrderType()==OP_BUY)
            {
            if (dBid - (OrderStopLoss() + dToMove)>MarketInfo(OrderSymbol(),MODE_STOPLEVEL)* MarketInfo(OrderSymbol(),MODE_POINT))
            OrderModify(iTicket,OrderOpenPrice(),OrderStopLoss() + dToMove,OrderTakeProfit(),OrderExpiration());            
            }
         if (OrderType()==OP_SELL)
            {
            if ((OrderStopLoss() - dToMove) - dAsk>MarketInfo(OrderSymbol(),MODE_STOPLEVEL) * MarketInfo(OrderSymbol(),MODE_POINT))
            OrderModify(iTicket,OrderOpenPrice(),OrderStopLoss() - dToMove,OrderTakeProfit(),OrderExpiration());
            }      
         }
      }            
   }
   
//+------------------------------------------------------------------+   