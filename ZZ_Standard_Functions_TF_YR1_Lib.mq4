//+-----------------------------------------------------------------------------------------------+
//|                                                           ZZ_Standard_Functions_TF_YR1_Lib.mq4|
//|                                                           Copyright � Zhunko                  |
//|01.07.2007                                                 �F ZHUNKO zhunko@mail.ru            |
//+-----------------------------------------------------------------------------------------------+
//| ����� ������� ��� �� YR1.                                                                     |
//|1.���������� ����� � �� YR1.                                                                   |
//|  int iBars_YR1 (string Exchange);                                                             |
//|  iBarsYR (�������� ����);                                                                     |
//|2.����� ���� �� ������� � �� YR1.                                                              |
//|  int iBarShift_YR1 (string Exchange, datetime time, bool exact);                              |
//|  iBarShiftYR (�������� ����, �������� ������� ��� ������, ������������ �������� ���� ��� ��   |
//|               ������ (FALSE - iBarShift ���������� ���������/TRUE - iBarShift ���������� -1));|
//|3.����� �������� �� ������ ���� � �� YR1.                                                      |
//|  datetime iTime_YR1 (string Exchange, int shift);                                             | 
//|  iCloseYR (�������� ����, ����� ����);                                                        |
//|4.���� ��������.                                                                               |
//|  double iOpen_YR1 (string Exchange, int shift);                                               | 
//|  iOpenYR (�������� ����, ����� ����);                                                         |
//|5.������������ ���� ���������� ���� � �� YR1.                                                  |
//|  double iHigh_YR1 (string Exchange, int shift);                                               |
//|  iHighYR (�������� ����, ����� ����);                                                         |
//|6.����������� ���� ���������� ���� � �� YR1.                                                   |
//|  double iLow_YR1 (string Exchange, int shift);                                                |
//|  iLowYR (�������� ����, ����� ����);                                                          |
//|7.���� ��������.                                                                               |
//|  double iClose_YR1 (string Exchange, int shift);                                              |
//|  iCloseYR (�������� ����, ����� ����);                                                        |
//+-----------------------------------------------------------------------------------------------+
#property copyright "Copyright � 2006 Zhunko"
#property link      "zhunko@mail.ru"
#property library
//��������������� ������������ ������� ��� �� YR1.���������������������������������������������������������������������������������������������������������������������������������
//====���������� ����� � �� YR1.===================================================================================================================================================
int iBars_YR1 (string Exchange) // iBarsYR (�������� ����);
 {
  int iBarsMN1;     // ���������� ����� � �� MN1 �������� �����������.
  int iBarsYR1 = 0; // ���������� ����� � �� YR1.
  //----
  iBarsMN1 = iBars (Exchange, PERIOD_MN1); // ���������� ����� � �� MN1 �������� �����������.
  for (int i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  return (iBarsYR1);
 }
//=================================================================================================================================================================================
//====����� ���� �� ������� � �� YR1.==============================================================================================================================================
int iBarShift_YR1 (string Exchange, datetime time, bool exact) // iBarShiftYR (�������� ����, �������� ������� ��� ������, ������������ �������� ���� ��� �� ������ (FALSE - iBarShift ���������� ���������/TRUE - iBarShift ���������� -1);
 {
  bool     Coincidence = false;
  datetime iTimeMN1_0;   // ����� �������� �������� ���� �� MN1.
  datetime iTimeMN1_1;   // ����� �������� ����������� ���� �� MN1.
  int      i;
  int      iBarsYR1 = 0; // ���������� ����� � �� YR1.
  int      iBarsMN1;     // ���������� ����� � �� MN1 �������� �����������.
  int      FirstYear;    // ������ ��� ������ ������� ����.  
  int      ShiftYR1 = 0; // ������������ ��������.
  //----
  iBarsMN1 = iBars (Exchange, PERIOD_MN1);                       // ���������� ����� � �� MN1 �������� �����������.
  FirstYear = StrToInteger (StringSubstr (TimeToStr (iTime (Exchange, PERIOD_MN1, iBarsMN1 - 1), TIME_DATE), 0, 4)); // ������ ��� ������ ������� ����.
  if (TimeYear (time) < FirstYear || Year() < TimeYear (time))   // ��� �������� ������� �� ������, ��� ��������� ������� �� ��������� ������� ������� ������ ������� ��� ������� �������� ����. 
   {
    if (exact == false)                                          // ���� ������������� ���������, �� ���������� ����� ���������� ���� (����� ������� ���� � �������).
     {
      if (TimeYear (time) < FirstYear) ShiftYR1 = Year() - FirstYear; // ���� ������� ����� ������, ��� ����� ������ �������, �� ����������� ����� ���� ������ �������.
      if (TimeYear (time) > Year()) ShiftYR1 = 0;                // ���� ������� ����� ������, ��� ����� ����� �������, �� ����������� ����� ���� ����� �������.
     }
    else ShiftYR1 = -1;                                          // ���� ������������� ���������, �� ���������� -1 � ������ ���������� ����.
   }
  else                                                           // ���� ������� ����� ������ ��� ����� ������� ������ �������, �� ��������� ������� ����� �� ���������� � �������� ��������.
   {
    if (exact == true)                                           // ���� ������������� ���������, �� ���������� -1 � ������ ���������� ����.
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) ShiftYR1++;
        if (TimeYear (time) == TimeYear (iTime (Exchange, PERIOD_MN1, i))) // ������� �� ����� �� ������� ��������� �������� ��������� ��������� � �����.
         {
          Coincidence = true;
          break;
         }
       }
      if (Coincidence == false) ShiftYR1 = -1;                   // ���� ���������� � ����� �� ���������, ���������� -1.
     }
    else                                                         // ���� ������������� ���������, �� ���������� ��������� �� ���� ����� (����������) ���.
     {
      // ���������� ����� � �� YR1.
      for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
      ShiftYR1 = -1;
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)
         {
          ShiftYR1++;
          if (ShiftYR1 == 0)                                     // ����������� ������� ��� ������� ���� � �������.
           {
            if (TimeYear (time) == TimeYear (iTimeMN1_0)) break; // ������� �� ����� �� ������� ��������� �������� ��������� ��������� � �����.
            else
             {
              if (TimeYear (iTimeMN1_1) < TimeYear (time))       // �� ��������� �� ���������� ���.
               {
                ShiftYR1++;                                      // ���������� ���������� ���, ��������������� �������� ����.
                break;
               }
             }
           }
          if (0 < ShiftYR1 && ShiftYR1 < iBarsYR1)               // ��������� ������� ������� "������" ��� �� ������� � �� ���������� ���� � �������.
           {
            if (TimeYear (time) == TimeYear (iTimeMN1_0)) break; // ������� �� ����� �� ������� ��������� �������� ��������� ��������� � �����.
            else                                                 // ���� ������� ��� �� ����� ���������, �� ��������� �� ���������� ����.
             {
              if (TimeYear (iTimeMN1_1) < TimeYear (time) && TimeYear (time) < TimeYear (iTimeMN1_0))
               {
                ShiftYR1++;                                      // ���������� ���������� ���, ��������������� �������� ����.
                break;
               }
             }
           }
          if (ShiftYR1 == iBarsYR1) break;                       // ���� ��� ���������, �� ���������� ������� ���, ��������������� �������� ����.
         }
       }
     }
   }
  return (ShiftYR1);
 }
