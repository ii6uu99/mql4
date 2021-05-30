//+------------------------------------------------------------------+
//|                                                       Signal.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+

//‘ункци€ торговых сигналов основана на показани€х индикатора OsMA
//ƒобовл€ем функцию в советник #include <Signal.mqh>
//”словие if(GetSignal()==1) дл€ покупки
//”словие if(GetSignal()==-1) дл€ продажи
  
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"
 
extern int fast_ema_period = 10;//ѕериод усреднени€ дл€ вычислени€ быстрой скольз€щей средней.
extern int slow_ema_period = 12;//ѕериод усреднени€ дл€ вычислени€ медленной скольз€щей средней.
extern int   signal_period = 11;//ѕериод усреднени€ дл€ вычислени€ сигнальной линии.
extern int   applied_price = 5;// 0-6  »спользуема€ цена.
extern int          shift0 = 18;//»ндекс получаемого значени€ из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад).
extern int          shift1 = 20;//»ндекс получаемого значени€ из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад).
extern int          shift2 = 0;//»ндекс получаемого значени€ из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад).
extern int          shift3 = 11;//»ндекс получаемого значени€ из индикаторного буфера (сдвиг относительно текущего бара на указанное количество периодов назад).

//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
 int GetSignal()
   {
    
	  double x0 = iOsMA(NULL,0,fast_ema_period,slow_ema_period,signal_period,applied_price,shift0);
     double x1 = iOsMA(NULL,0,fast_ema_period,slow_ema_period,signal_period,applied_price,shift1);
     double x2 = iOsMA(NULL,0,fast_ema_period,slow_ema_period,signal_period,applied_price,shift2);
     double x3 = iOsMA(NULL,0,fast_ema_period,slow_ema_period,signal_period,applied_price,shift3);
     
    int vSignal = 0;
    if (x3>x2 && x2<x1 && x1<x0)vSignal = 1;//up 
    else
    if (x3<x2 && x2>x1 && x1>x0) vSignal =-1;//down

    
    return (vSignal);
   } 
//+------------------------------------------------------------------+