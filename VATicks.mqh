//+------------------------------------------------------------------+
//|                                                      VATicks.mqh |
//|                                      Copyright 2016, aka Vitales |
//|                                                avitaly@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, aka Vitales"
#property link      "avitaly@yandex.ru"
#property version   "1.00"
#property strict

#define TREND_BUY            1
#define TREND_SELL           2
#define TREND_NO             0


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class CTick
{
protected:
 double   Value;
 datetime DTime;
 void     SetTime(){DTime = TimeCurrent();}
public:
          CTick();
          ~CTick();
 void     SetTick(double value);
 double   GetTick() {return(Value);}
 datetime GetTime() {return(DTime);}
};

CTick::CTick()
{
}
//+------------------------------------------------------------------+
CTick::~CTick()
{
}
void CTick::SetTick(double value)
{
   if (Value!=value)
   {
     Value = value;
     SetTime();
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTicks
{
private:
   CTick Ticks[];//массив полученных тиков
protected:   
   bool  OutRange(int Start,int End);
public:
          CTicks();
          ~CTicks();
   void   Tick(double BidOrAsk);//учет тиков
   void   Reset(){ArrayFree(Ticks);}//Сброс счетчика тиков
   int    TickCount(){return(ArraySize(Ticks)-1);} //Количество тиков
   double GetTicValue(int index);//цена тика
   int    TickTime(int Start,int End);
   double Speed(int Start,int End);
   double Length(int Start,int End);
   double EstimatedPath(int Start,int End,double V0=0);
   double Acceleration(int Start,int End);
   int    Trend(int Start,int End);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTicks::CTicks()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTicks::~CTicks()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTicks::OutRange(int Start,int End)
{
  if (Start<0 || End>TickCount() || Start>=End || End<0) return(true);
  return(false);
}
//+------------------------------------------------------------------+
//|Учет тиков должна вызываться из OnTick() эксперта                 |
//|                                                                  |
//+------------------------------------------------------------------+
void CTicks::Tick(double BidOrAsk)
{
   int size = ArraySize(Ticks);
   if (size>2147483646)
   {
      Reset();
      size = ArraySize(Ticks);
   }
   if (size>=1) if (BidOrAsk==Ticks[size-1].GetTick()) return;//два подряд тика по одной цене игнорируются
   ArrayResize(Ticks,size+1);
   Ticks[size].SetTick(BidOrAsk);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTicks::GetTicValue(int index)
{
  if (index>ArraySize(Ticks)-1 || index<0) return(-1);
  return(Ticks[index].GetTick()); 
}
//+------------------------------------------------------------------+
//|Время                                                             |
//+------------------------------------------------------------------+

int CTicks::TickTime(int Start,int End)
{
 if (OutRange(Start,End)) return(-1); 
 double res = (double)(Ticks[Start].GetTime()-Ticks[End].GetTime());   
 return((int)MathAbs(res));
}

//+------------------------------------------------------------------+
//|Длина вектора движения цены                                       |
//+------------------------------------------------------------------+
double CTicks::Length(int Start,int End)
{
  if (OutRange(Start,End)) return(-1);
  double res = NormalizeDouble((GetTicValue(Start)-GetTicValue(End))/Point(),Digits());   
  return(MathAbs(res));
}

//+------------------------------------------------------------------+
//|Расчетный путь цены с учетом ускорения                            |
//+------------------------------------------------------------------+
double CTicks::EstimatedPath(int Start,int End,double V0=0)
{
  if (OutRange(Start,End)) return(-1);
  double A = Acceleration(Start,End);
  int T = TickTime(Start,End);
  if (A==0) return(0);
  double res = NormalizeDouble((A*(T*T))/2+V0*T,2);
  return(res);
}

//+------------------------------------------------------------------+
//|Скорость вектора движения цены                                    |
//+------------------------------------------------------------------+
double CTicks::Speed(int Start,int End)
{
  if (OutRange(Start,End)) return(-1);
  return(NormalizeDouble(Length(Start,End)/TickTime(Start,End),Digits()));

}
//+------------------------------------------------------------------+
//|Ускорение вектора движения цены                                   |
//+------------------------------------------------------------------+
double CTicks::Acceleration(int Start,int End)
{
  if (OutRange(Start,End)) return(-1);
  double V = Speed(Start,End);
  int    T = TickTime(Start,End);    
  return(NormalizeDouble(V/T,Digits()));
}

//+------------------------------------------------------------------+
//|Направление вектора движения цены                                 |
//+------------------------------------------------------------------+
int CTicks::Trend(int Start,int End)
{  
  int trend = TREND_NO;
  if (OutRange(Start,End)) return(-1);
  double res = GetTicValue(End)-GetTicValue(Start);   
  if (res>0) trend=TREND_BUY;
  if (res<0) trend=TREND_SELL;
  return(trend);
}

//+------------------------------------------------------------------+
