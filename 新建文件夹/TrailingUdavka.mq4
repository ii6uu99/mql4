//+------------------------------------------------------------------+
//|                                               TrailingStairs.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iTrl_dist_1 = 30;    // �������� ���������� ��������� (�������) (�� ������ MarketInfo(Symbol(),MODE_STOPLEVEL), ������ trl_dist_2 � trl_dist_3);
extern   int      iLevel_1 = 50;       // ������� ������� (�������), ��� ���������� �������� ��������� ��������� ����� ��������� � trl_dist_1 �� trl_dist_2 (������ level_2; ������ trl_dist_1);
extern   int      iTrl_dist_2 = 20;    // ���������� ��������� (�������) ����� ���������� ������ ������ ������� � level_1 ������� (�� ������ MarketInfo(Symbol(),MODE_STOPLEVEL));
extern   int      iLevel_2 = 70;       // ������� ������� (�������), ��� ���������� �������� ��������� ��������� ����� ��������� � trl_dist_2 �� trl_dist_3 ������� (������ trl_dist_1 � ������ level_1);
extern   int      iTrl_dist_3 = 10;    // ���������� ��������� (�������) ����� ���������� ������ ������ ������� � level_2 ������� (�� ������ MarketInfo(Symbol(),MODE_STOPLEVEL)).

//+------------------------------------------------------------------+
//| �������� �����������-�������������� ("������")                   |
//| �������� ��������� ����� �������, �������� �������� (�������) � |
//| 2 "������" (�������� �������, �������), ��� ������� ��������     |
//| ���������, � ��������������� �������� ��������� (�������)        |
//| ������: �������� �������� 30 �., ��� +50 - 20 �., +80 � ������ - |
//| �� ���������� � 10 �������.                                      |
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
   TrailingUdavka(iTicket,iTrl_dist_1,iLevel_1,iTrl_dist_2,iLevel_2,iTrl_dist_3);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingUdavka(int ticket,int trl_dist_1,int level_1,int trl_dist_2,int level_2,int trl_dist_3)
   {  
   
   double newstop = 0; // ����� ��������
   double trldist; // ���������� ��������� (� ����������� �� "�����������" ����� = trl_dist_1, trl_dist_2 ��� trl_dist_3)

   // ��������� ���������� ��������
   if ((trl_dist_1<MarketInfo(Symbol(),MODE_STOPLEVEL)) || (trl_dist_2<MarketInfo(Symbol(),MODE_STOPLEVEL)) || (trl_dist_3<MarketInfo(Symbol(),MODE_STOPLEVEL)) || 
   (level_1<=trl_dist_1) || (level_2<=trl_dist_1) || (level_2<=level_1) || (ticket==0) || (!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)))
      {
      Print("�������� �������� TrailingUdavka() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      } 
   
   // ���� ������� ������� (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      // ���� ������ <=trl_dist_1, �� trldist=trl_dist_1, ���� ������>trl_dist_1 && ������<=level_1*Point ...
      if ((Bid-OrderOpenPrice())<=level_1*Point) trldist = trl_dist_1;
      if (((Bid-OrderOpenPrice())>level_1*Point) && ((Bid-OrderOpenPrice())<=level_2*Point)) trldist = trl_dist_2;
      if ((Bid-OrderOpenPrice())>level_2*Point) trldist = trl_dist_3; 
            
      // ���� �������� = 0 ��� ������ ����� ��������, �� ���� ���.���� (Bid) ������/����� ��������� ����_��������+�����.���������
      if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice()))
         {
         if (Bid>(OrderOpenPrice() + trldist*Point))
         newstop = Bid -  trldist*Point;
         }

      // �����: ���� ������� ���� (Bid) ������/����� ��������� �������_��������+���������� ���������, 
      else
         {
         if (Bid>(OrderStopLoss() + trldist*Point))
         newstop = Bid -  trldist*Point;
         }
      
      // ������������ ��������
      if ((newstop>OrderStopLoss()) && (newstop<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
         }
      }
      
   // ���� �������� ������� (OP_SELL)
   if (OrderType()==OP_SELL)
      { 
      // ���� ������ <=trl_dist_1, �� trldist=trl_dist_1, ���� ������>trl_dist_1 && ������<=level_1*Point ...
      if ((OrderOpenPrice()-(Ask + MarketInfo(Symbol(),MODE_SPREAD)*Point))<=level_1*Point) trldist = trl_dist_1;
      if (((OrderOpenPrice()-(Ask + MarketInfo(Symbol(),MODE_SPREAD)*Point))>level_1*Point) && ((OrderOpenPrice()-(Ask + MarketInfo(Symbol(),MODE_SPREAD)*Point))<=level_2*Point)) trldist = trl_dist_2;
      if ((OrderOpenPrice()-(Ask + MarketInfo(Symbol(),MODE_SPREAD)*Point))>level_2*Point) trldist = trl_dist_3; 
            
      // ���� �������� = 0 ��� ������ ����� ��������, �� ���� ���.���� (Ask) ������/����� ��������� ����_��������+�����.���������
      if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice()))
         {
         if (Ask<(OrderOpenPrice() - (trldist + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         newstop = Ask + trldist*Point;
         }

      // �����: ���� ������� ���� (Bid) ������/����� ��������� �������_��������+���������� ���������, 
      else
         {
         if (Ask<(OrderStopLoss() - (trldist + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         newstop = Ask +  trldist*Point;
         }
            
       // ������������ ��������
      if (newstop>0)
         {
         if (((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice())) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         else
            {
            if ((newstop<OrderStopLoss()) && (newstop>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))  
               {
               if (!OrderModify(ticket,OrderOpenPrice(),newstop,OrderTakeProfit(),OrderExpiration()))
               Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
               }
            }
         }
      }      
   }
//+------------------------------------------------------------------+