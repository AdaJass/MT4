//+------------------------------------------------------------------+
//|                                                 StableSignal.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2
#include <Variance.mqh>

input int SmoothPeriod=12;   // 
input int DoubleSmooth=100;
input int VariancePeriod=6;

//--- indicator buffers

double    ExtStandarBuffer[];
double    ExtSignalBuffer[];
double    ExtStableBuffer[];
double    StandarBar=0.0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
   double all=0.0;
   for(int i=1;i<101;i++)
      all+=MathAbs(iClose(NULL,NULL,i)-iOpen(NULL,NULL,i));
   StandarBar=all/100;
   IndicatorBuffers(3);
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   //SetIndexDrawBegin(2,SmoothPeriod+10);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtStandarBuffer);
   SetIndexBuffer(1,ExtSignalBuffer);
   SetIndexBuffer(2,ExtStableBuffer);
//--- name for DataWindow and indicator subwindow label   
   SetIndexLabel(0,"Stable");
   SetIndexLabel(1,"Signal");
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---
   int i,limit;
//---
   if(rates_total<=SmoothPeriod+20)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit++;
//--- macd counted in the 1-st buffer
   double tem=0.0;
   for(i=0; i<limit; i++)
   {
      //Print(i);
      ExtStableBuffer[i]=1000*MathLog(BDVariance(i,VariancePeriod)); 
   
      
   }
   for(i=0; i<limit;i++)
   {
   
      tem=0.0; 
      if(limit>100&&limit-i<SmoothPeriod+1){
         ExtSignalBuffer[i]=ExtStableBuffer[i];
         break;
      }            
      for(int j=0;j<SmoothPeriod;j++)
      {
         tem+=ExtStableBuffer[i+j];                       
      }
      ExtSignalBuffer[i]=tem/SmoothPeriod;
   }
   
   for(i=0; i<limit;i++)
   {
   
      tem=0.0; 
      if(limit>100&&limit-i<DoubleSmooth+1){
         ExtStandarBuffer[i]=ExtStableBuffer[i];
         break;
      }            
      for(int j=0;j<DoubleSmooth;j++)
      {
         tem+=ExtStableBuffer[i+j];                       
      }
      ExtStandarBuffer[i]=0.95*tem/DoubleSmooth;
   }
   
      
      
   //SimpleMA(rates_total, SmoothPeriod, ExtStandarBuffer);
//--- signal line counted in the 2-nd buffer
   //SimpleMAOnBuffer(rates_total,prev_calculated,0,3,ExtStandarBuffer,ExtSignalBuffer);
//--- done
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
