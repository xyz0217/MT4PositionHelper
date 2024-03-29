//+------------------------------------------------------------------+
//|                                         MQL45LibraryFunction.mqh |
//|                                          Copyright 2023, xyz0217 |
//|                                                   xyz0217@qq.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, xyz0217"
#property link      "https://zhuanlan.zhihu.com/p/619251599"
#property version   "1.00"
#property strict /*

//此代码是在GPL-3.0许可下发布的。 如引用文件或 部分函数 请保留原作者信息 尽量开源代码
//This code is released under the GPL-3.0 license.
//原作者 xyz0217 小鹏 https://zhuanlan.zhihu.com/p/619251599  QQ群 221696452

查看 函数说明 使用Alt+M 或者 请直接 向下搜索 vvv
自定义函数 我会尽量使用MQL4和MQL5都可以使用的代码 这样MT4和MT5都可以引用 如果有些不能引用 可能是有变量造成的 请单提取出函数 加入主程序
MQL5部分 我一般会先空着 等以后有机会补充 如果发现 在MQL5编译时 函数返回0 就是MQL5代码部分 没有写 我会开源到 github 如果你用更好用的自定义函数
或者对MQL5代码很熟悉 欢迎一起维护 作者对MQL5不熟悉 很多代码都只能空着 哈哈。
引入文件时 经常会遇到 Magic EA和库文件 的名称 冲突 请改EA里的 Magic 为 MAGIC 选择全部替换时 不要忘了 打钩 仅有匹配的文字 区分大小写

编写EA或面板 引用这个库文件 编写规范建议 如果注意细节 您编写的代码 就可以在MT4 MT5上通用了 首先把下面一段代码 放到 EA的 OnTick函数里 放最靠上面位置 解决通用编译问题
1.可以继续使用 Ask Bid 
2.有些Time 相关的函数 4 5 不一样 使用时 统一使用 比如 Hour() 换成  timeCurrent.hour timeLocal.hour 就可以通用编译了
3.账户相关的函数使用 AccountInfoDouble(ACCOUNT_PROFIT) 改括号里面的值 

/*编写EA或面板  引用这个文件  在MQL4或MQL5上编译时 需要把下面 这段 注释代码里的 代码 放到 EA的 OnTick函数里 放最靠上面位置 解决通用编译问题

////////////////////////////////////////// 下面这段是 MQL45LibraryFunction.mqh 使用 不是MQL5编译 请忽略
TimeToStruct(TimeCurrent(),timeCurrent);//Time 相关的函数 4 5 不一样 使用时 统一使用 比如 Hour() 换成  timeCurrent.hour timeLocal.hour 就可以通用编译了
TimeToStruct(TimeLocal(),timeLocal);
#ifdef __MQL5__  //MQL5编译时 把这段代码 放到 OnTick函数 最上面 模拟 MT4里的Bid Ask 防止MT4上的EA改写到MT5时报错
   if(SymbolInfoTick(_Symbol,last_tick1))//在MQL5上模拟Bid Ask
     {
      last_tick_time=last_tick1.time;//最新一个Tick的 time
      Bid=last_tick1.bid;// 最新一个Tick的 Bid
      Ask=last_tick1.ask;// 最新一个Tick的 Ask
      last_tick_last=last_tick1.last;
      last_tick_volume=last_tick1.volume;
     }
#endif
///////////////////////////////////////// MQL45LibraryFunction.mqh 使用 结束

*/////////////////////////// 代码开始 vvv
MqlDateTime timeCurrent;
MqlDateTime timeLocal;
#ifdef __MQL5__          //MQL5编译的代码
MqlTick last_tick1;
datetime last_tick_time;
double Bid,Ask,last_tick_last;
ulong last_tick_volume;

#include <Trade\AccountInfo.mqh>
CAccountInfo AccountInfo;
#include <Trade\Trade.mqh>
CTrade Trade;
enum TypeOfFilling //Filling Mode
  {
   FOK,//ORDER_FILLING_FOK
   RETURN,// ORDER_FILLING_RETURN
   IOC,//ORDER_FILLING_IOC
  };
input TypeOfFilling  useORDER_FILLING_RETURN=FOK; //Execution mode
#else           //MQL4编译的代码

#endif          //选择性编译结束
/////
/*  函数模板  
#ifdef __MQL5__ //MQL5编译的代码
return(0);
#else           //MQL4编译的代码

#endif          //选择性编译结束
*/
////////////////////////////
double GetLastBuyPrice(int Magic)//获取Buy订单相关的 最近一个订单的价格 vvv
  {
#ifdef __MQL5__ //MQL5编译的代码
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      return(OrderGetDouble(ORDER_PRICE_OPEN));
      break;
     }
   return(0);
