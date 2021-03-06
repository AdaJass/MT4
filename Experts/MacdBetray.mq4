//+------------------------------------------------------------------+
//|                                                   MacdBetray.mq4 |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
extern int PriceBetray=10;  //价格背离的点数
extern int MacdBetray=10;
extern double Lots = 0.01;   //做单手数
//extern int LongWait=5;  //下单后，均线多长时间没给信号离场

bool Dealing=false;
bool Direction=false;
bool CrossType=false;  //true 金叉，false死叉
datetime DealTime=0;

bool GoldCross(double main_head, double main_tail, double signal_head, double signal_tail)   //main is fast line
{
   if(main_head-signal_head>MacdBetray*Point&&signal_tail-main_tail>MacdBetray*Point)
      return true;
   else   
      return false;
}

bool DeadCross(double main_head, double main_tail, double signal_head, double signal_tail)   
{      
   if(signal_head-main_head>MacdBetray*Point&&main_tail-signal_tail>MacdBetray*Point)
      return true;
   else
      return false;
}

bool MacdCross(double main_head, double main_tail, double signal_head, double signal_tail)   //main is fast line
{
   if(main_head>signal_head&&main_tail<signal_tail)
      return true;
      
   if(main_head<signal_head&&main_tail>signal_tail)
      return true;
    
   return false;
}

double Macd_Main(int shift)
{
   return iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
}
double Macd_Signal(int shift)
{
   return iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
}

void Deal(bool flag)
{
   if(flag)
   {
      if(OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,0,0,0,0)>0){
         Direction=true;
         Dealing=true;
         DealTime=TimeCurrent();
      }
   }
   if(!flag)
   {
      if(OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,0,0,0,0,0)>0){
         Direction=false;
         Dealing=true;
         DealTime=TimeCurrent();
      }
   }
}
void CloseDeal()
{
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
   
   Dealing=false;
}

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
   
   double lots=AccountFreeMargin()*2/100000;
   if(lots>0.01)
      Lots=lots;      
   
   double Ma12_1=iMA(NULL,0,12,0,MODE_EMA,PRICE_CLOSE,1);
   double Ma50_1=iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,1);
      
      
   if(!Dealing&&int(TimeCurrent()-DealTime)>25*3600&&GoldCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2)))
   { 
      CrossType=true;     
      for(int i=3;i<150;i++)
      {      
         if(GoldCross(Macd_Main(i),Macd_Main(i+1),Macd_Signal(i),Macd_Signal(i+1)))
         {
            if((Macd_Main(1)+Macd_Main(2))/2>(Macd_Main(i)+Macd_Main(i+1)/2)&&(iClose(NULL,0,i)-iClose(NULL,0,1))/Point>PriceBetray)
            {
               Deal(true);
               break;
            }
            
            if((Macd_Main(1)+Macd_Main(2))/2<(Macd_Main(i)+Macd_Main(i+1)/2)&&(iClose(NULL,0,1)-iClose(NULL,0,i))/Point>PriceBetray)
            {
               Deal(true);
               break;
            }
            
         }
      }
   }
   
   if(!Dealing&&int(TimeCurrent()-DealTime)>25*3600&&DeadCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2)))
   { 
      CrossType=false;     
      for(int i=3;i<150;i++)
      {      
         if(DeadCross(Macd_Main(i),Macd_Main(i+1),Macd_Signal(i),Macd_Signal(i+1)))
         {
            
            if((Macd_Main(1)+Macd_Main(2))/2>(Macd_Main(i)+Macd_Main(i+1)/2)&&(iClose(NULL,0,i)-iClose(NULL,0,1))/Point>PriceBetray)
            {
               Deal(false);
               break;
            }
            
            if((Macd_Main(1)+Macd_Main(2))/2<(Macd_Main(i)+Macd_Main(i+1)/2)&&(iClose(NULL,0,1)-iClose(NULL,0,i))/Point>PriceBetray)
            {
               Deal(false);
               break;
            }
         }
      }
   }
   
   if(Dealing)
   {
      if(CrossType&&DeadCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2))) //Macd 反向×
      {
         if(Direction&&Ma12_1<Ma50_1)
            CloseDeal();
         if(!Direction&&Ma12_1>Ma50_1)
            CloseDeal();
      }
      
      if(!CrossType&&GoldCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2))) //Macd 反向×
      {
         if(Direction&&Ma12_1<Ma50_1)
            CloseDeal();
         if(!Direction&&Ma12_1>Ma50_1)
            CloseDeal();
      }
      
      if((Direction&&Ma12_1>Ma50_1)||(!Direction&&Ma12_1<Ma50_1)) //EMA给出了信号
      { 
         if(Direction&&DeadCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2)))
            CloseDeal();  
            
         if(!Direction&&GoldCross(Macd_Main(1),Macd_Main(2),Macd_Signal(1),Macd_Signal(2)))
            CloseDeal();  
      }
   }          
}
//+------------------------------------------------------------------+
