//+------------------------------------------------------------------+
//|														 				lot_lib.mqh |
//|                                      Copyright � 2005, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
//#property copyright "Copyright � 2005, komposter"
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
�������������:
- ��������� lot_lib.mqh � ����� MetaTrader 4\experts\include
- � �������� ��������� ��������� ������:

// � ����� ������:
#include <lot_lib.mqh>
 
// � �-��� init():
    lotlib_PrevLots = 0.0;  lotlib_PrevProfit = 0.0;
 
// � ������� start(), _�����_������_ ���������� ������:
    lotlib_OpenPriceLevel = Ask; // ������ Ask - �������� �������� ������ �������� ������� 
    lotlib_StopLossLevel = Ask-StopLoss*Point; // ������ Ask-StopLoss*Point - �������� �������� ������ ��������� �������
 
// � ������� start(), ����, ��� ������� �������� ������� (��������, ����� ��������-������):
         lotlib_PrevLots = OrderLots();  lotlib_PrevProfit = OrderProfit();
- ������ ���� ��� ��������� ������ ���������� �������� Lot(). �.�. ������ ������ ����������, ������������ ������ ���� (������ Lot ��� Lots) ����� Lot().
- ����������� �������� � ���������� =)

����������: ���� ������� ������ ��������� ������������ 2 � ������ �������, ���������� lotlib_PrevLots � lotlib_PrevProfit ���������� ������������� ����������� ������ �������� ����� ��������� ����� �������. �������, ����� �������� ����������� (��������� �������� ������� ��� ��������� ��������) ��� ������� �������������� ;)

������� ����������:
- LotSizeVariant - � ��������, ����� ������� ����
- StartLot - ��������� ������ ���� (��� LotSizeVariant 0-5)
- AddLot - ������ "��������" ���� (��� LotSizeVariant 1 � 2)
- KLot - ���������� �������� (��� LotSizeVariant 3 � 4)
- MaxRisk - % �� ��������, ������� ����� ��������� (��� LotSizeVariant 5, 6, 11-17, 31-37)
- TrueProfitPoints - ����� (� �������), ������ ������� ������� ������� ����� ��������� �������� (������ ������� ����� ��������� �������). (��� LotSizeVariant 1-4)
- BalanceUse - ������� �������, ������� ����� ������������ ���������. ���� ����������� ��������� ������������ ����������� ����������, ���������� 100/"���-�� ���������" (�.�. ��� 3-� ��������� 33, ��� 4-� - 25, � �.�.) (��� LotSizeVariant 5, 6, 7, 11-17, 31-37)

��������� �������� LotSizeVariant:
0 - ������������� ������ ���� (������� ���������� StartLot)
1 - ���� ���������� ������� ���������� (������� ������ TrueProfitPoints �������), ������ ���� ������������� �� AddLot (��� �����������, ���� AddLot ������ 0), ���� ��������� (������� ������ TrueProfitPoints �������) - ��������������� StartLot
2 - ���� ���������� ������� ���������, ������ ���� ������������� �� AddLot, ���� ���������� - ��������������� StartLot
3 - ���� ���������� ������� ����������, ������ ���� ������������� � AddLot ���, ���� ��������� - ��������������� StartLot
4 - ���� ���������� ������� ���������, ������ ���� ������������� � AddLot ���, ���� ���������� - ��������������� StartLot
5 - ������ ���� ���������� � ��������, ��� ������������ ������ �� �������� ������� (� ������ ������������ ��������) �������� MaxRisk ��������� �� ��������
6 - ������ ���� ���������� ��� ������� �� ������� (����������� ���������� MaxRisk. ��������, ��� eurusd: ��� ������� 1000 � MaxRisk=10 ��������� 0.1 ���, � ��� ������� 15000 � MaxRisk=5 ��������� 0,8 ����)<br />
7 - ������ ���� ���������� �� ������� "1% �� �������" / "������� ��������� �������� ���� �� ��������� 20-�� �����" * 0,4. ������ ���� - �� ����� =)

11-17 - ��������� �������� �� ��������� 1-7, ������ ���� ��������� �������� �� 5-�� �������� (�.�. ������������ ������ ����� MaxRisk % �� �������)
21-27 - ��������� �������� �� ��������� 1-7, ������ ���� �� ����� �����������
31-37 - ��������� �������� �� ��������� 1-7, ������ ���� ��������� �������� �� 5-�� �������� � �� ����� �����������. �.�. ���� �� ����� ������, ��� � 5-� ��������, �� ���������� �� ������� �� 5-�� ��������, �� ���� ��� ���� ����� ������, ��� ���������� ���, ����� ��������� ����������� ����.

100-128 - ��� �������� ������ (������ ��� �����������):
100 - 0
101 - 1 108 - 11 115 - 21 122 - 31
102 - 2 109 - 12 115 - 22 123 - 32
103 - 3 110 - 13 117 - 23 124 - 33
104 - 4 111 - 14 118 - 24 125 - 34
105 - 5 112 - 15 119 - 25 126 - 35
106 - 6 113 - 16 120 - 26 127 - 36
107 - 7 114 - 17 121 - 27 128 - 37
*/

// ��������������� ��������� (���� ����������, �������� � ����):
//---- ��� �� ����� ������ �������� MIN_LOT
#define MIN_LOT			0.1
//---- ��� �� ����� ������ �������� MAX_LOT
#define MAX_LOT			100
//---- ���� � ������ ��������� ������ (��������, �� ��� ����������� ���������� ���������������� �� ��������), �-��� ����� �������� DEFAULT_LOT
#define DEFAULT_LOT		-1

// �����! _�����_ ������� �-��� Lot() ���������� ��������� �������� ����������:
double lotlib_PrevLots = -1.0;		// ������ ���� ���������� ������
double lotlib_PrevProfit = 0.12345;	//	�������/������ ���������� ������� � $
double lotlib_OpenPriceLevel = -1;	//	������� �������� ����������� �������
double lotlib_StopLossLevel = -1;	//	������� ��������� ����������� �������

/////////////////////////////////////////////////////////////////////////////////
/**/ double Lot()
/////////////////////////////////////////////////////////////////////////////////
{
	if ( !lotlibVariableChekOK() ) { return(DEFAULT_LOT); }

	double lot = 0.0, lot_tmp = 0.0, maxloss_money = 0.0, maxloss_points = 0.0, _AccountBalance = AccountBalance() * BalanceUse * 0.01;
	int lotsizevariant = LotSizeVariant;

	double lotcost = lotlib_LotCost( Symbol() );
	if ( lotcost <= 0 ) { lotcost = 10; }

//---- ������� ���������� ��� ����������� (LotSizeVariant 100 - 128):
	if ( LotSizeVariant >= 100 && LotSizeVariant <= 107 ) { lotsizevariant -= 100; }
	if ( LotSizeVariant >= 108 && LotSizeVariant <= 114 ) { lotsizevariant -= 107; }
	if ( LotSizeVariant >= 115 && LotSizeVariant <= 121 ) { lotsizevariant -= 114; }
	if ( LotSizeVariant >= 122 && LotSizeVariant <= 128 ) { lotsizevariant -= 121; }

//---- ��� ��������� 11-17, 21-27, 31-37
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

// �-��� minri, ������������ ����
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

