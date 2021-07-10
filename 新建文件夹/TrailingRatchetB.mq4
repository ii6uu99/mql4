//+------------------------------------------------------------------+
//|                                             TrailingRatchetB.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ Софт для управления капиталом"

extern   int      iTicket;             // уникальный номер (тикет) открытой позиции
extern   int      iPf_level_1 = 10;    // уровень профита (пунктов), при котором стоплосс переносим в безубыток + 1 пункт;
extern   int      iPf_level_2 = 20;    // уровень профита (пунктов), при котором стоплосс переносим с +1 на расстояние pf_level_1 пунктов от курса открытия;
extern   int      iPf_level_3 = 30;    // уровень профита (пунктов), при котором стоплосс переносим с pf_level_1 на pf_level_2 пунктов от курса открытия (на этом действия функции заканчиваются);
extern   int      iLs_level_1 = 15;    // расстояние от курса открытия в сторону "лосса", на котором будет установлен стоплосс при достижении профитом позиции +1 (т.е. при +1 стоплосс будет поджат на ls_level_1);
extern   int      iLs_level_2 = 25;    // расстояние от курса открытия в "лоссе", на котором будет установлен стоплосс при условии, что курс сначала опускался ниже ls_level_1, а потом поднялся выше (т.е. имели лосс, но он начал уменьшаться - не допустим его повторного увеличения);
extern   int      iLs_level_3 = 35;    // расстояние от курса открытия "минусе", на котором будет установлен стоплосс при условии, что курс снижался ниже ls_level_2, а потом поднялся выше;
extern   bool     bTrlinloss = false;  // следует ли тралить на участке лоссов (между курсом стоплосса и открытия)

