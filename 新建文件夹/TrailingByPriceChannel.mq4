//+------------------------------------------------------------------+
//|                                       TrailingByPriceChannel.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iBars_n = 20;        // ���-�� ����� �������� �������, �� ������� �������� ������� �����
extern   int      iIndent = 3;         // ������ �� ���� ����, �� ������� ����������� ��������

//+------------------------------------------------------------------+
//| �������� �� ������� ������                                       |
//| ��� ������� �������� ��� ���������� ������� ���������� �����     |
//| (�����) �������� �������, � ����� ���������� ��������� ���������:|
//| ���-�� �����, ����� ������� (��� ��� ��������� �� �����) ������- |
//| ������ �������� �������� (��� ��� ������ �������, ��� - ���     |
//| �������), � ����� ������ � ������� �� ������� ��� ����������     |
//| ���������.                                                       |
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
   TrailingByPriceChannel(iTicket,iBars_n,iIndent);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingByPriceChannel(int iTicket,int iBars_n,int iIndent)
   {     
   
   // ��������� ���������� ��������
   if ((iBars_n<1) || (iIndent<0) || (iTicket==0) || (!OrderSelect(iTicket,SELECT_BY_TICKET)))
      {
      Print("�������� �������� TrailingByPriceChannel() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      } 
   
   double   dChnl_max; // ������� ������� ������
   double   dChnl_min; // ������ ������� ������
   
   // ���������� ����.��� � ���.��� �� iBars_n ����� ������� � [1] (= ������� � ������ ������� �������� ������)
   dChnl_max = High[iHighest(Symbol(),0,2,iBars_n,1)] + (iIndent+MarketInfo(Symbol(),MODE_SPREAD))*Point;
   dChnl_min = Low[iLowest(Symbol(),0,1,iBars_n,1)] - iIndent*Point;   
   
   // ���� ������� �������, � � �������� ���� (���� ������ ������� ������ ���� �� ���������, ==0), ������������ ���
   if (OrderType()==OP_BUY)
      {
      if ((OrderStopLoss()<dChnl_min) && (dChnl_min<Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dChnl_min,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
         }
      }
   
   // ���� ������� - ��������, � � �������� ���� (���� ������� ������� ������ ��� �� ��������, ==0), ������������ ���
   if (OrderType()==OP_SELL)
      {
      if (((OrderStopLoss()==0) || (OrderStopLoss()>dChnl_max)) && (dChnl_min>Ask+MarketInfo(Symbol(),MODE_STOPLEVEL)*Point))
         {
         if (!OrderModify(iTicket,OrderOpenPrice(),dChnl_max,OrderTakeProfit(),OrderExpiration()))
         Print("�� ������� �������������� �������� ������ �",OrderTicket(),". ������: ",GetLastError());
         }
      }
   }
//+------------------------------------------------------------------+