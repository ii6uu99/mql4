//+-----------------------------------------------------------------------------------------------+
//|                                                           ZZ_Standard_Functions_TF_YR1_Lib.mq4|
//|                                                           Copyright © Zhunko                  |
//|01.07.2007                                                 МF ZHUNKO zhunko@mail.ru            |
//+-----------------------------------------------------------------------------------------------+
//| Набор функций для ТФ YR1.                                                                     |
//|1.Количество баров в ТФ YR1.                                                                   |
//|  int iBars_YR1 (string Exchange);                                                             |
//|  iBarsYR (валютная пара);                                                                     |
//|2.Номер бара по времени в ТФ YR1.                                                              |
//|  int iBarShift_YR1 (string Exchange, datetime time, bool exact);                              |
//|  iBarShiftYR (валютная пара, значение времени для поиска, возвращаемое значение если бар не   |
//|               найден (FALSE - iBarShift возвращает ближайший/TRUE - iBarShift возвращает -1));|
//|3.Время открытия по номеру бара в ТФ YR1.                                                      |
//|  datetime iTime_YR1 (string Exchange, int shift);                                             | 
//|  iCloseYR (валютная пара, номер бара);                                                        |
//|4.Цена открытия.                                                                               |
//|  double iOpen_YR1 (string Exchange, int shift);                                               | 
//|  iOpenYR (валютная пара, номер бара);                                                         |
//|5.Максимальная цена выбранного бара в ТФ YR1.                                                  |
//|  double iHigh_YR1 (string Exchange, int shift);                                               |
//|  iHighYR (валютная пара, номер бара);                                                         |
//|6.Минимальная цена выбранного бара в ТФ YR1.                                                   |
//|  double iLow_YR1 (string Exchange, int shift);                                                |
//|  iLowYR (валютная пара, номер бара);                                                          |
//|7.Цена закрытия.                                                                               |
//|  double iClose_YR1 (string Exchange, int shift);                                              |
//|  iCloseYR (валютная пара, номер бара);                                                        |
//+-----------------------------------------------------------------------------------------------+
#property copyright "Copyright © 2006 Zhunko"
#property link      "zhunko@mail.ru"
#property library
//жжжжСтандардные библиотечные функции для ТФ YR1.жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//====Количество баров в ТФ YR1.===================================================================================================================================================
int iBars_YR1 (string Exchange) // iBarsYR (валютная пара);
 {
  int iBarsMN1;     // Количество баров в ТФ MN1 текущего инструмента.
  int iBarsYR1 = 0; // Количество баров в ТФ YR1.
  //----
  iBarsMN1 = iBars (Exchange, PERIOD_MN1); // Количество баров в ТФ MN1 текущего инструмента.
  for (int i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  return (iBarsYR1);
 }
//=================================================================================================================================================================================
//====Номер бара по времени в ТФ YR1.==============================================================================================================================================
int iBarShift_YR1 (string Exchange, datetime time, bool exact) // iBarShiftYR (валютная пара, значение времени для поиска, возвращаемое значение если бар не найден (FALSE - iBarShift возвращает ближайший/TRUE - iBarShift возвращает -1);
 {
  bool     Coincidence = false;
  datetime iTimeMN1_0;   // Время открытия текущего бара на MN1.
  datetime iTimeMN1_1;   // Время открытия предыдущего бара на MN1.
  int      i;
  int      iBarsYR1 = 0; // Количество баров в ТФ YR1.
  int      iBarsMN1;     // Количество баров в ТФ MN1 текущего инструмента.
  int      FirstYear;    // Первый год начала истории пары.  
  int      ShiftYR1 = 0; // Возвращаемое значение.
  //----
  iBarsMN1 = iBars (Exchange, PERIOD_MN1);                       // Количество баров в ТФ MN1 текущего инструмента.
  FirstYear = StrToInteger (StringSubstr (TimeToStr (iTime (Exchange, PERIOD_MN1, iBarsMN1 - 1), TIME_DATE), 0, 4)); // Первый год начала истории пары.
  if (TimeYear (time) < FirstYear || Year() < TimeYear (time))   // Для экономии времени на циклах, при выбранном времени со значением меньшем времени начала истории или большем текущего года. 
   {
    if (exact == false)                                          // Если переключатель запрещает, то возвращаем номер ближайшего бара (номер первого бара в истории).
     {
      if (TimeYear (time) < FirstYear) ShiftYR1 = Year() - FirstYear; // Если входное время меньше, чем время начало истории, то возвращаемм номер бара начала истории.
      if (TimeYear (time) > Year()) ShiftYR1 = 0;                // Если входное время больше, чем время конца истории, то возвращаемм номер бара конца истории.
     }
    else ShiftYR1 = -1;                                          // Если переключатель разрешает, то возвращаем -1 в случае отсутствия бара.
   }
  else                                                           // Если входное время больше или равно времени начала истории, то проверяем входное время на совпадение с месячной историей.
   {
    if (exact == true)                                           // Если переключатель разрешает, то возвращаем -1 в случае отсутствия бара.
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) ShiftYR1++;
        if (TimeYear (time) == TimeYear (iTime (Exchange, PERIOD_MN1, i))) // Выходим из цикла по условию равенства входного параметра найденому в цикле.
         {
          Coincidence = true;
          break;
         }
       }
      if (Coincidence == false) ShiftYR1 = -1;                   // Если совпадения в цикле не произошло, возвращаем -1.
     }
    else                                                         // Если переключатель запрещает, то возвращаем ближайший по ходу цикла (предыдущий) бар.
     {
      // Количество баров в ТФ YR1.
      for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
      ShiftYR1 = -1;
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)
         {
          ShiftYR1++;
          if (ShiftYR1 == 0)                                     // Специальные условия для первого бара в истории.
           {
            if (TimeYear (time) == TimeYear (iTimeMN1_0)) break; // Выходим из цикла по условию равенства входного параметра найденому в цикле.
            else
             {
              if (TimeYear (iTimeMN1_1) < TimeYear (time))       // Не проверяем на последущий бар.
               {
                ShiftYR1++;                                      // Возвращаем предыдущий бар, соответствующий младшему году.
                break;
               }
             }
           }
          if (0 < ShiftYR1 && ShiftYR1 < iBarsYR1)               // Применяем обычные условия "ворота" для не первого и не последнего года в истории.
           {
            if (TimeYear (time) == TimeYear (iTimeMN1_0)) break; // Выходим из цикла по условию равенства входного параметра найденому в цикле.
            else                                                 // Если искомый год не равен найденому, то проверяем на отсутствие бара.
             {
              if (TimeYear (iTimeMN1_1) < TimeYear (time) && TimeYear (time) < TimeYear (iTimeMN1_0))
               {
                ShiftYR1++;                                      // Возвращаем предыдущий бар, соответствующий младшему году.
                break;
               }
             }
           }
          if (ShiftYR1 == iBarsYR1) break;                       // Если бар последний, то возвращаем текущий бар, соответствующий младшему году.
         }
       }
     }
   }
  return (ShiftYR1);
 }
