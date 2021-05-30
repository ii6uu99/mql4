//+------------------------------------------------------------------+
//|														 				lot_lib.mqh |
//|                                      Copyright © 2005, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
//#property copyright "Copyright © 2005, komposter"
//#property link      "mailto:komposterius@mail.ru"

extern string 		LotSize_Properties 			= "-------LotSize-Properties------";
extern int 			LotSizeVariant					= 0;
extern double 		StartLot 						= 0.1;
extern double 		AddLot							= 0.1;
extern double 		KLot								= 2;
extern double 		MaxRisk							= 5;
extern double		TrueProfitPoints				= 0.0;
extern double 		BalanceUse						= 100;

/*
Использование:
- скачиваем lot_lib.mqh в папку MetaTrader 4\experts\include
- в эксперта добавляем следующие строки:

// в самом начале:
#include <lot_lib.mqh>
 
// в ф-цию init():
    lotlib_PrevLots = 0.0;  lotlib_PrevProfit = 0.0;
 
// в функцию start(), _перед_каждой_ установкой ордера:
    lotlib_OpenPriceLevel = Ask; // вместо Ask - реальное значение уровня открытия позиции 
    lotlib_StopLossLevel = Ask-StopLoss*Point; // вместо Ask-StopLoss*Point - реальное значение уровня СтопЛосса позиции
 
// в функцию start(), туда, где выбрана открытая позиция (например, перед трейлинг-стопом):
         lotlib_PrevLots = OrderLots();  lotlib_PrevProfit = OrderProfit();
- размер лота при установке ордера определяем функцией Lot(). Т.е. просто вместо переменной, определяющей размер лота (обычно Lot или Lots) пишем Lot().
- компилируем эксперта и пользуемся =)

Примечание: если эксперт держит открытыми одновременно 2 и больше позиций, переменным lotlib_PrevLots и lotlib_PrevProfit необходимо дополнительно присваивать нужные значения перед открытием новой позиции. Выбрать, какие значения присваивать (последней закрытой позиции или последней открытой) вам придётся самостоятельно ;)

Внешние переменные:
- LotSizeVariant - № варианта, будет описано ниже
- StartLot - начальный размер лота (для LotSizeVariant 0-5)
- AddLot - размер "прибавки" лота (для LotSizeVariant 1 и 2)
- KLot - коэфициент прибавки (для LotSizeVariant 3 и 4)
- MaxRisk - % от депозита, которым можно рисковать (для LotSizeVariant 5, 6, 11-17, 31-37)
- TrueProfitPoints - сумма (в пунктах), больше которой прибыль позиции будет считаться прибылью (меньше которой будет считаться убытком). (для LotSizeVariant 1-4)
- BalanceUse - Процент баланса, который будет задействован экспертом. Если планируется торговать одновременно несколькими экспертами, установите 100/"кол-во экспертов" (т.е. для 3-х экспертов 33, для 4-х - 25, и т.д.) (для LotSizeVariant 5, 6, 7, 11-17, 31-37)

Возможные значения LotSizeVariant:
0 - фиксированный размер лота (задаётся переменной StartLot)
1 - если предыдущая позиция прибыльная (прибыль больше TrueProfitPoints пунктов), размер лота увеличивается на AddLot (или уменьшается, если AddLot меньше 0), если убыточная (прибыль меньше TrueProfitPoints пунктов) - устанавливается StartLot
2 - если предыдущая позиция убыточная, размер лота увеличивается на AddLot, если прибыльная - устанавливается StartLot
3 - если предыдущая позиция прибыльная, размер лота увеличивается в AddLot раз, если убыточная - устанавливается StartLot
4 - если предыдущая позиция убыточная, размер лота увеличивается в AddLot раз, если прибыльная - устанавливается StartLot
5 - размер лота выбирается с расчётом, что максимальный убыток от открытой позиции (в случае срабатывания СтопЛосс) составит MaxRisk процентов от депозита
6 - размер лота выбирается как процент от баланса (управляется переменной MaxRisk. Например, для eurusd: при Балансе 1000 и MaxRisk=10 откроется 0.1 лот, а при балансе 15000 и MaxRisk=5 откроется 0,8 лота)<br />
7 - размер лота выбирается по формуле "1% от баланса" / "среднюю амплитуду движения цены на последних 20-ти барах" * 0,4. Откуда взял - не помню =)

11-17 - алгоритмы подсчёта из вариантов 1-7, размер лота ограничен размером из 5-го варианта (т.е. максимальный убыток будет MaxRisk % от баланса)
21-27 - алгоритмы подсчёта из вариантов 1-7, размер лота не может уменьшаться
31-37 - алгоритмы подсчёта из вариантов 1-7, размер лота ограничен размером из 5-го варианта и не может уменьшаться. Т.е. если он будет больше, чем в 5-м варианте, он уменьшится до размера из 5-го варианта, но если при этом будет меньше, чем предыдущий лот, будет приравнян предыдущему лоту.

100-128 - все варианты подряд (удобно для оптимизации):
100 - 0
101 - 1 108 - 11 115 - 21 122 - 31
102 - 2 109 - 12 115 - 22 123 - 32
103 - 3 110 - 13 117 - 23 124 - 33
104 - 4 111 - 14 118 - 24 125 - 34
105 - 5 112 - 15 119 - 25 126 - 35
106 - 6 113 - 16 120 - 26 127 - 36
107 - 7 114 - 17 121 - 27 128 - 37
*/

