//+------------------------------------------------------------------+
//|                                             TrailingRatchetB.mq4 |
//|                                                              I_D |
//|                                            http://www.mymmk.com/ |
//+------------------------------------------------------------------+
#property copyright "I_D"
#property link      "http://www.mymmk.com/ ���� ��� ���������� ���������"

extern   int      iTicket;             // ���������� ����� (�����) �������� �������
extern   int      iPf_level_1 = 10;    // ������� ������� (�������), ��� ������� �������� ��������� � ��������� + 1 �����;
extern   int      iPf_level_2 = 20;    // ������� ������� (�������), ��� ������� �������� ��������� � +1 �� ���������� pf_level_1 ������� �� ����� ��������;
extern   int      iPf_level_3 = 30;    // ������� ������� (�������), ��� ������� �������� ��������� � pf_level_1 �� pf_level_2 ������� �� ����� �������� (�� ���� �������� ������� �������������);
extern   int      iLs_level_1 = 15;    // ���������� �� ����� �������� � ������� "�����", �� ������� ����� ���������� �������� ��� ���������� �������� ������� +1 (�.�. ��� +1 �������� ����� ������ �� ls_level_1);
extern   int      iLs_level_2 = 25;    // ���������� �� ����� �������� � "�����", �� ������� ����� ���������� �������� ��� �������, ��� ���� ������� ��������� ���� ls_level_1, � ����� �������� ���� (�.�. ����� ����, �� �� ����� ����������� - �� �������� ��� ���������� ����������);
extern   int      iLs_level_3 = 35;    // ���������� �� ����� �������� "������", �� ������� ����� ���������� �������� ��� �������, ��� ���� �������� ���� ls_level_2, � ����� �������� ����;
extern   bool     bTrlinloss = false;  // ������� �� ������� �� ������� ������ (����� ������ ��������� � ��������)

