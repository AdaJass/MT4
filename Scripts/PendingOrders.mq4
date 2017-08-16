//+------------------------------------------------------------------+
//|                                                PendingOrders.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double scale=double(MathCeil(1/Point));
   double pendingPrice=Bid;
   double lots=0.01;
   for(int i=0;i<40;i++){
      pendingPrice=pendingPrice-100*Point;
      OrderSend(Symbol(),OP_SELLSTOP,lots,pendingPrice,0,0,0,0,0,0,clrAliceBlue);
      OrderSend(Symbol(),OP_BUYLIMIT,lots,pendingPrice,3,0,0,0,0,0,clrAliceBlue);
   
   }
   
   RefreshRates();
   pendingPrice=Bid;
   
   for(int i=0;i<50;i++){
      pendingPrice=pendingPrice+100*Point;
      OrderSend(Symbol(),OP_BUYSTOP,lots,pendingPrice,0,0,0,0,0,0,clrAliceBlue);
      OrderSend(Symbol(),OP_SELLLIMIT,lots,pendingPrice,3,0,0,0,0,0,clrAliceBlue);   
   }
   
  }
//+------------------------------------------------------------------+
