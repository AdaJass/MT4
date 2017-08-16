//+------------------------------------------------------------------+
//|                                                   Spaculator.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#include "..\\Include\\ordersoperation.mqh"

#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict

input double Lots=1.0;
input double AverageLine=1.07;
input double Gap=0.10;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
bool dealing=false,direction=false;

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
   double ratio=MarketInfo("XBRUSD",MODE_BID)/MarketInfo("XTIUSD",MODE_BID);
   if(!dealing&&(ratio-AverageLine)>=Gap)
   {
      OrderSend("XBRUSD",OP_SELL,Lots,Bid,3,0,0);
      OrderSend("XTIUSD",OP_BUY,Lots,Ask,3,0,0);
      dealing=true;
      direction=false;
   }
   if(dealing&&(ratio-AverageLine)>=1.5*Gap&&OrdersTotal()<4){
      OrderSend("XBRUSD",OP_SELL,Lots,Bid,3,0,0);
      OrderSend("XTIUSD",OP_BUY,Lots,Ask,3,0,0);
   }
   
   if(!dealing&&(AverageLine-ratio)>=Gap)
   {
      OrderSend("XTIUSD",OP_SELL,Lots,Bid,3,0,0);
      OrderSend("XBRUSD",OP_BUY,Lots,Ask,3,0,0);
      dealing=true;
      direction=true;
   }
   if(dealing&&(AverageLine-ratio)>=1.5*Gap&&OrdersTotal()<4){
      OrderSend("XTIUSD",OP_SELL,Lots,Bid,3,0,0);
      OrderSend("XBRUSD",OP_BUY,Lots,Ask,3,0,0);
   }
   
   if(dealing&&!direction&&AverageLine-ratio>=0.35*Gap)
   {
      _CloseAllOrders();
      dealing=false;
   }
   
   if(dealing&&direction&&ratio-AverageLine>=0.35*Gap)
   {
      _CloseAllOrders();
      dealing=false;
   }
   
}
//+------------------------------------------------------------------+