//+------------------------------------------------------------------+
//| ТРЕЙЛИНГ RATCHET БАРИШПОЛЬЦА                                     |
//| При достижении профитом уровня 1 стоплосс - в +1, при достижении |
//| профитом уровня 2 профита - стоплосс - на уровень 1, когда       |
//| профит достигает уровня 3 профита, стоплосс - на уровень 2       |
//| (дальше можно трейлить другими методами)                         |
//| при работе в лоссовом участке - тоже 3 уровня, но схема работы   |
//| с ними несколько иная, а именно: если мы опустились ниже уровня, |
//| а потом поднялись выше него (пример для покупки), то стоплосс    |
//| ставим на следующий, более глубокий уровень (например, уровни    |
//| -5, -10 и -25, стоплосс -40; если опустились ниже -10, а потом   |
//| поднялись выше -10, то стоплосс - на -25, если поднимемся выще   |
//| -5, то стоплосс перенесем на -10, при -2 (спрэд) стоп на -5      |
//| работаем только с одной позицией одновременно. При запуске       |
//| эксперта ему необходимо указать уникальный номер (тикет)         |
//| открытой позиции (iTicket)                                       |
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
   TrailingRatchetB(iTicket,iPf_level_1,iPf_level_2,iPf_level_3,iLs_level_1,iLs_level_2,iLs_level_3,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingRatchetB(int ticket,int pf_level_1,int pf_level_2,int pf_level_3,int ls_level_1,int ls_level_2,int ls_level_3,bool trlinloss)
   {
    
   // проверяем переданные значения
   if ((ticket==0) || (!OrderSelect(ticket,SELECT_BY_TICKET)) || (pf_level_2<=pf_level_1) || (pf_level_3<=pf_level_2) || 
   (pf_level_3<=pf_level_1) || (pf_level_2-pf_level_1<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) || (pf_level_3-pf_level_2<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) ||
   (pf_level_1<=MarketInfo(Symbol(),MODE_STOPLEVEL)))
      {
      Print("Трейлинг функцией TrailingRatchetB() невозможен из-за некорректности значений переданных ей аргументов.");
      return(0);
      }
                
   // если длинная позиция (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      double dBid = MarketInfo(Symbol(),MODE_BID);
      
      // Работаем на участке профитов
      
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_3+спрэд", стоплосс переносим в "pf_level_2+спрэд"
      if ((dBid-OrderOpenPrice())>=pf_level_3*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + pf_level_2 *Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + pf_level_2*Point,OrderTakeProfit(),OrderExpiration());
         }
      else
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_2+спрэд", стоплосс переносим в "pf_level_1+спрэд"
      if ((dBid-OrderOpenPrice())>=pf_level_2*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + pf_level_1*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + pf_level_1*Point,OrderTakeProfit(),OrderExpiration());
         }
      else        
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_1+спрэд", стоплосс переносим в +1 ("открытие + спрэд")
      if ((dBid-OrderOpenPrice())>=pf_level_1*Point)
      // если стоплосс не определен или хуже чем "открытие+1"
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + 1*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + 1*Point,OrderTakeProfit(),OrderExpiration());
         }

      // Работаем на участке лоссов
      if (trlinloss==true)      
         {
         // Глобальная переменная терминала содержит значение самого уровня убытка (ls_level_n), ниже которого опускался курс
         // (если он после этого поднимается выше, устанавливаем стоплосс на ближайшем более глубоком уровне убытка (если это не начальный стоплосс позиции)
         // Создаём глобальную переменную (один раз)
         if(!GlobalVariableCheck("zeticket")) 
            {
            GlobalVariableSet("zeticket",ticket);
            // при создании присвоим ей "0"
            GlobalVariableSet("dpstlslvl",0);
            }
         // если работаем с новой сделкой (новый тикет), затираем значение dpstlslvl
         if (GlobalVariableGet("zeticket")!=ticket)
            {
            GlobalVariableSet("dpstlslvl",0);
            GlobalVariableSet("zeticket",ticket);
            }
      
         // убыточным считаем участок ниже курса открытия и до первого уровня профита
         if ((dBid-OrderOpenPrice())<pf_level_1*Point)         
            {
            // если (текущий_курс лучше/равно открытие) и (dpstlslvl>=ls_level_1), стоплосс - на ls_level_1
            if (dBid>=OrderOpenPrice()) 
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_1*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_1*Point,OrderTakeProfit(),OrderExpiration());
      
            // если (текущий_курс лучше уровня_убытка_1) и (dpstlslvl>=ls_level_1), стоплосс - на ls_level_2
            if ((dBid>=OrderOpenPrice()-ls_level_1*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_1))
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_2*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_2*Point,OrderTakeProfit(),OrderExpiration());
      
            // если (текущий_курс лучше уровня_убытка_2) и (dpstlslvl>=ls_level_2), стоплосс - на ls_level_3
            if ((dBid>=OrderOpenPrice()-ls_level_2*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_2))
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_3*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_3*Point,OrderTakeProfit(),OrderExpiration());
      
            // проверим/обновим значение наиболее глубокой "взятой" лоссовой "ступеньки"
            // если "текущий_курс-курс открытия+спрэд" меньше 0, 
            if ((dBid-OrderOpenPrice()+MarketInfo(Symbol(),MODE_SPREAD)*Point)<0)
            // проверим, не меньше ли он того или иного уровня убытка
               {
               if (dBid<=OrderOpenPrice()-ls_level_3*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_3)
               GlobalVariableSet("dpstlslvl",ls_level_3);
               else
               if (dBid<=OrderOpenPrice()-ls_level_2*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_2)
               GlobalVariableSet("dpstlslvl",ls_level_2);   
               else
               if (dBid<=OrderOpenPrice()-ls_level_1*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_1)
               GlobalVariableSet("dpstlslvl",ls_level_1);
               }
            } // end of "if ((dBid-OrderOpenPrice())<pf_level_1*Point)"
         } // end of "if (trlinloss==true)"
      }
      
   // если короткая позиция (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      double dAsk = MarketInfo(Symbol(),MODE_ASK);
      
      // Работаем на участке профитов
      
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_3+спрэд", стоплосс переносим в "pf_level_2+спрэд"
      if ((OrderOpenPrice()-dAsk)>=pf_level_3*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (pf_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (pf_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }
      else
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_2+спрэд", стоплосс переносим в "pf_level_1+спрэд"
      if ((OrderOpenPrice()-dAsk)>=pf_level_2*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (pf_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (pf_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }
      else        
      // если разница "текущий_курс-курс_открытия" больше чем "pf_level_1+спрэд", стоплосс переносим в +1 ("открытие + спрэд")
      if ((OrderOpenPrice()-dAsk)>=pf_level_1*Point)
      // если стоплосс не определен или хуже чем "открытие+1"
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (1 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }

      // Работаем на участке лоссов
      if (trlinloss==true)      
         {
         // Глобальная переменная терминала содержит значение самого уровня убытка (ls_level_n), ниже которого опускался курс
         // (если он после этого поднимается выше, устанавливаем стоплосс на ближайшем более глубоком уровне убытка (если это не начальный стоплосс позиции)
         // Создаём глобальную переменную (один раз)
         if(!GlobalVariableCheck("zeticket")) 
            {
            GlobalVariableSet("zeticket",ticket);
            // при создании присвоим ей "0"
            GlobalVariableSet("dpstlslvl",0);
            }
         // если работаем с новой сделкой (новый тикет), затираем значение dpstlslvl
         if (GlobalVariableGet("zeticket")!=ticket)
            {
            GlobalVariableSet("dpstlslvl",0);
            GlobalVariableSet("zeticket",ticket);
            }
      
         // убыточным считаем участок ниже курса открытия и до первого уровня профита
         if ((OrderOpenPrice()-dAsk)<pf_level_1*Point)         
            {
            // если (текущий_курс лучше/равно открытие) и (dpstlslvl>=ls_level_1), стоплосс - на ls_level_1
            if (dAsk<=OrderOpenPrice()) 
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // если (текущий_курс лучше уровня_убытка_1) и (dpstlslvl>=ls_level_1), стоплосс - на ls_level_2
            if ((dAsk<=OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_1))
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // если (текущий_курс лучше уровня_убытка_2) и (dpstlslvl>=ls_level_2), стоплосс - на ls_level_3
            if ((dAsk<=OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_2))
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_3 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_3 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // проверим/обновим значение наиболее глубокой "взятой" лоссовой "ступеньки"
            // если "текущий_курс-курс открытия+спрэд" меньше 0, 
            if ((OrderOpenPrice()-dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)<0)
            // проверим, не меньше ли он того или иного уровня убытка
               {
               if (dAsk>=OrderOpenPrice()+(ls_level_3+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_3)
               GlobalVariableSet("dpstlslvl",ls_level_3);
               else
               if (dAsk>=OrderOpenPrice()+(ls_level_2+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_2)
               GlobalVariableSet("dpstlslvl",ls_level_2);   
               else
               if (dAsk>=OrderOpenPrice()+(ls_level_1+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_1)
               GlobalVariableSet("dpstlslvl",ls_level_1);
               }
            } // end of "if ((dBid-OrderOpenPrice())<pf_level_1*Point)"
         } // end of "if (trlinloss==true)"
      }      
   }
//+------------------------------------------------------------------+