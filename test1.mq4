//****** Проект (советник): test1.mq4
//+------------------------------------------------------------------+
//|      Программный код сгенерирован MasterWindows Copyright DC2008 |
//|                              http://www.mql5.com/ru/users/dc2008 |
//+------------------------------------------------------------------+
#property strict
#property copyright     "Copyright 2010-2016, DC2008"
#property link          "http://www.mql5.com/ru/users/dc2008"
#property version       "1.00"
#property description   "Example of MasterWindows library"
//--- Подключаем файлы классов
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
     {"Новое окно","",""},
     {"NEW1","new1",""},
     {"NEW2","new2",""},
     {"NEW3","new3",""},
     {"NEW4","new4",""},
     {"NEW5","new5",""},
     {"NEW6","new6",""},
     {}
  };
//+------------------------------------------------------------------+
//| класс CMasterWindows (Главный модуль)                            |
//+------------------------------------------------------------------+
class CMasterWindows:public CWin
  {
private:
   long              Y_hide;          // величина сдвига окна
   long              Y_obj;           // величина сдвига окна
   long              H_obj;           // величина сдвига окна
public:
   void              CMasterWindows() {on_event=false;}
   void              Run();           // метод запуска главного модуля
   void              Hide();          // метод: свернуть окно
   void              Deinit() {ObjectsDeleteAll(0,0,-1); Comment("");}
   virtual void      OnEvent(const int id,
                             const long &lparam,
                             const double &dparam,
                             const string &sparam);
  };
//+------------------------------------------------------------------+
//| Метод Run класса CMasterWindows                                  |
//+------------------------------------------------------------------+
void CMasterWindows::Run()
  {
   ObjectsDeleteAll(0,0,-1);
   Comment("Программный код сгенерирован MasterWindows for MQL5 © DC2008");
//--- создаём главное окно и запускаем исполняемый модуль
   SetWin("test1.Exp",50,100,250,CORNER_LEFT_UPPER);
   Draw(Mint,Mstr,7);
  }
//+------------------------------------------------------------------+
//| Метод обработки события OnChartEvent класса CMasterWindows       |
//+------------------------------------------------------------------+
void CMasterWindows::OnEvent(const int id,
                             const long &lparam,
                             const double &dparam,
                             const string &sparam)
  {
   if(on_event // обработка событий разрешена
      && StringFind(sparam,"test1.Exp",0)>=0)
     {
      //--- трансляция событий OnChartEvent
      STR1.OnEvent(id,lparam,dparam,sparam);
      STR2.OnEvent(id,lparam,dparam,sparam);
      STR3.OnEvent(id,lparam,dparam,sparam);
      STR4.OnEvent(id,lparam,dparam,sparam);
      STR5.OnEvent(id,lparam,dparam,sparam);
      STR6.OnEvent(id,lparam,dparam,sparam);
      //--- создание графического объекта
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CREATE)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW1] в редакторе Edit STR1
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_ENDEDIT
         && StringFind(sparam,".STR1",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW2] : кнопка Plus STR2
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR2",0)>0
         && StringFind(sparam,".Button3",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW2] : кнопка Minus STR2
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR2",0)>0
         && StringFind(sparam,".Button4",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW3] : кнопка Plus STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button3",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW3] : кнопка Minus STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button4",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW3] : кнопка Up STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button5",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- редактирование переменных [NEW3] : кнопка Down STR3
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR3",0)>0
         && StringFind(sparam,".Button6",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- нажатие кнопки [new4] STR4
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR4",0)>0
         && StringFind(sparam,".Button",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- нажатие кнопки [NEW5] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(1)",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- нажатие кнопки [new5] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(2)",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- нажатие кнопки [] STR5
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".STR5",0)>0
         && StringFind(sparam,"(3)",0)>0)
        {
         //--- реакция на планируемое событие
        }
      //--- нажатие кнопки Close в главном окне
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".Button1",0)>0)
        {
         //--- реакция на планируемое событие
         ExpertRemove();
        }
      //--- нажатие кнопки Hide в главном окне
      if((ENUM_CHART_EVENT)id==CHARTEVENT_OBJECT_CLICK
         && StringFind(sparam,".Button0",0)>0)
        {
         //--- реакция на планируемое событие
        }
     }
  }
//--- объявление главного модуля
CMasterWindows MasterWin;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- запуск главного модуля
   MasterWin.Run();
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- деинициализация главного модуля (удаляем весь мусор)
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
//--- трансляция событий OnChartEvent в главный модуль
   MasterWin.OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
