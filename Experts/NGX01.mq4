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
input int starttime=13;
input int endtime=23;
input int GAP = 70;
input int CLOSE_GAP=150;

bool Direction=false;
bool Dealing=false;
bool TodayDeal=false;
double t1;
double t2;
double t3;
double t4;


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
int Environment(double gappp)
{
   double average = (t2+t3+t4)/3;
   //Print(average);
   double gap=(t1 - average)/Point;
   if(gap>gappp)
   {
      return 1;
   }
   if(gap<-gappp)
   {
      return -1;         
   }   
   return 0;
}
bool IsDealTime()
{
   if(Hour()>=starttime&&Hour()<endtime)
      return true;
   return false;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   //datetime now=TimeCurrent();
   t1 = TypicalPrice(1);
   t2 = TypicalPrice(2);
   t3 = TypicalPrice(4);
   t4 = TypicalPrice(5);
   double average = (t2+t3+t4)/3;
   
   if(Hour()==0||Hour()==1)
         TodayDeal=false;
              
   if(IsDealTime())
   {
      //last 5 hours average price.
      //Print(GAP*Point); 
      
      if(!Dealing&&!TodayDeal)
      {
         if(Environment(GAP)==1)
         {
            OrderSend(NULL,OP_BUY,1.0,Ask,3,0,0);
            Dealing=true;
            Direction=true;
            TodayDeal=true;
         }
         if(Environment(GAP)==-1)
         {
            OrderSend(NULL,OP_SELL,1.0,Bid,3,0,0);
            Dealing=true;
            Direction=false;
            TodayDeal=true;
         } 
      }   
   }
   if(Dealing)
   {
      if(Environment(CLOSE_GAP)*(double(Direction)-0.5)<0)
      {
         _CloseAllOrders();
         Dealing=false;         
      }
      if(MathAbs(t1-average)<70*Point&&MathAbs(t3-average)<70*Point&&!IsDealTime())
      {
         _CloseAllOrders();
         Dealing=false;    
      }
   
   }
   
}
//+------------------------------------------------------------------+
