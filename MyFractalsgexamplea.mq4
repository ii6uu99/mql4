//+------------------------------------------------------------------+
//|                                                   MyFractals.mq4 |
//|                                                              I_D |
//|             ���� ��� ���������� ���������: http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D / ���� ������"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

#define magic 3904900
// ����������� ���������� ������� ��� ��������� ����� ���������
// ������ ������ ������� - ��. ����� � ����� ����
#import "TrailingAll_11.ex4"
   void TrailingByShadows(int ticket,int tmfrm,int bars_n, int indent,bool trlinloss);
   void TrailingByFractals(int ticket,int tmfrm,int frktl_bars,int indent,bool trlinloss);   
   void TrailingStairs(int ticket,int trldistance,int trlstep);   
   void TrailingUdavka(int ticket,int trl_dist_1,int level_1,int trl_dist_2,int level_2,int trl_dist_3);
   void TrailingByTime(int ticket,int interval,int trlstep,bool trlinloss);   
   void TrailingByATR(int ticket,int atr_timeframe,int atr1_period,int atr1_shift,int atr2_period,int atr2_shift,double coeff,bool trlinloss);
   void TrailingRatchetB(int ticket,int pf_level_1,int pf_level_2,int pf_level_3,int ls_level_1,int ls_level_2,int ls_level_3,bool trlinloss);  
   void TrailingByPriceChannel(int iTicket,int iBars_n,int iIndent);
   void TrailingByMA(int iTicket,int iTmFrme,int iMAPeriod,int iMAShift,int MAMethod,int iApplPrice,int iShift,int iIndent);
   void TrailingFiftyFifty(int iTicket,int iTmFrme,double dCoeff,bool bTrlinloss); 
   void KillLoss(int iTicket,double dSpeedCoeff);   
#import

