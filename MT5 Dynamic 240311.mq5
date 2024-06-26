//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

ulong EAMagic = 123; //EA Magic Number

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CTrade trade; //实例化一个对象为trade
CSymbolInfo iSymbol;

datetime  iniNowTime=0;

int NACtrl=0;

int TakeProfit = 100;

input int MaxTrades = 100;
int Distance = 100;
double Lots = 0.01;

input string ForDirection = "1 - SELL, 2 - BUY, others invalid";
int Direction = 3;
int DirectionTemp = 3;

double   FirstOpenBid;
double   FirstOpenAsk;
string   FirstDistanceS;
string   FirstDistanceB;

//double   HighSell=0, LowBuy=99999;

double Bid = 0.0;
double Ask = 0.0;

double NowBid=0.0, NowAsk = 0.0;

string Direction1 = "N/A";
string Direction2;

double   LOT,MINLOT;

double MaxLossRate=8.0;

double    NowEquity=0;
double    NowEquitydEquity;
double    NowEquityPercent;
double    iniNowEquity=0;
double    iniNowEquitydEquity;
double    iniNowEquitydEquityP;
double    NowEquitydEqP;

//+------------------------------------------------------------------+
//| Expert initialization function |
//+------------------------------------------------------------------+
int OnInit()
  {
   iSymbol.Name(Symbol());

   if(!iSymbol.Name(Symbol())) // sets symbol name
      return(INIT_FAILED);
   RefreshRates();

   trade.SetExpertMagicNumber(EAMagic);

   MyButton();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   Comment("");
  }


