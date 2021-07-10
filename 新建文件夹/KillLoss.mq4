//+------------------------------------------------------------------+
//|                                                     KillLoss.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   double   dSpeedCoeff = 1;     // ����������� ��������, ������������, ��� ������ �������� �������� ��������� ����� � ���� ������

//+------------------------------------------------------------------+
//| �������� KillLoss                                                |
//| ����������� �� ������� ������. ����: �������� �������� ��������� |
//| ����� �� ��������� �������� ����� � ����������� (dSpeedCoeff).   |
//| ��� ���� ����������� ����� "���������" � �������� ����������     |
//| ������ - ���, ����� ��� ������� ����� ����� �������� ������. ��� |
//| ������������ = 1 �������� ��������� ����� ��������� ����� ����-  |
//| ��� ��������� � ������ �� ������ ������� �������, ��� �����.>1   |
//| ����� ������� ����� � ��������� ����� ������� � ������� �����-   |
//| ���� ��������� �����, ��� �����.<1 - ��������, ����� � �������-  |
//| �� ���������.                                                    |
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
   KillLoss(iTicket,dSpeedCoeff);
   return(0);
  }
//+------------------------------------------------------------------+

void KillLoss(int iTicket,double dSpeedCoeff)
   {   
   // ��������� ���������� ��������
   if ((iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)) || (dSpeedCoeff<0.1))
      {
      Print("�������� �������� KillLoss() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      }           
      
   double dStopPriceDiff; // ���������� (�������) ����� ������ � ����������   
   double dToMove; // ���-�� �������, �� ������� ������� ����������� ��������   
   // ������� ����
   double dBid = MarketInfo(OrderSymbol(),MODE_BID);
   double dAsk = MarketInfo(OrderSymbol(),MODE_ASK);      
   
   // ������� ���������� ����� ������ � ����������
   if (OrderType()==OP_BUY) dStopPriceDiff = dBid - OrderStopLoss();
   if (OrderType()==OP_SELL) dStopPriceDiff = (OrderStopLoss() + MarketInfo(OrderSymbol(),MODE_SPREAD)*MarketInfo(OrderSymbol(),MODE_POINT)) - dAsk;                  
   
   // ���������, ���� ����� != ������, � ������� �������� ������, ���������� ������� ���������� ����� ������ � ����������
   if (GlobalVariableGet("zeticket")!=iTicket)
      {
      GlobalVariableSet("sldiff",dStopPriceDiff);      
      GlobalVariableSet("zeticket",iTicket);
      }
   else
      {                                   
      // ����, � ��� ���� ����������� ��������� ��������� �����
      // �� ������ �����, ������� �������� ���� � ������� �����, 
      // �� ������ ����������� �������� ��� �� ������� �� dSpeedCoeff ��� �������
      // (��������, ���� ���� ���������� �� 3 ������ �� ���, dSpeedCoeff = 1.5, ��
      // �������� ����������� �� 3 � 1.5 = 4.5, ��������� - 5 �. ���� ��������� �� 
      // ������ (������� ������), ������ �� ������.            
      
      // ���-�� �������, �� ������� ����������� ���� � ��������� � ������� ���������� �������� (����, �� ����)
      dToMove = (GlobalVariableGet("sldiff") - dStopPriceDiff) / MarketInfo(OrderSymbol(),MODE_POINT);
      
      // ���������� ����� ��������, �� ������ ���� ��� �����������
      if (dStopPriceDiff<GlobalVariableGet("sldiff"))
      GlobalVariableSet("sldiff",dStopPriceDiff);
      
      // ������ �������� �� ������, ���� ���������� ����������� (�.�. ���� ����������� � ���������, ������ ������)
      if (dToMove>0)
         {       
         // ��������, ��������������, ����� ����� ����������� �� ����� �� ����������, �� � ������ �����. ���������
         dToMove = MathRound(dToMove * dSpeedCoeff) * MarketInfo(OrderSymbol(),MODE_POINT);                 
      
         // ������ ��������, ����� �� �� ��������� �������� �� ����� ����������
         if (OrderType()==OP_BUY)
            {
            if (dBid - (OrderStopLoss() + dToMove)>MarketInfo(OrderSymbol(),MODE_STOPLEVEL)* MarketInfo(OrderSymbol(),MODE_POINT))
            OrderModify(iTicket,OrderOpenPrice(),OrderStopLoss() + dToMove,OrderTakeProfit(),OrderExpiration());            
            }
         if (OrderType()==OP_SELL)
            {
            if ((OrderStopLoss() - dToMove) - dAsk>MarketInfo(OrderSymbol(),MODE_STOPLEVEL) * MarketInfo(OrderSymbol(),MODE_POINT))
            OrderModify(iTicket,OrderOpenPrice(),OrderStopLoss() - dToMove,OrderTakeProfit(),OrderExpiration());
            }      
         }
      }            
   }
   
//+------------------------------------------------------------------+   