//=================================================================================================================================================================================
//====Время открытия по номеру бара в ТФ YR1.======================================================================================================================================
datetime iTime_YR1 (string Exchange, int shift) // iCloseYR (валютная пара, номер бара);
 {
  datetime TimeYR;        // Возвращаемое значение.
  int      i;
  int      iBarsYR1;      // Количество баров в годовом ТФ.
  int      ShiftYR1 = -1; // Текущий номер бара ТФ YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                     // Количество баров в ТФ MN1 текущего инструмента.
  // Количество баров в ТФ YR1 текущего инструмента.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) TimeYR = 0;                               // Возвращаем ноль в случае ошибки.
  else
   {
    for (i = 0; i < iBarsMN1; i++)
     {
      datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // Время открытия текущего бара на MN1.
      datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // Время открытия предыдущего бара на MN1.
      if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // Если остаток не равен нулю, то бары находятся в разных годах.
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
//====Цена открытия.===============================================================================================================================================================
double iOpen_YR1 (string Exchange, int shift) // iOpenYR (валютная пара, номер бара);
 {
  double   OpenYR;        // Возвращаемое значение.
  int      i;
  int      iBarsYR1;      // Количество баров в годовом ТФ.
  int      ShiftYR1 = -1; // Текущий номер бара ТФ YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                     // Количество баров в ТФ MN1 текущего инструмента.
  // Количество баров в ТФ YR1 текущего инструмента.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) OpenYR = 0;                               // Возвращаем ноль в случае ошибки.
  else
   {
    for (i = 0; i < iBarsMN1; i++)
     {
      datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // Время открытия текущего бара на MN1.
      datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // Время открытия предыдущего бара на MN1.
      if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // Если остаток не равен нулю, то бары находятся в разных годах.
       {
        ShiftYR1++;
        if (shift == ShiftYR1) OpenYR = iOpen (Exchange, PERIOD_MN1, i);
       }
     }
   }
  return (OpenYR);
 }
//=================================================================================================================================================================================
//====Максимальная цена выбранного бара в ТФ YR1.==================================================================================================================================
double iHigh_YR1 (string Exchange, int shift) // iHighYR (валютная пара, номер бара);
 {
  bool     Break = false;
  datetime iTimeMN1_0;
  datetime iTimeMN1_1;
  double   ArrayHighMN1[12]; // Технический массив.
  double   HighYR;           // Возвращаемое значение.
  int      count = -1;       // Количество элементов для поиска.
  int      iBarsYR1;         // Количество баров в годовом ТФ.
  int      i, j;
  int      ShiftYR1 = 0;     // Текущий номер бара ТФ YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                             // Количество баров в ТФ MN1 текущего инструмента.
  // Количество баров в ТФ YR1 текущего инструмента.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) HighYR = 0;                                       // Возвращаем ноль в случае ошибки.
  else
   {
    if (shift == 0)                                                                        // Если бар нулевой, то считаем упорощённым способом.
     {
      for (j = 0; j < 12; j++)
       {
        count++;                                                                           // Счётчик значимых баров.
        ArrayHighMN1[count] = iHigh (Exchange, PERIOD_MN1, j);
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                      // Время открытия текущего бара на MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                                  // Время открытия предыдущего бара на MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) break;// Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
       }
     }
    if (0 < shift || shift < iBarsMN1 - 1)
     {  
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                                      // Время открытия текущего бара на MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                                  // Время открытия предыдущего бара на MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)       // Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
         {
          ShiftYR1++;
          if (shift == ShiftYR1)
           {
            for (j = i + 1; j < i + 13; j++)
             {
              count++;                                                                     // Счётчик значимых баров.
              ArrayHighMN1[count] = iHigh (Exchange, PERIOD_MN1, j);
              iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                // Время открытия текущего бара на MN1.
              iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                            // Время открытия предыдущего бара на MN1.
              if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
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
    HighYR = ArrayHighMN1[ArrayMaximum (ArrayHighMN1, count + 1, 0)];                      // Ищим максимальное значение     
   }
//  Comment ("ArrayHighMN1[", count + 1, "] = {", ArrayHighMN1[0], ", ", ArrayHighMN1[1], ", ", ArrayHighMN1[2], ", ", ArrayHighMN1[3], ", ", ArrayHighMN1[4], ", ", ArrayHighMN1[5], ", ", ArrayHighMN1[6], ", ", ArrayHighMN1[7], ", ", ArrayHighMN1[8], ", ", ArrayHighMN1[9], ", ", ArrayHighMN1[10], ", ", ArrayHighMN1[11], "};");
  return (HighYR);
 }
//=================================================================================================================================================================================
//====Минимальная цена выбранного бара в ТФ YR1.===================================================================================================================================
double iLow_YR1 (string Exchange, int shift) // iLowYR (валютная пара, номер бара);
 {
  bool     Break = false;
  datetime iTimeMN1_0;
  datetime iTimeMN1_1;
  double   ArrayLowMN1[12]; // Технический массив.
  double   LowYR;           // Возвращаемое значение.
  int      count = -1;      // Количество элементов для поиска.
  int      iBarsYR1;         // Количество баров в годовом ТФ.
  int      i, j;
  int      ShiftYR1 = 0;    // Текущий номер бара ТФ YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                             // Количество баров в ТФ MN1 текущего инструмента.
  // Количество баров в ТФ YR1 текущего инструмента.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) LowYR = 0;                                        // Возвращаем ноль в случае ошибки.
  else
   {
    if (shift == 0)                                                                        // Если бар нулевой, то считаем упорощённым способом.
     {
      for (j = 0; j < 12; j++)
       {
        count++;                                                                           // Счётчик значимых баров.
        ArrayLowMN1[count] = iLow (Exchange, PERIOD_MN1, j);
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                      // Время открытия текущего бара на MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                                  // Время открытия предыдущего бара на MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) break;// Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
       }
     }
    if (0 < shift || shift < iBarsMN1 - 1)
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                                      // Время открытия текущего бара на MN1.
        iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                                  // Время открытия предыдущего бара на MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0)       // Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
         {
          ShiftYR1++;
          if (shift == ShiftYR1)
           {
            for (j = i + 1; j < i + 13; j++)
             {
              count++;                                                                     // Счётчик значимых баров.
              ArrayLowMN1[count] = iLow (Exchange, PERIOD_MN1, j);
              iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, j);                                // Время открытия текущего бара на MN1.
              iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, j + 1);                            // Время открытия предыдущего бара на MN1.
              if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // Если остаток не равен нулю, то бары находятся в разных годах. Останавливаем поиск.
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
    LowYR = ArrayLowMN1[ArrayMinimum (ArrayLowMN1, count + 1, 0)];                         // Ищим максимальное значение     
   }
//  Comment ("ArrayLowMN1[", count + 1, "] = {", ArrayLowMN1[0], ", ", ArrayLowMN1[1], ", ", ArrayLowMN1[2], ", ", ArrayLowMN1[3], ", ", ArrayLowMN1[4], ", ", ArrayLowMN1[5], ", ", ArrayLowMN1[6], ", ", ArrayLowMN1[7], ", ", ArrayLowMN1[8], ", ", ArrayLowMN1[9], ", ", ArrayLowMN1[10], ", ", ArrayLowMN1[11], "};");
  return (LowYR);
 }
//=================================================================================================================================================================================
//====Цена закрытия.===============================================================================================================================================================
double iClose_YR1 (string Exchange, int shift) // iCloseYR (валютная пара, номер бара);
 {
  double CloseYR;      // Возвращаемое значение.
  int    i;
  int    iBarsYR1;     // Количество баров в годовом ТФ.
  int    ShiftYR1 = 0; // Текущий номер бара ТФ YR1.
  //----
  int iBarsMN1 = iBars (Exchange, PERIOD_MN1);                                       // Количество баров в ТФ MN1 текущего инструмента.
  // Количество баров в ТФ YR1 текущего инструмента.
  for (i = 0; i < iBarsMN1; i++) if (MathMod (TimeYear (1.0 * iTime (Exchange, PERIOD_MN1, i)), 1.0 * TimeYear (iTime (Exchange, PERIOD_MN1, i + 1))) != 0) iBarsYR1++;
  if (0 > shift || shift > iBarsYR1 - 1) CloseYR = 0;                                // Возвращаем ноль в случае ошибки.
  else
   {
    if (shift == 0) CloseYR = iClose (Exchange, PERIOD_MN1, 0);                      // Если бар нулевой, то цена закрытия годового бара равна цене закрытия месячного бара.
    else                                                                             // Если бар не нулевой, ищем в цикле несовпадения года времени открытия соседних баров.
     {
      for (i = 0; i < iBarsMN1; i++)
       {
        datetime iTimeMN1_0 = iTime (Exchange, PERIOD_MN1, i);                       // Время открытия текущего бара на MN1.
        datetime iTimeMN1_1 = iTime (Exchange, PERIOD_MN1, i + 1);                   // Время открытия предыдущего бара на MN1.
        if (MathMod (TimeYear (1.0 * iTimeMN1_0), 1.0 * TimeYear (iTimeMN1_1)) != 0) // Если остаток не равен нулю, то бары находятся в разных годах.
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
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//+------------------------------------------------------------------+
//|                                          ZZ_Check TF YR1.mq4     |
//|                                          Copyright © Zhunko      |
//|01.07.2007                                МF ZHUNKO zhunko@mail.ru|
//+------------------------------------------------------------------+
//|ИНДИКАТОР ДЛЯ КОНТРОЛЯ ФУНКЦИЙ ДЛЯ ТФ YR1 из библиотеки           |
//|"ZZ_Standard_Functions_TF_YR1_Lib.ex4"                            |
//+------------------------------------------------------------------+
/*#property copyright "Copyright © 2006 Zhunko"
#property link      "zhunko@mail.ru"
//----
#property indicator_chart_window
#import "ZZ_Standard_Functions_TF_YR1_Lib.ex4"
// Количество баров в ТФ YR1.
  int iBars_YR1 (string Exchange);                                // iBars_YR (валютная пара);
// Номер бара по времени в ТФ YR1.
  int iBarShift_YR1 (string Exchange, datetime time, bool exact); // iBarShift_YR (валютная пара, значение времени для поиска, возвращаемое значение если бар не найден (FALSE - iBarShift возвращает ближайший/TRUE - iBarShift возвращает -1));|
// Время открытия по номеру бара в ТФ YR1.
  datetime iTime_YR1 (string Exchange, int shift);                // iTime_YR (валютная пара, номер бара);   
// Цена открытия.
  double iOpen_YR1 (string Exchange, int shift);                  // iOpen_YR (валютная пара, номер бара);
// Максимальная цена выбранного бара в ТФ YR1.
  double iHigh_YR1 (string Exchange, int shift);                  // iHigh_YR (валютная пара, номер бара);
// Минимальная цена выбранного бара в ТФ YR1.
  double iLow_YR1 (string Exchange, int shift);                   // iLow_YR (валютная пара, номер бара);
// Цена закрытия.
  double iClose_YR1 (string Exchange, int shift);                 // iClose_YR (валютная пара, номер бара);
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
  
  Comment ("Инструмент ", Symbol(), " ", TF,
           "\nКоличество баров = ", iBarsYR1,
           "\nНомер бара по времени = ", iBarShiftYR1, " (", TimeYR1, ")",
           "\nВремя открытия по номеру бара = ", TimeToStr (iTimeYR, TIME_DATE|TIME_MINUTES), " (", Number_Bar, ")",
           "\nЦена открытия = ", iOpenYR1, "(", Number_Bar, ")",
           "\nМаксимальная цена = ", iHighYR1, "(", Number_Bar, ")",
           "\nМинимальная цена = ", iLowYR1, "(", Number_Bar, ")",
           "\nЦена закрытия = ", iCloseYR1, "(", Number_Bar, ")");
//  iHighYR1 = iHigh_YR1 (Symbol(), Number_Bar);
//  iLow_YR1 (Symbol(), Number_Bar);
  return(0);
 }*/
//===================================================================================================================