//+------------------------------------------------------------------+
//|                                                    Arbitrage.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict

input double Lots=1.0;
extern double CloseProfit=40;

bool dealing=false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

void TriangleHedge()
{
   double eurgbp=MarketInfo("EURGBP",MODE_BID); 
   if(OrderSend("EURUSD",OP_BUY,Lots,MarketInfo("EURUSD",MODE_ASK),3,0,0,"",0,0,0)>0)
   {
      RefreshRates();
      if(OrderSend("EURGBP",OP_SELL,Lots,MarketInfo("EURGBP",MODE_BID),3,0,0,"",0,0,0)>0){
         RefreshRates();
         double lots = Lots*eurgbp;
         if(OrderSend("GBPUSD",OP_SELL,lots,MarketInfo("GBPUSD",MODE_BID),3,0,0,"",0,0,0)>0){
            dealing=true;
         }else{
            Alert("Something bad happend!!");
         }
      }else{
         Alert("Something bad happend!!");
      }
   }  
}

void TriangleClose()
{
   for(;OrdersTotal()>0;){               
      if(!OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
         continue; 
      if(OrderSymbol()=="EURUSD")
      {  
         if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,0)==false)
            Alert("Order Close Wrong");
      }
      if(OrderSymbol()=="GBPUSD")
      {  
         if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,0)==false)
            Alert("Order Close Wrong");
      }
      if(OrderSymbol()=="EURGBP")
      {  
         if(OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,0)==false)
            Alert("Order Close Wrong");
      }  
   }
   if(OrdersTotal()<=0)
   {
      dealing=false;
   } 
}

int OnInit()
{
//--- 
   if(OrdersTotal()==3)
      dealing=true;  
   
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
   double profit=0.0;
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue; 
      profit+=OrderProfit()+OrderSwap()+OrderCommission();
      //Print("swap ",OrderSwap()," commision :",OrderCommission());
   } 
   
   if(profit/Lots>CloseProfit)
   {
      TriangleClose();
   }
   
   if(dealing==false)
   {
      TriangleHedge();
   }
   
}
//+------------------------------------------------------------------+
