//+------------------------------------------------------------------+
//|                                               TrailingStairs.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iTrldistance = 40;   // ���������� �� �������� ����� (�������), �� ������� ���������� ��������, �������
extern   int      iTrlstep = 10;       // "���" ��������� ��������� (�������) (�� ������ 1)

//+------------------------------------------------------------------+
//| �������� �����������-������������                                |
//| ��������� ��������� ����� �������, ���������� �� ����� ��������,|
//| �� ������� �������� ����������� (�������) � "���", � ������� ��  |
//| ����������� (�������)                                            |
//| ������: ��� +30 ���� �� +10, ��� +40 - ���� �� +20 � �.�.        |
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
   TrailingStairs(iTicket,iTrldistance,iTrlstep);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingStairs(int ticket,int trldistance,int trlstep)
   { 
   
   double nextstair; // ��������� �������� �����, ��� ������� ����� ������ ��������

   // ��������� ���������� ��������
   if ((trldistance<MarketInfo(Symbol(),MODE_STOPLEVEL)) || (trlstep<1) || (trldistance<trlstep) || (ticket==0) || (!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)))
      {
      Print("�������� �������� TrailingStairs() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      } 
   
   // ���� ������� ������� (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // �����������, ��� ����� �������� ����� ������� ��������������� ��������
      // ���� �������� ���� �������� ��� ����� 0 (�� ���������), �� ��������� ������� = ���� �������� + trldistance + �����
      if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice()))
      nextstair = OrderOpenPrice() + trldistance*Point;
         
      // ����� ��������� ������� = ������� �������� + trldistance + trlstep + �����
      else
      nextstair = OrderStopLoss() + trldistance*Point;

      // ���� ������� ���� (Bid) >= nextstair � ����� �������� ����� ����� ��������, ������������ ���������
      if (Bid>=nextstair)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice()) && (OrderOpenPrice() + trlstep*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)) 
            {
            if (!OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + trlstep*Point,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      else
         {
         if (!OrderModify(ticket,OrderOpenPrice(),OrderStopLoss() + trlstep*Point,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
         }
      }
      
   // ���� �������� ������� (OP_SELL)
   if (OrderType()==OP_SELL)
      { 
      // �����������, ��� ����� �������� ����� ������� ��������������� ��������
      // ���� �������� ���� �������� ��� ����� 0 (�� ���������), �� ��������� ������� = ���� �������� + trldistance + �����
      if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice()))
      nextstair = OrderOpenPrice() - (trldistance + MarketInfo(Symbol(),MODE_SPREAD))*Point;
      
      // ����� ��������� ������� = ������� �������� + trldistance + trlstep + �����
      else
      nextstair = OrderStopLoss() - (trldistance + MarketInfo(Symbol(),MODE_SPREAD))*Point;
       
      // ���� ������� ���� (���) >= nextstair � ����� �������� ����� ����� ��������, ������������ ���������
      if (Ask<=nextstair)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice()) && (OrderOpenPrice() - (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }
      else
         {
         if (!OrderModify(ticket,OrderOpenPrice(),OrderStopLoss()- (trlstep + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
         }
      }      
   }
//+------------------------------------------------------------------+