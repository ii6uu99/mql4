//****** ������ (��������): test1.mq4
//+------------------------------------------------------------------+
//|      ����������� ��� ������������ MasterWindows Copyright DC2008 |
//|                              http://www.mql5.com/ru/users/dc2008 |
//+------------------------------------------------------------------+
#property strict
#property copyright     "Copyright 2010-2016, DC2008"
#property link          "http://www.mql5.com/ru/users/dc2008"
#property version       "1.00"
#property description   "Example of MasterWindows library"
//--- ���������� ����� �������
#include <ClassWin.mqh>
int Mint[][3]=
  {
     {1,0,0},
     {2,100,0},
     {3,100,0},
     {4,100,0},
     {5,100,0},
     {6,100,50},
     {1,100,50},
     {}
  };
string Mstr[][3]=
  {
     {"����� ����","",""},
     {"NEW1","new1",""},
     {"NEW2","new2",""},
     {"NEW3","new3",""},
     {"NEW4","new4",""},
     {"NEW5","new5",""},
     {"NEW6","new6",""},
     {}
  };
//+------------------------------------------------------------------+
//| ����� CMasterWindows (������� ������)                            |
//+------------------------------------------------------------------+
class CMasterWindows:public CWin
  {
private:
   long              Y_hide;          // �������� ������ ����
   long              Y_obj;           // �������� ������ ����
   long              H_obj;           // �������� ������ ����
public:
   void              CMasterWindows() {on_event=false;}
   void              Run();           // ����� ������� �������� ������
   void              Hide();          // �����: �������� ����
   void              Deinit() {ObjectsDeleteAll(0,0,-1); Comment("");}
   virtual void      OnEvent(const int id,
                             const long &lparam,
                             const double &dparam,
                             const string &sparam);
  };
//+------------------------------------------------------------------+
//| ����� Run ������ CMasterWindows                                  |
//+------------------------------------------------------------------+
void CMasterWindows::Run()
  {
   ObjectsDeleteAll(0,0,-1);
   Comment("����������� ��� ������������ MasterWindows for MQL5 � DC2008");
//--- ������ ������� ���� � ��������� ����������� ������
   SetWin("test1.Exp",50,100,250,CORNER_LEFT_UPPER);
   Draw(Mint,Mstr,7);
  }
//+------------------------------------------------------------------+
//| ����� ��������� ������� OnChartEvent ������ CMasterWindows       |
//+------------------------------------------------------------------+
void CMasterWindows::OnEvent(const int id,
                             const long &lparam,
                             const double &dparam,
                             const string &sparam)
  {
   if(on_event // ��������� ������� ���������
      && StringFind(sparam,"test1.Exp",0)>=0)
     {
      //--- ���������� ������� OnChartEvent
      STR1.OnEvent(id,lparam,dparam,sparam);
      STR2.OnEvent(id,lparam,dparam,sparam);
      STR3.OnEvent(id,lparam,dparam,sparam);
      STR4.OnEvent(id,lparam,dparam,sparam);
      STR5.OnEvent(id,lparam,dparam,sparam);
      STR6.OnEvent(id,lparam,dparam,sparam);
      //--- �������� ������������ �������
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CREATE)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW1] � ��������� Edit STR1
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_ENDEDIT
         && StringFind(sparam,".STR1",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW2] : ������ Plus STR2
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR2",0)>0
         && StringFind(sparam,".Button3",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW2] : ������ Minus STR2
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR2",0)>0
         && StringFind(sparam,".Button4",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW3] : ������ Plus STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button3",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW3] : ������ Minus STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button4",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW3] : ������ Up STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button5",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- �������������� ���������� [NEW3] : ������ Down STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button6",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- ������� ������ [new4] STR4
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR4",0)>0
         && StringFind(sparam,".Button",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- ������� ������ [NEW5] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(1)",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- ������� ������ [new5] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(2)",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- ������� ������ [] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(3)",0)>0)
        {
         //--- ������� �� ����������� �������
        }
      //--- ������� ������ Close � ������� ����
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".Button1",0)>0)
        {
         //--- ������� �� ����������� �������
         ExpertRemove();
        }
      //--- ������� ������ Hide � ������� ����
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".Button0",0)>0)
        {
         //--- ������� �� ����������� �������
        }
     }
  }
//--- ���������� �������� ������
CMasterWindows MasterWin;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- ������ �������� ������
   MasterWin.Run();
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- ��������������� �������� ������ (������� ���� �����)
   MasterWin.Deinit();
  }
//+------------------------------------------------------------------+
//| Expert Event function                                            |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- ���������� ������� OnChartEvent � ������� ������
   MasterWin.OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