// Предварительная настройка (если необходимо, измените в коде):
//---- лот не будет МЕНЬШЕ значения MIN_LOT
#define MIN_LOT			0.1
//---- лот не будет БОЛЬШЕ значения MAX_LOT
#define MAX_LOT			100
//---- если в работе произошла ошибка (например, не все необходимые переменные инициализированы из эксперта), ф-ция вернёт значение DEFAULT_LOT
#define DEFAULT_LOT		-1

// ВАЖНО! _Перед_ вызовом ф-ции Lot() необходимо присвоить значения переменным:
double lotlib_PrevLots = -1.0;		// размер лота предыдущей позици
double lotlib_PrevProfit = 0.12345;	//	прибыль/убыток предыдущей позиции в $
double lotlib_OpenPriceLevel = -1;	//	уровень открытия открываемой позиции
double lotlib_StopLossLevel = -1;	//	уровень стоплосса открываемой позиции

/////////////////////////////////////////////////////////////////////////////////
/**/ double Lot()
/////////////////////////////////////////////////////////////////////////////////
{
	if ( !lotlibVariableChekOK() ) { return(DEFAULT_LOT); }

	double lot = 0.0, lot_tmp = 0.0, maxloss_money = 0.0, maxloss_points = 0.0, _AccountBalance = AccountBalance() * BalanceUse * 0.01;
	int lotsizevariant = LotSizeVariant;

	double lotcost = lotlib_LotCost( Symbol() );
	if ( lotcost <= 0 ) { lotcost = 10; }

//---- перебор параметров для оптимизации (LotSizeVariant 100 - 128):
	if ( LotSizeVariant >= 100 && LotSizeVariant <= 107 ) { lotsizevariant -= 100; }
	if ( LotSizeVariant >= 108 && LotSizeVariant <= 114 ) { lotsizevariant -= 107; }
	if ( LotSizeVariant >= 115 && LotSizeVariant <= 121 ) { lotsizevariant -= 114; }
	if ( LotSizeVariant >= 122 && LotSizeVariant <= 128 ) { lotsizevariant -= 121; }

//---- для вариантов 11-17, 21-27, 31-37
	if ( LotSizeVariant >= 11 && LotSizeVariant <= 17 ) { lotsizevariant -= 10; }
	if ( LotSizeVariant >= 21 && LotSizeVariant <= 27 ) { lotsizevariant -= 20; }
	if ( LotSizeVariant >= 31 && LotSizeVariant <= 37 ) { lotsizevariant -= 30; }

	switch ( lotsizevariant )
	{
		case 0:
		{
			lot = StartLot;
			break;
		}
		case 1:
		{
			if ( lotlib_PrevProfit >= TrueProfitPoints * lotlib_PrevLots * lotcost )
			{ lot = lotlib_PrevLots + AddLot; }
			else
			{ lot = StartLot; }
			break;
		}
		case 2:
		{
			if ( lotlib_PrevProfit <  TrueProfitPoints * lotlib_PrevLots * lotcost )
			{ lot = lotlib_PrevLots + AddLot; }
			else
			{ lot = StartLot; }
			break;
		}
		case 3:
		{
			if ( lotlib_PrevProfit >= TrueProfitPoints * lotlib_PrevLots * lotcost )
			{ lot = lotlib_PrevLots * KLot; }
			else
			{ lot = StartLot; }
			break;
		}
		case 4:
		{
			if ( lotlib_PrevProfit <  TrueProfitPoints * lotlib_PrevLots * lotcost )
			{ lot = lotlib_PrevLots * KLot; }
			else
			{ lot = StartLot; }
			break;
		}
		case 5:
		{
			if ( lotlib_StopLossLevel > 0 )
			{
				maxloss_money  = _AccountBalance * MaxRisk * 0.01;
				maxloss_points = MathAbs( lotlib_OpenPriceLevel - lotlib_StopLossLevel ) / Point;
				lot = maxloss_money / maxloss_points / lotcost;
			}
			else
			{ lot = StartLot; }
			break;
		}
		case 6:
		{
//			lot = _AccountBalance * MaxRisk * 0.00001;
			lot = _AccountBalance * MaxRisk * 0.0001 / lotcost;
			break;
		}
		case 7:
		{
			lot = _AccountBalance * 0.01 / iATR( Symbol(), Period(), 20, 1 ) / lotcost * 4 * Point;
			break;
		}
		default:
		{
			Print( "lot_lib Error! Invalid LotSizeVariant!" );
			return(DEFAULT_LOT);
		}
	}

	if ( ( LotSizeVariant >= 11 && LotSizeVariant <= 17 ) || ( LotSizeVariant >= 108 && LotSizeVariant <= 114 ) )
	{
		if ( lotlib_StopLossLevel > 0 )
		{
			maxloss_money  = _AccountBalance * MaxRisk * 0.01;
			maxloss_points = MathAbs( lotlib_OpenPriceLevel - lotlib_StopLossLevel ) / Point;
			lot_tmp = maxloss_money / maxloss_points / lotcost;
			if ( lot > lot_tmp ) { lot = lot_tmp; }
		}
	}
	if ( ( LotSizeVariant >= 21 && LotSizeVariant <= 27 ) || ( LotSizeVariant >= 115 && LotSizeVariant <= 121 ) )
	{
		lot = MathMax( lot, lotlib_PrevLots );
	}
	if ( ( LotSizeVariant >= 31 && LotSizeVariant <= 37 ) || ( LotSizeVariant >= 122 && LotSizeVariant <= 128 ) )
	{
		if ( lotlib_StopLossLevel > 0 )
		{
			maxloss_money  = _AccountBalance * MaxRisk * 0.01;
			maxloss_points = MathAbs( lotlib_OpenPriceLevel - lotlib_StopLossLevel ) / Point;
			lot_tmp = maxloss_money / maxloss_points / lotcost;
			if ( lot > lot_tmp ) { lot = lot_tmp; }
		}
		lot = MathMax( lot, lotlib_PrevLots );
	}

	if ( lot < MIN_LOT ) { lot = MIN_LOT; }
	if ( lot > MAX_LOT ) { lot = MAX_LOT; }
	return( NormalizeDouble( lot, 1 ) );
}

