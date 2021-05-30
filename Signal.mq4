//+------------------------------------------------------------------+
//|                                                       Signal.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+

//������� �������� �������� �������� �� ���������� ���������� OsMA
//��������� ������� � �������� #include <Signal.mqh>
//������� if(GetSignal()==1) ��� �������
//������� if(GetSignal()==-1) ��� �������
  
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"
 
extern int fast_ema_period = 10;//������ ���������� ��� ���������� ������� ���������� �������.
extern int slow_ema_period = 12;//������ ���������� ��� ���������� ��������� ���������� �������.
extern int   signal_period = 11;//������ ���������� ��� ���������� ���������� �����.
extern int   applied_price = 5;// 0-6  ������������ ����.
extern int          shift0 = 18;//������ ����������� �������� �� ������������� ������ (����� ������������ �������� ���� �� ��������� ���������� �������� �����).
extern int          shift1 = 20;//������ ����������� �������� �� ������������� ������ (����� ������������ �������� ���� �� ��������� ���������� �������� �����).
extern int          shift2 = 0;//������ ����������� �������� �� ������������� ������ (����� ������������ �������� ���� �� ��������� ���������� �������� �����).
extern int          shift3 = 11;//������ ����������� �������� �� ������������� ������ (����� ������������ �������� ���� �� ��������� ���������� �������� �����).

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