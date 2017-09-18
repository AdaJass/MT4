//+------------------------------------------------------------------+
//|                                                      NetWork.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input bool Direction = true;
input double MaxLots = 2.0;
input double LowestLine = 0.0;
input double HighestLine = 0.0;
input double Gap = 200;

double Unit =0.0;


void Deal(int ods)
{
   for(int i=0;i<ods;i++)
   {
      RefreshRates();
      if(!Direction)
      {
         OrderSend(Symbol(),OP_SELL,Unit,Bid,3,0,0,NULL,0,0,clrGreen);
      }
      if(Direction)
      {
         OrderSend(Symbol(),OP_BUY,Unit,Ask,3,0,0,NULL,0,0,clrGreen);
      }
   }
}

void CloseDeal(int ods)
{
   int tickets[400];
   int nn=0;
   for(int cnt=0;cnt<OrdersTotal();cnt++)
   {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=Symbol())
         continue;
      if(Direction&&(Bid-OrderOpenPrice())>Gap*Point)
      {
         tickets[nn++]=OrderTicket();
         if(nn>=ods)
            break;
         continue;
      }   
      if(!Direction&&(OrderOpenPrice()-Bid)>Gap*Point)
      {        
         tickets[nn++]=OrderTicket();
         if(nn>ods)
            break;
         continue;        
      }
   }
   for(int i=0;i<nn;i++)
   {
      if(!OrderSelect(tickets[i],SELECT_BY_TICKET,MODE_TRADES))
         continue;
      RefreshRates();
      if(Direction)
      {
         if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet))
            Print("OrderClose error ",GetLastError());
      }
      if(!Direction)
      {
         if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet))
            Print("OrderClose error ",GetLastError()); 
      }
   }
}

int OnInit()
{
//---

   Unit = MaxLots/((HighestLine - LowestLine)/Point/Gap);   
   Print("the unit is: ",Unit);
   if(Unit<0.01){
      Print("Parameter Wrong, MaxLots too small");
      ExpertRemove();
   } 
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
   double orderLot = 0.0;
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;
         
      if(OrderType()==OP_BUY&&Direction){        
         orderLot+=OrderLots();
      }                                        
      if(OrderType()==OP_SELL&&!Direction){
         orderLot+=OrderLots();
      }                 
   }
   orderLot = MathAbs(orderLot);
   
   if(Bid<LowestLine||Bid>HighestLine)
   {
      Alert("Price out of boundary!");
      return;
   }
   int g = 0;
   if(Direction)
      g=int((HighestLine-Bid)/Point/Gap);
   if(!Direction)
      g=int((Bid-LowestLine)/Point/Gap);
   
   if(orderLot/Unit - g > Unit)  //here should close od
   {
      int ods= int(orderLot/Unit) -g;
      CloseDeal(ods);      
   }
   if(g - orderLot/Unit >Unit)  //here should deal
   {
      int ods= g - (orderLot/Unit);
      Deal(ods);
   }   
}
//+------------------------------------------------------------------+