#else           //MQL4编译的代码

   int total=OrdersTotal()-1;
   for(int cnt = total ; cnt >=0 ; cnt--)
     {
      int a=OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && (OrderType()==OP_BUYSTOP || OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT))
        {
         return(OrderOpenPrice());
         break;
        }
     }
   return(0);
#endif         //选择性编译结束
  }
///////////////////////////////////////////////
double GetLastBuyLot(int Magic)//获取Buy订单相关的 最近一个订单的手数 vvv
  {
#ifdef __MQL5__ //MQL5编译的代码
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      return(OrderGetDouble(ORDER_VOLUME_CURRENT));
      break;
     }
   return(0);
#else           //MQL4编译的代码

   int total=OrdersTotal()-1;
   for(int cnt = total ; cnt >=0 ; cnt--)
     {
      int a=OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && (OrderType()==OP_BUYSTOP || OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT))
        {
         return(OrderLots());
         break;
        }
     }
   return(0);
#endif
  }
///////////////////////////////////////////////
double GetLastSellPrice(int Magic)//获取Sell订单相关的 最近一个订单的价格 vvv
  {
#ifdef __MQL5__ //MQL5编译的代码
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      return(OrderGetDouble(ORDER_PRICE_OPEN));
      break;
     }
   return(0);
#else         //MQL4编译的代码
   int total=OrdersTotal()-1;

   for(int cnt = total ; cnt >=0 ; cnt--)
     {
      int a= OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && (OrderType()==OP_SELLSTOP ||OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT))
        {
         return(OrderOpenPrice());
         break;
        }
     }
   return(0);
#endif
  }
/////////////////////////////////////////////////
double GetLastSellLot(int Magic)//获取Sell订单相关的 最近一个订单的 手数 vvv
  {
#ifdef __MQL5__ //MQL5编译的代码
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      return(OrderGetDouble(ORDER_VOLUME_CURRENT));
      break;
     }
   return(0);
#else //MQL4编译的代码
   int total=OrdersTotal()-1;
   for(int cnt = total ; cnt >=0 ; cnt--)
     {
      int a= OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && (OrderType()==OP_SELLSTOP ||OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT))
        {
         return(OrderLots());
         break;
        }
     }
   return(0);
#endif
  }
/////////////////////////////////////////////////
int GetOrdersTotal(int Magic)//获取魔术号 订单的总数 vvv
  {
#ifdef __MQL5__
   int i=0;
   int cntMyPos=PositionsTotal();
   for(int ti=cntMyPos-1; ti>=0; ti--)
     {
      if(PositionGetSymbol(ti)!=_Symbol)
         continue;
      if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
         continue;

      i++;
     }
   return(i);
#else
   int c=0;
   int total  = OrdersTotal();

   for(int cnt = 0 ; cnt < total ; cnt++)
     {
      int a=OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == Magic && OrderSymbol()==Symbol())
        {
         c++;
        }
     }
   return(c);
#endif
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double CheckTakeProfit(int Magic=0)//计算订单或者 魔术号订单的 利润  vvv
  {
   double curProfit=0;
   double profit=0;

#ifdef __MQL5__
   int cntMyPos=PositionsTotal();
   for(int ti=cntMyPos-1; ti>=0; ti--)
     {
      if(PositionGetSymbol(ti)!=_Symbol)
         continue;
      if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
         continue;

      profit+=PositionGetDouble(POSITION_PROFIT);
      profit+=PositionGetDouble(POSITION_SWAP);
     }
#else
   int cntMyPos=OrdersTotal();
   if(cntMyPos>0)
     {
      for(int ti=cntMyPos-1; ti>=0; ti--)
        {
         if(OrderSelect(ti,SELECT_BY_POS,MODE_TRADES)==false)
            continue;
         if(OrderType()==OP_BUY || OrderType()==OP_SELL) {}
         else
           {
            continue;
           }
         if(OrderSymbol()!=_Symbol)
            continue;
         if(Magic>0 && OrderMagicNumber()!=Magic)
            continue;

         profit+=OrderCommission();
         profit+=OrderProfit();
         profit+=OrderSwap();
        }
     }
#endif
   return profit;
  }
//+------------------------------------------------------------------+

///////////////////
enum TypeOfPos
  {
   MY_BUY,
   MY_SELL,
   MY_BUYSTOP,
   MY_BUYLIMIT,
   MY_SELLSTOP,
   MY_SELLLIMIT,
  };
