//+------------------------------------------------------------------+
//|                                           TrailingFiftyFifty.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iTmFrme = 60;        // период чарта, по барам которого происходит поджатие
extern   double   dCoeff = 0.5;        // "коэффициент поджатия", в % от 0.01 до 1 
extern   bool     bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

static datetime sdtPrevtime = 0;
 
//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ "ПОЛОВИНЯЩИЙ"                                           |
//| По закрытии очередного периода (бара) подтягиваем стоплосс на    |
//| половину (но можно и любой иной коэффициент) дистанции, прой-    |
//| денной курсом (т.е., например, по закрытии суток профит +55 п. - |
//| стоплосс переносим в 55/2=27 п. Если по закрытии след.           |
//| суток профит достиг, допустим, +80 п., то стоплосс переносим на  |
//| половину (напр.) расстояния между тек. стоплоссом и курсом на    |
//| закрытии бара - 27 + (80-27)/2 = 27 + 53/2 = 27 + 26 = 53 п.     |
//| При запуске эксперта ему необходимо указать уникальный номер     |
//| (тикет) открытой позиции (iTicket); iTmFrme - таймфрейм (в       |
//| минутах, цифрами dCoeff - "коэффициент поджатия", в % от 0.01 до |
//| 1 (в последнем случае стоплосс будет перенесен (если получится)  |
//| вплотную к тек. курсу и позиция, скорее всего, сразу же          |
//| закроется) bTrlinloss - стоит ли тралить на лоссовом участке -   |
//| если да, то по закрытию очередного бара расстояние между         |
//| стоплоссом (в т.ч. "до" безубытка) и текущим курсом будет        |
//| сокращаться в dCoeff раз чтобы посл. вариант работал, обязательно| 
//| должен быть определён  cтоплосс (не равен 0)                     |
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
   TrailingFiftyFifty(iTicket,iTmFrme,dCoeff,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingFiftyFifty(int iTicket,int iTmFrme,double dCoeff,bool bTrlinloss)
   { 
   // активируем трейлинг только по закрытии бара
   if (sdtPrevtime == iTime(Symbol(),iTmFrme,0)) return(0);
   else
      {
      sdtPrevtime = iTime(Symbol(),iTmFrme,0);             
      
      // проверяем переданные значения
      if ((iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)) || 
      ((iTmFrme!=1) && (iTmFrme!=5) && (iTmFrme!=15) && (iTmFrme!=30) && (iTmFrme!=60) && (iTmFrme!=240) && 
      (iTmFrme!=1440) && (iTmFrme!=10080) && (iTmFrme!=43200)) || (dCoeff<0.01) || (dCoeff>1.0))
         {
         Print("Трейлинг функцией TrailingFiftyFifty() невозможен из-за некорректности значений переданных ей аргументов.");
         return(0);
         }
         
      // начинаем тралить - с первого бара после открывающего (иначе при bTrlinloss сразу же после открытия 
      // позиции стоплосс будет перенесен на половину расстояния между стоплоссом и курсом открытия)
      // т.е. работаем только при условии, что с момента OrderOpenTime() прошло не менее iTmFrme минут
      if (iTime(Symbol(),iTmFrme,0)>OrderOpenTime())
      {         
      
      double dBid = MarketInfo(Symbol(),MODE_BID);
      double dAsk = MarketInfo(Symbol(),MODE_ASK);
      double dNewSl;
      double dNexMove;     
      
      // для длинной позиции переносим стоплосс на dCoeff дистанции от курса открытия до Bid на момент открытия бара
      // (если такой стоплосс лучше имеющегося и изменяет стоплосс в сторону профита)
      if (OrderType()==OP_BUY)
         {
         if ((bTrlinloss) && (OrderStopLoss()!=0))
            {
            dNexMove = NormalizeDouble(dCoeff*(dBid-OrderStopLoss()),Digits);
            dNewSl = NormalizeDouble(OrderStopLoss()+dNexMove,Digits);            
            }
         else
            {
            // если стоплосс ниже курса открытия, то тралим "от курса открытия"
            if (OrderOpenPrice()>OrderStopLoss())
               {
               dNexMove = NormalizeDouble(dCoeff*(dBid-OrderOpenPrice()),Digits);                 
               //Print("dNexMove = ",dCoeff,"*(",dBid,"-",OrderOpenPrice(),")");
               dNewSl = NormalizeDouble(OrderOpenPrice()+dNexMove,Digits);
               //Print("dNewSl = ",OrderOpenPrice(),"+",dNexMove);
               }
         
            // если стоплосс выше курса открытия, тралим от стоплосса
            if (OrderStopLoss()>=OrderOpenPrice())
               {
               dNexMove = NormalizeDouble(dCoeff*(dBid-OrderStopLoss()),Digits);
               dNewSl = NormalizeDouble(OrderStopLoss()+dNexMove,Digits);
               }                                      
            }
            
         // стоплосс перемещаем только в случае, если новый стоплосс лучше текущего и если смещение - в сторону профита
         // (при первом поджатии, от курса открытия, новый стоплосс может быть лучше имеющегося, и в то же время ниже 
         // курса открытия (если dBid ниже последнего) 
         if ((dNewSl>OrderStopLoss()) && (dNexMove>0) && ((dNewSl<Bid- MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)))
            {
            if (!OrderModify(OrderTicket(),OrderOpenPrice(),dNewSl,OrderTakeProfit(),OrderExpiration(),Red))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }       
      
      // действия для короткой позиции   
      if (OrderType()==OP_SELL)
         {
         if ((bTrlinloss) && (OrderStopLoss()!=0))
            {
            dNexMove = NormalizeDouble(dCoeff*(OrderStopLoss()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);
            dNewSl = NormalizeDouble(OrderStopLoss()-dNexMove,Digits);            
            }
         else
            {         
            // если стоплосс выше курса открытия, то тралим "от курса открытия"
            if (OrderOpenPrice()<OrderStopLoss())
               {
               dNexMove = NormalizeDouble(dCoeff*(OrderOpenPrice()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);                 
               dNewSl = NormalizeDouble(OrderOpenPrice()-dNexMove,Digits);
               }
         
            // если стоплосс нижу курса открытия, тралим от стоплосса
            if (OrderStopLoss()<=OrderOpenPrice())
               {
               dNexMove = NormalizeDouble(dCoeff*(OrderStopLoss()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);
               dNewSl = NormalizeDouble(OrderStopLoss()-dNexMove,Digits);
               }                  
            }
         
         // стоплосс перемещаем только в случае, если новый стоплосс лучше текущего и если смещение - в сторону профита
         if ((dNewSl<OrderStopLoss()) && (dNexMove>0) && (dNewSl>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(OrderTicket(),OrderOpenPrice(),dNewSl,OrderTakeProfit(),OrderExpiration(),Blue))
            Print("Не удалось модифицировать стоплосс ордера №",OrderTicket(),". Ошибка: ",GetLastError());
            }
         }               
      }
      }   
   }
//+------------------------------------------------------------------+