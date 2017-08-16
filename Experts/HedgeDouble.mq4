//+------------------------------------------------------------------+
//|                                                  HedgeDouble.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict


double goldSize=0.0; 
double silverSize=0.0; 
double goldPrice 0.0;
double silverPrice = 0.0;
double hedgeRateBaseSilver = 0.0;
   

int count = 0;
double GoldVsSilver[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   ArrayResize(GoldVsSilver,73000,10000);
   goldSize = MarketInfo("XAUUSD",MODE_LOTSIZE);
   silverSize = MarketInfo("XAUUSD",MODE_LOTSIZE);
   
//---
   EventSetTimer(60);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double CandleHigh(const string S, int T)
{
   return iClose(S,T,0)-
}

void OnTick()
{
//---   
   goldPrice = MarketInfo("XAUUSD",MODE_BID);
   silverPrice = MarketInfo("XAGUSD",MODE_BID);
   hedgeRateBaseSilver = (silverSize*silverPrice)/(goldSize*goldPrice);
   
   if(   
}
//+------------------------------------------------------------------+
void OnTimer()
{
   GoldVsSilver[count++]=hedgeRateBaseSilver;
}