//+------------------------------------------------------------------+
//| �������� RATCHET �����������                                     |
//| ��� ���������� �������� ������ 1 �������� - � +1, ��� ���������� |
//| �������� ������ 2 ������� - �������� - �� ������� 1, �����       |
//| ������ ��������� ������ 3 �������, �������� - �� ������� 2       |
//| (������ ����� �������� ������� ��������)                         |
//| ��� ������ � �������� ������� - ���� 3 ������, �� ����� ������   |
//| � ���� ��������� ����, � ������: ���� �� ���������� ���� ������, |
//| � ����� ��������� ���� ���� (������ ��� �������), �� ��������    |
//| ������ �� ���������, ����� �������� ������� (��������, ������    |
//| -5, -10 � -25, �������� -40; ���� ���������� ���� -10, � �����   |
//| ��������� ���� -10, �� �������� - �� -25, ���� ���������� ����   |
//| -5, �� �������� ��������� �� -10, ��� -2 (�����) ���� �� -5      |
//| �������� ������ � ����� �������� ������������. ��� �������       |
//| �������� ��� ���������� ������� ���������� ����� (�����)         |
//| �������� ������� (iTicket)                                       |
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
   TrailingRatchetB(iTicket,iPf_level_1,iPf_level_2,iPf_level_3,iLs_level_1,iLs_level_2,iLs_level_3,bTrlinloss);
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingRatchetB(int ticket,int pf_level_1,int pf_level_2,int pf_level_3,int ls_level_1,int ls_level_2,int ls_level_3,bool trlinloss)
   {
    
   // ��������� ���������� ��������
   if ((ticket==0) || (!OrderSelect(ticket,SELECT_BY_TICKET)) || (pf_level_2<=pf_level_1) || (pf_level_3<=pf_level_2) || 
   (pf_level_3<=pf_level_1) || (pf_level_2-pf_level_1<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) || (pf_level_3-pf_level_2<=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) ||
   (pf_level_1<=MarketInfo(Symbol(),MODE_STOPLEVEL)))
      {
      Print("�������� �������� TrailingRatchetB() ���������� ��-�� �������������� �������� ���������� �� ����������.");
      return(0);
      }
                
   // ���� ������� ������� (OP_BUY)
   if (OrderType()==OP_BUY)
      {
      double dBid = MarketInfo(Symbol(),MODE_BID);
      
      // �������� �� ������� ��������
      
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_3+�����", �������� ��������� � "pf_level_2+�����"
      if ((dBid-OrderOpenPrice())>=pf_level_3*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + pf_level_2 *Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + pf_level_2*Point,OrderTakeProfit(),OrderExpiration());
         }
      else
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_2+�����", �������� ��������� � "pf_level_1+�����"
      if ((dBid-OrderOpenPrice())>=pf_level_2*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + pf_level_1*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + pf_level_1*Point,OrderTakeProfit(),OrderExpiration());
         }
      else        
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_1+�����", �������� ��������� � +1 ("�������� + �����")
      if ((dBid-OrderOpenPrice())>=pf_level_1*Point)
      // ���� �������� �� ��������� ��� ���� ��� "��������+1"
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()<OrderOpenPrice() + 1*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + 1*Point,OrderTakeProfit(),OrderExpiration());
         }

      // �������� �� ������� ������
      if (trlinloss==true)      
         {
         // ���������� ���������� ��������� �������� �������� ������ ������ ������ (ls_level_n), ���� �������� ��������� ����
         // (���� �� ����� ����� ����������� ����, ������������� �������� �� ��������� ����� �������� ������ ������ (���� ��� �� ��������� �������� �������)
         // ������ ���������� ���������� (���� ���)
         if(!GlobalVariableCheck("zeticket")) 
            {
            GlobalVariableSet("zeticket",ticket);
            // ��� �������� �������� �� "0"
            GlobalVariableSet("dpstlslvl",0);
            }
         // ���� �������� � ����� ������� (����� �����), �������� �������� dpstlslvl
         if (GlobalVariableGet("zeticket")!=ticket)
            {
            GlobalVariableSet("dpstlslvl",0);
            GlobalVariableSet("zeticket",ticket);
            }
      
         // ��������� ������� ������� ���� ����� �������� � �� ������� ������ �������
         if ((dBid-OrderOpenPrice())<pf_level_1*Point)         
            {
            // ���� (�������_���� �����/����� ��������) � (dpstlslvl>=ls_level_1), �������� - �� ls_level_1
            if (dBid>=OrderOpenPrice()) 
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_1*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_1*Point,OrderTakeProfit(),OrderExpiration());
      
            // ���� (�������_���� ����� ������_������_1) � (dpstlslvl>=ls_level_1), �������� - �� ls_level_2
            if ((dBid>=OrderOpenPrice()-ls_level_1*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_1))
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_2*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_2*Point,OrderTakeProfit(),OrderExpiration());
      
            // ���� (�������_���� ����� ������_������_2) � (dpstlslvl>=ls_level_2), �������� - �� ls_level_3
            if ((dBid>=OrderOpenPrice()-ls_level_2*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_2))
            if ((OrderStopLoss()==0) || (OrderStopLoss()<(OrderOpenPrice()-ls_level_3*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice()-ls_level_3*Point,OrderTakeProfit(),OrderExpiration());
      
            // ��������/������� �������� �������� �������� "������" �������� "���������"
            // ���� "�������_����-���� ��������+�����" ������ 0, 
            if ((dBid-OrderOpenPrice()+MarketInfo(Symbol(),MODE_SPREAD)*Point)<0)
            // ��������, �� ������ �� �� ���� ��� ����� ������ ������
               {
               if (dBid<=OrderOpenPrice()-ls_level_3*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_3)
               GlobalVariableSet("dpstlslvl",ls_level_3);
               else
               if (dBid<=OrderOpenPrice()-ls_level_2*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_2)
               GlobalVariableSet("dpstlslvl",ls_level_2);   
               else
               if (dBid<=OrderOpenPrice()-ls_level_1*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_1)
               GlobalVariableSet("dpstlslvl",ls_level_1);
               }
            } // end of "if ((dBid-OrderOpenPrice())<pf_level_1*Point)"
         } // end of "if (trlinloss==true)"
      }
      
   // ���� �������� ������� (OP_SELL)
   if (OrderType()==OP_SELL)
      {
      double dAsk = MarketInfo(Symbol(),MODE_ASK);
      
      // �������� �� ������� ��������
      
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_3+�����", �������� ��������� � "pf_level_2+�����"
      if ((OrderOpenPrice()-dAsk)>=pf_level_3*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (pf_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (pf_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }
      else
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_2+�����", �������� ��������� � "pf_level_1+�����"
      if ((OrderOpenPrice()-dAsk)>=pf_level_2*Point)
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (pf_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (pf_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }
      else        
      // ���� ������� "�������_����-����_��������" ������ ��� "pf_level_1+�����", �������� ��������� � +1 ("�������� + �����")
      if ((OrderOpenPrice()-dAsk)>=pf_level_1*Point)
      // ���� �������� �� ��������� ��� ���� ��� "��������+1"
         {
         if ((OrderStopLoss()==0) || (OrderStopLoss()>OrderOpenPrice() - (1 + MarketInfo(Symbol(),MODE_SPREAD))*Point))
         OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() - (1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
         }

      // �������� �� ������� ������
      if (trlinloss==true)      
         {
         // ���������� ���������� ��������� �������� �������� ������ ������ ������ (ls_level_n), ���� �������� ��������� ����
         // (���� �� ����� ����� ����������� ����, ������������� �������� �� ��������� ����� �������� ������ ������ (���� ��� �� ��������� �������� �������)
         // ������ ���������� ���������� (���� ���)
         if(!GlobalVariableCheck("zeticket")) 
            {
            GlobalVariableSet("zeticket",ticket);
            // ��� �������� �������� �� "0"
            GlobalVariableSet("dpstlslvl",0);
            }
         // ���� �������� � ����� ������� (����� �����), �������� �������� dpstlslvl
         if (GlobalVariableGet("zeticket")!=ticket)
            {
            GlobalVariableSet("dpstlslvl",0);
            GlobalVariableSet("zeticket",ticket);
            }
      
         // ��������� ������� ������� ���� ����� �������� � �� ������� ������ �������
         if ((OrderOpenPrice()-dAsk)<pf_level_1*Point)         
            {
            // ���� (�������_���� �����/����� ��������) � (dpstlslvl>=ls_level_1), �������� - �� ls_level_1
            if (dAsk<=OrderOpenPrice()) 
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // ���� (�������_���� ����� ������_������_1) � (dpstlslvl>=ls_level_1), �������� - �� ls_level_2
            if ((dAsk<=OrderOpenPrice() + (ls_level_1 + MarketInfo(Symbol(),MODE_SPREAD))*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_1))
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // ���� (�������_���� ����� ������_������_2) � (dpstlslvl>=ls_level_2), �������� - �� ls_level_3
            if ((dAsk<=OrderOpenPrice() + (ls_level_2 + MarketInfo(Symbol(),MODE_SPREAD))*Point) && (GlobalVariableGet("dpstlslvl")>=ls_level_2))
            if ((OrderStopLoss()==0) || (OrderStopLoss()>(OrderOpenPrice() + (ls_level_3 + MarketInfo(Symbol(),MODE_SPREAD))*Point)))
            OrderModify(ticket,OrderOpenPrice(),OrderOpenPrice() + (ls_level_3 + MarketInfo(Symbol(),MODE_SPREAD))*Point,OrderTakeProfit(),OrderExpiration());
      
            // ��������/������� �������� �������� �������� "������" �������� "���������"
            // ���� "�������_����-���� ��������+�����" ������ 0, 
            if ((OrderOpenPrice()-dAsk+MarketInfo(Symbol(),MODE_SPREAD)*Point)<0)
            // ��������, �� ������ �� �� ���� ��� ����� ������ ������
               {
               if (dAsk>=OrderOpenPrice()+(ls_level_3+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_3)
               GlobalVariableSet("dpstlslvl",ls_level_3);
               else
               if (dAsk>=OrderOpenPrice()+(ls_level_2+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_2)
               GlobalVariableSet("dpstlslvl",ls_level_2);   
               else
               if (dAsk>=OrderOpenPrice()+(ls_level_1+MarketInfo(Symbol(),MODE_SPREAD))*Point)
               if (GlobalVariableGet("dpstlslvl")<ls_level_1)
               GlobalVariableSet("dpstlslvl",ls_level_1);
               }
            } // end of "if ((dBid-OrderOpenPrice())<pf_level_1*Point)"
         } // end of "if (trlinloss==true)"
      }      
   }
//+------------------------------------------------------------------+