//=================================================================================================================================================================================
//====����� �������� �� ������ ���� � �� YR1.======================================================================================================================================
datetime iTime_YR1 (string Exchange, int shift) // iCloseYR (�������� ����, ����� ����);
 {
  datetime TimeYR;        // ������������ ��������.
  int      i;
  int      iBarsYR1;      // ���������� ����� � ������� ��.
  int      ShiftYR1 = -1; // ������� ����� ���� �� YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                     // ���������� ����� � �� MN1 �������� �����������.
  // ���������� ����� � �� YR1 �������� �����������.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) TimeYR = 0;                               // ���������� ���� � ������ ������.
  else
   {
    for (i = 0; i < iBarsMN1; i++)
     {
      datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // ����� �������� �������� ���� �� MN1.
      datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // ����� �������� ����������� ���� �� MN1.
      if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����.
       {
        ShiftYR1++;
        if (shift == ShiftYR1)
         {
          TimeYR = iTimeMN1_0;
          break;
         }
       }
     }
   }
  return (TimeYR);
 }
//=================================================================================================================================================================================
//====���� ��������.===============================================================================================================================================================
double iOpen_YR1 (string Exchange, int shift) // iOpenYR (�������� ����, ����� ����);
 {
  double   OpenYR;        // ������������ ��������.
  int      i;
  int      iBarsYR1;      // ���������� ����� � ������� ��.
  int      ShiftYR1 = -1; // ������� ����� ���� �� YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                     // ���������� ����� � �� MN1 �������� �����������.
  // ���������� ����� � �� YR1 �������� �����������.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) OpenYR = 0;                               // ���������� ���� � ������ ������.
  else
   {
    for (i = 0; i < iBarsMN1; i++)
     {
      datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // ����� �������� �������� ���� �� MN1.
      datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // ����� �������� ����������� ���� �� MN1.
      if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����.
       {
        ShiftYR1++;
        if (shift == ShiftYR1) OpenYR = iOpen (Exchange, PERIOD_MN1, i);
       }
     }
   }
  return (OpenYR);
 }
