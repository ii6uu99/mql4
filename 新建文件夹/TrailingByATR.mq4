//+------------------------------------------------------------------+
//|                                                TrailingByATR.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/"


extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iAtr_timeframe;      // ������ �������, �� ������� ��������� ATR (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int      iAtr1_period = 5;    // ������ ������� ATR
extern   int      iAtr1_shift = 1;     // ����� ������� ATR
extern   int      iAtr2_period = 36;   // ������ ������� ATR
extern   int      iAtr2_shift = 1;     // ����� ������� ATR
extern   double   dCoeff = 1;          // �����������, �� ������� ������ ATR, ����� �������� �������� (��� coeff=1 ���� ����� �������� �� ���������� � 1 ATR, ��� coeff=1.5 - �� ���������� � ������� ATR � �.�.)
extern   bool     bTrlinloss = false;  // ������� �� ������� �� ������� ������ (����� ������ ��������� � ��������)

//+------------------------------------------------------------------+
//| �������� �� ATR (Average True Range, ������� �������� ��������)  |
//| ��� ������� �������� ��� ���������� ������� ���������� �����     |
//| (�����) �������� �������, � ����� ���������� ��������� ���������:|
//| ������ ��R � �����������, �� ������� ���������� ATR. �.�.        |
//| �������� "�������" �� ���������� ATR � N �� �������� �����;      |
//| ������� - �� ����� ���� (�.�. �� ���� �������� ���������� ����)  |
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
   TrailingByATR(iTicket,iAtr_timeframe,iAtr1_period,iAtr1_shift,iAtr2_period,iAtr2_shift,dCoeff,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByATR(int ticket,int atr_timeframe,int atr1_period,int atr1_shift,int atr2_period,int atr2_shift,double coeff,bool trlinloss)
   {
   // ��������� ���������� ��������   
   if ((ticket==0) || (atr1_period<1) || (atr2_period<1) || (coeff<=0) || (!OrderSelect(ticket,SELECT_BY_TICKET)) || 
   ((atr_timeframe!=1) && (atr_timeframe!=5) && (atr_timeframe!=15) && (atr_timeframe!=30) && (atr_timeframe!=60) && 
   (atr_timeframe!=240) && (atr_timeframe!=1440) && (atr_timeframe!=10080) && (atr_timeframe!=43200)) || (atr1_shift<0) || (atr2_shift<0))
      {
      Print("�������� �������� TrailingByATR() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      }
   
   double curr_atr1; // ������� �������� ATR - 1
   double curr_atr2; // ������� �������� ATR - 2
   double best_atr; // ������� �� �������� ATR
   double atrXcoeff; // ��������� ��������� �������� �� ATR �� �����������
   double newstop; // ����� ��������
   
   // ������� �������� ATR-1, ATR-2
   curr_atr1 = iATR(Symbol(),atr_timeframe,atr1_period,atr1_shift);
   curr_atr2 = iATR(Symbol(),atr_timeframe,atr2_period,atr2_shift);
   
   // ������� �� ��������
   best_atr = MathMax(curr_atr1,curr_atr2);
   
   // ����� ��������� �� �����������
   atrXcoeff = best_atr * coeff;
              
   // ���� ������� ������� (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // ����������� �� �������� ����� (����� ��������)
      newstop = Bid - atrXcoeff;           
      
      // ���� trlinloss==true (�.�. ������� ������� � ���� ������), ��
      if (trlinloss==true)      
         {
         // ���� �������� �����������, �� ������ � ����� ������
         if ((OrderStopLoss()==0) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         // ����� ������ ������ ���� ����� ���� ����� �������
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      else
         {
         // ���� �������� �����������, �� ������, ���� ���� ����� ��������
         if ((OrderStopLoss()==0) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         // ���� ���� �� ����� 0, �� ������ ���, ���� �� ����� ����������� � ����� ��������
         else
            {
            if ((newstop>OrderStopLoss()) && (newstop>OrderOpenPrice()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      }
      
   // ���� �������� ������� (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      // ����������� �� �������� ����� (����� ��������)
      newstop = Ask + atrXcoeff;
      
      // ���� trlinloss==true (�.�. ������� ������� � ���� ������), ��
      if (trlinloss==true)      
         {
         // ���� �������� �����������, �� ������ � ����� ������
         if ((OrderStopLoss()==0) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         // ����� ������ ������ ���� ����� ���� ����� �������
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      else
         {
         // ���� �������� �����������, �� ������, ���� ���� ����� ��������
         if ((OrderStopLoss()==0) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         // ���� ���� �� ����� 0, �� ������ ���, ���� �� ����� ����������� � ����� ��������
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop<OrderOpenPrice()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      }      
   }


//+------------------------------------------------------------------+