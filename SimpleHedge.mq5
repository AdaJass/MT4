//+------------------------------------------------------------------+
//|                                                  SimpleHedge.mq5 |
//|                                                          AdaJass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "AdaJass"
#property link      "jass.ada@qq.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Expert\ExpertTrade.mqh>

input int CHANGE_PERIOD = 5;
input double MONEY_DROPDOWN = 0.001;

CExpertTrade *m_trade;


double startM, currentM;
int bars, cbars;
int MagicNumber=1924;
bool dealing =false;

int OnInit()
  {
//---
   m_trade=new CExpertTrade;   
   bars=Bars(_Symbol,PERIOD_D1);
   //OperateSet();
//---
   return(INIT_SUCCEEDED);
  }
  

void OperateSet()
{
   m_trade.Buy(17.0,"USTEC",SymbolInfoDouble("USTEC",SYMBOL_ASK));
   m_trade.Sell(10.0,"US2000",SymbolInfoDouble("US2000",SYMBOL_BID));
   dealing=true;
   startM=SymbolInfoDouble("USTEC",SYMBOL_ASK)/SymbolInfoDouble("US2000",SYMBOL_BID);
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
void OnTick()
  {
//---
   if(!dealing&&SymbolInfoDouble("USTEC",SYMBOL_ASK)>0.1&&SymbolInfoDouble("US2000",SYMBOL_BID)>0.1)
      OperateSet();
   cbars = Bars(_Symbol, PERIOD_D1);
   //Print(cbars," dajk ", currentM," another ",SymbolInfoDouble("US2000",SYMBOL_BID));
   if(cbars-bars>CHANGE_PERIOD)
   {
      bars=cbars;
      currentM=SymbolInfoDouble("USTEC",SYMBOL_ASK)/SymbolInfoDouble("US2000",SYMBOL_BID);
      //Print(cbars," dajk ", currentM," another ",startM);
      if((currentM-startM)/startM <-MONEY_DROPDOWN)
      {
         OperateSet();
         Print("dkjgkdjkgsjgskdgjakdjgkajdskgjaksdjg");
      }
      startM=currentM;
   }
   
  }
//+------------------------------------------------------------------+
