//+------------------------------------------------------------------+
//|                                                  OrangeJuice.mq4 |
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
bool deal=false;
datetime dealtime=0;
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
   if(ChartSymbol(0)!="OrangeJuice")
   {
      Alert("This EA Will Just Run On OrangeJuice!");
      Print("This EA Will Just Run On OrangeJuice!");
   }
   datetime date=TimeCurrent();
   double lots=0.1*AccountFreeMargin()/MarketInfo("OrangeJuice",MODE_MARGINREQUIRED);
   lots=int(lots);
   int ticket=0;
   
   if(!deal&&TimeCurrent()-dealtime>1728000&&lots>1&&(TimeMonth(date)>0&&TimeMonth(date)<3||TimeMonth(date)==12)&&(
      (iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,5)>68&&iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,0)<65)||
      (iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,7)>68&&iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,0)<65)||
      (iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,9)>68&&iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,0)<65))){
      Print("hehehehehehehhe",Bid);
      ticket=OrderSend("OrangeJuice",OP_SELL,lots,Bid,10,0,0);
      deal=true;
      dealtime=TimeCurrent();
   }
   if(deal&&iRSI(NULL,PERIOD_D1,20,PRICE_TYPICAL,0)<50){
      
      for(int ii=0,all=OrdersTotal();ii<all;ii++){               
         if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
            continue;
                     
         if(OrderSymbol()!=Symbol())
            continue; 
                   
         RefreshRates();
         if(OrderType()==OP_BUY){ 
            if(OrderClose(OrderTicket(),OrderLots(),Bid,10,clrRed)){            
               ii-=1;
               continue;
            }
         }
         if(OrderType()==OP_SELL){
            if(OrderClose(OrderTicket(),OrderLots(),Ask,10,clrRed)){         
               ii-=1;
            }
         }
      } 
      deal=false;
   }
   
}
//+------------------------------------------------------------------+