// vvv 下单函数 MQL4 5 通用 mytype= MY_  volume 手数 price=0是当前价 price可以省略 之后的都可以不用填 止盈止损是相对位置 计算的是 当前货币的最小基本点Point position MQL5上用的
bool OrderSendPlus(TypeOfPos mytype,double volume,double price=0, double sl=0, double tp=0,int Magic=0, ulong position=0, string comment="", string sym="")
  {
   if(!StringLen(sym))
     {
      sym=_Symbol;
     }
   int curDigits=(int) SymbolInfoInteger(sym, SYMBOL_DIGITS);
#ifdef __MQL4__

   if(price==0)
     {
      price=OrderOpenPrice();
     }
#else
   MqlTick last_tick;
   double ask=0,bid=0;
   if(price!=0)
     {
      ask=price;
      bid=price;
     }
   if(price==0)
     {
      if(SymbolInfoTick(_Symbol,last_tick))
        {
         price=last_tick.last;
         ask=last_tick.ask;
         bid=last_tick.bid;
        }
     }
   if(sl>0)
     {
      if(mytype==MY_BUY || mytype==MY_BUYLIMIT || mytype==MY_BUYSTOP)
        {
         sl=NormalizeDouble(ask-sl*Point(),curDigits);
        }
      if(mytype==MY_SELL || mytype==MY_SELLLIMIT || mytype==MY_SELLSTOP)
        {
         sl=NormalizeDouble(bid+sl*Point(),curDigits);
        }

     }
   if(tp>0)
     {
      if(mytype==MY_BUY || mytype==MY_BUYLIMIT || mytype==MY_BUYSTOP)
        {
         tp=NormalizeDouble(ask+tp*Point(),curDigits);
        }
      if(mytype==MY_SELL || mytype==MY_SELLLIMIT || mytype==MY_SELLSTOP)
        {
         tp=NormalizeDouble(bid-tp*Point(),curDigits);
        }
     }
#endif
////////////////////////////////
#ifdef __MQL5__
   ENUM_TRADE_REQUEST_ACTIONS action=TRADE_ACTION_DEAL;
   ENUM_ORDER_TYPE type=ORDER_TYPE_BUY;
   switch(mytype)
     {
      case MY_BUY:
         action=TRADE_ACTION_DEAL;
         type=ORDER_TYPE_BUY;
         break;
      case MY_BUYSTOP:
         action=TRADE_ACTION_PENDING;
         type=ORDER_TYPE_BUY_STOP;
         break;
      case MY_BUYLIMIT:
         action=TRADE_ACTION_PENDING;
         type=ORDER_TYPE_BUY_LIMIT;
         break;
      case MY_SELL:
         action=TRADE_ACTION_DEAL;
         type=ORDER_TYPE_SELL;
         break;
      case MY_SELLSTOP:
         action=TRADE_ACTION_PENDING;
         type=ORDER_TYPE_SELL_STOP;
         break;
      case MY_SELLLIMIT:
         action=TRADE_ACTION_PENDING;
         type=ORDER_TYPE_SELL_LIMIT;
         break;
     }

   MqlTradeRequest mrequest;
   MqlTradeResult mresult;
   ZeroMemory(mrequest);

   mrequest.action = action;
   mrequest.sl = sl;
   mrequest.tp = tp;
   mrequest.symbol = sym;
   if(position>0)
     {
      mrequest.position = position;
     }
   if(StringLen(comment))
     {
      mrequest.comment=comment;
     }
   if(action!=TRADE_ACTION_SLTP)
     {
      if(price>0)
        {
         mrequest.price = price;
        }
      if(volume>0)
        {
         mrequest.volume = volume;
        }
      mrequest.type = type;
      mrequest.magic = Magic;
      switch(useORDER_FILLING_RETURN)
        {
         case FOK:
            mrequest.type_filling = ORDER_FILLING_FOK;
            break;
         case RETURN:
            mrequest.type_filling = ORDER_FILLING_RETURN;
            break;
         case IOC:
            mrequest.type_filling = ORDER_FILLING_IOC;
            break;
        }
      mrequest.deviation=100;
     }
   if(OrderSend(mrequest,mresult))
     {
      if(mresult.retcode==10009 || mresult.retcode==10008)
        {
         return true;

        }
      else
        {
         Print("GetLastError=   ",GetLastError());
        }
     }
#else
   int type=OP_BUY;
   switch(mytype)
     {
      case MY_BUY:
         type=OP_BUY;
         break;
      case MY_BUYSTOP:
         type=OP_BUYSTOP;
         break;
      case MY_BUYLIMIT:
         type=OP_BUYLIMIT;
         break;
      case MY_SELL:
         type=OP_SELL;
         break;
      case MY_SELLSTOP:
         type=OP_SELLSTOP;
         break;
      case MY_SELLLIMIT:
         type=OP_SELLLIMIT;
         break;
     }

   int ticket=OrderSend(sym, type, volume, price, 5, 0, 0, comment, Magic, 0);
   if(ticket<0)
     {
      Error();
     }
   else
     {
      double OpenPrice=Bid;

      if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
        {
         OpenPrice=OrderOpenPrice();
        }
      if(sl>0)
        {
         if(mytype==MY_BUY || mytype==MY_BUYLIMIT || mytype==MY_BUYSTOP)
           {
            sl=NormalizeDouble(OpenPrice-sl*Point(),curDigits);
           }
         if(mytype==MY_SELL || mytype==MY_SELLLIMIT || mytype==MY_SELLSTOP)
           {
            sl=NormalizeDouble(OpenPrice+sl*Point(),curDigits);
           }

        }
      if(tp>0)
        {
         if(mytype==MY_BUY || mytype==MY_BUYLIMIT || mytype==MY_BUYSTOP)
           {
            tp=NormalizeDouble(OpenPrice+tp*Point(),curDigits);
           }
         if(mytype==MY_SELL || mytype==MY_SELLLIMIT || mytype==MY_SELLSTOP)
           {
            tp=NormalizeDouble(OpenPrice-tp*Point(),curDigits);
           }
        }
      if(sl>0 || tp>0)
        {
         if(!OrderModify(ticket,OrderOpenPrice(),sl,tp,0))
            Error();
        }
      //////
      return true;
     }

#endif
   return false;
  }
