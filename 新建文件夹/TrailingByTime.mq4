//+------------------------------------------------------------------+
//|                                           TrailingFiftyFifty.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iInterval = 240;     // ��������� ��������, ����� ������� (�� �����������) ����������� ��������, �����
extern   int      iTrlstep = 20;       // ��� ���������, �������
extern   bool     bTrlinloss = false;  // ������� �� ������� �� ������� ������ (����� ������ ��������� � ��������)

//+------------------------------------------------------------------+
//| �������� �� �������                                              |
//| ��� ������� �������� ��� ���������� ������� ���������� �����     |
//| (�����) �������� �������, � ����� ���������� ��������� ���������:|
//| ��������� �������� (�����), � ������� ������������ �����������   |
//| ���������, ��� ��������� (�������), � ����� ����������, �������  |
//| �� ������������� �� ������� ����������                           |
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
   TrailingByTime(iTicket,iInterval,iTrlstep,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByTime(int ticket,int interval,int trlstep,bool trlinloss)
   {
      
   // ��������� ���������� ��������
   if ((ticket==0) || (interval<1) || (trlstep<1) || !OrderSelect(ticket,SELECT_BY_TICKET))
      {
      Print("�������� �������� TrailingByTime() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      }
      
   double minpast; // ���-�� ������ ����� �� �������� ������� �� �������� ������� 
   double times2change; // ���-�� ���������� interval � ������� �������� ������� (�.�. ������� ��� ������ ��� ���� ��������� ��������) 
   double newstop; // ����� �������� ��������� (�������� ���-�� ���������, ������� ������ ���� ����� �����)
   
   // ����������, ������� ������� ������ � ������� �������� �������
   minpast = (TimeCurrent() - OrderOpenTime()) / 60;
      
   // ������� ��� ����� ���� ����������� ��������
   times2change = MathFloor(minpast / interval);
         
   // ���� ������� ������� (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // ���� ������ � ������, �� ��������� �� ��������� (���� �� �� 0, ���� 0 - �� ��������)
      if (trlinloss==true)
         {
         if (OrderStopLoss()==0) newstop = OrderOpenPrice() + times2change*(trlstep*Point);
         else newstop = OrderStopLoss() + times2change*(trlstep*Point); 
         }
      else
      // ����� - �� ����� �������� �������
      newstop = OrderOpenPrice() + times2change*(trlstep*Point); 
         
      if (times2change>0)
         {
         if ((newstop>OrderStopLoss()) && (newstop<Bid- MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      }
      
   // ���� �������� ������� (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      // ���� ������ � ������, �� ��������� �� ��������� (���� �� �� 0, ���� 0 - �� ��������)
      if (trlinloss==true)
         {
         if (OrderStopLoss()==0) newstop = OrderOpenPrice() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
         else newstop = OrderStopLoss() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
         }
      else
      newstop = OrderOpenPrice() - times2change*(trlstep*Point) - MarketInfo(Symbol(),MODE_SPREAD)*Point;
                
      if (times2change>0)
         {
         if (((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice())) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         else
         if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      }      
   }
//+------------------------------------------------------------------+