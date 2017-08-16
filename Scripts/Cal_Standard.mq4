//+------------------------------------------------------------------+
//|                                                 Cal_Standard.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                                  jass.ada@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "jass.ada@qq.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   double all=0.0;
   for(int i=1;i<101;i++)
      all+=MathAbs(iClose(NULL,NULL,i)-iOpen(NULL,NULL,i));
   Print("average bar high is: ",all/100);
   
  }
//+------------------------------------------------------------------+