////////////////////////////////
bool IsNewBar()//当前周期 新的K线是否已经开始 true是开始了 只在K线开始时返回一次  vvv
  {
   static datetime Old_Time;
   datetime New_Time[1]= {D'1970.01.01 00:00:00'};
   if(Old_Time==D'1970.01.01 00:00:00' && New_Time[0]==D'1970.01.01 00:00:00')//加载时运行一次 解决第一次返回 true的问题
     {
      CopyTime(_Symbol,_Period,0,1,New_Time);
      Old_Time=New_Time[0];
      return false;
     }
   if(CopyTime(_Symbol,_Period,0,1,New_Time)>0)
     {
      if(Old_Time!=New_Time[0])
        {
         Old_Time=New_Time[0];
         return true;
        }
     }
   return false;
  }
///////////////////////////////
void CloseAllPos(int Magic=0)//一键平仓 如果是锁仓订单时 有对冲平仓功能 会节约手续费 MQL4 MQL5都可以引用  vvv
  {
   int magic=Magic;
   CloseByPos(magic);
#ifdef __MQL5__
   int cntMyPos=PositionsTotal();
   for(int ti=cntMyPos-1; ti>=0; ti--)
     {
      if(PositionGetSymbol(ti)!=_Symbol)
         continue;
      if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
         continue;

      Trade.PositionClose(PositionGetInteger(POSITION_TICKET));
     }
   /*
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
   {
    ulong orderTicket=OrderGetTicket(ti);
    if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
       continue;
    if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
       continue;

    Trade.OrderDelete(orderTicket);
   }*/
#else
   int cntMyPos=OrdersTotal();
   if(cntMyPos>0)
     {
      for(int ti=cntMyPos-1; ti>=0; ti--)
        {
         if(OrderSelect(ti,SELECT_BY_POS,MODE_TRADES)==false)
            continue;
         if(OrderSymbol()!=_Symbol)
            continue;
         if(Magic>0 && OrderMagicNumber()!=Magic)
            continue;

         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(), OrderLots(),OrderClosePrice(),10))
              {
               Error();
              }
           }
         if(OrderType()==OP_SELL)
           {
            if(!OrderClose(OrderTicket(), OrderLots(),OrderClosePrice(),10))
              {
               Error();
              }
           }
        }
      PlaySound("ok.wav");
     }
#endif
  }
///////////////////////////////// https://www.mql5.com/zh/articles/5596
void CloseAllPos_Order(int Magic=0)//一键平仓包含挂单 如果是锁仓订单时 有对冲平仓功能 会节约手续费 MQL4 MQL5都可以引用  vvv
  {
   int magic=Magic;
   CloseByPos(magic);
#ifdef __MQL5__
   int cntMyPos=PositionsTotal();
   for(int ti=cntMyPos-1; ti>=0; ti--)
     {
      if(PositionGetSymbol(ti)!=_Symbol)
         continue;
      if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
         continue;

      Trade.PositionClose(PositionGetInteger(POSITION_TICKET));
     }

   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      Trade.OrderDelete(orderTicket);
     }
#else
   int cntMyPos=OrdersTotal();
   if(cntMyPos>0)
     {
      for(int ti=cntMyPos-1; ti>=0; ti--)
        {
         if(OrderSelect(ti,SELECT_BY_POS,MODE_TRADES)==false)
            continue;
         if(OrderSymbol()!=_Symbol)
            continue;
         if(Magic>0 && OrderMagicNumber()!=Magic)
            continue;

         if(OrderType()==0 || OrderType()==1)
           {
            if(!OrderClose(OrderTicket(), OrderLots(),OrderClosePrice(),10,CLR_NONE))
              {
               Error();
              }
           }
         else
           {
            if(!OrderDelete(OrderTicket()))
              {
               Error();
              }
           }

        }
      PlaySound("ok.wav");
     }
