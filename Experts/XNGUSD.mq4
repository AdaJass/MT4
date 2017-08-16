//+------------------------------------------------------------------+
//|                                                       XNGUSD.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict
#include <ordersoperation.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int starttime=16;
input int endtime=23;
input int GAP = 200;
//input int PRE_GROW=350;
input int STOPLOSS=400;

bool Direction=false;
bool Dealing=false;

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
double TypicalPrice(int shift)
{
   return (High[shift]+Low[shift]+Close[shift])/3;
}
int Environment()
{
   double t1 = TypicalPrice(1);
   double t2 = TypicalPrice(2);
   double t3 = TypicalPrice(3);
   double t4 = TypicalPrice(4);
   double average = (t1+t2+t3+t4)/4;
   double Ht1=(Close[1]-Open[5])/Point;
   //Print(average);
   double gap=(t1 - average)/Point;
   if(gap>GAP)
   {
      return 1;
   }
   if(gap<-GAP)
   {
      return -1;         
   }
   /*
   if(t1>t3&&t2>t4&&(Bid-t1)>GAP*Point*0.3)
   {
      return 1;
   }
   if(t1<t3&&t2<t4&&(t1-Bid)>GAP*Point*0.3)
   {
      return -1;
   }*/
   return 0;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   //datetime now=TimeCurrent();
   double Lots=1.0;//int(0.1*AccountFreeMargin()/MarketInfo(Symbol(),MODE_MARGINREQUIRED));
   if(Hour()>=starttime&&Hour()<endtime)
   {
      //last 5 hours average price.
      //Print(GAP*Point);      
      if(!Dealing)
      {
         if(Environment()==1)
         {
            OrderSend(NULL,OP_BUY,Lots,Ask,3,Ask-STOPLOSS*Point,0);
            Dealing=true;
            Direction=true;
         }
         if(Environment()==-1)
         {
            OrderSend(NULL,OP_SELL,Lots,Bid,3,Bid+STOPLOSS*Point,0);
            Dealing=true;
            Direction=false;
         } 
      }   
   }
   if(Dealing&&Hour()>3&&Hour()<10)
   {
      if(Environment()*(double(Direction)-0.5)<=0)
      {
         _CloseAllOrders();
         Dealing=false;         
      }
   
   }
   
}
//+------------------------------------------------------------------+
