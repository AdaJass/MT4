//+------------------------------------------------------------------+
//|                                                     StockAus.mq4 |
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
   
   int file_handle=FileOpen("data//StockRelative.csv",FILE_READ|FILE_WRITE|FILE_CSV,','); 
   double cn50[];
   double aus200[];
   double aud_high[];
   double aud_low[];
   double aud_close[];
   datetime timeaud[];
   datetime timeaus[];
   datetime timecn[];
   int Profit=150;
   int StopLoss=200;
   /*
   ArraySetAsSeries(cn50,true); 
   ArraySetAsSeries(aus200,true); 
   ArraySetAsSeries(audusd,true); 
   ArraySetAsSeries(timeaud,true); 
   ArraySetAsSeries(timeaus,true); 
   ArraySetAsSeries(timecn,true); 
   */      
   CopyClose("CN50",PERIOD_H1,0,6200,cn50);
   CopyTime("CN50",PERIOD_H1,0,6200,timecn);
   
   CopyHigh("AUDUSD",PERIOD_H1,0,20200,aud_high);
   CopyLow("AUDUSD",PERIOD_H1,0,20200,aud_low);
   CopyClose("AUDUSD",PERIOD_H1,0,20200,aud_close);
   CopyTime("AUDUSD",PERIOD_H1,0,20200,timeaud);
   
   CopyClose("AUS200",PERIOD_H1,0,20200,aus200);
   CopyTime("AUS200",PERIOD_H1,0,20200,timeaus);
   
   /*
   if(file_handle!=INVALID_HANDLE) 
   { 
      Print(TimeYear(timeaud[0]),"-",TimeMonth(timeaud[0]),"-",TimeDay(timeaud[0]),"  ",TimeHour(timeaud[0]),":",TimeMinute(timeaud[0])); 
      int n=0; 
      string timestring="";    
      for(int i=0;i<5100;i++){ 
         timestring=TimeYear(timeaud[i])+"-"+TimeMonth(timeaud[i])+"-"+TimeDay(timeaud[i])+"  "+TimeHour(timeaud[i])+":"+TimeMinute(timeaud[i]);             
         if(n<5100&&TimeHour(timeaud[i])==TimeHour(timeaus[n]))   
            FileWrite(file_handle,timestring,aus200[n],cn50[n++],audusd[i]); 
         else
            FileWrite(file_handle,timestring,audusd[i]);
      }
      //--- close the file 
      FileClose(file_handle);       
   } 
   else{
      PrintFormat("Failed to open %s file, Error code = %d",Symbol(),GetLastError()); 
   }
   */
   string timestringaud=TimeYear(timeaud[0])+"-"+TimeMonth(timeaud[0])+"-"+TimeDay(timeaud[0])+"  "+TimeHour(timeaud[0])+":"+TimeMinute(timeaud[0]);
   string timestringcn=TimeYear(timecn[0])+"-"+TimeMonth(timecn[0])+"-"+TimeDay(timecn[0])+"  "+TimeHour(timecn[0])+":"+TimeMinute(timecn[0]);
   string timestringaus=TimeYear(timeaus[0])+"-"+TimeMonth(timeaus[0])+"-"+TimeDay(timeaus[0])+"  "+TimeHour(timeaus[0])+":"+TimeMinute(timeaus[0]);

   Print("aud: ",timestringaud,"   cn: ",timestringcn,"   aus: ",timestringaus);
   int cn_n=0,aud_n=0,aus_n=0;
   double cn_gap=0.0,aus_gap=0.0,aud_gap=0.0;
   int win=0,lose=0;
   
   while(cn_n<6125)
   {
      if(TimeHour(timecn[cn_n])!=10){
         cn_n++;
         continue;
      }
      if(timeaud[aud_n]<timecn[cn_n]){
         aud_n++;
         continue;
      }
      
      if(timeaus[aus_n]<timecn[cn_n]){
         aus_n++;
         continue;
      }
      
      if(cn_n<6||aus_n<6||aud_n<6)
      {
         cn_n++;
         continue;
      }
      if(MathAbs(timecn[cn_n]-timeaus[aus_n])>3600)
      {
         cn_n++;
         continue;
      }
      cn_gap=cn50[cn_n]-cn50[cn_n-6];
      aus_gap=aus200[aus_n]-aus200[aus_n-6];
      aud_gap=aud_close[aud_n]-aud_close[aud_n-6];      
      
      if(MathAbs(cn_gap)>5){
         timestringaud=TimeYear(timeaud[aud_n])+"-"+TimeMonth(timeaud[aud_n])+"-"+TimeDay(timeaud[aud_n])+"  "+TimeHour(timeaud[aud_n])+":"+TimeMinute(timeaud[aud_n]);
         timestringcn=TimeYear(timecn[cn_n])+"-"+TimeMonth(timecn[cn_n])+"-"+TimeDay(timecn[cn_n])+"  "+TimeHour(timecn[cn_n])+":"+TimeMinute(timecn[cn_n]);
         timestringaus=TimeYear(timeaus[aus_n])+"-"+TimeMonth(timeaus[aus_n])+"-"+TimeDay(timeaus[aus_n])+"  "+TimeHour(timeaus[aus_n])+":"+TimeMinute(timeaus[aus_n]);
         
         if(cn_gap>10){
            Print("aud: ",timestringaud,"   cn: ",timestringcn,"   aus: ",timestringaus," --buy");
            if(aud_close[aud_n]-aud_low[aud_n+1]>StopLoss*0.00001||aud_close[aud_n]-aud_low[aud_n+2]>StopLoss*0.00001)
               lose++;
            else if(aud_high[aud_n+1]-aud_close[aud_n]>Profit*0.00001||aud_high[aud_n+2]-aud_close[aud_n]>Profit*0.00001)
               win++;            
         }
         if(cn_gap<-10){
            Print("aud: ",timestringaud,"   cn: ",timestringcn,"   aus: ",timestringaus,"  --sell");
            if(aud_high[aud_n+1]-aud_close[aud_n]>StopLoss*0.00001||aud_high[aud_n+2]-aud_close[aud_n]>StopLoss*0.00001)
               lose++;
            else if(aud_close[aud_n]-aud_low[aud_n+1]>Profit*0.00001||aud_close[aud_n]-aud_low[aud_n+2]>Profit*0.00001)
               win++;            
         }
      
      }
      cn_n++;      
   }
   Print("Win: ",win," Lose: ",lose);       
}
//+------------------------------------------------------------------+
 