#endif
  }

//+------------------------------------------------------------------+
void CloseAllPendingOrder(int Magic=0)//一键平挂单  MQL4 MQL5都可以引用  vvv
  {
#ifdef __MQL5__
   int cntMyPosO=OrdersTotal();
   for(int ti=cntMyPosO-1; ti>=0; ti--)
     {
      ulong orderTicket=OrderGetTicket(ti);
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol)
         continue;
      if(Magic>0 && OrderGetInteger(ORDER_MAGIC)!=Magic)
         continue;

      Trade.OrderDelete(orderTicket);
     }
#else
   int cntMyPos=OrdersTotal();
   if(cntMyPos>0)
     {
      for(int ti=cntMyPos-1; ti>=0; ti--)
        {
         if(OrderSelect(ti,SELECT_BY_POS,MODE_TRADES)==false)
            continue;
         if(OrderSymbol()!=_Symbol)
            continue;
         if(Magic>0 && OrderMagicNumber()!=Magic)
            continue;
         if(OrderType()==0 || OrderType()==1)
            continue;

         if(!OrderDelete(OrderTicket()))
           {
            Error();
           }
        }
      PlaySound("ok.wav");
     }
#endif
  }

//+------------------------------------------------------------------+
void CloseByPos(int Magic=0)//一键平 对冲单 只留下 单一方向的订单 会节约手续费 vvv
  {
   bool repeatOpen=false;
#ifdef __MQL5__
   int cntMyPos=PositionsTotal();
   for(int ti=cntMyPos-1; ti>=0; ti--)
     {
      if(PositionGetSymbol(ti)!=_Symbol)
         continue;
      if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
         continue;

      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        {
         long closefirst=PositionGetInteger(POSITION_TICKET);
         double closeLots=PositionGetDouble(POSITION_VOLUME);

         for(int ti2=cntMyPos-1; ti2>=0; ti2--)
           {
            if(PositionGetSymbol(ti2)!=_Symbol)
               continue;
            if(Magic>0 && PositionGetInteger(POSITION_MAGIC)!=Magic)
               continue;
            if(PositionGetInteger(POSITION_TYPE)!=POSITION_TYPE_SELL)
               continue;
            if(PositionGetDouble(POSITION_VOLUME)!=closeLots)
               continue;

            MqlTradeRequest request;
            MqlTradeResult  result;
            ZeroMemory(request);
            ZeroMemory(result);
            request.action=TRADE_ACTION_CLOSE_BY;
            request.position=closefirst;
            request.position_by=PositionGetInteger(POSITION_TICKET);
            if(Magic>0)
               request.magic=Magic;
            if(OrderSend(request,result))
              {
               repeatOpen=true;
               break;
              }
           }
         if(repeatOpen)
           {
            break;
           }
        }
     }
#else
   int cntMyPos=OrdersTotal();
   if(cntMyPos>0)
     {
      for(int ti=cntMyPos-1; ti>=0; ti--)
        {
         if(OrderSelect(ti,SELECT_BY_POS,MODE_TRADES)==false)
            continue;
         if(OrderSymbol()!=_Symbol)
            continue;
         if(Magic>0 && OrderMagicNumber()!=Magic)
            continue;

         if(OrderType()==OP_BUY)
           {
            int closefirst=OrderTicket();
            double closeLots=OrderLots();

            for(int ti2=cntMyPos-1; ti2>=0; ti2--)
              {
               if(OrderSelect(ti2,SELECT_BY_POS,MODE_TRADES)==false)
                  continue;
               if(OrderSymbol()!=_Symbol)
                  continue;
               if(Magic>0 && OrderMagicNumber()!=Magic)
                  continue;
               if(OrderType()!=OP_SELL)
                  continue;
               if(OrderLots()<closeLots)
                  continue;

               if(OrderCloseBy(closefirst, OrderTicket()))
                 {
                  repeatOpen=true;
                  break;
                 }
              }
            if(repeatOpen)
              {
               break;
              }
           }

        }
      PlaySound("ok.wav");
     }
#endif
// if we closed a position by an opposite one,
// launch the closeByPos function again
   if(repeatOpen)
     {
      CloseByPos();
     }
  }
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////
string Error()//获取最后一次错误信息 输出中文错误信息   vvv
  {
   int myErrorNum = GetLastError();
   if(myErrorNum <= 0)
     {
      return("");
     }
   string myLastErrorStr;
   switch(myErrorNum)
     {
      case 0 :
         myLastErrorStr = "交易报错:0 没有错误返回";
         break;
      case 1 :
         myLastErrorStr = "交易报错:1 没有返回错误，可能是反复同价修改";
         break;
      case 2 :
         myLastErrorStr = "交易报错:2 一般错误";
         break;
      case 3 :
         myLastErrorStr = "交易报错:3 交易参数出错";
         break;
      case 4 :
         myLastErrorStr = "交易报错:4 交易服务器繁忙";
         break;
      case 5 :
         myLastErrorStr = "交易报错:5 客户终端软件版本太旧";
         break;
      case 6 :
         myLastErrorStr = "交易报错:6 没有连接交易服务器";
         break;
      case 7 :
         myLastErrorStr = "交易报错:7 操作权限不够";
         break;
      case 8 :
         myLastErrorStr = "交易报错:8 交易请求过于频繁";
         break;
      case 9 :
         myLastErrorStr = "交易报错:9 交易操作故障";
         break;
      case 64 :
         myLastErrorStr = "交易报错:64 账户被禁用";
         break;
      case 65 :
         myLastErrorStr = "交易报错:65 无效账户";
         break;
      case 128 :
         myLastErrorStr = "交易报错:128 交易超时";
         break;
      case 129 :
         myLastErrorStr = "交易报错:129 无效报价";
         break;
      case 130 :
         myLastErrorStr = "交易报错:130 止盈止损错误,距离当前价格太近.";
         break;
      case 131 :
         myLastErrorStr = "交易报错:131 交易量错误";
         break;
      case 132 :
         myLastErrorStr = "交易报错:132 休市";
         break;
      case 133 :
         myLastErrorStr = "交易报错:133 禁止交易,可能是临时休市";
         break;
      case 134 :
         myLastErrorStr = "交易报错:134 资金不足";
         break;
      case 135 :
         myLastErrorStr = "交易报错:135 报价发生改变";
         break;
      case 136 :
         myLastErrorStr = "交易报错:136 建仓价过期 或 有数据发布 保证金不足 exness外汇平台";
         break;
      case 137 :
         myLastErrorStr = "交易报错:137 经纪商很忙";
         break;
      case 138 :
         myLastErrorStr = "交易报错:138 报价使用错误，检查 Ask、Bid";
         break;
      case 139 :
         myLastErrorStr = "交易报错:139 定单被锁定";
         break;
      case 140 :
         myLastErrorStr = "交易报错:140 只允许做买入类型操作";
         break;
      case 141 :
         myLastErrorStr = "交易报错:141 请求过多";
         break;
      case 145 :
         myLastErrorStr = "交易报错:145 过于接近报价，禁止修改";
         break;
      case 146 :
         myLastErrorStr = "交易报错:146 交易繁忙";
         break;
      case 147 :
         myLastErrorStr = "交易报错:147 交易期限被经纪商取消";
         break;
      case 148 :
         myLastErrorStr = "交易报错:148 持仓单数量超过经纪商的规定";
         break;
      case 149 :
         myLastErrorStr = "交易报错:149 禁止对冲";
         break;
      case 150 :
         myLastErrorStr = "交易报错:150 FIFO 禁则";
         break;
      case 4000:
         myLastErrorStr = "运行报错:4000 没有错误返回";
         break;
      case 4001:
         myLastErrorStr = "运行报错:4001 函数指针错误";
         break;
      case 4002:
         myLastErrorStr = "运行报错:4002 数组越界";
         break;
      case 4003:
         myLastErrorStr = "运行报错:4003 调用栈导致内存不足";
         break;
      case 4004:
         myLastErrorStr = "运行报错:4004 递归栈溢出";
         break;
      case 4005:
         myLastErrorStr = "运行报错:4005 堆栈参数导致内存不足";
         break;
      case 4006:
         myLastErrorStr = "运行报错:4006 字符串参数导致内存不足";
         break;
      case 4007:
         myLastErrorStr = "运行报错:4007 临时字符串导致内存不足";
         break;
      case 4008:
         myLastErrorStr = "运行报错:4008 字符串变量缺少初始化赋值";
         break;
      case 4009:
         myLastErrorStr = "运行报错:4009 字符串数组缺少初始化赋值";
         break;
      case 4010:
         myLastErrorStr = "运行报错:4010 字符串数组空间不够";
         break;
      case 4011:
         myLastErrorStr = "运行报错:4011 字符串太长";
         break;
      case 4012:
         myLastErrorStr = "运行报错:4012 因除数为零导致的错误";
         break;
      case 4013:
         myLastErrorStr = "运行报错:4013 除数为零";
         break;
      case 4014:
         myLastErrorStr = "运行报错:4014 错误的命令";
         break;
      case 4015:
         myLastErrorStr = "运行报错:4015 错误的跳转";
         break;
      case 4016:
         myLastErrorStr = "运行报错:4016 数组没有初始化";
         break;
      case 4017:
         myLastErrorStr = "运行报错:4017 禁止调用 DLL ";
         break;
      case 4018:
         myLastErrorStr = "运行报错:4018 库文件无法调用";
         break;
      case 4019:
         myLastErrorStr = "运行报错:4019 函数无法调用";
         break;
      case 4020:
         myLastErrorStr = "运行报错:4020 禁止调用智 EA 函数";
         break;
      case 4021:
         myLastErrorStr = "运行报错:4021 函数中临时字符串返回导致内存不够";
         break;
      case 4022:
         myLastErrorStr = "运行报错:4022 系统繁忙";
         break;
      case 4023:
         myLastErrorStr = "运行报错:4023 DLL 函数调用错误";
         break;
      case 4024:
         myLastErrorStr = "运行报错:4024 内部错误";
         break;
      case 4025:
         myLastErrorStr = "运行报错:4025 内存不够";
         break;
      case 4026:
         myLastErrorStr = "运行报错:4026 指针错误";
         break;
      case 4027:
         myLastErrorStr = "运行报错:4027 过多的格式定义";
         break;
      case 4028:
         myLastErrorStr = "运行报错:4028 参数计数器越界";
         break;
      case 4029:
         myLastErrorStr = "运行报错:4029 数组错误";
         break;
      case 4030:
         myLastErrorStr = "运行报错:4030 图表没有响应";
         break;
      case 4050:
         myLastErrorStr = "运行报错:4050 参数无效";
         break;
      case 4051:
         myLastErrorStr = "运行报错:4051 错误订单序列号,由于订单总数已变化";
         break;
      case 4052:
         myLastErrorStr = "运行报错:4052 字符串函数内部错误";
         break;
      case 4053:
         myLastErrorStr = "运行报错:4053 数组错误";
         break;
      case 4054:
         myLastErrorStr = "运行报错:4054 数组使用不正确";
         break;
      case 4055:
         myLastErrorStr = "运行报错:4055 自定义指标错误";
         break;
      case 4056:
         myLastErrorStr = "运行报错:4056 数组不兼容";
         break;
      case 4057:
         myLastErrorStr = "运行报错:4057 全局变量处理错误";
         break;
      case 4058:
         myLastErrorStr = "运行报错:4058 没有发现全局变量";
         break;
      case 4059:
         myLastErrorStr = "运行报错:4059 复盘模式中函数被禁用";
         break;
      case 4060:
         myLastErrorStr = "运行报错:4060 函数未确认";
         break;
      case 4061:
         myLastErrorStr = "运行报错:4061 发送邮件错误";
         break;
      case 4062:
         myLastErrorStr = "运行报错:4062 String 参数错误";
         break;
      case 4063:
         myLastErrorStr = "运行报错:4063 Integer 参数错误";
         break;
      case 4064:
         myLastErrorStr = "运行报错:4064 Double 参数错误";
         break;
      case 4065:
         myLastErrorStr = "运行报错:4065 数组参数错误";
         break;
      case 4066:
         myLastErrorStr = "运行报错:4066 历史数据有错误";
         break;
      case 4067:
         myLastErrorStr = "运行报错:4067 交易内部错误";
         break;
      case 4068:
         myLastErrorStr = "运行报错:4068 没有发现资源文件";
         break;
      case 4069:
         myLastErrorStr = "运行报错:4069 不支持资源文件";
         break;
      case 4070:
         myLastErrorStr = "运行报错:4070 重复的资源文件";
         break;
      case 4071:
         myLastErrorStr = "运行报错:4071 自定义指标没有初始化";
         break;
      case 4099:
         myLastErrorStr = "运行报错:4099 文件末尾";
         break;
      case 4100:
         myLastErrorStr = "运行报错:4100 文件错误";
         break;
      case 4101:
         myLastErrorStr = "运行报错:4101 文件名称错误";
         break;
      case 4102:
         myLastErrorStr = "运行报错:4102 打开文件过多";
         break;
      case 4103:
         myLastErrorStr = "运行报错:4103 不能打开文件";
         break;
      case 4104:
         myLastErrorStr = "运行报错:4104 不兼容的文件";
         break;
      case 4105:
         myLastErrorStr = "运行报错:4105 没有选择定单";
         break;
      case 4106:
         myLastErrorStr = "运行报错:4106 未知的商品名称";
         break;
      case 4107:
         myLastErrorStr = "运行报错:4107 价格无效";
         break;
      case 4108:
         myLastErrorStr = "运行报错:4108 无效订单号";
         break;
      case 4109:
         myLastErrorStr = "运行报错:4109 禁止交易，请尝试修改 EA 属性";
         break;
      case 4110:
         myLastErrorStr = "运行报错:4110 禁止买入类型交易，请尝试修改 EA属性";
         break;
      case 4111:
         myLastErrorStr = "运行报错:4111 禁止卖出类型交易，请尝试修改 EA属性";
         break;
      case 4200:
         myLastErrorStr = "运行报错:4200 对象已经存在";
         break;
      case 4201:
         myLastErrorStr = "运行报错:4201 未知的对象属性";
         break;
      case 4202:
         myLastErrorStr = "运行报错:4202 对象不存在";
         break;
      case 4203:
         myLastErrorStr = "运行报错:4203 未知的对象类型";
         break;
      case 4204:
         myLastErrorStr = "运行报错:4204 对象没有命名";
         break;
      case 4205:
         myLastErrorStr = "运行报错:4205 对象坐标错误";
         break;
      case 4206:
         myLastErrorStr = "运行报错:4206 没有指定副图窗口";
         break;
      case 4207:
         myLastErrorStr = "运行报错:4207 图形对象错误";
         break;
      case 4210:
         myLastErrorStr = "运行报错:4210 未知的图表属性";
         break;
      case 4211:
         myLastErrorStr = "运行报错:4211 没有发现主图";
         break;
      case 4212:
         myLastErrorStr = "运行报错:4212 没有发现副图";
         break;
      case 4213:
         myLastErrorStr = "运行报错:4210 图表中没有发现指标";
         break;
      case 4220:
         myLastErrorStr = "运行报错:4220 商品选择错误";
         break;
      case 4250:
         myLastErrorStr = "运行报错:4250 消息传递错误";
         break;
      case 4251:
         myLastErrorStr = "运行报错:4251 消息参数错误";
         break;
      case 4252:
         myLastErrorStr = "运行报错:4252 消息被禁用";
         break;
      case 4253:
         myLastErrorStr = "运行报错:4253 消息发送过于频繁";
         break;
      case 5001:
         myLastErrorStr = "运行报错:5001 文件打开过多";
         break;
      case 5002:
         myLastErrorStr = "运行报错:5002 错误的文件名";
         break;
      case 5003:
         myLastErrorStr = "运行报错:5003 文件名过长";
         break;
      case 5004:
         myLastErrorStr = "运行报错:5004 无法打开文件";
         break;
      case 5005:
         myLastErrorStr = "运行报错:5005 文本文件缓冲区分配错误";
         break;
      case 5006:
         myLastErrorStr = "运行报错:5006 文无法删除文件";
         break;
      case 5007:
         myLastErrorStr = "运行报错:5007 文件句柄无效";
         break;
      case 5008:
         myLastErrorStr = "运行报错:5008 文件句柄错误";
         break;
      case 5009:
         myLastErrorStr = "运行报错:5009 文件必须设置为 FILE_WRITE";
         break;
      case 5010:
         myLastErrorStr = "运行报错:5010 文件必须设置为 FILE_READ";
         break;
      case 5011:
         myLastErrorStr = "运行报错:5011 文件必须设置为 FILE_BIN";
         break;
      case 5012:
         myLastErrorStr = "运行报错:5012 文件必须设置为 FILE_TXT";
         break;
      case 5013:
         myLastErrorStr = "运行报错:5013 文件必须设置为 FILE_TXT 或FILE_CSV";
         break;
      case 5014:
         myLastErrorStr = "运行报错:5014 文件必须设置为 FILE_CSV";
         break;
      case 5015:
         myLastErrorStr = "运行报错:5015 读文件错误";
         break;
      case 5016:
         myLastErrorStr = "运行报错:5016 写文件错误";
         break;
      case 5017:
         myLastErrorStr = "运行报错:5017 二进制文件必须指定字符串大小";
         break;
      case 5018:
         myLastErrorStr = "运行报错:5018 文件不兼容";
         break;
      case 5019:
         myLastErrorStr = "运行报错:5019 目录名非文件名";
         break;
      case 5020:
         myLastErrorStr = "运行报错:5020 文件不存在";
         break;
      case 5021:
         myLastErrorStr = "运行报错:5021 文件不能被重复写入";
         break;
      case 5022:
         myLastErrorStr = "运行报错:5022 错误的目录名";
         break;
      case 5023:
         myLastErrorStr = "运行报错:5023 目录名不存在";
         break;
      case 5024:
         myLastErrorStr = "运行报错:5024 指定文件而不是目录";
         break;
      case 5025:
         myLastErrorStr = "运行报错:5025 不能删除目录";
         break;
      case 5026:
         myLastErrorStr = "运行报错:5026 不能清空目录";
         break;
      case 5027:
         myLastErrorStr = "运行报错:5027 改变数组大小错误";
         break;
      case 5028:
         myLastErrorStr = "运行报错:5028 改变字符串大小错误";
         break;
      case 5029:
         myLastErrorStr = "运行报错:5029 结构体包含字符串或者动态数组";
         break;
      default://如果没有找到
         myLastErrorStr = IntegerToString(GetLastError()) + " 这个错误没有找到中文解释,请查阅帮助文档并补齐" ; //
         break;
     }
   Print(myLastErrorStr);
   return(myLastErrorStr);
  }
//////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
