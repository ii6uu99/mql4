/*
https://www.mql5.com/en/code/8556


该函数根据指定的可用资产百分比 (х%) 自动计算手数或使用固定手数（“х”不带“%”符号）。

我们将函数 添加 #include <Lot_Volume.mqh> 到程序并在必要的地方调用它： OrderSend(Symbol, Order Type, Lot_Volume(), Price, 0, Stop, Profit);

例如，如果您指定“10%”，那么手数将等于免费资产的 10%，如果您只指定“10”，那么手数将等于 10 手。

当然，该库并不完美，我等待您的评论。


*/




//泽黻鲨 疣聍弪?疣珈屦?铕溴疣 ?玎忤耔祛耱?铗 箨噻囗眍泐 % 疋钺钿睇?耩邃耱?
extern string Lots;
double Lot_Volume()
   {
   if (StringSubstr(Lots, StringLen(Lots)-1, StringLen(Lots)) == "%")
      {
      double step = MarketInfo(Symbol(),MODE_LOTSTEP);
      double Lots1 = NormalizeDouble(StrToDouble(StringSubstr(Lots, StringLen(0), StringLen(Lots)-1)),1);
      double Lots2 = NormalizeDouble(((AccountFreeMargin()*(Lots1/100)/MarketInfo(Symbol(),MODE_MARGINREQUIRED)/step)*step),1);
      }  
   else if (StringSubstr(Lots, StringLen(Lots)-1, StringLen(Lots)) != "%")
      Lots2 = NormalizeDouble(StrToDouble(Lots),1);
      
   if (Lots2<MarketInfo(Symbol(),MODE_MINLOT))
      {
         Lots2 = MarketInfo(Symbol(),MODE_MINLOT);
         Alert ("朽珈屦 腩蜞 铟屙?爨? 玉蜞眍怆屙 扈龛爨朦睇?疣珈屦! ", Lots1);
      }
   return(Lots2);
   }