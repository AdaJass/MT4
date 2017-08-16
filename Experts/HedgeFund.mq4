//+------------------------------------------------------------------+
//|                                                    HedgeFund.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict

input double UNIT=0.5;
input double GAP=10;
input double MID=1.0;
input double RADIUS=100;
input string MAIN_PAIR="XAUUSD";
input string HEDGE_PAIR="XAUUSD";
input int POINT=5;
input bool BUY_OR_SELL=true;

double HighEdge,LowEdge,MaxLot,MaxStage;
double SliceLength,Unit;
bool GameStart=false;
double OrdersLots=0.0;

//Function Definition
void KeepOrders(double lots)
{
   double orderBuy=0.0,orderSell=0.0;       
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;
      
      if(OrderType()==OP_BUY){        
         orderBuy+=OrderLots();
      }                                        
      if(OrderType()==OP_SELL){
         orderSell+=OrderLots();
      }                 
   }
   double orders=orderBuy-orderSell;
   if(lots>0.01){
      if(orderSell>0.01){
         CloseOrders(false);
      }
     
      if(orderBuy-lots>=UNIT){
         CloseOrders(true,(orderBuy-lots)/UNIT);
      }
      
      if(lots-orderBuy>=UNIT){
         
      }
   }
   
   if(lots<-0.01)
   
   if(
   
   if(orders-lots<0.01||orders-lots>-0.01)
      return
   
   
   
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   HighEdge=MID+RADIUS*POINT;
   LowEdge=MID-RADIUS*POINT;
   MaxStage=RADIUS/GAP;
   SliceLength=RADIUS/GAP;
   MaxLot=UNIT*SliceLength;
   
   if(OrdersTotal()>0){
      GameStart=true;
      OrdersLots=0.0;       
      for(int ii=0,all=OrdersTotal();ii<all;ii++){               
         if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
            continue;
         if(OrderSymbol()!=Symbol())
            continue;
            
         if(OrderType()==OP_BUY){        
            OrdersLots+=OrderLots();
         }                                        
         if(OrderType()==OP_SELL){
            OrdersLots-=OrderLots();
         }                 
      }
   }
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   double Price=MarketInfo(MAIN_PAIR,MODE_BID)/MarketInfo(HEDGE_PAIR,MODE_BID);
   double priceRadius=(Price-MID)/POINT;
   double priceStage=priceRadius/GAP;
   double orderStage=OrdersLots/UNIT;
      
   if(GameStart&&MathAbs(priceStage)<MaxStage)
   {
      if(MathAbs(MathAbs(priceStage)-orderStage)>0.9999)
         KeepOrders(priceStage*UNIT);
   }
   if(MathAbs(priceStage)>MaxStage)
   {
      if(priceRadius>0)
         KeepOrders(-MaxLot);
      
      if(priceRadius<0)
         KeepOrders(MaxLot);
      
      GameStart=true;
   }
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   
   
   
}
//+------------------------------------------------------------------+
