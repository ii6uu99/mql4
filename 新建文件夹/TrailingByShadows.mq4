//+------------------------------------------------------------------+
//|                                            TrailingByShadows.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/"

extern   int   iTicket;             // ���������� ����� (�����) �������� �������
extern   int   iTmfrm;              // ������, �� ����� �������� ������� ������� (1, 5, 15, 30, 60, 240, 1440, 10080, 43200)
extern   int   iBars_n = 3;         // ���-�� �����, �� ������� ������� �������
extern   int   iIndent = 3;         // ������ �� ���� ����, �� ������� ����������� ��������
extern   bool  bTrlinloss = false;  // ������� �� ������� �� ������� ������ (����� ������ ��������� � ��������)

//+------------------------------------------------------------------+
//| �������� �� ����� N ������                                       |
//| ��� ������� �������� ��� ���������� ������� ���������� �����     |
//| (�����) �������� �������, � ����� ���������� ��������� ���������:|
//| ���������� �����, �� ����� ������� ���������� �������������      |
//| (�� 1 � ������) � ������ (�������) - ���������� �� ����. (���.)  |
//| �����, �� ������� ����������� �������� (�� 0), �������������     |
//| trlinloss ���������, ������� �� ������������� �� �������         |
//| "��������-���� �������� �������.                                 |
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
   TrailingByShadows(iTicket,iTmfrm,iBars_n,iIndent,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByShadows(int ticket,int tmfrm,int bars_n, int indent,bool trlinloss)
   {  
   
   int i; // counter
   double new_extremum;
   
   // ��������� ���������� ��������
   if ((bars_n<1) || (indent<0) || (ticket==0) || ((tmfrm!=1) && (tmfrm!=5) && (tmfrm!=15) && (tmfrm!=30) && (tmfrm!=60) && (tmfrm!=240) && (tmfrm!=1440) && (tmfrm!=10080) && (tmfrm!=43200)) || (!OrderSelect(ticket,SELECT_BY_TICKET)))
      {
      Print("�������� �������� TrailingByShadows() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      } 
   
   // ���� ������� ������� (OP_BUY), ������� ������� bars_n ������
   if (OrderType()==OP_BUY)
      {
      for(i=1;i<=bars_n;i++)
         {
         if (i==1) new_extremum = iLow(Symbol(),tmfrm,i);
         else 
         if (new_extremum>iLow(Symbol(),tmfrm,i)) new_extremum = iLow(Symbol(),tmfrm,i);
         }         
      
      // ���� ������ � � ���� �������
      if (trlinloss==true)
         {
         // ���� ��������� �������� "�����" �������� ��������� �������, ��������� 
         if ((((new_extremum - indent*Point)>OrderStopLoss()) || (OrderStopLoss()==0)) && (new_extremum - indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum - indent*Point,OrderTakeProfit(),OrderExpiration()))            
         Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
         }
      else
         {
         // ���� ����� �������� �� ������ ����� �����������, �� � ����� �������� �������
         if ((((new_extremum - indent*Point)>OrderStopLoss()) || (OrderStopLoss()==0)) && ((new_extremum - indent*Point)>OrderOpenPrice()) && (new_extremum - indent*Point<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum-indent*Point,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
         }
      }
      
   // ���� �������� ������� (OP_SELL), ������� ������� bars_n ������
   if (OrderType()==OP_SELL)
      {
      for(i=1;i<=bars_n;i++)
         {
         if (i==1) new_extremum = iHigh(Symbol(),tmfrm,i);
         else 
         if (new_extremum<iHigh(Symbol(),tmfrm,i)) new_extremum = iHigh(Symbol(),tmfrm,i);
         }         
           
      // ���� ������ � � ���� �������
      if (trlinloss==true)
         {
         // ���� ��������� �������� "�����" �������� ��������� �������, ��������� 
         if ((((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderStopLoss()) || (OrderStopLoss()==0)) && (new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
         }
      else
         {
         // ���� ����� �������� �� ������ ����� �����������, �� � ����� �������� �������
         if ((((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderStopLoss()) || (OrderStopLoss()==0)) && ((new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point)<OrderOpenPrice()) && (new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         if (!OrderModify(ticket,OrderOpenPrice(),new_extremum + (indent + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� ����� �",OrderTicket(),". ������: ",GetLastError());
         }      
      }      
   }
//+------------------------------------------------------------------+