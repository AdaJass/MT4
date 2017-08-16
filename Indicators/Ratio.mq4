//+------------------------------------------------------------------+
//|                                                        Ratio.mq4 |
//|                                                         Ada.Jass |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Ada.Jass"
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
//#property indicator_minimum    20
//#property indicator_maximum    100
#property indicator_buffers 2
#property indicator_color1  Yellow
#property indicator_color2  Blue

input int long_period=20;
input const string pair="US2000";

//--- indicator buffers 
double ExtYellowBuffer[]; 
double ExtBlueBuffer[]; 

//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
void OnInit(void) 
  { 
   IndicatorDigits(Digits);   
//--- line shifts when drawing 
   SetIndexShift(0,0); 
   SetIndexDrawBegin(0,0);
   SetIndexShift(1,0); 
   SetIndexDrawBegin(1,0);
   
//--- 3 indicator buffers mapping 
   SetIndexBuffer(0,ExtYellowBuffer); 
   SetIndexBuffer(1,ExtBlueBuffer); 
//--- drawing settings 
   SetIndexStyle(0,DRAW_LINE);  
   SetIndexStyle(1,DRAW_LINE);
//--- index labels 
   SetIndexLabel(0,"gold vs relate"); 
   SetIndexLabel(1,"Average"); 
  } 
//+------------------------------------------------------------------+ 
//| Bill Williams' Alligator                                         | 
//+------------------------------------------------------------------+ 
int OnCalculate(const int rates_total, 
                const int prev_calculated, 
                const datetime &time[], 
                const double &open[], 
                const double &high[], 
                const double &low[], 
                const double &close[], 
                const long &tick_volume[], 
                const long &volume[], 
                const int &spread[]) 
  { 
   int limit=rates_total-prev_calculated;
   /* 
   ArraySetAsSeries(ExtYellowBuffer,true);
   ArraySetAsSeries(ExtBlueBuffer,true);     
   ArraySetAsSeries(close,true);
   */
   
   if(prev_calculated>0)
      limit++;
   
//--- main loop 
   double exblue=0.0;
   double relate=0.0;  
   
   for(int i=0; i<limit; i++) 
   { 
      relate=iClose(pair,ChartPeriod(),i);
      
      if(relate>0.1)
      {
         ExtYellowBuffer[i]=close[i]/relate;
         
      }else{
         ExtYellowBuffer[i]=0.0;
      }  
   }
   
   for(int i=0; i<limit; i++) 
   {  
      exblue=0.0; 
      if(limit>100&&limit-i<25){
         ExtBlueBuffer[i]=ExtYellowBuffer[i];
         break;
      }            
      for(int j=0;j<long_period;j++)
      {
         exblue=exblue+ExtYellowBuffer[i+j];                       
      }
      ExtBlueBuffer[i]=exblue/long_period;
   }


   return(rates_total); 
  }