//---- input parameters
extern int        iTrlBars = 5;   
static datetime   dPrevtime = 0;


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
   {
   if (Bars<100)  {  Print("There are less than 100 bars (",Bars," on the chart. Traiding is not allowed.");   return(0);}
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
   if (dPrevtime == Time[0]) 
      return(0);
   else
      {
      // ������������ ������ ��� � ������
      dPrevtime = Time[0];
      
      // ����������:
      int i;
      double lastbuyhigh;
      double lastbuystop;
      double lastselllow;
      double lastsellstop;
      int buys, sells; // pending orders
      int allopens; // open orders
      
      // ������� ��������� �������� �� ������� (��������� - �����) � �� ������� (��������� - ����)
      // ������� �� �������
      for(i=1;i<Bars;i++)
         {         
         if ((High[i]<High[i+1]) && (High[i+1]>=High[i+2]) && (High[i+1]>=High[i+3]))         
            {
            lastbuyhigh = High[i+1] + (3 + MarketInfo(Symbol(),MODE_SPREAD))*Point;   
            lastbuystop = Low[iLowest(Symbol(),0,1,4,i)] - 1*Point;
            break;
            }
         }
         
      // ������� �� �������   
      for(i=1;i<Bars;i++)
         {         
         if ((Low[i]>Low[i+1]) && (Low[i+1]<=Low[i+2]) && (Low[i+1]<=Low[i+3]))         
            {
            lastselllow = Low[i+1] - 3*Point;   
            lastsellstop = High[iHighest(Symbol(),0,2,4,i)] + (1+MarketInfo(Symbol(),MODE_SPREAD))*Point;
            break;
            }
         } 
         
      // ���� ��������� ����������� ��� "���������" (��������� - ��� ��������� �� ������� ��� ���� - �� �������)
      // (�������) ��������� ���������� ��������, ��: �) ���� ����������� ���� ���������� - ���������� ��� ���� 
      // �� ��� ������������ ������� ����, �) ���� ����������� ���� ���������� - ���� ���� �� ��� ������������ ����,
      // ���� - �� ������� ���������
      // ��� ������ - ������ ��������� ����� �� ���, � ������� ����������� ����� ����������� ���� ����������
      
      if ((High[1]>=lastbuyhigh) && (Close[1]>=lastbuyhigh))
         {
         // ���� ��� ���� ����� ������ � ������ ������� �����, ������, ����� ����������
         allopens = 0; buys = 0;
         for (i=0;i<OrdersTotal();i++)
            {
            if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if (OrderMagicNumber()!=magic || OrderSymbol()!=Symbol()) continue;
            if (OrderType()==OP_BUYSTOP)
               {             
               if ((High[1]+(3+MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderOpenPrice())
               OrderModify(OrderTicket(),High[1]+(3+MarketInfo(Symbol(),MODE_SPREAD))*Point,lastbuystop,0,0,Red);               
               buys++;            
               }
            if (OrderType()==OP_BUY) allopens++;
            }
         // ���� ���������==0, ����������         
         if ((buys==0) && (allopens==0))
            {                     
            if (OrderSend(Symbol(),OP_BUYSTOP,0.1,High[1]+(3+MarketInfo(Symbol(),MODE_SPREAD))*Point,3,High[1]-(50+MarketInfo(Symbol(),MODE_SPREAD))*Point,0,NULL,magic,0,Red)<0)
            Print("Failed to send buy stop order. Err: ",GetLastError());
            }
         }
         
      if ((Low[1]<=lastselllow) && (Close[1]<=lastselllow))
         {
         // ���� ��� ���� ����� ������ � ������ ������� �����, ������, ����� ����������
         allopens = 0; sells = 0;
         for (i=0;i<OrdersTotal();i++)
            {
            if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if (OrderMagicNumber()!=magic || OrderSymbol()!=Symbol()) continue;
            if (OrderType()==OP_SELLSTOP)
               {             
               if ((Low[1]-3*Point)>OrderOpenPrice())
               OrderModify(OrderTicket(),Low[1]-3*Point,lastsellstop,0,0,Blue);
               sells++;            
               }
            if (OrderType()==OP_SELL) allopens++;
            }
         // ���� ���������==0, ����������         
         if ((sells==0) && (allopens==0))
            {
            if (!OrderSend(Symbol(),OP_SELLSTOP,0.1,Low[1]-3*Point,3,Low[1]+50*Point,0,NULL,magic,0,Blue)<0)
            Print("Failed to send sell stop order. Err: ",GetLastError());
            }
         }         
         
      // �������� �� �������� ���� (1 ��� / ���)
     for (i=0;i<OrdersTotal();i++)
         {
         if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
         if (OrderMagicNumber()!=magic || OrderSymbol()!=Symbol()) continue;
         if ((OrderType()==OP_BUY) || (OrderType()==OP_SELL))
            {
            // !!! ������ ������ ������� ��������� !!!
            // !!! ������ ������ ������� ��������� !!!
            // !!! ������ ������ ������� ��������� !!!
            // ����� ��������� ��������� ��, ��������, ������� �������� �� ���������. ����������� �� 
            // 5-������ ��������� �� �������, � �������� �� ���������� � 3 �., � ���� ������ �� ������
            TrailingByFractals(OrderTicket(),1440,5,3,false);
            // (��� �����, ���������� �������������� ������� ����� OrderSelect() � ������� �������, 
            // ������� �� ����� ������� � ��������� ����������� ���������).
            // ��� ������� �� ������ ��������������� ������ ��� ��������� � ���������� ����� ������ 
            // ��� ���� "���������������" �� ��� ����� ��� ����� ������� �����������.            
            //TrailingByShadows(OrderTicket(),60,iTrlBars,3,true);            
            //TrailingRatchetB(OrderTicket(),10,25,30,10,25,30,false);
            //TrailingStairs(OrderTicket(),50,10);  
            //TrailingByATR(OrderTicket(),1440,5,1,20,1,1,false); 
            // � �.�.       
            }
         }
      }                   
   return(0);
   }
//+------------------------------------------------------------------+