//=================================================================================================================================================================================
//====������������ ���� ���������� ���� � �� YR1.==================================================================================================================================
double iHigh_YR1 (string Exchange, int shift) // iHighYR (�������� ����, ����� ����);
 {
  bool     Break = false;
  datetime iTimeMN1_0;
  datetime iTimeMN1_1;
  double   ArrayHighMN1[12]; // ����������� ������.
  double   HighYR;           // ������������ ��������.
  int      count = -1;       // ���������� ��������� ��� ������.
  int      iBarsYR1;         // ���������� ����� � ������� ��.
  int      i, j;
  int      ShiftYR1 = 0;     // ������� ����� ���� �� YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                             // ���������� ����� � �� MN1 �������� �����������.
  // ���������� ����� � �� YR1 �������� �����������.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) HighYR = 0;                                       // ���������� ���� � ������ ������.
  else
   {
    if (shift == 0)                                                                        // ���� ��� �������, �� ������� ����������� ��������.
     {
      for (j = 0; j < 12; j++)
       {
        count++;                                                                           // ������� �������� �����.
        ArrayHighMN1[count] = iHigh (Exchange, PERIOD_MN1, j);
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                      // ����� �������� �������� ���� �� MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                                  // ����� �������� ����������� ���� �� MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) break;// ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
       }
     }
    if (0 < shift || shift < iBarsMN1 - 1)
     {  
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                                      // ����� �������� �������� ���� �� MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                                  // ����� �������� ����������� ���� �� MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)       // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
         {
          ShiftYR1++;
          if (shift == ShiftYR1)
           {
            for (j = i + 1; j < i + 13; j++)
             {
              count++;                                                                     // ������� �������� �����.
              ArrayHighMN1[count] = iHigh (Exchange, PERIOD_MN1, j);
              iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                // ����� �������� �������� ���� �� MN1.
              iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                            // ����� �������� ����������� ���� �� MN1.
              if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
               {
                Break = true;
                break;
               }
             }
            if (Break == true) break;
           }
         }
       }
     }
    HighYR = ArrayHighMN1[ArrayMaximum (ArrayHighMN1, count + 1, 0)];                      // ���� ������������ ��������     
   }
//  Comment ("ArrayHighMN1[", count + 1, "] = {", ArrayHighMN1[0], ", ", ArrayHighMN1[1], ", ", ArrayHighMN1[2], ", ", ArrayHighMN1[3], ", ", ArrayHighMN1[4], ", ", ArrayHighMN1[5], ", ", ArrayHighMN1[6], ", ", ArrayHighMN1[7], ", ", ArrayHighMN1[8], ", ", ArrayHighMN1[9], ", ", ArrayHighMN1[10], ", ", ArrayHighMN1[11], "};");
  return (HighYR);
 }
