//+------------------------------------------------------------------+
//|                                                      Eternal.mq4 |
//|                                                         Ada.Jass |
//|                                             shiyi.iloveu.forever |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "shiyi.iloveu.forever"
#property version   "1.00"
#property strict

input double Lots=0.01;
input int MiniBuyGap = 10000; //最小的买单做单间隔
input int MiniSellGap = 10000; //最小的卖单做单间隔

input int BuyProfitGap=150;   //最小买单平仓间隔
input int SellProfitGap=150;   //最小卖单平仓间隔
input int BuyGainOrdersClose = 1; //当至少有多少个买单盈利时才平仓
input int SellGainOrdersClose = 1; //当至少有多少个卖单盈利时才平仓
input double LowGate= 0;  // you must input the low trashold
input double HighGate= 1000.0;   // you must input the high trashold

double lots;
int tickets=0;
double scale=double(MathCeil(1/Point));
double lastHedgePrice=0.0;
double lastSellPrice=0.0;
double lastBuyPrice=0.0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void GetTrend(void)
{
   double orderLots=0.0;
   double buyLots=0.0;
   double sellLots=0.0;
   
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;            
      double min=OrderLots()-Lots;
      if(min>0.01)
      {
         Alert("it is odd! input lots isn't equal to the deal!");
         break;
      }
      if(OrderType()==OP_BUY){        
         orderLots+=OrderLots();
         buyLots+=OrderLots();
      }                                        
      if(OrderType()==OP_SELL){
         orderLots-=OrderLots();
         sellLots-=OrderLots();
      }                 
   }
   Print(Symbol(),"'s orders trend is: ", orderLots,", in which of buy is: ", buyLots,", and sell is: ", sellLots); 
}


void Hedge()
{  
   if(Bid>HighGate||Bid<LowGate)
      return;
      
   int ticket1=-5;
   int ticket2=-5;
   tickets = OrdersTotal();
   
   RefreshRates();
   ticket1=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,NULL,0,0,clrGreen);
   RefreshRates(); 
   ticket2=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,0,NULL,0,0,clrGreen);
   RefreshRates();
      
   if(ticket1!=-1&&ticket2!=-1){        
      lastSellPrice=Bid;
      lastHedgePrice=Bid;  
      lastBuyPrice=Ask;   
      Print("Hedge Deal OK!");    
   }
   else{
      Print("The order open error happend! Error Code:",GetLastError());
      if(ticket1==-1){
         Print("Ask is: ",Ask);
         if(OrderSend(Symbol(),OP_BUY,lots,Ask,100,0,0,NULL,0,0,clrGreen)==-1&&ticket2>=0)
            OrderClose(ticket2,Lots,Bid,3,clrBlue);
      }
      if(ticket2==-1){
         Print("Bid is: ",Bid);
         if(OrderSend(Symbol(),OP_SELL,lots,Bid,100,0,0,NULL,0,0,clrGreen)==-1&&ticket1>=0)
            OrderClose(ticket1,Lots,Ask,3,clrBlue);
      }      
   }
   GetTrend();
}

void Deal(bool flag)
{  
   if(Bid>HighGate||Bid<LowGate)
      return;
   if(flag){     
      if(OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,NULL,0,0,clrGreen)){
         lastBuyPrice=Ask;
         Print("This is auto price gap deal is ok!");
      }else{
         Print("There is an error, WTF!! , code is: ", GetLastError());
      }
   }else if(!flag){
      if(OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,0,NULL,0,0,clrGreen)){
         lastSellPrice=Bid;
         Print("This is auto price gap deal is ok!");
      }else{
         Print("There is an error, WTF!! , code is: ", GetLastError());
      }
   }
   GetTrend();
}



int OnInit()
  {
//---
   lots=Lots;
   if(lastBuyPrice<0.00001)
      lastBuyPrice=Bid;
   if(lastHedgePrice<0.0001)
      lastHedgePrice=Bid;
   if(lastSellPrice<0.0001)
      lastSellPrice=Bid;
      
   GetTrend();
   
   EventSetTimer(400);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   datetime now = TimeCurrent();
   
   if(MathAbs(scale*(Bid-lastBuyPrice))>MiniBuyGap)
      Deal(true); 
   if(MathAbs(scale*(Bid-lastSellPrice))>MiniSellGap)
      Deal(false);   
   
   /*
   double bar0 = scale*(iOpen(Symbol(),PERIOD_M5,0)-iClose(Symbol(),PERIOD_M5,0));
   double bar15 = scale*(iOpen(Symbol(),PERIOD_M15,0)-iClose(Symbol(),PERIOD_M15,0));   
   
   
   if(MathAbs(bar0)>60||MathAbs(bar15)>150)
      return;
   */  
      
   int buyShouldClose=0;
   int sellShouldClose=0;   
   for(int ii=0,all=OrdersTotal();ii<all;ii++){               
      if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
         continue;
         
      if(OrderSymbol()!=Symbol())
         continue;        
      
      if(OrderType()==OP_BUY&&scale*(Ask-OrderOpenPrice())>BuyProfitGap){ 
         buyShouldClose++;
      }
      if(OrderType()==OP_SELL&&scale*(OrderOpenPrice()-Bid)>SellProfitGap){
         sellShouldClose++;
      }
   }
     
   double distance = MathAbs(scale*(Bid-lastHedgePrice));
   if((buyShouldClose>=BuyGainOrdersClose)||(sellShouldClose>=SellGainOrdersClose)){
      int kk=0;
      for(int ii=0,all=OrdersTotal();ii<all;ii++){               
         if(!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES))
            continue;
            
         if(OrderSymbol()!=Symbol())
            continue;   
                     
         RefreshRates();
          
         if(OrderType()==OP_BUY&&scale*(Ask-OrderOpenPrice())>BuyProfitGap){
            if(OrderClose(OrderTicket(),OrderLots(),Bid,10,clrRed)){
               kk++;  
               ii=-1;             
               Print("Deal Close for positive profit");
            } 
         }                                        
         if(OrderType()==OP_SELL&&scale*(OrderOpenPrice()-Bid)>SellProfitGap){
            if(OrderClose(OrderTicket(),OrderLots(),Ask,10,clrRed)){
               kk++;
               ii=-1;
               Print("Deal Close for positive profit");
            }
         }                 
      }
      if(kk>0)
         Hedge();
         
      return;
   }    
   
   
  }
//+------------------------------------------------------------------+


void OnTimer()
{
   
   GetTrend();  
}