bool lotlibVariableChekOK()
{
	bool _return = true;
	if ( lotlib_PrevLots			<	0			) { Print( "lot_lib Error! lotlib_PrevLots not initialized!"			); _return = false; }
	if ( lotlib_PrevProfit		==	0.12345	) { Print( "lot_lib Error! lotlib_PrevProfit not initialized!"			); _return = false; }
	if ( lotlib_OpenPriceLevel	<	0			) { Print( "lot_lib Error! lotlib_OpenPriceLevel not initialized!"	); _return = false; }
	if ( lotlib_StopLossLevel	<	0			) { Print( "lot_lib Error! lotlib_StopLossLevel not initialized!"		); _return = false; }
	return(_return);
}

// ф-ция minri, доработанная мной
/////////////////////////////////////////////////////////////////////////////////
/**/ double lotlib_LotCost ( string _Symbol )
/////////////////////////////////////////////////////////////////////////////////
{
	if ( MarketInfo ( _Symbol, MODE_BID ) <= 0 ) { return(-1.0); }
	double Cost = -1.0;

	string FirstPart  = StringSubstr( _Symbol, 0, 3 );
	string SecondPart = StringSubstr( _Symbol, 3, 3 );

	double Base = MarketInfo ( _Symbol, MODE_LOTSIZE ) * MarketInfo ( _Symbol, MODE_POINT );
	if ( SecondPart == "USD" )
	{ Cost = Base; }
	else
	{
		if ( FirstPart == "USD" )
		{ Cost = Base / MarketInfo ( _Symbol, MODE_BID ); }
		else
		{
			if ( MarketInfo( "USD" + SecondPart, MODE_BID ) > 0 )
			{ Cost = Base / MarketInfo( "USD" + SecondPart, MODE_BID ); }
			else
			{ Cost = Base * MarketInfo( SecondPart + "USD", MODE_BID ); }
		}
	}
return( NormalizeDouble(Cost, 2) );
}