//=================================================================================================================================================================================
//====����������� ���� ���������� ���� � �� YR1.===================================================================================================================================
double iLow_YR1 (string Exchange, int shift) // iLowYR (�������� ����, ����� ����);
 {
  bool     Break = false;
  datetime iTimeMN1_0;
  datetime iTimeMN1_1;
  double   ArrayLowMN1[12]; // ����������� ������.
  double   LowYR;           // ������������ ��������.
  int      count = -1;      // ���������� ��������� ��� ������.
  int      iBarsYR1;         // ���������� ����� � ������� ��.
  int      i, j;
  int      ShiftYR1 = 0;    // ������� ����� ���� �� YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                             // ���������� ����� � �� MN1 �������� �����������.
  // ���������� ����� � �� YR1 �������� �����������.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) LowYR = 0;                                        // ���������� ���� � ������ ������.
  else
   {
    if (shift == 0)                                                                        // ���� ��� �������, �� ������� ����������� ��������.
     {
      for (j = 0; j < 12; j++)
       {
        count++;                                                                           // ������� �������� �����.
        ArrayLowMN1[count] = iLow (Exchange, PERIOD_MN1, j);
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                      // ����� �������� �������� ���� �� MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                                  // ����� �������� ����������� ���� �� MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) break;// ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
       }
     }
    if (0 < shift || shift < iBarsMN1 - 1)
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                                      // ����� �������� �������� ���� �� MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                                  // ����� �������� ����������� ���� �� MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)       // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
         {
          ShiftYR1++;
          if (shift == ShiftYR1)
           {
            for (j = i + 1; j < i + 13; j++)
             {
              count++;                                                                     // ������� �������� �����.
              ArrayLowMN1[count] = iLow (Exchange, PERIOD_MN1, j);
              iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                // ����� �������� �������� ���� �� MN1.
              iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                            // ����� �������� ����������� ���� �� MN1.
              if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����. ������������� �����.
               {
                Break = true;
                break;
               }
             }
            if (Break == true) break;
           }
         }
       }
     }
    LowYR = ArrayLowMN1[ArrayMinimum (ArrayLowMN1, count + 1, 0)];                         // ���� ������������ ��������     
   }
//  Comment ("ArrayLowMN1[", count + 1, "] = {", ArrayLowMN1[0], ", ", ArrayLowMN1[1], ", ", ArrayLowMN1[2], ", ", ArrayLowMN1[3], ", ", ArrayLowMN1[4], ", ", ArrayLowMN1[5], ", ", ArrayLowMN1[6], ", ", ArrayLowMN1[7], ", ", ArrayLowMN1[8], ", ", ArrayLowMN1[9], ", ", ArrayLowMN1[10], ", ", ArrayLowMN1[11], "};");
  return (LowYR);
 }
//=================================================================================================================================================================================
//====���� ��������.===============================================================================================================================================================
double iClose_YR1 (string Exchange, int shift) // iCloseYR (�������� ����, ����� ����);
 {
  double CloseYR;      // ������������ ��������.
  int    i;
  int    iBarsYR1;     // ���������� ����� � ������� ��.
  int    ShiftYR1 = 0; // ������� ����� ���� �� YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                       // ���������� ����� � �� MN1 �������� �����������.
  // ���������� ����� � �� YR1 �������� �����������.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) CloseYR = 0;                                // ���������� ���� � ������ ������.
  else
   {
    if (shift == 0) CloseYR = iClose (Exchange, PERIOD_MN1, 0);                      // ���� ��� �������, �� ���� �������� �������� ���� ����� ���� �������� ��������� ����.
    else                                                                             // ���� ��� �� �������, ���� � ����� ������������ ���� ������� �������� �������� �����.
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // ����� �������� �������� ���� �� MN1.
        datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // ����� �������� ����������� ���� �� MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // ���� ������� �� ����� ����, �� ���� ��������� � ������ �����.
         {
          ShiftYR1++;
          if (shift == ShiftYR1) CloseYR = iClose (Exchange, PERIOD_MN1, i + 1);
         }
       }
     }
   }
  return (CloseYR);
 }
//=================================================================================================================================================================================
//���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������

