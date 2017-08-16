//+------------------------------------------------------------------+
//|                                          HalfDayBreakThrough.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict

input double StopLoss=200;
input double Profit=100;
input double lots=0.1;
input int houroftime=15;
input int minuteoftime=30;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double daylow=Bid;
double dayhigh=Bid;

int OnInit()
  {
//---
   
//---
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
void OnTick()
{
//---
   
   datetime date=TimeCurrent();
   if(TimeHour(date)<houroftime)
   {
      dayhigh=iHigh(NULL,PERIOD_D1,0);
      daylow=iLow(NULL,PERIOD_D1,0);   
   }else{
      if(Bid>dayhigh)
      {
         OrderSend(Symbol(),OP_BUY,lots,Ask,3,Ask-StopLoss*Point,Ask+Profit*Point,"",0,0,0);
         dayhigh=10000.0;
         daylow=0.0;
      }
      
      if(Bid<daylow){
         OrderSend(Symbol(),OP_SELL,lots,Bid,3,Bid+StopLoss*Point,Bid-Profit*Point,"",0,0,0);
         
         dayhigh=10000.0;
         daylow=0.0;          
      }
   }
}
//+------------------------------------------------------------------+
