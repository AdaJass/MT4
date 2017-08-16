//+------------------------------------------------------------------+
//|                                                StockRelative.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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
   int cn50 = iClose("CN50",PERIOD_D1,0)-iOpen("CN50",PERIOD_D1,0);  //120
   int aus200 = iClose("AUS200",PERIOD_D1,0)-iOpen("AUS200",PERIOD_D1,0);  //60
   Print(cn50,"  ",aus200);
   if(OrdersTotal()>0)
      return;
   datetime t=TimeCurrent();
   int hour = TimeHour(t);   
   if(hour==10)
   {
      int cn50 = iClose("CN50",PERIOD_D1,0)-iOpen("CN50",PERIOD_D1,0);  //120
      int aus200 = iClose("AUS200",PERIOD_D1,0)-iOpen("AUS200",PERIOD_D1,0);  //30
      int audusd =  int((iClose("AUDUSD",PERIOD_D1,0)-iOpen("AUDUSD",PERIOD_D1,0))*100000);  //100 
      Print("This is in the block!!"); 
      if(cn50*aus200>0&&cn50>120&&aus200>30&&audusd>60)
      {
         OrderSend("AUDUSD",OP_BUY,1.0,Ask,3,Ask-200*Point,Ask+300*Point,"Trend Deal",0,0,clrCyan);
      }
      if(cn50*aus200<0&&cn50<-120&&aus200<-30&&audusd<-60)
      {
         OrderSend(Symbol(),OP_SELL,1.0,Bid,3,Bid+200*Point,Bid-300*Point,"Trend Deal",0,0,clrCyan);
      }
   }
   
  }
//+------------------------------------------------------------------+