//+------------------------------------------------------------------+
//|                                          ZZ_Check TF YR1.mq4     |
//|                                          Copyright � Zhunko      |
//|01.07.2007                                �F ZHUNKO zhunko@mail.ru|
//+------------------------------------------------------------------+
//|��������� ��� �������� ������� ��� �� YR1 �� ����������           |
//|"ZZ_Standard_Functions_TF_YR1_Lib.ex4"                            |
//+------------------------------------------------------------------+
/*#property copyright "Copyright � 2006 Zhunko"
#property link      "zhunko@mail.ru"
//----
#property indicator_chart_window
#import "ZZ_Standard_Functions_TF_YR1_Lib.ex4"
// ���������� ����� � �� YR1.
  int iBars_YR1 (string Exchange);                                // iBars_YR (�������� ����);
// ����� ���� �� ������� � �� YR1.
  int iBarShift_YR1 (string Exchange, datetime time, bool exact); // iBarShift_YR (�������� ����, �������� ������� ��� ������, ������������ �������� ���� ��� �� ������ (FALSE - iBarShift ���������� ���������/TRUE - iBarShift ���������� -1));|
// ����� �������� �� ������ ���� � �� YR1.
  datetime iTime_YR1 (string Exchange, int shift);                // iTime_YR (�������� ����, ����� ����);   
// ���� ��������.
  double iOpen_YR1 (string Exchange, int shift);                  // iOpen_YR (�������� ����, ����� ����);
// ������������ ���� ���������� ���� � �� YR1.
  double iHigh_YR1 (string Exchange, int shift);                  // iHigh_YR (�������� ����, ����� ����);
// ����������� ���� ���������� ���� � �� YR1.
  double iLow_YR1 (string Exchange, int shift);                   // iLow_YR (�������� ����, ����� ����);
// ���� ��������.
  double iClose_YR1 (string Exchange, int shift);                 // iClose_YR (�������� ����, ����� ����);
#import
//====
extern int    Number_Bar = 40;
extern string TimeYR1    = "2006.01.01 00:00";
extern bool   Exact      = false;
//====
string ArrayTimfram_str[9] = {"M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN1"};
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
 {
  int      iBarsYR1 = iBars_YR1 (Symbol());
  int      iBarShiftYR1 = iBarShift_YR1 (Symbol(), StrToTime (TimeYR1), Exact);
  datetime iTimeYR = iTime_YR1 (Symbol(), Number_Bar);
  double   iOpenYR1 = iOpen_YR1 (Symbol(), Number_Bar);
  double   iHighYR1 = iHigh_YR1 (Symbol(), Number_Bar);
  double   iLowYR1 = iLow_YR1 (Symbol(), Number_Bar);
  double   iCloseYR1 = iClose_YR1 (Symbol(), Number_Bar);
  string   TF;
  //----
  if (Period() ==     1) TF = ArrayTimfram_str[0];
  if (Period() ==     5) TF = ArrayTimfram_str[1];
  if (Period() ==    15) TF = ArrayTimfram_str[2];
  if (Period() ==    30) TF = ArrayTimfram_str[3];
  if (Period() ==    60) TF = ArrayTimfram_str[4];
  if (Period() ==   240) TF = ArrayTimfram_str[5];
  if (Period() ==  1440) TF = ArrayTimfram_str[6];
  if (Period() == 10080) TF = ArrayTimfram_str[7];
  if (Period() == 43200) TF = ArrayTimfram_str[8];
  
  Comment ("���������� ", Symbol(), " ", TF,
           "\n���������� ����� = ", iBarsYR1,
           "\n����� ���� �� ������� = ", iBarShiftYR1, " (", TimeYR1, ")",
           "\n����� �������� �� ������ ���� = ", TimeToStr (iTimeYR, TIME_DATE|TIME_MINUTES), " (", Number_Bar, ")",
           "\n���� �������� = ", iOpenYR1, "(", Number_Bar, ")",
           "\n������������ ���� = ", iHighYR1, "(", Number_Bar, ")",
           "\n����������� ���� = ", iLowYR1, "(", Number_Bar, ")",
           "\n���� �������� = ", iCloseYR1, "(", Number_Bar, ")");
//  iHighYR1 = iHigh_YR1 (Symbol(), Number_Bar);
//  iLow_YR1 (Symbol(), Number_Bar);
  return(0);
 }*/
//===================================================================================================================