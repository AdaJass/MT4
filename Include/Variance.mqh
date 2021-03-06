//+------------------------------------------------------------------+
//|                                                     Variance.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
double HLVariance(int start_index, int count)  //波动方差
{
   double data[];
   ArrayResize(data,count,10);   
   double tem=0.0,sum=0.0;  
   for(int i=0;i<count;i++)
   {
      tem=MathAbs(iHigh(NULL,0,i+start_index)-iLow(NULL,0,i+start_index))/Point;
      data[i]=tem;
      sum+=tem;
   }
   double aver_X=sum/count;
   sum=0.0;
   for(int i=0;i<count;i++)
   {
      sum+=(data[i]-aver_X)*(data[i]-aver_X);
   }
   return sum/count;
}

double BDVariance(int start_index, int count)  //波动方差
{
   double data[];
   ArrayResize(data,count,10);   
   double tem=0.0,sum=0.0;  
   for(int i=0;i<count;i++)
   {
      tem=MathAbs(iOpen(NULL,0,i+start_index)-iClose(NULL,0,i+start_index))/Point;
      data[i]=tem;
      sum+=tem;
   }
   double aver_X=sum/count;
   sum=0.0;
   for(int i=0;i<count;i++)
   {
      sum+=(data[i]-aver_X)*(data[i]-aver_X);
   }
   return sum/count;
}

double SimpleMA(const int position,const int period,const double &price[])
  {
//---
   double result=0.0;
//--- check position
   if(position>=period-1 && period>0)
     {
      //--- calculate value
      for(int i=0;i<period;i++) result+=price[position-i];
      result/=period;
     }
//---
   return(result);
  }