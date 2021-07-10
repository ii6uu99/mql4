//+------------------------------------------------------------------+
//|                                           TrailingFiftyFifty.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iTmFrme = 60;        // ������ �����, �� ����� �������� ���������� ��������
extern   double   dCoeff = 0.5;        // "����������� ��������", � % �� 0.01 �� 1 
extern   bool     bTrlinloss = false;  // ������� �� ������� �� ������� ������ (����� ������ ��������� � ��������)

static datetime sdtPrevtime = 0;
 
//+------------------------------------------------------------------+
//| �������� "�����������"                                           |
//| �� �������� ���������� ������� (����) ����������� �������� ��    |
//| �������� (�� ����� � ����� ���� �����������) ���������, ����-    |
//| ������ ������ (�.�., ��������, �� �������� ����� ������ +55 �. - |
//| �������� ��������� � 55/2=27 �. ���� �� �������� ����.           |
//| ����� ������ ������, ��������, +80 �., �� �������� ��������� ��  |
//| �������� (����.) ���������� ����� ���. ���������� � ������ ��    |
//| �������� ���� - 27 + (80-27)/2 = 27 + 53/2 = 27 + 26 = 53 �.     |
//| ��� ������� �������� ��� ���������� ������� ���������� �����     |
//| (�����) �������� ������� (iTicket); iTmFrme - ��������� (�       |
//| �������, ������� dCoeff - "����������� ��������", � % �� 0.01 �� |
//| 1 (� ��������� ������ �������� ����� ��������� (���� ���������)  |
//| �������� � ���. ����� � �������, ������ �����, ����� ��          |
//| ���������) bTrlinloss - ����� �� ������� �� �������� ������� -   |
//| ���� ��, �� �� �������� ���������� ���� ���������� �����         |
//| ���������� (� �.�. "��" ���������) � ������� ������ �����        |
//| ����������� � dCoeff ��� ����� ����. ������� �������, �����������| 
//| ������ ���� ��������  c������� (�� ����� 0)                     |
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
   TrailingFiftyFifty(iTicket,iTmFrme,dCoeff,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingFiftyFifty(int iTicket,int iTmFrme,double dCoeff,bool bTrlinloss)
   { 
   // ���������� �������� ������ �� �������� ����
   if (sdtPrevtime == iTime(Symbol(),iTmFrme,0)) return(0);
   else
      {
      sdtPrevtime = iTime(Symbol(),iTmFrme,0);             
      
      // ��������� ���������� ��������
      if ((iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)) || 
      ((iTmFrme!=1) && (iTmFrme!=5) && (iTmFrme!=15) && (iTmFrme!=30) && (iTmFrme!=60) && (iTmFrme!=240) && 
      (iTmFrme!=1440) && (iTmFrme!=10080) && (iTmFrme!=43200)) || (dCoeff<0.01) || (dCoeff>1.0))
         {
         Print("�������� �������� TrailingFiftyFifty() ���������� ��-�� �������������� �������� ���������� �� ����������.");
         return(0);
         }
         
      // �������� ������� - � ������� ���� ����� ������������ (����� ��� bTrlinloss ����� �� ����� �������� 
      // ������� �������� ����� ��������� �� �������� ���������� ����� ���������� � ������ ��������)
      // �.�. �������� ������ ��� �������, ��� � ������� OrderOpenTime() ������ �� ����� iTmFrme �����
      if (iTime(Symbol(),iTmFrme,0)>OrderOpenTime())
      {         
      
      double dBid = MarketInfo(Symbol(),MODE_BID);
      double dAsk = MarketInfo(Symbol(),MODE_ASK);
      double dNewSl;
      double dNexMove;     
      
      // ��� ������� ������� ��������� �������� �� dCoeff ��������� �� ����� �������� �� Bid �� ������ �������� ����
      // (���� ����� �������� ����� ���������� � �������� �������� � ������� �������)
      if (OrderType()==OP_BUY)
         {
         if ((bTrlinloss) && (OrderStopLoss()!=0))
            {
            dNexMove = NormalizeDouble(dCoeff*(dBid-OrderStopLoss()),Digits);
            dNewSl = NormalizeDouble(OrderStopLoss()+dNexMove,Digits);            
            }
         else
            {
            // ���� �������� ���� ����� ��������, �� ������ "�� ����� ��������"
            if (OrderOpenPrice()>OrderStopLoss())
               {
               dNexMove = NormalizeDouble(dCoeff*(dBid-OrderOpenPrice()),Digits);                 
               //Print("dNexMove = ",dCoeff,"*(",dBid,"-",OrderOpenPrice(),")");
               dNewSl = NormalizeDouble(OrderOpenPrice()+dNexMove,Digits);
               //Print("dNewSl = ",OrderOpenPrice(),"+",dNexMove);
               }
         
            // ���� �������� ���� ����� ��������, ������ �� ���������
            if (OrderStopLoss()>=OrderOpenPrice())
               {
               dNexMove = NormalizeDouble(dCoeff*(dBid-OrderStopLoss()),Digits);
               dNewSl = NormalizeDouble(OrderStopLoss()+dNexMove,Digits);
               }                                      
            }
            
         // �������� ���������� ������ � ������, ���� ����� �������� ����� �������� � ���� �������� - � ������� �������
         // (��� ������ ��������, �� ����� ��������, ����� �������� ����� ���� ����� ����������, � � �� �� ����� ���� 
         // ����� �������� (���� dBid ���� ����������) 
         if ((dNewSl>OrderStopLoss()) && (dNexMove>0) && ((dNewSl<Bid- MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)))
            {
            if (!OrderModify(OrderTicket(),OrderOpenPrice(),dNewSl,OrderTakeProfit(),OrderExpiration(),Red))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }       
      
      // �������� ��� �������� �������   
      if (OrderType()==OP_SELL)
         {
         if ((bTrlinloss) && (OrderStopLoss()!=0))
            {
            dNexMove = NormalizeDouble(dCoeff*(OrderStopLoss()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);
            dNewSl = NormalizeDouble(OrderStopLoss()-dNexMove,Digits);            
            }
         else
            {         
            // ���� �������� ���� ����� ��������, �� ������ "�� ����� ��������"
            if (OrderOpenPrice()<OrderStopLoss())
               {
               dNexMove = NormalizeDouble(dCoeff*(OrderOpenPrice()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);                 
               dNewSl = NormalizeDouble(OrderOpenPrice()-dNexMove,Digits);
               }
         
            // ���� �������� ���� ����� ��������, ������ �� ���������
            if (OrderStopLoss()<=OrderOpenPrice())
               {
               dNexMove = NormalizeDouble(dCoeff*(OrderStopLoss()-(dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)),Digits);
               dNewSl = NormalizeDouble(OrderStopLoss()-dNexMove,Digits);
               }                  
            }
         
         // �������� ���������� ������ � ������, ���� ����� �������� ����� �������� � ���� �������� - � ������� �������
         if ((dNewSl<OrderStopLoss()) && (dNexMove>0) && (dNewSl>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
            {
            if (!OrderModify(OrderTicket(),OrderOpenPrice(),dNewSl,OrderTakeProfit(),OrderExpiration(),Blue))
            Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
            }
         }               
      }
      }   
   }
//+------------------------------------------------------------------+