//Lots按钮
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)

  {

//按钮 start
   if(id==CHARTEVENT_OBJECT_CLICK)
     {

      //MaxLossRate按钮 start
      if(sparam=="MaxLossUp")//按上
        {
         MaxLossRate=MaxLossRate+0.1;

         ObjectSetString(0,"MaxLossRateText",OBJPROP_TEXT,DoubleToString(MaxLossRate,1));
         ObjectSetInteger(0,"MaxLossUp",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }


      if(sparam=="MaxLossDown")//按下
        {
         MaxLossRate=MaxLossRate-0.1;
         ObjectSetString(0,"MaxLossRateText",OBJPROP_TEXT,DoubleToString(MaxLossRate,1));
         ObjectSetInteger(0,"MaxLossDown",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="MaxLossUp1")//按上
        {
         MaxLossRate=MaxLossRate+1.0;

         ObjectSetString(0,"MaxLossRateText",OBJPROP_TEXT,DoubleToString(MaxLossRate,1));
         ObjectSetInteger(0,"MaxLossUp1",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="MaxLossDown1")//按下
        {
         MaxLossRate=MaxLossRate-1.0;
         ObjectSetString(0,"MaxLossRateText",OBJPROP_TEXT,DoubleToString(MaxLossRate,1));
         ObjectSetInteger(0,"MaxLossDown1",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      //Distance按钮 start
      if(sparam=="TakeProfit10P")//按上
        {
         TakeProfit=TakeProfit+10;   //
         ObjectSetString(0,"TakeProfit",OBJPROP_TEXT,IntegerToString(TakeProfit));
         ObjectSetInteger(0,"TakeProfit10P",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }


      if(sparam=="TakeProfit10M")//按下
        {
         TakeProfit=TakeProfit-10;
         if(TakeProfit<=30)
           {
            TakeProfit=30;
           }
         ObjectSetString(0,"TakeProfit",OBJPROP_TEXT,IntegerToString(TakeProfit));
         ObjectSetInteger(0,"TakeProfit10M",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="TakeProfit100P")//按上
        {
         TakeProfit=TakeProfit+100;   //
         ObjectSetString(0,"TakeProfit",OBJPROP_TEXT,IntegerToString(TakeProfit));
         ObjectSetInteger(0,"TakeProfit100P",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="TakeProfit100M")//按下
        {
         TakeProfit=TakeProfit-100;
         if(TakeProfit<=100)
           {
            TakeProfit=100;
           }
         ObjectSetString(0,"TakeProfit",OBJPROP_TEXT,IntegerToString(TakeProfit));
         ObjectSetInteger(0,"TakeProfit100M",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="TakeProfitI")
        {
         TakeProfit=(MathRound(TakeProfit/100))*100;// 取整
         ObjectSetString(0,"TakeProfit",OBJPROP_TEXT,IntegerToString(TakeProfit));
         ObjectSetInteger(0,"TakeProfitI",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      //Lots按钮 start
      if(sparam=="LOT001P")//按上
        {
         Lots=Lots+0.01;   //
         ObjectSetString(0,"LOT",OBJPROP_TEXT,DoubleToString(Lots,2));
         ObjectSetInteger(0,"LOT001P",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="LOT001M")//按下
        {
         Lots=Lots-0.01;
         if(Lots<=0.01)
           {
            Lots=0.01;
           }
         ObjectSetString(0,"LOT",OBJPROP_TEXT,DoubleToString(Lots,2));
         ObjectSetInteger(0,"LOT001M",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="LOTP")
        {
         Lots=Lots+0.1;   //
         ObjectSetString(0,"LOT",OBJPROP_TEXT,DoubleToString(Lots,2));
         ObjectSetInteger(0,"LOTP",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="LOTM")//按下
        {
         Lots=Lots-0.1;
         if(Lots<=0.01)
           {
            Lots=0.01;
           }
         ObjectSetString(0,"LOT",OBJPROP_TEXT,DoubleToString(Lots,2));
         ObjectSetInteger(0,"LOTM",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      //Distance按钮 start
      if(sparam=="Distance10P")
        {
         Distance=Distance+10;   //
         ObjectSetString(0,"Distance",OBJPROP_TEXT,IntegerToString(Distance));
         ObjectSetInteger(0,"Distance10P",OBJPROP_STATE,false);
         ChartRedraw();
         return;
        }

      if(sparam=="Distance10M")
        {
         Distance=Distance-10;   //
         ObjectSetString(0,"Distance",OBJPROP_TEXT,IntegerToString(Distance));
         ObjectSetInteger(0,"Distance10M",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }

      if(sparam=="Distance100P")
        {
         Distance=Distance+100;   //
         ObjectSetString(0,"Distance",OBJPROP_TEXT,IntegerToString(Distance));
         ObjectSetInteger(0,"Distance100P",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }

      if(sparam=="Distance100M")
        {
         Distance=Distance-100;   //
         ObjectSetString(0,"Distance",OBJPROP_TEXT,IntegerToString(Distance));
         ObjectSetInteger(0,"Distance100M",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }
      //Distance按钮 end

      //DiNA,Direction按钮 start
      //extern string ForDirection = "1 - SELL, 2 - BUY, others invalid";
      if(sparam=="DirectionNotNA")
        {
         NACtrl=2;
         Direction=DirectionTemp;
         if(DirectionTemp==2)
            Direction1="Buy";
         if(DirectionTemp==1)
            Direction1="Sell";
         ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);
         ObjectSetInteger(0,"DirectionNotNA",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }



      if(sparam=="DiNA")
        {
         NACtrl=1;
         Direction=3;
         Direction1="N/A";
         ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);
         ObjectSetInteger(0,"DiNA",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }




      if(sparam=="DirectionP")//按上
        {
         Direction=2;   // 2 - BUY,
         Direction1="Buy";
         ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);
         ObjectSetInteger(0,"DirectionP",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }

      if(sparam=="DirectionM")//按上
        {
         Direction=1;   // 1 - SELL,
         Direction1="Sell";
         ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);
         ObjectSetInteger(0,"DirectionM",OBJPROP_STATE,0);
         ChartRedraw();
         return;
        }
      //DiNA,Direction按钮 end
     }
//按钮 end
  }

//+------------------------------------------------------------------+
//| SetLab                                                           |
//+------------------------------------------------------------------+
void SetLabel(string name,int x,int y,int corner,string text,int fontsize,string fontname,color clr=-1)
  {
   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetString(0,name,OBJPROP_FONT,fontname);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);

  }

//+------------------------------------------------------------------+
//| Expert tick function |
//+------------------------------------------------------------------+
void OnTick()
  {
   RefreshRates();

//MaxLossRate start
   if((-(NowEquityPercent))<=MaxLossRate & Direction!=3)
     {
      DirectionTemp=Direction;
     }

   if((-(NowEquityPercent))<=MaxLossRate & NACtrl!=1)
     {
      Direction=DirectionTemp;

      if(Direction==2)
         Direction1="Buy";
      if(Direction==1)
         Direction1="Sell";
      ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);

     }

   if((-(NowEquityPercent))>MaxLossRate)
     {
      NACtrl=2;
      Direction=3;
      Direction1="N/A";
      ObjectSetString(0,"Direction",OBJPROP_TEXT,Direction1);
     }


   Ask = iSymbol.Ask();
   Bid = iSymbol.Bid();
//if(Direction==1 || Direction==2 || Direction==3)
   if(Direction==1 || Direction==2)
     {
      if(NowBid==0.0)
        {
         NowBid=Bid;
        }

      if(NowAsk==0.0)
        {
         NowAsk=Ask;
        }

     }
   if(Direction==1 && number(POSITION_TYPE_SELL)==0)  //开空
     {
      if(Bid-NowBid >= Distance*SymbolInfoDouble(Symbol(),SYMBOL_POINT))
        {
         trade.Sell(Lots,Symbol(),Bid,0,Bid-TakeProfit*iSymbol.Point(),"Test");
         return;
        }
     }

   if(Direction==2 && number(POSITION_TYPE_BUY)==0)  //开多
     {
      if(NowAsk-Ask>=Distance*SymbolInfoDouble(Symbol(),SYMBOL_POINT))
        {
         trade.Buy(Lots,Symbol(),Ask,0,Ask+TakeProfit*iSymbol.Point(),"Test");
         return;
        }
     }


   double   HighSell=0, LowBuy=99999;

   for(int i = PositionsTotal()-1; i >=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket))
         continue;
      if(PositionGetString(POSITION_SYMBOL) != Symbol() || PositionGetInteger(POSITION_MAGIC) !=  EAMagic)
         continue;
      if((PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL))
        {
         if(HighSell<PositionGetDouble(POSITION_PRICE_OPEN))
            HighSell=PositionGetDouble(POSITION_PRICE_OPEN);
        }

      if((PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY))
        {
         if(LowBuy>PositionGetDouble(POSITION_PRICE_OPEN))
            LowBuy=PositionGetDouble(POSITION_PRICE_OPEN);
        }
     }

   int sellorders = number(POSITION_TYPE_SELL);
   if(Direction==1 && sellorders>0 && sellorders<MaxTrades)   //开空
     {
      if(Bid-HighSell>=TakeProfit*Point())
        {
         trade.Sell(Lots,Symbol(),Bid,0,Bid-TakeProfit*iSymbol.Point(),"Test");
         return;
        }
     }

   int buyorders = number(POSITION_TYPE_BUY);
   if(Direction==2 && buyorders>0 && buyorders<MaxTrades)   //开多
     {
      if(LowBuy-Ask>=TakeProfit*Point())
        {
         trade.Buy(Lots,Symbol(),Ask,0,Ask+TakeProfit*iSymbol.Point(),"Test");
         return;
        }
     }



//NowEquity-Deposit()   start
   if(NowEquity==0)
      NowEquity=AccountInfoDouble(ACCOUNT_EQUITY);
   NowEquitydEquity=AccountInfoDouble(ACCOUNT_EQUITY)-NowEquity;
//   NowEquitydEquity=ACCOUNT_EQUITY-NowEquity-Deposit(void);
   NowEquityPercent=(NowEquitydEquity/NowEquity)*100;
//NowEquity-Deposit()   end



//最大浮亏率 start
//err
   if(NowEquitydEqP>NowEquityPercent)
      NowEquitydEqP=NowEquityPercent;
//最大浮亏率 end

//FirstOpenBid start
   if(Direction==1 || Direction==3)
     {
      FirstOpenBid=NowBid+Distance*Point();
      FirstDistanceS=DoubleToString((FirstOpenBid-Bid)/Point(),0);
      //      FirstDistanceInt=StringToInteger(FirstDistance);
     }

   if(Direction==2 || Direction==3)
     {
      FirstOpenAsk=NowAsk-Distance*Point();
      FirstDistanceB=DoubleToString((Ask-FirstOpenAsk)/Point(),0);
      //      FirstDistanceInt=StringToInteger(FirstDistance);
     }
//FirstOpenBid end

//Dynamic start

//  TimeToString(i_order.Time(),TIME_DATE|TIME_SECONDS)


   datetime  NowTimeTest;

   NowTimeTest=TimeCurrent();

   if(iniNowTime==0)
     {
      iniNowTime=TimeCurrent();
      //      iniNowTime=datetime(PERIOD_MN1);
     }

   int iniNowTimeStringSubstrint;

   string iniNowTimeToString;
   iniNowTimeToString=TimeToString(iniNowTime,3);
   string iniNowTimeStringSubstr;

   iniNowTimeStringSubstr=StringSubstr(iniNowTimeToString,5,2);
   iniNowTimeStringSubstrint=StringToInteger(iniNowTimeStringSubstr);


   int MNowTimeDvalue;
   SetLabel("iniNowTime",1800,100,0,"iniNowTime=     "+TimeToString(iniNowTime,3),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移
   SetLabel("NowTimeTestvalue",1800,140,0,"NowTimeTestvalue=     "+TimeToString(NowTimeTest,3),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移
   SetLabel("NowTimeTestDATE",1800,180,0,"NowTimeTestDATE=         "+TimeToString(NowTimeTest,TIME_DATE),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移

   SetLabel("NowTimeTestMINUTES",1800,220,0,"NowTimeTestMINUTES=         "+TimeToString(NowTimeTest,TIME_MINUTES),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移

   SetLabel("iniNowTimeStringSubstr",1800,260,0,"iniNowTimeStringSubstr=     "+StringSubstr(iniNowTimeStringSubstr,0,4),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移

   SetLabel("iniNowTimeStringSubstrint",1800,300,0,"iniNowTimeStringSubstrint=     "+IntegerToString(iniNowTimeStringSubstrint),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移











//Dynamic start



//iniNowEquitydEqP
   SetLabel("NowEquity",1800,350,0,"NowEquity=     "+DoubleToString(NowEquity,2),18,"Verdana",Red);//前X，数值大，左移。后Y，数值大，下移；数值小，上移
   SetLabel("AccountEquity",1800,380,0,"AccountEquity="+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2),18,"Verdana",Red);
   SetLabel("AccountEquity-NowEquity)D",1800,410,0,"(AccountEquity-NowEquity)D="+DoubleToString(NowEquitydEquity,2),18,"Verdana",Red);
   SetLabel("AccountEquity-NowEquity)P",1800,440,0,"NowEquityPercent="+DoubleToString(NowEquityPercent,2),18,"Verdana",Red);
   SetLabel("MaxLossRateSetLable",1800,470,0,"MaxLossRate="+DoubleToString(NowEquitydEqP,2),18,"Verdana",Red);
   SetLabel("ACCOUNT_CREDIT",1800,500,0,"ACCOUNT_CREDIT="+DoubleToString(AccountInfoDouble(ACCOUNT_CREDIT),2),18,"Verdana",Red);
   SetLabel("TakeProfit1",1800,530,0,"TakeProfit="+IntegerToString(TakeProfit),18,"Verdana",Red);
// TakeProfit

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(Direction==1 || DirectionTemp==1)//Sell
     {
      SetLabel("NowBid",1600,90,0,"NowBid=       "+DoubleToString(NowBid,_Digits),18,"Verdana",clrRed);//Sell //前X，数值大，左移；后Y，数值大，下移
      SetLabel("Bid",1600,110,0,"Bid=              "+DoubleToString(Bid,_Digits),18,"Verdana",clrRed);//Sell
      SetLabel("FirstOpenBid",1600,130,0,"FirstOpenBid="+DoubleToString(FirstOpenBid,_Digits),18,"Verdana",clrRed);//前X，数值大，左移；后Y，数值大，下移
      SetLabel("FirstDistanceS",1600,150,0,"FirstDistanceS=   "+FirstDistanceS,18,"Verdana",clrRed);//Sell
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(DirectionTemp==2 & Direction==2)
     {
      ObjectDelete(0,"NowBid");
      ObjectDelete(0,"Bid");
      ObjectDelete(0,"FirstOpenBid");
      ObjectDelete(0,"FirstDistanceS");
      NowBid=0;
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(Direction==2 || DirectionTemp==2)//Buy
     {
      SetLabel("NowAsk",1000,10,0,"NowAsk=       "+DoubleToString(NowAsk,_Digits),18,"Verdana",clrRed);//前X，数值大，左移；后Y，数值大，下移
      SetLabel("Ask",1000,50,0,"Ask=              "+DoubleToString(Ask,_Digits),18,"Verdana",clrRed);
      SetLabel("FirstOpenAsk",1000,90,0,"FirstOpenAsk="+DoubleToString(FirstOpenAsk,_Digits),18,"Verdana",clrRed);
      SetLabel("FirstDistanceB",1000,130,0,"FirstDistanceB=   "+FirstDistanceB,18,"Verdana",clrRed);
      //      ObjectDelete(0,"NowAsk");
      //      NowAsk=0;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(DirectionTemp==1 & Direction==1)
     {
      ObjectDelete(0,"NowAsk");
      ObjectDelete(0,"Ask");
      ObjectDelete(0,"FirstOpenAsk");
      ObjectDelete(0,"FirstDistanceB");

      //      ObjectDelete(0,"NowAsk");
      NowAsk=0;
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   Comment("Distance=",Distance,"\n","FirstOpenBid=",FirstOpenBid,"\n","FirstDistanceS=",FirstDistanceS,"\n","NowBid:=",NowBid,"\n","Bid:=",Bid,"\n",
           "HighSell:=",HighSell,"\n","LowBuy:=",LowBuy,"\n","DirectionTemp:=",DirectionTemp,"\n","Direcion:=",Direction,"\n","Direcion1:=",Direction1,"\n",
           "NACtrl:=",NACtrl);
   return;
//Direction1
  }
//+------------------------------------------------------------------+
//| Trade function |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int number(ENUM_POSITION_TYPE mode)
  {
   int n=0;

   for(int i = PositionsTotal()-1; i >=0; i--)
     {
      ulong ticket = PositionGetTicket(i);

      if(!PositionSelectByTicket(ticket))
         continue;

      if(PositionGetInteger(POSITION_TYPE) == mode
         && PositionGetString(POSITION_SYMBOL) == Symbol()
         && PositionGetInteger(POSITION_MAGIC) ==  EAMagic)
        {
         n++;
        }
     }

   return(n);
  }


//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRates()
  {
//--- refresh rates
   if(!iSymbol.RefreshRates())
     {
      Print("RefreshRates error");
      return(false);
     }
//--- protection against the return value of "zero"
   if(iSymbol.Ask()==0 || iSymbol.Bid()==0)
      return(false);
//---
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyButton()
  {

//按钮套中套start
   int YDISTANCE1=100;//数值小，上移
   int YDISTANCE2=YDISTANCE1-20;
   int YDISTANCE3=YDISTANCE1-1;
   int XDISTANCE=150;
// MaxLossRate按钮 start
   createbuttom("MaxLossUp","5",XDISTANCE,YDISTANCE1+236,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("MaxLossDown","6",XDISTANCE,YDISTANCE1+251,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移

   createbuttom("MaxLossUp1","5",XDISTANCE,YDISTANCE1+266,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("MaxLossDown1","6",XDISTANCE,YDISTANCE1+281,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移

//显示MaxLossRate文本框
   createedit("MaxLossRateText",DoubleToString(MaxLossRate,1),XDISTANCE+68,YDISTANCE3+251,60,25,clrRed,clrBlack,"微软雅黑",12,CORNER_RIGHT_UPPER);
//显示MaxLossRate Lable
   createlabel("MaxLossRateLabel","MaxLossR",XDISTANCE+248,YDISTANCE3+253,120,25,clrRed,clrNONE,"微软雅黑",12,CORNER_RIGHT_UPPER);
// MaxLossRate按钮 end

// TakeProfit按钮 start
   createbuttom("TakeProfit10P","5",XDISTANCE,YDISTANCE1+50,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("TakeProfit10M","6",XDISTANCE,YDISTANCE1+65,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("TakeProfit100P","5",XDISTANCE,YDISTANCE1+80,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("TakeProfit100M","6",XDISTANCE,YDISTANCE1+95,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
   createbuttom("TakeProfitI","5",XDISTANCE+50,YDISTANCE1+50,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
//显示TakeProfit文本框
   createedit("TakeProfit",IntegerToString(TakeProfit),XDISTANCE+68,YDISTANCE3+66,60,25,clrRed,clrBlack,"微软雅黑",12,CORNER_RIGHT_UPPER);
//显示TakeProfitlabel
   createlabel("TakeProfitlabel","TakeProfit",XDISTANCE+254,YDISTANCE3+68,120,25,clrRed,clrNONE,"微软雅黑",12,CORNER_RIGHT_UPPER);
// TakeProfit按钮 end

//Distance按钮 start
   createbuttom("Distance10P","5",XDISTANCE,YDISTANCE1-30,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("Distance10M","6",XDISTANCE,YDISTANCE1-15,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("Distance100P","5",XDISTANCE,YDISTANCE1,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("Distance100M","6",XDISTANCE,YDISTANCE1+15,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
//显示Distance文本框
   createedit("Distance",IntegerToString(Distance),XDISTANCE+68,YDISTANCE3-13,60,25,clrRed,clrBlack,"微软雅黑",12,CORNER_RIGHT_UPPER);
//显示Distancelabel
   createlabel("Distancelabel","Distance",XDISTANCE+242,YDISTANCE3-10,120,25,clrRed,clrNONE,"微软雅黑",12,CORNER_RIGHT_UPPER);//X数值大，左移;Y数值大，下移
// TakeProfit按钮 end
//Distance按钮 end

//Lots按钮 start
   createbuttom("LOT001P","5",XDISTANCE,YDISTANCE1+150,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("LOT001M","6",XDISTANCE,YDISTANCE1+165,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("LOTP","5",XDISTANCE,YDISTANCE1+180,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("LOTM","6",XDISTANCE,YDISTANCE1+195,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
//显示LOT文本框
   createedit("LOT",DoubleToString(Lots,2),XDISTANCE+68,YDISTANCE3+165,60,25,clrRed,clrBlack,"微软雅黑",12,CORNER_RIGHT_UPPER);
//显示LOTlabel
   createlabel("LOTlabel","Lots",XDISTANCE+206,YDISTANCE3+166,120,25,clrRed,clrNONE,"微软雅黑",12,CORNER_RIGHT_UPPER);
//Lots按钮 end

//DiNA,Direction按钮 start
//extern string ForDirection = "1 - SELL, 2 - BUY, others invalid";
   createbuttom("DiNA","6",XDISTANCE+50,YDISTANCE1-95,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("DirectionNotNA","5",XDISTANCE+70,YDISTANCE1-95,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("DirectionP","5",XDISTANCE,YDISTANCE1-70,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
   createbuttom("DirectionM","6",XDISTANCE,YDISTANCE1-55,16,8,clrBlue,clrLightBlue,"Webdings",10,CORNER_RIGHT_UPPER);
//显示Direction文本框
   if(Direction==3)
      Direction1="N/A";
   createedit("Direction",Direction1,XDISTANCE+68,YDISTANCE3-70,60,25,clrRed,clrBlack,"微软雅黑",12,CORNER_RIGHT_UPPER);
//显示Directionlabel
   createlabel("Directionlabel","Direction",XDISTANCE+245,YDISTANCE3-78,120,25,clrRed,clrNONE,"微软雅黑",12,CORNER_RIGHT_UPPER);
//DiNA,Direction按钮 end

//按钮套中套end
  }



//生成按钮
void createbuttom(string 按钮名称,string 显示文字,int X,int Y,int 按钮长度,int 按钮高度,color 字体颜色,color 背景色,string 字体,int 字体大小,int 位置)
  {
//--- Create a button to send custom events
   ObjectCreate(0,按钮名称,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,按钮名称,OBJPROP_COLOR,字体颜色);
   ObjectSetInteger(0,按钮名称,OBJPROP_BGCOLOR,背景色);
   ObjectSetInteger(0,按钮名称,OBJPROP_BORDER_COLOR,背景色);
   ObjectSetInteger(0,按钮名称,OBJPROP_XDISTANCE,X);
   ObjectSetInteger(0,按钮名称,OBJPROP_YDISTANCE,Y);
   ObjectSetInteger(0,按钮名称,OBJPROP_CORNER,位置);
   ObjectSetInteger(0,按钮名称,OBJPROP_XSIZE,按钮长度);
   ObjectSetInteger(0,按钮名称,OBJPROP_YSIZE,按钮高度);
   ObjectSetString(0,按钮名称,OBJPROP_FONT,字体);
   ObjectSetString(0,按钮名称,OBJPROP_TEXT,显示文字);
   ObjectSetInteger(0,按钮名称,OBJPROP_FONTSIZE,字体大小);
   ObjectSetInteger(0,按钮名称,OBJPROP_SELECTABLE,0);
  }



//+---------------------------------------------------------------------------------------------------------------------------------------------+
//生成文字输入框
void createedit(string 编辑框名称,string 显示文字,int X,int Y,int 按钮长度,int 按钮高度,color 字体颜色,color 背景色,string 字体,int 字体大小,int 位置)
  {
//--- Create a button to send custom events
   ObjectCreate(0,编辑框名称,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,编辑框名称,OBJPROP_COLOR,字体颜色);
   ObjectSetInteger(0,编辑框名称,OBJPROP_BGCOLOR,背景色);
   ObjectSetInteger(0,编辑框名称,OBJPROP_XDISTANCE,X);
   ObjectSetInteger(0,编辑框名称,OBJPROP_YDISTANCE,Y);
   ObjectSetInteger(0,编辑框名称,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,编辑框名称,OBJPROP_CORNER,位置);
   ObjectSetInteger(0,编辑框名称,OBJPROP_XSIZE,按钮长度);
   ObjectSetInteger(0,编辑框名称,OBJPROP_YSIZE,按钮高度);
   ObjectSetString(0,编辑框名称,OBJPROP_FONT,字体);
   ObjectSetString(0,编辑框名称,OBJPROP_TEXT,显示文字);
   ObjectSetInteger(0,编辑框名称,OBJPROP_FONTSIZE,字体大小);
   ObjectSetInteger(0,编辑框名称,OBJPROP_SELECTABLE,0);
   ObjectSetInteger(0,编辑框名称,OBJPROP_HIDDEN,true);
  }


//+---------------------------------------------------------------------------------------------------------------------------------------------+
void createlabel(string 标签名称,string 显示文字,int X,int Y,int 标签长度,int 标签高度,color 字体颜色,color 背景色,string 字体,int 字体大小,int 位置)
  {
//--- Create a button to send custom events
   ObjectCreate(0,标签名称,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,标签名称,OBJPROP_COLOR,字体颜色);
   ObjectSetInteger(0,标签名称,OBJPROP_BGCOLOR,背景色);
   ObjectSetInteger(0,标签名称,OBJPROP_XDISTANCE,X);
   ObjectSetInteger(0,标签名称,OBJPROP_YDISTANCE,Y);
   ObjectSetInteger(0,标签名称,OBJPROP_CORNER,位置);
   ObjectSetInteger(0,标签名称,OBJPROP_XSIZE,标签长度);
   ObjectSetInteger(0,标签名称,OBJPROP_YSIZE,标签高度);
   ObjectSetString(0,标签名称,OBJPROP_FONT,字体);
   ObjectSetString(0,标签名称,OBJPROP_TEXT,显示文字);
   ObjectSetInteger(0,标签名称,OBJPROP_FONTSIZE,字体大小);
   ObjectSetInteger(0,标签名称,OBJPROP_SELECTABLE,0);
   ObjectSetInteger(0,标签名称,OBJPROP_HIDDEN,true);

  }

//+------------------------------------------------------------------+
