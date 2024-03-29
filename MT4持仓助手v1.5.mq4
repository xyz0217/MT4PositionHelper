//|                                                  MT4持仓助手.mq4 |
//|                                                              xyz |
//|                                                   xyz0217@qq.com |
#property copyright "EA更新地址"
#property link      "http://blog.sina.com.cn/s/blog_98c568c20102xma8.html"
#property version   "1.5"
#property description "使用前先打印EA快捷键说明文件 文件在网盘中 网盘地址在上面或者看EA的代码 在头部位置"
#property description "Q群中有最新的版本请及时更新 221696452 "
#property strict
#define TP_PRICE_LINE "OG TP Price Line"//定义常量
#define SL_PRICE_LINE "OG SL Price Line"

//网盘地址 https://xyz0217.lanzoui.com/b02ccvfve  密码 1111 方便下载但更新可能不及时 下载方便 临时使用
//网盘地址 https://1drv.ms/f/s!Ag12rv4UaBTFdk21qQ-u-7ViriU   更新及时 相关文件全，但国内访问不稳定
//网盘地址 https://mega.nz/folder/uN9A1D5b#5_ou1D3moJMYyVZVDQnATQ 更新及时 相关文件全，但国内访问不稳定
//网盘地址 https://pan.baidu.com/s/1H5vIu8YTcivl3eZ3qtjKLg 密码 pc1o 更新可能不及时
//EA更新地址 http://blog.sina.com.cn/s/blog_98c568c20102xma8.html
//如发现问题请发邮件 xyz0217@qq.com 或qq群 221696452 我会及时修复

//此代码是在GPL-3.0许可下发布的。
//This code is released under the GPL-3.0 license.

/*
如果发现是 自定义函数  光标放在上面 按Alt+G 会跳转到 自定义函数 可以研究它的功能
代码搜索定位   OnTick() ttt    OnTimer()  Ttt 主数字键1 1111 小数字键1 1j  26个字母 比如搜索B键 搜索 Bj   Test 测试键
 定时器 t000 t111 t222 t333  图像按钮 通用mmm 常用菜单 mmm1 往后类推
 把5分钟 15分钟 收盘时 运行一次的代码 更新到了OnTick里 这样运行时间上会更加精准 设置了4个延迟 0 3 6 9 秒
 5min0 15min3 类推 需要收盘后 马上运行的 放0s里 但如果是需要判断刚生成K线的形态的 放 3 6 里 9里面放不那么急的 指标类

V1.5
增加了横线模式下 自动根据指标的一些提示移动横线位置 以达到随着行情的变化 自动处理一些订单 横线模式下H+主数字键 2022.1.3
更新版本为1.5 以后会尽量添加一些EA根据一些指标和参数 自动管理开平仓的功能。
V1.4
增加触及订单止盈止损线时 订单被平的提示音 2022.1.2
键盘右面的Shift sparam的值被官方改为了310 以前是54，造成键盘右面的Shift无法使用，已修复，MT4官方这是啥情况？ 2021.9.13
提前按B键再L+P触线只平buy单  提前按N键再L+P触线只平sell单 （S键被占用无法使用S键平空单）2021.9.13
增加一键反手开仓 Ctrl+Alt+F 触及横线 平仓后反手 2021.9.8
代码太多运行不流畅 优化了代码运行逻辑 没订单时停用了大部分功能 节约系统性能 2021.08.24
优化了横线模式 L+K 触及横线开仓的几种不同模式 2021.08.23
修改了一些错误 2021.08.19
增强划线代码部分功能 划线挂单 划线平仓 划线开仓 划线止盈止损 2018.05.31
增加全局变量 默认开启 限制EA最多可下的订单手数，防止盲目下单
由于笔记本小键盘开启不方便 先添加了两个笔记本上用的下单按键 buy单 p键右边第二个键 sell单L键右边第二个键 Ctrl+Alt+ } 开启 2018.01.11
修改了锁仓快捷键 换成了Shift+小键盘0 Tab+主键盘0 EA运行总开关临时关闭
增加了一些功能的快捷开关 Tab+主键盘1~6 划线和定时器的一些快捷开关 2017.11.10
增加了划线挂单模式 触及线开始挂单
增加了整数位设置止盈止损 V/A+T/F 2017.11.10
增加了可以灵活设置偏移量的按键 方向键的 上键和下键  程序会记录上键或者下键按下的次数 挂单前可以先按几次 程序会根据你按下的次数做更大的偏移 2017.10.31
增强了整数位挂单模块的能力 可以提前按几次T键进行更灵活更大的偏移 2017.10.29
增加了分批平仓的全局变量设置 为了节约电脑性能在一个MT4中相同货币对可以运行多个EA副本 但EA自动处理订单的功能只能在其中一个副本中使用 2017.10.18
增加不同的小数点位数，使用不同的止盈止损 而且参数不会再因为重新加载而丢失了 2017.10.16
划线平仓的代码里有布林带平仓 顺手整理了一下 解决了老代码提示警告的问题 2017.10.12
整体把划线平仓的代码移植到了EA中，由于代码比较复杂，而且写的比较早，有很多不兼容的地方，以后我会慢慢改的现在追求的是能用就好，哈哈 2017.10.07
添加一键平buy单 一键平sell单 2017.10.02
添加客户端全局变量 以应对重新加载EA时之前修改的参数丢失问题 以后会添加更多的参数为客户端全局变量 2017.09.30
第一次运行EA时要求修改适合自己的全局默认下单手数 修改后 参数不会再丢失了
修改接受BUG的邮箱，国外的邮箱由于国内总所周知的原因收发不稳定
添加默认下单量 四 五 六 倍的下单快捷键 Ctrl+小键盘9,8,7或6,5,4
V1.3
调整屏幕提示的方式和位置 2017.08.18
增加定时器5 6，计算不同的K线定时止盈止损 2017.05.25
增加整数位批量挂单抓回撤
增加智能计算最近的最低最高点以斐波那契百分比位挂单 2017.02.17
快捷键不够用 启用V和A代替B和S表示 buy单和sell单 以扩充快捷键。
增加快速设置止盈止损和快速设置挂单快捷键
正式启用定时器功能，处理简单的智能止盈止损
修改底层代码，加入部分自定义函数，为以后添加自动止盈止损自动加仓自动减仓功能做准备 2017.01.20
V1.2
增加批量移动当前止盈止损的快捷键 2017.01.12
优化了部分代码和设置。
增加了大量的快捷键，主要集中在止盈止损和挂单上，都集中在调试模块，适合在快速的行情中入场和出场，追单。2016.11.29
V1.1
修复了部分漏洞
增加键盘下单模式，使用了OnChartEvent()函数，它和脚本最大的区别就是它会记下快捷键按下的次数，自动重复的执行，如果想平几单，而不是全部订单
您可以快速的按几下平一单的快捷键，而不用担心有没有执行，它会一直执行完为止的，所以下单的时候一定要小心，不要按错次数了哦。
快捷键可以自定义 请先打开 测试键盘按钮状态的位掩码的字符串值 的开关，然后按下你想使用的快捷键，获取的sparam数值在EA的实时日志上。
组合键Ctrl+Alt+字母或数字也有自己的sparam的值，所以也可以使用组合键。
增加一键设置保本。
增加一键锁仓。
增加一键批量开反向单锁仓只有同向单时使用，使用说明在下面的自定义fanxiangsuodan函数里，必看！
增加批量挂单，主要用于追行情，突破行情时使用。
增加批量修改止盈止损点数或直接输入价位,第二次使用时之前设置的参数还在，记得先清零。
增加批量智能设置止损止盈，使用时，先设置参数，第二次使用时之前设置的参数还在，记得先清零。
增加快速平一单模式，可以按时间先后或者价格高低选择 2016.07.26
增加订单信息显示 2016.07.28
加入一些短线做单时使用的快捷键，在调试模块，正在完善中。。。 2016.09.08
快速修改EA参数时，可以使用“F7”快捷键。
V1.0
计时器平仓模式
设定多少秒运行一次平仓代码 行情波动大时，不那么迅速的平仓，能得到更多的利润，当然有得必有失，
如果回撤过于迅速,也可能会有到达分批平仓点位没平掉的情况。
Tick平仓模式
每个报价都会运行一次平仓代码，到达分批平仓点位时，基本都能平掉部分仓位。
minTP 分批平仓单子之间的最小间距，如果在行情波动不剧烈的时候出现一次在很近的位置平掉两单，这是因为在平仓的时候平台滑点造成的，可以稍微调大这个minTP值
刚接触mql4不久，有很多地方都不懂，只能七拼八凑哈，如果您对这个小EA有更好的修改和建议，请给我邮件发个副本哈xyz0217@qq.com 。
本EA参考了 自动止损、止盈、盈利后移动止损、分批出场.mq4  感谢原作者 龙德而隐者 。
*/
extern bool EAswitch=true;//EA运行总开关 EA不自动处理订单 Tab+0 临时关闭 按两次 分步平仓关闭 再按 追踪止损关闭 解锁时关闭分步平仓
extern string  reminder39="Shift+G 平挂单 一键锁仓 Shift+小键盘0 详细快捷键请看网盘中的快捷键说明文档 ";//小键盘9开多单6开空单 平最近下的一单 PageDown键 全平 Ctrl+Alt+P键
//extern string  reminder34="Tab+3~6 定时器 Tab+7 划线平仓 Tab+8 布林带平仓 1,2,7互斥 1和2一次有效";//EA部分功能快捷开关 Tab+主键盘0 临时关闭EA Tab+1 划线挂单 Tab+2 划线开仓
//extern string  reminder36="P+L buystop L+L sellstop 以划线为基准批量止盈止损B/S+O/K 一次有效";//Tab+1划线挂单开关 默认触及线开始挂单 直接挂 O+L buylimit K+L selllimit
extern string Q群中有最新的版本请及时更新、默认下单手数的调整在最下面="客户端全局函数设置 在最下面 修改里面的参数后不会再因为断电死机或者重新加载EA而丢失了";//
extern string reminder10="调试模块 有待完善 谨慎使用 快捷下单的按键是小键盘数字单键 小心不要误按了 ";//Q群221696452参数必须设置成适合自己的 代码漏洞或建议请发邮件xyz0217@qq.com
//extern string reminder32="挂单或止盈止损前可以先按几次 程序会根据你按下的次数做更大的偏移 ";//可以灵活设置偏移量的按键 方向键的 上键和下键 默认按一次偏移20
//extern string reminder20="整数位批量挂单抓回撤 O+t buylimit K+t selllimit 整数位设置止盈止损 V/A+T/F";//计算最近的最低最高点以斐波那契百分比位挂单 O+f buylimit K+f selllimit
//extern string reminder22="Buylimit O+ Buystop P+ Selllimit K+ Sellstop L+ 小键盘0,1,2,3";// 快捷距当前价多少点挂单 智能挂单G+t/p G+s/l 智能止盈止损b/s+j/i或b/s+u/h
//extern string reminder23="Buylimit O+ Buystop P+ Selllimit K+ Sellstop L+ 小键盘4,5,7,8";//计算最近多少K线的最高点和最低点挂单 有问题请先看下EA的日志 Tab+主键盘1~9-0快捷开关
//extern string reminder24="Shift+T/P Buylimit Buystop Shift+S/L Selllimit Sellstop  Shift+G 批量平挂单";//快捷计算最近K线的最低最高价智能计算批量挂单 参数设置在下面
extern double accountProfitmax=10000;//订单总利润达到多少全平仓L+X 建议把EA的快捷键设置为Alt+M 经常重新加载下EA ====
extern double accountProfitmin=10000;//订单总亏损达到多少全平仓 如自动启用最下面全局客户端设置
extern double accountProfitmax1=1;//订单总利润达到多少全平仓 薅羊毛 按一下右边的Shift后 L+X
extern double accountProfitmin1=200;//订单总亏损达到多少全平仓 薅羊毛 ShiftR+ L+X ====
extern int piliangtpdianshu=5;//以均/现价基础批量设置止盈的基数  b/s+p/l+主键盘0-9均价
extern int piliangsldianshu=5;//以均/现价基础批量设置止损的基数  b/s+o/k+主键盘0-9现价
extern int piliangtpjianju=1;//以均/现价基础批量设置止盈间距 智能止盈止损 统一价位止盈止损v/a+i/j
extern int piliangsljianju=3;//以均/现价基础批量设置止损间距 计算结果的基础上再减去多少点止盈止损v/a+u/h
extern int moveSTTP=50;//紧急批量上移或下移止盈止损距当前多少个点 b/s+止盈y/g 止损t/f
extern string reminder27="=== 定时器模块 定时自动移动止盈止损 追单专用 ===";//一般在一分钟或五分钟上用
extern bool timeGMTYesNo3=false;//定时器3开关 定时批量智能移动止损位 一分钟上用  =========
extern int timeGMTSeconds3=60;//定时器3 多少秒运行一次
extern bool buytrue03=true;//定时器3 ture只处理多单 false只处理空单
extern bool timeGMTYesNo4=false;//定时器4开关 定时批量智能移动止盈位 一分钟上用
extern int timeGMTSeconds4=60;//定时器4 多少秒运行一次
extern bool buytrue04=true;//定时器4 ture只处理多单 false只处理空单
extern bool timeGMTYesNo5=false;//定时器5开关 定时批量智能移动止损位 五分钟上用  =========
extern int timeGMTSeconds5=300;//定时器5 多少秒运行一次
extern bool buytrue05=true;//定时器5 ture只处理多单 false只处理空单
extern bool timeGMTYesNo6=false;//定时器6开关 定时批量智能移动止盈位 五分钟上用
extern int timeGMTSeconds6=300;//定时器6 多少秒运行一次
extern bool buytrue06=true;//定时器6 ture只处理多单 false只处理空单
extern string reminder28="快捷止盈止损距离当前价的点数 如参数小于平台停止水平位直接在水平位设置 ===";//如果是V/A+小键盘数字既按均价基础计算
extern double zhinengSLTP1=40;//需要移动的点数
extern int zhinengSLTP2=80;//快捷止损b或s+小键盘1,4,7 双倍默认点数快捷止损b或s+小键盘3,6,9
extern int zhinengSLTP3=120;//快捷止盈b或s+小键盘,2,5,8 如果是V/A+小键盘数字既按均价基础计算
extern int zhinengSLTPjianju=1;//止盈止损间距
extern int zhinengSLTPjuxianjia=20;//保护措施 距现价的最小止盈止损距离
extern int zhinengSLTPdingdangeshu=20;//只处理最近下的多少单
extern string reminder17="=== 快速批量智能设置统一止盈止损位 ===";//默认以最小的小数点为基准
extern int timeframe06=0;//图表时间周期 v/a+i/j 止损是计算结果再增加双倍点差的位置
extern int bars06=13;//取图表多少根k线计算结果
extern int beginbar06=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju06=0;//止损止盈间距
extern int juxianjia06=10;//保护措施 距现价的最小止赢止损距离
extern int dingdangeshu06=100;//只处理最近下的多少单
extern int pianyiliang06=50;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang06tp=15;//止赢在计算结果的基础上上移或下移几个点智能设置统一止盈位
extern int selltp06=20;//sell单止盈加点差的基础上再上移多少点 防止平台恶意扩大点差而无法止盈
extern string reminder16="=== 快速批量智能计算在结果的基础上减去点差再减去多少点止盈止损 ===";//默认以最小的小数点为基准
extern int timeframe05=0;//图表时间周期 v/a+u/h
extern int bars05=13;//取图表多少根k线计算结果
extern int beginbar05=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju05=3;//止损止盈间距
extern int juxianjia05=30;//保护措施 距现价的最小止赢距离
extern int dingdangeshu05=300;//只处理最近下的多少单
extern int pianyiliang05=80;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang05tp=20;//止赢在计算结果的基础上上移或下移几个点
extern string reminder12="=== 快速智能设置止盈止损参数短线追单专用 ===";//默认以最小的小数点为基准
extern int timeframe10=0;//图表时间周期  止损是计算结果再增加双倍点差的位置
extern int bars10=13;//取图表多少根k线计算结果 B/S+I/J
extern int bars1010=7;//取图表多少根k线计算结果 B/S+U/H 计算K线数不同
extern int beginbar10=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju10=3;//止损间距 Tab+Q 移动止盈止损到5000点上 变相取消
extern int jianju10tp=2;//止盈间距
extern int juxianjia10=20;//保护措施 距现价的最小止赢止损距离
extern int dingdangeshu10=100;//只处理最近下的多少单
extern int pianyiliang10=50;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang10nom=50;//止损在计算结果的基础上上移或下移几个点 N/D+小键盘数字 快捷智能止损
extern int dingdangeshu10nom=10;//快捷 只处理最近下的多少单 N/D+小键盘数字 快捷智能止损
extern int pianyiliang10tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int selltp10=20;//sell单止盈加点差的基础上再上移多少点 防止平台恶意扩大点差而无法止盈
extern string reminder15="=== 快捷距当前价或计算最近多少K线的最高点和最低点挂单 ===";//默认以最小的小数点为基准
extern int Guadanprice=10;//快捷距当前价多少点挂单 当挂单距离现价低于停止水平位时以停止水平位挂单
extern int Guadanprice1=40;//Buylimit o+ Buystop p+
extern int Guadanprice2=60;//Selllimit k+ Sellstop l+
extern int Guadanprice3=80;//  +小键盘0,1,2,3
extern int Guadanprice4=14;//快捷计算最近多少K线的最高点和最低点挂单
extern int Guadanprice5=5;//Buylimit o+ Buystop p+
extern int Guadanprice7=17;//Selllimit k+ Sellstop l+
extern int Guadanprice8=8;//   +小键盘4,5,7,8 分别对应设置的K线
extern int Guadanbuylimitpianyiliang=40;// Buylimit在计算结果的基础上 上移多少点
extern int Guadanselllimitpianyiliang=30;//Selllimit在计算结果的基础上 下移多少点
extern int Guadandianchabeishu=2;//挂Buystop和Sellstop时偏移多少倍点差以防假突破
extern double Guadanlots=0.3;//挂单手数
extern int Guadangeshu=5;//挂单个数
extern int Guadanjianju=3;//挂单间距
extern int Guadanjuxianjia=15;//保险措施 距现价挂单的最小点数
extern double Guadansl=0.0;//挂单止损点数 0不设止损
extern double Guadantp=0.0;//挂单止盈点数 0不设止盈
extern string  reminder43="=== 快捷计算最近K线的最低最高价智能计算批量挂单 ===";//默认以最小的小数点为基准
extern int Guadanprice41=11;//快捷计算最近多少K线的最高点和最低点挂单
extern int Guadanbuylimitpianyiliang1=20;//Buylimit在计算结果的基础上 上移多少点
extern int Guadanselllimitpianyiliang1=10;//Selllimit在计算结果的基础上 下移多少点
extern int Guadandianchabeishubuylimit1=2;//挂Buylimit 向上偏移多少倍点差以防挂不上
extern int Guadandianchabeishuselllimit1=2;//挂Selllimt 向下偏移多少倍点差以防挂不上
extern int Guadandianchabeishu1=2;//挂Buystop和Sellstop时偏移多少倍点差以防假突破
extern double Guadanlots1=0.2;//挂单手数 挂单前可以先按几次T键 程序会根据你按下的次数做更大的偏移
extern int Guadangeshu1=5;//挂单个数 Shift+T/P Buylimit Buystop Shift+S/L Selllimit Sellstop
extern int Guadanjianju1=3;//挂单间距 Shift+G 批量平挂单
extern int Guadanjuxianjia1=15;//保险措施 距现价挂单的最小点数
extern double Guadansl1=0.0;//挂单止损点数 0不设止损 按一次T键偏移的默认值是20个基点
extern double Guadantp1=0.0;//挂单止盈点数 0不设止盈
extern string reminder11="=== 智能挂单参数设置短线追单专用 ===";//默认以最小的小数点为基准
extern int zhinengguadanjuxianjia=20;//挂单距当前价最小距离 智能挂单G+t buylimit G+s selllimit
extern int zhinenga=13;//取最近的多少根K线计算 G+p buystop G+l sellstop
extern double zhinengguadanlots=0.2;//挂单手数
extern int zhinengguadangeshu=5;//挂单个数
extern int zhinengguadanjianju=3;//挂单间距
extern int zhinengguadanSL=0;//挂单止损，0即为不设置
extern int zhinengguadanTP=0;//挂单止盈，0即为不设置
extern int zhinengguadanslippage=5;//挂单滑点数
extern int zhinengb=0;//从第几根k线开始计算，默认当前K线
extern int zhinengtimeframe=0;//K线的时间周期，默认当前图表时间周期
extern int zhinengguadanzengjiabuy=30;//上移几个点开始挂buylimit单 可以是负数
extern int zhinengguadanzengjiasell=15;//下移几个点开始挂selllimit单 可以是负数
extern int zhinengguadanzengjiabuystop=30;//上移几个点开始挂buystop单 可以是负数
extern int zhinengguadanzengjiasellstop=15;//下移几个点开始挂sellstop单 可以是负数
extern string reminder19="=== 计算最近的最低最高点以斐波那契百分比位挂单 ===";//默认以最小的小数点为基准
extern int timeframe07=0;//图表时间周期 数量多的K线计算参数
extern int bars07=31;//取图表多少根k线计算结果 O+f buylimit K+f selllimit
extern int beginbar07=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int timeframe08=0;//图表时间周期  数量少的K线计算参数    ====
extern int bars08=11;//取图表多少根k线计算结果 斐波那契需要两个点划线 这个模块就是找到这两个点
extern int beginbar08=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern string reminder18="=== 斐波那契百分比挂单参数 ===";//默认以最小的小数点为基准
extern int fibhulue6=6;//忽略6设置 忽略一个百分比位置挂单 0123456对应-23.6%--76.4%  数字8为不忽略
extern int fibhulue5=5;// 0,1,2,3,4,5,6分别对应-23.6% 0% 23.6% 38.2% 50% 61.8% 76.4% 数字8为不忽略
extern int fibhulue4=8;//忽略4设置50% 填相对应的忽略数字即为不在这个百分比位挂单
extern int fibhulue3=8;//忽略3设置38.2% 例如填8为不忽略38.2% 填3为忽略这个位置
extern int fibhulue2=8;//忽略2设置23.6%   O+f buylimit K+f selllimit
extern int fibhulue1=8;//忽略1设置0%
extern int fibhulue0=8;//忽略0设置 -23.6%位置带止损挂单 对付一些假突破行情
extern int fibGuadansl1=100;//-23.6%位置挂单止损点数 0不设止损 尽量设置上止损 以防真突破
extern int fibbuypianyiliang=-15;//buylimit偏移量 在计算结果的基础上整体上移或下移多少点
extern int fibsellpianyiliang=5;//sellimit偏移量 在计算结果的基础上整体上移或下移多少点
extern double fibGuadanlots=0.2;//挂单手数
extern int fibGuadangeshu=1;//开始时挂单个数  每增加一个百分比位置挂单数加一
extern int fibGuadanjianju=3;//挂单间距
extern int fibGuadanjuxianjia=20;//保险措施 距现价挂单的最小点数
extern int fibGuadansl=0;//挂单止损点数 0不设止损
extern int fibGuadantp=0;//挂单止盈点数 0不设止盈
extern string reminder21="=== 整数位批量挂单抓回撤 ===";//默认以最小的小数点为基准
extern int tenweishu=5;//报价从左到右包含整数部分(小数点也算一位)截取的的位数 之后的忽略
extern double tenmax=30;//当点差过大时 buylimit单在计算结果上加上这个点数 不再参考点差
extern double tenGuadanlots=0.3;//挂单手数 如果selllimit挂的价位偏差很大 请调整上面截取的位数
extern int tenGuadangeshu=5;//挂单个数 O+t buylimit K+t selllimit
extern int tenGuadanjianju=3;//挂单间距
extern int tenbuypianyiliang=30;//buylimit偏移量 在计算结果的基础上整体上移多少点
extern int tensellpianyiliang=25;//selllimit偏移量 在计算结果的基础上整体下移多少点
extern int tenGuadanjuxianjia=20;//保险措施 距现价挂单的最小点数
extern double tenGuadansl=0;//挂单止损点数 0不设止损
extern double tenGuadantp=0;//挂单止盈点数 0不设止盈
extern string reminder31="=== 整数位智能计算后批量止盈止损 ===";//默认以最小的小数点为基准
extern int tensltpweishu=5;//报价从左到右包含整数部分(小数点也算一位)截取的的位数 之后的忽略
extern double tensltpmax=30;//当点差过大时 在计算结果上加上这个点数 不再参考点差
extern int tensltppianyiliang=25;//止损偏移量 V/A+T/F
extern int tentppianyiliang=25;//止盈偏移量
extern int tensltpjianju=3;//间距
extern int tensltpjuxianjia=15;//保险措施 距现价挂单的最小点数
extern int tensltpdingdangeshu=10;//处理的订单数
/*extern string reminder05="=== 批量智能设置止盈止损参数设置 ===";//默认以最小的小数点为基准
extern int a99=13;//取最近的多少根K线计算止损最低最高值
extern int b99=0;//从第几根k线开始计算，默认当前K线
extern int timeframe99=0;//K线的时间周期，默认当前图表时间周期
extern int c99=5;//止损间距
extern int d99=10;//在计算结果的基础上增加几个点，可以是负整数
extern double SL99=0.0;//或直接输入止损价格,价格优先
extern double TP99=0.0;*///或直接输入止盈价格，下次用时记得清零
extern string reminder13="=== 定时器3参数 定时批量智能移动止损位 ===";//默认以最小的小数点为基准
extern int timeframe03=0;//图表时间周期
extern int bars03=11;//取图表多少根k线计算结果
extern int beginbar03=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju03=3;//止损间距
extern int juxianjia03=30;//保护措施 距现价的最小止损距离
extern int pianyiliang03=50;//止损在计算结果的基础上上移或下移几个点
extern int dingdangeshu03=10;//只处理最近下的多少单
extern string reminder14="=== 定时器4参数 定时批量智能移动止盈位 ===";//默认以最小的小数点为基准
extern int timeframe04=0;//图表时间周期
extern int bars04=11;//取图表多少根k线计算结果
extern int beginbar04=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju04=3;//止赢间距
extern int juxianjia04=15;//保护措施 距现价的最小止赢距离
extern int pianyiliang04tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int dingdangeshu04=10;//只处理最近下的多少单
extern string reminder25="=== 定时器5参数 定时批量智能移动止损位 ===";//默认以最小的小数点为基准
extern int dingshitimeframe05=0;//图表时间周期
extern int dingshibars05=7;//取图表多少根k线计算结果
extern int dingshibeginbar05=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int dingshijianju05=3;//止损间距
extern int dingshijuxianjia05=30;//保护措施 距现价的最小止损距离
extern int dingshipianyiliang05=50;//止损在计算结果的基础上上移或下移几个点
extern int dingshidingdangeshu05=10;//只处理最近下的多少单
extern string reminder26="=== 定时器6参数 定时批量智能移动止盈位 ===";//默认以最小的小数点为基准
extern int dingshitimeframe06=0;//图表时间周期
extern int dingshibars06=7;//取图表多少根k线计算结果
extern int dingshibeginbar06=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int dingshijianju06=3;//止赢间距
extern int dingshijuxianjia06=15;//保护措施 距现价的最小止赢距离
extern int dingshipianyiliang06tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int dingshidingdangeshu06=10;//只处理最近下的多少单
extern string reminder03=" ===  键盘下单参数设置  === ";//
extern bool keycode=true;//键盘下单默认开启
extern int buykey=73;//买单按键 默认小键盘数字键“9”
extern int sellkey=77;//卖单按键 默认小键盘数字键“6”
extern int buykeydouble=72;//买单按键 双倍默认手数 小键盘数字键“8”
extern int sellkeydouble=76;//卖单按键 双倍默认手数 小键盘数字键“5”
extern int buykey3=71;//买单按键 三倍默认手数 小键盘数字键“7”
extern int sellkey3=75;//卖单按键 三倍默认手数小键盘数字键“4”
extern int zuidaclose=338;//平价格最高的一单，默认“Insert”键
extern int zuixiaoclose=339;//平价格最低的一单，默认“Delete”键
extern int zuizaoclose=335;//平最早下的一单，默认“End”键
extern int zuijinclose=337;//平最近下的一单，默认“PageDown”键
extern int yijianPingcang=8217;//一键平仓，默认Ctrl+Alt+“P”键
//extern int yijianPingbuydan=8240;//一键平buy单，默认Ctrl+Alt+“B”键
//extern int yijianPingselldan=8223;//一键平sell单，默认Ctrl+Alt+“S”键
extern int baobenSL=8230;//批量设置止损位在保本线上,Ctrl+Alt+“L”键 默认处理多空单
extern int baobenTP=8212;//批量设置止盈位在保本线上,Ctrl+Alt+“T”键 如果提前按了B/S只处理一边
extern int piliangSLTP=1;//Tab+Esc 移动止盈止损到5000点上 变相取消 仅应急使用
//extern int zhinengSL=31;//批量智能设置止损 默认Tab+“S”键
//extern int zhinengTP=20;//批量智能设置止盈 默认Tab+“T”键
extern int suoCang=82;//一键锁仓，Shift+小键盘数字键“0” b/s+主键盘数字0 取消止盈止损
extern int fanxiangSuodan=82;//批量开反向单锁仓只有同向单时使用，Ctrl+小键盘数字键“0”
extern int timeframe09=0;//图表时间周期    带止损下单设置                       ====
extern int beginbar09=0;//0从当前K线开始 5就是包含当前K线往左5根K线忽略不计
extern int bars097=11;//现价买一单 然后取最近多少根k线计算最低价减去点差再减去偏移量的价位设置止损
extern int buypianyiliang=50;//buy单偏移量 止损在计算结果的基础上上移或下移几个点
extern int sellpianyiliang=50;//sell单偏移量 止损在计算结果的基础上上移或下移几个点  ====
extern int buypianyiliang9=30;//小偏移量 Ctrl+Alt+小键盘"9" buy单带止损 对应K线7 两倍点差偏移
extern int sellpianyiliang6=30;//小偏移量 Ctrl+Alt+小键盘"6" sell单带止损 快速带止损追单 如果反向直接止损出来
extern int bars096=4;//小偏移量 现价买一单然后取最近多少根k线计算最低价减去点差再减去偏移量的价位设置止损
extern double keylots=0.3;//键盘下单手数
extern int keyslippage=20;//键盘下单模式滑点数
extern string reminder01="=== 止盈止损移动止损参数设置 ===";//默认以最小的小数点为基准
extern bool autosttp=true;//止盈止损移动止损总开关 默认为计时器模式运行
extern bool timeGMTYesNo1=true;//自动止盈止损移动止损 定时器开关
extern int timeGMTSeconds1=180;//自动止盈止损移动止损多少秒运行一次
extern bool AutoStoploss=true;//止损开关
extern double stoploss=320;//止损点数
extern bool AutoTakeProfit=true;//止盈开关
extern double takeprofit=500;//止盈点数
//extern bool AutoTrailingStop=true;//盈利后移动止损开关
extern double TrailingStop=340;//移动止损点数
extern string reminder02="=== 等比例分步平仓参数设置 ===";//默认以最小的小数点为基准
extern int GraduallyNum=5;//在移动止损位和止盈位之间分几次平仓 止盈减移动止损后除以次数等于平仓的间隔
extern int SetTimer=5;//计时器秒数 计时器模式下分批平仓多少秒运行一次
extern int minTP=4;//调试使用 分批平仓单子之间的最小间距
extern int slippage=5;//调试使用 滑点数
//---- input parameters
extern string reminder30="有很多不兼容的地方，以后我会慢慢改的现在追求的是能用就好 哈哈=== ";//下面是划线平仓设置 整体把划线平仓的代码移植到了EA中，由于代码比较复杂 而且写的比较早
extern string  管理持仓单号="*";           // *为当前图标货币的全部持仓单 所有管理的持仓必须同方向 否则不工作。
//内容可以是一个或多个持仓单的ID，分割符随便，因为程序是判断每个持仓ID是不是这个变量的子串。所有管理的持仓必须同方向，否则不工作。
extern int     获利方式1制定2趋势线0无获利平仓=2;             // 获利方式：1-制定，2-趋势线，其它值-无获利平仓。
// 程序从图上搜索对象，可以是趋势线TrendLine、角度线TrendLine By Angel、等距离通道线Equidistant Channel。
extern int     止损方式1制定2趋势线3移动止损0无止损=2;             // 止损方式：1-制定，2-趋势线，3移动止损;其它值-无止损平仓。
extern int bandsA=20;//Bands指标参数1 时间周期 选择 1制定 时 为布林带平仓模式
extern int bandsB=0;//Bands指标参数2 平移 布林带会随着你选择的时间周期改变 小心EA触及布林带直接平仓了
extern int bandsC=2;//Bands指标参数3 偏差 布林带的默认参数不熟悉一定谨慎修改 请修改下面的参数 止盈平仓默认偏移了两倍点差Tab+8启动
extern int bandsdianchabeishu=2;//点差偏移倍数 偏移
extern int bandsTPpianyi=10;//止盈线偏移点数 偏移
extern int bandsSLpianyi=20;//止损线偏移点数 偏移
extern string  移动止损止损方式参数="";
extern double   止损=270;
extern double   首次保护盈利止损=200;
extern double   保护盈利 = 10;
extern double   移动步长 = 100;
extern bool    是否显示示例线=true;          // 是否在图中显示获利止损价格线，方便观察是否设置正确。
extern color  获利价格示例线=C'108,108,0';     // 获利价格线颜色
extern color   止损价格示例线=C'90,0,0';           // 止损价格线颜色
extern string reminder33="===划线挂单模块 触及趋势线开始挂单===";//
extern double huaxianguadanlots=0.1;//挂单手数
extern int huaxianguadangeshu=3;//挂单个数
extern int huaxianguadanjianju=3;//挂单间距
extern double huaxianguadansl=220;//挂单止损
extern double huaxianguadantp=200;//挂单止盈
extern double hengxianguadansl=0.0;//横线挂单止损 横线模式时L+G 默认不设置止盈止损
extern double hengxianguadantp=0.0;//横线挂单止盈 横线模式时L+G
extern int jianju07=3;// 止损间距 划线止盈止损参数设置
extern int jianju07tp=1;// 止盈间距 划线止盈止损参数设置
extern int pianyiliang07=20;//止损偏移 正数是正向偏移 负数是反向偏移
extern int pianyiliang07tp=20;// 止盈偏移
extern int juxianjia07=30;//距现价最小距离 保护措施
extern int dingdangeshu07=20;//只处理最近的几笔订单
extern int huaxianguadanjuxianjia=5;//安全措施 挂单距现价

extern string reminder35="===划线开仓模块 触及趋势线或横线开始开仓===";//
extern int huaxiankaicanggeshu=3;//开仓次数 其他参数以EA基本开仓参数为准 横线模式L+K
extern int huaxiankaicangtime=1000;//开仓间隔 毫秒 1秒=1000毫秒 只参考时间 不管开仓价位 横线模式L+K
extern int huaxiankaicanggeshuT=3;//开仓次数 参考时间和价格 止损线止损X+L+K
extern int huaxiankaicangtimeT=2000;//开仓间隔 毫秒 1秒=1000毫秒  不带止损线ctrlR+L+K
extern int huaxiankaicanggeshuR=3;//开仓次数 参考横线的位置既参考价格  横线ShiftR模式
extern double timeseconds1P=2;//开仓时间间隔 秒 既参考时间又参考价格 横线ShiftR模式
extern double huaxiankaicanglotsT=0.1;//开仓手数  横线ShiftR模式 越线后间隔时间连续开仓直到价格返回
extern double fkeyHoldingfanshoupianyi=30;//L+P 启动前 按F 全平后距现价多少个点挂反向单 可按上下方向键增大偏移

extern double huaxianzidongjiacanglots=0.1;// 自动加仓 开仓手数 ====== 测试五分钟自动追单 L+H
extern int huaxianzidongjiacanggeshu=3;// 自动加仓 开仓次数
extern int huaxianzidongjiacanggeshutime=2;//自动加仓 移动横线次数
extern int linezidongjiacangyidong=30;//自动加仓 移动横线 多少个点
extern int linebuyzidongjiacangpianyi=20;//自动加仓 Buy Line偏移
extern int linesellzidongjiacangpianyi=20;//自动加仓 Sell Line偏移 ======
extern int timeseconds=2;//平仓时间间隔 横线模式 按一下右边的Shift L+P越线按时间间隔一单一单平仓 平仓比较慢
extern int linebar=5;//计算最近多少根K线的最高最低值划一根横线 横线模式
extern double linepianyi=20;//横线模式下W/S每次上移或下移多少基点 横线模式
extern double lineslpianyi=30;//横线模式 CtrlR+ L+P 定时器模式SL 距横线偏移多少设置SL
extern int linekaicangshiftRbars=7;//ShiftR横线带止损开仓时 取最近多少根K线计算最高最低点
extern double linekaicangshiftRpianyi=100;//ShiftR横线带止损开仓时 计算结果后再偏移多少 点差已经加进去了

extern string reminder37="===短线加仓 快速止盈止损 剥头皮模块 测试中===";//Tab+> 多单剥头皮 Tab+< 空单剥头皮 再按"<"">"取消最近的止损横线
extern int SL5mtimeGMTSeconds1=30;//设置止盈止损的间隔时间
extern int SL5mlineGraduallyNum=2;//分批平仓
extern double SL5mlinestoploss=120;//止损
extern double SL5mlinetakeprofit=160;//止盈
extern double SL5mlineTrailingStop=120;//移动止损
extern int SL1mlinetimeframe=11;//计算最近多少根K线的最高最低点加上下面的偏移作为一分钟止损横线位置
extern int SL5mlinetimeframe=4;//计算最近多少根K线的最高最低点加上下面的偏移作为五分钟止损横线位置
extern int SL15mlinetimeframe=3;//计算最近多少根K线的最高最低点加上下面的偏移作为十五分钟止损横线位置
extern int SLlinepingcangjishu=2;//触及止损横线平掉最近下的几个订单 不全平
extern double SLbuylinepianyi=30;//buy单止损偏移
extern double SLselllinepianyi=30;//sell单止损偏移
extern int SLlinepingcangtime=1000;//止损平仓时间间隔毫秒
extern int  SL5QTPpingcang=60;//所有订单计算均价后在偏移多少作为止盈横线的位置 Tab+P激活止盈横线

extern string reminder40="reminder40";//剥头皮模式下 小键盘 * 键批量下单 止盈止损很小 薅羊毛===
extern int SL1mQlinetimeframe=7;//计算一分钟多少根K线的最低最高价偏移后作为止损位
extern int SLQNum=3;//批量下单个数
extern double SLQlots=0.03;//* 键批量下单手数 按一下左边的“/”键双倍下单 需要单独设置 独立于全局下单仓位
extern int SLQbuylinepianyi=30;//buy单止损偏移
extern int SLQselllinepianyi=30;//sell单止损偏移
extern int SL5Qtp=50;// 小键盘 * 键 下单预设的止盈点数
int SLsellQpengcangline1TP=4000;//下单后生成的止盈横线距离现价的位置 触线一单一单平仓
extern int SLQlinepingcangSleep=1000;//触及止盈横线平仓间隔时间 不让马上全平 大行情时好触及止盈出局
extern int  SL5QTPpingcang1=40;// 所有订单计算均价后在偏移多少作为止盈横线的位置 定时器自动更新横线
extern int SL5QTPtime=600;// 计数器秒数 保本平 用*号下的单 有时间限制 到时间不论盈亏都自动平仓
extern int SL5QTPtime1=900;//计数器秒数 直接平   =====

extern string reminder38="===根据指标的数值 自动执行计划任务 其他临时参数===";//
extern int  imbfxTmax=92;//MBFX指标上线 I+主键盘1启动 使用的自定义指标
extern int  imbfxTmin=8;//MBFX指标下线 测试阶段
extern double  iBSTrendmax=0.1;//BSTrend指标 I+主键盘2启动 测试阶段
extern double  iBSTrendmin=-0.1;//BSTrend指标
extern double  iBreakoutmax=97;//Breakout指标 计数器模式平仓 I+主键盘3启动 ShiftR+ 15分钟图表
extern double  iBreakoutfanshoumax=97;//Breakout指标 全平后反手 提前按F后  I+主键盘3启动 测试阶段
extern double iBreakoutSLpingcangNowmax=110;//突破百分比 Breakout指标 突破箱体马上止损平仓
extern int  iBreakoutkaicangbuygeshu=3;//K+I+3 开仓个数 根据Breakout指标矩形横线的位置启动横线模式开仓
extern int  iBreakoutkaicangbuytime=1000;//K+I+3 开仓时间间隔 毫秒 根据Breakout指标矩形横线的位置启动横线模式开仓
extern double  iBreakoutkaicangbuySLpianyi=100;//K+I+3止损偏移量  根据Breakout指标矩形横线的位置启动横线模式开仓
extern double linebuypingcangctrlRpianyi=40;//横线模式L+P 提前按Ctrl触及横线后距当前价多少设置止损 测试
extern bool zhendangzhibiaokaiguan=true;//震荡突破 指标 图表显示 默认开启 需要把指标放到 软件里
extern bool mbfx_tubiao=true;// mbfx指标 图表显示 默认开启 需要把指标放到 软件里

extern string reminder44="===横线模式 按钮 下面 一些零散的参数===";//
extern int hengxianJJSkaicanggeshu=3;//渐进式开仓 默认开仓个数
extern double hengxianJJSkaicangpianyi=5;//渐进式开仓 默认移动横线的间距
extern int yinyang5mkaicang1Kyangbuyhengpianyi=20;//图表按钮 常用菜单 第一个下面的 5分钟收阳 横线模式追单 横线与收盘价的偏移量
extern int a12pingcangpianyi=60;//横线模式 第28个按钮 策略性平仓回撤多少点后再下相同的订单追 薅羊毛
extern int menu27buybars=11;//Buy单计算最近多少根K线寻找阻力位最高点 小阻力位先平仓K线实体越过再开相同的仓位追
extern int menu27sellbars=11;//Sell单计算最近多少根K线寻找阻力位最高点 小阻力位先平仓K线实体越过再开相同的仓位追
extern int menu27buypianyi=30;//Buy单阻力位最高点 再向上偏移点数 小阻力位先平仓K线实体越过再开相同的仓位追
extern int menu27sellpianyi=30;//Sell单阻力位最低点 再向下偏移点数 小阻力位先平仓K线实体越过再开相同的仓位追
extern int menu29buypianyi=50;// Buy偏移点数  反锁后再回撤几个点平原来的单
extern int menu29sellpianyi=50;// Sell偏移点数 反锁后再回撤几个点平原来的单
extern int menu224_0sleep=30;//等待时间 越线等待几十秒 还越线 平最近下的几单 横线模式 24按键副1
extern int menu224_0geshu=5;//平几单  越线等待几十秒 还越线 平最近下的几单 横线模式 24按键副1
extern int menu224_1sleep=10;//间隔时间 秒 越线缓慢开仓直到返回 横线模式24按键副2
extern int menu224_1geshu=10;//开仓个数  越线缓慢开仓直到返回 横线模式24按键副2
extern string reminder45="===短线追单 按钮 下面 一些零散的参数===";//
extern int ATRcanshu=14;// ATR参数 默认14 参考ATR指标设置止盈止损
extern bool AutoATRStoploss=true;//止损开关 参考ATR指标设置止盈止损
extern bool AutoATRTakeProfit=true;//止盈开关 参考ATR指标设置止盈止损
extern int ATRSLbeishu=2;//止损是几倍ATR 参考ATR指标设置止盈止损
extern int ATRTPbeishu=3;//止盈是几倍ATR 参考ATR指标设置止盈止损
extern int ATRSLpianyi=20;//止损偏移多少点正数是扩大 负数是减小 参考ATR指标设置止盈止损
extern int ATRTPpianyi=0;//止盈偏移多少点 正数是减小 负数是扩大 参考ATR指标设置止盈止损
extern string reminder08="短线追单模式 参数设置";//图表按钮 短线追单 第一二个按钮上的  参数设置
extern double dxzdSLpianyiliang=30;//短线追单 越过横线止损时 增加的偏移量，防止行情上下阴线过长，白白止损
extern int dxzdSLSleep=3000;//毫秒 打到止损位 暂停几秒 再平仓 看会不会马上拉回来
extern double dxzdBuyLineCpianyiliang=-10;//追Buy 当前K线触及次K线收盘价 追一单的偏移量  按小键盘 * 启动触绿线开仓
extern double dxzdBuyLineOpianyiliang=20;//追Buy 当前K线触及次K线开盘价 追一单的偏移量 由远及近的启动三根绿线
extern double dxzdBuyLineLpianyiliang=20;//追Buy 当前K线触及次K线最低价 追一单的偏移量
extern double dxzdSellLineCpianyiliang=0;//追Sell 当前K线触及次K线收盘价 追一单的偏移量
extern double dxzdSellLineOpianyiliang=-20;//追Sell 当前K线触及次K线开盘价 追一单的偏移量
extern double dxzdSellLineHpianyiliang=-20;//追Sell 当前K线触及次K线最高价 追一单的偏移量
extern string reminder42="===短线追单 按钮 下面  5分钟追单智能设止损线 ===";//
extern int zn5mSL1bar=4;//5分钟 1取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern int zn5mSL2bar=7;//5分钟 2取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern int zn5mSL3bar=11;//5分钟 3取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern int zn15mSL1bar=3;//15分钟 1取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern int zn15mSL2bar=7;//15分钟 2取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern int zn15mSL3bar=11;//15分钟 3取最近多少根K线计算最低 最高价 加入偏移量 设置止损线
extern double zn5mBuySLpianyi=-40;//5分钟 Buy单止损线的偏移量
extern double zn5mSellSLpianyi=40;//5分钟 Sell单止损线的偏移量
extern double zn15mBuySLpianyi=-50;//5分钟 Buy单止损线的偏移量
extern double zn15mSellSLpianyi=50;//5分钟 Sell单止损线的偏移量
extern int zn5mSleep=4000;//毫秒 首次触及止损线时 等待几秒钟 如果不回来 就平仓 5分钟
extern int zn15mSleep=5000;//毫秒 首次触及止损线时 等待几秒钟 如果不回来 就平仓 15分钟
extern string reminder07="============= 全局及其他未归类的参数设置 =============";//
extern bool defaultlotstrue=true;//是否启用全局下单手数 默认启用
extern bool Testsparam=false;//自定义快捷键 测试按键对应的sparam值结果在EA的日志里
extern bool testtradeSLSP=true;//平台是否支持带上止盈止损开单 默认支持 如无法开单请改为false
extern bool dingdanxianshi=true;//订单信息显示在图表 默认开启
extern color dingdanxianshicolor=clrYellow;//订单信息显示颜色
extern int dingdanxianshiX=10;//订单信息显示位置 X轴 横向位置 左上起始位
extern int dingdanxianshiY=90;//订单信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX1=900;//EA操作信息显示位置 X轴 横向位置 右上起始位
extern int dingdanxianshiY1=30;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX2=900;//EA操作信息显示位置 X轴 横向位置 右上 第二行
extern int dingdanxianshiY2=60;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX3=900;//EA操作信息显示位置 X轴 横向位置 右上 第三行
extern int dingdanxianshiY3=90;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX4=230;//EA操作信息显示位置 X轴 横向位置 左上 为定位点
extern int dingdanxianshiY4=30;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX5=230;//EA操作信息显示位置 X轴 横向位置 左上 为定位点
extern int dingdanxianshiY5=60;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX6=230;//EA操作信息显示位置 X轴 横向位置 左上 为定位点
extern int dingdanxianshiY6=90;// EA操作信息显示位置 Y轴 纵向位置
extern bool timeGMTYesNo2=true;//定时器2开关 日志文字提示
extern int timeGMTSeconds2=20;//定时器2 停留多少秒 增加了笔记本下单的两个按键buy/sell P/L键右边隔壁按键
extern bool timeGMTYesNo0=true;//定时器0开关 请勿关闭
extern int timeGMTSeconds0=60;//定时器0多少秒执行一次
extern int presspianyi=20;//方向键上键和下键按一次偏移的点数 挂单前可以先按几次 程序会根据你按下的次数做更大的偏移
extern int pianyiglo=20;//默认止盈止损全局偏移的点数
extern int expirationM=0;//挂单有效时间 分钟 0永久 有些平台必须手动取消挂单  ===========

extern int yinyang5mkaicanggeshu=3;//Y+K 开仓次数 当前5分钟图表最近两根K线收盘时颜色相同开仓追单
extern int yinyang5mkaicangSleep=1000;//Y+K 开仓时间间隔 毫秒 当前5分钟图表最近两根K线收盘时颜色相同开仓追单
extern double yinyang5mkaicangshiftRpianyi=20;//shiftR Y+K 横线偏移量 当前5分钟图表最近两根K线收盘时颜色相同启动横线模式平仓
extern int yinyang5mpingcangSleep=2000;//Y+P 平仓时间延迟 毫秒 当前5分钟图表最近两根K线收盘时颜色相同时平仓
extern int yinyang5mpingcangshiftRSleep=2000;//shiftR Y+P 平仓后反手时间延迟 毫秒 当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手
extern int yinyang5mpingcangtime1=360;//shiftR Y+P  平仓 和平仓后反手 监控时间只能持续多少秒 到时间还没有执行就关闭
extern int dingshikaicanggeshu=3;//M+K 开仓次数 五分钟收盘时直接开仓
extern int dingshikaicangSleep=1000;//M+K 开仓次数 五分钟收盘时直接开仓
extern int yinyang5mpingcangctrlRSleep=2000;//ctrlR Y+P 平仓时间延迟 毫秒 最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓

extern string reminder29="=== 客户端全局函数设置 只在需要更新全局函数时使用一次 更新成功后请重新加载EA ===";//全局函数下的设置不会因为EA重新加载 MT4重启 意外断电关机而重置设置参数
extern bool globalVariablesDeleteAll=false;//删除全部的客户端全局函数 初始化客户端全局函数设置
extern bool glolotsture=false;//修改全局默认下单手数开关 请改为true后修改下一行 保存后重新加载EA即可 ===
extern double defaultlots=0.01;//全局默认下单手数 会修改EA所有的手数设定 请先打开上面的开关
extern bool gloGraduallytrue=false;//修改等比例分步平仓开关 请改为true后修改下一行的参数 保存即可       ===
extern bool Gradually=true;//等比例分步平仓 默认开启 下一行可以修改不同的分批平仓模式
extern bool gloTickmodetrue=false;//修改分批平仓模式开关 请改为true后修改下面的参数 保存即可           ===
extern bool Tickmode=false;//分批平仓模式默认false计时器模式 Ture是Tick平仓模式 为节约电脑资源默认计时器模式

extern bool gloAutoTrailingStoptrue=false;//修改盈利后追踪止损开关 请改为true后修改下一行的参数 保存即可       ===
extern bool AutoTrailingStop=true;//盈利后追踪止损 默认开启

extern bool glo5Digitsture=false;//修改五位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo5TP=420;//五位小数点时止盈点数 由于到达移动止损位时EA就开始自动分批平仓的原因
extern int glo5SL=320;//五位小数点时止损点数 请确保止盈减移动止损后除以4得到的是整数
extern int glo5moveSL=300;//五位小数点时移动止损点数 利润超过移动止损点后止损移到保本 然后分批平仓 EA默认是分五次分批平仓
extern bool glo3Digitsture=false;//修改三位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo3TP=620;//三位小数点时止盈点数 如果是黄金相关的货币对 止盈止损放大10倍
extern int glo3SL=420;//三位小数点时止损点数
extern int glo3moveSL=400;//三位小数点时移动止损点数
extern bool glo2Digitsture=false;//修改两位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo2TP=620;//两位小数点时止盈点数
extern int glo2SL=420;//两位小数点时止损点数
extern int glo2moveSL=400;//两位小数点时移动止损点数
extern bool glojianjuture=false;//设置全局间距开关 控制着EA全部的止盈止损间距 挂单间距                        ===
extern bool glojianju=false;//是否启用全局间距 启用后会以下面的参数修改整个EA的间距设定 默认不启用
extern int glojianjusl=3;//全局止损间距
extern int glojianjutp=1;//全局止盈间距
extern int glojianjuguadan=3;//全局挂单间距
extern bool glomaxTotallotsture=false;//设置全局单向最大下单总手数开关 请改为true后修改下面的参数 保存即可
extern double glomaxTotallots=5;//全局单向最大下单总手数 默认启动
extern bool glotickclosenumtrue=false;//设置Tick变化剧烈时自动平仓预设值开关 请改为true后修改下面的参数 保存即可
extern double glotickclosenum=40;//Tick变化剧烈时自动平仓预设值 B/S+Tab+9
extern bool gloxianshijunjiantrue=false;//图表订单信息是否显示均价 请改为true后修改下面的参数 保存即可
extern bool gloxianshijunjian=false;//图表订单信息是否显示均价 默认不显示
extern bool gloaccountProfitswitchtrue=false;//订单总利润平仓模式是否自动启用 请改为true后修改下面的参数 保存即可
extern bool gloaccountProfitswitch=false;//订单总利润平仓模式是否自动启用 默认不启用 L+X
extern bool globreakoutNottrue=false;//参考Breakout指标 突破提示音 是否自动启用 请改为true后修改下面的参数 保存后重新加载即可
extern bool globreakoutNot=false;//参考Breakout指标 突破提示音 默认不启用 M+主键盘1
extern bool gloAccountEquityLowtrue=false;//账户总净值 低于多少 全平仓  请改为true后修改下一行的参数 保存后重新加载EA即可
extern double gloAccountEquityLow=100;//账户总净值 低于多少 全平仓
extern bool gloAccountEquityHightrue=false;//账户总净值 高于多少 全平仓  请改为true后修改下一行的参数 保存后重新加载EA即可
extern double gloAccountEquityHigh=500;//账户总净值 高于多少 全平仓
extern bool gloAccountProfitmintrue=false;//总利润模式 盈利后再回到保本线 全平仓  请改为true后修改下一行的参数 保存后重新加载EA即可
extern double gloAccountProfitmin=1;//总利润模式 盈利后总利润再回到多少 全平仓

string TPObjName,SLObjName;   //字符串数据是用来存储文本串 找到的那两条线的名字
int    OrdersID[],OrdersCount,OpType;
double   建仓价,移动止损=0;
/*
一、采用趋势线计算获利止损价需要注意几点：

 1.图上有多条趋势线的情况：以管理多单为例，取距离当前价上方最近的一根趋势线作为止赢趋势线，止损线为下方最近的一根。
 2.运行中，用户可以随意改变趋势线的位置，程序会自动追踪。
 3.刚启动时，程序自动搜索到止赢止损趋势线后，不会再改变，即使用户把选中的线拖到别的线之外。
 4.更换当前图的时间周期会重新启动程序，再次搜索止赢止损线。
 5.如果用户删除原先选中的趋势线，程序会自动重新搜索。
 6.如果使用等距离通道线，则多单自动用上面一根作为止赢，下面的作为止损，空单相反。
 7.不建议使用角度线，因为角度线对于k线图不是固定的，坐标轴变化会影响线上价格的值。

二、建议操作方法：

 1.开仓
 2.在图中放置好平仓的止赢止损指标或趋势线
 3.把OrdersGuardian拖入图中，设置好相应的参数，建议把是否显示示例线设为true。在选项设置的common页Allow live trading先不要打勾，当前图的右上角应该出现一个叉。
 4.按下工具栏的Expert Advisors按钮，右上角的叉会变成一个哭脸，此时EA在工作，但不会平仓操作。
 5.如果图中显示的止赢止损线和预期一致，则按快捷键F7，选中Allow live trading，如果右上角图标变成一个笑脸，EA就开始正常工作监视持仓单了。
*/

/*
extern string reminder04="=== 批量挂单参数设置 临时废弃 ===";//默认以最小的小数点为基准
extern int guadanjuxianjia=50;//据现价多少挂单
extern double guadanlots=0.2;//挂单手数
extern int guadangeshu=5;//挂单个数
extern int guadanjianju=4;//挂单间距
extern int guadanSL=0;//挂单止损，0即为不设置
extern int guadanTP=0;//挂单止盈，0即为不设置
extern int guadanslippage=5;//挂单滑点数
*/
extern string reminder41="=== 图表上的按钮参数 ===";//图表上的按钮参数
///////////////////////////////////////////鼠标 点击 移动 图形按键 开始 mmmm

input int 缩放 = 2;
int d(const double d3)   //缩放比例
  {
   return((int)d3*缩放);
  }

//const int anjiu_zt = 10;//字体大小
#define anjiu_zt 10 ////字体大小
extern int anjiu_W=100;//按钮宽
extern int anjiu_H=12;//按钮高
#define COLOR_ENABLE clrDarkGray//中灰 按下时的背景色
#define COLOR_DISABLE clrWhiteSmoke//白 
#define menu_zs_zhu 35 //常用菜单下拉框 数量 请保持所有的菜单下拉框数量 保持一样 不同可能会使 数组 报错
#define menu_zs 35 //1下拉菜单数量
#define menu_zs2 35 //2下拉菜单数量
#define menu_zs3 35 //3下拉菜单数量
#define menu_zs4 35 //4下拉菜单数量
#define menu_zs5 35 //5下拉菜单数量
#define menu_zs6 35 //5下拉菜单数量
#define menu_zs8 35 //按钮1 副图1按键下拉菜单数量
#define menu_zs12 35 //按钮1 副图2按键下拉菜单数量
#define menu_zs13 35 //按钮1 副图3按键下拉菜单数量
#define menu_zs14 35 //按钮1 副图3按键下拉菜单数量
#define menu_zs15 35 //按钮1 副图3按键下拉菜单数量
#define menu_zs31 35 //按钮3 副图1按键下拉菜单数量
#define menu_zs223 35 //按钮2 副图23按键下拉菜单数量
#define menu_zs224 35 //按钮2 副图23按键下拉菜单数量

string pre = "oname"; //前缀关键字，用于批量删除
string pre1= "onameA"; //前缀关键字，用于批量删除
string pre2= "onameB"; //前缀关键字，用于批量删除
string pre3= "onameC"; //前缀关键字，用于批量删除
string pre4= "onameD"; //前缀关键字，用于批量删除
string pre5= "onameE"; //前缀关键字，用于批量删除
string pre6= "onameF"; //前缀关键字，用于批量删除
string pre8= "onameH"; //前缀关键字，用于批量删除
string pre31= "onameCA"; //前缀关键字，用于批量删除
string pre12= "onameAB"; //前缀关键字，用于批量删除
string pre13= "onameAC"; //前缀关键字，用于批量删除
string pre14= "onameAD"; //前缀关键字，用于批量删除
string pre15= "onameAE"; //前缀关键字，用于批量删除
string pre223= "onameBBC"; //前缀关键字，用于批量删除
string pre224= "onameBBD"; //前缀关键字，用于批量删除
extern int but_zhu_x=225;//按钮菜单 X坐标轴
extern int but_zhu_y=0;//按钮菜单 y坐标轴
//下面主导航栏的坐标 需要在在 初始化 里更新一下
int but_x=but_zhu_x+anjiu_W*缩放;
int but_y =but_zhu_y;
int but_x2=but_zhu_x+anjiu_W*缩放*2;
int but_y2 =but_zhu_y;
int but_x3=but_zhu_x+anjiu_W*缩放*3;
int but_y3 =but_zhu_y;
int but_x4=but_zhu_x+anjiu_W*缩放*4;
int but_y4=but_zhu_y;
int but_x5=but_zhu_x+anjiu_W*缩放*6;
int but_y5=but_zhu_y;
int but_x6=but_zhu_x+anjiu_W*缩放*5;//短线追单 和自动化 对调了一下
int but_y6=but_zhu_y;
int but_x8;
int but_y8;
int but_x31;
int but_y31;
int but_x12;
int but_y12;
int but_x13;
int but_y13;
int but_x14;
int but_y14;
int but_x15;
int but_y15;
int but_x223;
int but_y223;
int but_x224;
int but_y224;
bool view_but=true; //0主菜单下拉框隐藏开关 true 隐藏
bool view_but1=true; //1主菜单下拉框隐藏开关 true 隐藏
bool view_but2=true; //2主菜单下拉框隐藏开关 true 隐藏
bool view_but3=true; //3主菜单下拉框隐藏开关 true 隐藏
bool view_but4=true; //4主菜单下拉框隐藏开关 true 隐藏
bool view_but5=true; //5主菜单下拉框隐藏开关 true 隐藏
bool view_but6=true; //5主菜单下拉框隐藏开关 true 隐藏
bool view_but8=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but31=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but12=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but13=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but14=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but15=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but223=false; //主菜单下拉框隐藏开关 true 隐藏
bool view_but224=false; //主菜单下拉框隐藏开关 true 隐藏
//bool close_bool=false; //主菜单隐藏开关
bool menu[menu_zs];
bool menu1[menu_zs_zhu];
bool menu2[menu_zs2];
bool menu3[menu_zs3];
bool menu4[menu_zs4];
bool menu5[menu_zs5];
bool menu6[menu_zs6];
bool menu8[menu_zs8];
bool menu12[menu_zs12];
bool menu13[menu_zs13];
bool menu14[menu_zs14];
bool menu15[menu_zs15];
bool menu31[menu_zs31];
bool menu223[menu_zs223];
bool menu224[menu_zs224];
//double 水平线;
//bool 鼠标跟随;
bool shubiaogensuiBuy;//鼠标跟随;
bool shubiaogensuiSell;//鼠标跟随;
bool shubiaogensuiSL;//鼠标跟随;

///////////////////////////////////////////鼠标 点击 移动 图形按键 结束

double price1m5kLow;//预先设定几个数值，都是最近几根K线的最高最低值 用来止盈止损用 放定时器里
double price1m5kHigh;
double price1m10kLow;
double price1m10kHigh;
double price5m3kLow;
double price5m3kHigh;
double price5m5kLow;
double price5m5kHigh;
double price15m3kLow;
double price15m3kHigh;
double price15m5kLow;
double price15m5kHigh;
double price15m10kLow;
double price15m10kHigh;
double pricebuyline;
double pricesellline;
double pricemkLow[7];
double pricemkHigh[7];
int pricemkLowjishu=0;
int pricemkHighjishu=0;

double hpriceK1[];//一分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double lpriceK1[];//一分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double opriceK1[];//一分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double cpriceK1[];//一分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
datetime tpriceK1[];//K线开盘时间
double hpriceK[];//五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double lpriceK[];//五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double opriceK[];//五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double cpriceK[];//五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
datetime tpriceK[];//K线开盘时间
double hpriceK15[];//十五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double lpriceK15[];//十五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double opriceK15[];//十五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
double cpriceK15[];//十五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
datetime tpriceK15[];//时间
double buyline;
double sellline;
double slline;
double buylineOnTimer;
double selllineOnTimer;
double timebuyprice=0.0;
double timesellprice=10000.0;
double huaxianguadanlotsT=huaxianguadanlots;
double BreakOutDown80;//根据BreakOut指标 获取它矩形的横线价格
double BreakOutUp80;
double BreakOutDown100;
double BreakOutUp100;
double BreakOutDown0;
double BreakOutUp0;
int linebar01=linebar;
bool akey=false;
bool zkey=false;
bool ctrl=false;
bool ctrlR=false;
bool shift=false;
bool shiftR=false;
bool tab=false;
bool bkey=false;
bool skey=false;
bool pkey=false;
bool lkey=false;
bool tkey=false;
bool gkey=false;
bool okey=false;
bool ykey=false;
bool kkey=false;
bool vkey=false;
bool fkey=false;
bool jkey=false;
bool dkey=false;
bool mkey=false;
bool nkey=false;
bool xkey=false;
bool nakey=false;//主键盘数字1 左边的按键
bool ikey=false;
bool hkey=false;
bool fansuoYes=false;
bool yijianFanshou=false;

bool huaxianSwitch=false;//划线平仓或锁仓
bool huaxianTimeSwitch=false;//划线平仓或锁仓
bool huaxiankaicang=false;
bool huaxianguadan=false;//划线挂单开关 Tab+主键盘1 调试阶段
bool SL1mbuyLine=false;
bool SL1msellLine=false;
bool SL5mbuyLine=false;
bool SL5msellLine=false;
bool SL15mbuyLine=false;
bool SL15msellLine=false;
double SL1mbuyLineprice=Ask-1000*Point;
double SL1msellLineprice=Bid+1000*Point;
double SL5mbuyLineprice=Ask-1000*Point;
double SL5msellLineprice=Bid+1000*Point;
double SL15mbuyLineprice=Ask-1000*Point;
double SL15msellLineprice=Bid+1000*Point;
double SL1mbuyLineprice1;
double SL1msellLineprice1;
double SL5mbuyLineprice1;
double SL5msellLineprice1;
double SL15mbuyLineprice1;
double SL15msellLineprice1;
bool SLbuylinepingcang=false;//止损用
bool SLselllinepingcang=false;//止损用

bool SLbuylineQpingcang=false;//*键 剥头皮 短线触及平仓 定时器
bool SLselllineQpingcang=false;
bool SLbuylineQpingcangT=false;//*键 剥头皮 短线触及平仓 Tick
bool SLselllineQpingcangT=false;
double SLsellQpengcangline=Bid+1000*Point;
double SLbuyQpengcangline=Ask-1000*Point;

double yijianfanshoubuylots=0.0;
double yijianfanshouselllots=0.0;

//bool SLbuylinepingcang1=false;
//bool SLselllinepingcang1=false;

bool SLbuylineQpingcang1=false;//Q键 短线触及平仓 定时器
bool SLselllineQpingcang1=false;
bool SLbuylineQpingcangT1=false;//Q键 短线触及平仓 Tick上
bool SLselllineQpingcangT1=false;
double SLsellQpengcangline1=Bid+1000*Point;
double SLbuyQpengcangline1=Ask-1000*Point;
double fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

int SLlinepingcangjishu1=0;//
double SLQlotsT=SLQlots;

bool imbfxT=false;//
bool iBSTrend=false;//
bool iBreakout=false;//I+3
bool iBreakout15=false;//I+3
bool iBreakoutfanshou=false;//F+ I+3 平仓后反手
bool iBreakoutfanshou15=false;//f+I+3 平仓后反手
bool iBreakoutkaicangbuy=false;//启动横线模式开buy仓
bool iBreakoutkaicangsell=false;//启动横线模式开sell仓
bool iBreakoutkaicangbuy1=false;//启动横线模式开buy仓
bool iBreakoutkaicangsell1=false;//启动横线模式开sell仓
bool breakoutNot=false;//突破提醒
bool breakoutNot1=false;//突破提醒
bool iBreakoutSLpingcangNow=false;//突破箱体马上止损平仓
bool iBreakoutSLpingcang=false;//突破箱体止损平仓
bool iBreakoutSLpingcangBuy=false;//突破箱体止损平仓
bool iBreakoutSLpingcangSell=false;//突破箱体止损平仓
double iBreakoutSLpingcangBuyPrice=0.0;//突破箱体止损平仓
double iBreakoutSLpingcangSellPrice=0.0;//突破箱体止损平仓
int iBreakoutSLpingcangjishu=3;//突破箱体止损平仓


datetime ctrltimeCurrent;
datetime ctrlRtimeCurrent;
datetime shifttimeCurrent;
datetime shiftRtimeCurrent;
datetime tabtimeCurrent;
datetime btimeCurrent;
datetime stimeCurrent;
datetime ptimeCurrent;
datetime ltimeCurrent;
datetime ttimeCurrent;
datetime shangtimeGMT=TimeGMT();//统计 键按下的次数时使用 计时器的一种
datetime xiatimeGMT=TimeGMT();
datetime atimeCurrent;
datetime ztimeCurrent;
datetime gtimeCurrent;
datetime otimeCurrent;
datetime ytimeCurrent;
datetime ktimeCurrent;
datetime vtimeCurrent;
datetime ftimeCurrent;
datetime dtimeCurrent;
datetime mtimeCurrent;
datetime ntimeCurrent;
datetime natimeCurrent;//~
datetime htimeCurrent;
datetime xtimeCurrent;
datetime falsetimeCurrent;
datetime itimeCurrent;
datetime SL5QTPtimeCurrent;
datetime breakoutNottimeCurrent;
bool SL5QTPtimeCurrenttrue=false;
bool onlybuy=true;
bool onlysell=true;
bool onlystp=false;
bool onlytpt=false;
bool onlyup=false;
bool onlydown=false;
bool onlybuy1=false;
bool onlysell1=false;
bool buymaxTotallots=false;//限制最多下单总手数
bool sellmaxTotallots=false;//限制最多下单总手数
bool notebook=false;//笔记本模式
bool sellbaobenture=false;
bool buybaobenture=false;
bool tickclose=false;
bool huaxianShift=false;
bool huaxianCtrl=false;
bool tickShift=false;
bool linebuykaicang=false;
bool linekaicangshiftR=false;
bool OnTickswitch=true;//没订单时减少运行 节省系统性能
bool OnTimerswitch=true;//没订单时减少运行 节省系统性能
bool timertrue=false;//没订单时减少运行 节省系统性能
int huaxiankaicanggeshuR1=huaxiankaicanggeshuR;//
int huaxiankaicanggeshu1=huaxiankaicanggeshu;//延迟
int huaxiankaicanggeshuT1=huaxiankaicanggeshuT;//延迟
int huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
int huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
int huaxiankaicangtimeP=huaxiankaicangtime;//传导
int huaxiankaicangtimeTP=huaxiankaicangtimeT;//传导
bool linesellkaicang=false;
bool linebuyfansuo=false;
bool linesellfansuo=false;
bool linebuypingcang=false;
bool linebuypingcangR=false;//ShiftR
bool linebuypingcangC=false;//定时器模式运行
bool linebuypingcangctrlR=false;//触及横线后距当前价多少设置止损 薅羊毛用
bool linesellpingcang=false;
bool linesellpingcangR=false;
bool linesellpingcangC=false;
bool linesellpingcangctrlR=false;//触及横线后距当前价多少设置止损 薅羊毛用
bool linebuyzidongjiacang=false;
bool linesellzidongjiacang=false;
bool lineTime=false;
bool linefirsttime=true;
bool linekaicangT=false;//L+K 开仓标记 Tab 增加开仓次数和间隔时间开仓
bool linekaicangctrl=false;//L+K ctrl
bool dingshipingcang=false;//五分钟收线定时平仓
bool dingshipingcang15=false;//十五分钟收线定时平仓
bool dingshikaicang=false;//五分钟收盘时开仓
bool dingshikaicang15=false;//十五分钟收盘时开仓
int dingshikaicanggeshu1=dingshikaicanggeshu;//五分钟收盘时开仓次数
bool dingshipingcangF=false;//五分钟收线定时平仓后反手
bool dingshipingcang15F=false;//十五分钟收线定时平仓后反手
bool linebuypingcangonly=false;//L+P时 提前B/S只平一边
bool linesellpingcangonly=false;//L+P时 提前B/S只平一边
bool hengxianAi1=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi1a=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
double hengxianAi1bullpianyi=0.0;//
bool hengxianAi2=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi3=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi4=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi5=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi6=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi7=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool hengxianAi8=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
bool fkeyHolding=false;//反手开仓 支持
bool fkeyHoldingfanshou=false;//L+P 提前按F 平仓后 移动横线 启动触线开仓
bool accountProfitswitch=false;//以订单总利润 计算平仓模式
bool accountProfitswitch1=false;//以订单总利润 计算平仓模式 薅羊毛
bool yinyang5m1k;//追踪5分钟图表最近收盘的K线是阴是阳 阳线是 true
bool yinyang5m2k;//追踪5分钟图表最近收盘的K线是阴是阳
bool yinyang5m3k;//追踪5分钟图表最近收盘的K线是阴是阳
bool yinyang5m4k;//追踪5分钟图表最近收盘的K线是阴是阳
bool yinyang5m5k;//追踪5分钟图表最近收盘的K线是阴是阳
bool yinyang5mkaiguan=true;//追踪5分钟图表最近收盘的K线是阴是阳 默认开启
bool yinyang5mkaiguan1=false;//
bool yinyang15mkaiguan=true;//追踪15分钟图表最近收盘的K线是阴是阳 默认开启
bool yinyang15mkaiguan1=false;//
bool yinyang5mkaicang=false;//最近5分钟出现两根相同颜色的K线开仓追单
bool yinyang5mkaicang1=false;//
bool yinyang5mkaicangshiftR=false;//5分钟出现两根相同颜色的K线启动横线模式追单
bool yinyang5mkaicangshiftR1=false;//
bool yinyang5mpingcang=false;//最近5分钟出现两根相同颜色的K线平仓
bool yinyang5mpingcang1=false;
bool yinyang5mpingcangshiftR=false;//最近5分钟出现两根相同颜色的K线平仓后反手
bool yinyang5mpingcangshiftR1=false;
bool yinyang5mpingcangctrlR=false;//最近5分钟出现第二第三根K线和最近收盘的一根K线颜色相反平仓
bool yinyang5mpingcangctrlR1=false;
datetime yinyang5mpingcangtime;//Y+P 启动开关只能持续几分钟，不执行就关闭
int yinyang5mkaicanggeshu1=yinyang5mkaicanggeshu;
bool yinyang5mpingcangBuy1K2Kyin=false;//5分钟追多单时 连续出现两根阴线 直接平仓
bool yinyang5mpingcangBuy1K2Kyin1=false;//
bool yinyang5mpingcangSell1K2Kyang=false;//5分钟追空单时 连续出现两根阳线 直接平仓
bool yinyang5mpingcangSell1K2Kyang1=false;//
bool yinyang5mpingcangBuy1K2K3Kyin=false;//5分钟追多单时 连续出现3根阴线 直接平仓
bool yinyang5mpingcangBuy1K2K3Kyin1=false;//5分钟追多单时 连续出现3根阴线 直接平仓
bool yinyang5mpingcangSell1K2K3Kyang=false;//5分钟追空单时 连续出现3根阴线 直接平仓
bool yinyang5mpingcangSell1K2K3Kyang1=false;//5分钟追空单时 连续出现3根阴线 直接平仓
bool yinyang5mkaicang1Kyangbuy=false;//5分钟收阳 直接开多单追
bool yinyang5mkaicang1Kyinsell=false;//5分钟收阴 直接开空单追
bool yinyang5mkaicang1Kyangbuyheng=false;//5分钟收阳 直接开多单 横线模式追
bool yinyang5mkaicang1Kyinsellheng=false;//5分钟收阴 直接开空单 横线模式追
bool yiyang5mpingcangshiti=false;//L+P 越过横线 先不平仓 等五分钟收盘看 实体越过不 再平仓
bool yiyang5mpingcangshiti1=false;//L+P 越过横线 先不平仓 等五分钟收盘看 实体越过不 再平仓

double linepianyi1=linepianyi;//横线模式下W/S每次上移或下移多少基点 横线模式


int linetime;
int xunhuanMagic=0;//根据Magic循环平仓用

bool linelock=false;
int shangpress=0;//统计方向键上键按下的次数
int xiapress=0;//统计方向键下键按下的次数
int leftpress=0;//统计方向键左键按下的次数
int rightpress=0;//统计方向键右键按下的次数
int tickjishu=4;
bool tickbuyclose=false;
int dingdanshu=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu1=100;//主键盘0-9按下数字 处理最近的几单 N D 加小键盘数字使用
int dingdanshu2=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu3=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu4=100;//主键盘0-9按下数字 处理最近的几单
int pingcangdingdanshu=1000;//主键盘0-9按下数字 处理最近的几单
int guadangeshu=huaxianguadangeshu;//小键盘1 2 3 挂单个数
double tick4,tick3,tick2,tick1,tick0;
int buydangeshu=0;//定时更新订单个数
int selldangeshu=0;//定时更新订单个数
bool onlybuydan=false;//订单中 只要buy单
bool onlyselldan=false;//订单中 只要sell单
int timesecondstrue;
int xiaoshudian=2;//分批平仓 每次仓位保留到几位小数点
double keylotshalfT;
double keylotshalf;
int buyselldingdangeshunew=0;
int buyselldingdangeshuold=0;

double timeseconds1=timeseconds1P;//
//bool juxianjiadingshi03=false;
datetime expiration=TimeCurrent()+expirationM*60;
datetime timeGMT0=D'1970.01.01 00:00:00';
datetime timeGMT1=D'1970.01.01 00:00:00';
datetime timeGMT2=D'1970.01.01 00:00:00';
datetime timeGMT3=D'1970.01.01 00:00:00';
datetime timeGMT4=D'1970.01.01 00:00:00';
datetime timeGMT5=D'1970.01.01 00:00:00';
datetime timeGMT6=D'1970.01.01 00:00:00';
double OriginalLot;
string reminder06="=== 批量修改止盈止损点数或直接输入价位 ===";//默认以常用的点数为基准  临时弃用 隐藏参数
int StopLoss=0; // 止损点数设置 全为0时取消止盈止损
int TargetProfit=0; // 止盈点数设置 点数和价位可以混合使用
double FixedStopLoss=0.0; //或直接输入止损价位 价位优先 下次用时记得清零
double FixedTargetProfit=0.0; //或直接输入止盈价位 单独使用其中的一项不影响之前的设定

double diancha;//点差 不用带Point
double pianyilingGlo;//全局偏移量 不用*Point
double stoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);//当前货币的 停止水平位
double minlot=MarketInfo(Symbol(),MODE_MINLOT);//当前货币的最小下单量
string Exness="Exness Ltd.";
double buyLotslinshi;
double sellLotslinshi;
double buyLotslinshi1;//menu[27]上用
double sellLotslinshi1;
int bars0971=bars097;
bool kaiguan01=false;
bool dxzdBuyLineC1=false;
bool dxzdBuyLineO1=false;
bool dxzdBuyLineL1=false;
bool dxzdSellLineC1=false;
bool dxzdSellLineO1=false;
bool dxzdSellLineH1=false;
bool dxzdBuyi2kSL=false;//首次触及止损线 等待几秒钟 在运行
bool dxzdBuyi3kSL=false;
bool dxzdBuyi4kSL=false;
bool dxzdBuyi5kSL=false;
bool dxzdSelli2kSL=false;
bool dxzdSelli3kSL=false;
bool dxzdSelli4kSL=false;
bool dxzdSelli5kSL=false;
bool testkaiguan=true;
datetime dxzdBuyLineL1Time;// /键 生成后 有时限
bool znBuy5mSL1=false;//首次触及止损线 等待几秒钟 在运行
bool znBuy5mSL2=false;
bool znBuy5mSL3=false;
bool znBuy15mSL1=false;//首次触及止损线 等待几秒钟 在运行
bool znBuy15mSL2=false;
bool znBuy15mSL3=false;
bool znSell5mSL1=false;//首次触及止损线 等待几秒钟 在运行
bool znSell5mSL2=false;
bool znSell5mSL3=false;
bool znSell15mSL1=false;//首次触及止损线 等待几秒钟 在运行
bool znSell15mSL2=false;
bool znSell15mSL3=false;
double zhendangzhibiao[100];//震荡指标

int zhendang6H=0;//震荡指标最近6根K线 大于0.07K线的个数
int zhendang6Z=0;//震荡指标最近6根K线 0至0.07 K线的个数
int zhendang6F=0;//震荡指标最近6根K线 0至-0.07 K线的个数
int zhendang6L=0;//震荡指标最近6根K线 小于-0.07 K线的个数

int zhendang12H=0;//震荡指标最近12根K线 大于0.07K线的个数
int zhendang12Z=0;//震荡指标最近12根K线 0至0.07 K线的个数
int zhendang12F=0;//震荡指标最近12根K线 0至-0.07 K线的个数
int zhendang12L=0;//震荡指标最近12根K线 小于-0.07 K线的个数

int zhendang24H=0;//震荡指标最近24根K线 大于0.07K线的个数
int zhendang24Z=0;//震荡指标最近24根K线 0至0.07 K线的个数
int zhendang24F=0;//震荡指标最近24根K线 0至-0.07 K线的个数
int zhendang24L=0;//震荡指标最近24根K线 小于-0.07 K线的个数

int zhendang36H=0;//震荡指标最近36根K线 大于0.07K线的个数
int zhendang36Z=0;//震荡指标最近36根K线 0至0.07 K线的个数
int zhendang36F=0;//震荡指标最近36根K线 0至-0.07 K线的个数
int zhendang36L=0;//震荡指标最近36根K线 小于-0.07 K线的个数
datetime mbfxSleeptime;
int mbfxSleep;//秒 mbfx提醒一次后 等待时间
datetime shijiancha;//服务器与本地的时间差
bool BuySL1=false;
bool SellSL1=false;
datetime BuySL2;
datetime SellSL2;

bool kaiguan5m=true;//Tick 里 实现5分钟收盘时运行一次  更加 精准
bool kaiguan15m=true;
datetime kaiguan5mtime;
datetime kaiguan15mtime;

bool kaiguan5m1=true;
bool kaiguan15m1=true;
datetime kaiguan5m1time;
datetime kaiguan15m1time;

bool kaiguan5m2=true;
bool kaiguan15m2=true;
datetime kaiguan5m2time;
datetime kaiguan15m2time;

bool kaiguan5m3=true;
bool kaiguan15m3=true;
datetime kaiguan5m3time;
datetime kaiguan15m3time;
int hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
double hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
bool hengxianJJSkaicangBuy=false;//顺式开仓
bool hengxianJJSkaicangSell=false;
int menu4_8jishu=50;

datetime BuyTrendLineSLtime;
datetime SellTrendLineSLtime;
datetime BuyTrendLineSL2time;
datetime SellTrendLineSL2time;
datetime BuyTrendLineSL3time;
datetime SellTrendLineSL3time;
int BuyTrendLineSLjishu=5;
int SellTrendLineSLjishu=5;
bool BuyTrendLineSL1=false;
bool SellTrendLineSL1=false;
bool BuyTrendLineSL2=false;
bool SellTrendLineSL2=false;
bool BuyTrendLineSL3=false;
bool SellTrendLineSL3=false;

double Vegas144;
double Vegas169;
double Vegas288;
double Vegas338;
bool Vegas_144;
bool Vegas_169;
bool Vegas_288;
bool Vegas_338;
datetime selltime01;
datetime buytime01;
bool menu27Tick=false;
double f5lots=0.0;
datetime menu224_1time;
int menu224_0geshu1=menu224_0geshu;
int menu224_1geshu1=menu224_1geshu;
int menu224_1sleep1=menu224_1sleep;
int breakoutNottime=300;//breakout指标 突破提醒后 等待时间 秒 跟随图表周期变化
bool ATR1=true;
double ATRvalue=iATR(NULL,0,ATRcanshu,0);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()//chushihua
  {
   if(TerminalInfoInteger(TERMINAL_CPU_CORES)<=2 && but_zhu_x==225)//如何发现 电脑是两核以下的 默认为VPS 改变按钮的位置 靠左
     {
      but_zhu_x=25;
      anjiu_W=85;
      Print("电脑是两核以下的 默认为VPS上运行 改变按钮的位置 靠左 缩小间距 方便手机远程访问");
     }
   mbfxSleep=PeriodSeconds();
   breakoutNottime=PeriodSeconds();
   shijiancha=TimeLocal()-TimeCurrent();//服务器与本地的时间差
   pianyilingGlo=pianyiglo*Point;//全局偏移量 不用*Point；
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 1);//初始化鼠标移动和鼠标点击事件mmm
   RefreshRates();
   but_x=but_zhu_x+anjiu_W*缩放;
   but_y =but_zhu_y;
   but_x2=but_zhu_x+anjiu_W*缩放*2;
   but_y2 =but_zhu_y;
   but_x3=but_zhu_x+anjiu_W*缩放*3;
   but_y3 =but_zhu_y;
   but_x4=but_zhu_x+anjiu_W*缩放*4;
   but_y4=but_zhu_y;
   but_x5=but_zhu_x+anjiu_W*缩放*6;
   but_y5=but_zhu_y;
   but_x6=but_zhu_x+anjiu_W*缩放*5;//短线追单 和自动化 对调了一下
   but_y6=but_zhu_y;
   Draw_button0();//画按钮 隐藏按钮开关
   Draw_button_zhu();//画按钮 隐藏按钮开关
   Draw_button();//画按钮 隐藏按钮开关
   Draw_button2();//画按钮 隐藏按钮开关
   Draw_button3();//画按钮 隐藏按钮开关
   Draw_button4();//画按钮 隐藏按钮开关
   Draw_button5();//画按钮 隐藏按钮开关
   Draw_button6();//画按钮 隐藏按钮开关
   menu4[0]=true;//默认启动 备用 第一个按钮
   ArrayCopySeries(hpriceK1,2,NULL,1);//一分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
   ArrayCopySeries(lpriceK1,1,NULL,1);//ArrayCopySeries 这个功能 很神奇 只需要初始化一次 它并没有真的复制数组的内容  每次调用都会重定向计算 所以数组内容会跟着图表更新数据
   ArrayCopySeries(opriceK1,0,NULL,1);
   ArrayCopySeries(cpriceK1,3,NULL,1);
   ArrayCopySeries(tpriceK1,5,NULL,1);

   ArrayCopySeries(hpriceK,2,NULL,0);//五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
   ArrayCopySeries(lpriceK,1,NULL,0);//ArrayCopySeries 这个功能 很神奇 只需要初始化一次 它并没有真的复制数组的内容  每次调用都会重定向计算 所以数组内容会跟着图表更新数据
   ArrayCopySeries(opriceK,0,NULL,0);
   ArrayCopySeries(cpriceK,3,NULL,0);
   ArrayCopySeries(tpriceK,5,NULL,0);

   ArrayCopySeries(hpriceK15,2,NULL,15);//十五分钟K线收盘时 把最近的几根K线的四个数值 存储在数组中 方便调用
   ArrayCopySeries(lpriceK15,1,NULL,15);//ArrayCopySeries 这个功能 很神奇 只需要初始化一次 它并没有真的复制数组的内容  每次调用都会重定向计算 所以数组内容会跟着图表更新数据
   ArrayCopySeries(opriceK15,0,NULL,15);
   ArrayCopySeries(cpriceK15,3,NULL,15);
   ArrayCopySeries(tpriceK15,5,NULL,15);

//Print(ArraySize(hpriceK));//
//Print(hpriceK[0]);//获取第0根K线的最高价
//Print(hpriceK[ArrayMaximum(hpriceK,10,0)]);//计算最近10根K线 最高价是多少 包含当前K线
   if(linebuypingcangctrlRpianyi<stoplevel)
     {
      linebuypingcangctrlRpianyi=stoplevel+1;
     }
   if(IsDemo())
     {

     }
   if(MarketInfo(Symbol(),MODE_MINLOT)==0.1)//分步平仓 仓位小数点
     {
      xiaoshudian=1;
     }
   if(MarketInfo(Symbol(),MODE_MINLOT)==1)
     {
      xiaoshudian=0;
     }
   if(GetHoldingbuyOrdersCount()>0 || GetHoldingsellOrdersCount()>0)//如果订单反锁时 不执行止盈止损 自动分步平仓
     {
      if(NormalizeDouble(CGetbuyLots(),2)==NormalizeDouble(CGetsellLots(),2))
        {
         fansuoYes=true;
         Print("多空锁仓中 不执行止盈止损 自动分步平仓 解锁后需要重新加载EA恢复功能 注意价格是否会触发分步平仓");
         comment4("多空锁仓中 不执行止盈止损 自动分步平仓 解锁后");
         comment5("需要重新加载EA恢复功能 注意价格是否会触发分步平仓");
        }
     }
   if(ObjectFind(0,"Buy Line")==0)
      ObjectDelete(0,"Buy Line");
   if(ObjectFind(0,"Sell Line")==0)
      ObjectDelete(0,"Sell Line");
   if(ObjectFind(0,"SL1mbuyLine")==0)
      ObjectDelete(0,"SL1mbuyLine");
   if(ObjectFind(0,"SL5mbuyLine")==0)
      ObjectDelete(0,"SL5mbuyLine");
   if(ObjectFind(0,"SL15mbuyLine")==0)
      ObjectDelete(0,"SL15mbuyLine");
   if(ObjectFind(0,"SL1msellLine")==0)
      ObjectDelete(0,"SL1msellLine");
   if(ObjectFind(0,"SL5msellLine")==0)
      ObjectDelete(0,"SL5msellLine");
   if(ObjectFind(0,"SL15msellLine")==0)
      ObjectDelete(0,"SL15msellLine");
   if(ObjectFind(0,"SLsellQpengcangline")==0)
      ObjectDelete(0,"SLsellQpengcangline");
   if(ObjectFind(0,"SLbuyQpengcangline")==0)
      ObjectDelete(0,"SLbuyQpengcangline");
   if(ObjectFind(0,"SLsellQpengcangline1")==0)
      ObjectDelete(0,"SLsellQpengcangline1");
   if(ObjectFind(0,"SLbuyQpengcangline1")==0)
      ObjectDelete(0,"SLbuyQpengcangline1");
   if(ObjectFind(0,"iBSTrend")==0)
      ObjectDelete(0,"iBSTrend");
   if(ObjectFind(0,"MBFX")==0)
      ObjectDelete(0,"MBFX");
   if(ObjectFind(0,"iBreakout")==0)
      ObjectDelete(0,"iBreakout");
   if(ObjectFind(0,"iBreakoutfanshou")==0)
      ObjectDelete(0,"iBreakoutfanshou");

   EventSetTimer(SetTimer);//定时器 初始化
////////////////////////////////////////////////////////////////////////////
   if(gloxianshijunjiantrue)//
     {
      if(gloxianshijunjian)
        {
         GlobalVariableSet("gloxianshijunjian",1);
         Print("图表订单信息是否显示均价 显示 请重新加载EA");
         Alert("图表订单信息是否显示均价 显示 请重新加载EA");
        }
      else
        {
         GlobalVariableSet("gloxianshijunjian",0);
         Print("图表订单信息是否显示均价 不显示 请重新加载EA");
         Alert("图表订单信息是否显示均价 不显示 请重新加载EA");
        }
     }
   else
     {
      if(GlobalVariableCheck("gloxianshijunjian"))
        {
         if(GlobalVariableGet("gloxianshijunjian")==0)
           {
            gloxianshijunjian=false;
           }
         else
           {
            gloxianshijunjian=true;
           }
        }
      else
        {
         GlobalVariableSet("gloxianshijunjian",0);
        }
     }
///////////////////////////////////////////////////////////////
   if(globreakoutNottrue)//
     {
      if(globreakoutNot)
        {
         GlobalVariableSet("globreakoutNot",1);
         Print("参考Breakout指标 突破提示音 自动启用 请重新加载EA");
         Alert("参考Breakout指标 突破提示音 自动启用 请重新加载EA");
        }
      else
        {
         GlobalVariableSet("globreakoutNot",0);
         Print("参考Breakout指标 突破提示音 不自动启用 请重新加载EA");
         Alert("参考Breakout指标 突破提示音 不否自动启用 请重新加载EA");
        }
     }
   else
     {
      if(GlobalVariableCheck("globreakoutNot"))
        {
         if(GlobalVariableGet("globreakoutNot")==0)
           {
            breakoutNot=false;
            breakoutNot1=false;
           }
         else
           {
            breakoutNot=true;
            breakoutNot1=true;
           }
        }
      else
        {
         GlobalVariableSet("globreakoutNot",0);
        }
     }
///////////////////////////////////////////////////////////////
   if(gloaccountProfitswitchtrue)//
     {
      if(gloaccountProfitswitch)
        {
         GlobalVariableSet("gloaccountProfitswitch",1);
         Print("订单总利润平仓模式自动启用  请重新加载EA");
         comment1("订单总利润平仓模式自动启用  请重新加载EA");
         Alert("订单总利润平仓模式自动启用 请重新加载EA");
        }
      else
        {
         GlobalVariableSet("gloaccountProfitswitch",0);
         Print("订单总利润平仓模式不自动启用  请重新加载EA");
         comment1("订单总利润平仓模式不自动启用  请重新加载EA");
         Alert("订单总利润平仓模式不自动启用  请重新加载EA");
        }
     }
   else
     {
      if(GlobalVariableCheck("gloaccountProfitswitch"))
        {
         if(GlobalVariableGet("gloaccountProfitswitch")==0)
           {
            accountProfitswitch=false;
           }
         else
           {
            accountProfitswitch=true;
           }
        }
      else
        {
         GlobalVariableSet("gloaccountProfitswitch",0);
        }
     }
///////////////////////////////////
   if(glotickclosenumtrue)
     {
      string num="glotickclosenum"+Symbol();

      GlobalVariableSet(num,glotickclosenum);
      Print("Tick变化剧烈时自动平仓预设值已更新 请重新加载EA");
      Alert("Tick变化剧烈时自动平仓预设值已更新 请重新加载EA");
     }
   else
     {
      string num="glotickclosenum"+Symbol();
      if(GlobalVariableCheck(num))
        {
         glotickclosenum=GlobalVariableGet(num);
        }
      else
        {
         GlobalVariableSet(num,glotickclosenum);
        }
     }
   if(glomaxTotallotsture)
     {
      GlobalVariableSet("glomaxTotallots",glomaxTotallots);
      Print("全局单向最多下单手数限制已更新 请重新加载EA");
      Alert("全局单向最多下单总手数限制已更新 请重新加载EA");
     }
   else
     {
      if(GlobalVariableCheck("glomaxTotallots"))
         Print("全局单向最多下单总手数限制启用 当前最大可下",GlobalVariableGet("glomaxTotallots"),"手");
      else
         GlobalVariableSet("glomaxTotallots",glomaxTotallots);
     }
   if(glojianjuture)//设置间距的全局函数
     {
      GlobalVariableSet("glojianjusl",glojianjusl);
      GlobalVariableSet("glojianjutp",glojianjutp);
      GlobalVariableSet("glojianjuguadan",glojianjuguadan);
      if(GlobalVariableCheck("glojianjusl"))
         Print("全局的间距函数设置成功");
      if(glojianju)
        {
         GlobalVariableSet("glojianju",1);
         Print("全局间距已启用 请重新加载EA");
         Alert("全局间距已启用 请重新加载EA");
        }
      else
        {
         GlobalVariableDel("glojianju");
         Print("全局间距已关闭 请重新加载EA");
         Alert("全局间距已关闭 请重新加载EA");
        }
     }
   if(GlobalVariableCheck("glojianju") && GlobalVariableCheck("glojianjusl"))//判断全局间距设置并执行
     {
      int sl=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjusl"),0));
      int tp=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjutp"),0));
      int gd=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjuguadan"),0));
      jianju07=sl;
      jianju07tp=tp;
      jianju10=sl;
      jianju10tp=tp;
      piliangtpjianju=tp;
      piliangsljianju=sl;
      jianju03=sl;
      jianju04=tp;
      dingshijianju05=sl;
      dingshijianju06=tp;
      zhinengSLTPjianju=tp;
      jianju05=tp;
      Guadanjianju=gd;
      Guadanjianju1=gd;
      zhinengguadanjianju=gd;
      fibGuadanjianju=gd;
      tenGuadanjianju=gd;
      tensltpjianju=tp;
      huaxianguadanjianju=gd;
      Print("全局间距已启用 已修改间距为您的设定值 全局止损间距 ",sl," 全局止盈间距 ",tp," 全局挂单间距 ",gd," 如参数不对 请重新更新全局间距后加载");
     }
   if(globalVariablesDeleteAll)//初始化客户端全局函数设置
     {
      int Num=GlobalVariablesDeleteAll(NULL,0);
      if(Num>0)
        {
         Alert("删除全部的客户端全局函数成功 请重新加载EA");
         Print("删除全部的客户端全局函数成功 请重新加载EA");
        }
     }
////////////////////////////////////////////////////////////////////////////////////
   if(gloGraduallytrue)
     {
      if(Gradually)
        {
         GlobalVariableDel("gloGraduallyfalse");
         Print("分步平仓模式已启用 请重新加载EA");
         Alert("分步平仓模式已启用 请重新加载EA");
        }
      else
        {
         GlobalVariableSet("gloGraduallyfalse",1);
         Print("分步平仓模式已关闭 请重新加载EA");
         Alert("分步平仓模式已关闭 请重新加载EA");
        }
     }
   if(GlobalVariableCheck("gloGraduallyfalse"))
     {
      Gradually=false;
      Print("分步平仓模式已关闭");
     }
   else
     {
      Gradually=true;
     }
////////////////////////////////////////////////////////////////////////////////////
   if(gloAutoTrailingStoptrue)//
     {
      if(AutoTrailingStop)
        {
         GlobalVariableDel("gloAutoTrailingStopfalse");
         Print("盈利后追踪止损 已启用 请重新加载EA");
         Alert("盈利后追踪止损 已启用 请重新加载EA");
        }
      else
        {
         GlobalVariableSet("gloAutoTrailingStopfalse",1);
         Print("盈利后追踪止损 已关闭 请重新加载EA");
         Alert("盈利后追踪止损 已关闭 请重新加载EA");
        }
     }
   if(GlobalVariableCheck("gloAutoTrailingStopfalse"))
     {
      AutoTrailingStop=false;
      Print("盈利后追踪止损 已关闭");
     }
   else
     {
      AutoTrailingStop=true;
     }
////////////////////////////////////////////////////////////////////////////////////

   if(gloTickmodetrue)
     {
      if(Tickmode)
        {
         GlobalVariableSet("gloTickmodetrue",1);
         Print("Tick分步平仓模式已启用 请重新加载EA");
         Alert("Tick分步平仓模式已启用 请重新加载EA");
        }
      else
        {
         GlobalVariableDel("gloTickmodetrue");
         Print("计时器分步平仓模式已启用 请重新加载EA");
         Alert("计时器分步平仓模式已启用 请重新加载EA");
        }
     }
   if(glo5Digitsture)
     {
      GlobalVariableSet("glo5tp",glo5TP);
      GlobalVariableSet("glo5sl",glo5SL);
      GlobalVariableSet("glo5movesl",glo5moveSL);
      Alert("五位小数点时自动止盈止损参数已更新 请重新加载EA");
      Print("五位小数点时自动止盈止损参数已更新 请重新加载EA");
     }
   else
     {
      if(!GlobalVariableCheck("glo5tp"))
        {
         GlobalVariableSet("glo5tp",glo5TP);
         GlobalVariableSet("glo5sl",glo5SL);
         GlobalVariableSet("glo5movesl",glo5moveSL);
         Print("五位小数点时EA止盈止损初始化完成");
        }
     }
   if(glo3Digitsture)
     {
      GlobalVariableSet("glo3tp",glo3TP);
      GlobalVariableSet("glo3sl",glo3SL);
      GlobalVariableSet("glo3movesl",glo3moveSL);
      Alert("三位小数点时自动止盈止损参数已更新 请重新加载EA");
      Print("三位小数点时自动止盈止损参数已更新 请重新加载EA");
     }
   else
     {
      if(!GlobalVariableCheck("glo3tp"))
        {
         GlobalVariableSet("glo3tp",glo3TP);
         GlobalVariableSet("glo3sl",glo3SL);
         GlobalVariableSet("glo3movesl",glo3moveSL);
         Print("三位小数点时EA止盈止损初始化完成");
        }
     }
   if(glo2Digitsture)
     {
      GlobalVariableSet("glo2tp",glo2TP);
      GlobalVariableSet("glo2sl",glo2SL);
      GlobalVariableSet("glo2movesl",glo2moveSL);
      Alert("两位小数点时自动止盈止损参数已更新 请重新加载EA");
      Print("两位小数点时自动止盈止损参数已更新 请重新加载EA");
     }
   else
     {
      if(!GlobalVariableCheck("glo2tp"))
        {
         GlobalVariableSet("glo2tp",glo2TP);
         GlobalVariableSet("glo2sl",glo2SL);
         GlobalVariableSet("glo2movesl",glo2moveSL);
         Print("两位小数点时EA止盈止损初始化完成");
        }
     }
   if(Digits==5 && GlobalVariableCheck("glo5tp"))
     {
      stoploss=GlobalVariableGet("glo5sl");
      takeprofit=GlobalVariableGet("glo5tp");
      TrailingStop=GlobalVariableGet("glo5movesl");
     }
   if(Digits==3 && GlobalVariableCheck("glo3tp"))
     {
      if(Bid<800)
        {
         stoploss=GlobalVariableGet("glo3sl");
         takeprofit=GlobalVariableGet("glo3tp");
         TrailingStop=GlobalVariableGet("glo3movesl");//不是黄金相关的货币对
        }
      else
        {
         stoploss=GlobalVariableGet("glo3sl")*10;
         takeprofit=GlobalVariableGet("glo3tp")*10;
         TrailingStop=GlobalVariableGet("glo3movesl")*10;//是黄金相关的货币对止盈止损放大10倍
         linepianyi=linepianyi*10;//横线偏移放大10倍
         Print("3位小数点 是黄金相关的货币对止盈止损放大10倍");
        }
     }
   if(Digits==2 && GlobalVariableCheck("glo2tp"))
     {
      stoploss=GlobalVariableGet("glo2sl");
      takeprofit=GlobalVariableGet("glo2tp");
      TrailingStop=GlobalVariableGet("glo2movesl");
     }
   if(GlobalVariableCheck("gloTickmodetrue"))
     {
      if(Gradually)
        {
         Tickmode=true;
         Print("Tick分步平仓模式启用");
        }
      else
        {
         Print("Tick分步平仓模式关闭");
        }
     }
   else
     {
      if(Gradually)
        {
         Tickmode=false;
         Print("计时器分步平仓模式启用 ","每次平仓的仓位保留到 ",xiaoshudian," 位小数点");
        }
      else
        {
         Print("计时器分步平仓模式 关闭");
        }
     }
///////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(gloAccountEquityLowtrue)
     {
      GlobalVariableSet("gloAccountEquityLow",gloAccountEquityLow);
      Print("总净值低于",GlobalVariableGet("gloAccountEquityLow")," 全平仓 设置成功 请重新加载EA");
      comment1(StringFormat("总净值低于%G 全平仓 设置成功 请重新加载EA",GlobalVariableGet("gloAccountEquityLow")));
     }
   if(GlobalVariableCheck("gloAccountEquityLow"))
     {
      gloAccountEquityLow=GlobalVariableGet("gloAccountEquityLow");
     }
   if(gloAccountEquityHightrue)
     {
      GlobalVariableSet("gloAccountEquityHigh",gloAccountEquityHigh);
      Print("总净值高于",GlobalVariableGet("gloAccountEquityHigh")," 全平仓 设置成功 请重新加载EA");
      comment1(StringFormat("总净值高于%G 全平仓 设置成功 请重新加载EA",GlobalVariableGet("gloAccountEquityHigh")));
     }
   if(GlobalVariableCheck("gloAccountEquityHigh"))
     {
      gloAccountEquityHigh=GlobalVariableGet("gloAccountEquityHigh");
     }
   if(gloAccountProfitmintrue)
     {
      GlobalVariableSet("gloAccountProfitmin",gloAccountProfitmin);
      Print("总利润低于",GlobalVariableGet("gloAccountProfitmin")," 全平仓 设置成功 请重新加载EA");
      comment1(StringFormat("总利润低于%G 全平仓 设置成功 请重新加载EA",GlobalVariableGet("gloAccountProfitmin")));
     }
   if(GlobalVariableCheck("gloAccountProfitmin"))
     {
      gloAccountProfitmin=GlobalVariableGet("gloAccountProfitmin");
     }

////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(glolotsture)
     {
      GlobalVariableSet("glodefaultlots",defaultlots);
      Print("默认下单手数更新成功当前为",GlobalVariableGet("glodefaultlots"),"手 请重新加载EA");
      comment1(StringFormat("默认下单手数更新成功 当前为%G手 请重新加载EA",GlobalVariableGet("glodefaultlots")));
      if(ObjectFind("firstPS")==0)
         ObjectDelete("firstPS");
     }
   if(MarketInfo(Symbol(),MODE_TRADEALLOWED)==0)
      Print(Symbol()," 当前品种不允许交易");
   Print("EA默认可以直接带止损下单，如果无法下单请在 全局设置 里修改");
   /* //FXTM现在已经支持带止损下单了
     string ForexTime="ForexTime";
     if(ForexTime==StringSubstr(AccountServer(),0,9))
       {
        if(!GlobalVariableCheck("ForexTime"))
          {
           GlobalVariableSet(StringSubstr(AccountServer(),0,9),1);
           testtradeSLSP=false;
           Print("根据外汇服务器类型 EA已修改为不能直接带止损下单");
          }
        else
          {
           testtradeSLSP=false;
           Print("根据外汇服务器类型 EA已修改为不能直接带止损下单");
          }
       }
       */

   if(defaultlotstrue)
     {
      if(GlobalVariableCheck("glodefaultlots"))
        {
         defaultlots=GlobalVariableGet("glodefaultlots");
        }
      else
        {
         Alert("中更新适合您的基本下单手数 默认0.01手 此消息只提示一次");
         Alert("检测到您是第一次加载MT4持仓助手 请在 客户端全局函数设置");
         Print("检测到您是第一次加载MT4持仓助手 请在 客户端全局函数设置 中更新适合您的基本下单手数 默认0.01手 此消息只提示一次");
         //comment3("检测到您是第一次加载MT4持仓助手 请在 客户端全局函数设置 ");
         //comment4("中更新适合您的基本下单手数 默认0.01手 此消息只提示一次");
         if(ObjectFind("firstPS")!=-1)
            ObjectDelete("firstPS");
           {
            ObjectCreate(0,"firstPS",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"firstPS",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"firstPS",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"firstPS",OBJPROP_YDISTANCE,dingdanxianshiY+160);
            ObjectSetText("firstPS","请按F7 在最下面 客户端全局函数设置 中更新适合您的基本下单手数",16,"黑体",dingdanxianshicolor);
           }
         GlobalVariableSet("glodefaultlots",defaultlots);
         defaultlots=GlobalVariableGet("glodefaultlots");
        }
      if(minlot>defaultlots)
        {
         defaultlots=minlot;
         Print("EA默认下单手数小于当前货币最小下单手数 已修改为最小下单手数",defaultlots);
         comment5("EA默认下单手数小于当前货币最小下单手数 已修改为最小下单手数");
        }
      //Print("glodefaultlots ",GlobalVariableCheck("glodefaultlots"));
      keylots=defaultlots;
      Guadanlots=defaultlots;
      Guadanlots1=defaultlots;
      zhinengguadanlots=defaultlots;
      fibGuadanlots=defaultlots;
      tenGuadanlots=defaultlots;
      huaxianguadanlots=defaultlots;
      huaxiankaicanglotsT=defaultlots;
      //Print("keylots= ",keylots);
      Print("当前EA通过键盘快捷键下单的基本仓位是 ",defaultlots," 手 请 客户端全局函数设置 中更新为适合自己的仓位下单");
     }
   else
     {
      Print("当前EA通过键盘快捷键下单的基本仓位是 ",keylots," 手 请修改为适合自己的仓位下单");
     }
   Print("当前货币 停止水平位: ",StrToInteger(DoubleToStr(stoplevel,0)),"，账户杠杆比例: ",AccountLeverage(),":1","，买一手保证金 ",MarketInfo(Symbol(),MODE_MARGINREQUIRED),AccountCurrency(),", 多单隔夜利息: ",MarketInfo(Symbol(),MODE_SWAPLONG),",空单隔夜利息: ",MarketInfo(Symbol(),MODE_SWAPSHORT),swaptype());

   int level=AccountStopoutLevel();
   if(AccountStopoutMode()==0)
     {
      Print("强行平仓止损水平= ",level,"% ,",Digits(),"位小数点"",一手波动一个基点盈亏 ",DoubleToString(MarketInfo(Symbol(),MODE_TICKVALUE),2),AccountCurrency()," 最小下单手数",MarketInfo(Symbol(),MODE_MINLOT)," 改变手数的最小步长 改变交易手数时的最小间隔",MarketInfo(Symbol(),MODE_LOTSTEP),"  EAswitch= ",EAswitch);
     }
   else
     {
      Print("强行平仓止损水平= ",level," ",AccountCurrency());
     }
   keylotshalfT=MathFloor(keylots*0.5/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
   keylotshalf=keylots;
   if(Guadanprice<stoplevel)
      Guadanprice=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(Guadanjuxianjia<stoplevel)
      Guadanjuxianjia=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(Guadanjuxianjia1<stoplevel)
      Guadanjuxianjia1=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(zhinengSLTP1<stoplevel)
      zhinengSLTP1=stoplevel+2;
   if(EAswitch)
     {
      Print("当前图表",Digits,"位小数点"," EA自动设置止盈",takeprofit,"点 ","止损",stoploss,"点 ","移动止损",TrailingStop,"点");
      comment(StringFormat("%G位小数点 止盈%G点 止损%G点 移动止损%G点 默认下单仓位%G手",Digits,takeprofit,stoploss,TrailingStop,defaultlots));
      /*if(Digits==3 || Digits==2)
        {
         Gradually=false;
         Print("分步平仓模式已关闭");
         comment1(StringFormat("%G位小数点 分步平仓没调试好 暂时关闭",Digits));
        }*/
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)//tuichu
  {
   ObjectsDeleteAll(0, pre);//删除鼠标 按钮相关 所有包含此物件前缀名的对象
   if(ObjectFind(0,"buy")==0)
      ObjectDelete(0,"buy");
   if(ObjectFind(0,"sell")==0)
      ObjectDelete(0,"sell");
   if(ObjectFind(0,"buysell")==0)
      ObjectDelete(0,"buysell");
   if(ObjectFind(0,"AccountEquity")==0)
      ObjectDelete(0,"AccountEquity");
   if(ObjectFind(0,"AccountFreeMargin")==0)
      ObjectDelete(0,"AccountFreeMargin");
   if(ObjectFind(0,"zi")==0)
      ObjectDelete(0,"zi");
   if(ObjectFind(0,"zi1")==0)
      ObjectDelete(0,"zi1");
   if(ObjectFind(0,"zi2")==0)
      ObjectDelete(0,"zi2");
   if(ObjectFind(0,"zi3")==0)
      ObjectDelete(0,"zi3");
   if(ObjectFind(0,"zi4")==0)
      ObjectDelete(0,"zi4");
   if(ObjectFind(0,"zi5")==0)
      ObjectDelete(0,"zi5");
   if(ObjectFind(0,"ziR1")==0)
      ObjectDelete(0,"ziR1");
   if(ObjectFind(0,"botoupi")==0)
      ObjectDelete(0,"botoupi");
   if(ObjectFind(0,"zonglirun")==0)
      ObjectDelete(0,"zonglirun");
   if(ObjectFind(0,"zonglirun1")==0)
      ObjectDelete(0,"zonglirun1");
   if(ObjectFind(0,"firstPS")==0)
      ObjectDelete(0,"firstPS");
   if(ObjectFind(0,"Buy Line")==0)
      ObjectDelete(0,"Buy Line");
   if(ObjectFind(0,"Sell Line")==0)
      ObjectDelete(0,"Sell Line");
   if(ObjectFind(0,"SL Line")==0)
      ObjectDelete(0,"SL Line");
   if(ObjectFind(TPObjName)>=0)
      ObjectDelete(TPObjName);//反初始化。删除线
   if(ObjectFind(SLObjName)>=0)
      ObjectDelete(SLObjName);
   if(ObjectFind(TP_PRICE_LINE)>=0)
      ObjectDelete(TP_PRICE_LINE);
   if(ObjectFind(SL_PRICE_LINE)>=0)
      ObjectDelete(SL_PRICE_LINE);
   if(ObjectFind(0,"SL1mbuyLine")==0)
      ObjectDelete(0,"SL1mbuyLine");
   if(ObjectFind(0,"SL5mbuyLine")==0)
      ObjectDelete(0,"SL5mbuyLine");
   if(ObjectFind(0,"SL15mbuyLine")==0)
      ObjectDelete(0,"SL15mbuyLine");
   if(ObjectFind(0,"SL1msellLine")==0)
      ObjectDelete(0,"SL1msellLine");
   if(ObjectFind(0,"SL5msellLine")==0)
      ObjectDelete(0,"SL5msellLine");
   if(ObjectFind(0,"SL15msellLine")==0)
      ObjectDelete(0,"SL15msellLine");
   if(ObjectFind(0,"SLsellQpengcangline")==0)
      ObjectDelete(0,"SLsellQpengcangline");
   if(ObjectFind(0,"SLbuyQpengcangline")==0)
      ObjectDelete(0,"SLbuyQpengcangline");
   if(ObjectFind(0,"SLsellQpengcangline1")==0)
      ObjectDelete(0,"SLsellQpengcangline1");
   if(ObjectFind(0,"SLbuyQpengcangline1")==0)
      ObjectDelete(0,"SLbuyQpengcangline1");
   if(ObjectFind(0,"iBSTrend")==0)
      ObjectDelete(0,"iBSTrend");
   if(ObjectFind(0,"MBFX")==0)
      ObjectDelete(0,"MBFX");
   if(ObjectFind(0,"iBreakout")==0)
      ObjectDelete(0,"iBreakout");
   if(ObjectFind(0,"iBreakoutfanshou")==0)
      ObjectDelete(0,"iBreakoutfanshou");

   ObjectDelete(0,"fang1");
   ObjectDelete(0,"fang2");
   ObjectDelete(0,"fang3");
   ObjectDelete(0,"fang4");
   ObjectDelete(0,"fang5");
   ObjectDelete(0,"fang6");
   ObjectDelete(0,"fang3Low");
   ObjectDelete(0,"fang6High");
   ObjectDelete(0,"l1");
   ObjectDelete(0,"l2");
   ObjectDelete(0,"l3");
   ObjectDelete(0,"l4");
   ObjectDelete(0,"l5");
   ObjectDelete(0,"l6");

   ObjectDelete(0,"dxzdBuyi2kSL");
   ObjectDelete(0,"dxzdBuyi3kSL");
   ObjectDelete(0,"dxzdBuyi4kSL");
   ObjectDelete(0,"dxzdBuyi5kSL");
   ObjectDelete(0,"dxzdSelli2kSL");
   ObjectDelete(0,"dxzdSelli3kSL");
   ObjectDelete(0,"dxzdSelli4kSL");
   ObjectDelete(0,"dxzdSelli5kSL");

   ObjectDelete(0,"dxzdBuyi2kSL1");
   ObjectDelete(0,"dxzdBuyi3kSL1");
   ObjectDelete(0,"dxzdBuyi4kSL1");
   ObjectDelete(0,"dxzdBuyi5kSL1");
   ObjectDelete(0,"dxzdSelli2kSL1");
   ObjectDelete(0,"dxzdSelli3kSL1");
   ObjectDelete(0,"dxzdSelli4kSL1");
   ObjectDelete(0,"dxzdSelli5kSL1");

   ObjectDelete(0,"dxzdBuyLineC");
   ObjectDelete(0,"dxzdBuyLineO");
   ObjectDelete(0,"dxzdBuyLineL");
   ObjectDelete(0,"dxzdSellLineC");
   ObjectDelete(0,"dxzdSellLineO");
   ObjectDelete(0,"dxzdSellLineH");

   ObjectDelete(0,"znBuy5mSL1");
   ObjectDelete(0,"znBuy5mSL2");
   ObjectDelete(0,"znBuy5mSL3");
   ObjectDelete(0,"znBuy15mSL1");
   ObjectDelete(0,"znBuy15mSL2");
   ObjectDelete(0,"znBuy15mSL3");
   ObjectDelete(0,"znSell5mSL1");
   ObjectDelete(0,"znSell5mSL2");
   ObjectDelete(0,"znSell5mSL3");
   ObjectDelete(0,"znSell15mSL1");
   ObjectDelete(0,"znSell15mSL2");
   ObjectDelete(0,"znSell15mSL3");

   ObjectDelete(0,"zhendangR1");
   ObjectDelete(0,"zhendangR2");
   ObjectDelete(0,"zhendangR3");
   ObjectDelete(0,"zhendangR4");
   ObjectDelete(0,"mbfxR1");
   ObjectDelete(0,"mbfxR2");
   ObjectDelete(0,"ATR1");
   ObjectDelete(0,"mbfxR3");
   ObjectDelete(0,"mbfxR4");
   ObjectDelete(0,"BuySL1");
   ObjectDelete(0,"SellSL1");
   ObjectDelete(0,"BuySL2");
   ObjectDelete(0,"SellSL2");
   ObjectDelete(0,"TimeLine1");
   ObjectDelete(0,"BuyTrendLineSL1");
   ObjectDelete(0,"SellTrendLineSL1");
   ObjectDelete(0,"BuyTrendLineSL2");
   ObjectDelete(0,"SellTrendLineSL2");
   ObjectDelete(0,"BuyTrendLineSL3");
   ObjectDelete(0,"SellTrendLineSL3");
   ObjectDelete(0,"BuyStop1");
   ObjectDelete(0,"SellStop1");
   ObjectDelete(0,"2kbuySL1");
   ObjectDelete(0,"2ksellSL1");

   Comment("");
   EventKillTimer();
   GlobalVariablesFlush();//强制保存所有的全局变量到硬盘
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {

/////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
   OnChartEvent2(id, lparam, dparam, sparam);
///////////////////////////////////////////////////////////
   if(id==CHARTEVENT_KEYDOWN && keycode)//检测键盘动作，触发指令 搜索定位 KEYDOWN anjian
     {
      //Print(sparam);
      if(StrToInteger(sparam)==29 || StrToInteger(sparam)==16413)
        {
         ctrl=true;
         ctrltimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==285|| StrToInteger(sparam)==16669)
        {
         ctrlR=true;
         ctrlRtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==42 || StrToInteger(sparam)==16426)
        {
         shift=true;
         shifttimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==310 || StrToInteger(sparam)==16694 || StrToInteger(sparam)==54)
        {
         shiftR=true;
         shiftRtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==15 || StrToInteger(sparam)==16399)
        {
         tab=true;
         tabtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==48 || StrToInteger(sparam)==16432)
        {
         bkey=true;
         btimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==31 || StrToInteger(sparam)==16415)
        {
         skey=true;
         stimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==45 || StrToInteger(sparam)==16429)
        {
         xkey=true;
         xtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==25 || StrToInteger(sparam)==16409)
        {
         pkey=true;
         ptimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==38 || StrToInteger(sparam)==16422)
        {
         lkey=true;
         ltimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==20 || StrToInteger(sparam)==16404)
        {
         tkey=true;
         ttimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==30 || StrToInteger(sparam)==16414)
        {
         akey=true;
         atimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==44 || StrToInteger(sparam)==16428)
        {
         zkey=true;
         ztimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==34 || StrToInteger(sparam)==16418)
        {
         gkey=true;
         gtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==24 || StrToInteger(sparam)==16408)
        {
         okey=true;
         otimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==37 || StrToInteger(sparam)==16421)
        {
         kkey=true;
         ktimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==47 || StrToInteger(sparam)==16431)
        {
         vkey=true;
         vtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==33 || StrToInteger(sparam)==16417)
        {
         fkey=true;
         ftimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==32 || StrToInteger(sparam)==16416)
        {
         dkey=true;
         dtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==50 || StrToInteger(sparam)==16434)
        {
         mkey=true;
         mtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==49 || StrToInteger(sparam)==16433)
        {
         nkey=true;
         ntimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==23 || StrToInteger(sparam)==16407)
        {
         ikey=true;
         itimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==35 || StrToInteger(sparam)==16419)
        {
         hkey=true;
         htimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==21 || StrToInteger(sparam)==16405)
        {
         ykey=true;
         ytimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==41 || StrToInteger(sparam)==16425)//Test
        {
         // PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRRpianyi*Point,Digits),0,0,0,dingdanshu);
         //PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRRpianyi*Point,Digits),0,0,0,dingdanshu);
         Print("dingdanshu,2,3,4= ",dingdanshu," ",dingdanshu2," ",dingdanshu3," ",dingdanshu4," mbfxSleeptime=",mbfxSleeptime," mbfxSleep=",mbfxSleep);
         Print("buyline= ",buyline," buylineOnTimer= ",buylineOnTimer," sellline=",sellline," selllineOnTimer=",selllineOnTimer," slline",slline);
         Print("EA开关= ",EAswitch," 自动分批平仓= ",Gradually," 盈利后追踪止损= ",AutoTrailingStop," fansuoYes=",fansuoYes," yinyang5mkaicang=",yinyang5mkaicang," yinyang5mkaicang1=",yinyang5mkaicang1," 最近一次的错误代码 ",error());
         // Print("盈利后追踪止损= ",AutoTrailingStop);
         //Print("EA开关= ",EAswitch);
         Print("fansuoYes= ",fansuoYes," linebuypingcang=",linebuypingcang," linesellpingcang=",linesellpingcang," linebuykaicang=",linebuykaicang," linesellkaicang=",linesellkaicang," linekaicangctrl=",linekaicangctrl," linelock= ",linelock," yijianFanshou= ",yijianFanshou," breakoutNot=",breakoutNot," yiyang5mpingcangshiti=",yiyang5mpingcangshiti," yiyang5mpingcangshiti1=",yiyang5mpingcangshiti);
         //Print("yijianFanshou= ",yijianFanshou);
         nakey=true;
         natimeCurrent=TimeCurrent();
         //Print("测试专用");
         // Print("MODE_SPREAD ",MarketInfo(Symbol(),MODE_SPREAD));
         Print("MODE_LOTSTEP ",MarketInfo(Symbol(),MODE_LOTSTEP)," MODE_SPREAD ",MarketInfo(Symbol(),MODE_SPREAD)," MODE_MINLOT ",MarketInfo(Symbol(),MODE_MINLOT));
         //Print("MODE_MINLOT ",MarketInfo(Symbol(),MODE_MINLOT));
         // Print("Ask ",MarketInfo(Symbol(),MODE_ASK));
         //Print("Bid ",MarketInfo(Symbol(),MODE_BID));
         Print("GetLastError=",GetLastError()," Bid= ",MarketInfo(Symbol(),MODE_BID)," Ask= ",MarketInfo(Symbol(),MODE_ASK)," 多单均价= ",HoldingOrderbuyAvgPrice()," 空单均价= ",HoldingOrdersellAvgPrice());
         shifttimeCurrent=D'1970.01.01 00:00:00';//清除Shift按键时间
         SL5QTPtimeCurrenttrue=false;//剥头皮定时处理订单关闭
         //Print("剥头皮定时处理订单关闭");
         //comment("剥头皮定时处理订单关闭");
         //Print("多单均价= ",HoldingOrderbuyAvgPrice()," 空单均价= ",HoldingOrdersellAvgPrice());
         comment1(StringFormat("多单均价= %G 空单均价= %G",HoldingOrderbuyAvgPrice(),HoldingOrdersellAvgPrice()));
         // Print("空单均价= ",HoldingOrdersellAvgPrice());
         // comment2(StringFormat("",HoldingOrdersellAvgPrice()));
         // Print("linelock= ",linelock);
         //  Print("0.0=",MathRound(0.0));
         // double bid=StrToDouble(DoubleToString(1.2498,3));

         //double bid1=NormalizeDouble(bid,3);
         // Print("bid",bid," Digits",Digits);
         //Tenguadan(false,3,30);
         //Fibguadan(0,1.2400,1.2500);
         //Fibguadan(1,1.25000,1.26000);
         if(kaiguan01)
           {
            kaiguan01=false;
            comment3("标识高低位 划趋势线 关闭");
            ObjectDelete("fang1");
            ObjectDelete("fang2");
            ObjectDelete("fang3");
            ObjectDelete("fang4");
            ObjectDelete("fang5");
            ObjectDelete("fang6");
            ObjectDelete("fang3Low");
            ObjectDelete("fang6High");
            ObjectDelete("l1");
            ObjectDelete("l2");
            ObjectDelete("l3");
            ObjectDelete("l4");
            ObjectDelete("l5");
            ObjectDelete("l6");
           }
         else
           {
            kaiguan01=true;
            comment3("标识高低位 划趋势线  启动");
           }

         if(ObjectFind(0,"Buy Line")==0)
           {
            buyline=NormalizeDouble(ObjectGet("Buy Line",1),Digits);   //定时更新横线的价格
            buylineOnTimer=Ask;
           }
         if(ObjectFind(0,"Sell Line")==0)
           {
            sellline=NormalizeDouble(ObjectGet("Sell Line",1),Digits);   //定时更新横线的价格
            selllineOnTimer=Bid;
           }
        }

      if(StrToInteger(sparam)==327)//home 按键
        {
         Print("home");
         comment("home");
        }
      if(StrToInteger(sparam)==329)//Page Up 按键  结合VPS 手机链接到VPS 手机上使用软件里的键盘 市价买一单
        {
         Print("市价买一单 处理中 . . .");
         comment("      市价买一单 处理中 . . .");
         int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
           {
            PlaySound("ok.wav");
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         return;
        }
      if(StrToInteger(sparam)==349)//手机上使用软件里的键盘 鼠标右键的图标 结合VPS 手机链接到VPS 手机上使用软件里的键盘 市价卖一单
        {
         Print("市价卖一单 处理中 . . .");
         comment("     市价卖一单 处理中 . . .");
         int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
         if(keysell>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         return;
        }
      ////////////////////////////////////////////////////
      if(StrToInteger(sparam)==70)
        {
         Print("平最近下的一单 处理中 . . .");
         comment("平最近下的一单 处理中 . . .");
         zuijinkeyclose();
        }
      if(StrToInteger(sparam)==piliangSLTP)
        {
         if(tabtimeCurrent+1>=TimeCurrent() && tab==true)
           {
            Gradually=false;
            Print("默认批量设置止盈止损5000点 变相取消 仅应急使用  处理中 . . .");
            comment("默认批量设置止盈止损5000点 变相取消 仅应急使用  处理中 . . .");
            StopLoss=5000;
            TargetProfit=5000;
            piliangsltp();
            tab=false;
            StopLoss=0;
            TargetProfit=0;
            FixedStopLoss=0.0;
            FixedTargetProfit=0.0;
            return;
           }
         else
           {
            tab=false;
           }
        }
      if(StrToInteger(sparam)==63)// F5 功能键
        {
         if(ObjectFind(0,"zi4")==0)
           {
            f5lots=CGetbuyLots();
            if(f5lots==0.0)
              {
               f5lots=CGetsellLots();
              }
            Print("更新为当前的仓位 ",f5lots," 手 Tab+ 9 6 开仓");
            comment4(StringFormat("更新为当前的仓位 %G 手 Tab+ 9 6 开仓",f5lots));
            return;
           }
         else
           {
            Print("最后一次保存的仓位 ",f5lots,"手  再按更新为当前的仓位");
            comment4(StringFormat("最后一次保存的仓位 %G 手 再按更新为当前的仓位",f5lots));
            return;
           }
        }
      if(StrToInteger(sparam)==suoCang)
        {

         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("一键锁仓 处理中 . . .");
            comment("一键锁仓 处理中 . . .");
            suocang();
            shift=false;
            return;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==fanxiangSuodan)
        {
         if(ctrltimeCurrent+1>=TimeCurrent() && ctrl==true)
           {
            Print("开反向单锁仓 处理中 . . .");
            comment("开反向单锁仓 处理中 . . .");
            fanxiangsuodan();
            monianjian(15);
            monianjian(1);
            ctrl=false;
            return;
           }
         else
            ctrl=false;
        }
      if(Testsparam)
         Print(" sparam的值 ",sparam," lparam的值 ",lparam," dparam的 值",dparam);//测试键盘按钮状态的位掩码的字符串值,方便自定义快捷键，组合键Ctrl+Alt+字母或数字也有自己的sparam的值，所以也可以使用。
      int Sparam=StrToInteger(sparam);
      switch(Sparam)
        {
         case 8219://开启笔记本下单按键 Ctrl+Alt+ } 开启
           {
            if(notebook)
              {
               notebook=false;
               Print("笔记本下单按键关闭");
               comment("笔记本下单按键关闭");
              }
            else
              {
               notebook=true;
               Print("笔记本下单按键开启buy或sell是P或L键右边第二个键");
               comment("笔记本下单按键开启buy或sell是P或L键右边第二个键");
              }
           }
         break;
         case 27:
           {
            if(notebook)
              {
               Print("市价买一单 处理中 . . .");
               comment("市价买一单 处理中 . . .");
               int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy>0)
                 {
                  PlaySound("ok.wav");
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               Print("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
               comment("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
              }
           }
         break;
         case 40:
           {
            if(notebook)
              {
               Print("市价卖一单 处理中 . . .");
               comment("市价卖一单 处理中 . . .");
               int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell>0)
                  PlaySound("ok.wav");
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               Print("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
               comment("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
              }
           }
         break;
         case 1://Esc jian
           {
            if(!ObjectFind(0,"onamezhegai")==0)
              {
               Draw_zhegai();
               menu4[1]=true;
               comment4("遮盖当前未收盘K线 以减少波动对行情的判断 ");
              }
            else
              {
               ObjectDelete(0,"onamezhegai");
               menu4[1]=false;
               comment4("遮盖当前未收盘K线 取消 ");
              }
           }
         break;
         case 328://方向键 上键 shang jian
           {
            if(shangtimeGMT+10>=TimeGMT())
              {
               shangpress++;
               Print("方向键 上键按下次数+1  上键按下次数",shangpress);
               comment(StringFormat("方向键上键 按下次数+1 当前按下次数%G ",shangpress));
              }
            else
              {
               shangpress=1;
               Print("计时器10秒已过 方向键上键计数重置  上键按下次数",shangpress);
               comment(StringFormat("计时器10秒已过 方向键上键计数重置 当前按下次数%G ",shangpress));
              }
            shangtimeGMT=TimeGMT();
           }
         break;
         case 336://方向键 下键
           {
            if(xiatimeGMT+10>=TimeGMT())
              {
               xiapress++;
               Print("方向键 下键按下次数+1 当前方向键 下键按下次数",xiapress);
               comment(StringFormat("方向键下键 按下次数+1 当前按下次数%G ",xiapress));
              }
            else
              {
               xiapress=1;
               Print("计时器10秒已过 方向键下键计数重置 当前方向键 下键按下次数",xiapress);
               comment(StringFormat("计时器10秒已过 方向键下键计数重置 当前按下次数%G ",xiapress));
              }
            xiatimeGMT=TimeGMT();
           }
         break;
         case 331://方向键 左键
           {
            if(shangtimeGMT+10>=TimeGMT())
              {
               leftpress++;
               Print("方向键 左键按下次数+1 当前方向键 左键按下次数",leftpress);
               comment(StringFormat("方向键左键《== 按下次数+1 当前按下次数%G ",leftpress));
              }
            else
              {
               leftpress=1;
               Print("计时器10秒已过 方向键左键计数重置 当前方向键 左键按下次数",leftpress);
               comment(StringFormat("计时器10秒已过 方向键左键计数重置 当前按下次数%G ",leftpress));
              }
            shangtimeGMT=TimeGMT();
           }
         break;
         case 333://方向键 右键
           {
            if(xiatimeGMT+10>=TimeGMT())
              {
               rightpress++;
               Print("方向键 右键按下次数+1 当前方向键 右键按下次数",rightpress);
               comment(StringFormat("方向键右键 ==》 按下次数+1 当前按下次数%G ",rightpress));
              }
            else
              {
               rightpress=1;
               Print("计时器10秒已过 方向键右键计数重置 当前方向键 下键按下次数",rightpress);
               comment(StringFormat("计时器10秒已过 方向键右键计数重置 当前按下次数%G ",rightpress));
              }
            xiatimeGMT=TimeGMT();
           }
         break;
         case 2://主键盘1 1111 1 j
           {
            if(htimeCurrent+5>=TimeCurrent() && linelock==true)
              {
               if(hengxianAi1==false && hengxianAi1a==false)//
                 {
                  hengxianAi1=true;
                  hengxianAi1a=false;
                  hengxianAi1bullpianyi=(shangpress-xiapress)*pianyilingGlo;
                  Print("距离布林带上下偏移多少 ",hengxianAi1bullpianyi);
                  Print("横线模式下根据布林带上下轨位置 移动横线 开启");
                  comment1("横线模式下根据布林带上下轨位置 移动横线 开启");
                  return;
                 }
               else
                 {
                  if(hengxianAi1a==false)
                    {
                     hengxianAi1a=true;
                     hengxianAi1=false;
                     hengxianAi1bullpianyi=(shangpress-xiapress)*pianyilingGlo;
                     Print("距离布林带上下偏移多少 ",hengxianAi1bullpianyi);
                     Print("横线模式下根据布林带中轨位置 移动横线 开启");
                     comment1("横线模式下根据布林带中轨位置 移动横线 开启");
                     return;
                    }
                  else
                    {
                     hengxianAi1a=false;
                     hengxianAi1=false;
                     Print("横线模式下根据布林带位置 移动横线  关闭");
                     comment1("横线模式下根据布林带位置 移动横线 关闭");
                     return;
                    }
                 }
              }
            if(itimeCurrent+3>=TimeCurrent())
              {
               if(imbfxT==false)
                 {
                  imbfxT=true;
                  Print("当前图表参考MBFX指标 自动平仓 开启");
                  comment1("当前图表参考MBFX指标 自动平仓 开启");
                  return;
                 }
               else
                 {
                  imbfxT=false;
                  Print("当前图表参考MBFX指标 自动平仓 关闭");
                  comment1("当前图表参考MBFX指标 自动平仓 关闭");
                  return;
                 }
              }
            if(mtimeCurrent+3>=TimeCurrent())
              {
               if(breakoutNot==false)
                 {
                  breakoutNot=true;
                  breakoutNot1=true;
                  Print("当前图表参考Breakout指标 突破提醒 开启");
                  comment1("当前图表参考Breakout指标 突破提醒 开启");
                  return;
                 }
               else
                 {
                  breakoutNot=false;
                  breakoutNot1=false;
                  Print("当前图表参考Breakout指标 突破提醒 关闭");
                  comment1("当前图表参考Breakout指标 突破提醒 关闭");
                  return;
                 }
              }
            if(tabtimeCurrent+3>=TimeCurrent() && tab==true)
              {
               if(huaxianguadan)
                 {
                  huaxianguadan=false;
                  if(ObjectFind(TPObjName)>=0)
                     ObjectDelete(TPObjName);
                  if(ObjectFind(SLObjName)>=0)
                     ObjectDelete(SLObjName);
                  if(ObjectFind(TP_PRICE_LINE)>=0)
                     ObjectDelete(TP_PRICE_LINE);
                  if(ObjectFind(SL_PRICE_LINE)>=0)
                     ObjectDelete(SL_PRICE_LINE);
                  Print("划线挂单模式关闭");
                  comment1("划线挂单模式关闭");
                 }
               else
                 {
                  huaxianguadan=true;
                  huaxianSwitch=false;
                  huaxiankaicang=false;
                  Print("触及划线挂单模式开启需要至少一个订单指引挂单方向");
                  comment1("触及划线挂单模式开启需要至少一个订单指引挂单方向");
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(10*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(10*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(10*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(10*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=1;
            dingdanshu1=1;
            dingdanshu2=1;
            dingdanshu3=1;
            dingdanshu4=1;
            guadangeshu=1;
            comment("主键盘数字键1 只处理最近下的一单 本提示消失按键失效");
           }
         break;
         case 3://主键盘2 2222 2 j
           {
            if(mtimeCurrent+3>=TimeCurrent())
              {
               if(menu4[0]==false)
                 {
                  menu4[0]=true;
                  Print("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 开启");
                  comment1("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 开启");
                  return;
                 }
               else
                 {
                  menu4[0]=false;
                  Print("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 关闭");
                  comment1("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 关闭");
                  return;
                 }
              }
            if(itimeCurrent+1>=TimeCurrent())
              {
               if(iBSTrend==false)
                 {
                  iBSTrend=true;
                  Print("当前图表参考BSTrend指标 自动平仓 开启");
                  comment1("当前图表参考BSTrend指标 自动平仓 开启");
                  return;
                 }
               else
                 {
                  iBSTrend=false;
                  Print("当前图表参考BSTrend指标 自动平仓 关闭");
                  comment1("当前图表参考BSTrend指标 自动平仓 关闭");
                  return;
                 }
              }
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(huaxiankaicang)
                 {
                  huaxiankaicang=false;
                  if(ObjectFind(TPObjName)>=0)
                     ObjectDelete(TPObjName);
                  if(ObjectFind(SLObjName)>=0)
                     ObjectDelete(SLObjName);
                  if(ObjectFind(TP_PRICE_LINE)>=0)
                     ObjectDelete(TP_PRICE_LINE);
                  if(ObjectFind(SL_PRICE_LINE)>=0)
                     ObjectDelete(SL_PRICE_LINE);
                  Print("触及划线直接开仓模式关闭");
                  comment1("触及划线直接开仓模式关闭");
                 }
               else
                 {
                  huaxiankaicang=true;
                  huaxianSwitch=false;
                  huaxianguadan=false;
                  Print("触及划线直接开仓模式开启 需要至少一个订单指引开仓方向");
                  comment1("触及划线直接开仓模式开启 需要至少一个订单指引开仓方向");
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(20*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(20*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(20*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(20*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=2;
            dingdanshu1=2;
            dingdanshu2=2;
            dingdanshu3=2;
            dingdanshu4=2;
            guadangeshu=2;
            comment("主键盘数字键 2 只处理最近下的两单 本提示消失按键失效");
           }
         break;
         case 4://主键盘3 3333
           {
            if(itimeCurrent+3>=TimeCurrent())//
              {
               if(ftimeCurrent+3>=TimeCurrent())
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(iBreakoutfanshou==false)
                       {
                        iBreakoutfanshou=true;
                        iBreakoutfanshou15=true;
                        Print("参考15分钟图表Breakout指标 全平后反手开仓 开启");
                        comment1("参考15分钟图表Breakout指标 全平后反手开仓 开启");
                        return;
                       }
                     else
                       {
                        iBreakoutfanshou=false;
                        iBreakoutfanshou15=false;
                        Print("参考15分钟图表Breakout指标 全平后反手开仓 关闭");
                        comment1("参考15分钟图表Breakout指标 全平后反手开仓 关闭");
                        return;
                       }
                    }
                  else
                    {
                     if(iBreakoutfanshou==false)
                       {
                        iBreakoutfanshou=true;
                        iBreakoutfanshou15=false;
                        Print("当前图表参考Breakout指标 全平后反手开仓 开启");
                        comment1("当前图表参考Breakout指标 全平后反手开仓 开启");
                        return;
                       }
                     else
                       {
                        iBreakoutfanshou=false;
                        iBreakoutfanshou15=false;
                        Print("当前图表参考Breakout指标 全平后反手开仓 关闭");
                        comment1("当前图表参考Breakout指标 全平后反手开仓 关闭");
                        return;
                       }
                    }
                 }
               else
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(iBreakout==false)
                       {
                        iBreakout=true;
                        iBreakout15=true;
                        Print("参考15分钟图表Breakout指标 自动平仓 开启");
                        comment1("参考15分钟图表Breakout指标 自动平仓 开启");
                        return;
                       }
                     else
                       {
                        iBreakout=false;
                        iBreakout15=false;
                        Print("参考15分钟图表Breakout指标 自动平仓 关闭");
                        comment1("参考15分钟图表Breakout指标 自动平仓 关闭");
                        return;
                       }
                    }
                  else
                    {
                     if(ktimeCurrent+5>=TimeCurrent())
                       {
                        if(iBreakoutkaicangbuy==false)
                          {
                           if(iBreakoutkaicangsell==true)
                             {
                              iBreakoutkaicangsell=false;
                              iBreakoutkaicangbuy=false;
                              Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
                              comment1("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
                              return;
                             }
                           else
                             {
                              iBreakoutkaicangbuy=true;
                              iBreakoutkaicangsell=false;
                              iBreakout=false;
                              iBreakout15=false;
                              iBreakoutfanshou=false;
                              iBreakoutfanshou15=false;
                              Print("当前图表参考Breakout指标矩形横线位置启动横线模式Buy单开仓 开启");
                              comment1("当前图表参考Breakout指标矩形横线位置启动横线模式Buy单开仓 开启");
                              return;
                             }

                          }
                        else
                          {
                           if(iBreakoutkaicangsell==false)
                             {
                              iBreakoutkaicangsell=true;
                              iBreakoutkaicangbuy=false;
                              iBreakout=false;
                              iBreakout15=false;
                              iBreakoutfanshou=false;
                              iBreakoutfanshou15=false;
                              Print("当前图表参考Breakout指标矩形横线位置启动横线模式sell单开仓 开启");
                              comment1("当前图表参考Breakout指标矩形横线位置启动横线模式sell单开仓 开启");
                              return;
                             }
                          }
                       }
                     else
                       {
                        if(iBreakout==false)
                          {
                           iBreakout=true;
                           iBreakout15=false;
                           iBreakoutfanshou=false;
                           iBreakoutfanshou15=false;
                           Print("当前图表参考Breakout指标 自动平仓 开启");
                           comment1("当前图表参考Breakout指标 自动平仓 开启");
                           return;
                          }
                        else
                          {
                           iBreakout=false;
                           iBreakout15=false;
                           iBreakoutfanshou=false;
                           iBreakoutfanshou15=false;
                           iBreakoutkaicangbuy=false;
                           iBreakoutkaicangsell=false;
                           Print("当前图表参考Breakout指标 自动平仓 关闭");
                           Print("当前图表参考Breakout指标 全平后反手开仓 关闭");
                           Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
                           comment1("当前图表参考Breakout指标 功能 关闭");
                           return;
                          }
                       }
                    }
                 }

              }
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo3)
                 {
                  if(btimeCurrent+3>=TimeCurrent())
                    {
                     timeGMTYesNo3=true;
                     buytrue03=true;
                     Print("定时器3开启 定时批量智能移动止损位 只处理buy单");
                     comment1("定时器3开启 定时批量智能移动止损位 只处理buy单");
                     return;
                    }
                  else
                    {
                     if(stimeCurrent+3>=TimeCurrent())
                       {
                        timeGMTYesNo3=true;
                        buytrue03=false;
                        Print("定时器3开启 定时批量智能移动止损位 只处理sell单");
                        comment1("定时器3开启 定时批量智能移动止损位 只处理sell单");
                        return;
                       }
                     else
                       {
                        Print("未检测到按下B或S键 定时器启用需要在按Tab键前先选择处理的订单类型 buy单按B sell单按S");
                        comment1("定时器启动失败 按Tab键前先选择订单类型buy单按B sell单按S");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo3=false;
                  buytrue03=true;
                  timebuyprice=0.0;
                  timesellprice=10000.0;
                  Print("定时器3关闭");
                  comment1("定时器3关闭");
                 }
               tab=false;
               bkey=false;
               skey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(30*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(30*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(30*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(30*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=3;
            dingdanshu1=3;
            dingdanshu2=3;
            dingdanshu3=3;
            dingdanshu4=3;
            guadangeshu=3;
            comment("主键盘数字键 3 只处理最近下的三单 本提示消失按键失效");
           }
         break;
         case 5://主键盘4
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo4)
                 {
                  if(btimeCurrent+3>=TimeCurrent())
                    {
                     timeGMTYesNo4=true;
                     buytrue04=true;
                     Print("定时器4开启 定时批量智能移动止盈位 只处理buy单");
                     comment1("定时器4开启 定时批量智能移动止盈位 只处理buy单");
                     return;
                    }
                  else
                    {
                     if(stimeCurrent+3>=TimeCurrent())
                       {
                        timeGMTYesNo4=true;
                        buytrue04=false;
                        Print("定时器4开启 定时批量智能移动止盈位 只处理sell单");
                        comment1("定时器4开启 定时批量智能移动止盈位 只处理sell单");
                        return;
                       }
                     else
                       {
                        Print("未检测到按下B或S键 定时器启用需要在按Tab键前先选择处理的订单类型 buy单按B sell单按S");
                        comment1("定时器启动失败 按Tab键前先选择订单类型buy单按B sell单按S");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo4=false;
                  buytrue04=true;
                  Print("定时器4关闭");
                  comment1("定时器4关闭");
                 }
               tab=false;
               bkey=false;
               skey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(40*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(40*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(40*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(40*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=4;
            dingdanshu1=4;
            dingdanshu2=4;
            dingdanshu3=4;
            dingdanshu4=4;
            guadangeshu=4;
            comment("主键盘数字键 4 本提示消失按键失效");
           }
         break;
         case 6://主键盘5
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo5)
                 {
                  if(btimeCurrent+3>=TimeCurrent())
                    {
                     timeGMTYesNo5=true;
                     buytrue05=true;
                     Print("定时器5开启 定时批量智能移动止损位 只处理buy单");
                     comment1("定时器5开启 定时批量智能移动止损位 只处理buy单");
                     return;
                    }
                  else
                    {
                     if(stimeCurrent+3>=TimeCurrent())
                       {
                        timeGMTYesNo5=true;
                        buytrue05=false;
                        Print("定时器5开启 定时批量智能移动止损位 只处理sell单");
                        comment1("定时器5开启 定时批量智能移动止损位 只处理sell单");
                        return;
                       }
                     else
                       {
                        Print("未检测到按下B或S键 定时器启用需要在按Tab键前先选择处理的订单类型 buy单按B sell单按S");
                        comment1("定时器启动失败 按Tab键前先选择订单类型buy单按B sell单按S");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo5=false;
                  buytrue05=true;
                  Print("定时器5关闭");
                  comment1("定时器5关闭");
                 }
               tab=false;
               bkey=false;
               skey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(50*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(50*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(50*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(50*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=5;
            dingdanshu1=5;
            dingdanshu2=5;
            dingdanshu3=5;
            dingdanshu4=5;
            guadangeshu=5;
            comment("主键盘数字键 5 本提示消失按键失效");
           }
         break;
         case 7://主键盘6
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo6)
                 {
                  if(btimeCurrent+3>=TimeCurrent())
                    {
                     timeGMTYesNo6=true;
                     buytrue06=true;
                     Print("定时器6开启 定时批量智能移动止盈位 只处理buy单");
                     comment1("定时器6开启 定时批量智能移动止盈位 只处理buy单");
                     return;
                    }
                  else
                    {
                     if(stimeCurrent+3>=TimeCurrent())
                       {
                        timeGMTYesNo6=true;
                        buytrue06=false;
                        Print("定时器6开启 定时批量智能移动止盈位 只处理sell单");
                        comment1("定时器6开启 定时批量智能移动止盈位 只处理sell单");
                        return;
                       }
                     else
                       {
                        Print("未检测到按下B或S键 定时器启用需要在按Tab键前先选择处理的订单类型 buy单按B sell单按S");
                        comment1("定时器启动失败 按Tab键前先选择订单类型buy单按B sell单按S");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo6=false;
                  buytrue06=true;
                  Print("定时器6关闭");
                  comment1("定时器6关闭");
                 }
               tab=false;
               bkey=false;
               skey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(60*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(60*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(60*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(60*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=6;
            dingdanshu1=6;
            dingdanshu2=6;
            dingdanshu3=6;
            dingdanshu4=6;
            guadangeshu=6;
            comment("主键盘数字键 6 本提示消失按键失效");
           }
         break;
         case 8://主键盘7
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(shiftR)
                 {
                  if(shift)
                    {
                     huaxianShift=true;
                     huaxianTimeSwitch=true;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     huaxianSwitch=false;
                     Print("划线反向锁仓定时器模式开启");
                     comment1("划线反向锁仓定时器模式开启");
                    }
                  else
                    {
                     if(ctrl)
                       {
                        huaxianCtrl=true;
                        huaxianTimeSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        huaxianSwitch=false;
                        Print("划线反向等量开仓变相锁仓定时器模式 开启");
                        comment1("划线反向等量开仓变相锁仓定时器模式 开启");
                       }
                     else
                       {
                        huaxianTimeSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        huaxianSwitch=false;
                        Print("划线平仓定时器模式开启");
                        comment1("划线平仓定时器模式开启");
                       }
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(huaxianSwitch || huaxianTimeSwitch)
                    {
                     huaxianSwitch=false;
                     huaxianTimeSwitch=false;
                     huaxianShift=false;
                     huaxianCtrl=false;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("划线平仓或锁仓模式关闭");
                     comment1("划线平仓或锁仓模式关闭");
                    }
                  else
                    {
                     if(shift)
                       {
                        huaxianShift=true;
                        huaxianSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        Print("划线反向锁仓模式开启");
                        comment1("划线反向锁仓模式开启");
                       }
                     else
                       {
                        if(ctrl)
                          {
                           huaxianCtrl=true;
                           huaxianSwitch=true;
                           huaxianguadan=false;
                           huaxiankaicang=false;
                           Print("划线反向等量开仓变相锁仓模式 开启");
                           comment1("划线反向等量开仓变相锁仓模式 开启");
                          }
                        else
                          {
                           huaxianSwitch=true;
                           huaxianguadan=false;
                           huaxiankaicang=false;
                           Print("划线平仓模式开启");
                           comment1("划线平仓模式开启");
                          }
                       }

                    }
                  tab=false;
                  shift=false;
                  ctrl=false;
                 }
              }
            else
              {
               tab=false;
              }

            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(70*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(70*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(70*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(70*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=7;
            dingdanshu1=7;
            dingdanshu2=7;
            dingdanshu3=7;
            dingdanshu4=7;
            comment("主键盘数字键 7 本提示消失按键失效");
           }
         break;
         case 9://主键盘8
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(huaxianTimeSwitch)
                    {
                     huaxianTimeSwitch=false;
                     huaxianSwitch=false;
                     获利方式1制定2趋势线0无获利平仓=2;
                     止损方式1制定2趋势线3移动止损0无止损=2;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("布林带平仓 定时器模式 关闭");
                     comment1("布林带平仓 定时器模式 关闭");
                    }
                  else
                    {
                     huaxianTimeSwitch=true;
                     huaxianSwitch=false;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     获利方式1制定2趋势线0无获利平仓=1;
                     止损方式1制定2趋势线3移动止损0无止损=1;
                     Print("布林带平仓 定时器模式 开启 默认参数20");
                     comment1("布林带平仓 定时器模式 开启 默认参数20");
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(huaxianSwitch || huaxianTimeSwitch)
                    {
                     huaxianSwitch=false;
                     huaxianTimeSwitch=false;
                     获利方式1制定2趋势线0无获利平仓=2;
                     止损方式1制定2趋势线3移动止损0无止损=2;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("布林带平仓模式关闭");
                     comment1("布林带平仓模式关闭");
                    }
                  else
                    {
                     huaxianSwitch=true;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     获利方式1制定2趋势线0无获利平仓=1;
                     止损方式1制定2趋势线3移动止损0无止损=1;
                     Print("布林带平仓模式开启 默认参数20");
                     comment1("布林带平仓模式开启 默认参数20");
                    }
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(80*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(80*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(80*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(80*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=8;
            dingdanshu1=8;
            dingdanshu2=8;
            dingdanshu3=8;
            dingdanshu4=8;
            comment("主键盘数字键 8 本提示消失按键失效");
           }
         break;
         case 10://主键盘9 9 j
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(tickclose)
                 {
                  tickclose=false;
                  tickShift=false;
                  Print("Tick数值变化剧烈时自动平仓 关闭");
                  comment1("Tick数值变化剧烈时自动平仓 关闭");
                 }
               else
                 {
                  if(bkey)
                    {
                     tickbuyclose=true;
                     if(ctrltimeCurrent+3>=TimeCurrent())
                       {
                        tickShift=true;
                       }
                     tickclose=true;
                     Print("Buy单Tick数值变化剧烈时自动平仓 开启 最大变化预设值",glotickclosenum," 启用前按一下Shift进入调试模式","tickShift=",tickShift);
                     comment1("Buy单Tick数值变化剧烈时自动平仓 开启");
                     bkey=false;
                     ctrl=false;
                    }
                  if(skey)
                    {
                     if(ctrltimeCurrent+3>=TimeCurrent())
                       {
                        tickShift=true;
                       }
                     tickclose=true;
                     Print("Sell单Tick数值变化剧烈时自动平仓 开启 最大变化预设值",glotickclosenum," 启用前按一下Shift进入调试模式","tickShift=",tickShift);
                     comment1("Sell单Tick数值变化剧烈时自动平仓 开启");
                     skey=false;
                     ctrl=false;
                    }
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(90*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(90*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(90*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(90*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=9;
            dingdanshu1=9;
            dingdanshu2=9;
            dingdanshu3=9;
            dingdanshu4=9;
            comment("主键盘数字键 9 本提示消失按键失效");
           }
         break;
         case 11://主键盘0
           {
            if(tabtimeCurrent+6>=TimeCurrent() && tab==true)
              {
               if(EAswitch && Gradually)
                 {
                  EAswitch=false;
                  Print("EA运行总开关 临时关闭 如需长时间关闭请按F7修改");
                  comment1("EA运行总开关 临时关闭 如需长时间关闭请按F7修改");
                  return;
                 }
               else
                 {
                  if(Gradually)
                    {
                     Gradually=false;
                     EAswitch=true;
                     Print("EA运行总开关开启 但分步平仓 临时关闭");
                     comment1("EA运行总开关开启 但分步平仓 临时关闭");
                     return;
                    }
                  else
                    {
                     if(AutoTrailingStop)
                       {
                        AutoTrailingStop=false;
                        Gradually=false;
                        EAswitch=true;
                        Print("EA运行总开关开启 但分步平仓 移动止损 临时关闭");
                        comment1("EA运行总开关开启 但分步平仓 移动止损 临时关闭");
                        return;
                       }
                     else
                       {
                        EAswitch=true;
                        Gradually=true;
                        AutoTrailingStop=true;
                        Print("EA运行总开关 开启 功能全部开启");
                        comment1("EA运行总开关 开启 功能全部开启");
                       }
                    }
                 }
               Print("AutoTrailingStop=",AutoTrailingStop);
               Print("Gradually=",Gradually);
               Print("EAswitch=",EAswitch);
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(0*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(0*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单取消止盈止损 处理中 . . . ");
               comment("多单取消止盈止损 处理中 . . . ");
               StopLoss=0;
               TargetProfit=0;
               FixedStopLoss=0.0;
               FixedTargetProfit=0.0;
               onlysell=false;
               piliangsltp();
               onlysell=true;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单取消止盈止损 处理中 . . . ");
               comment("空单取消止盈止损 处理中 . . . ");
               StopLoss=0;
               TargetProfit=0;
               FixedStopLoss=0.0;
               FixedTargetProfit=0.0;
               onlybuy=false;
               piliangsltp();
               onlybuy=true;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(0*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(0*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
           }
         break;
         case 309://小键盘  "/"键  / j
           {

            if(menu6[0])
              {
               if(ObjectFind(0,"dxzdBuyLineL")>=0 && dxzdBuyLineL1Time+180>TimeCurrent())
                 {
                  if(dxzdBuyLineL1==false && ObjectFind(0,"dxzdBuyLineL")>=0)
                    {
                     dxzdBuyLineL1=true;
                     Print("短线追Buy单 当前K线回撤到邻近K线的最低价附近时 追一单1 开启");
                     comment3("短线追Buy单 当前K线回撤到次K线的最低价附近时 追一单1 开启");
                     ObjectSet("dxzdBuyLineL",OBJPROP_COLOR,clrGreen);
                     dxzdBuyLineL1Time=TimeCurrent();
                     return;
                    }
                  else
                    {
                     if(dxzdBuyLineO1==false && ObjectFind(0,"dxzdBuyLineO")>=0)
                       {
                        dxzdBuyLineO1=true;
                        Print("短线追Buy单 当前K线回撤到邻近K线的开盘价附近时 追一单2 开启");
                        comment3("短线追Buy单 当前K线回撤到邻近K线的开盘价附近时 追一单2 开启");
                        ObjectSet("dxzdBuyLineO",OBJPROP_COLOR,clrGreen);
                        return;
                       }
                     else
                       {
                        if(dxzdBuyLineC1==false && ObjectFind(0,"dxzdBuyLineC")>=0)
                          {
                           dxzdBuyLineC1=true;
                           Print("短线追Buy单 当前K线回撤到邻近K线的收盘价附近时 追一单3 开启");
                           comment3("短线追Buy单 当前K线回撤到邻近K线的收盘价附近时 追一单3 开启");
                           ObjectSet("dxzdBuyLineC",OBJPROP_COLOR,clrGreen);
                           return;
                          }
                        else
                          {
                           if(dxzdBuyLineC1 && dxzdBuyLineO1 && dxzdBuyLineL1)
                             {
                              dxzdBuyLineL1=false;
                              dxzdBuyLineO1=false;
                              dxzdBuyLineC1=false;
                              ObjectDelete(0,"dxzdBuyLineL");
                              ObjectDelete(0,"dxzdBuyLineO");
                              ObjectDelete(0,"dxzdBuyLineC");
                              Print("短线追Buy单 触及开仓绿线时自动开仓 关闭");
                              comment3("短线追Buy单 触及开仓绿线时自动开仓 关闭");
                              return;
                             }
                          }
                       }
                    }
                 }
               else
                 {
                  Print("短线追Buy单 画出开仓线 再按启动触线开仓 颜色会改变");
                  comment3("短线追Buy单 画出开仓线 再按启动触线开仓 颜色会改变");
                  dxzdBuyLineL1Time=TimeCurrent();
                  ObjectDelete(0,"dxzdBuyLineL");
                  ObjectDelete(0,"dxzdBuyLineO");
                  ObjectDelete(0,"dxzdBuyLineC");
                  ObjectCreate(0,"dxzdBuyLineL",OBJ_RECTANGLE,0,Time[1],Low[1]+dxzdBuyLineLpianyiliang*Point,Time[0]+2500,Low[1]+dxzdBuyLineLpianyiliang*Point);
                  ObjectSet("dxzdBuyLineL",OBJPROP_BACK,false);
                  ObjectSet("dxzdBuyLineL",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdBuyLineL",OBJPROP_COLOR,clrDimGray);

                  ObjectCreate(0,"dxzdBuyLineC",OBJ_RECTANGLE,0,Time[1],Close[1]+dxzdBuyLineCpianyiliang*Point,Time[0]+2500,Close[1]+dxzdBuyLineCpianyiliang*Point);
                  ObjectSet("dxzdBuyLineC",OBJPROP_BACK,false);
                  ObjectSet("dxzdBuyLineC",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdBuyLineC",OBJPROP_COLOR,clrDimGray);

                  ObjectCreate(0,"dxzdBuyLineO",OBJ_RECTANGLE,0,Time[1],Open[1]+dxzdBuyLineOpianyiliang*Point,Time[0]+2500,Open[1]+dxzdBuyLineOpianyiliang*Point);
                  ObjectSet("dxzdBuyLineO",OBJPROP_BACK,false);
                  ObjectSet("dxzdBuyLineO",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdBuyLineO",OBJPROP_COLOR,clrDimGray);
                 }
              }


            if(menu6[1])
              {
               if(ObjectFind(0,"dxzdSellLineH")>=0 && dxzdBuyLineL1Time+180>TimeCurrent())
                 {
                  if(dxzdSellLineH1==false && ObjectFind(0,"dxzdSellLineH")>=0)
                    {
                     dxzdSellLineH1=true;
                     Print("短线追Sell单 当前K线回撤到邻近K线的最高价附近时 追一单1 开启");
                     comment3("短线追Sell单 当前K线回撤到次K线的最高价附近时 追一单1 开启");
                     ObjectSet("dxzdSellLineH",OBJPROP_COLOR,clrGreen);
                     dxzdBuyLineL1Time=TimeCurrent();
                     return;
                    }
                  else
                    {
                     if(dxzdSellLineO1==false && ObjectFind(0,"dxzdSellLineO")>=0)
                       {
                        dxzdSellLineO1=true;
                        Print("短线追Sell单 当前K线回撤到邻近K线的开盘价附近时 追一单2 开启");
                        comment3("短线追Sell单 当前K线回撤到邻近K线的开盘价附近时 追一单2 开启");
                        ObjectSet("dxzdSellLineO",OBJPROP_COLOR,clrGreen);
                        return;
                       }
                     else
                       {
                        if(dxzdSellLineC1==false && ObjectFind(0,"dxzdSellLineC")>=0)
                          {
                           dxzdSellLineC1=true;
                           Print("短线追Sell单 当前K线回撤到邻近K线的收盘价附近时 追一单3 开启");
                           comment3("短线追Sell单 当前K线回撤到邻近K线的收盘价附近时 追一单3 开启");
                           ObjectSet("dxzdSellLineC",OBJPROP_COLOR,clrGreen);
                           return;
                          }
                        else
                          {
                           dxzdSellLineH1=false;
                           dxzdSellLineO1=false;
                           dxzdSellLineC1=false;
                           ObjectDelete(0,"dxzdSellLineH");
                           ObjectDelete(0,"dxzdSellLineO");
                           ObjectDelete(0,"dxzdSellLineC");
                           Print("短线追Sell单 触及开仓绿线时自动开仓 关闭");
                           comment3("短线追Sell单 触及开仓绿线时自动开仓 关闭");
                           return;
                          }
                       }
                    }
                 }
               else
                 {
                  Print("短线追Sell单 画出开仓线 再按启动触线开仓 颜色会改变");
                  comment3("短线追Sell单 画出开仓线 再按启动触线开仓 颜色会改变");
                  dxzdBuyLineL1Time=TimeCurrent();
                  ObjectDelete(0,"dxzdSellLineH");
                  ObjectDelete(0,"dxzdSellLineO");
                  ObjectDelete(0,"dxzdSellLineC");
                  ObjectCreate(0,"dxzdSellLineH",OBJ_RECTANGLE,0,Time[1],High[1]+dxzdSellLineHpianyiliang*Point,Time[0]+2500,High[1]+dxzdSellLineHpianyiliang*Point);
                  ObjectSet("dxzdSellLineH",OBJPROP_BACK,false);
                  ObjectSet("dxzdSellLineH",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdSellLineH",OBJPROP_COLOR,clrDimGray);

                  ObjectCreate(0,"dxzdSellLineO",OBJ_RECTANGLE,0,Time[1],Open[1]+dxzdSellLineOpianyiliang*Point,Time[0]+2500,Open[1]+dxzdSellLineOpianyiliang*Point);
                  ObjectSet("dxzdSellLineO",OBJPROP_BACK,false);
                  ObjectSet("dxzdSellLineO",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdSellLineO",OBJPROP_COLOR,clrDimGray);

                  ObjectCreate(0,"dxzdSellLineC",OBJ_RECTANGLE,0,Time[1],Close[1]+dxzdSellLineCpianyiliang*Point,Time[0]+2500,Close[1]+dxzdSellLineCpianyiliang*Point);
                  ObjectSet("dxzdSellLineC",OBJPROP_BACK,false);
                  ObjectSet("dxzdSellLineC",OBJPROP_WIDTH,1);
                  ObjectSet("dxzdSellLineC",OBJPROP_COLOR,clrDimGray);
                 }
              }
           }
         break;
         case 55://小键盘 乘号键 * j
           {
            if(Tickmode)
              {
               if(SL15mbuyLine)
                 {
                  double buysl;
                  double buysl1=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mQlinetimeframe,0))-SLQbuylinepianyi*Point;
                  double buysl2=Ask-50*Point;
                  Print("buysl1=",buysl1," buysl2=",buysl2);
                  if(buysl2>buysl1)
                    {
                     buysl=buysl1;
                    }
                  else
                    {
                     buysl=buysl2;
                    }
                  for(int i=SLQNum; i>0; i--)
                    {
                     int ticket=OrderSend(Symbol(),OP_BUY,SLQlotsT,Ask,6,buysl,Ask+SL5Qtp*Point,NULL,1688,0,CLR_NONE);
                     if(ticket>0)
                        PlaySound("ok.wav");
                     else
                        PlaySound("timeout.wav");
                     buysl=buysl-3*Point;
                    }
                  SL5QTPtimeCurrent=TimeCurrent();
                  SL5QTPtimeCurrenttrue=true;

                  SLbuylineQpingcang1=true;
                  SLbuylineQpingcangT1=true;
                  SetLevel("SLsellQpengcangline1",Bid+SLsellQpengcangline1TP*Point,DarkSlateGray);
                  SLsellQpengcangline1=Bid+SLsellQpengcangline1TP*Point;
                 }
               else
                 {
                  double sellsl;
                  double sellsl1=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mQlinetimeframe,0))+SLQselllinepianyi*Point;
                  double sellsl2=Bid+50*Point;
                  Print("sellsl1=",sellsl1," sellsl2=",sellsl2);
                  if(sellsl2<sellsl1)
                    {
                     sellsl=sellsl1;
                    }
                  else
                    {
                     sellsl=sellsl2;
                    }
                  for(int i=SLQNum; i>0; i--)
                    {
                     int ticket=OrderSend(Symbol(),OP_SELL,SLQlotsT,Bid,6,sellsl,Bid-SL5Qtp*Point,NULL,1688,0,CLR_NONE);
                     if(ticket>0)
                        PlaySound("ok.wav");
                     else
                        PlaySound("timeout.wav");
                     sellsl=sellsl+3*Point;
                    }
                  SL5QTPtimeCurrent=TimeCurrent();
                  SL5QTPtimeCurrenttrue=true;

                  SLselllineQpingcang1=true;
                  SLselllineQpingcangT1=true;
                  SetLevel("SLbuyQpengcangline1",Ask-SLsellQpengcangline1TP*Point,DarkSlateGray);
                  SLbuyQpengcangline1=Ask-SLsellQpengcangline1TP*Point;
                 }
              }
           }
         break;
         case 82://小键盘0 0 j
           {
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
              {
               kkey=false;
              }
            if(menu1[14])
              {
               if(bars0971==1 || ObjectFind(0,"zi1")<0)
                 {
                  menu1[14]=false;
                  bars0971=bars097;
                  shiftRtimeCurrent=TimeCurrent()-1000;
                  Print("带止损开仓模式 关闭");
                  comment1("带止损开仓模式 关闭");
                 }
               else
                 {
                  bars0971--;
                  Print("带止损开仓模式 启动 计算最近的 ",bars0971," 根K线设止损 重复按减少K线 启动后 按ShiftR 300秒内 按一分钟图表计算最高最低价 ");
                  comment1(StringFormat("带止损开仓模式 启动 计算最近的 %G 根K线设止损 重复按减少K线",bars0971));
                 }
              }
            else
              {
               menu1[14]=true;
               Print("带止损开仓模式 启动 计算最近的 ",bars0971," 根K线设止损 重复按减少K线 启动后 按ShiftR 300秒内 按一分钟图表计算最高最低价 ");
               comment1(StringFormat("带止损开仓模式 启动 计算最近的 %G 根K线设止损 重复按减少K线 ",bars0971));
              }
           }
         break;
         case 79://小键盘1 j  1111
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 1 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 1 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,1,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 1 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 1 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,1,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(true,Bid-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(false,Ask+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
              {
               Print("akey ",akey);
               akey=false;
              }

            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice1,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice1));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice1,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice1));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice1,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice1));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice1,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice1));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=1;
            comment("小键盘数字键 1 本提示消失按键失效");
           }
         break;
         case 80://小键盘2 j
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 2 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 2 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,2,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 2 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 2 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,2,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(true,Bid+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(false,Ask-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice2,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice2));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice2,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice2));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice2,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice2));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice2,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice2));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=2;
            comment("小键盘数字键 2 本提示消失按键失效");
           }
         break;
         case 81://小键盘3 j
           {

            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 3 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 3 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,3,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 3 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 3 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,3,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(true,Bid-zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(false,Ask+zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice3,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice3));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice3,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice3));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice3,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice3));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice3,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice3));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=3;
            comment("小键盘数字键 3 本提示消失按键失效");
           }
         break;
         case 75://小键盘4
           {
            if(ntimeCurrent+2>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 4 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 4 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,4,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 4 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 4 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,4,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(true,Bid-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent())
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(false,Ask+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+3>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+5>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+5>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 76://小键盘5
           {
            if(ntimeCurrent+3>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 5 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 5 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,5,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+3>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 5 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 5 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,5,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(true,Bid+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent())
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(false,Ask-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+3>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+3>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point+press()));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 77://小键盘6
           {
            if(ntimeCurrent+2>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 6 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 6 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,6,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 6 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 6 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,6,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(true,Bid-zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent())
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(false,Ask+zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+3>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+3>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
           }
         break;
         case 71://小键盘7
           {
            if(ntimeCurrent+2>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 7 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 7 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,7,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 7 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 7 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,7,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(true,Bid-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent())
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(false,Ask+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+3>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+3>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 72://小键盘8 jian
           {
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(true,Bid+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
              {
               bkey=false;
              }
            if(stimeCurrent+3>=TimeCurrent())//
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(false,Ask-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
              {
               skey=false;
              }
            if(ntimeCurrent+3>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 8 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 8 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,8,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
              {
               nkey=false;
              }
            if(dtimeCurrent+3>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 8 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 8 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,8,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
              {
               dkey=false;
              }

            if(vtimeCurrent+3>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+3>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            // if(ctrltimeCurrent+1>=TimeCurrent() && ctrl==true){Print("市价三倍买一单 处理中 . . .");comment("市价三倍买一单 处理中 . . .");int om=OrderSend(Symbol(),OP_BUY,keylots*3,Ask,keyslippage,0,0,NULL,0);if(om>0) PlaySound("ok.wav");else PlaySound("timeout.wav");ctrl=false;return;}
            //else ctrl=false;
            if(ptimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent())
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 73://小键盘9
           {
            if(ntimeCurrent+2>=TimeCurrent())
              {
               Print("n=",nkey,"多单计算最近 9 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 9 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,9,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent())
              {
               Print("d=",dkey,"空单计算最近 9 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 9 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,9,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent())
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(true,Bid-zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent())
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(false,Ask+zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent())
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent())
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
           }
         break;
         case 25://P jian
           {
            if(ytimeCurrent+3>=TimeCurrent())//
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(yinyang5mpingcangshiftR)
                    {
                     yinyang5mpingcangshiftR=false;
                     Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 关闭");
                     comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 关闭");
                     pkey=false;
                     return;
                    }
                  else
                    {
                     yinyang5mpingcangshiftR=true;
                     yinyang5mpingcangtime=TimeCurrent();
                     Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 开启");
                     comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 开启");
                     pkey=false;
                     return;
                    }
                 }
               else
                 {
                  if(ctrlRtimeCurrent+3>=TimeCurrent())
                    {
                     if(yinyang5mpingcangctrlR)
                       {
                        yinyang5mpingcangctrlR=false;
                        Print("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 关闭");
                        comment("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 关闭");
                        pkey=false;
                        return;
                       }
                     else
                       {
                        yinyang5mpingcangctrlR=true;
                        yinyang5mpingcangtime=TimeCurrent();
                        Print("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 开启");
                        comment("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 开启");
                        pkey=false;
                        return;
                       }
                    }
                  else
                    {
                     if(yinyang5mpingcang)
                       {
                        yinyang5mpingcang=false;
                        yinyang5mpingcangshiftR=false;
                        yinyang5mpingcangctrlR=false;
                        Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓 关闭");
                        comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓 关闭");
                        pkey=false;
                        return;
                       }
                     else
                       {
                        yinyang5mpingcang=true;
                        Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓 开启");
                        comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓 开启");
                        pkey=false;
                        return;
                       }
                    }

                 }

              }
            if(tabtimeCurrent+3>=TimeCurrent())//
              {
               if(SLbuylineQpingcang==false && SLselllineQpingcang==false)
                 {
                  if(Tickmode)
                    {
                     if(SL15mbuyLine)
                       {
                        SLbuylineQpingcang=true;
                        SLbuylineQpingcangT=true;
                        timeseconds=1;
                        SetLevel("SLsellQpengcangline",Bid+2000*Point,DarkSlateGray);
                        SLsellQpengcangline=Bid+2000*Point;
                        Print("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓  开启");
                        comment("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓 开启");
                       }
                     else
                       {
                        if(SL15msellLine)
                          {
                           SLselllineQpingcang=true;
                           SLselllineQpingcangT=true;
                           timeseconds=1;
                           SetLevel("SLbuyQpengcangline",Ask-2000*Point,DarkSlateGray);
                           SLbuyQpengcangline=Ask-2000*Point;
                           Print("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓  开启");
                           comment("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓 开启");
                          }
                       }
                    }
                 }
               else
                 {
                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  Print("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓 关闭 ");
                  comment("剥头皮模式下 Buy单短线止盈 价格越过横线一单一单止盈平仓 关闭");
                 }
              }
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               if(shiftRtimeCurrent+2>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0 && linesellpingcangR==false)
                    {
                     linesellpingcangR=true;
                     linelock=true;
                     pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                     Print("sell单越过横线一单一单平仓 开启 仅止盈用 buy单用 sell Line sell单用 buy Line");
                     comment(StringFormat("sell单 越过横线一单一单平仓 开启 仅止盈用 平仓个数%G",pingcangdingdanshu));
                    }
                 }
               else
                 {
                  if(tab)
                    {
                     if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false)
                       {
                        PiliangSL(true,buyline-(MarketInfo(Symbol(),MODE_SPREAD)+lineslpianyi)*Point,jianju07,0,1,10);
                        linebuypingcangC=true;
                        linelock=true;
                        pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                        Print("触及横线全平仓 定时器模式 开启");
                        comment("触及横线全平仓 定时器模式 开启");
                        tab=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+5>=TimeCurrent())
                       {
                        if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false && linebuypingcangC==false)
                          {
                           if(ftimeCurrent+5>=TimeCurrent())
                             {
                              fkeyHolding=true;
                              linebuypingcang=true;
                              linelock=true;
                              linebuypingcangctrlR=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线后反向距横线多少设置止盈 同时反向开仓 开启 ");
                              comment("触及横线后反向距横线多少设置止损 同时反向开仓 开启 ");
                             }
                           else
                             {
                              linebuypingcang=true;
                              linelock=true;
                              linebuypingcangctrlR=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线后反向距横线多少设置止盈 开启 薅羊毛有风险");
                              comment("触及横线后反向距横线多少设置止盈 开启 薅羊毛有风险");
                             }
                          }
                       }
                     else
                       {
                        if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false && linebuypingcangC==false)//
                          {
                           if(btimeCurrent+3>=TimeCurrent())
                             {
                              linebuypingcang=true;
                              linebuypingcangonly=true;
                              linesellpingcangonly=false;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线 只平buy单 开启");
                              comment(StringFormat("触及横线 只平buy单 开启 平仓个数%G",pingcangdingdanshu));
                             }
                           else
                             {
                              if(ntimeCurrent+3>=TimeCurrent())
                                {
                                 linebuypingcang=true;
                                 linebuypingcangonly=false;
                                 linesellpingcangonly=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线 只平sell单 开启");
                                 comment(StringFormat("触及横线 只平sell单 开启 平仓个数%G",pingcangdingdanshu));
                                }
                              else
                                {
                                 if(ftimeCurrent+3>=TimeCurrent())
                                   {
                                    fkeyHoldingfanshou=true;//
                                    fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi1+shangpress*presspianyi+xiapress*presspianyi;
                                    linebuypingcang=true;
                                    linelock=true;
                                    //pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前按主数字键
                                    Print("触及横线全平仓后 距现价",fkeyHoldingfanshoupianyi1,"点反手追单 开启");
                                    comment(StringFormat("触及横线全平仓后 距现价%G点反手追单 开启 ",fkeyHoldingfanshoupianyi1));
                                   }
                                 else
                                   {
                                    linebuypingcang=true;
                                    linelock=true;
                                    pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                    Print("触及横线全平仓 开启 平仓个数",pingcangdingdanshu);
                                    comment(StringFormat("触及横线全平仓 开启 平仓个数%G",pingcangdingdanshu));
                                   }


                                }

                             }

                          }
                        else
                          {
                           if(linebuypingcang || linebuypingcangR || linebuypingcangC || linebuypingcangctrlR)
                             {
                              linebuypingcang=false;
                              linebuypingcangR=false;
                              linebuypingcangC=false;
                              linebuypingcangctrlR=false;
                              linebuypingcangonly=false;
                              linesellpingcangonly=false;
                              linelock=false;
                              fkeyHolding=false;
                              fkeyHoldingfanshou=false;
                              Print("触及横线平仓 功能 关闭");
                              comment("触及横线平仓 功能 关闭");
                             }
                          }
                       }
                    }
                 }
               if(shiftRtimeCurrent+2>=TimeCurrent())
                 {
                  if(ObjectFind("Sell Line")==0 && linebuypingcangR==false)
                    {
                     linebuypingcangR=true;
                     linelock=true;
                     pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                     Print("buy单 越过横线一单一单平仓 开启 仅止盈用  buy单用 sell Line sell单用 buy Line");
                     comment(StringFormat("buy单 越过横线一单一单平仓 开启 仅止盈用 平仓个数%G",pingcangdingdanshu));
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(tab)
                    {
                     if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false)
                       {
                        PiliangSL(false,sellline+(MarketInfo(Symbol(),MODE_SPREAD)+lineslpianyi)*Point,jianju07,0,1,10);
                        linesellpingcangC=true;
                        linelock=true;
                        pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                        Print("触及横线全平仓 定时器模式 开启");
                        comment("触及横线全平仓 定时器模式 开启");
                        tab=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+5>=TimeCurrent())
                       {
                        if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false && linebuypingcangC==false)
                          {
                           if(ftimeCurrent+5>=TimeCurrent())
                             {
                              fkeyHolding=true;
                              linesellpingcang=true;
                              linesellpingcangctrlR=true;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线后反向距横线多少设置止盈 同时反向开仓 开启 ");
                              comment("触及横线后反向距横线多少设置止盈 同时反向开仓 开启");
                             }
                           else
                             {
                              linesellpingcang=true;
                              linesellpingcangctrlR=true;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                              comment("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                             }
                          }
                       }
                     else
                       {
                        if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false && linebuypingcangC==false)
                          {
                           if(btimeCurrent+3>=TimeCurrent())
                             {
                              linesellpingcang=true;
                              linebuypingcangonly=true;
                              linesellpingcangonly=false;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线 只平buy单 开启");
                              comment(StringFormat("触及横线 只平buy单 开启 平仓个数%G",pingcangdingdanshu));
                             }
                           else
                             {
                              if(ntimeCurrent+3>=TimeCurrent())
                                {
                                 linesellpingcang=true;
                                 linebuypingcangonly=false;
                                 linesellpingcangonly=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线 只平sell单 开启");
                                 comment(StringFormat("触及横线 只平sell单 开启 平仓个数%G",pingcangdingdanshu));
                                }
                              else
                                {
                                 if(ftimeCurrent+3>=TimeCurrent())
                                   {
                                    fkeyHoldingfanshou=true;
                                    fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi1+shangpress*presspianyi+xiapress*presspianyi;
                                    linesellpingcang=true;
                                    linelock=true;
                                    pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前按主数字键
                                    Print("触及横线全平仓后 距现价多少点挂反向订单 开启 平仓个数",pingcangdingdanshu," 偏移量 ",fkeyHoldingfanshoupianyi1);
                                    comment(StringFormat("触及横线全平仓后 距现价多少点挂反向订单 开启 平仓个数%G",pingcangdingdanshu));
                                   }
                                 else
                                   {
                                    linesellpingcang=true;
                                    linelock=true;
                                    pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                    Print("触及横线全平仓 开启 平仓个数",pingcangdingdanshu);
                                    comment(StringFormat("触及横线全平仓 开启 平仓个数%G",pingcangdingdanshu));
                                   }
                                }

                             }
                          }
                        else
                          {
                           if(linesellpingcang || linesellpingcangR || linesellpingcangC || linesellpingcangctrlR)
                             {
                              linesellpingcang=false;
                              linesellpingcangR=false;
                              linesellpingcangC=false;
                              linesellpingcangctrlR=false;
                              linebuypingcangonly=false;
                              linesellpingcangonly=false;
                              linelock=false;
                              fkeyHolding=false;
                              fkeyHoldingfanshou=false;
                              Print("触及横线平仓 功能 关闭");
                              comment("触及横线平仓 功能 关闭");
                             }
                          }
                       }
                    }
                 }
               lkey=false;
               pkey=false;
              }
            else
              {
               lkey=false;
              }
            if(gtimeCurrent+2>=TimeCurrent() && gkey==true)
              {
               Print("g=",gkey," 智能buystop单 处理中. . .");
               comment(" 智能buystop单 处理中. . .");
               zhinengguadanbuystop();
               gkey=false;
              }
            else
              {
               gkey=false;
              }
            if(mtimeCurrent+3>=TimeCurrent() && mkey==true)
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(ftimeCurrent+3>=TimeCurrent())
                    {
                     if(dingshipingcang15F)
                       {
                        dingshipingcang15F=false;
                        Print("mkey=",mkey," 当前十五分钟K线收线时平仓后反手 关闭");
                        comment("当前十五分钟K线收线时平仓后反手 关闭");
                        mkey=false;
                        pkey=false;
                       }
                     else
                       {
                        dingshipingcang15F=true;
                        Print("mkey=",mkey," 当前十五分钟K线收线时平仓后反手  开启");
                        comment("当前十五分钟K线收线时平仓后反手 开启");
                        mkey=false;
                        pkey=false;
                       }
                    }
                  else
                    {
                     if(dingshipingcang15)
                       {
                        dingshipingcang15=false;
                        dingshipingcang15F=false;
                        Print("mkey=",mkey," 当前十五分钟K线收线时平仓 关闭");
                        comment("当前十五分钟K线收线时平仓 关闭");
                        mkey=false;
                        pkey=false;
                       }
                     else
                       {
                        dingshipingcang15=true;
                        Print("mkey=",mkey," 当前十五分钟K线收线时平仓  开启");
                        comment("当前十五分钟K线收线时平仓 开启");
                        mkey=false;
                        pkey=false;
                       }
                    }

                 }
               else
                 {
                  if(ftimeCurrent+3>=TimeCurrent())
                    {
                     if(dingshipingcangF)
                       {
                        dingshipingcangF=false;
                        Print("mkey=",mkey," 当前五分钟K线收线时平仓后反手 关闭");
                        comment("当前五分钟K线收线时平仓后反手 关闭");
                        mkey=false;
                        pkey=false;
                       }
                     else
                       {
                        dingshipingcangF=true;
                        Print("mkey=",mkey," 当前五分钟K线收线时平仓后反手  开启");
                        comment("当前五分钟K线收线时平仓后反手 开启");
                        mkey=false;
                        pkey=false;
                       }
                    }
                  else
                    {
                     if(dingshipingcang)
                       {
                        dingshipingcang=false;
                        dingshipingcangF=false;
                        dingshipingcang15=false;
                        dingshipingcang15F=false;
                        Print("mkey=",mkey," 当前五分钟K线收线时平仓 关闭");
                        comment("当前五分钟K线收线时平仓 关闭");
                        mkey=false;
                        pkey=false;
                       }
                     else
                       {
                        dingshipingcang=true;
                        Print("mkey=",mkey," 当前五分钟K线收线时平仓  开启");
                        comment("当前五分钟K线收线时平仓 开启");
                        mkey=false;
                        pkey=false;
                       }
                    }
                 }
              }
            else
              {
               mkey=false;
              }
           }
         break;
         case 38://L jian
           {
            if(ObjectFind("Buy Line")==0 || ObjectFind("SL Line")==0)
              {

              }
            else
              {
               if(gtimeCurrent+1>=TimeCurrent() && gkey==true && lkey==true)
                 {
                  Print("g=",gkey," 智能sellstop单 处理中. . .");
                  comment(" 智能sellstop单 处理中. . .");
                  zhinengguadansellstop();
                  gkey=false;
                  lkey=false;
                 }
               else
                  gkey=false;
              }
           }
         break;
         case 21://Y jian
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量上移当前止盈",moveSTTP,"个点");
               comment(StringFormat("多单批量上移当前止盈%G点",moveSTTP));
               onlybuy1=true;
               onlytpt=true;
               movesttp();
               onlybuy1=false;
               onlytpt=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量上移当前止盈",moveSTTP,"个点");
               comment(StringFormat("空单批量上移当前止盈%G个点",moveSTTP));
               onlysell1=true;
               onlyup=true;
               movesttp();
               onlybuy1=false;
               onlyup=false;
               skey=false;
              }
            else
               skey=false;
           }
         break;
         case 34://G jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  if(shiftR)
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        double sl=GetiLowest(0,7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Point-50*Point;
                        Print("横线处挂Buylimit单带7K智能止损 处理中... ",sl);
                        comment("横线处挂Buylimit单带7K智能止损 处理中...");
                        Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),sl,huaxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                       }
                     gkey=false;
                     lkey=false;
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("横线处挂sellstop单 处理中... ");
                        comment("横线处挂sellstop单 处理中...");
                        Guadansellstop(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        ctrl=false;
                       }
                     else
                       {
                        if(ObjectFind("SL Line")==0)
                          {
                           Print("横线处带止损挂Buylimit单在止损线止损  处理中... ",buyline);
                           comment("横线处带止损挂Buylimit单在止损线止损 处理中...");
                           Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),slline,huaxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                        else
                          {
                           Print("横线处带止损挂Buylimit单 X键可生成止损线  处理中... ",buyline);
                           comment("横线处带止损挂Buylimit单 X键可生成止损线 处理中...");
                           Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           xiapress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                       }
                    }
                  return;
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  if(shiftR)
                    {
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sl1=GetiHighest(0,7,0)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+50*Point;
                        Print("横线处挂Selllimit单带7K智能止损 处理中... ",sl1);
                        comment("横线处挂Selllimit单带7K智能止损 处理中...");
                        Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),sl1,huaxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        gkey=false;
                        lkey=false;
                        shiftR=false;
                        return;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("横线处挂buystop单 处理中... ");
                        comment("横线处挂buystop单 处理中...");
                        Guadanbuystop(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        ctrl=false;
                        gkey=false;
                        lkey=false;
                        return;
                       }
                     else
                       {
                        if(ObjectFind("SL Line")==0)

                          {
                           Print("横线处挂Selllimit单在止损线止损 处理中... ",slline);
                           comment("横线处挂Selllimit单在止损线止损 处理中...");
                           Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),slline,huaxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                        else
                          {
                           Print("横线处挂Selllimit单 X键可生成止损线 处理中... ",sellline);
                           comment("横线处挂Selllimit单 X键可生成止损线 处理中...");
                           Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+(rightpress-leftpress),huaxianguadanjianju+(shangpress-xiapress),hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           xiapress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                       }
                    }
                 }
               return;
              }
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量下移当前止盈",moveSTTP,"个点");
               comment(StringFormat("多单批量下移当前止盈%G个点",moveSTTP));
               onlybuy1=true;
               onlydown=true;
               movesttp();
               onlybuy1=false;
               onlydown=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量下移当前止盈",moveSTTP,"个点");
               comment(StringFormat("空单批量下移当前止盈%G个点",moveSTTP));
               onlysell1=true;
               onlytpt=true;
               movesttp();
               onlybuy1=false;
               onlytpt=false;
               skey=false;
               gkey=false;
              }
            else
               skey=false;
           }
         break;
         case 20://T jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  Print("buyline=",NormalizeDouble(buyline,Digits));
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     if(buyline<Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("Sell单红线处设置统一止盈 处理中... ");
                        comment("Sell单红线处设置统一止盈 处理中...");
                        PiliangTP(false,NormalizeDouble(buyline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Sell单无法设置止盈 或没有sell单 ");
                        comment("红线处在当前价上方 Sell单无法设置止盈 或没有sell单");
                       }
                    }
                  else
                    {
                     if(buyline<Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("Sell单红线处设置止盈 处理中... ");
                        comment("Sell单红线处设置止盈 处理中...");
                        PiliangTP(false,NormalizeDouble(buyline,Digits),jianju07tp,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Sell单无法设置止盈 或没有sell单 ");
                        comment("红线处在当前价上方 Sell单无法设置止盈 或没有sell单");
                       }
                    }
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  Print("sellline=",NormalizeDouble(sellline,Digits));
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     if(sellline>Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("Buy单绿线处设置统一止盈 处理中... ");
                        comment("Buy单绿线处设置统一止盈 处理中...");
                        PiliangTP(true,NormalizeDouble(sellline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单 ");
                        comment("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单");
                       }
                    }
                  else
                    {
                     if(sellline>Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("Buy单绿线处设置止盈 处理中... ");
                        comment("Buy单绿线处设置止盈 处理中...");
                        PiliangTP(true,NormalizeDouble(sellline,Digits),jianju07tp,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单 ");
                        comment("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单");
                       }
                    }
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }
               lkey=false;
               tkey=false;
              }
            else
              {
               lkey=false;
              }
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(true,false,tensltpweishu,tensltpmax);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(false,false,tensltpweishu,tensltpmax);
               akey=false;
               return;
              }
            else
               akey=false;
            if(gtimeCurrent+2>=TimeCurrent() && gkey==true)
              {
               Print("g=",gkey," 智能buylimit单 处理中. . .");
               comment(" 智能buylimit单 处理中. . .");
               zhinengguadanbuylimit();
               gkey=false;
               return;
              }
            else
               gkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量上移当前止损",moveSTTP,"个点");
               comment(StringFormat("多单批量上移当前止损%G个点",moveSTTP));
               onlybuy1=true;
               onlyup=true;
               movesttp();
               onlybuy1=false;
               onlyup=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量上移当前止损",moveSTTP,"个点");
               comment(StringFormat("空单批量上移当前止损%G个点",moveSTTP));
               onlysell1=true;
               onlystp=true;
               movesttp();
               onlybuy1=false;
               onlystp=false;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" o=",okey," 整数位批量挂buylimit单抓回撤 处理中 . . . ");
               comment("整数位批量挂buylimit单抓回撤 处理中 . . . ");
               Tenguadan(true,tenweishu,tenmax);
               okey=false;
               return;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" k=",kkey," 整数位批量挂selllimit单抓回撤 处理中 . . . ");
               comment("整数位批量挂selllimit单抓回撤 处理中 . . . ");
               Tenguadan(false,tenweishu,tenmax);
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 33://F jian
           {

            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(true,true,tensltpweishu,tensltpmax);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(false,true,tensltpweishu,tensltpmax);
               akey=false;
               return;
              }
            else
               akey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量下移当前止损",moveSTTP,"个点");
               comment(StringFormat("多单批量下移当前止损%G个点",moveSTTP));
               onlybuy1=true;
               onlystp=true;
               movesttp();
               onlybuy1=false;
               onlystp=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量下移当前止损",moveSTTP,"个点");
               comment(StringFormat("空单批量下移当前止损%G个点",moveSTTP));
               onlysell1=true;
               onlydown=true;
               movesttp();
               onlybuy1=false;
               onlydown=false;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" o=",okey," 计算最近的最低最高点以斐波那契百分比位挂buylimit单");
               comment("计算最近的最低最高点以斐波那契百分比位挂buylimit单 处理中 . . .");
               Print("计算的最低价",GetiLowest(timeframe08,bars08,beginbar08)," 计算的最高价",GetiHighest(timeframe08,bars08,beginbar08)," 偏移量",fibbuypianyiliang);
               Fibguadan(0,GetiLowest(timeframe07,bars07,beginbar07),GetiHighest(timeframe08,bars08,beginbar08));
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" k=",kkey," 计算最近的最低最高点以斐波那契百分比位挂selllimit单");
               comment("计算最近的最低最高点以斐波那契百分比位挂selllimit单 处理中 . . .");
               Print("计算的最低价",GetiLowest(timeframe08,bars08,beginbar08)," 计算的最高价",GetiHighest(timeframe07,bars07,beginbar07)," 偏移量",fibsellpianyiliang);
               Fibguadan(1,GetiLowest(timeframe08,bars08,beginbar08),GetiHighest(timeframe07,bars07,beginbar07));
               kkey=false;
              }
            else
               kkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {

               if(ObjectFind("Buy Line")==0 && linebuyfansuo==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(buyline>Bid)
                       {
                        int aa1=OrderSend(Symbol(),OP_SELLLIMIT,CGetbuyLots(),buyline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa1>0)
                          {
                           Print("订单编号= ",aa1);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           Print("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        shiftR=false;
                       }
                     else
                       {
                        int aa1=OrderSend(Symbol(),OP_SELLSTOP,CGetbuyLots(),buyline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa1>0)
                          {
                           Print("订单编号= ",aa1);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           Print("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        shiftR=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        yijianFanshou=true;
                        linelock=true;
                        Print("触及横线平仓后 反手开仓 开启");
                        comment("触及横线平仓后 反手开仓 开启");
                       }
                     else
                       {
                        linebuyfansuo=true;
                        yijianFanshou=false;
                        linelock=true;
                        Print("触及横线开仓反锁 开启");
                        comment("触及横线开仓反锁 开启");

                       }
                    }
                 }
               else
                 {
                  if(linebuyfansuo)
                    {
                     linebuyfansuo=false;
                     yijianFanshou=false;
                     linelock=false;
                     Print("触及横线开仓反锁 关闭");
                     comment("触及横线开仓反锁 关闭");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellfansuo==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(sellline>Bid)
                       {
                        int aa2=OrderSend(Symbol(),OP_BUYSTOP,CGetsellLots(),sellline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa2>0)
                          {
                           Print("订单编号= ",aa2);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                     else
                       {
                        int aa2=OrderSend(Symbol(),OP_BUYLIMIT,CGetsellLots(),sellline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa2>0)
                          {
                           Print("订单编号= ",aa2);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        yijianFanshou=true;
                        linelock=true;
                        Print("触及横线平仓后 反手开仓 开启");
                        comment("触及横线平仓后 反手开仓 开启");
                       }
                     else
                       {
                        linesellfansuo=true;
                        yijianFanshou=false;
                        linelock=true;
                        Print("触及横线开仓反锁 开启");
                        comment("触及横线开仓反锁 开启");
                       }
                    }
                 }
               else
                 {
                  if(linesellfansuo)
                    {
                     linesellfansuo=false;
                     yijianFanshou=false;
                     linelock=false;
                     Print("触及横线开仓反锁 关闭");
                     comment("触及横线开仓反锁 关闭");
                    }
                 }
               lkey=false;
               fkey=false;
              }
            else
              {
               lkey=false;
              }
           }
         break;
         case 19://R jian
           {
            if(ObjectFind("Sell Line")==0 || ObjectFind("Buy Line")==0)
              {
               linepianyi1=linepianyi*2;
               comment1("横线移动距离 临时翻倍 文字消失 恢复正常 左Ctrl距离减半");
              }
           }
         break;
         case 30://A jian
           {
            if(BuyTrendLineSLtime+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL1")==0)
                 {

                  TrendLine("BuyTrendLineSL1",Time[BuyTrendLineSLjishu+1],Low[BuyTrendLineSLjishu+1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu+1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损1");
                  BuyTrendLineSLjishu++;
                  return;
                 }
              }
            if(SellTrendLineSLtime+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL1")==0)
                 {

                  TrendLine("SellTrendLineSL1",Time[SellTrendLineSLjishu+1],High[SellTrendLineSLjishu+1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu+1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损1");
                  SellTrendLineSLjishu++;
                  return;
                 }
              }
            ////////////////////////////////////////////////
            if(BuyTrendLineSL2time+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL2")==0)
                 {

                  TrendLine("BuyTrendLineSL2",Time[BuyTrendLineSLjishu+1],Low[BuyTrendLineSLjishu+1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu+1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损2");
                  BuyTrendLineSLjishu++;
                  return;
                 }
              }
            if(SellTrendLineSL2time+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL2")==0)
                 {

                  TrendLine("SellTrendLineSL2",Time[SellTrendLineSLjishu+1],High[SellTrendLineSLjishu+1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu+1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损2");
                  SellTrendLineSLjishu++;
                  return;
                 }
              }
            /////////////////////////////////////////////////////////////////////////
            if(BuyTrendLineSL3time+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL3")==0)
                 {

                  TrendLine("BuyTrendLineSL3",Time[BuyTrendLineSLjishu+1],Low[BuyTrendLineSLjishu+1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu+1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损3");
                  BuyTrendLineSLjishu++;
                  return;
                 }
              }
            if(SellTrendLineSL3time+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL3")==0)
                 {

                  TrendLine("SellTrendLineSL3",Time[SellTrendLineSLjishu+1],High[SellTrendLineSLjishu+1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu+1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损3");
                  SellTrendLineSLjishu++;
                  return;
                 }
              }
            ///////////////////////////////////////////////////////////////////
            if(linelock==false)
              {
               if(ctrltimeCurrent+20>=TimeCurrent())
                 {
                  Print("ctrl+A执行 bar=",linebar01);
                  if(ObjectFind("Buy Line")==0)
                    {
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01+1));
                     double buyline1=Open[linebar01+1];
                     ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                     buyline=buyline1;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01+1));
                     double sellline1=Open[linebar01+1];
                     ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                     sellline=sellline1;
                    }
                  linebar01++;
                 }
               else
                 {
                  if(ctrlRtimeCurrent+15>=TimeCurrent())
                    {
                     Print("ctrlR+A执行 bar=",linebar01+1);
                     comment(StringFormat("当前K线%G 计算最高最低的中间值划线",linebar01+1));
                     if(ObjectFind("Buy Line")==0)
                       {
                        double buyline1=(Low[linebar01+1]+High[linebar01+1])/2;
                        ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                        buyline=buyline1;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sellline1=(Low[linebar01+1]+High[linebar01+1])/2;
                        ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                        sellline=sellline1;
                       }
                     linebar01++;
                    }
                  else
                    {
                     Print("A执行 bar=",linebar01);
                     if(ObjectFind("Buy Line")==0)
                       {
                        comment(StringFormat("当前K线%G 计算最低值划线",linebar01+1));
                        double buyline1=Low[linebar01+1];
                        ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                        buyline=buyline1;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        comment(StringFormat("当前K线%G 计算最高值划线",linebar01+1));
                        double sellline1=High[linebar01+1];
                        ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                        sellline=sellline1;
                       }
                     linebar01++;
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
              }
           }
         break;
         case 32://D jian
           {
            if(BuyTrendLineSLtime+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL1")==0)
                 {

                  TrendLine("BuyTrendLineSL1",Time[BuyTrendLineSLjishu-1],Low[BuyTrendLineSLjishu-1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu-1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损1");

                  if(BuyTrendLineSLjishu>1)
                    {
                     BuyTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            if(SellTrendLineSLtime+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL1")==0)
                 {

                  TrendLine("SellTrendLineSL1",Time[SellTrendLineSLjishu-1],High[SellTrendLineSLjishu-1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu-1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损1");
                  if(SellTrendLineSLjishu>1)
                    {
                     SellTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            ///////////////////////////////////////////////////////
            if(BuyTrendLineSL2time+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL2")==0)
                 {

                  TrendLine("BuyTrendLineSL2",Time[BuyTrendLineSLjishu-1],Low[BuyTrendLineSLjishu-1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu-1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损2");

                  if(BuyTrendLineSLjishu>1)
                    {
                     BuyTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            if(SellTrendLineSL2time+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL2")==0)
                 {

                  TrendLine("SellTrendLineSL2",Time[SellTrendLineSLjishu-1],High[SellTrendLineSLjishu-1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu-1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损2");
                  if(SellTrendLineSLjishu>1)
                    {
                     SellTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            ///////////////////////////////////////////////////////
            if(BuyTrendLineSL3time+20>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL3")==0)
                 {

                  TrendLine("BuyTrendLineSL3",Time[BuyTrendLineSLjishu-1],Low[BuyTrendLineSLjishu-1]-pianyilingGlo,Time[0]+1000,Low[BuyTrendLineSLjishu-1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损3");

                  if(BuyTrendLineSLjishu>1)
                    {
                     BuyTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            if(SellTrendLineSL3time+20>=TimeCurrent())
              {
               if(ObjectFind("SellTrendLineSL3")==0)
                 {

                  TrendLine("SellTrendLineSL3",Time[SellTrendLineSLjishu-1],High[SellTrendLineSLjishu-1]+pianyilingGlo,Time[0]+1000,High[SellTrendLineSLjishu-1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损3");
                  if(SellTrendLineSLjishu>1)
                    {
                     SellTrendLineSLjishu--;
                    }
                  return;
                 }
              }
            ///////////////////////////////////////////////////////
            if(linelock==false)
              {
               if(ctrltimeCurrent+20>=TimeCurrent())
                 {
                  if(linebar01==0)
                     linebar01=1;
                  if(ObjectFind("Buy Line")==0)
                    {
                     Print("ctrl+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 横线在开盘价 ",linebar01-1));
                     double buyline2=Open[linebar01-1];
                     ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                     buyline=buyline2;
                     dkey=false;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     Print("ctrl+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01-1));
                     double sellline2=Open[linebar01-1];
                     ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                     sellline=sellline2;
                     dkey=false;
                    }
                  linebar01--;
                 }
               else
                 {
                  if(ctrlRtimeCurrent+15>=TimeCurrent())
                    {
                     Print("ctrlR+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 计算最高最低的中间值划线",linebar01-1));
                     if(linebar01==0)
                        linebar01=1;
                     if(ObjectFind("Buy Line")==0)
                       {
                        double buyline2=(Low[linebar01-1]+High[linebar01-1])/2;
                        ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                        buyline=buyline2;
                        dkey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sellline2=(Low[linebar01-1]+High[linebar01-1])/2;
                        ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                        sellline=sellline2;
                        dkey=false;
                       }
                     linebar01--;
                    }
                  else
                    {
                     if(linebar01==0)
                        linebar01=1;
                     if(ObjectFind("Buy Line")==0)
                       {
                        Print("D执行 bar=",linebar01-1);
                        comment(StringFormat("当前K线%G 计算最低值划线",linebar01-1));
                        double buyline2=Low[linebar01-1];
                        ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                        buyline=buyline2;
                        dkey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        Print("D执行 bar=",linebar01-1);
                        comment(StringFormat("当前K线%G 计算最高值划线",linebar01-1));
                        double sellline2=High[linebar01-1];
                        ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                        sellline=sellline2;
                        dkey=false;
                       }
                     linebar01--;
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               dkey=false;
              }
           }
         break;
         case 17://W jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     ObjectMove(0,"Buy Line",0,Time[linebar],buyline+linepianyi*0.5*Point);
                     buyline=buyline+linepianyi*0.5*Point;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     ObjectMove(0,"Sell Line",0,Time[linebar],sellline+linepianyi*0.5*Point);
                     sellline=sellline+linepianyi*0.5*Point;
                    }
                 }
               else
                 {
                  if(ObjectFind("SL Line")==0)
                    {
                     if(ObjectFind("SL Line")==0)
                       {
                        ObjectMove(0,"SL Line",0,Time[linebar],slline+linepianyi1*Point);
                        slline=slline+linepianyi1*Point;
                       }
                    }
                  else
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        ObjectMove(0,"Buy Line",0,Time[linebar],buyline+linepianyi1*Point);
                        buyline=buyline+linepianyi1*Point;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        ObjectMove(0,"Sell Line",0,Time[linebar],sellline+linepianyi1*Point);
                        sellline=sellline+linepianyi1*Point;
                       }
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
              }
           }
         break;
         case 18://E jian
           {
            if(ObjectFind("Buy Line")==0)
              {
               buyline=NormalizeDouble(buyline,Digits-1);
               Print("横线位置舍弃最后一位小数");
               comment("横线位置舍弃最后一位小数");
              }
            if(ObjectFind("Sell Line")==0)
              {
               sellline=NormalizeDouble(sellline,Digits-1);
               Print("横线位置舍弃最后一位小数");
               comment("横线位置舍弃最后一位小数");
              }
           }
         break;
         case 48://B jian
           {

           }
         break;
         case 52://> jian 多单剥头皮
           {
            if(ztimeCurrent+2>=TimeCurrent() && menu6[1]==false)
              {
               if(menu6[0])
                 {
                  menu6[0]=false;
                  comment3("短线追Buy单模式 关闭 ");
                  Print("短线追Buy单模式 关闭 ");
                  ObjectDelete(0,"dxzdBuyi2kSL");
                  ObjectDelete(0,"dxzdBuyi3kSL");
                  ObjectDelete(0,"dxzdBuyi4kSL");
                  ObjectDelete(0,"dxzdBuyi5kSL");
                  ObjectDelete(0,"dxzdBuyi2kSL1");
                  ObjectDelete(0,"dxzdBuyi3kSL1");
                  ObjectDelete(0,"dxzdBuyi4kSL1");
                  ObjectDelete(0,"dxzdBuyi5kSL1");
                  ObjectDelete(0,"dxzdBuyLineC");
                  ObjectDelete(0,"dxzdBuyLineO");
                  ObjectDelete(0,"dxzdBuyLineL");
                  dxzdBuyLineL1=false;
                  dxzdBuyLineO1=false;
                  dxzdBuyLineC1=false;
                  return;
                 }
               else
                 {
                  menu6[0]=true;
                  comment3("短线追Buy单模式 启动 ");
                  Print("短线追Buy单模式 启动 ");
                  return;
                 }
              }

            if(tabtimeCurrent+2>=TimeCurrent() && Tickmode==false)
              {
               Tickmode=true;
               timeGMTSeconds1=SL5mtimeGMTSeconds1;
               GraduallyNum=SL5mlineGraduallyNum;
               stoploss=SL5mlinestoploss;
               takeprofit=SL5mlinetakeprofit;
               TrailingStop=SL5mlineTrailingStop;
               SL1mbuyLine=true;
               SL5mbuyLine=true;
               SL15mbuyLine=true;
               SLbuylinepingcang=true;
               bars097=3;//Shift 带止损下单计算K线减小
               buypianyiliang=30;//  Shift 带止损下单偏移减小
               sellpianyiliang=30;// Shift 带止损下单偏移减小
               SL1mbuyLineprice=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;//初始化
               SL5mbuyLineprice=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SL5mbuyLineprice=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SL1mbuyLineprice=Ask-500*Point;
               SL5mbuyLineprice=Ask-500*Point;
               SL15mbuyLineprice=Ask-500*Point;
               Print("Tick分步平仓启动 多单 止盈止损已修改为剥头皮模式");
               comment("Tick分步平仓启动 多单 止盈止损已修改为剥头皮模式");
               return;
              }
            else
              {
               if(tabtimeCurrent+1>TimeCurrent())
                 {
                  Tickmode=false;
                  timeGMTSeconds1=180;
                  GraduallyNum=5;
                  stoploss=320;
                  takeprofit=500;
                  TrailingStop=340;
                  SL1mbuyLine=false;
                  SL5mbuyLine=false;
                  SL15mbuyLine=false;
                  SLbuylinepingcang=false;
                  SL1msellLine=false;
                  SL5msellLine=false;
                  SL15msellLine=false;
                  SLselllinepingcang=false;
                  bars097=7;//Shift 带止损下单计算K线减小
                  buypianyiliang=50;//  Shift 带止损下单偏移减小
                  sellpianyiliang=50;// Shift 带止损下单偏移减小

                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline1");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline1");
                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  if(ObjectFind(0,"SL5mbuyLine")==0)
                     ObjectDelete(0,"SL5mbuyLine");
                  if(ObjectFind(0,"SL15mbuyLine")==0)
                     ObjectDelete(0,"SL15mbuyLine");
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  if(ObjectFind(0,"SL5msellLine")==0)
                     ObjectDelete(0,"SL5msellLine");
                  if(ObjectFind(0,"SL15msellLine")==0)
                     ObjectDelete(0,"SL15msellLine");
                  if(ObjectFind(0,"botoupi")==0)
                     ObjectDelete(0,"botoupi");
                  Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  return;
                 }
              }
            if(Tickmode)
              {
               if(SL1mbuyLine)
                 {
                  SL1mbuyLine=false;
                  SL1mbuyLineprice=Ask-1000*Point;
                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  Print("一分钟止损横线取消 ");
                  comment("一分钟止损横线取消");
                 }
               else
                 {
                  if(SL5mbuyLine)
                    {
                     SL5mbuyLine=false;
                     SL5mbuyLineprice=Ask-1000*Point;
                     if(ObjectFind(0,"SL5mbuyLine")==0)
                        ObjectDelete(0,"SL5mbuyLine");
                     Print("五分钟止损横线取消 ");
                     comment("五分钟止损横线取消");
                    }
                  else

                    {
                     if(SL15mbuyLine)
                       {
                        SL15mbuyLine=false;
                        SL15mbuyLineprice=Ask-1000*Point;
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        Print("十五分钟止损横线取消 ");
                        comment("十五分钟止损横线取消");
                       }
                     else
                       {
                        Tickmode=false;
                        timeGMTSeconds1=100;
                        GraduallyNum=5;
                        stoploss=GlobalVariableGet("glo5sl");
                        takeprofit=GlobalVariableGet("glo5tp");
                        TrailingStop=GlobalVariableGet("glo5movesl");
                        SL1mbuyLine=false;
                        SL5mbuyLine=false;
                        SL15mbuyLine=false;
                        SLbuylinepingcang=false;
                        SL1msellLine=false;
                        SL5msellLine=false;
                        SL15msellLine=false;
                        SLselllinepingcang=false;
                        bars097=7;//Shift 带止损下单计算K线减小
                        buypianyiliang=50;//  Shift 带止损下单偏移减小
                        sellpianyiliang=50;// Shift 带止损下单偏移减小
                        SLbuylineQpingcang=false;
                        SLselllineQpingcang=false;
                        SLbuylineQpingcangT=false;
                        SLselllineQpingcangT=false;
                        timeseconds=2;
                        if(ObjectFind(0,"SLsellQpengcangline")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SLsellQpengcangline1")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SL1mbuyLine")==0)
                           ObjectDelete(0,"SL1mbuyLine");
                        if(ObjectFind(0,"SL5mbuyLine")==0)
                           ObjectDelete(0,"SL5mbuyLine");
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        if(ObjectFind(0,"SL1msellLine")==0)
                           ObjectDelete(0,"SL1msellLine");
                        if(ObjectFind(0,"SL5msellLine")==0)
                           ObjectDelete(0,"SL5msellLine");
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        if(ObjectFind(0,"botoupi")==0)
                           ObjectDelete(0,"botoupi");
                        Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                        comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                       }
                    }
                 }
              }
           }
         break;
         case 51://< jian 空单剥头皮
           {
            if(ztimeCurrent+2>=TimeCurrent() && menu6[0]==false)
              {
               if(menu6[1])
                 {
                  menu6[1]=false;
                  comment3("短线追Sell单模式 关闭 ");
                  ObjectDelete(0,"dxzdSelli2kSL");
                  ObjectDelete(0,"dxzdSelli3kSL");
                  ObjectDelete(0,"dxzdSelli4kSL");
                  ObjectDelete(0,"dxzdSelli5kSL");
                  ObjectDelete(0,"dxzdSelli2kSL1");
                  ObjectDelete(0,"dxzdSelli3kSL1");
                  ObjectDelete(0,"dxzdSelli4kSL1");
                  ObjectDelete(0,"dxzdSelli5kSL1");
                  ObjectDelete(0,"dxzdSellLineC");
                  ObjectDelete(0,"dxzdSellLineO");
                  ObjectDelete(0,"dxzdSellLineH");
                  dxzdSellLineH1=false;
                  dxzdSellLineO1=false;
                  dxzdSellLineC1=false;
                  return;
                 }
               else
                 {
                  menu6[1]=true;
                  comment3("短线追Sell单模式 启动 ");
                  Print("短线追Sell单模式 启动 ");
                  return;
                 }
              }

            if(tabtimeCurrent+1>=TimeCurrent() && Tickmode==false)
              {
               Tickmode=true;
               timeGMTSeconds1=SL5mtimeGMTSeconds1;
               GraduallyNum=SL5mlineGraduallyNum;
               stoploss=SL5mlinestoploss;
               takeprofit=SL5mlinetakeprofit;
               TrailingStop=SL5mlineTrailingStop;
               SL1msellLine=true;
               SL5msellLine=true;
               SL15msellLine=true;
               SLselllinepingcang=true;
               bars097=3;//Shift 带止损下单计算K线减小
               buypianyiliang=30;//  Shift 带止损下单偏移减小
               sellpianyiliang=30;// Shift 带止损下单偏移减小
               SL1msellLineprice=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;//初始化
               SL5msellLineprice=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               SL15msellLineprice=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               SL1msellLineprice=Bid+500*Point;
               SL5msellLineprice=Bid+500*Point;
               SL15msellLineprice=Bid+500*Point;
               Print("Tick分步平仓启动 空单 止盈止损已修改为剥头皮模式");
               comment("Tick分步平仓启动 空单 止盈止损已修改为剥头皮模式");
               return;
              }
            else
              {
               if(tabtimeCurrent+2>=TimeCurrent())
                 {
                  Tickmode=false;
                  timeGMTSeconds1=100;
                  GraduallyNum=5;
                  stoploss=GlobalVariableGet("glo5sl");
                  takeprofit=GlobalVariableGet("glo5tp");
                  TrailingStop=GlobalVariableGet("glo5movesl");
                  SL1mbuyLine=false;
                  SL5mbuyLine=false;
                  SL15mbuyLine=false;
                  SLbuylinepingcang=false;
                  SL1msellLine=false;
                  SL5msellLine=false;
                  SL15msellLine=false;
                  SLselllinepingcang=false;
                  bars097=7;//Shift 带止损下单计算K线减小
                  buypianyiliang=50;//  Shift 带止损下单偏移减小
                  sellpianyiliang=50;// Shift 带止损下单偏移减小
                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline1");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  if(ObjectFind(0,"SL5mbuyLine")==0)
                     ObjectDelete(0,"SL5mbuyLine");
                  if(ObjectFind(0,"SL15mbuyLine")==0)
                     ObjectDelete(0,"SL15mbuyLine");
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  if(ObjectFind(0,"SL5msellLine")==0)
                     ObjectDelete(0,"SL5msellLine");
                  if(ObjectFind(0,"SL15msellLine")==0)
                     ObjectDelete(0,"SL15msellLine");
                  if(ObjectFind(0,"botoupi")==0)
                     ObjectDelete(0,"botoupi");
                  Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  return;
                 }
              }
            if(Tickmode)
              {
               if(SL1msellLine)
                 {
                  SL1msellLine=false;
                  SL1msellLineprice=Bid+1000*Point;
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  Print("一分钟止损横线取消 ");
                  comment("一分钟止损横线取消");
                 }
               else
                 {
                  if(SL5msellLine)
                    {
                     SL5msellLine=false;
                     SL5msellLineprice=Bid+1000*Point;
                     if(ObjectFind(0,"SL5msellLine")==0)
                        ObjectDelete(0,"SL5msellLine");
                     Print("五分钟止损横线取消 ");
                     comment("五分钟止损横线取消");
                    }
                  else
                    {
                     if(SL15msellLine)
                       {
                        SL15msellLine=false;
                        SL15msellLineprice=Bid+1000*Point;
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        Print("十五分钟止损横线取消 ");
                        comment("十五分钟止损横线取消");
                       }
                     else
                       {
                        Tickmode=false;
                        timeGMTSeconds1=100;
                        GraduallyNum=5;
                        stoploss=GlobalVariableGet("glo5sl");
                        takeprofit=GlobalVariableGet("glo5tp");
                        TrailingStop=GlobalVariableGet("glo5movesl");
                        SL1mbuyLine=false;
                        SL5mbuyLine=false;
                        SL15mbuyLine=false;
                        SLbuylinepingcang=false;
                        SL1msellLine=false;
                        SL5msellLine=false;
                        SL15msellLine=false;
                        SLselllinepingcang=false;
                        bars097=7;//Shift 带止损下单计算K线减小
                        buypianyiliang=50;//  Shift 带止损下单偏移减小
                        sellpianyiliang=50;// Shift 带止损下单偏移减小
                        SLbuylineQpingcang=false;
                        SLselllineQpingcang=false;
                        SLbuylineQpingcangT=false;
                        SLselllineQpingcangT=false;
                        timeseconds=2;
                        if(ObjectFind(0,"SLsellQpengcangline")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SLsellQpengcangline1")==0)
                           ObjectDelete(0,"SLsellQpengcangline1");
                        if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SL1mbuyLine")==0)
                           ObjectDelete(0,"SL1mbuyLine");
                        if(ObjectFind(0,"SL5mbuyLine")==0)
                           ObjectDelete(0,"SL5mbuyLine");
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        if(ObjectFind(0,"SL1msellLine")==0)
                           ObjectDelete(0,"SL1msellLine");
                        if(ObjectFind(0,"SL5msellLine")==0)
                           ObjectDelete(0,"SL5msellLine");
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        if(ObjectFind(0,"botoupi")==0)
                           ObjectDelete(0,"botoupi");
                        Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                        comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                       }
                    }
                 }
              }
           }
         break;
         case 16://Q jian
           {
            if(ObjectFind(0,"Sell Line")==0)
              {
               ObjectDelete(0,"Sell Line");
               ObjectDelete(0,"SL Line");
               linebar01=linebar;
               linebuykaicang=false;
               linebuypingcang=false;
               linebuyfansuo=false;
               linesellkaicang=false;
               linesellpingcang=false;
               linesellfansuo=false;
               yijianFanshou=false;
               linelock=false;
               lkey=false;
               linebuyzidongjiacang=false;
               linesellzidongjiacang=false;
               linebuypingcangR=false;
               linesellpingcangR=false;
               linebuypingcangC=false;
               linesellpingcangC=false;
               linebuypingcangctrlR=false;
               linesellpingcangctrlR=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               linekaicangT=false;
               linekaicangctrl=false;
               timeseconds1=timeseconds1P;
               pingcangdingdanshu=1000;
               hengxianAi1=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi1a=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi2=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi3=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi4=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi5=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi6=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi7=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               hengxianAi8=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
               shangpress=0;
               xiapress=0;
               leftpress=0;
               rightpress=0;//清除方向键按下次数
               fkeyHolding=false;//
               fkeyHoldingfanshou=false;
               menu[24]=false;
               menu[26]=false;
               hengxianJJSkaicangBuy=false;
               hengxianJJSkaicangSell=false;
               return;
              }
            if(ObjectFind("Buy Line")==0)
              {
               ObjectDelete(0,"Buy Line");
               sellline=High[iHighest(NULL,0,MODE_HIGH,linebar,0)];
               SetLevel("Sell Line",sellline,ForestGreen);
               selllineOnTimer=Bid;
              }
            else
              {
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               buyline=Low[iLowest(NULL,0,MODE_LOW,linebar,0)];
               SetLevel("Buy Line",buyline,Red);
               buylineOnTimer=Bid;
              }
           }
         break;
         case 45://X jian
           {
            if(ltimeCurrent+3>=TimeCurrent())//
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(accountProfitswitch1==false)
                    {
                     accountProfitswitch1=true;

                     Print("以总利润多少计算 自动平仓 开启 薅羊毛 ","当前设置盈利 ",accountProfitmax1," 亏损 ",accountProfitmin1," 全平仓");
                     comment1(StringFormat("以订单总利润多少计算自动平仓 开启 薅羊毛 盈利%G亏损%G全平仓",accountProfitmax1,accountProfitmin1));
                     //  comment2(StringFormat("当前设置盈利%G亏损%G全平仓",accountProfitmax,accountProfitmin));
                     return;
                    }
                  else
                    {
                     accountProfitswitch1=false;
                     menu3[1]=false;
                     // accountProfitswitch=false;
                     Print("以订单总利润多少计算 自动平仓 薅羊毛 关闭");
                     comment1("以订单总利润多少计算 自动平仓 薅羊毛 关闭");
                     return;
                    }
                 }
               else
                 {
                  if(accountProfitswitch==false)
                    {
                     accountProfitswitch=true;

                     Print("以订单总利润多少计算 自动平仓 开启","当前设置盈利 ",accountProfitmax," 亏损 ",accountProfitmin," 全平仓");
                     comment1(StringFormat("以订单总利润多少计算自动平仓 开启 盈利%G亏损%G全平仓",accountProfitmax,accountProfitmin));
                     //  comment2(StringFormat("当前设置盈利%G亏损%G全平仓",accountProfitmax,accountProfitmin));
                     return;
                    }
                  else
                    {
                     accountProfitswitch=false;//
                     accountProfitswitch1=false;
                     menu3[0]=false;
                     menu3[1]=false;
                     if(ObjectFind(0,"zonglirun")==0)
                        ObjectDelete(0,"zonglirun");
                     if(ObjectFind(0,"zonglirun1")==0)
                        ObjectDelete(0,"zonglirun1");
                     Print("以订单总利润多少计算 自动平仓 关闭");
                     comment1("以订单总利润多少计算 自动平仓 关闭");
                     return;
                    }
                 }
              }
            else
              {

              }
            if(ObjectFind("SL Line")==0)
              {
               ObjectDelete(0,"SL Line");
              }
            else
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  slline=buyline-100*Point;
                  SetLevel("SL Line",slline,FireBrick);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  slline=sellline+100*Point;
                  SetLevel("SL Line",slline,FireBrick);
                 }
              }
           }
         break;
         case 31://S jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     ObjectMove(0,"Buy Line",0,Time[linebar],buyline-linepianyi*0.5*Point);
                     buyline=buyline-linepianyi*0.5*Point;
                     skey=false;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     ObjectMove(0,"Sell Line",0,Time[linebar],sellline-linepianyi*0.5*Point);
                     sellline=sellline-linepianyi*0.5*Point;
                     skey=false;
                    }
                 }
               else
                 {
                  if(ObjectFind("SL Line")==0)
                    {
                     if(ObjectFind("SL Line")==0)
                       {
                        ObjectMove(0,"SL Line",0,Time[linebar],slline-linepianyi1*Point);
                        slline=slline-linepianyi1*Point;
                        skey=false;
                       }
                    }
                  else
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        ObjectMove(0,"Buy Line",0,Time[linebar],buyline-linepianyi1*Point);
                        buyline=buyline-linepianyi1*Point;
                        skey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        ObjectMove(0,"Sell Line",0,Time[linebar],sellline-linepianyi1*Point);
                        sellline=sellline-linepianyi1*Point;
                        skey=false;
                       }
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
              }

            if(gtimeCurrent+1>=TimeCurrent() && gkey==true && skey)
              {
               Print("g=",gkey," s=",skey," 智能selllimit单 处理中. . .");
               comment(" 智能selllimit单 处理中. . .");
               zhinengguadanselllimit();
               gkey=false;
               skey=false;
              }
            else
               gkey=false;
           }
         break;
         case 44://Z jian
           {
            if(tabtimeCurrent+3>=TimeCurrent() && shifttimeCurrent+3>=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL1")==0 || ObjectFind("SellTrendLineSL1")==0)
                 {
                  ObjectDelete(0,"BuyTrendLineSL1");
                  ObjectDelete(0,"SellTrendLineSL1");
                  BuyTrendLineSL1=false;
                  SellTrendLineSL1=false;
                  BuyTrendLineSLtime=TimeCurrent()-1000000;
                  return;
                 }
               if(ObjectFind("BuyTrendLineSL2")==0 || ObjectFind("SellTrendLineSL2")==0)
                 {
                  ObjectDelete(0,"BuyTrendLineSL2");
                  ObjectDelete(0,"SellTrendLineSL2");
                  BuyTrendLineSL2=false;
                  SellTrendLineSL2=false;
                  BuyTrendLineSL2time=TimeCurrent()-1000000;
                  return;
                 }
               if(ObjectFind("BuyTrendLineSL3")==0 || ObjectFind("SellTrendLineSL3")==0)
                 {
                  ObjectDelete(0,"BuyTrendLineSL3");
                  ObjectDelete(0,"SellTrendLineSL3");
                  BuyTrendLineSL3=false;
                  SellTrendLineSL3=false;
                  BuyTrendLineSL3time=TimeCurrent()-1000000;
                  return;
                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////
            if(tabtimeCurrent+3>=TimeCurrent() && BuyTrendLineSL3time+20<TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL3")==0 || ObjectFind("SellTrendLineSL3")==0)
                 {
                  if(ObjectFind("BuyTrendLineSL1")==0 || ObjectFind("SellTrendLineSL1")==0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL1");
                     ObjectDelete(0,"SellTrendLineSL1");
                     BuyTrendLineSL1=false;
                     SellTrendLineSL1=false;
                     BuyTrendLineSLtime=TimeCurrent()-1000000;
                     return;
                    }
                  if(ObjectFind("BuyTrendLineSL2")==0 || ObjectFind("SellTrendLineSL2")==0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL2");
                     ObjectDelete(0,"SellTrendLineSL2");
                     BuyTrendLineSL2=false;
                     SellTrendLineSL2=false;
                     BuyTrendLineSL2time=TimeCurrent()-1000000;
                     return;
                    }
                  if(ObjectFind("BuyTrendLineSL3")==0 || ObjectFind("SellTrendLineSL3")==0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL3");
                     ObjectDelete(0,"SellTrendLineSL3");
                     BuyTrendLineSL3=false;
                     SellTrendLineSL3=false;
                     BuyTrendLineSL3time=TimeCurrent()-1000000;
                     return;
                    }
                 }

              }
            ////////////////////////////////////////////////////////////////////

            if(tabtimeCurrent+3>=TimeCurrent() && BuyTrendLineSL2time+21600>TimeCurrent() && BuyTrendLineSL2time+20<=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL3")<0 && ObjectFind("SellTrendLineSL3")<0)
                 {
                  BuyTrendLineSL3time=TimeCurrent();
                  BuyTrendLineSLjishu=5;
                  TrendLine("BuyTrendLineSL3",Time[5],Low[5]-pianyilingGlo,Time[0]+1000,Low[5]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损3");
                  return;
                 }
               else
                 {

                  if(ObjectFind("SellTrendLineSL3")<0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL3");
                     SellTrendLineSL3time=TimeCurrent();
                     SellTrendLineSLjishu=5;
                     TrendLine("SellTrendLineSL3",Time[5],High[5]+pianyilingGlo,Time[0]+1000,High[5]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损3");
                     return;
                    }
                  else
                    {
                     ObjectDelete(0,"SellTrendLineSL3");
                     BuyTrendLineSL3time=TimeCurrent()-100000;
                     return;
                    }
                 }

              }

            ////////////////////////////////////////////////////////////////////
            if(tabtimeCurrent+3>=TimeCurrent() && BuyTrendLineSLtime+21600>TimeCurrent() && BuyTrendLineSLtime+20<=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL2")<0 && ObjectFind("SellTrendLineSL2")<0)
                 {
                  BuyTrendLineSL2time=TimeCurrent();
                  BuyTrendLineSLjishu=5;
                  TrendLine("BuyTrendLineSL2",Time[5],Low[5]-pianyilingGlo,Time[0]+1000,Low[5]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损2");
                  return;
                 }
               else
                 {

                  if(ObjectFind("SellTrendLineSL2")<0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL2");
                     SellTrendLineSL2time=TimeCurrent();
                     SellTrendLineSLjishu=5;
                     TrendLine("SellTrendLineSL2",Time[5],High[5]+pianyilingGlo,Time[0]+1000,High[5]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损2");
                     return;
                    }
                  else
                    {
                     ObjectDelete(0,"SellTrendLineSL2");
                     BuyTrendLineSL2time=TimeCurrent()-100000;
                     return;
                    }
                 }

              }

            /////////////////////////////////////////////////////////////////
            if(tabtimeCurrent+3>=TimeCurrent() && BuyTrendLineSL2time+20<=TimeCurrent() && BuyTrendLineSL3time+20<=TimeCurrent())
              {
               if(ObjectFind("BuyTrendLineSL1")<0 && ObjectFind("SellTrendLineSL1")<0)
                 {
                  BuyTrendLineSLtime=TimeCurrent();
                  BuyTrendLineSLjishu=5;
                  TrendLine("BuyTrendLineSL1",Time[5],Low[5]-pianyilingGlo,Time[0]+1000,Low[5]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损1");
                  return;
                 }
               else
                 {

                  if(ObjectFind("SellTrendLineSL1")<0)
                    {
                     ObjectDelete(0,"BuyTrendLineSL1");
                     SellTrendLineSLtime=TimeCurrent();
                     SellTrendLineSLjishu=5;
                     TrendLine("SellTrendLineSL1",Time[5],High[5]+pianyilingGlo,Time[0]+1000,High[5]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损1");
                     return;
                    }
                  else
                    {
                     ObjectDelete(0,"SellTrendLineSL1");
                     BuyTrendLineSLtime=TimeCurrent()-100000;
                     return;
                    }
                 }

              }

            ////////////////////////////////////////////////////////////////////
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(shiftRtimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     if(buyline<Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("Buy单横线处设置统一止损 处理中... ");
                        comment("Buy单横线处设置统一止损 处理中...");
                        PiliangSL(true,NormalizeDouble(buyline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Buy单无法设置止损 或没有Buy单 ");
                        comment("红线处在当前价上方 Buy单无法设置止损 或没有Buy单");
                       }
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     if(sellline>Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("Sell单横线处设置统一止损 处理中... ");
                        comment("Sell单横线处设置统一止损 处理中...");
                        PiliangSL(false,NormalizeDouble(sellline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Sell单无法设置止损 或没有sell单 ");
                        comment("绿线处在当前价下方 Sell单无法设置止损 或没有sell单");
                       }
                    }
                 }
               else
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     if(buyline<Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("Buy单横线处设置止损 处理中... ");
                        comment("Buy单横线处设置止损 处理中...");
                        PiliangSL(true,NormalizeDouble(buyline,Digits),jianju07,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Buy单无法设置止损 或没有sell单 ");
                        comment("红线处在当前价上方 Buy单无法设置止损 或没有sell单");
                       }
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     if(sellline>Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("Sell单横线处设置止损 处理中... ");
                        comment("Sell单横线处设置止损 处理中...");
                        PiliangSL(false,NormalizeDouble(sellline,Digits),jianju07,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Sell单无法设置止损 或没有sell单 ");
                        comment("绿线处在当前价下方 Sell单无法设置止损 或没有sell单");
                       }
                    }
                 }
               lkey=false;
               zkey=false;
              }
            else
              {
               lkey=false;
              }
           }
         break;
         case 36://J jian
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars10,"根K线批量智能止损 处理中 . . . ");
               comment(StringFormat("多单计算最近%G根K线批量智能止损 处理中 . . . ",bars10));
               PiliangSL(true,GetiLowest(timeframe10,bars10,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars10,"根K线批量智能止损 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止损 处理中 . . . ",bars10));
               PiliangSL(false,GetiHighest(timeframe10,bars10,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print(" v=",vkey,"多单智能设置统一止损位 处理中 . . .");
               comment("多单智能设置统一止损位 处理中 . . . ");
               PiliangSL(true,GetiLowest(timeframe06,bars06,beginbar06)-MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju06,pianyiliang06,juxianjia06,dingdangeshu06);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print(" a=",akey,"空单智能设置统一止损位 处理中 . . .");
               comment("空单智能设置统一止损位 处理中 . . . ");
               PiliangSL(false,GetiHighest(timeframe06,bars06,beginbar06)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju06,pianyiliang06,juxianjia06,dingdangeshu06);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 37://K jian
           {
            if(mtimeCurrent+3>=TimeCurrent())//
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(dingshikaicang15)
                    {
                     dingshikaicang15=false;
                     dingshikaicanggeshu1=dingshikaicanggeshu;
                     Print("十五分钟K线收盘时直接开仓 关闭");
                     comment("十五分钟K线收盘时直接开仓 关闭 关闭");
                     kkey=false;
                     return;
                    }
                  else
                    {
                     dingshikaicang15=true;
                     dingshikaicanggeshu1=dingshikaicanggeshu+(rightpress-leftpress);
                     Print("十五分钟K线收盘时直接开仓 开启 次数",dingshikaicanggeshu1);
                     comment(StringFormat("十五分钟K线收盘时直接开仓 开启 次数%G",dingshikaicanggeshu1));
                     kkey=false;
                     return;
                    }
                 }
               else
                 {
                  if(dingshikaicang)
                    {
                     dingshikaicang=false;
                     dingshikaicang15=false;
                     dingshikaicanggeshu1=dingshikaicanggeshu;
                     Print("五分钟K线收盘时直接开仓 关闭");
                     comment("五分钟K线收盘时直接开仓 关闭");
                     kkey=false;
                     return;
                    }
                  else
                    {
                     dingshikaicang=true;
                     dingshikaicanggeshu1=dingshikaicanggeshu+(rightpress-leftpress);
                     Print("五分钟K线收盘时直接开仓 开启 次数",dingshikaicanggeshu1);
                     comment(StringFormat("五分钟K线收盘时直接开仓 开启 次数%G",dingshikaicanggeshu1));
                     kkey=false;
                     return;
                    }
                 }

              }
            if(ytimeCurrent+3>=TimeCurrent())//
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(yinyang5mkaicangshiftR)
                    {
                     yinyang5mkaicangshiftR=false;
                     Print("5分钟出现两根相同颜色的K线启动横线模式追单 关闭");
                     comment("5分钟出现两根相同颜色的K线启动横线模式追单 关闭");
                     kkey=false;
                     return;
                    }
                  else
                    {
                     yinyang5mkaicangshiftR=true;
                     yinyang5mkaicanggeshu1=yinyang5mkaicanggeshu+(rightpress-leftpress);
                     Print("5分钟出现两根相同颜色的K线启动横线模式追单 开启 次数",yinyang5mkaicanggeshu1);
                     comment(StringFormat("5分钟出现两根相同颜色的K线启动横线模式追单 开启 次数%G",yinyang5mkaicanggeshu1));
                     kkey=false;
                     return;
                    }
                 }
               else
                 {
                  if(yinyang5mkaicang)
                    {
                     yinyang5mkaicang=false;
                     yinyang5mkaicangshiftR=false;
                     Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 关闭");
                     comment("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 关闭");
                     kkey=false;
                     return;
                    }
                  else
                    {
                     yinyang5mkaicang=true;
                     yinyang5mkaicanggeshu1=yinyang5mkaicanggeshu+(rightpress-leftpress);
                     Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 开启 次数",yinyang5mkaicanggeshu1);
                     comment(StringFormat("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 开启 次数%G",yinyang5mkaicanggeshu1));
                     kkey=false;
                     return;
                    }
                 }

              }
            if(ltimeCurrent+2>=TimeCurrent())
              {
               if(tabtimeCurrent+2>=TimeCurrent())
                 {
                  if(menu[26]==false)
                    {
                     if(ObjectFind("Buy Line")==0 && linelock==false)
                       {
                        if(ObjectFind("SL Line")==0 && buyline>slline && slline<Bid && ObjectFind("BuySL2")<0)
                          {
                           menu[26]=true;
                           hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                           hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                           linelock=true;

                           menu224[0]=true;
                           ObjectCreate(0,"BuySL2",OBJ_HLINE,0,Time[0],slline,0);
                           ObjectSet("BuySL2",OBJPROP_COLOR,clrMaroon);
                           ObjectSetString(0,"BuySL2",OBJPROP_TOOLTIP," 越线等待几十秒 还越线 平最近下的几单 BuySL2");
                           ObjectDelete(0,"SL Line");
                           if(dingdanshu3<=9)
                             {
                              menu224_0geshu1=dingdanshu3;
                             }
                           else
                             {
                              menu224_0geshu1=hengxianJJSkaicanggeshu1;
                             }
                           Print("越线等待几十秒 还越线 平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                           comment1(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));


                           Print("渐进式触及横线开Buy单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1,"发现SL Line 同时启动 越线等待30s平仓");
                           comment2(StringFormat("渐进式触及横线开Buy单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                           tab=false;
                           return;
                          }
                        else
                          {
                           menu[26]=true;
                           hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                           hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                           linelock=true;
                           Print("渐进式触及横线开Buy单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                           comment2(StringFormat("渐进式触及横线开Buy单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                           tab=false;
                           return;
                          }

                       }
                     if(ObjectFind("Sell Line")==0 && linelock==false)
                       {
                        if(ObjectFind("SL Line")==0 && sellline<slline && slline>Bid && ObjectFind("SellSL2")<0)
                          {
                           menu[26]=true;
                           hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                           hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                           linelock=true;

                           menu224[0]=true;
                           ObjectCreate(0,"SellSL2",OBJ_HLINE,0,Time[0],slline,0);
                           ObjectSet("SellSL2",OBJPROP_COLOR,clrMaroon);
                           ObjectSetString(0,"SellSL2",OBJPROP_TOOLTIP," 越线等待几十秒 还越线 平最近下的几单 BuySL2");
                           ObjectDelete(0,"SL Line");
                           if(dingdanshu3<=9)
                             {
                              menu224_0geshu1=dingdanshu3;
                             }
                           else
                             {
                              menu224_0geshu1=hengxianJJSkaicanggeshu1;
                             }
                           Print("越线等待几十秒 还越线 平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                           comment1(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));

                           Print("渐进式触及横线开Sell单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                           comment2(StringFormat("渐进式触及横线开Sell单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                           tab=false;
                           return;
                          }
                        else
                          {
                           menu[26]=true;
                           hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                           hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                           linelock=true;
                           Print("渐进式触及横线开Sell单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                           comment2(StringFormat("渐进式触及横线开Sell单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                           tab=false;
                           return;
                          }
                       }
                    }
                  else
                    {
                     menu[26]=false;
                     if(menu224_0geshu1==hengxianJJSkaicanggeshu1)
                       {
                        menu224[0]=false;
                        ObjectDelete(0,"BuySL2");
                        ObjectDelete(0,"SellSL2");
                        menu224_0geshu1=menu224_0geshu;
                       }
                     hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                     hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                     linelock=false;
                     Print("渐进式触及横线开仓 关闭 ");
                     comment2("渐进式触及横线开仓 关闭 ");
                     ObjectDelete(0,"Buy Line");
                     ObjectDelete(0,"Sell Line");
                     ObjectDelete(0,"SL Line");
                     hengxianJJSkaicangBuy=false;
                     hengxianJJSkaicangSell=false;
                     tab=false;
                     return;
                    }
                 }
               if(ObjectFind("Buy Line")==0 && linebuykaicang==false)
                 {
                  //Print(shiftRtimeCurrent," ",TimeCurrent());
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     linekaicangshiftR=true;
                     linebuykaicang=true;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR+(rightpress-leftpress);
                     timeseconds1=timeseconds1P+(shangpress-xiapress);
                     linelock=true;
                     Print("触及横线开Buy单 开启 参考价格和时间 开仓",huaxiankaicanggeshuR1,"次");
                     comment(StringFormat("触及横线开Buy单 开启 越过价格%G开仓 间隔%G秒 开仓%G次",buyline,timeseconds1,huaxiankaicanggeshuR1));
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        linebuykaicang=true;
                        linekaicangT=true;
                        huaxiankaicanggeshuT1=huaxiankaicanggeshuT+(rightpress-leftpress);
                        huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
                        if(huaxiankaicangtimeTP<0)
                           huaxiankaicangtimeTP=0;
                        shangpress=0;
                        xiapress=0;
                        linelock=true;
                        Print("触及横线开Buy单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                        comment(StringFormat("触及不带止损开Buy单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));
                        ctrlR=false;
                       }
                     else
                       {
                        if(ObjectFind(0,"SL Line")==0)
                          {
                           linebuykaicang=true;
                           linekaicangT=true;
                           huaxiankaicanggeshuT1=huaxiankaicanggeshuT+(rightpress-leftpress);
                           huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
                           if(huaxiankaicangtimeTP<0)
                              huaxiankaicangtimeTP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                           comment(StringFormat("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓%G次",huaxiankaicanggeshuT1));
                          }
                        else
                          {
                           if(ctrltimeCurrent+3>=TimeCurrent())
                             {
                              linebuykaicang=true;
                              linekaicangctrl=true;
                              huaxiankaicanggeshu1=huaxiankaicanggeshu+(rightpress-leftpress);
                              linelock=true;
                              Print("触及横线开Buy单 开启 只开一次 提前按右方向键增加仓位 开仓",huaxiankaicanggeshu1*keylots,"手");
                              comment(StringFormat("触及横线开Buy单开启 只开一次 按右方向键增加仓位 开仓%G手",huaxiankaicanggeshu1*keylots));
                             }
                           else
                             {
                              linebuykaicang=true;
                              huaxiankaicanggeshu1=huaxiankaicanggeshu+(rightpress-leftpress);
                              huaxiankaicangtimeP=huaxiankaicangtime+(shangpress-xiapress)*1000;
                              if(huaxiankaicangtimeP<0)
                                 huaxiankaicangtimeP=0;
                              shangpress=0;
                              xiapress=0;
                              linelock=true;
                              Print("触及横线开Buy单 开启 只参考时间 开仓",huaxiankaicanggeshu1,"次");
                              comment(StringFormat("触及横线开Buy单 开启 只参考时间开仓间隔%G毫秒 开仓%G次",huaxiankaicangtimeP,huaxiankaicanggeshu1));
                             }
                          }

                       }
                    }
                 }
               else
                 {
                  if(linebuykaicang)
                    {
                     linebuykaicang=false;
                     linekaicangshiftR=false;
                     linekaicangT=false;
                     linekaicangctrl=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     huaxiankaicanggeshu1=huaxiankaicanggeshu;
                     huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
                     timeseconds1=timeseconds1P;
                     linelock=false;
                     Print("触及横线开Buy单 关闭");
                     comment("触及横线开Buy单 关闭");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellkaicang==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     linekaicangshiftR=true;
                     linesellkaicang=true;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR+(rightpress-leftpress);
                     timeseconds1=timeseconds1P+(shangpress-xiapress);
                     linelock=true;
                     Print("触及横线开Sell单 开启 参考价格和时间 开仓",huaxiankaicanggeshuR1,"次");
                     comment(StringFormat("触及横线开Sell单 开启 越过价格%G开仓 间隔%G秒 开仓%G次",sellline,timeseconds1,huaxiankaicanggeshuR1));
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        linesellkaicang=true;
                        linekaicangT=true;
                        huaxiankaicanggeshuT1=huaxiankaicanggeshuT+(rightpress-leftpress);
                        huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
                        if(huaxiankaicangtimeTP<0)
                           huaxiankaicangtimeTP=0;
                        shangpress=0;
                        xiapress=0;
                        linelock=true;
                        Print("触及横线开sell单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                        comment(StringFormat("触及不带止损开sell单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));
                        ctrlR=false;
                       }
                     else
                       {
                        if(ObjectFind(0,"SL Line")==0)
                          {
                           linesellkaicang=true;
                           linekaicangT=true;
                           huaxiankaicanggeshuT1=huaxiankaicanggeshuT+(rightpress-leftpress);
                           huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
                           if(huaxiankaicangtimeTP<0)
                              huaxiankaicangtimeTP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Sell单止损线止损 开启 参考时间和价格 开仓",huaxiankaicanggeshuT1,"次");
                           comment(StringFormat("触及横线开Sell单止损线止损 开启 参考时间和价格 开仓%G次",huaxiankaicanggeshuT1));
                          }
                        else
                          {
                           if(ctrltimeCurrent+3>=TimeCurrent())
                             {
                              linesellkaicang=true;
                              linekaicangctrl=true;
                              huaxiankaicanggeshu1=huaxiankaicanggeshu+(rightpress-leftpress);
                              linelock=true;
                              Print("触及横线开sell单 开启 只开一次 提前按右方向键增加仓位 开仓",huaxiankaicanggeshu1*keylots,"手");
                              comment(StringFormat("触及横线开sell单开启 只开一次 按右方向键增加仓位 开仓%G手",huaxiankaicanggeshu1*keylots));
                             }
                           else
                             {
                              linesellkaicang=true;
                              huaxiankaicanggeshu1=huaxiankaicanggeshu+(rightpress-leftpress);
                              huaxiankaicangtimeP=huaxiankaicangtime+(shangpress-xiapress)*1000;
                              if(huaxiankaicangtimeP<0)
                                 huaxiankaicangtimeP=0;
                              shangpress=0;
                              xiapress=0;
                              linelock=true;
                              Print("触及横线开Sell单 开启 只参考时间 开仓",huaxiankaicanggeshu1,"次");
                              comment(StringFormat("触及横线开Sell单 开启 只参考时间开仓间隔%G毫秒 开仓%G次",huaxiankaicangtimeP,huaxiankaicanggeshu1));
                             }
                          }
                       }
                    }
                 }
               else
                 {
                  if(linesellkaicang)
                    {
                     linesellkaicang=false;
                     linekaicangshiftR=false;
                     linekaicangT=false;
                     linekaicangctrl=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     huaxiankaicanggeshu1=huaxiankaicanggeshu;
                     huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
                     timeseconds1=timeseconds1P;
                     linelock=false;
                     Print("触及横线开Sell单 关闭");
                     comment("触及横线开Sell单 关闭");
                    }
                 }
               lkey=false;
               kkey=false;
              }
            else
              {
               lkey=false;
              }
           }
         break;
         case 23://I j
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars10,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("多单计算最近%G根K线批量智能止盈 处理中 . . . ",bars10));
               PiliangTP(true,GetiHighest(timeframe10,bars10,beginbar10)+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars10,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止盈 处理中 . . . ",bars10));
               PiliangTP(false,GetiLowest(timeframe10,bars10,beginbar10)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp10)*Point+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print(" v=",vkey,"多单智能设置统一止盈位 处理中 . . .");
               comment("多单智能设置统一止盈位 处理中 . . . ");
               PiliangTP(true,GetiHighest(timeframe06,bars06,beginbar06)+press(),jianju06,pianyiliang06tp,juxianjia06,dingdangeshu06);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print(" a=",akey,"空单智能设置统一止盈位 处理中 . . .");
               comment("空单智能设置统一止盈位 处理中 . . . ");
               PiliangTP(false,GetiLowest(timeframe06,bars06,beginbar06)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp06)*Point+press(),jianju06,pianyiliang06tp,juxianjia06,dingdangeshu06);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 22://U j
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars1010,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("多单计算最近%G根K线批量智能止盈 处理中 . . . ",bars1010));
               PiliangTP(true,GetiHighest(timeframe10,bars1010,beginbar10)+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars1010,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止盈 处理中 . . . ",bars1010));
               PiliangTP(false,GetiLowest(timeframe10,bars1010,beginbar10)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp10)*Point+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey," 多单批量智能计算在结果的基础上减去点差再加上",pianyiliang05tp,"点止盈 处理中 . . .");
               comment(StringFormat("多单批量智能计算在结果的基础上减去点差再减去%G点止盈 处理中 . . .",pianyiliang05tp));
               PiliangTP(true,GetiHighest(timeframe05,bars05,beginbar05)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05tp,juxianjia05,dingdangeshu05);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey," 空单批量智能计算在结果的基础上加上点差再加上",pianyiliang05tp,"点止盈 处理中 . . .");
               comment(StringFormat("空单批量智能计算在结果的基础上加上点差再加上%G点止盈 处理中 . . .",pianyiliang05tp));
               PiliangTP(false,GetiLowest(timeframe05,bars05,beginbar05)+MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05tp,juxianjia05,dingdangeshu05);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 35://H j
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0 && linebuyzidongjiacang==false)
                 {
                  if(shiftR)
                    {
                     /*
                                          linekaicangshiftR=true;
                                          linebuykaicang=true;
                                          linelock=true;
                                          Print("触及横线开Buy单 开启 只参考价格");
                                          comment("触及横线开Buy单 开启 只参考价格");
                                          shiftR=false;*/
                    }
                  else
                    {
                     linebuyzidongjiacang=true;
                     linelock=true;
                     Print("五分钟自动加仓Buy单 开启 ");
                     comment("五分钟自动加仓Buy单 开启 ");
                    }
                 }
               else
                 {
                  if(linebuyzidongjiacang)
                    {
                     linebuyzidongjiacang=false;
                     linelock=false;
                     huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
                     huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
                     lineTime=false;
                     linetime=0;
                     linefirsttime=true;
                     Print("五分钟自动加仓Buy单 关闭");
                     comment("五分钟自动加仓Buy单 关闭");
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellkaicang==false)
                 {
                  if(shiftR)
                    {
                     /*
                                          linekaicangshiftR=true;
                                          linesellkaicang=true;
                                          linelock=true;
                                          Print("触及横线开Sell单 开启 只参考价格");
                                          comment("触及横线开Sell单 开启 只参考价格");
                                          shiftR=false;*/
                    }
                  else
                    {
                     linesellzidongjiacang=true;
                     linelock=true;
                     Print("五分钟自动加仓Sell单 开启");
                     comment("五分钟自动加仓Sell单 开启");
                    }
                 }
               else
                 {
                  if(linesellzidongjiacang)
                    {
                     linesellzidongjiacang=false;
                     linelock=false;
                     Print("五分钟自动加仓Sell单 关闭");
                     comment("五分钟自动加仓Sell单 关闭");
                     huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
                     huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
                     lineTime=false;
                     linetime=0;
                     linefirsttime=true;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
               lkey=false;
              }
            else
              {
               lkey=false;
              }
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars1010,"根K线批量智能止损 处理中 . . . ");
               comment(StringFormat("多单计算最近%G根K线批量智能止损 处理中 . . . ",bars1010));
               PiliangSL(true,GetiLowest(timeframe10,bars1010,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars1010,"根K线批量智能止损 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止损 处理中 . . . ",bars1010));
               PiliangSL(false,GetiHighest(timeframe10,bars1010,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey," 多单批量智能计算在结果的基础上减去点差再减去",pianyiliang05,"点止损 处理中 . . .");
               comment(StringFormat("多单批量智能计算在结果的基础上减去点差再减去%G点止损 处理中 . . .",pianyiliang05));
               PiliangSL(true,GetiLowest(timeframe05,bars05,beginbar05)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05,juxianjia05,dingdangeshu05);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey," 空单批量智能计算在结果的基础上加上点差再加上",pianyiliang05,"点止损 处理中 . . .");
               comment(StringFormat("空单批量智能计算在结果的基础上加上点差再加上%G点止损 处理中 . . .",pianyiliang05));
               PiliangSL(false,GetiHighest(timeframe05,bars05,beginbar05)+MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05,juxianjia05,dingdangeshu05);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 53://"? / 键" / j  主键盘
           {
            if(menu[28] && menu6[0]==false && menu6[1]==false)
              {
               if(ObjectFind(0,"zi4")>=0)
                 {
                  a12pingcangpianyi=a12pingcangpianyi*2;
                  Print("策略性平仓 回撤后 重新开仓 回撤距离恢复正常 ",a12pingcangpianyi);
                  comment4(StringFormat("策略性平仓 回撤后 重新开仓 回撤距离恢复正常 %G 基点",a12pingcangpianyi));
                  return;
                 }
               else
                 {
                  a12pingcangpianyi=a12pingcangpianyi/2;
                  Print("策略性平仓 回撤后 重新开仓 回撤距离减半 ",a12pingcangpianyi);
                  comment4(StringFormat("策略性平仓 回撤后 重新开仓 回撤距离减半 %G 基点",a12pingcangpianyi));
                  return;
                 }
              }
            if(menu6[0])
              {
               if(ObjectFind(0,"dxzdBuyi2kSL")>=0)
                 {
                  ObjectDelete(0,"dxzdBuyi2kSL");
                  ObjectDelete(0,"dxzdBuyi2kSL1");
                  Print("短线追Buy单 手动取消最近的一根止损线");
                  comment4("短线追Buy单 手动取消最近的一根止损线");
                 }
               else
                 {
                  if(ObjectFind(0,"dxzdBuyi3kSL")>=0)
                    {
                     ObjectDelete(0,"dxzdBuyi3kSL");
                     ObjectDelete(0,"dxzdBuyi3kSL1");
                     Print("短线追Buy单 手动取消第二根止损线");
                     comment4("短线追Buy单 手动取消第二根止损线");
                    }
                  else
                    {
                     if(ObjectFind(0,"dxzdBuyi4kSL")>=0)
                       {
                        ObjectDelete(0,"dxzdBuyi4kSL");
                        ObjectDelete(0,"dxzdBuyi4kSL1");
                        Print("短线追Buy单 手动取消第三根止损线");
                        comment4("短线追Buy单 手动取消第三根止损线");
                       }
                    }
                 }
               return;
              }
            if(menu6[1])
              {
               if(ObjectFind(0,"dxzdSelli2kSL")>=0)
                 {
                  ObjectDelete(0,"dxzdSelli2kSL");
                  ObjectDelete(0,"dxzdSelli2kSL1");
                  Print("短线追Sell单 手动取消最近的一根止损线");
                  comment4("短线追Sell单 手动取消最近的一根止损线");
                 }
               else
                 {
                  if(ObjectFind(0,"dxzdSelli3kSL")>=0)
                    {
                     ObjectDelete(0,"dxzdSelli3kSL");
                     ObjectDelete(0,"dxzdSelli3kSL1");
                     Print("短线追Sell单 手动取消第二根止损线");
                     comment4("短线追Sell单 手动取消第二根止损线");
                    }
                  else
                    {
                     if(ObjectFind(0,"dxzdSelli4kSL")>=0)
                       {
                        ObjectDelete(0,"dxzdSelli4kSL");
                        ObjectDelete(0,"dxzdSelli4kSL1");
                        Print("短线追Sell单 手动取消第三根止损线");
                        comment4("短线追Sell单 手动取消第三根止损线");
                       }
                    }
                 }
               return;
              }
            huaxianguadanlotsT=MathFloor(huaxianguadanlots*0.5/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
            keylotshalf=keylotshalfT;
            Print("挂单默认仓位减半 本提示消失仓位恢复");
            comment(StringFormat("挂单默认仓位减半 %G 手 本提示消失仓位恢复 ",huaxianguadanlotsT));
           }
         break;
         case 83://小键盘 小数点 . j
           {

            if(SL5QTPtimeCurrenttrue)
              {
               if(SLQlotsT==SLQlots)
                 {
                  SLQlotsT=SLQlots*2;
                  Print("小键盘 *键 双倍手数开仓");
                  comment("小键盘 *键 双倍手数开仓");
                  return;
                 }
               else
                 {
                  SLQlotsT=SLQlots;
                  Print("小键盘 *键 恢复正常手数开仓");
                  comment("小键盘 *键 恢复正常手数开仓");
                  return;
                 }
              }
            if(keylots==defaultlots)
              {
               keylots=defaultlots*0.5;
               Print("小键盘9 6下单 手数减半");
               comment5("小键盘9 6下单 手数减半");
              }
            else
              {
               keylots=defaultlots;
               Print("小键盘9 6下单 恢复默认手数");
               comment5("小键盘9 6下单 恢复默认手数");
              }
           }
         break;
         default:
            break;
        }
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(StrToInteger(sparam)==buykey)//市价买一单
        {
         if(tabtimeCurrent+1>=TimeCurrent() && f5lots!=0.0)
           {
            Print("根据最近记录的仓位 Buy一单 F5查看");
            comment1("根据最近记录的仓位 Buy一单 F5查看");
            int keybuy=OrderSend(Symbol(),OP_BUY,f5lots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
              {
               PlaySound("ok.wav");
              }
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
            return;
           }
         if(menu1[14])
           {
            if(shiftRtimeCurrent+180>=TimeCurrent())
              {
               Print("取一分钟图表计算 Buy一单");
               buysellnowSL(true,keylotshalf,1,bars0971,beginbar09,buypianyiliang);
              }
            else
              {
               buysellnowSL(true,keylotshalf,timeframe09,bars0971,beginbar09,buypianyiliang);
              }

           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价买一单 处理中 . . .");
            comment("市价买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
           }
        }
      if(StrToInteger(sparam)==sellkey)
        {
         if(tabtimeCurrent+1>=TimeCurrent() && f5lots!=0.0)
           {
            Print("根据最近记录的仓位 Buy一单 F5查看");
            comment1("根据最近记录的仓位 Buy一单 F5查看");
            int keybuy=OrderSend(Symbol(),OP_SELL,f5lots,Bid,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
              {
               PlaySound("ok.wav");
              }
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
            return;
           }
         if(menu1[14])
           {
            if(shiftRtimeCurrent+180>=TimeCurrent())
              {
               Print("取一分钟图表计算 Sell一单");
               buysellnowSL(false,keylotshalf,1,bars0971,beginbar09,sellpianyiliang);
              }
            else
              {
               buysellnowSL(false,keylotshalf,timeframe09,bars0971,beginbar09,sellpianyiliang);
              }

           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价卖一单 处理中 . . .");
            comment("市价卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
           }
        }
      if(StrToInteger(sparam)==buykeydouble)
        {
         if(menu1[14])
           {
            buysellnowSL(true,keylotshalf*2,timeframe09,bars0971,beginbar09,buypianyiliang);
           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价双倍买一单 处理中 . . .");
            comment("市价双倍买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots*2,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==sellkeydouble)
        {
         if(menu1[14])
           {
            buysellnowSL(false,keylotshalf*2,timeframe09,bars0971,beginbar09,sellpianyiliang);
           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价双倍卖一单 处理中 . . .");
            comment("市价双倍卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots*2,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==buykey3)
        {
         if(menu1[14])
           {
            buysellnowSL(true,keylotshalf*3,timeframe09,bars0971,beginbar09,buypianyiliang);
           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价三倍仓位买一单 处理中 . . .");
            comment("市价三倍仓位买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots*3,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==sellkey3)
        {
         if(menu1[14])
           {
            buysellnowSL(false,keylotshalf*3,timeframe09,bars0971,beginbar09,sellpianyiliang);
           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价三倍仓位卖一单 处理中 . . .");
            comment("市价三倍仓位卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots*3,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==zuidaclose)
        {
         Print("平价格最高的一单 处理中 . . .");
         comment("平价格最高的一单 处理中 . . .");
         zuidakeyclose();
         return;
        }
      if(StrToInteger(sparam)==zuixiaoclose)
        {
         Print("平价格最低的一单 处理中 . . .");
         comment("平价格最低的一单 处理中 . . .");
         zuixiaokeyclose();
        }
      if(StrToInteger(sparam)==zuizaoclose)
        {
         Print("平最早下的一单 处理中 . . .");
         comment("平最早下的一单 处理中 . . .");
         zuizaokeyclose();
        }
      if(StrToInteger(sparam)==zuijinclose)
        {
         Print("平最近下的一单 处理中 . . .");
         comment("平最近下的一单 处理中 . . .");
         zuijinkeyclose();
        }

      if(StrToInteger(sparam)==8225)//Ctrl+Alt+F 一键反手
        {
         yijianfanshou();
        }
      if(StrToInteger(sparam)==8529)//Ctrl+Alt+PageDown
        {
         Print("平最近下的一Buy单 处理中 . . .");
         comment("平最近下的一Buy单 处理中 . . .");
         zuijinBuyclose();
         return;
        }
      if(StrToInteger(sparam)==8527)//Ctrl+Alt+End
        {
         Print("平最近下的一Sell单 处理中 . . .");
         comment("平最近下的一Sell单 处理中 . . .");
         zuijinSellclose();
         return;
        }
      if(StrToInteger(sparam)==8263)//Ctrl+Alt+小键盘7
        {
         buysellnowSL(true,keylotshalf*3,timeframe09,bars097,beginbar09,buypianyiliang);
        }
      if(StrToInteger(sparam)==8264)//Ctrl+Alt+小键盘8
        {
         buysellnowSL(true,keylotshalf*2,timeframe09,bars097,beginbar09,buypianyiliang);
        }
      if(StrToInteger(sparam)==8267)//Ctrl+Alt+小键盘4
        {
         buysellnowSL(false,keylotshalf*3,timeframe09,bars097,beginbar09,sellpianyiliang);
        }
      if(StrToInteger(sparam)==8268)//Ctrl+Alt+小键盘5
        {
         buysellnowSL(false,keylotshalf*2,timeframe09,bars097,beginbar09,sellpianyiliang);
        }
      if(StrToInteger(sparam)==8265)//Ctrl+Alt+小键盘9
        {
         buysellnowSL(true,keylotshalf,timeframe09,bars096,beginbar09,buypianyiliang9);
        }
      if(StrToInteger(sparam)==8269)//Ctrl+Alt+小键盘6
        {
         buysellnowSL(false,keylotshalf,timeframe09,bars096,beginbar09,sellpianyiliang6);
        }
      if(StrToInteger(sparam)==baobenSL)
        {
         Print("批量移动止损到保本线上 处理中 . . .");
         comment("批量移动止损到保本线上 处理中 . . .");
         double baobenbuySL=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits);
         double baobensellSL=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits);
         if(bkey)
            buybaobenture=true;
         if(skey)
            sellbaobenture=true;
         for(int  i=0; i<OrdersTotal(); i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  if(sellbaobenture)
                    { }
                  else
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobenbuySL,OrderTakeProfit(),0);
                    }
                 }
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 {
                  if(buybaobenture)
                     break;
                  bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobensellSL,OrderTakeProfit(),0);
                 }
              }
           }
         PlaySound("ok.wav");
         buybaobenture=false;
         sellbaobenture=false;
        }
      if(StrToInteger(sparam)==baobenTP)
        {
         Print("批量移动止盈到保本线上 处理中 . . .");
         comment("批量移动止盈到保本线上 处理中 . . .");
         double baobenbuyTP=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits);
         double baobensellTP=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits);
         if(bkey)
            buybaobenture=true;
         if(skey)
            sellbaobenture=true;
         for(int  i=0; i<OrdersTotal(); i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  if(sellbaobenture)
                    { }
                  else
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobenbuyTP,0);
                    }
                 }
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 {
                  if(buybaobenture)
                     break;
                  bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobensellTP,0);
                 }
              }
           }
         PlaySound("ok.wav");
         buybaobenture=false;
         sellbaobenture=false;
        }
      if(StrToInteger(sparam)==20)//T
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂BuyLimit单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂BuyLimit单 处理中 . . .");
            Guadanbuylimit(Guadanlots1,GetiLowest(0,Guadanprice41,0)+Guadanbuylimitpianyiliang1*Point+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishubuylimit1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==31)//S
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂SellLimit单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂SellLimit单 处理中 . . .");
            Guadanselllimit(Guadanlots1,GetiHighest(0,Guadanprice41,0)-Guadanselllimitpianyiliang1*Point-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishuselllimit1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==25)//
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂BuyStop单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂BuyStop单 处理中 . . .");
            Guadanbuystop(Guadanlots1,GetiHighest(0,Guadanprice41,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==38)//
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂SellStop单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂SellStop单 处理中 . . .");
            Guadansellstop(Guadanlots1,GetiLowest(0,Guadanprice41,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==34)//G 平挂单
        {

         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("批量平挂单 处理中 . . .");
            comment("批量平挂单 处理中 . . .");
            pingguadan();
            shift=false;
            shifttimeCurrent=shifttimeCurrent-500;
           }
         else
            shift=false;
        }


      if(StrToInteger(sparam)==yijianPingcang)
        {
         Print("一键平仓 处理中 . . .");
         comment("一键平仓 处理中 . . .");
         xunhuanquanpingcang();
         ctrl=false;
        }
      if(StrToInteger(sparam)==8240)
        {
         Print("一键平buy单 处理中 . . .");
         comment("一键平buy单 处理中 . . .");
         yijianpingbuydan();
         ctrl=false;
        }
      if(StrToInteger(sparam)==8223)
        {
         Print("一键平sell单 处理中 . . .");
         comment("一键平sell单 处理中 . . .");
         yijianpingselldan();
         ctrl=false;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()//ttt
  {
// datetime time1=ObjectGet("BuyTrendLineSL1",OBJPROP_TIME1);
// double price1=ObjectGet("BuyTrendLineSL1",OBJPROP_PRICE1);
//string Text1=ObjectGetString(0,"BuyTrendLineSL1",OBJPROP_TOOLTIP,0);

//Print((datetime)ObjectGet("BuyTrendLineSL1",OBJPROP_TIME1));
////Print((int)(TimeLocal()-TimeCurrent())/3600);
//Print(IsVisualMode());
// Print("Close[1]=",Close[1]," Low[1]=",Low[1]);
//Print(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0));
//Print(StrToInteger(DoubleToStr(CGetbuyLots()/keylots)));
//Print(" lpriceK0=",lpriceK[0]," lpriceK1=",lpriceK[1]," lpriceK2=",lpriceK[2]);
// Print(lpriceK[ArrayMinimum(lpriceK,3,0)]," lpriceK0=",lpriceK[0]," lpriceK1=",lpriceK[1]," lpriceK2=",lpriceK[2]);
//Print(PeriodSeconds());
// bool xxx= ObjectCreate(0,"xxx",OBJ_TREND,0,Time[1],Close[1],Time[10],Close[10]);
//int xyz=ObjectFind("BreakOut Box:TrendHigh");
//Print(ObjectFind("BreakOut Box:TrendHigh"));
//  Print(ObjectFind("TrendHigh"));
// Print(ObjectFind(0,"BreakOut Box:TrendHigh"));
// Print(NormalizeDouble(iCustom(NULL,0,"震荡突破",0,0),4));
// Print(ObjectFind(0,"BreakOut Box:AAA-Panel01"));
// Print(ObjectFind("BreakOut Box: TrendingDown"));
//  double x=ObjectGet("BreakOut Box: TrendingDown",OBJPROP_PRICE1);
//    Print("找到"," ",x," ",GetLastError());
//Print(ObjectFind(1,"gfdgfdgfd"));
//Print(-accountProfitmin,"  ",AccountProfit());
//Print(ctrlRtimeCurrent," ",TimeCurrent());
//Print("timertrue=",timertrue);
//Print("TICK ",TimeGMT());
//Print("Time ",AccountProfit());

//Print(StrToInteger(DoubleToStr(CGetsellLots()/keylots)));
//Print(TimeCurrent()+20);
///////////////////////////////////////////////////////////////////////////////////////
//double mbfx=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",7,0.0,0,0),4);
//Print(iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0));
//Print(NormalizeDouble(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0),2));//参数第五位是计算最近多少根K线
//Print(iCustom(NULL,0,"Custom/XU v4-Breakout",0,0,0,0,50,1,0));//参数第五位是计算最近多少根K线



//////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
   if(EAswitch==false)//
     {
      return;
     }
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////
   if(menu[26])
     {
      if(ObjectFind(0,"Buy Line")==0 && linelock && hengxianJJSkaicangpianyi1>=0)
        {
         if(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)>=Bid)
           {
            Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
              {
               PlaySound("ok.wav");
               ObjectMove(0,"Buy Line",0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)-hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Buy Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
           }
        }
      if(ObjectFind(0,"Buy Line")==0 && linelock && hengxianJJSkaicangpianyi1<0)
        {
         if(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)<=Bid && hengxianJJSkaicangBuy)
           {
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
              {
               PlaySound("ok.wav");
               ObjectMove(0,"Buy Line",0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)-hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  hengxianJJSkaicangBuy=false;
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Buy Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }
           }
         if(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)>=Bid && hengxianJJSkaicangBuy==false)//运行一次
           {
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
              {
               hengxianJJSkaicangBuy=true;
               PlaySound("ok.wav");
               ObjectMove(0,"Buy Line",0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)-hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Buy Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }
           }
        }
      ////////////////////////////////////////////////////////
      if(ObjectFind(0,"Sell Line")==0 && linelock && hengxianJJSkaicangpianyi1>=0)
        {
         if(ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)<=Bid)
           {
            Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
              {
               PlaySound("ok.wav");
               ObjectMove(0,"Sell Line",0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)+hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Sell Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
           }
        }
      ////////////////////////////////////////////////////////
      if(ObjectFind(0,"Sell Line")==0 && linelock && hengxianJJSkaicangpianyi1<0)
        {
         if(ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)>=Bid && hengxianJJSkaicangSell)
           {
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
              {
               PlaySound("ok.wav");
               ObjectMove(0,"Sell Line",0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)+hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  hengxianJJSkaicangSell=false;
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Sell Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }

           }
         if(ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)<=Bid && hengxianJJSkaicangSell==false)//运行一次
           {
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
              {
               hengxianJJSkaicangSell=true;
               PlaySound("ok.wav");
               ObjectMove(0,"Sell Line",0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)+hengxianJJSkaicangpianyi1*Point);
               hengxianJJSkaicanggeshu1--;
               Print("渐进式触及横线开仓开始  剩余次数 ",hengxianJJSkaicanggeshu1);
               if(hengxianJJSkaicanggeshu1<=0)
                 {
                  menu[26]=false;
                  hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
                  hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
                  linelock=false;
                  ObjectDelete(0,"Sell Line");
                  Print("渐进式触及横线开仓 关闭 ");
                  comment4("渐进式触及横线开仓 关闭 ");
                 }
              }

           }
        }
     }
/////////////////////////////////////////////////////////5分钟收盘时 运行一次 开始
//////////////////////////////////////
   if(kaiguan5m && kaiguan5mtime+180<TimeCurrent()) //5分钟收盘时 运行一次 延迟 0s 启动 5min0 5min
     {
      int m=TimeMinute(TimeCurrent());
      if(m==5 || m==10 || m==15 || m==20 || m==25 || m==30 || m==35|| m==40|| m==45 || m==50|| m==55|| m==0)
        {
         if(TimeSeconds(TimeCurrent())>=0)
           {
            ///////////////////////////////

            // Print("kaiguan5m 0=",TimeCurrent()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan5mtime=TimeCurrent();
           }
        }
     }
   if(kaiguan15m && kaiguan15mtime+750<TimeCurrent())//15分钟收盘时 运行一次 延迟 0s 启动 15min0 15min
     {
      int m=TimeMinute(TimeCurrent());
      if(m==15 || m==30 || m==45 || m==0)
        {
         if(TimeSeconds(TimeCurrent())>=0)
           {
            ///////////////////////////////

            //  Print("kaiguan15m 0=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan15mtime=TimeCurrent();
           }
        }
     }
////////////////////////////////////
   if(kaiguan5m1 && kaiguan5m1time+240<TimeCurrent()) //
     {
      int m=TimeMinute(TimeCurrent());
      if(m==5 || m==10 || m==15 || m==20 || m==25 || m==30 || m==35|| m==40|| m==45 || m==50|| m==55|| m==0)
        {
         if(TimeSeconds(TimeCurrent())>=3)
           {
            if(iOpen(NULL,0,1)<iClose(NULL,0,1))
              {
               yinyang5m1k=true;
              }
            else
              {
               yinyang5m1k=false;
              }
            if(iOpen(NULL,0,2)<iClose(NULL,0,2))
              {
               yinyang5m2k=true;
              }
            else
              {
               yinyang5m2k=false;
              }
            if(iOpen(NULL,0,3)<iClose(NULL,0,3))
              {
               yinyang5m3k=true;
              }
            else
              {
               yinyang5m3k=false;
              }
            if(iOpen(NULL,0,4)<iClose(NULL,0,4))
              {
               yinyang5m4k=true;
              }
            else
              {
               yinyang5m4k=false;
              }
            if(iOpen(NULL,0,5)<iClose(NULL,0,5))
              {
               yinyang5m5k=true;
              }
            else
              {
               yinyang5m5k=false;
              }
            //Print(iOpen(NULL,0,1)," ",iClose(NULL,0,1)," ",yinyang5m1k," ",TimeCurrent());
            //Print("5分钟收盘运行一次 准确运行时间",TimeLocal());
            ////////////////////////////////////////////
            if(yinyang5m1k && yinyang5m2k)
              {
               yinyang5mkaicang1=true;
               yinyang5mkaicangshiftR1=true;
               yinyang5mpingcang1=true;
               yinyang5mpingcangshiftR1=true;
              }
            if(yinyang5m1k==false && yinyang5m2k==false)
              {
               yinyang5mkaicang1=true;
               yinyang5mkaicangshiftR1=true;
               yinyang5mpingcang1=true;
               yinyang5mpingcangshiftR1=true;
              }
            if(yinyang5m1k && yinyang5m2k==false && yinyang5m2k==false)
              {
               yinyang5mpingcangctrlR1=true;
              }
            if(yinyang5m1k==false && yinyang5m2k && yinyang5m2k)
              {
               yinyang5mpingcangctrlR1=true;
              }
            if(!yinyang5m1k && !yinyang5m2k)
              {
               yinyang5mpingcangBuy1K2Kyin1=true;
              }
            if(yinyang5m1k && yinyang5m2k)
              {
               yinyang5mpingcangSell1K2Kyang1=true;
              }
            if(!yinyang5m1k && !yinyang5m2k && !yinyang5m3k)
              {
               yinyang5mpingcangBuy1K2K3Kyin1=true;
              }
            if(yinyang5m1k && yinyang5m2k && yinyang5m3k)
              {
               yinyang5mpingcangSell1K2K3Kyang1=true;
              }
            if(yinyang5m1k)
              {
               yinyang5mkaicang1Kyangbuy=true;
              }
            if(!yinyang5m1k)
              {
               yinyang5mkaicang1Kyinsell=true;
              }
            if(yinyang5m1k)
              {
               yinyang5mkaicang1Kyangbuyheng=true;
              }
            if(!yinyang5m1k)
              {
               yinyang5mkaicang1Kyinsellheng=true;
              }
            ////////////////////////////////////// 5分钟收盘时 运行一次 延迟 3s 启动 5min3  挂靠执行
            if(menu[27])
              {
               if(ObjectFind(0,"BuyStop1")==0 && ObjectGetDouble(0,"BuyStop1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                 {
                  comment4("K线收盘时 K线实体越过了横线 开仓追");
                  Print("K线收盘时 K线实体越过了横线 开仓追");
                  int keybuy=OrderSend(Symbol(),OP_BUY,buyLotslinshi1,Ask,keyslippage,0,0,NULL,0,0);
                  if(keybuy>0)
                    {
                     PlaySound("ok.wav");
                     ObjectDelete(0,"BuyStop1");
                     buyLotslinshi1=0.0;
                     menu[27]=false;
                     menu27Tick=false;
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     Print("GetLastError=",error());
                    }
                 }
               if(ObjectFind(0,"SellStop1")==0 && ObjectGetDouble(0,"SellStop1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                 {
                  comment4("K线收盘时 K线实体越过了横线 开仓追");
                  Print("K线收盘时 K线实体越过了横线 开仓追");
                  int keysell=OrderSend(Symbol(),OP_SELL,sellLotslinshi1,Bid,keyslippage,0,0,NULL,0,0);
                  if(keysell>0)
                    {
                     PlaySound("ok.wav");
                     ObjectDelete(0,"SellStop1");
                     sellLotslinshi1=0.0;
                     menu[27]=false;
                     menu27Tick=false;
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     Print("GetLastError=",error());
                    }

                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////
            if(menu6[28]==false)//开关是假的
              {
               if(ObjectFind(0,"BuyTrendLineSL1")==0 && BuyTrendLineSLtime+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"BuyTrendLineSL1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的两单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的两单 Close[1]=",Close[1]);
                     zuijinBuyclose();
                     zuijinBuyclose();
                     ObjectDelete(0,"BuyTrendLineSL1");

                    }
                  else
                    {
                     if(ObjectGetDouble(0,"BuyTrendLineSL1",OBJPROP_PRICE,0)>Low[1] && ObjectGetDouble(0,"BuyTrendLineSL1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k==false)
                       {
                        comment4("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处");
                        Print("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处Close[1]=",Close[1],"  Low[1]=",Low[1]);
                        TrendLine("BuyTrendLineSL1",Time[1],Low[1]-pianyilingGlo,Time[0]+2000,Low[1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损1");
                        BuyTrendLineSL1=true;
                       }

                    }
                 }
               if(ObjectFind(0,"SellTrendLineSL1")==0 && BuyTrendLineSLtime+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"SellTrendLineSL1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的两单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的两单");
                     zuijinSellclose();
                     zuijinSellclose();
                     ObjectDelete(0,"SellTrendLineSL1");
                    }
                  else
                    {
                     if(ObjectGetDouble(0,"SellTrendLineSL1",OBJPROP_PRICE,0)<High[1] && ObjectGetDouble(0,"SellTrendLineSL1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k)
                       {
                        comment4("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        Print("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        TrendLine("SellTrendLineSL1",Time[1],High[1]+pianyilingGlo,Time[0]+2000,High[1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损1");
                        SellTrendLineSL1=true;
                       }

                    }
                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////
            if(menu6[28]==false)//开关是假的
              {
               if(ObjectFind(0,"BuyTrendLineSL2")==0 && BuyTrendLineSL2time+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"BuyTrendLineSL2",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的三单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的三单 Close[1]=",Close[1]);
                     zuijinBuyclose();
                     zuijinBuyclose();
                     zuijinBuyclose();
                     ObjectDelete(0,"BuyTrendLineSL2");

                    }
                  else
                    {
                     if(ObjectGetDouble(0,"BuyTrendLineSL2",OBJPROP_PRICE,0)>Low[1] && ObjectGetDouble(0,"BuyTrendLineSL2",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k==false)
                       {
                        comment4("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处");
                        Print("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处Close[1]=",Close[1],"  Low[1]=",Low[1]);
                        TrendLine("BuyTrendLineSL2",Time[1],Low[1]-pianyilingGlo,Time[0]+2000,Low[1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损2");
                        BuyTrendLineSL2=true;
                       }

                    }
                 }
               if(ObjectFind(0,"SellTrendLineSL2")==0 && BuyTrendLineSL2time+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"SellTrendLineSL2",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的三单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的三单");
                     zuijinSellclose();
                     zuijinSellclose();
                     zuijinSellclose();
                     ObjectDelete(0,"SellTrendLineSL2");
                    }
                  else
                    {
                     if(ObjectGetDouble(0,"SellTrendLineSL2",OBJPROP_PRICE,0)<High[1] && ObjectGetDouble(0,"SellTrendLineSL2",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k)
                       {
                        comment4("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        Print("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        TrendLine("SellTrendLineSL2",Time[1],High[1]+pianyilingGlo,Time[0]+2000,High[1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损2");
                        SellTrendLineSL2=true;
                       }

                    }
                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////
            if(menu6[28]==false)//开关是假的
              {
               if(ObjectFind(0,"BuyTrendLineSL3")==0 && BuyTrendLineSL3time+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"BuyTrendLineSL3",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的四单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的四单 Close[1]=",Close[1]);
                     zuijinBuyclose();
                     zuijinBuyclose();
                     zuijinBuyclose();
                     zuijinBuyclose();
                     ObjectDelete(0,"BuyTrendLineSL3");

                    }
                  else
                    {
                     if(ObjectGetDouble(0,"BuyTrendLineSL3",OBJPROP_PRICE,0)>Low[1] && ObjectGetDouble(0,"BuyTrendLineSL3",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k==false)
                       {
                        comment4("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处");
                        Print("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处Close[1]=",Close[1],"  Low[1]=",Low[1]);
                        TrendLine("BuyTrendLineSL3",Time[1],Low[1]-pianyilingGlo,Time[0]+2000,Low[1]-pianyilingGlo,clrCrimson,"Buy单K线收盘时实体越过 止损3");
                        BuyTrendLineSL3=true;
                       }

                    }
                 }
               if(ObjectFind(0,"SellTrendLineSL3")==0 && BuyTrendLineSL3time+20<TimeCurrent())
                 {
                  if(ObjectGetDouble(0,"SellTrendLineSL3",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损最近下的四单");
                     Print("K线收盘时 K线实体越过了横线 止损最近下的四单");
                     zuijinSellclose();
                     zuijinSellclose();
                     zuijinSellclose();
                     zuijinSellclose();
                     ObjectDelete(0,"SellTrendLineSL3");
                    }
                  else
                    {
                     if(ObjectGetDouble(0,"SellTrendLineSL3",OBJPROP_PRICE,0)<High[1] && ObjectGetDouble(0,"SellTrendLineSL3",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k)
                       {
                        comment4("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        Print("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        TrendLine("SellTrendLineSL3",Time[1],High[1]+pianyilingGlo,Time[0]+2000,High[1]+pianyilingGlo,clrBrown,"Sell单K线收盘时实体越过 止损3");
                        SellTrendLineSL3=true;
                       }

                    }
                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////
            if(menu4[0])//
              {
               if(yinyang5m1k)
                 {
                  if(yinyang5m2k==false && yinyang5m3k==false)
                    {
                     if(opriceK[3]>opriceK[2])
                       {
                        if(opriceK[3]<cpriceK[1])
                          {
                           comment3("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");
                           Print("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");

                           if(menu3[22]==false)
                             {
                              PlaySound("alert.wav");
                              PlaySound("maidou.wav");
                             }
                          }
                       }
                     else
                       {
                        if(opriceK[2]<cpriceK[1])
                          {
                           comment3("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");
                           Print("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");

                           if(menu3[22]==false)
                             {
                              PlaySound("alert.wav");
                              PlaySound("maidou.wav");
                             }
                          }
                       }
                    }
                 }
               else
                 {
                  if(yinyang5m2k && yinyang5m3k)
                    {
                     if(opriceK[3]>opriceK[2])
                       {
                        if(opriceK[2]>cpriceK[1])
                          {
                           comment3("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");
                           Print("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");

                           if(menu3[22]==false)
                             {
                              PlaySound("alert.wav");
                              PlaySound("maidou.wav");
                             }
                          }
                       }
                     else
                       {
                        if(opriceK[3]>cpriceK[1])
                          {
                           comment3("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");
                           Print("K线收盘回撤力度过大实体盖过了2K和3K 可能震荡或更大回撤");

                           if(menu3[22]==false)
                             {
                              PlaySound("alert.wav");
                              PlaySound("maidou.wav");
                             }
                          }
                       }
                    }
                 }
              }
            //////////////////////////////////////////////
            //Print("kaiguan5m1 3=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan5m1time=TimeCurrent();
           }
        }
     }
   if(kaiguan15m1 && kaiguan15m1time+780<TimeCurrent())//15分钟收盘时 运行一次 延迟 3s 启动 15min3
     {
      int m=TimeMinute(TimeCurrent());
      if(m==15 || m==30 || m==45 || m==0)
        {
         if(TimeSeconds(TimeCurrent())>=3)
           {
            ///////////////////////////////
            //Print("kaiguan15m1 3=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan15m1time=TimeCurrent();
           }
        }
     }
////////////////////////////////////
   if(kaiguan5m2 && kaiguan5m2time+240<TimeCurrent()) //5分钟收盘时 运行一次 延迟 6s 启动 5min6
     {
      int m=TimeMinute(TimeCurrent());
      if(m==5 || m==10 || m==15 || m==20 || m==25 || m==30 || m==35|| m==40|| m==45 || m==50|| m==55|| m==0)
        {
         if(TimeSeconds(TimeCurrent())>=6)
           {
            ////////////////////////////////////////////////////////////////
            if(menu6[8] && ObjectFind(0,"2kbuySL1")==0)
              {
               if(ObjectGetDouble(0,"2kbuySL1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                 {
                  Print("连续两个阳线设止损线于阳线最低点 实体越线 平仓最近三单");
                  zuijinBuyclose();
                  zuijinBuyclose();
                  zuijinBuyclose();
                  menu6[8]=false;
                  ObjectDelete(0,"2kbuySL1");
                 }
               else
                 {
                  if(yinyang5m1k && yinyang5m2k)
                    {
                     TrendLine("2kbuySL1",Time[2],Low[2]-pianyilingGlo,Time[0]+2500,Low[2]-pianyilingGlo,Red,"连续两个阳线设止损线于阳线最低点");
                    }
                 }
              }
            if(menu6[9] && ObjectFind(0,"2ksellSL1")==0)
              {
               if(ObjectGetDouble(0,"2ksellSL1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                 {
                  Print("连续两个阴线设止损线于阴线最高点 实体越线 平仓最近三单");
                  zuijinSellclose();
                  zuijinSellclose();
                  zuijinSellclose();
                  menu6[9]=false;
                  ObjectDelete(0,"2ksellSL1");
                 }
               else
                 {
                  if(yinyang5m1k==false && yinyang5m2k==false)
                    {
                     TrendLine("2ksellSL1",Time[2],High[2]+pianyilingGlo,Time[0]+2500,High[2]+pianyilingGlo,clrBrown,"连续两个阴线设止损线于阴线最高点");
                    }
                 }
              }
            ////////////////////////////////////////////////////////////
            if(yiyang5mpingcangshiti && menu[24])
              {
               if(cpriceK[1]<sellline)
                 {
                  if(ObjectFind("Sell Line")==0)
                    {
                     ObjectMove(0,"Sell Line",0,Time[linebar],hpriceK[1]+pianyilingGlo);
                     sellline=hpriceK[1]+pianyilingGlo;
                     Print("收盘时实体未越过横线 移动横线到K线的最高最低点");
                    }
                  menu[24]=false;
                 }
               else
                 {
                  xunhuanquanpingcang();
                  monianjian(16);
                  comment1("收盘时越过横线 直接平仓");
                  Print("收盘时越过横线 直接平仓");
                 }
               yiyang5mpingcangshiti=false;
              }

            if(yiyang5mpingcangshiti1 && menu[24])
              {
               if(cpriceK[1]>buyline)
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     ObjectMove(0,"Buy Line",0,Time[linebar],lpriceK[1]-pianyilingGlo);
                     buyline=lpriceK[1]-pianyilingGlo;
                     Print("收盘时实体未越过横线 移动横线到K线的最高最低点");
                    }
                  menu[24]=false;
                 }
               else
                 {
                  xunhuanquanpingcang();
                  monianjian(16);
                  monianjian(16);
                  comment1("收盘时越过横线 直接平仓");
                  Print("收盘时越过横线 直接平仓");
                 }
               yiyang5mpingcangshiti1=false;
              }
            //////////////////////////////////////////
            if(menu6[4])//
              {
               if(ObjectFind(0,"znBuy5mSL1")>=0)
                 {
                  ObjectDelete(0,"znBuy5mSL1");
                  ObjectCreate(0,"znBuy5mSL1",OBJ_RECTANGLE,0,tpriceK[zn5mSL1bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL1bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL1bar,0)]+zn5mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy5mSL1",OBJPROP_BACK,false);
                  ObjectSet("znBuy5mSL1",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy5mSL1",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy5mSL1",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线1");
                 }
               if(ObjectFind(0,"znBuy5mSL2")>=0)
                 {
                  ObjectDelete(0,"znBuy5mSL2");
                  ObjectCreate(0,"znBuy5mSL2",OBJ_RECTANGLE,0,tpriceK[zn5mSL2bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL2bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL2bar,0)]+zn5mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy5mSL2",OBJPROP_BACK,false);
                  ObjectSet("znBuy5mSL2",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy5mSL2",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy5mSL2",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线2");
                 }
               if(ObjectFind(0,"znBuy5mSL3")>=0)
                 {
                  ObjectDelete(0,"znBuy5mSL3");
                  ObjectCreate(0,"znBuy5mSL3",OBJ_RECTANGLE,0,tpriceK[zn5mSL3bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL3bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL3bar,0)]+zn5mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy5mSL3",OBJPROP_BACK,false);
                  ObjectSet("znBuy5mSL3",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy5mSL3",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy5mSL3",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线3");
                 }
              }

            if(menu6[6])
              {
               if(ObjectFind(0,"znBuy15mSL1")>=0)
                 {
                  ObjectDelete(0,"znBuy15mSL1");
                  ObjectCreate(0,"znBuy15mSL1",OBJ_RECTANGLE,0,tpriceK15[zn15mSL1bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL1bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL1bar,0)]+zn15mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy15mSL1",OBJPROP_BACK,false);
                  ObjectSet("znBuy15mSL1",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy15mSL1",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy15mSL1",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线1");
                 }
               if(ObjectFind(0,"znBuy15mSL2")>=0)
                 {
                  ObjectDelete(0,"znBuy15mSL2");
                  ObjectCreate(0,"znBuy15mSL2",OBJ_RECTANGLE,0,tpriceK15[zn15mSL2bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL2bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL2bar,0)]+zn15mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy15mSL2",OBJPROP_BACK,false);
                  ObjectSet("znBuy15mSL2",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy15mSL2",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy15mSL2",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线2");
                 }
               if(ObjectFind(0,"znBuy15mSL3")>=0)
                 {
                  ObjectDelete(0,"znBuy15mSL3");
                  ObjectCreate(0,"znBuy15mSL3",OBJ_RECTANGLE,0,tpriceK15[zn15mSL3bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL3bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL3bar,0)]+zn15mBuySLpianyi*Point-diancha);
                  ObjectSet("znBuy15mSL3",OBJPROP_BACK,false);
                  ObjectSet("znBuy15mSL3",OBJPROP_WIDTH,1);
                  ObjectSet("znBuy15mSL3",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znBuy15mSL2",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线2");
                 }
              }
            if(menu6[5])
              {
               if(ObjectFind(0,"znSell5mSL1")>=0)
                 {
                  ObjectDelete(0,"znSell5mSL1");
                  Print(hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha);
                  ObjectCreate(0,"znSell5mSL1",OBJ_RECTANGLE,0,tpriceK[zn5mSL1bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell5mSL1",OBJPROP_BACK,false);
                  ObjectSet("znSell5mSL1",OBJPROP_WIDTH,1);
                  ObjectSet("znSell5mSL1",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell5mSL1",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线1");
                 }
               if(ObjectFind(0,"znSell5mSL2")>=0)
                 {
                  ObjectDelete(0,"znSell5mSL2");
                  ObjectCreate(0,"znSell5mSL2",OBJ_RECTANGLE,0,tpriceK[zn5mSL2bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL2bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL2bar,0)]+zn5mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell5mSL2",OBJPROP_BACK,false);
                  ObjectSet("znSell5mSL2",OBJPROP_WIDTH,1);
                  ObjectSet("znSell5mSL2",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell5mSL2",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线2");
                 }
               if(ObjectFind(0,"znSell5mSL3")>=0)
                 {
                  ObjectDelete(0,"znSell5mSL3");
                  ObjectCreate(0,"znSell5mSL3",OBJ_RECTANGLE,0,tpriceK[zn5mSL3bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL3bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL3bar,0)]+zn5mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell5mSL3",OBJPROP_BACK,false);
                  ObjectSet("znSell5mSL3",OBJPROP_WIDTH,1);
                  ObjectSet("znSell5mSL3",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell5mSL3",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线3");
                 }
              }
            if(menu6[7])
              {
               if(ObjectFind(0,"znSell15mSL1")>=0)
                 {
                  ObjectDelete(0,"znSell15mSL1");
                  ObjectCreate(0,"znSell15mSL1",OBJ_RECTANGLE,0,tpriceK15[zn15mSL1bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL1bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL1bar,0)]+zn15mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell15mSL1",OBJPROP_BACK,false);
                  ObjectSet("znSell15mSL1",OBJPROP_WIDTH,1);
                  ObjectSet("znSell15mSL1",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell15mSL1",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线1");
                 }
               if(ObjectFind(0,"znSell15mSL2")>=0)
                 {
                  ObjectDelete(0,"znSell15mSL2");
                  ObjectCreate(0,"znSell15mSL2",OBJ_RECTANGLE,0,tpriceK15[zn15mSL2bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL2bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL2bar,0)]+zn15mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell15mSL2",OBJPROP_BACK,false);
                  ObjectSet("znSell15mSL2",OBJPROP_WIDTH,1);
                  ObjectSet("znSell15mSL2",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell15mSL2",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线2");
                 }
               if(ObjectFind(0,"znSell15mSL3")>=0)
                 {
                  ObjectDelete(0,"znSell15mSL3");
                  ObjectCreate(0,"znSell15mSL3",OBJ_RECTANGLE,0,tpriceK15[zn15mSL3bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL3bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL3bar,0)]+zn15mSellSLpianyi*Point+diancha);
                  ObjectSet("znSell15mSL3",OBJPROP_BACK,false);
                  ObjectSet("znSell15mSL3",OBJPROP_WIDTH,1);
                  ObjectSet("znSell15mSL3",OBJPROP_COLOR,clrCrimson);
                  ObjectSetString(0,"znSell15mSL3",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线3");
                 }
              }
            ///////////////////////////////////////////////////////////
            if(menu6[0])//短线追Buy单
              {
               if(yinyang5m1k)
                 {
                  if(ObjectFind(0,"dxzdBuyi2kSL")>=0)
                    {
                     ObjectDelete("dxzdBuyi2kSL");
                     ObjectCreate(0,"dxzdBuyi2kSL",OBJ_RECTANGLE,0,Time[1],GetiLowest(0,2,0),Time[0]+5000,GetiLowest(0,2,0));
                     ObjectSet("dxzdBuyi2kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi2kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi2kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi3kSL")>=0)
                    {
                     ObjectDelete("dxzdBuyi3kSL");
                     ObjectCreate(0,"dxzdBuyi3kSL",OBJ_RECTANGLE,0,Time[2],GetiLowest(0,3,0),Time[0]+5000,GetiLowest(0,3,0));
                     ObjectSet("dxzdBuyi3kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi3kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi3kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi4kSL")>=0)
                    {
                     ObjectDelete("dxzdBuyi4kSL");
                     ObjectCreate(0,"dxzdBuyi4kSL",OBJ_RECTANGLE,0,Time[3],GetiLowest(0,4,0),Time[0]+5000,GetiLowest(0,4,0));
                     ObjectSet("dxzdBuyi4kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi4kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi4kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi5kSL")>=0)
                    {
                     ObjectDelete("dxzdBuyi5kSL");
                     ObjectCreate(0,"dxzdBuyi5kSL",OBJ_RECTANGLE,0,Time[4],GetiLowest(0,5,0),Time[0]+5000,GetiLowest(0,5,0));
                     ObjectSet("dxzdBuyi5kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi5kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi5kSL",OBJPROP_COLOR,Red);
                    }

                  if(ObjectFind(0,"dxzdBuyi2kSL1")>=0)//
                    {
                     ObjectDelete("dxzdBuyi2kSL1");
                     ObjectCreate(0,"dxzdBuyi2kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,2,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,2,0)-dxzdSLpianyiliang*Point-diancha);
                     ObjectSet("dxzdBuyi2kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi2kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi2kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi3kSL1")>=0)//
                    {
                     ObjectDelete("dxzdBuyi3kSL1");
                     ObjectCreate(0,"dxzdBuyi3kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,3,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,3,0)-dxzdSLpianyiliang*Point-diancha);
                     ObjectSet("dxzdBuyi3kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi3kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi3kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi4kSL1")>=0)//
                    {
                     ObjectDelete("dxzdBuyi4kSL1");
                     ObjectCreate(0,"dxzdBuyi4kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,4,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,4,0)-dxzdSLpianyiliang*Point-diancha);
                     ObjectSet("dxzdBuyi4kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi4kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi4kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdBuyi5kSL1")>=0)//
                    {
                     ObjectDelete("dxzdBuyi5kSL1");
                     ObjectCreate(0,"dxzdBuyi5kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,5,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,5,0)-dxzdSLpianyiliang*Point-diancha);
                     ObjectSet("dxzdBuyi5kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdBuyi5kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdBuyi5kSL1",OBJPROP_COLOR,Red);
                    }

                 }
              }
            if(menu6[1])//短线追Sell单
              {
               if(yinyang5m1k==false)
                 {
                  if(ObjectFind(0,"dxzdSelli2kSL")>=0)
                    {
                     ObjectDelete("dxzdSelli2kSL");
                     ObjectCreate(0,"dxzdSelli2kSL",OBJ_RECTANGLE,0,Time[1],GetiHighest(0,2,0),Time[0]+5000,GetiHighest(0,2,0));
                     ObjectSet("dxzdSelli2kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli2kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli2kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli3kSL")>=0)
                    {
                     ObjectDelete("dxzdSelli3kSL");
                     ObjectCreate(0,"dxzdSelli3kSL",OBJ_RECTANGLE,0,Time[2],GetiHighest(0,3,0),Time[0]+5000,GetiHighest(0,3,0));
                     ObjectSet("dxzdSelli3kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli3kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli3kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli4kSL")>=0)
                    {
                     ObjectDelete("dxzdSelli4kSL");
                     ObjectCreate(0,"dxzdSelli4kSL",OBJ_RECTANGLE,0,Time[3],GetiHighest(0,4,0),Time[0]+5000,GetiHighest(0,4,0));
                     ObjectSet("dxzdSelli4kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli4kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli4kSL",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli5kSL")>=0)
                    {
                     ObjectDelete("dxzdSelli5kSL");
                     ObjectCreate(0,"dxzdSelli5kSL",OBJ_RECTANGLE,0,Time[4],GetiHighest(0,5,0),Time[0]+5000,GetiHighest(0,5,0));
                     ObjectSet("dxzdSelli5kSL",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli5kSL",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli5kSL",OBJPROP_COLOR,Red);
                    }

                  if(ObjectFind(0,"dxzdSelli2kSL1")>=0)//
                    {
                     ObjectDelete("dxzdSelli2kSL1");
                     ObjectCreate(0,"dxzdSelli2kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,2,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,2,0)+dxzdSLpianyiliang*Point+diancha);
                     ObjectSet("dxzdSelli2kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli2kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli2kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli3kSL1")>=0)//
                    {
                     ObjectDelete("dxzdSelli3kSL1");
                     ObjectCreate(0,"dxzdSelli3kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,3,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,3,0)+dxzdSLpianyiliang*Point+diancha);
                     ObjectSet("dxzdSelli3kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli3kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli3kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli4kSL1")>=0)//
                    {
                     ObjectDelete("dxzdSelli4kSL1");
                     ObjectCreate(0,"dxzdSelli4kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,4,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,4,0)+dxzdSLpianyiliang*Point+diancha);
                     ObjectSet("dxzdSelli4kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli4kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli4kSL1",OBJPROP_COLOR,Red);
                    }
                  if(ObjectFind(0,"dxzdSelli5kSL1")>=0)//
                    {
                     ObjectDelete("dxzdSelli5kSL1");
                     ObjectCreate(0,"dxzdSelli5kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,5,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,5,0)+dxzdSLpianyiliang*Point+diancha);
                     ObjectSet("dxzdSelli5kSL1",OBJPROP_BACK,false);
                     ObjectSet("dxzdSelli5kSL1",OBJPROP_WIDTH,1);
                     ObjectSet("dxzdSelli5kSL1",OBJPROP_COLOR,Red);
                    }

                 }
              }
            /////////////////////////////////////////////////////////////
            ///////////////////////////////
            if(menu4[8])
              {
               if(ObjectFind(0,"BuySL1")==0)
                 {
                  if(ObjectGetDouble(0,"BuySL1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k==false)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损平仓 开始");
                     Print("K线收盘时 K线实体越过了横线 止损平仓 开始 Close[1]=",Close[1]);
                     for(int i=menu4_8jishu; i>0; i--)
                       {
                        zuijinBuyclose();
                        if(GetHoldingbuyOrdersCount()<=0)
                          {
                           break;
                          }
                       }
                     ObjectDelete(0,"BuySL1");
                     ObjectDelete(0,"SellSL1");
                     menu4[8]=false;
                     menu4_8jishu=50;
                    }
                  else
                    {
                     if(ObjectGetDouble(0,"BuySL1",OBJPROP_PRICE,0)>Low[1] && ObjectGetDouble(0,"BuySL1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k==false)
                       {
                        comment4("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处");
                        Print("K线收盘时实体未越过横线 但下引线越过了 移动到下引线处Close[1]=",Close[1],"  Low[1]=",Low[1]);
                        ObjectMove(0,"BuySL1",0,Time[1],Low[1]-pianyilingGlo-diancha);
                        BuySL1=true;
                       }

                    }
                 }
               if(ObjectFind(0,"SellSL1")==0)
                 {
                  if(ObjectGetDouble(0,"SellSL1",OBJPROP_PRICE,0)<Close[1] && yinyang5m1k)
                    {
                     comment4("K线收盘时 K线实体越过了横线 止损平仓 开始");
                     Print("K线收盘时 K线实体越过了横线 止损平仓 开始");
                     for(int i=menu4_8jishu; i>0; i--)
                       {
                        zuijinSellclose();
                        if(GetHoldingsellOrdersCount()<=0)
                          {
                           break;
                          }
                       }
                     ObjectDelete(0,"BuySL1");
                     ObjectDelete(0,"SellSL1");
                     menu4[8]=false;
                     menu4_8jishu=50;
                    }
                  else
                    {
                     if(ObjectGetDouble(0,"SellSL1",OBJPROP_PRICE,0)<High[1] && ObjectGetDouble(0,"SellSL1",OBJPROP_PRICE,0)>Close[1] && yinyang5m1k)
                       {
                        comment4("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        Print("K线收盘时实体未越过横线 但上引线越过了 移动到上引线处");
                        ObjectMove(0,"SellSL1",0,Time[1],High[1]+pianyilingGlo+diancha);
                        SellSL1=true;
                       }

                    }
                 }
              }
            ////////////////////////////////
            //Print("kaiguan5m2 6=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan5m2time=TimeCurrent();
           }
        }
     }
   if(kaiguan15m2 && kaiguan15m2time+780<TimeCurrent())//15分钟收盘时 运行一次 延迟 6s 启动 15min6
     {
      int m=TimeMinute(TimeCurrent());
      if(m==15 || m==30 || m==45 || m==0)
        {
         if(TimeSeconds(TimeCurrent())>=6)
           {
            ///////////////////////////////
            //Print("kaiguan15m2 6=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan15m2time=TimeCurrent();
           }
        }
     }
////////////////////////////////////
   if(kaiguan5m3 && kaiguan5m3time+240<TimeCurrent()) //5分钟收盘时 运行一次 延迟 9s 启动 5min9
     {
      int m=TimeMinute(TimeCurrent());
      if(m==5 || m==10 || m==15 || m==20 || m==25 || m==30 || m==35|| m==40|| m==45 || m==50|| m==55|| m==0)
        {
         if(TimeSeconds(TimeCurrent())>=9)
           {
            ////////////////////////////////////////////////////////////////
            if(ATR1)
              {
               ATRvalue=iATR(NULL,0,ATRcanshu,0);
               if(ObjectFind(0,"ATR1")<0)
                 {
                  ObjectCreate(0,"ATR1",OBJ_LABEL,0,0,0);
                  ObjectSetInteger(0,"ATR1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
                  ObjectSetInteger(0,"ATR1",OBJPROP_XDISTANCE,80);
                  ObjectSetInteger(0,"ATR1",OBJPROP_YDISTANCE,140);
                  ObjectSetText("ATR1","ATR "+string(NormalizeDouble(ATRvalue/Point,0)),12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"ATR1",OBJPROP_TOOLTIP,"真实波动幅度均值 ATR值最适合用来设置止损 因为它能让您把止损设在最大距离的位置 避开市场噪音 同时使用尽可能短的止损");
                 }
               else
                 {
                  ObjectSetText("ATR1","ATR "+string(NormalizeDouble(ATRvalue/Point,0)),12,"黑体",dingdanxianshicolor);
                 }
              }
            ////////////////////////////////////////////////////////////////////////////////////////////////////
            Vegas144=NormalizeDouble(iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,0),Digits);
            Vegas169=NormalizeDouble(iMA(NULL,0,169,0,MODE_EMA,PRICE_CLOSE,0),Digits);
            Vegas288=NormalizeDouble(iMA(NULL,0,288,0,MODE_EMA,PRICE_CLOSE,0),Digits);
            Vegas338=NormalizeDouble(iMA(NULL,0,338,0,MODE_EMA,PRICE_CLOSE,0),Digits);
            if(Vegas_144)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  ObjectMove(0,"Buy Line",0,Time[0],Vegas144);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  ObjectMove(0,"Sell Line",0,Time[0],Vegas144);
                 }
              }
            if(Vegas_169)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  ObjectMove(0,"Buy Line",0,Time[0],Vegas169);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  ObjectMove(0,"Sell Line",0,Time[0],Vegas169);
                 }
              }
            if(Vegas_288)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  ObjectMove(0,"Buy Line",0,Time[0],Vegas288);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  ObjectMove(0,"Sell Line",0,Time[0],Vegas288);
                 }
              }
            if(Vegas_338)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  ObjectMove(0,"Buy Line",0,Time[0],Vegas338);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  ObjectMove(0,"Sell Line",0,Time[0],Vegas338);
                 }
              }
            /////////////////////////////////////////////////////////////////////////////////////
            if(zhendangzhibiaokaiguan)
              {
               if(NormalizeDouble(iCustom(NULL,0,"Custom/震荡突破",0,0),4)==0.0)
                 {
                  comment4("震荡突破 指标 没有找到  请放到Indicators/Custom/震荡突破.ex4 ");
                  Print("震荡突破 指标 没有找到 请放到Indicators/Custom/震荡突破.ex4");
                  zhendangzhibiaokaiguan=false;
                  return;
                 }
               // Print(NormalizeDouble(iCustom(NULL,0,"Custom/震荡突破",0,0),4));//指标最后一位参数 代表第几根K线
               for(int i=0; i<99; i++)
                 {
                  zhendangzhibiao[i]=NormalizeDouble(iCustom(NULL,0,"Custom/震荡突破",0,i),4);
                 }
               //////////////////////////////////////////////////////////////////////
               zhendang6H=0;//震荡突破指标最近12根K线大于0.07的个数
               for(int i=0; i<6; i++)
                 {
                  if(zhendangzhibiao[i]>0.07)
                    {
                     zhendang6H++;
                    }
                 }
               zhendang6Z=0;
               for(int i=0; i<6; i++)
                 {
                  if(zhendangzhibiao[i]<=0.07 && zhendangzhibiao[i]>0)
                    {
                     zhendang6Z++;
                    }
                 }
               zhendang6F=0;
               for(int i=0; i<6; i++)
                 {
                  if(zhendangzhibiao[i]>=-0.07 && zhendangzhibiao[i]<0)
                    {
                     zhendang6F++;
                    }
                 }
               zhendang6L=0;
               for(int i=0; i<6; i++)
                 {
                  if(zhendangzhibiao[i]<-0.07)
                    {
                     zhendang6L++;
                    }
                 }
               //Print(zhendang6H," ",zhendang6Z," ",zhendang6F," ", zhendang6L);
               //////////////////////////////////////////////////////////////////////
               zhendang12H=0;//震荡突破指标最近12根K线大于0.07的个数
               for(int i=0; i<12; i++)
                 {
                  if(zhendangzhibiao[i]>0.07)
                    {
                     zhendang12H++;
                    }
                 }
               zhendang12Z=0;
               for(int i=0; i<12; i++)
                 {
                  if(zhendangzhibiao[i]<=0.07 && zhendangzhibiao[i]>0)
                    {
                     zhendang12Z++;
                    }
                 }
               zhendang12F=0;
               for(int i=0; i<12; i++)
                 {
                  if(zhendangzhibiao[i]>=-0.07 && zhendangzhibiao[i]<0)
                    {
                     zhendang12F++;
                    }
                 }
               zhendang12L=0;
               for(int i=0; i<12; i++)
                 {
                  if(zhendangzhibiao[i]<-0.07)
                    {
                     zhendang12L++;
                    }
                 }
               //Print(zhendang12H," ",zhendang12Z," ",zhendang12F," ", zhendang12L);
               //////////////////////////////////////////////////////////////////////
               //////////////////////////////////////////////////////////////////////
               zhendang24H=0;//震荡突破指标最近24根K线大于0.07的个数
               for(int i=0; i<24; i++)
                 {
                  if(zhendangzhibiao[i]>0.07)
                    {
                     zhendang24H++;
                    }
                 }
               zhendang24Z=0;
               for(int i=0; i<24; i++)
                 {
                  if(zhendangzhibiao[i]<=0.07 && zhendangzhibiao[i]>0)
                    {
                     zhendang24Z++;
                    }
                 }
               zhendang24F=0;
               for(int i=0; i<24; i++)
                 {
                  if(zhendangzhibiao[i]>=-0.07 && zhendangzhibiao[i]<0)
                    {
                     zhendang24F++;
                    }
                 }
               zhendang24L=0;
               for(int i=0; i<24; i++)
                 {
                  if(zhendangzhibiao[i]<-0.07)
                    {
                     zhendang24L++;
                    }
                 }
               //Print(zhendang24H," ",zhendang24Z," ",zhendang24F," ", zhendang24L);
               //////////////////////////////////////////////////////////////////////
               zhendang36H=0;//震荡突破指标最近36根K线大于0.07的个数
               for(int i=0; i<36; i++)
                 {
                  if(zhendangzhibiao[i]>0.07)
                    {
                     zhendang36H++;
                    }
                 }
               zhendang36Z=0;
               for(int i=0; i<36; i++)
                 {
                  if(zhendangzhibiao[i]<=0.07 && zhendangzhibiao[i]>0)
                    {
                     zhendang36Z++;
                    }
                 }
               zhendang36F=0;
               for(int i=0; i<36; i++)
                 {
                  if(zhendangzhibiao[i]>=-0.07 && zhendangzhibiao[i]<0)
                    {
                     zhendang36F++;
                    }
                 }
               zhendang36L=0;
               for(int i=0; i<36; i++)
                 {
                  if(zhendangzhibiao[i]<-0.07)
                    {
                     zhendang36L++;
                    }
                 }
               //Print(zhendang36H," ",zhendang36Z," ",zhendang36F," ", zhendang36L);
               //////////////////////////////////////////////////////////////////////
               if(ObjectFind(0,"zhendangR4")<0)
                 {
                  ObjectCreate(0,"zhendangR4",OBJ_LABEL,0,0,0);
                  ObjectSetInteger(0,"zhendangR4",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
                  ObjectSetInteger(0,"zhendangR4",OBJPROP_XDISTANCE,80);
                  ObjectSetInteger(0,"zhendangR4",OBJPROP_YDISTANCE,20);
                  ObjectSetText("zhendangR4",""+string(zhendang6H)+" "+string(zhendang12H)+" "+string(zhendang24H)+" "+string(zhendang36H),12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"zhendangR4",OBJPROP_TOOLTIP,"震荡突破指标计算最近6根K线对应的值 分别在 大于0.07 0.07至0 0至-0.07 小于-0.07 四个区间K线的个数 第一列 以此判断当前的短期趋势 ");
                 }
               else
                 {
                  ObjectSetText("zhendangR4",""+string(zhendang6H)+" "+string(zhendang12H)+" "+string(zhendang24H)+" "+string(zhendang36H),12,"黑体",dingdanxianshicolor);
                 }
               if(ObjectFind(0,"zhendangR1")<0)
                 {
                  ObjectCreate(0,"zhendangR1",OBJ_LABEL,0,0,0);
                  ObjectSetInteger(0,"zhendangR1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
                  ObjectSetInteger(0,"zhendangR1",OBJPROP_XDISTANCE,80);
                  ObjectSetInteger(0,"zhendangR1",OBJPROP_YDISTANCE,40);
                  ObjectSetText("zhendangR1",""+string(zhendang6Z)+" "+string(zhendang12Z)+" "+string(zhendang24Z)+" "+string(zhendang36Z),12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"zhendangR1",OBJPROP_TOOLTIP,"四列数 分别对应 震荡突破指标计算最近6根 12根 24根 36根 K线对应的值 五分钟图表 分别对应30分钟 1 2 3小时 ");
                 }
               else
                 {
                  ObjectSetText("zhendangR1",""+string(zhendang6Z)+" "+string(zhendang12Z)+" "+string(zhendang24Z)+" "+string(zhendang36Z),12,"黑体",dingdanxianshicolor);
                 }
               if(ObjectFind(0,"zhendangR2")<0)
                 {
                  ObjectCreate(0,"zhendangR2",OBJ_LABEL,0,0,0);
                  ObjectSetInteger(0,"zhendangR2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
                  ObjectSetInteger(0,"zhendangR2",OBJPROP_XDISTANCE,80);
                  ObjectSetInteger(0,"zhendangR2",OBJPROP_YDISTANCE,60);
                  ObjectSetText("zhendangR2",""+string(zhendang6F)+" "+string(zhendang12F)+" "+string(zhendang24F)+" "+string(zhendang36F),12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"zhendangR2",OBJPROP_TOOLTIP," 第三列  第一行 第二行 数字越大 上涨行情 不要做空  如果第一行 第四行 几乎接近0 说明 没有突破 在震荡");
                 }
               else
                 {
                  ObjectSetText("zhendangR2",""+string(zhendang6F)+" "+string(zhendang12F)+" "+string(zhendang24F)+" "+string(zhendang36F),12,"黑体",dingdanxianshicolor);
                 }
               if(ObjectFind(0,"zhendangR3")<0)
                 {
                  ObjectCreate(0,"zhendangR3",OBJ_LABEL,0,0,0);
                  ObjectSetInteger(0,"zhendangR3",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
                  ObjectSetInteger(0,"zhendangR3",OBJPROP_XDISTANCE,80);
                  ObjectSetInteger(0,"zhendangR3",OBJPROP_YDISTANCE,80);
                  ObjectSetText("zhendangR3",""+string(zhendang6L)+" "+string(zhendang12L)+" "+string(zhendang24L)+" "+string(zhendang36L),12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"zhendangR3",OBJPROP_TOOLTIP,"最近36根K线 第四列 第三行 第四行 数字越大 下跌行情 不要做多 ");
                 }
               else
                 {
                  ObjectSetText("zhendangR3",""+string(zhendang6L)+" "+string(zhendang12L)+" "+string(zhendang24L)+" "+string(zhendang36L),12,"黑体",dingdanxianshicolor);
                 }
              }
            ///////////////////////////////////////////////////////////////////////////////////
            ///////////////////////////////
            //Print("kaiguan5m3 9=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan5m3time=TimeCurrent();
           }
        }
     }
   if(kaiguan15m3 && kaiguan15m3time+780<TimeCurrent())//15分钟收盘时 运行一次 延迟 9s 启动 15min9
     {
      int m=TimeMinute(TimeCurrent());
      if(m==15 || m==30 || m==45 || m==0)
        {
         if(TimeSeconds(TimeCurrent())>=9)
           {
            ///////////////////////////////
            if(ObjectFind("BuyTrendLineSL1")==0)//更新横线长度
              {
               datetime time1=(datetime)ObjectGet("BuyTrendLineSL1",OBJPROP_TIME1);
               double price1=ObjectGet("BuyTrendLineSL1",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"BuyTrendLineSL1",OBJPROP_TOOLTIP,0);
               TrendLine("BuyTrendLineSL1",time1,price1,Time[0]+1000,price1,clrCrimson,text1);
              }
            if(ObjectFind("BuyTrendLineSL2")==0)
              {
               datetime time1=(datetime)ObjectGet("BuyTrendLineSL2",OBJPROP_TIME1);
               double price1=ObjectGet("BuyTrendLineSL2",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"BuyTrendLineSL2",OBJPROP_TOOLTIP,0);
               TrendLine("BuyTrendLineSL2",time1,price1,Time[0]+1000,price1,clrCrimson,text1);
              }
            if(ObjectFind("BuyTrendLineSL3")==0)
              {
               datetime time1=(datetime)ObjectGet("BuyTrendLineSL3",OBJPROP_TIME1);
               double price1=ObjectGet("BuyTrendLineSL3",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"BuyTrendLineSL3",OBJPROP_TOOLTIP,0);
               TrendLine("BuyTrendLineSL3",time1,price1,Time[0]+1000,price1,clrCrimson,text1);
              }
            if(ObjectFind("SellTrendLineSL1")==0)
              {
               datetime time1=(datetime)ObjectGet("SellTrendLineSL1",OBJPROP_TIME1);
               double price1=ObjectGet("SellTrendLineSL1",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"SellTrendLineSL1",OBJPROP_TOOLTIP,0);
               TrendLine("SellTrendLineSL1",time1,price1,Time[0]+1000,price1,clrBrown,text1);
              }
            if(ObjectFind("SellTrendLineSL2")==0)
              {
               datetime time1=(datetime)ObjectGet("SellTrendLineSL2",OBJPROP_TIME1);
               double price1=ObjectGet("SellTrendLineSL2",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"SellTrendLineSL2",OBJPROP_TOOLTIP,0);
               TrendLine("SellTrendLineSL2",time1,price1,Time[0]+1000,price1,clrBrown,text1);
              }
            if(ObjectFind("SellTrendLineSL3")==0)
              {
               datetime time1=(datetime)ObjectGet("SellTrendLineSL3",OBJPROP_TIME1);
               double price1=ObjectGet("SellTrendLineSL3",OBJPROP_PRICE1);
               string text1=ObjectGetString(0,"SellTrendLineSL3",OBJPROP_TOOLTIP,0);
               TrendLine("SellTrendLineSL3",time1,price1,Time[0]+1000,price1,clrBrown,text1);
              }
            //////////////////////////////////////
            if(fansuoYes)//订单反锁平仓后 启用EA部分功能
              {
               if(GetHoldingbuyOrdersCount()<=0 && GetHoldingsellOrdersCount()<=0)
                 {
                  fansuoYes=false;
                  Print("锁仓订单已解锁 空仓中 恢复执行止盈止损 自动分步平仓 ");
                  comment5("锁仓订单已解锁 空仓中 恢复执行止盈止损 自动分步平仓");

                 }
              }
            //Print("kaiguan15m3 9=",TimeLocal()," Close[1]=",Close[1]);
            ///////////////////////////////
            kaiguan15m3time=TimeCurrent();
           }
        }
     }
////////////////////////////////////////////////////////////////5分钟收盘时 运行一次 结束 下面是Tick范围
   if(menu224[1])
     {
      if(ObjectFind(0,"Buy Line")==0 && ObjectFind(0,"SL Line")==0 && buyline>=Bid && slline<buyline && menu224_1time+menu224_1sleep1<=TimeCurrent())
        {

         int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,slline,0,NULL,0,0);
         if(keybuy10>0)
           {
            PlaySound("ok.wav");
            menu224_1geshu1--;
            Print("越线缓慢开仓直到返回 剩余开仓个数",menu224_1geshu1);
            menu224_1time=TimeCurrent();
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         if(menu224_1geshu1==0)
           {
            comment4("越线缓慢开仓直到返回 关闭");
            Print(" 越线缓慢开仓直到返回 关闭");
            ObjectDelete(0,"Buy Line");
            ObjectDelete(0,"Sell Line");
            ObjectDelete(0,"SL Line");
            menu224_1geshu1=menu224_1geshu;
            menu224_1sleep1=menu224_1sleep;
            menu224[1]=false;
           }
        }
      if(ObjectFind(0,"Sell Line")==0 && ObjectFind(0,"SL Line")==0 && sellline<=Bid && slline>sellline  && menu224_1time+menu224_1sleep1<=TimeCurrent())
        {

         int  keybuy10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,slline,0,NULL,0,0);
         if(keybuy10>0)
           {
            PlaySound("ok.wav");
            menu224_1geshu1--;
            Print("越线缓慢开仓直到返回 剩余开仓个数",menu224_1geshu1);
            menu224_1time=TimeCurrent();
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         if(menu224_1geshu1==0)
           {
            comment4("越线缓慢开仓直到返回 关闭");
            Print(" 越线缓慢开仓直到返回 关闭");
            ObjectDelete(0,"Buy Line");
            ObjectDelete(0,"Sell Line");
            ObjectDelete(0,"SL Line");
            menu224_1geshu1=menu224_1geshu;
            menu224_1sleep1=menu224_1sleep;
            menu224[1]=false;
           }
        }
     }
////////////////////////////////////////////////////////////////////////////////////////////
   if(BuySL1 && menu4[8])
     {
      if(ObjectFind(0,"BuySL1")==0 && ObjectGetDouble(0,"BuySL1",OBJPROP_PRICE,0)>Bid)
        {
         comment4("K线越过了横线 止损平仓 开始");
         Print(" K线越过了横线 止损平仓 开始");
         yijianpingbuydan();
         ObjectDelete(0,"BuySL1");
         ObjectDelete(0,"SellSL1");
         menu4[8]=false;
         BuySL1=false;
         menu4_8jishu=50;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SellSL1 && menu4[8])
     {
      if(ObjectFind(0,"SellSL1")==0 && ObjectGetDouble(0,"SellSL1",OBJPROP_PRICE,0)<Bid)
        {
         comment4("K线越过了横线 止损平仓 开始");
         Print(" K线越过了横线 止损平仓 开始");
         yijianpingselldan();
         ObjectDelete(0,"BuySL1");
         ObjectDelete(0,"SellSL1");
         menu4[8]=false;
         SellSL1=false;
         menu4_8jishu=50;
        }
     }
//////////////////////////////////////////////////
   if(menu224[0])
     {
      if(ObjectFind(0,"BuySL2")==0 && ObjectGetDouble(0,"BuySL2",OBJPROP_PRICE,0)>Bid && BuySL2+menu224_0sleep<=TimeCurrent())
        {
         if(BuySL2+menu224_0sleep+30>=TimeCurrent())
           {
            pingzuijin(menu224_0geshu1);
            comment4("K线越过了横线 等待后未回来 平仓开始");
            Print(" K线越过了横线 等待后未回来 平仓最近下的",menu224_0geshu1);
            ObjectDelete(0,"BuySL2");
            ObjectDelete(0,"SellSL2");
            menu224[0]=false;
            return;
           }
         comment4("K线越过了横线 计时开始");
         Print(" K线越过了横线 计时开始");
         BuySL2=TimeCurrent();
        }
      if(ObjectFind(0,"SellSL2")==0 && ObjectGetDouble(0,"SellSL2",OBJPROP_PRICE,0)<Bid && SellSL2+menu224_0sleep<=TimeCurrent())
        {
         if(SellSL2+menu224_0sleep+30>=TimeCurrent())
           {
            pingzuijin(menu224_0geshu1);
            comment4("K线越过了横线 等待后未回来 平仓开始");
            Print(" K线越过了横线 等待后未回来 平仓最近下的",menu224_0geshu1);
            ObjectDelete(0,"BuySL2");
            ObjectDelete(0,"SellSL2");
            menu224[0]=false;
            return;
           }
         comment4("K线越过了横线 计时开始");
         Print(" K线越过了横线 计时开始");
         SellSL2=TimeCurrent();
        }
     }
//////////////////////////////////////////////////
   if(BuyTrendLineSL1)
     {
      if(ObjectFind(0,"BuyTrendLineSL1")==0 && ObjectGetDouble(0,"BuyTrendLineSL1",OBJPROP_PRICE,0)>Bid)
        {
         comment4("K线越过了横线 止损平仓最近的三单");
         Print(" K线越过了横线 止损平仓最近的三单");
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         ObjectDelete(0,"BuyTrendLineSL1");
         BuyTrendLineSL1=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SellTrendLineSL1)
     {
      if(ObjectFind(0,"SellTrendLineSL1")==0 && ObjectGetDouble(0,"SellTrendLineSL1",OBJPROP_PRICE,0)<Bid)
        {
         comment4("K线越过了横线 止损平仓最近的三单");
         Print(" K线越过了横线 止损平仓最近的三单");
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         ObjectDelete(0,"SellTrendLineSL1");
         SellTrendLineSL1=false;
        }
     }
////////////////////////////////////////////////
   if(BuyTrendLineSL2)
     {
      if(ObjectFind(0,"BuyTrendLineSL2")==0 && ObjectGetDouble(0,"BuyTrendLineSL2",OBJPROP_PRICE,0)>Bid)
        {
         comment4("K线越过了横线 止损平仓最近的四单");
         Print(" K线越过了横线 止损平仓最近的四单");
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         ObjectDelete(0,"BuyTrendLineSL2");
         BuyTrendLineSL2=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SellTrendLineSL2)
     {
      if(ObjectFind(0,"SellTrendLineSL2")==0 && ObjectGetDouble(0,"SellTrendLineSL2",OBJPROP_PRICE,0)<Bid)
        {
         comment4("K线越过了横线 止损平仓最近的四单");
         Print(" K线越过了横线 止损平仓最近的四单");
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         ObjectDelete(0,"SellTrendLineSL2");
         SellTrendLineSL2=false;
        }
     }
////////////////////////////////////////////////
   if(BuyTrendLineSL3)
     {
      if(ObjectFind(0,"BuyTrendLineSL3")==0 && ObjectGetDouble(0,"BuyTrendLineSL3",OBJPROP_PRICE,0)>Bid)
        {
         comment4("K线越过了横线 止损平仓最近的五单");
         Print(" K线越过了横线 止损平仓最近的五单");
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         zuijinBuyclose();
         ObjectDelete(0,"BuyTrendLineSL3");
         BuyTrendLineSL3=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SellTrendLineSL3)
     {
      if(ObjectFind(0,"SellTrendLineSL3")==0 && ObjectGetDouble(0,"SellTrendLineSL3",OBJPROP_PRICE,0)<Bid)
        {
         comment4("K线越过了横线 止损平仓最近的三单");
         Print(" K线越过了横线 止损平仓最近的三单");
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         zuijinSellclose();
         ObjectDelete(0,"SellTrendLineSL3");
         SellTrendLineSL3=false;
        }
     }
////////////////////////////////////////////////
////////////////////////////////////////////////
   if(menu6[4])
     {
      if(ObjectFind(0,"znBuy5mSL1")>=0 && ObjectGet("znBuy5mSL1",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy5mSL1==false)
           {
            znBuy5mSL1=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znBuy5mSL1=false;
            Print("触及5分钟智能止损线 平最近下的两单");
            comment4("触及5分钟智能止损线 平最近下的两单");
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy5mSL1");
           }
        }
      if(ObjectFind(0,"znBuy5mSL2")>=0 && ObjectGet("znBuy5mSL2",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy5mSL2==false)
           {
            znBuy5mSL2=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znBuy5mSL2=false;
            Print("触及5分钟智能止损线 平最近下的三单");
            comment4("触及5分钟智能止损线 平最近下的三单");
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy5mSL2");
           }
        }
      if(ObjectFind(0,"znBuy5mSL3")>=0 && ObjectGet("znBuy5mSL3",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy5mSL3==false)
           {
            znBuy5mSL3=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znBuy5mSL3=false;
            Print("触及5分钟智能止损线 平最近下的四单 功能关闭");
            comment4("触及5分钟智能止损线 平最近下的四单 功能关闭");
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy5mSL3");
            menu6[4]=false;
           }
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu6[6])
     {
      if(ObjectFind(0,"znBuy15mSL1")>=0 && ObjectGet("znBuy15mSL1",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy15mSL1==false)
           {
            znBuy15mSL1=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znBuy15mSL1=false;
            Print("触及15分钟智能止损线 平最近下的两单");
            comment4("触及15分钟智能止损线 平最近下的两单");
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy15mSL1");
           }
        }
      if(ObjectFind(0,"znBuy15mSL2")>=0 && ObjectGet("znBuy15mSL2",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy15mSL2==false)
           {
            znBuy15mSL2=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znBuy15mSL2=false;
            Print("触及15分钟智能止损线 平最近下的三单");
            comment4("触及15分钟智能止损线 平最近下的三单");
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy15mSL2");
           }
        }
      if(ObjectFind(0,"znBuy15mSL3")>=0 && ObjectGet("znBuy15mSL3",OBJPROP_PRICE1)>Bid)
        {
         if(znBuy15mSL3==false)
           {
            znBuy15mSL3=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znBuy15mSL3=false;
            Print("触及15分钟智能止损线 平最近下的四单 功能关闭");
            comment4("触及15分钟智能止损线 平最近下的四单 功能关闭");
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            ObjectDelete(0,"znBuy15mSL3");
            menu6[6]=false;
           }
        }
     }
/////////////////////////////////////////////////////
   if(menu6[5])
     {
      if(ObjectFind(0,"znSell5mSL1")>=0 && ObjectGet("znSell5mSL1",OBJPROP_PRICE1)<Bid)
        {
         if(znSell5mSL1==false)
           {
            znSell5mSL1=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znSell5mSL1=false;
            Print("触及5分钟智能止损线 平最近下的两单");
            comment4("触及5分钟智能止损线 平最近下的两单");
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell5mSL1");
           }
        }
      if(ObjectFind(0,"znSell5mSL2")>=0 && ObjectGet("znSell5mSL2",OBJPROP_PRICE1)<Bid)
        {
         if(znSell5mSL2==false)
           {
            znSell5mSL2=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znSell5mSL2=false;
            Print("触及5分钟智能止损线 平最近下的三单");
            comment4("触及5分钟智能止损线 平最近下的三单");
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell5mSL2");
           }
        }
      if(ObjectFind(0,"znSell5mSL3")>=0 && ObjectGet("znSell5mSL3",OBJPROP_PRICE1)<Bid)
        {
         if(znSell5mSL3==false)
           {
            znSell5mSL3=true;
            Sleep(zn5mSleep);
            return;
           }
         else
           {
            znSell5mSL3=false;
            Print("触及5分钟智能止损线 平最近下的四单 功能关闭");
            comment4("触及5分钟智能止损线 平最近下的四单 功能关闭");
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell5mSL3");
            menu6[5]=false;
           }
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu6[7])
     {
      if(ObjectFind(0,"znSell15mSL1")>=0 && ObjectGet("znSell15mSL1",OBJPROP_PRICE1)<Bid)
        {
         if(znSell15mSL1==false)
           {
            znSell15mSL1=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znSell15mSL1=false;
            Print("触及15分钟智能止损线 平最近下的两单");
            comment4("触及15分钟智能止损线 平最近下的两单");
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell15mSL1");
           }
        }
      if(ObjectFind(0,"znSell15mSL2")>=0 && ObjectGet("znSell15mSL2",OBJPROP_PRICE1)<Bid)
        {
         if(znSell15mSL2==false)
           {
            znSell15mSL2=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znSell15mSL2=false;
            Print("触及15分钟智能止损线 平最近下的三单");
            comment4("触及15分钟智能止损线 平最近下的三单");
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell15mSL2");
           }
        }
      if(ObjectFind(0,"znSell15mSL3")>=0 && ObjectGet("znSell15mSL3",OBJPROP_PRICE1)<Bid)
        {
         if(znSell15mSL3==false)
           {
            znSell15mSL3=true;
            Sleep(zn15mSleep);
            return;
           }
         else
           {
            znSell15mSL3=false;
            Print("触及15分钟智能止损线 平最近下的四单 功能关闭");
            comment4("触及15分钟智能止损线 平最近下的四单 功能关闭");
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            ObjectDelete(0,"znSell15mSL3");
            menu6[6]=false;
           }
        }
     }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(menu6[0])//短线追Buy单
     {
      if(ObjectFind(0,"dxzdBuyLineL")>=0 && dxzdBuyLineL1 && ObjectGet("dxzdBuyLineL",OBJPROP_PRICE1)>Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Buy单 触及次K线的最低价附近 追一单 1");
         comment4("短线追Buy单 触及次K线的最低价附近 追一单 1");
         dxzdBuyLineL1=false;
         ObjectSet("dxzdBuyLineL",OBJPROP_COLOR,clrDimGray);
        }
      if(ObjectFind(0,"dxzdBuyLineO")>=0 && dxzdBuyLineO1 && ObjectGet("dxzdBuyLineO",OBJPROP_PRICE1)>Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Buy单 触及次K线的开盘价附近 追一单 2");
         comment4("短线追Buy单 触及次K线的开盘价附近 追一单 2");
         dxzdBuyLineO1=false;
         ObjectSet("dxzdBuyLineO",OBJPROP_COLOR,clrDimGray);
        }
      if(ObjectFind(0,"dxzdBuyLineC")>=0 && dxzdBuyLineC1 && ObjectGet("dxzdBuyLineC",OBJPROP_PRICE1)>Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Buy单 触及次K线的收盘价附近 追一单 3");
         comment4("短线追Buy单 触及次K线的收盘价附近 追一单 3");
         Print("短线追Buy单 触及绿线开仓 关闭 如需要请按* 重新开启  ");
         comment3("短线追Buy单 触及绿线开仓 关闭 如需要请按* 重新开启  ");
         dxzdBuyLineC1=false;
         ObjectSet("dxzdBuyLineC",OBJPROP_COLOR,clrDimGray);
        }

      if(ObjectFind(0,"dxzdBuyi2kSL")>=0 && ObjectGet("dxzdBuyi2kSL",OBJPROP_PRICE1)>Bid+dxzdSLpianyiliang*Point+diancha)
        {
         if(dxzdBuyi2kSL==false)
           {
            dxzdBuyi2kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            zuijinBuyclose();
            dxzdBuyi2kSL=false;
            Print("短线追单 回撤到第一止损位 平最近下的一单");
            comment4("短线追单 回撤到第一止损位 平最近一单");
            ObjectDelete(0,"dxzdBuyi2kSL");
            ObjectDelete(0,"dxzdBuyi2kSL1");
           }
        }
      if(ObjectFind(0,"dxzdBuyi3kSL")>=0 && ObjectGet("dxzdBuyi3kSL",OBJPROP_PRICE1)>Bid+dxzdSLpianyiliang*Point+diancha)
        {
         if(dxzdBuyi3kSL==false)
           {
            dxzdBuyi3kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdBuyi3kSL=false;
            zuijinBuyclose();
            zuijinBuyclose();
            Print("短线追单 回撤到第二止损位 平最近下的两单");
            comment4("短线追单 回撤到第二止损位 平最近两单");
            ObjectDelete(0,"dxzdBuyi3kSL");
            ObjectDelete(0,"dxzdBuyi3kSL1");
           }
        }
      if(ObjectFind(0,"dxzdBuyi4kSL")>=0 && ObjectGet("dxzdBuyi4kSL",OBJPROP_PRICE1)>Bid+dxzdSLpianyiliang*Point+diancha)
        {
         if(dxzdBuyi4kSL==false)
           {
            dxzdBuyi4kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdBuyi4kSL=false;
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            Print("短线追单 回撤到第三止损位 平最近下的三单");
            comment4("线追单 回撤到第三止损位 平最近下的三单");
            ObjectDelete(0,"dxzdBuyi4kSL");
            ObjectDelete(0,"dxzdBuyi4kSL1");
           }
        }
      if(ObjectFind(0,"dxzdBuyi5kSL")>=0 && ObjectGet("dxzdBuyi5kSL",OBJPROP_PRICE1)>Bid+dxzdSLpianyiliang*Point+diancha)
        {
         if(dxzdBuyi5kSL==false)
           {
            dxzdBuyi5kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdBuyi5kSL=false;
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            zuijinBuyclose();
            Print("短线追单 回撤到第四止损位 平最近下的四单");
            comment4("线追单 回撤到第四止损位 平最近下的四单");
            Print("短线追Buy单失败 关闭追单模式");
            comment3("短线追Buy单失败 关闭追单模式");
            menu6[0]=false;
            ObjectDelete(0,"dxzdBuyi2kSL");
            ObjectDelete(0,"dxzdBuyi3kSL");
            ObjectDelete(0,"dxzdBuyi4kSL");
            ObjectDelete(0,"dxzdBuyi5kSL");
            ObjectDelete(0,"dxzdBuyi2kSL1");
            ObjectDelete(0,"dxzdBuyi3kSL1");
            ObjectDelete(0,"dxzdBuyi4kSL1");
            ObjectDelete(0,"dxzdBuyi5kSL1");
            ObjectDelete(0,"dxzdBuyLineC");
            ObjectDelete(0,"dxzdBuyLineO");
            ObjectDelete(0,"dxzdBuyLineL");
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu6[1])//短线追Sell单
     {
      if(ObjectFind(0,"dxzdSellLineH")>=0 && dxzdSellLineH1 && ObjectGet("dxzdSellLineH",OBJPROP_PRICE1)<Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Sell单 触及次K线的最高价附近 追一单 3");
         Print("短线追Sell单 触及绿线开仓 关闭 如需要请按* 重新开启  ");
         comment3("短线追Sell单 触及绿线开仓 关闭 如需要请按* 重新开启  ");
         comment4("短线追Sell单 触及次K线的最高价附近 追一单 3");
         dxzdSellLineH1=false;
         ObjectSet("dxzdSellLineH",OBJPROP_COLOR,clrDimGray);
        }
      if(ObjectFind(0,"dxzdSellLineO")>=0 && dxzdSellLineO1 && ObjectGet("dxzdSellLineO",OBJPROP_PRICE1)<Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Sell单 触及次K线的开盘价附近 追一单 2");
         comment4("短线追Sell单 触及次K线的开盘价附近 追一单 2");
         dxzdSellLineO1=false;
         ObjectSet("dxzdSellLineO",OBJPROP_COLOR,clrDimGray);
        }
      if(ObjectFind(0,"dxzdSellLineC")>=0 && dxzdSellLineC1 && ObjectGet("dxzdSellLineC",OBJPROP_PRICE1)<Bid)
        {
         int keybuy=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
           }
         Print("短线追Sell单 触及次K线的收盘价附近 追一单 1");
         comment4("短线追Sell单 触及次K线的收盘价附近 追一单 1");
         dxzdSellLineC1=false;
         ObjectSet("dxzdSellLineC",OBJPROP_COLOR,clrDimGray);
        }
      if(ObjectFind(0,"dxzdSelli2kSL")>=0 && ObjectGet("dxzdSelli2kSL",OBJPROP_PRICE1)<Bid-dxzdSLpianyiliang*Point-diancha)
        {
         if(dxzdSelli2kSL==false)
           {
            dxzdSelli2kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdSelli2kSL=false;
            zuijinSellclose();
            Print("短线追单 回撤到第一止损位 平最近下的一单");
            comment4("短线追单 回撤到第一止损位 平最近一单");
            ObjectDelete(0,"dxzdSelli2kSL");
            ObjectDelete(0,"dxzdSelli2kSL1");
           }
        }
      if(ObjectFind(0,"dxzdSelli3kSL")>=0 && ObjectGet("dxzdSelli3kSL",OBJPROP_PRICE1)<Bid-dxzdSLpianyiliang*Point-diancha)
        {
         if(dxzdSelli3kSL==false)
           {
            dxzdSelli3kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdSelli3kSL=false;
            zuijinSellclose();
            zuijinSellclose();
            Print("短线追单 回撤到第二止损位 平最近下的两单");
            comment4("短线追单 回撤到第二止损位 平最近下的两单");
            ObjectDelete(0,"dxzdSelli3kSL");
            ObjectDelete(0,"dxzdSelli3kSL1");
           }
        }
      if(ObjectFind(0,"dxzdSelli4kSL")>=0 && ObjectGet("dxzdSelli4kSL",OBJPROP_PRICE1)<Bid-dxzdSLpianyiliang*Point-diancha)
        {
         if(dxzdSelli4kSL==false)
           {
            dxzdSelli4kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdSelli4kSL=false;
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            Print("短线追单 回撤到第三止损位 平最近下的三单");
            comment4("短线追单 回撤到第三止损位 平最近下的三单");
            ObjectDelete(0,"dxzdSelli4kSL");
            ObjectDelete(0,"dxzdSelli4kSL1");
           }
        }
      if(ObjectFind(0,"dxzdSelli5kSL")>=0 && ObjectGet("dxzdSelli5kSL",OBJPROP_PRICE1)<Bid-dxzdSLpianyiliang*Point-diancha)
        {
         if(dxzdSelli5kSL==false)
           {
            dxzdSelli5kSL=true;
            Sleep(dxzdSLSleep);
            return;
           }
         else
           {
            dxzdSelli5kSL=false;
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            zuijinSellclose();
            Print("短线追单 回撤到第四止损位 平最近下的四单");
            comment4("短线追单 回撤到第四止损位 平最近下的四单");
            Print("短线追Sell单失败 关闭追单模式");
            comment3("短线追Sell单失败 关闭追单模式");
            menu6[1]=false;
            ObjectDelete(0,"dxzdSelli2kSL");
            ObjectDelete(0,"dxzdSelli3kSL");
            ObjectDelete(0,"dxzdSelli4kSL");
            ObjectDelete(0,"dxzdSelli5kSL");
            ObjectDelete(0,"dxzdSelli2kSL1");
            ObjectDelete(0,"dxzdSelli3kSL1");
            ObjectDelete(0,"dxzdSelli4kSL1");
            ObjectDelete(0,"dxzdSelli5kSL1");
            ObjectDelete(0,"dxzdSellLineC");
            ObjectDelete(0,"dxzdSellLineO");
            ObjectDelete(0,"dxzdSellLineH");
           }
        }
     }
///////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(menu3[14])
     {
      if(AccountEquity()<=gloAccountEquityLow)
        {
         Print("账户总净值低于 ",AccountEquity()," 全平仓 启动 ");
         xunhuanquanpingcangplus();
         menu3[14]=false;
         comment1("账户总净值低于多少全平仓 关闭");
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu3[15])
     {
      if(AccountEquity()>gloAccountEquityHigh)
        {
         Print("账户总净值高于 ",AccountEquity()," 全平仓 启动 ");
         xunhuanquanpingcangplus();
         menu3[15]=false;
         comment1("账户总净值高于多少全平仓 关闭");
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu3[16])
     {
      if(AccountProfit()<=gloAccountProfitmin && AccountProfit()!=0.0)
        {
         Print("总利润低于 ",AccountProfit()," 全平仓 启动 ");
         xunhuanquanpingcangplus();
         menu3[16]=false;
         comment1("总利润低于多少全平仓 关闭");
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu3[17])
     {
      if(AccountProfit()>=0)
        {
         Print("总利润低于 ",AccountProfit()," 平仓后反手 启动 ");
         yijianfanshou();
         menu3[17]=false;
        }
     }
//////////////////////////////////////////////////////////////////
   if(menu4[1])//遮盖当前K线时 隐藏时间显示
     {
      if(ObjectFind(0,"time")==0)
        {
         ObjectDelete(0,"time");
        }
     }
//////////////////////////////////////////////////////////////////////////
   if(menu[27])//
     {
      if(ObjectFind(0,"Buy Line")!=0 && ObjectFind(0,"Sell Line")!=0 && ObjectFind(0,"BuyStop1")!=0 && ObjectFind(0,"SellStop1")!=0)
        {
         if(buyLotslinshi!=CGetbuyLots() && sellLotslinshi==0.0)
           {
            SetLevel("BuyStop1",GetiHighest(0,menu27buybars,0)+menu27buypianyi*Point,clrCrimson,"BuyStop K线收盘后实体突破追");
            buyLotslinshi1=buyLotslinshi;
            comment(StringFormat("小阻力位先平仓K线实体越过再开相同的仓位追Buy单 开启 仓位%G手",buyLotslinshi1));
            Print("小阻力位先平仓K线实体越过再开相同的仓位追Buy单 开启 仓位",buyLotslinshi1,"手");
           }
         if(buyLotslinshi==0.0 && sellLotslinshi!=CGetsellLots())
           {
            SetLevel("SellStop1",GetiLowest(0,menu27sellbars,0)-menu27sellpianyi*Point,clrOliveDrab,"SellStop K线收盘后实体突破追");
            sellLotslinshi1=sellLotslinshi;
            comment(StringFormat("小阻力位先平仓K线实体越过再开相同的仓位追Sell单 开启 仓位%G手",sellLotslinshi1));
            Print("小阻力位先平仓K线实体越过再开相同的仓位追Sell单 开启 仓位",sellLotslinshi1,"手");
           }
        }
     }
///////////////////////////////////////////////////////////////////////////
   if(menu[28])//
     {
      if(ObjectFind(0,"Buy Line")!=0 && ObjectFind(0,"Sell Line")!=0)
        {
         if(buyLotslinshi!=CGetbuyLots() && sellLotslinshi==0.0)
           {
            SetLevel("Buy Line",sellline-a12pingcangpianyi*Point,Red);
            buyline=sellline-a12pingcangpianyi*Point;
            buylineOnTimer=Bid;
            huaxiankaicanggeshu1 = (int)MathRound(buyLotslinshi/keylots);
            monianjian(29);
            monianjian(38);
            monianjian(37);
            comment(StringFormat("策略性平仓回撤几个点后再下相同的订单追 开启 仓位 %G",huaxiankaicanggeshu1*keylots));
            Print("策略性平仓回撤几个点后再下相同的订单追 开启 仓位 ",huaxiankaicanggeshu1*keylots);
            menu[28]=false;
           }
         if(buyLotslinshi==0.0 && sellLotslinshi!=CGetsellLots())
           {
            SetLevel("Sell Line",buyline+a12pingcangpianyi*Point,ForestGreen);
            sellline=buyline+a12pingcangpianyi*Point;
            selllineOnTimer=Bid;
            huaxiankaicanggeshu1 = (int)MathRound(sellLotslinshi/keylots);
            monianjian(29);
            monianjian(38);
            monianjian(37);
            comment(StringFormat("策略性平仓回撤几个点后再下相同的订单追 开启 仓位 %G",huaxiankaicanggeshu1*keylots));
            Print("策略性平仓回撤几个点后再下相同的订单追 开启 仓位 ",huaxiankaicanggeshu1*keylots);
            menu[28]=false;
           }
        }
     }
//////////////////////////////////////////////////////////////////////////////////////////////
   if(menu8[9])//
     {
      //Print(lpriceK[ArrayMinimum(lpriceK,3,0)]);
      if(lpriceK[ArrayMinimum(lpriceK,3,1)]-pianyilingGlo>Bid)
        {
         yijianpingbuydan();
         Print("5分钟追多单价格回撤 突破了最近的2根K线最低点先平仓 ");
         comment1("5分钟追多单价格回撤 突破了最近的2根K线最低点先平仓");
         menu8[9]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[10])
     {
      // Print(hpriceK[ArrayMaximum(hpriceK,3,1)]);
      if(hpriceK[ArrayMaximum(hpriceK,3,1)]+pianyilingGlo<Bid)
        {
         yijianpingselldan();
         Print("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓 ");
         comment1("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓");
         menu8[10]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[11])
     {
      if(lpriceK[ArrayMinimum(lpriceK,4,1)]-pianyilingGlo>Bid)
        {
         yijianpingbuydan();
         Print("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓 ");
         comment1("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓");
         menu8[11]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[12])
     {
      if(hpriceK[ArrayMaximum(hpriceK,4,1)]+pianyilingGlo<Bid)
        {
         yijianpingselldan();
         Print("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓 ");
         comment1("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓");
         menu8[12]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[13])
     {
      if(yinyang5mkaicang1Kyangbuy)
        {
         Print("5分钟收阳了 开多追一单 ");
         comment1("5分钟收阳了 开多追一单");
         monianjian(73);
         yinyang5mkaicang1Kyangbuy=false;
         menu8[13]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[14])
     {
      if(yinyang5mkaicang1Kyinsell)
        {
         Print("5分钟收阴了 开空追一单 ");
         comment1("5分钟收阴了 开空追一单");
         monianjian(77);
         yinyang5mkaicang1Kyinsell=false;
         menu8[14]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[15])//
     {
      if(yinyang5mkaicang1Kyangbuyheng)
        {
         if(ObjectFind(0,"Buy Line")==0)
           {
            monianjian(16);
            monianjian(16);
            ObjectDelete(0,"Buy Line");
           }
         SetLevel("Buy Line",cpriceK[1]-yinyang5mkaicang1Kyangbuyhengpianyi*Point,Red);
         buylineOnTimer=Bid;
         monianjian(285);
         monianjian(38);
         monianjian(37);
         Print("5分钟收阳 横线模式开多单追 ");
         comment1("5分钟收阳 横线模式开多单追");
         yinyang5mkaicang1Kyangbuyheng=false;
         menu8[15]=false;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu8[16])
     {
      if(yinyang5mkaicang1Kyinsellheng)
        {
         if(ObjectFind(0,"Sell Line")==0)
           {
            monianjian(16);
            ObjectDelete(0,"Sell Line");
           }
         SetLevel("Sell Line",cpriceK[1]+yinyang5mkaicang1Kyangbuyhengpianyi*Point,ForestGreen);
         selllineOnTimer=Bid;
         monianjian(285);
         monianjian(38);
         monianjian(37);
         Print("5分钟收阴 横线模式开空单追 ");
         comment1("5分钟收阴 横线模式开空单追");
         yinyang5mkaicang1Kyinsellheng=false;
         menu8[16]=false;
        }
     }
/////////////////////////////////////////////////////////////////////////////
   if(iBreakoutSLpingcangNow)//Breakout指标 突破箱体 直接止损平仓
     {
      double ibreakout;
      ibreakout=NormalizeDouble(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0),2);
      if(ibreakout==0.0)
        {
         comment("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4 ");
         Print("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4");
         iBreakoutSLpingcangNow=false;
         return;
        }

      if(ibreakout>iBreakoutSLpingcangNowmax)
        {
         yijianpingselldan();
         iBreakoutSLpingcangNow=false;
         Print("Breakout指标 突破箱体 止损平仓");
        }
      if(ibreakout<-iBreakoutSLpingcangNowmax)
        {
         yijianpingbuydan();
         iBreakoutSLpingcangNow=false;
         Print("Breakout指标 突破箱体 止损平仓");
        }
     }
//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
   if(yinyang5mkaicang)//当前5分钟图表最近两根K线收盘时颜色相同开仓追单
     {
      if(yinyang5mkaicang1)
        {
         if(yinyang5m1k)
           {
            for(int i=yinyang5mkaicanggeshu1; i>0; i--)//
              {
               Sleep(yinyang5mkaicangSleep);
               int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  i++;
                  Print("GetLastError=",error());
                 }
              }
            yinyang5mkaicang1=false;
            yinyang5mkaicang=false;
            menu8[0]=false;
            Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单完成");
            comment1("当前5分钟图表最近两根K线收盘时颜色相同开仓追单完成");
           }
         else
           {
            for(int i=yinyang5mkaicanggeshu1; i>0; i--)//
              {
               Sleep(yinyang5mkaicangSleep);
               int  keybuy10=OrderSend(Symbol(),OP_SELL,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  i++;
                  Print(error());
                 }
              }
            yinyang5mkaicang1=false;
            yinyang5mkaicang=false;
            menu8[0]=false;
            Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单完成");
            comment1("当前5分钟图表最近两根K线收盘时颜色相同开仓追单完成");
           }
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mkaicangshiftR)//5分钟出现两根相同颜色的K线启动横线模式追单
     {
      if(yinyang5mkaicangshiftR1)//
        {
         if(yinyang5m1k)
           {
            SetLevel("Buy Line",Bid-yinyang5mkaicangshiftRpianyi*Point,Red);
            buylineOnTimer=Bid;
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");

            linebuykaicang=true;
            linekaicangT=true;
            huaxiankaicanggeshuT1=yinyang5mkaicanggeshu1;
            huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
            if(huaxiankaicangtimeTP<0)
               huaxiankaicangtimeTP=0;
            shangpress=0;
            xiapress=0;
            linelock=true;
            Print("触及横线开Buy单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
            comment(StringFormat("触及不带止损开Buy单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));

            yinyang5mkaicangshiftR=false;
            yinyang5mkaicangshiftR1=false;
            menu8[1]=false;
            Print("5分钟出现两根相同颜色的K线启动横线模式追单完成");
            comment1("5分钟出现两根相同颜色的K线启动横线模式追单完成");
           }
         else
           {
            SetLevel("Sell Line",Ask+yinyang5mkaicangshiftRpianyi*Point,ForestGreen);
            selllineOnTimer=Bid;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");

            linesellkaicang=true;
            linekaicangT=true;
            huaxiankaicanggeshuT1=yinyang5mkaicanggeshu1;
            huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*1000;
            if(huaxiankaicangtimeTP<0)
               huaxiankaicangtimeTP=0;
            shangpress=0;
            xiapress=0;
            linelock=true;
            Print("触及横线开sell单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
            comment(StringFormat("触及不带止损开sell单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));

            yinyang5mkaicangshiftR=false;
            yinyang5mkaicangshiftR1=false;
            menu8[1]=false;
            Print("5分钟出现两根相同颜色的K线启动横线模式追单完成");
            comment1("5分钟出现两根相同颜色的K线启动横线模式追单完成");
           }
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcang)//当前5分钟图表最近两根K线收盘时颜色相同时平仓
     {
      if(yinyang5mpingcangtime+yinyang5mpingcangtime1>=TimeCurrent())
        {
         yinyang5mpingcang=false;
         menu8[2]=false;
         Print("5分钟图表最近两根K线收盘时颜色相同时 平仓 超时关闭 ",yinyang5mpingcangtime1);
         comment1("5分钟图表最近两根K线收盘时颜色相同时 平仓 超时关闭");
        }
      if(yinyang5mpingcang1)
        {
         Sleep(yinyang5mpingcangSleep);
         yijianpingcang();
         yinyang5mpingcang=false;
         yinyang5mpingcang1=false;
         menu8[2]=false;
         Print("5分钟图表最近两根K线收盘时颜色相同时 平仓 完成");
         comment1("5分钟图表最近两根K线收盘时颜色相同时 平仓 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangBuy1K2Kyin)//5分钟追多单时 连续出现两根阴线 直接平仓
     {
      if(yinyang5mpingcangBuy1K2Kyin1)
        {
         Sleep(yinyang5mpingcangSleep);
         yijianpingbuydan();
         yinyang5mpingcangBuy1K2Kyin=false;
         yinyang5mpingcangBuy1K2Kyin1=false;
         menu8[5]=false;
         Print("5分钟追多单时 连续出现两根阴线 直接平仓 完成");
         comment1("5分钟追多单时 连续出现两根阴线 直接平仓 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangSell1K2Kyang)//5分钟追空单时 连续出现两根阳线 直接平仓
     {
      if(yinyang5mpingcangSell1K2Kyang1)
        {
         Sleep(yinyang5mpingcangSleep);
         yijianpingselldan();
         yinyang5mpingcangSell1K2Kyang=false;
         yinyang5mpingcangSell1K2Kyang1=false;
         menu8[6]=false;
         Print("5分钟追空单时 连续出现两根阳线 直接平仓 完成");
         comment1("5分钟追空单时 连续出现两根阳线 直接平仓 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangBuy1K2K3Kyin)//5分钟追多单时 连续出现3根阴线 直接平仓
     {
      if(yinyang5mpingcangBuy1K2K3Kyin1)
        {
         Sleep(yinyang5mpingcangSleep);
         yijianpingbuydan();
         yinyang5mpingcangBuy1K2K3Kyin=false;
         yinyang5mpingcangBuy1K2K3Kyin1=false;
         menu8[7]=false;
         Print("5分钟追多单时 连续出现3根阴线 直接平仓 完成");
         comment1("5分钟追多单时 连续出现3根阴线 直接平仓 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangSell1K2K3Kyang)//5分钟追空单时 连续出现两根阳线 直接平仓
     {
      if(yinyang5mpingcangSell1K2K3Kyang1)
        {
         Sleep(yinyang5mpingcangSleep);
         yijianpingselldan();
         yinyang5mpingcangSell1K2K3Kyang=false;
         yinyang5mpingcangSell1K2K3Kyang1=false;
         menu8[8]=false;
         Print("5分钟追空单时 连续出现3根阳线 直接平仓 完成");
         comment1("5分钟追空单时 连续出现3根阳线 直接平仓 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangshiftR)//当前5分钟图表最近两根K线收盘时颜色相同时 平仓后反手
     {
      if(yinyang5mpingcangtime+yinyang5mpingcangtime1>=TimeCurrent())
        {
         yinyang5mpingcangshiftR=false;
         menu8[3]=false;
         Print("5分钟图表最近两根K线收盘时颜色相同时平仓后反手 超时关闭 ",yinyang5mpingcangtime1);
         comment1("5分钟图表最近两根K线收盘时颜色相同时平仓后反手 超时关闭");
        }
      if(yinyang5mpingcangshiftR1)
        {
         Sleep(yinyang5mpingcangshiftRSleep);
         yijianfanshou();
         yinyang5mpingcangshiftR=false;
         yinyang5mpingcangshiftR1=false;
         menu8[3]=false;
         Print("5分钟图表最近两根K线收盘时颜色相同时 平仓后反手 完成");
         comment1("5分钟图表最近两根K线收盘时颜色相同时 平仓后反手 完成");
        }
     }
////////////////////////////////////////////////////////////////////////
   if(yinyang5mpingcangctrlR)//最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓
     {
      if(yinyang5mpingcangctrlR1)
        {
         Sleep(yinyang5mpingcangctrlRSleep);
         yijianpingcang();
         yinyang5mpingcangctrlR=false;
         yinyang5mpingcangctrlR1=false;
         menu8[4]=false;
         Print("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 完成");
         comment1("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 完成");
        }
     }
//////////////////////////////////////////////////////////////////////
   if(breakoutNot)//
     {
      if(breakoutNot1)
        {
         if(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0)>=100 || iCustom(NULL,0,"Custom/XU v4-Breakout",1,0)<=-100)
           {
            comment1("突破了当前图表周期的短期阻力位哈 -Breakout");
            Print("突破了当前图表周期的短期阻力位哈 -Breakout");

            if(menu3[22]==false)
              {
               PlaySound("alert.wav");
               PlaySound("maidou.wav");
              }
            breakoutNottimeCurrent=TimeCurrent();
            breakoutNot1=false;
           }
        }
     }
/////////////////////////////////////
   if(accountProfitswitch)
     {
      if(AccountProfit()>=accountProfitmax  || AccountProfit()<-accountProfitmin)
        {
         Print("订单总利润为 ",AccountProfit(),"账户全平仓");
         xunhuanquanpingcangplus();
         if(ObjectFind(0,"zonglirun")==0)
            ObjectDelete(0,"zonglirun");
         if(GlobalVariableGet("gloaccountProfitswitch")==0)
           {
            accountProfitswitch=false;
            accountProfitswitch1=false;
            menu3[0]=false;
            menu3[1]=false;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(accountProfitswitch1)//薅羊毛
     {
      if(AccountProfit()>=accountProfitmax1  || AccountProfit()<-accountProfitmin1)
        {
         Print("订单总利润为 ",AccountProfit(),"账户全平仓");
         xunhuanquanpingcangplus();
         accountProfitswitch1=false;//
         menu3[1]=false;
         if(ObjectFind(0,"zonglirun1")==0)
            ObjectDelete(0,"zonglirun1");
        }

     }
///////////////////////////////////////////////////////////////////////////////
   if(huaxianguadan)//划线挂单
     {
      Huaxianguadan();
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(huaxiankaicang)//触及线开仓
     {
      Huaxiankaicang();
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(huaxianSwitch)
     {
      HuaxianSwitch();
     }
/////////////////////////////////////////////////////////////////////////////////////横线模式开始
   if(linebuykaicang && buyline>=Bid && buyline<buylineOnTimer)//触及横线开仓 buy  L+K  buyline横线在当前价之下
     {
      Print("buyline横线在当前价之下 buyline<buylineOnTimer buyline ",buyline,"buylineOnTimer ",buylineOnTimer);
      if(linekaicangshiftR)//参考时间和价格 带止损
        {
         if(buyline>=Bid)
           {
            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(true,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;
                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linebuykaicang=false;
                     linekaicangshiftR=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
           }
        }
      else
        {
         if(linekaicangT && buyline>=Bid)//触及横线开仓 buy 参考时间和价格 X键提前生成止损线止损 无止损线不带止损
           {

            Sleep(huaxiankaicangtimeTP);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            comment5("开仓中..计时 如果文字消失后重现 没越过横线 在附近 也会继续开仓");
            // Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,slline,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linebuykaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            if(linekaicangctrl)//触及横线开仓 buy 只开一次
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots*huaxiankaicanggeshu1,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"BuyStop1");
                  ObjectDelete(0,"SellStop1");
                  buyLotslinshi1=0.0;
                  sellLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linebuykaicang=false;
               linekaicangctrl=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
            else
              {
               for(int i=huaxiankaicanggeshu1; i>0; i--)//触及横线开仓 buy 只参考时间
                 {
                  RefreshRates();
                  Sleep(huaxiankaicangtimeP);
                  //Print(TimeCurrent(),"  ",i);
                  //Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
                  int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                     PlaySound("ok.wav");
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linebuykaicang=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }

        }
     }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linebuykaicang && buyline>buylineOnTimer && buyline<=Bid)//触及横线开仓 buy  L+K```   buyline横线在当前价之上
     {
      Print("buyline横线在当前价之上 buyline>buylineOnTimer buyline ",buyline,"buylineOnTimer ",buylineOnTimer);
      if(linekaicangshiftR)//参考时间和价格 带止损
        {
         if(buyline<=Bid)
           {
            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(true,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;

                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linebuykaicang=false;
                     linekaicangshiftR=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
           }
        }
      else
        {
         if(linekaicangT && buyline<=Bid)//触及横线开仓 buy 参考时间和价格 X键提前生成止损线止损 无止损线不带止损
           {
            Sleep(huaxiankaicangtimeTP);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            comment5("开仓中..计时 如果文字消失后重现 没越过横线 在附近 也会继续开仓");
            // Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,slline,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linebuykaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            if(linekaicangctrl)//触及横线开仓 buy 只开一次
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots*huaxiankaicanggeshu1,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"BuyStop1");
                  ObjectDelete(0,"SellStop1");
                  buyLotslinshi1=0.0;
                  sellLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linebuykaicang=false;
               linekaicangctrl=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
            else
              {
               for(int i=huaxiankaicanggeshu1; i>0; i--)//触及横线开仓 buy 只参考时间
                 {
                  RefreshRates();
                  Sleep(huaxiankaicangtimeP);
                  //Print(TimeCurrent(),"  ",i);
                  //Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
                  int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                     PlaySound("ok.wav");
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linebuykaicang=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }

        }
     }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linesellkaicang && sellline>selllineOnTimer && sellline<=Bid)//触及横线开仓 sell  横线在当前价之上
     {
      if(linekaicangshiftR)
        {
         if(sellline<=Bid)
           {

            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(false,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;
                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linekaicangshiftR=false;
                     linesellkaicang=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
            //  Sleep(huaxiankaicangtimeshiftR);
           }
        }
      else
        {
         if(linekaicangT && sellline<=Bid)
           {
            Sleep(huaxiankaicangtimeTP);
            // Print(TimeCurrent(),"  ",huaxiankaicanggeshuT1);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            comment5("开仓中..计时 如果文字消失后重现 没越过横线 在附近 也会继续开仓");
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,slline,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linesellkaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            if(linekaicangctrl)//触及横线开仓 sell 只开一次
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,keylots*huaxiankaicanggeshu1,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"BuyStop1");
                  ObjectDelete(0,"SellStop1");
                  buyLotslinshi1=0.0;
                  sellLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linesellkaicang=false;
               linekaicangctrl=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
            else
              {
               for(int i=huaxiankaicanggeshu1; i>0; i--)
                 {
                  Sleep(huaxiankaicangtimeP);
                  //Print(TimeCurrent(),"  ",i);
                  //Print("市价卖一单 处理中 . . .");comment("市价卖一单 处理中 . . .");
                  int keysell10=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
                  if(keysell10>0)
                     PlaySound("ok.wav");
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linesellkaicang=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }

        }
     }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linesellkaicang && sellline<selllineOnTimer && sellline>=Bid)//触及横线开仓 sell  横线在当前价之下
     {
      if(linekaicangshiftR)
        {
         if(sellline>=Bid)
           {

            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(false,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;
                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linekaicangshiftR=false;
                     linesellkaicang=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
            //  Sleep(huaxiankaicangtimeshiftR);
           }
        }
      else
        {
         if(linekaicangT && sellline>=Bid)
           {
            Sleep(huaxiankaicangtimeTP);
            // Print(TimeCurrent(),"  ",huaxiankaicanggeshuT1);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            comment5("开仓中..计时 如果文字消失后重现 没越过横线 在附近 也会继续开仓");
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,slline,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            else
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linesellkaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            if(linekaicangctrl)//触及横线开仓 sell 只开一次
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,keylots*huaxiankaicanggeshu1,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"BuyStop1");
                  ObjectDelete(0,"SellStop1");
                  buyLotslinshi1=0.0;
                  sellLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linesellkaicang=false;
               linekaicangctrl=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
            else
              {
               for(int i=huaxiankaicanggeshu1; i>0; i--)
                 {
                  RefreshRates();
                  Sleep(huaxiankaicangtimeP);
                  //Print(TimeCurrent(),"  ",i);
                  //Print("市价卖一单 处理中 . . .");comment("市价卖一单 处理中 . . .");
                  int keysell10=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
                  if(keysell10>0)
                     PlaySound("ok.wav");
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
               huaxiankaicanggeshu1=huaxiankaicanggeshu;
               linesellkaicang=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }

        }
     }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(OnTickswitch==false)//没订单时以后 OnTick 模块不运行
     {
      return;
     }
//////////////////////////////////////////////////////////////////////////////////////
   if(iBreakoutfanshou)//依据指标全平后反手开仓F+I+3
     {
      double ibreakout;
      if(iBreakoutfanshou15)
        {
         ibreakout=NormalizeDouble(iCustom(NULL,15,"Custom/XU v4-Breakout",1,0),2);
         //Print(ibreakout);
        }
      else
        {
         ibreakout=NormalizeDouble(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0),2);
         //Print(ibreakout);
        }

      if(ibreakout==0.0)
        {
         comment("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4 ");
         Print("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4");
         iBreakoutfanshou=false;
         return;
        }
      if(ibreakout>iBreakoutfanshoumax)
        {

         if(GetHoldingbuyOrdersCount()>0.0 && GetHoldingsellOrdersCount()==0.0) //多单
           {
            yijianfanshou();
            iBreakoutfanshou=false;
            Print("Breakout指标 大于",iBreakoutfanshoumax,"多单全平后反手开仓 ",ibreakout);
           }

         if(GetHoldingsellOrdersCount()>0.0 && GetHoldingbuyOrdersCount()>0.0)//多空单都有
           {
            iBreakoutfanshou=false;
            Print("多空单都有 无法反手开仓 Breakout指标");
            comment1("多空单都有 无法反手开仓 Breakout指标");
           }
        }
      if(ibreakout<-iBreakoutfanshoumax)
        {
         if(GetHoldingsellOrdersCount()>0.0 && GetHoldingbuyOrdersCount()==0.0)//空单
           {
            yijianfanshou();
            iBreakoutfanshou=false;
            Print("Breakout指标 小于",-iBreakoutfanshoumax,"空单全平后反手开仓 ",ibreakout);
           }
         if(GetHoldingsellOrdersCount()>0.0 && GetHoldingbuyOrdersCount()>0.0)//多空单都有
           {
            iBreakoutfanshou=false;
            Print("多空单都有 无法反手开仓 Breakout指标");
            comment1("多空单都有 无法反手开仓 Breakout指标");
           }
        }
     }
///////////////////////////////////////////////////////////////////////////////////////
   if(dingshipingcang)//当前五分钟K线收线时平仓
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang=false;
            Print("五分钟K线收线时平仓 完成");
            comment("五分钟K线收线时平仓 完成");
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(dingshipingcang15)//当前十五分钟K线收线时平仓
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang15=false;
            Print("十五分钟K线收线时平仓 完成");
            comment("十五分钟K线收线时平仓 完成");
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(dingshipingcangF)//当前五分钟K线收线时平仓反手
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓后反手触发时间 ",TimeCurrent());
            yijianfanshou();
            dingshipingcangF=false;
            Print("五分钟K线收线时平仓后反手 完成");
            comment("五分钟K线收线时平仓后反手 完成");
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(dingshipingcang15F)//当前十五分钟K线收线时平仓后反手
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓后反手触发时间 ",TimeCurrent());
            yijianfanshou();
            dingshipingcang15F=false;
            Print("十五分钟K线收线时平仓后反手 完成");
            comment("十五分钟K线收线时平仓后反手 完成");
           }
        }
     }
/////////////////////////////////////////////////////////////////////// 剥头皮开始
   if(SLbuylineQpingcangT1)//*键下单用 buy单超过横线一单一单平仓 仅止盈用
     {
      if(SLsellQpengcangline1<=Bid)
        {
         Sleep(SLQlinepingcangSleep);
         yijianpingcangMagic(1688);
         SLbuylineQpingcangT1=false;
         SLbuylineQpingcang1=false;
         SLsellQpengcangline1=Bid+10000*Point;
         ObjectMove(0,"SLsellQpengcangline1",0,Time[0],SLsellQpengcangline1);
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SLselllineQpingcangT1)//*键下单用 sell单超过横线一单一单平仓 仅止盈用
     {
      if(SLbuyQpengcangline1>=Bid)
        {
         Sleep(SLQlinepingcangSleep);
         yijianpingcangMagic(1688);
         SLselllineQpingcangT1=false;
         SLselllineQpingcang1=false;
         SLbuyQpengcangline1=Ask-10000*Point;
         ObjectMove(0,"SLbuyQpengcangline1",0,Time[0],SLbuyQpengcangline1);
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SLbuylineQpingcangT)//buy单超过横线一单一单平仓 仅止盈用 平最近的
     {
      //    Sleep(linepingcangRTime);
      if(SLsellQpengcangline<=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetbuyLots()==0.0)
           {
            SLsellQpengcangline=Bid+10000*Point;
            ObjectMove(0,"SLsellQpengcangline",0,Time[0],SLsellQpengcangline);
           }
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SLselllineQpingcangT)//sell单超过横线一单一单平仓 仅止盈用 平最近的
     {
      //   Sleep(linepingcangRTime);
      if(SLbuyQpengcangline>=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetsellLots()==0.0)
           {
            SLbuyQpengcangline=Ask-10000*Point;
            ObjectMove(0,"SLbuyQpengcangline",0,Time[0],SLbuyQpengcangline);
           }
        }
     }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SLbuylinepingcang)//buy单越过横线一单一单止损平仓
     {
      if(SL1mbuyLineprice>=Ask || SL5mbuyLineprice>=Ask || SL15mbuyLineprice>=Ask)//触及止损线会平掉部分仓位
        {
         if(SL1mbuyLineprice>=Ask)
           {
            if(SLlinepingcangjishu>SLlinepingcangjishu1)
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
               SLlinepingcangjishu1++;
              }
            else
              {
               SLlinepingcangjishu1=0;
               SL1mbuyLine=false;
               SL1mbuyLineprice=Ask-1000*Point;
               if(ObjectFind("SL1mbuyLine")==0)
                  ObjectDelete("SL1mbuyLine");
              }
           }
         else
           {
            if(SL5mbuyLineprice>=Ask)
              {
               if(SLlinepingcangjishu>SLlinepingcangjishu1)
                 {
                  Sleep(SLlinepingcangtime);
                  zuijinkeyclose();
                  zuijinkeyclose();
                  SLlinepingcangjishu1++;
                 }
               else
                 {
                  SLlinepingcangjishu1=0;
                  SL5mbuyLine=false;
                  SL5mbuyLineprice=Ask-1000*Point;
                  if(ObjectFind("SL5mbuyLine")==0)
                     ObjectDelete("SL5mbuyLine");
                 }
              }
            else
              {
               if(SL5mbuyLineprice>=Ask)
                 {
                  Sleep(SLlinepingcangtime);
                  xunhuanquanpingcang();
                  SL15mbuyLine=false;
                  SL15mbuyLineprice=Ask-1000*Point;
                  if(ObjectFind("SL15mbuyLine")==0)
                     ObjectDelete("SL15mbuyLine");
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SLselllinepingcang)//sell单越过横线一单一单止损平仓
     {
      if(SL1msellLineprice<=Bid || SL5msellLineprice<=Bid || SL15msellLineprice<=Bid)
        {
         if(SL1msellLineprice<=Bid)
           {
            if(SLlinepingcangjishu>SLlinepingcangjishu1)
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
               SLlinepingcangjishu1++;
              }
            else
              {
               SLlinepingcangjishu1=0;
               SL1msellLine=false;
               SL1msellLineprice=Bid+1000*Point;
               if(ObjectFind("SL1msellLine")==0)
                  ObjectDelete("SL1msellLine");
              }
           }
         else
           {
            if(SL5msellLineprice<=Bid)
              {
               if(SLlinepingcangjishu>SLlinepingcangjishu1)
                 {
                  Sleep(SLlinepingcangtime);
                  zuijinkeyclose();
                  zuijinkeyclose();
                  SLlinepingcangjishu1++;
                 }
               else
                 {
                  SLlinepingcangjishu1=0;
                  SL5msellLine=false;
                  SL5msellLineprice=Bid+1000*Point;
                  if(ObjectFind("SL5msellLine")==0)
                     ObjectDelete("SL5msellLine");
                 }
              }
            else
              {
               if(SL15msellLineprice<=Bid)
                 {
                  Sleep(SLlinepingcangtime);
                  xunhuanquanpingcang();
                  if(ObjectFind("SL15msellLine")==0)
                     ObjectDelete("SL15msellLine");
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                 }
              }
           }
        }
     }

////////////////////////////////////////////////////////////////////// 剥头皮结束
   if(linebuyfansuo)/////////////////////////////////////////////////////////触及横线buy单临时锁仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之下");

         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         suocang();
         linebuyfansuo=false;
         linelock=false;
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之上");
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         suocang();
         linebuyfansuo=false;
         linelock=false;
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(linesellfansuo)//触及横线sell单临时锁仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         suocang();
         linesellfansuo=false;
         linelock=false;
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         suocang();
         linesellfansuo=false;
         linelock=false;
        }
     }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(yijianFanshou  && ObjectFind(0,"Buy Line")==0)//触及横线全平后反手开仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之下");
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之上");
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(yijianFanshou  &&  ObjectFind(0,"Sell Line")==0)//触及横线全平后反手开仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }
///////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linebuypingcangR)////buy单超过横线一单一单平仓 仅止盈用
     {
      if(ObjectFind(0,"Sell Line")==0 && sellline<=Bid && buytime01+timeseconds<=TimeCurrent())
        {
         buytime01=TimeCurrent();
         zuijinkeyclose();
         if(CGetbuyLots()==0.0)
           {
            linebuypingcangR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            Print("超过横线一单一单平仓 关闭");
           }
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(linesellpingcangR)//sell单超过横线一单一单平仓 仅止盈用
     {
      if(ObjectFind(0,"Buy Line")==0 && buyline>=Bid && selltime01+timeseconds<=TimeCurrent())
        {
         selltime01=TimeCurrent();
         zuijinkeyclose();
         if(CGetsellLots()==0.0)
           {
            linesellpingcangR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            Print("超过横线一单一单平仓 关闭");
           }
        }
     }
/////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linebuypingcang)//触及横线全平仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         if(linebuypingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            if(fkeyHolding)
              {
               //PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               //PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               sellline=buyline+linebuypingcangctrlRpianyi*Point;
               SetLevel("Sell Line",sellline,ForestGreen);
               yijianFanshou=true;
               linebuypingcang=false;
               linebuypingcangctrlR=false;
               linelock=false;
               fkeyHolding=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
              }
            else
              {
               PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               linebuypingcang=false;
               linebuypingcangctrlR=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linebuypingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linebuypingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  if(fkeyHoldingfanshou)//
                    {
                     if(CGetbuyLots()!=0.0  && CGetsellLots()==0.0)
                       {
                        sellline=buyline+fkeyHoldingfanshoupianyi1*Point;
                        SetLevel("Sell Line",sellline,ForestGreen);
                        selllineOnTimer=Bid;
                        linesellkaicang=true;
                        linekaicangctrl=true;
                        huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetbuyLots()/keylots));
                        fkeyHoldingfanshou=false;
                        fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                        xunhuanquanpingcang();
                        linebuypingcang=false;
                        Print("平仓后距现价多少点移动横线挂反手单 开启 sell横线之下 开仓个数 ",huaxiankaicanggeshu1);
                        comment("平仓后距现价多少点移动横线挂反手单 开启 sell");
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                       }
                     else
                       {
                        if(CGetbuyLots()==0.0  && CGetsellLots()!=0.0)
                          {
                           buyline=buyline-fkeyHoldingfanshoupianyi1*Point;
                           SetLevel("Buy Line",buyline,Red);
                           linebuykaicang=true;
                           linekaicangctrl=true;
                           huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetsellLots()/keylots));
                           fkeyHoldingfanshou=false;
                           fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           Print("平仓后距现价多少点移动横线挂反手单 开启 buy横线之下 开仓个数",huaxiankaicanggeshu1," ",buyline);
                           comment("平仓后距现价多少点移动横线挂反手单 开启 buy");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           Print("订单方向不一致 平仓后移动横线挂反手单 无法开启 ");
                           comment("订单方向不一致 平仓后移动横线挂反手单 无法开启");
                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           linelock=false;
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                       }
                    }
                  else
                    {
                     if(menu[24])
                       {
                        yiyang5mpingcangshiti1=true;
                       }
                     else
                       {
                        xunhuanquanpingcang();
                        linebuypingcang=false;
                        linelock=false;
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                    }

                 }

              }

           }
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         if(linebuypingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            if(fkeyHolding)
              {
               //PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               //PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               buyline=buyline-linebuypingcangctrlRpianyi*Point;
               SetLevel("Buy Line",buyline,Red);
               yijianFanshou=true;
               linebuypingcang=false;
               linebuypingcangctrlR=false;
               linelock=false;
               fkeyHolding=false;
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
            else
              {
               PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               linebuypingcang=false;
               linebuypingcangctrlR=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linebuypingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linebuypingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  if(fkeyHoldingfanshou)//
                    {
                     if(CGetbuyLots()!=0.0  && CGetsellLots()==0.0)
                       {
                        sellline=buyline+fkeyHoldingfanshoupianyi1*Point;
                        SetLevel("Sell Line",sellline,ForestGreen);
                        selllineOnTimer=Bid;
                        linesellkaicang=true;
                        linekaicangctrl=true;
                        huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetbuyLots()/keylots));
                        fkeyHoldingfanshou=false;
                        fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                        xunhuanquanpingcang();
                        linebuypingcang=false;
                        Print("平仓后距现价多少点移动横线挂反手单 开启 sell横线之上 开仓个数 ",huaxiankaicanggeshu1);
                        comment("平仓后距现价多少点移动横线挂反手单 开启 sell");
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                       }
                     else
                       {
                        if(CGetbuyLots()==0.0  && CGetsellLots()!=0.0)
                          {
                           buyline=buyline-fkeyHoldingfanshoupianyi1*Point;
                           SetLevel("Buy Line",buyline,Red);
                           linebuykaicang=true;
                           linekaicangctrl=true;
                           huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetsellLots()/keylots));
                           fkeyHoldingfanshou=false;
                           fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           Print("平仓后距现价多少点移动横线挂反手单 开启 buy横线之上 开仓个数",huaxiankaicanggeshu1," ",buyline);
                           comment("平仓后距现价多少点移动横线挂反手单 开启 buy");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           Print("订单方向不一致 平仓后移动横线挂反手单 无法开启 ");
                           comment("订单方向不一致 平仓后移动横线挂反手单 无法开启");
                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           linelock=false;
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                       }
                    }
                  else
                    {
                     if(menu[24])
                       {
                        //yiyang5mpingcangshiti1=true;
                       }
                     else
                       {
                        xunhuanquanpingcang();
                        linebuypingcang=false;
                        linelock=false;
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                    }
                 }

              }
           }
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(linesellpingcang)//触及横线全平仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         if(linesellpingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            if(fkeyHolding)
              {
               //PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               //PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               buyline=sellline-linebuypingcangctrlRpianyi*Point;
               SetLevel("Buy Line",buyline,Red);
               yijianFanshou=true;
               linesellpingcang=false;
               linesellpingcangctrlR=false;
               linelock=false;
               fkeyHolding=false;
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
            else
              {
               PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               linesellpingcang=false;
               linesellpingcangctrlR=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//
              {
               yijianpingbuydan();
               linesellpingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linesellpingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  if(fkeyHoldingfanshou)//
                    {
                     if(CGetbuyLots()!=0.0  && CGetsellLots()==0.0)
                       {
                        sellline=sellline+fkeyHoldingfanshoupianyi1*Point;
                        SetLevel("Sell Line",sellline,ForestGreen);
                        selllineOnTimer=Bid;
                        linesellkaicang=true;
                        linekaicangctrl=true;
                        huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetbuyLots()/keylots));
                        fkeyHoldingfanshou=false;
                        fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                        xunhuanquanpingcang();
                        linesellpingcang=false;
                        Print("平仓后距现价多少点移动横线挂反手单 开启 sell横线之下 开仓个数 ",huaxiankaicanggeshu1," ",sellline);
                        comment("平仓后距现价多少点移动横线挂反手单 开启 sell");
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                       }
                     else
                       {
                        if(CGetbuyLots()==0.0  && CGetsellLots()!=0.0)
                          {
                           buyline=sellline-fkeyHoldingfanshoupianyi1*Point;
                           SetLevel("Buy Line",buyline,Red);
                           linebuykaicang=true;
                           linekaicangctrl=true;
                           huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetsellLots()/keylots));
                           fkeyHoldingfanshou=false;
                           fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                           xunhuanquanpingcang();
                           linesellpingcang=false;
                           Print("平仓后距现价多少点移动横线挂反手单 开启 buy横线之下 开仓个数 ",huaxiankaicanggeshu1," ",buyline);
                           comment("平仓后距现价多少点移动横线挂反手单 开启 buy");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           Print("订单方向不一致 平仓后移动横线挂反手单 无法开启 ");
                           comment("订单方向不一致 平仓后移动横线挂反手单 无法开启");
                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           linelock=false;
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                       }
                    }
                  else
                    {
                     if(menu[24])
                       {
                        yiyang5mpingcangshiti=true;
                       }
                     else
                       {
                        xunhuanquanpingcang();//
                        linesellpingcang=false;
                        linelock=false;
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                    }
                 }

              }
           }
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         if(linesellpingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            if(fkeyHolding)
              {
               //PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               //PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               sellline=sellline+linebuypingcangctrlRpianyi*Point;
               SetLevel("Sell Line",sellline,ForestGreen);
               yijianFanshou=true;
               linesellpingcang=false;
               linesellpingcangctrlR=false;
               linelock=false;
               fkeyHolding=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
              }
            else
              {
               PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
               linesellpingcang=false;
               linesellpingcangctrlR=false;
               linelock=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
              }
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//
              {
               yijianpingbuydan();
               linesellpingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linesellpingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  if(fkeyHoldingfanshou)//
                    {
                     if(CGetbuyLots()!=0.0  && CGetsellLots()==0.0)
                       {
                        sellline=sellline+fkeyHoldingfanshoupianyi1*Point;
                        SetLevel("Sell Line",sellline,ForestGreen);
                        selllineOnTimer=Bid;
                        linesellkaicang=true;
                        linekaicangctrl=true;
                        huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetbuyLots()/keylots));
                        fkeyHoldingfanshou=false;
                        fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                        xunhuanquanpingcang();
                        linesellpingcang=false;
                        Print("平仓后距现价多少点移动横线挂反手单 开启 sell横线之下 开仓个数",huaxiankaicanggeshu1," ",sellline);
                        comment("平仓后距现价多少点移动横线挂反手单 开启 sell");
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                       }
                     else
                       {
                        if(CGetbuyLots()==0.0  && CGetsellLots()!=0.0)
                          {
                           buyline=sellline-fkeyHoldingfanshoupianyi1*Point;
                           SetLevel("Buy Line",buyline,Red);
                           linebuykaicang=true;
                           linekaicangctrl=true;
                           huaxiankaicanggeshu1=StrToInteger(DoubleToStr(CGetsellLots()/keylots));
                           fkeyHoldingfanshou=false;
                           fkeyHoldingfanshoupianyi1=fkeyHoldingfanshoupianyi;

                           xunhuanquanpingcang();
                           linesellpingcang=false;
                           Print("平仓后距现价多少点移动横线挂反手单 开启 buy横线之下 开仓个数",huaxiankaicanggeshu1," ",buyline);
                           comment("平仓后距现价多少点移动横线挂反手单 开启 buy");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                        else
                          {
                           Print("订单方向不一致 平仓后移动横线挂反手单 无法开启 ");
                           comment("订单方向不一致 平仓后移动横线挂反手单 无法开启");
                           xunhuanquanpingcang();
                           linebuypingcang=false;
                           linelock=false;
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                          }
                       }
                    }
                  else
                    {
                     if(menu[24])
                       {
                        //yiyang5mpingcangshiti=true;
                       }
                     else
                       {
                        xunhuanquanpingcang();
                        linesellpingcang=false;
                        linelock=false;
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                    }
                 }

              }
           }
        }
     }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(linebuyzidongjiacang)//五分钟自动追Buy单
     {
      int T=TimeMinute(TimeCurrent());
      if(linefirsttime)//第一次开启时执行
        {
         if(Open[1]-Close[1]<0)
           {
            double p1=Close[1]-20*Point;
            double p2=Bid-20*Point;
            if(p2<p1)
              {
               buyline=p2;
               if(ObjectFind("Buy Line")==0)
                  ObjectMove(0,"Buy Line",0,Time[1],buyline);
              }
            else
              {
               buyline=p1;
               if(ObjectFind("Buy Line")==0)
                  ObjectMove(0,"Buy Line",0,Time[1],buyline);
              }
            linefirsttime=false;
           }
        }



      if(T==1 || T==5 || T==10 || T==15 || T==20 || T==25 || T==30 || T==35 || T==40 || T==45 || T==50 || T==55)//定时执行
        {
         if(linetime<T)
            lineTime=false;
         if(linetime==55 && T==1)
            lineTime=false;
         if(Open[1]-Close[1]<0 && lineTime==false)
           {
            buyline=Close[1]-linebuyzidongjiacangpianyi*Point;
            if(ObjectFind("Buy Line")==0)
              {
               bool T1=ObjectMove(0,"Buy Line",0,Time[1],buyline);
               if(T1)
                 {
                  lineTime=true;
                  linetime=T;
                 }
              }
           }
        }



      if(huaxianzidongjiacanggeshu1==0)
        {
         huaxianzidongjiacanggeshutime1--;
         if(huaxianzidongjiacanggeshutime1>0)
           {
            if(ObjectFind("Buy Line")==0)
               ObjectMove(0,"Buy Line",0,Time[1],buyline-linezidongjiacangyidong*Point);
            buyline=buyline-linezidongjiacangyidong*Point;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
           }
         else
           {
            linebuyzidongjiacang=false;
            linelock=false;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
            huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
            lineTime=false;
            linetime=0;
            linefirsttime=true;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
        }



      else
        {
         if(buyline>=Bid)
           {
            RefreshRates();
            Sleep(huaxiankaicangtime);
            buysellnowSL(true,huaxianzidongjiacanglots,5,7,0,50);
            huaxianzidongjiacanggeshu1--;
           }
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(linesellzidongjiacang)//五分钟自动追Sell单
     {
      int T=TimeMinute(TimeCurrent());
      if(linefirsttime)//第一次开启时执行
        {
         if(Open[1]-Close[1]>0)
           {
            double p1=Close[1]+20*Point;
            double p2=Bid+20*Point;
            if(p2>p1)
              {
               sellline=p2;
               if(ObjectFind("Sell Line")==0)
                  ObjectMove(0,"Sell Line",0,Time[1],sellline);
              }
            else
              {
               sellline=p1;
               if(ObjectFind("Sell Line")==0)
                  ObjectMove(0,"Sell Line",0,Time[1],sellline);
              }
            linefirsttime=false;
           }
        }
      if(T==1 || T==5 || T==10 || T==15 || T==20 || T==25 || T==30 || T==35 || T==40 || T==45 || T==50 || T==55)//定时执行
        {
         if(linetime<T)
            lineTime=false;
         if(linetime==55 && T==1)
            lineTime=false;
         if(Open[1]-Close[1]>0 && lineTime==false)
           {
            sellline=Close[1]+linesellzidongjiacangpianyi*Point;
            if(ObjectFind("Sell Line")==0)
              {
               bool T1=ObjectMove(0,"Sell Line",0,Time[1],sellline);
               if(T1)
                 {
                  lineTime=true;
                  linetime=T;
                 }
              }
           }
        }
      if(huaxianzidongjiacanggeshu1==0)
        {
         huaxianzidongjiacanggeshutime1--;
         if(huaxianzidongjiacanggeshutime1>0)
           {
            if(ObjectFind("Sell Line")==0)
               ObjectMove(0,"Sell Line",0,Time[1],sellline+linezidongjiacangyidong*Point);
            sellline=sellline+linezidongjiacangyidong*Point;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
           }
         else
           {
            linesellzidongjiacang=false;
            linelock=false;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
            huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
            lineTime=false;
            linetime=0;
            linefirsttime=true;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
        }
      else
        {
         if(sellline<=Bid)
           {
            RefreshRates();
            Sleep(huaxiankaicangtime);
            buysellnowSL(false,huaxianzidongjiacanglots,5,7,0,50);
            huaxianzidongjiacanggeshu1--;
           }
        }
     }
//////////////////////////////五分钟自动追单结束
   if(tickclose)//Tick数值变化剧烈 自动开始平仓
     {
      int jishu=tickjishu;
      double abs=0;
      switch(tickjishu)
        {
         case 4:
           {
            tick4=Bid;
            tickjishu--;
           }
         break;
         case 3:
           {
            tick3=Bid;
            tickjishu--;
           }
         break;
         case 2:
           {
            tick2=Bid;
            tickjishu--;
           }
         break;
         case 1:
           {
            tick1=Bid;
            tickjishu--;
           }
         break;
         case 0:
           {
            tick0=Bid;
            tickjishu=4;
           }
         break;
        }
      switch(jishu)
        {
         case 4:
           {
            abs=(NormalizeDouble(tick4-tick3,Digits)/Point);
           }
         break;
         case 3:
           {
            abs=(NormalizeDouble(tick3-tick2,Digits)/Point);
           }
         break;
         case 2:
           {
            abs=(NormalizeDouble(tick2-tick1,Digits)/Point);
           }
         break;
         case 1:
           {
            abs=(NormalizeDouble(tick1-tick0,Digits)/Point);
           }
         break;
         case 0:
           {
            abs=(NormalizeDouble(tick0-tick4,Digits)/Point);
           }
         break;
        }
      if(tickbuyclose)
        {
         if(tickShift)
            Print("Tick变化值= ",abs," 预设值",glotickclosenum,"  tickjishu=",jishu," tick4=",tick4," tick3=",tick3," tick2=",tick2," tick1=",tick1," tick0=",tick0);
         if(abs>glotickclosenum && MathAbs(abs)<500)
           {
            xunhuanquanpingcang();
            tickclose=false;
            Print("Tick数值变化剧烈 数值大于预设值",glotickclosenum,"自动开始平仓");
            comment1("Tick数值变化剧烈大于预设值自动开始平仓");
           }
        }
      else
        {
         if(tickShift)
            Print("Tick变化值= ",abs," 预设值",-glotickclosenum,"  tickjishu=",jishu," tick4=",tick4," tick3=",tick3," tick2=",tick2," tick1=",tick1," tick0=",tick0);
         if(abs<-glotickclosenum && MathAbs(abs)<500)
           {
            xunhuanquanpingcang();
            tickclose=false;
            Print("Tick数值变化剧烈 数值大于预设值",-glotickclosenum,"自动开始平仓");
            comment1("Tick数值变化剧烈大于预设值自动开始平仓");
           }
        }
     }
///////////////////////////////////////////////////////////////////
   if(Tickmode  && fansuoYes==false)//分步平仓
     {
      closecode();
     }
  }
///////////////////////////////////////////////////////////////////

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()//Ttt 定时器
  {


//Print(NormalizeDouble(iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,0),Digits));
//Print(zhendangzhibiao[0]," ",zhendangzhibiao[1]," ",zhendangzhibiao[2]);
//Print(iCustom(NULL,0,"Custom/震荡突破",2,0));
//Print(iCustom(NULL,0,"Custom/震荡突破",1,0));
//Print(TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL));
//OnChartEvent2(CHARTEVENT_KEYDOWN, lparam, dparam, sparam);
/////////////////////////////////////
//int  m = TimeSeconds(TimeCurrent());
//   Print("MODE_MINLOT ",MarketInfo(Symbol(),MODE_MINLOT));
//  Print("MODE_LOTSTEP ",MarketInfo(Symbol(),MODE_LOTSTEP));
//Print(MarketInfo(Symbol(),MODE_LOTSIZE));
//Print(GetHoldingguadanOrdersCount());
//
//Print(AccountProfit());
// Print(SL5QTPtimeCurrent+10);
//double mb=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",7,0.0,0,0),4);
//double bs=NormalizeDouble(iCustom(NULL,0,"Custom/bstrend-indicator",12,0,0),5);
//Print(mb);
//Print(bs);
// Print(TimeGMT());
//Print(iLow(NULL,PERIOD_M5,1));
// Print(iLow(NULL,PERIOD_M15,1));
//   Print(iLowest(NULL,PERIOD_M1,MODE_LOW,7,0));
//  Print("1=",SL1mbuyLineprice," ","5=",SL5mbuyLineprice," ","15=",SL15mbuyLineprice);
/////////////////////////////////////////////////////////////////
//Print(ObjectGetString(0,"onamev",OBJPROP_TEXT,0));

//Print("value1 ",NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",0,iii),4)," value2 ",NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",1,iii),4)," value3 ",NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",2,iii),4));//
//Print("value4 ",NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",0,0),4));//指标第一个参数 0 1 2 分别对应三个值


/////////////////////////////////////////////////////////////////
   if(menu3[18])
     {
      if(AccountProfit()>AccountBalance()*0.5)
        {
         Print("本金盈利50%全平仓 开始 当前利润=",AccountProfit());
         comment4("本金盈利50% 全平仓 关闭 ");
         xunhuanquanpingcangplus();
         menu3[18]=false;
        }
     }
///////////////////////////////////////////////////
   if(iBreakoutkaicangbuy || iBreakoutkaicangsell)
     {
      if(ObjectFind("BreakOut Box: BreakOutDown")==0)//根据BreakOut指标 获取横线的位置
        {
         BreakOutDown80=ObjectGet("BreakOut Box: BreakOutDown",OBJPROP_PRICE1);//80%下降
         // Print("BreakOutDown80"," ",BreakOutDown80);
        }
      if(ObjectFind("BreakOut Box: BreakoutUp")==0)
        {
         BreakOutUp80=ObjectGet("BreakOut Box: BreakoutUp",OBJPROP_PRICE2);//80%上升
         // Print("BreakOutUp80"," ",BreakOutUp80);
        }
      if(ObjectFind("BreakOut Box: BreakOutDown")==0)
        {
         BreakOutDown100=ObjectGet("BreakOut Box: StrongBreakOutDown",OBJPROP_PRICE1);//下降突破
         //  Print("BreakOutDown100"," ",BreakOutDown100);
        }
      if(ObjectFind("BreakOut Box: BreakoutUp")==0)
        {
         BreakOutUp100=ObjectGet("BreakOut Box: StrongBreakOutUp",OBJPROP_PRICE2);//上升突破
         // Print("BreakOutUp100"," ",BreakOutUp100);
        }
      if(ObjectFind("BreakOut Box: Avg-High")==0)
        {
         BreakOutUp0=ObjectGet("BreakOut Box: Avg-High",OBJPROP_PRICE1);//上升0%
         // Print("BreakOutUp0"," ",BreakOutUp0);
        }
      if(ObjectFind("BreakOut Box: Avg-Low")==0)
        {
         BreakOutDown0=ObjectGet("BreakOut Box: Avg-Low",OBJPROP_PRICE1);//下降0%
         // Print("BreakOutDown0"," ",BreakOutDown0);
        }
     }
////////////////////////////////////////////////////////////////
   if(iBreakoutkaicangbuy)//当前图表参考Breakout指标矩形横线位置启动横线模式开Buy仓
     {
      if(iBreakoutkaicangbuy1)
        {
         if(ObjectFind(0,"SL Line")<0)
           {
            iBreakoutkaicangbuy=false;
            iBreakoutkaicangbuy1=false;
            BreakOutUp80=0.0;
            BreakOutUp100=0.0;
            BreakOutDown80=0.0;
            BreakOutDown100=0.0;
            Print("横线模式开仓 成功? 未找到SL Line 当前功能关闭");
            comment1("横线模式开仓 成功? 未找到SL Line 当前功能关闭");
           }
         else
           {
            ObjectMove(0,"Buy Line",0,Time[0],BreakOutDown80);
            ObjectMove(0,"SL Line",0,Time[0],BreakOutDown100-iBreakoutkaicangbuySLpianyi*Point);
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
        }
      if(BreakOutDown80!=0.0 && BreakOutDown80<Bid && iBreakoutkaicangbuy1==false)//
        {
         SetLevel("Buy Line",BreakOutDown80,Red);
         buylineOnTimer=Bid;
         SetLevel("SL Line",BreakOutDown100-iBreakoutkaicangbuySLpianyi*Point,FireBrick);
         slline=BreakOutDown100-iBreakoutkaicangbuySLpianyi*Point;
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         if(ObjectFind(0,"SL Line")==0)
           {
            linebuykaicang=true;
            linekaicangT=true;
            huaxiankaicanggeshuT1=iBreakoutkaicangbuygeshu+(rightpress-leftpress);
            huaxiankaicangtimeTP=iBreakoutkaicangbuytime+(shangpress-xiapress)*1000;
            if(huaxiankaicangtimeTP<0)
               huaxiankaicangtimeTP=0;
            linelock=true;
            Print("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
            comment(StringFormat("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓%G次",huaxiankaicanggeshuT1));

            iBreakoutkaicangbuy1=true;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 成功");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 成功");
           }
        }
     }
////////////////////////////////////////////////////////////////////////
   if(iBreakoutkaicangsell)//当前图表参考Breakout指标矩形横线位置启动横线模式开sell仓
     {
      if(iBreakoutkaicangsell1)
        {
         if(ObjectFind(0,"SL Line")<0)
           {
            iBreakoutkaicangsell=false;
            iBreakoutkaicangsell1=false;
            BreakOutUp80=0.0;
            BreakOutUp100=0.0;
            BreakOutDown80=0.0;
            BreakOutDown100=0.0;
            Print("横线模式开仓 成功? 未找到SL Line 当前功能关闭");
            comment1("横线模式开仓 成功? 未找到SL Line 当前功能关闭");
           }
         else
           {
            ObjectMove(0,"Sell Line",0,Time[0],BreakOutUp80);
            ObjectMove(0,"SL Line",0,Time[0],BreakOutUp100+iBreakoutkaicangbuySLpianyi*Point);
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
           }
        }
      //Print("BreakOutUp80=",BreakOutUp80," Bid=",Bid," iBreakoutkaicangsell1=",iBreakoutkaicangsell1);
      if(BreakOutUp80!=0.0 && BreakOutUp80>Bid && iBreakoutkaicangsell1==false)//
        {
         SetLevel("Sell Line",BreakOutUp80,ForestGreen);
         selllineOnTimer=Bid;
         SetLevel("SL Line",BreakOutUp100+iBreakoutkaicangbuySLpianyi*Point,FireBrick);
         slline=BreakOutUp100+iBreakoutkaicangbuySLpianyi*Point;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"SL Line")==0)
           {
            linesellkaicang=true;
            linekaicangT=true;
            huaxiankaicanggeshuT1=iBreakoutkaicangbuygeshu+(rightpress-leftpress);
            huaxiankaicangtimeTP=iBreakoutkaicangbuytime+(shangpress-xiapress)*1000;
            if(huaxiankaicangtimeTP<0)
               huaxiankaicangtimeTP=0;
            linelock=true;
            Print("触及横线开Sell单止损线止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
            comment(StringFormat("触及横线开Sell单止损线止损 开启 参考时间和价位 开仓%G次",huaxiankaicanggeshuT1));

            iBreakoutkaicangsell1=true;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 成功");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 成功");
           }
        }
     }
//////////////////////////////////////////////////////////////////////////////////////////////

   if(yinyang5mkaiguan1)//追踪5分钟图表最近收盘的几根K线是阴是阳 默认开启 只在5分钟收盘时运行一次  5min OnTimer 基本弃用 请搜索 5min3
     {

      /////////////////////////////////////////// 5分钟收盘后执行一次 挂靠执行


      ////////////////////////////////////////////
      yinyang5mkaiguan1=false;
     }
   if(yinyang15mkaiguan1)//追踪15分钟图表最近收盘的几根K线是阴是阳 默认开启 只在15分钟收盘时运行一次  15min OnTimer 基本弃用 请搜索
     {
      ////////////////////////////////////////15分钟收盘后执行一次 挂靠执行

      ///////////////////////////////////////
      yinyang15mkaiguan1=false;
     }
   if(yinyang5mkaiguan)//追踪5分钟图表最近收盘的K线是阴是阳 默认开启
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            yinyang5mkaiguan1=true;
           }
        }
     }
   if(yinyang15mkaiguan)//追踪15分钟图表最近收盘的K线是阴是阳 默认开启
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            yinyang15mkaiguan1=true;
           }
        }
     }
///////////////////////////////////////////////////////////////////////////////////////////////////
   if(breakoutNot)//breakout指标突破提醒
     {
      if(breakoutNot1==false)
        {
         if(breakoutNottimeCurrent+breakoutNottime<=TimeCurrent())
           {
            breakoutNot1=true;
           }
        }
     }
////////////////////////////////////////////////////////////////////////////////////////
   if(hengxianAi1)//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
     {
      double a1=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_LOWER,0),Digits);//布林带下轨
      double a2=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_UPPER,0),Digits);//布林带上轨
      double a3=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_MAIN,0),Digits);//布林带中轨
      //Print(a2,"  ",a3,"  ",a1);
      if(ObjectFind("Buy Line")==0)
        {
         if(buyline<Bid)
           {
            ObjectMove(0,"Buy Line",0,Time[linebar],a1+hengxianAi1bullpianyi);
            buyline=a1+hengxianAi1bullpianyi;
           }
         else
           {
            ObjectMove(0,"Buy Line",0,Time[linebar],a2+hengxianAi1bullpianyi);
            buyline=a2+hengxianAi1bullpianyi;
           }

        }
      if(ObjectFind("Sell Line")==0)
        {
         if(sellline>Bid)
           {
            ObjectMove(0,"Sell Line",0,Time[linebar],a2+hengxianAi1bullpianyi);
            sellline=a2+hengxianAi1bullpianyi;
           }
         else
           {
            ObjectMove(0,"Sell Line",0,Time[linebar],a1+hengxianAi1bullpianyi);
            sellline=a1+hengxianAi1bullpianyi;
           }

        }
     }
   if(hengxianAi1a)//
     {
      double a1=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_LOWER,0),Digits);//布林带下轨
      double a2=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_UPPER,0),Digits);//布林带上轨
      double a3=NormalizeDouble(iBands(NULL,0,bandsA,bandsC,bandsB,PRICE_CLOSE,MODE_MAIN,0),Digits);//布林带中轨
      //Print(a2,"  ",a3,"  ",a1);
      if(ObjectFind("Buy Line")==0)
        {
         if(a3<Bid)
           {
            if(buyline<Bid)
              {
               ObjectMove(0,"Buy Line",0,Time[linebar],a3+hengxianAi1bullpianyi);
               buyline=a3+hengxianAi1bullpianyi;
               //Print(buyline,"  ",hengxianAi1bullpianyi);
              }
           }
         else
           {
            if(buyline>Bid)
              {
               ObjectMove(0,"Buy Line",0,Time[linebar],a3+hengxianAi1bullpianyi);
               buyline=a3+hengxianAi1bullpianyi;
              }
           }

        }
      if(ObjectFind("Sell Line")==0)
        {
         if(a3<Bid)

           {
            if(sellline<Bid)
              {
               ObjectMove(0,"Sell Line",0,Time[linebar],a3+hengxianAi1bullpianyi);
               sellline=a3+hengxianAi1bullpianyi;
              }
           }
         else
           {
            if(sellline>Bid)
              {
               ObjectMove(0,"Sell Line",0,Time[linebar],a3+hengxianAi1bullpianyi);
               sellline=a3+hengxianAi1bullpianyi;
              }
           }

        }
     }
///////////////////////////////////////////增加触及订单止盈止损线时 订单被平的提示音 2022.1.2
//Print(buyselldingdangeshunew," ",buyselldingdangeshuold);
   buyselldingdangeshunew=GetHoldingbuyOrdersCount()+GetHoldingsellOrdersCount();
   if(buyselldingdangeshunew==0 && buyselldingdangeshuold==0)
     {

     }
   else
     {
      buyselldingdangeshunew=GetHoldingbuyOrdersCount()+GetHoldingsellOrdersCount();

      if(buyselldingdangeshunew<buyselldingdangeshuold)//
        {
         for(int i=OrdersHistoryTotal()-1; i>=0; i--)//
           {
            if(OrderSelect(i,SELECT_BY_POS, MODE_HISTORY) &&  OrderSymbol()==Symbol())
              {
               if(OrderCloseTime()+30>TimeCurrent())
                 {
                  if(OrderComment()=="[tp]" || OrderComment()=="[sl]" || StringSubstr(OrderComment(),0,2)=="so")
                    {
                     Print("触及止盈或止损一单 订单号"+(string)OrderTicket());
                     PlaySound("ok.wav");
                     buyselldingdangeshuold=GetHoldingbuyOrdersCount()+GetHoldingsellOrdersCount();
                     return;
                    }
                 }
               else
                 {
                  buyselldingdangeshuold=GetHoldingbuyOrdersCount()+GetHoldingsellOrdersCount();
                  return;
                 }
              }
           }
        }
      buyselldingdangeshuold=GetHoldingbuyOrdersCount()+GetHoldingsellOrdersCount();
     }
// Print(buyselldingdangeshunew," ",buyselldingdangeshuold);
///////////////////////////////////////////////////////////////////////////////
   if(dingshikaicang)//当前五分钟K线收线时开仓 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时开仓触发时间 ",TimeCurrent());
            if(onlybuydan)
              {
               for(int i=dingshikaicanggeshu; i>0; i--)//
                 {
                  Sleep(dingshikaicangSleep);
                  int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                    {
                     PlaySound("ok.wav");
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
              }
            if(onlyselldan)
              {
               for(int i=dingshikaicanggeshu; i>0; i--)//
                 {
                  Sleep(dingshikaicangSleep);
                  int  keybuy10=OrderSend(Symbol(),OP_SELL,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                    {
                     PlaySound("ok.wav");
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
              }
            if(onlybuydan==false  && onlyselldan==false)
              {
               Print("空仓或多空都有 五分钟K线收线时开仓 无法开仓");
               comment1("空仓或多空都有 五分钟K线收线时开仓 无法开仓");
              }
            dingshikaicang=false;
            Print("五分钟K线收线时开仓 完成");
            comment1("五分钟K线收线时开仓 完成");
           }
        }
     }
///////////////////////////////////////////////////////////////////////////////////////
   if(dingshikaicang15)//当前十五分钟K线收线时开仓 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时开仓触发时间 ",TimeCurrent());
            if(onlybuydan)
              {
               for(int i=dingshikaicanggeshu; i>0; i--)//
                 {
                  Sleep(dingshikaicangSleep);
                  int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                    {
                     PlaySound("ok.wav");
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
              }
            if(onlyselldan)
              {
               for(int i=dingshikaicanggeshu; i>0; i--)//
                 {
                  Sleep(dingshikaicangSleep);
                  int  keybuy10=OrderSend(Symbol(),OP_SELL,keylots,OrderOpenPrice(),keyslippage,0,0,NULL,0,0);
                  if(keybuy10>0)
                    {
                     PlaySound("ok.wav");
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     i++;
                     Print("GetLastError=",error());
                    }
                 }
              }
            if(onlybuydan==false  && onlyselldan==false)
              {
               Print("空仓或多空都有 十五分钟K线收线时开仓 无法开仓");
               comment1("空仓或多空都有 十五分钟K线收线时开仓 无法开仓");
              }
            dingshikaicang15=false;
            Print("十五分钟K线收线时开仓 完成");
            comment1("十五分钟K线收线时开仓 完成");
           }
        }
     }
///////////////////////////////////////////////////////////////////////////////////////
   if(GetHoldingdingdanguadanOrdersCount()==0 || Lots()==0.0)//没订单时 OnTick 模块不运行
     {
      OnTickswitch=false;
     }
   else
     {
      OnTickswitch=true;
     }
///////////////////////////////////////////////////////////////////////////////////////////
   if(dingshipingcang)//当前五分钟K线收线时平仓 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang=false;
            Print("五分钟K线收线时平仓 完成");
            comment("五分钟K线收线时平仓 完成");
           }
        }
     }
   if(dingshipingcang15)//当前十五分钟K线收线时平仓 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang15=false;
            Print("十五分钟K线收线时平仓 完成");
            comment("十五分钟K线收线时平仓 完成");
           }
        }
     }
   if(dingshipingcangF)//当前五分钟K线收线时平仓反手 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓后反手触发时间 ",TimeCurrent());
            yijianfanshou();
            dingshipingcangF=false;
            Print("五分钟K线收线时平仓后反手 完成");
            comment("五分钟K线收线时平仓后反手 完成");
           }
        }
     }
   if(dingshipingcang15F)//当前十五分钟K线收线时平仓后反手 定时器里判断时间
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓后反手触发时间 ",TimeCurrent());
            yijianfanshou();
            dingshipingcang15F=false;
            Print("十五分钟K线收线时平仓后反手 完成");
            comment("十五分钟K线收线时平仓后反手 完成");
           }
        }
     }
//////////////////////////////////////////////////////////////////////////////////////////
   if(CGetbuyLots()>=GlobalVariableGet("glomaxTotallots"))//限制EA最大下单量
     {
      buymaxTotallots=true;
     }
   else
     {
      buymaxTotallots=false;
     }
   if(CGetsellLots()>=GlobalVariableGet("glomaxTotallots"))
     {
      sellmaxTotallots=true;
     }
   else
     {
      sellmaxTotallots=false;
     }
/////////////////////////////////////////////////////////////////////////////////
   if(ObjectFind(0,"Buy Line")==0)
     {
      buyline=NormalizeDouble(ObjectGet("Buy Line",1),Digits);   //定时更新横线的价格
     }
   if(ObjectFind(0,"Sell Line")==0)
     {
      sellline=NormalizeDouble(ObjectGet("Sell Line",1),Digits);   //定时更新横线的价格
     }
   if(ObjectFind(0,"SL Line")==0)
     {
      slline=NormalizeDouble(ObjectGet("SL Line",1),Digits);   //定时更新横线的价格
     }
   if(ObjectFind(0,"SL1mbuyLine")==0)
     {
      SL1mbuyLineprice=NormalizeDouble(ObjectGet("SL1mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL5mbuyLine")==0)
     {
      SL5mbuyLineprice=NormalizeDouble(ObjectGet("SL5mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL15mbuyLine")==0)
     {
      SL15mbuyLineprice=NormalizeDouble(ObjectGet("SL15mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL1msellLine")==0)
     {
      SL1msellLineprice=NormalizeDouble(ObjectGet("SL1msellLine",1),Digits);
     }
   if(ObjectFind(0,"SL5msellLine")==0)
     {
      SL5msellLineprice=NormalizeDouble(ObjectGet("SL5msellLine",1),Digits);
     }
   if(ObjectFind(0,"SL15msellLine")==0)
     {
      SL15msellLineprice=NormalizeDouble(ObjectGet("SL15msellLine",1),Digits);
     }
   if(kaiguan01)//
     {
      RefreshRates();
      drawTrend("l1","fang1",208,104,0,PaleGoldenrod);
      drawTrend("l2","fang2",104,52,0,PaleGoldenrod);
      drawTrend("l3","fang3",52,26,0,PaleGoldenrod);
      drawTrend("l4","fang4",208,104,1,CadetBlue);
      drawTrend("l5","fang5",104,52,1,CadetBlue);
      drawTrend("l6","fang6",52,26,1,CadetBlue);
      // ObjectCreate(0,"dxzdSLLine1",OBJ_RECTANGLE,0,Time[1],Close[1],Time[0],Close[1]);
     }
   if(menu6[0])//短线追Buy单
     {

      if(yinyang5m1k && yinyang5m2k)
        {
         if(ObjectFind(0,"dxzdBuyLineC")>=0)
           {
            double a=ObjectGet("dxzdBuyLineC",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdBuyLineC");
            ObjectCreate(0,"dxzdBuyLineC",OBJ_RECTANGLE,0,Time[1],Close[1]+dxzdBuyLineCpianyiliang*Point,Time[0]+2500,Close[1]+dxzdBuyLineCpianyiliang*Point);
            ObjectSet("dxzdBuyLineC",OBJPROP_BACK,false);
            ObjectSet("dxzdBuyLineC",OBJPROP_WIDTH,1);
            ObjectSet("dxzdBuyLineC",OBJPROP_COLOR,a);
           }
         if(ObjectFind(0,"dxzdBuyLineO")>=0)
           {
            double a1=ObjectGet("dxzdBuyLineO",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdBuyLineO");
            ObjectCreate(0,"dxzdBuyLineO",OBJ_RECTANGLE,0,Time[1],Open[1]+dxzdBuyLineOpianyiliang*Point,Time[0]+2500,Open[1]+dxzdBuyLineOpianyiliang*Point);
            ObjectSet("dxzdBuyLineO",OBJPROP_BACK,false);
            ObjectSet("dxzdBuyLineO",OBJPROP_WIDTH,1);
            ObjectSet("dxzdBuyLineO",OBJPROP_COLOR,a1);
           }
         if(ObjectFind(0,"dxzdBuyLineL")>=0)
           {
            double a2=ObjectGet("dxzdBuyLineL",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdBuyLineL");
            ObjectCreate(0,"dxzdBuyLineL",OBJ_RECTANGLE,0,Time[1],Low[1]+dxzdBuyLineLpianyiliang*Point,Time[0]+2500,Low[1]+dxzdBuyLineLpianyiliang*Point);
            ObjectSet("dxzdBuyLineL",OBJPROP_BACK,false);
            ObjectSet("dxzdBuyLineL",OBJPROP_WIDTH,1);
            ObjectSet("dxzdBuyLineL",OBJPROP_COLOR,a2);
           }
        }

      if(ObjectFind(0,"dxzdBuyi5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi2kSL",OBJ_RECTANGLE,0,Time[1],GetiLowest(0,2,0),Time[0]+5000,GetiLowest(0,2,0));
         ObjectSet("dxzdBuyi2kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi2kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi2kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi3kSL",OBJ_RECTANGLE,0,Time[2],GetiLowest(0,3,0),Time[0]+5000,GetiLowest(0,3,0));
         ObjectSet("dxzdBuyi3kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi3kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi3kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi4kSL",OBJ_RECTANGLE,0,Time[3],GetiLowest(0,4,0),Time[0]+5000,GetiLowest(0,4,0));
         ObjectSet("dxzdBuyi4kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi4kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi4kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi5kSL",OBJ_RECTANGLE,0,Time[4],GetiLowest(0,5,0),Time[0]+5000,GetiLowest(0,5,0));
         ObjectSet("dxzdBuyi5kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi5kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi5kSL",OBJPROP_COLOR,Red);
        }

      if(ObjectFind(0,"dxzdBuyi5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi2kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,2,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,2,0)-dxzdSLpianyiliang*Point-diancha);
         ObjectSet("dxzdBuyi2kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi2kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi2kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi3kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,3,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,3,0)-dxzdSLpianyiliang*Point-diancha);
         ObjectSet("dxzdBuyi3kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi3kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi3kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi4kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,4,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,4,0)-dxzdSLpianyiliang*Point-diancha);
         ObjectSet("dxzdBuyi4kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi4kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi4kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdBuyi5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdBuyi5kSL1",OBJ_RECTANGLE,0,Time[0],GetiLowest(0,5,0)-dxzdSLpianyiliang*Point-diancha,Time[0]+500,GetiLowest(0,5,0)-dxzdSLpianyiliang*Point-diancha);
         ObjectSet("dxzdBuyi5kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdBuyi5kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdBuyi5kSL1",OBJPROP_COLOR,Red);
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(menu6[1])//短线追Sell单
     {
      if(yinyang5m1k==false && yinyang5m2k==false)
        {
         if(ObjectFind(0,"dxzdSellLineC")>=0)
           {
            double b=ObjectGet("dxzdSellLineC",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdSellLineC");
            ObjectCreate(0,"dxzdSellLineC",OBJ_RECTANGLE,0,Time[1],Close[1]+dxzdSellLineCpianyiliang*Point,Time[0]+2500,Close[1]+dxzdSellLineCpianyiliang*Point);
            ObjectSet("dxzdSellLineC",OBJPROP_BACK,false);
            ObjectSet("dxzdSellLineC",OBJPROP_WIDTH,1);
            ObjectSet("dxzdSellLineC",OBJPROP_COLOR,b);
           }

         if(ObjectFind(0,"dxzdSellLineO")>=0)
           {
            double b1=ObjectGet("dxzdSellLineO",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdSellLineO");
            ObjectCreate(0,"dxzdSellLineO",OBJ_RECTANGLE,0,Time[1],Open[1]+dxzdSellLineOpianyiliang*Point,Time[0]+2500,Open[1]+dxzdSellLineOpianyiliang*Point);
            ObjectSet("dxzdSellLineO",OBJPROP_BACK,false);
            ObjectSet("dxzdSellLineO",OBJPROP_WIDTH,1);
            ObjectSet("dxzdSellLineO",OBJPROP_COLOR,b1);
           }
         if(ObjectFind(0,"dxzdSellLineH")>=0)
           {
            double b2=ObjectGet("dxzdSellLineH",OBJPROP_COLOR);
            ObjectDelete(0,"dxzdSellLineH");
            ObjectCreate(0,"dxzdSellLineH",OBJ_RECTANGLE,0,Time[1],High[1]+dxzdSellLineHpianyiliang*Point,Time[0]+2500,High[1]+dxzdSellLineHpianyiliang*Point);
            ObjectSet("dxzdSellLineH",OBJPROP_BACK,false);
            ObjectSet("dxzdSellLineH",OBJPROP_WIDTH,1);
            ObjectSet("dxzdSellLineH",OBJPROP_COLOR,b2);
           }
        }
      if(ObjectFind(0,"dxzdSelli5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli2kSL",OBJ_RECTANGLE,0,Time[1],GetiHighest(0,2,0),Time[0]+5000,GetiHighest(0,2,0));
         ObjectSet("dxzdSelli2kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli2kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli2kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli3kSL",OBJ_RECTANGLE,0,Time[2],GetiHighest(0,3,0),Time[0]+5000,GetiHighest(0,3,0));
         ObjectSet("dxzdSelli3kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli3kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli3kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli4kSL",OBJ_RECTANGLE,0,Time[3],GetiHighest(0,4,0),Time[0]+5000,GetiHighest(0,4,0));
         ObjectSet("dxzdSelli4kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli4kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli4kSL",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli5kSL",OBJ_RECTANGLE,0,Time[4],GetiHighest(0,5,0),Time[0]+5000,GetiHighest(0,5,0));
         ObjectSet("dxzdSelli5kSL",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli5kSL",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli5kSL",OBJPROP_COLOR,Red);
        }

      if(ObjectFind(0,"dxzdSelli5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli2kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,2,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,2,0)+dxzdSLpianyiliang*Point+diancha);
         ObjectSet("dxzdSelli2kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli2kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli2kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli3kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,3,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,3,0)+dxzdSLpianyiliang*Point+diancha);
         ObjectSet("dxzdSelli3kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli3kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli3kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli4kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,4,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,4,0)+dxzdSLpianyiliang*Point+diancha);
         ObjectSet("dxzdSelli4kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli4kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli4kSL1",OBJPROP_COLOR,Red);
        }
      if(ObjectFind(0,"dxzdSelli5kSL1")<0)//第一次启动运行
        {
         ObjectCreate(0,"dxzdSelli5kSL1",OBJ_RECTANGLE,0,Time[0],GetiHighest(0,5,0)+dxzdSLpianyiliang*Point+diancha,Time[0]+500,GetiHighest(0,5,0)+dxzdSLpianyiliang*Point+diancha);
         ObjectSet("dxzdSelli5kSL1",OBJPROP_BACK,false);
         ObjectSet("dxzdSelli5kSL1",OBJPROP_WIDTH,1);
         ObjectSet("dxzdSelli5kSL1",OBJPROP_COLOR,Red);
        }
     }
/////////////////////////////////////////////下面 挂靠定时器 5s执行一次 5s

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(Tickmode)//剥头皮模式
     {
      if(ObjectFind(0,"SLbuyQpengcangline")==0)
        {
         SLbuyQpengcangline=NormalizeDouble(ObjectGet("SLbuyQpengcangline",1),Digits);  //定时更新横线的价格
        }
      if(ObjectFind(0,"SLsellQpengcangline")==0)
        {
         SLsellQpengcangline=NormalizeDouble(ObjectGet("SLsellQpengcangline",1),Digits);  //定时更新横线的价格
        }
      if(ObjectFind(0,"SLbuyQpengcangline1")==0)
        {
         SLbuyQpengcangline=NormalizeDouble(ObjectGet("SLbuyQpengcangline1",1),Digits);  //定时更新横线的价格
        }
      if(ObjectFind(0,"SLsellQpengcangline1")==0)
        {
         SLsellQpengcangline=NormalizeDouble(ObjectGet("SLsellQpengcangline1",1),Digits);  //定时更新横线的价格
        }
     }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   if(SLbuylineQpingcang)//计算所有订单的均价再偏移多少点作为止盈的横线位置
     {
      if(GetHoldingbuyOrdersCount()>0)
        {
         if(ObjectFind("SLsellQpengcangline")==0)
           {
            SLsellQpengcangline=HoldingOrderbuyAvgPrice()+SL5QTPpingcang*Point;
            ObjectMove(0,"SLsellQpengcangline",0,Time[0],SLsellQpengcangline);
           }
         else
           {
            SetLevel("SLsellQpengcangline",Bid+2000*Point,DarkSlateGray);
            SLsellQpengcangline=Bid+2000*Point;
           }
        }
     }
   if(SLselllineQpingcang)//计算所有订单的均价再偏移多少点作为止盈的横线位置
     {
      if(GetHoldingsellOrdersCount()>0)
        {
         if(ObjectFind("SLbuyQpengcangline")==0)
           {
            SLbuyQpengcangline=HoldingOrdersellAvgPrice()-SL5QTPpingcang*Point;
            ObjectMove(0,"SLbuyQpengcangline",0,Time[0],SLbuyQpengcangline);
           }
         else
           {
            SetLevel("SLbuyQpengcangline",Ask-2000*Point,DarkSlateGray);
            SLbuyQpengcangline=Ask-2000*Point;
           }
        }
     }
   if(SLbuylineQpingcang1)//计算所有订单的均价再偏移多少点作为止盈的横线位置 *键 剥头皮模式下
     {
      if(GetHoldingbuyOrdersCount()>0)
        {
         if(ObjectFind("SLsellQpengcangline1")==0)
           {
            SLsellQpengcangline1=HoldingOrderbuyAvgPrice()+SL5QTPpingcang1*Point;
            ObjectMove(0,"SLsellQpengcangline1",0,Time[0],SLsellQpengcangline1);
           }
         else
           {
            SetLevel("SLsellQpengcangline1",Bid+2000*Point,DarkSlateGray);
            SLsellQpengcangline1=Bid+2000*Point;
           }
        }
     }
   if(SLselllineQpingcang1)//计算所有订单的均价再偏移多少点作为止盈的横线位置 *键 剥头皮模式下
     {
      if(GetHoldingsellOrdersCount()>0)
        {
         if(ObjectFind("SLbuyQpengcangline1")==0)
           {
            SLbuyQpengcangline1=HoldingOrdersellAvgPrice()-SL5QTPpingcang1*Point;
            ObjectMove(0,"SLbuyQpengcangline1",0,Time[0],SLbuyQpengcangline1);
           }
         else
           {
            SetLevel("SLbuyQpengcangline1",Ask-2000*Point,DarkSlateGray);
            SLbuyQpengcangline1=Ask-2000*Point;
           }
        }
     }
///////////////////////////////////////订单信息显示 挂靠5s 定时器执行

/////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////上面 5s 执行一次的定时器结束
   if(timeGMTYesNo0 && timeGMT0==D'1970.01.01 00:00:00')//定时器0 60秒执行一次 搜索定位 t0000 60s
     {
      timeGMT0=TimeGMT();
      //Print("定时器0启用 ",TimeLocal());
     }
   else
     {
      if(timeGMTYesNo0 && TimeGMT()>=timeGMT0+timeGMTSeconds0)
        {
         //Print("定时器3时间到 处理中 . . . ",TimeGMT());
         ////////////////////////////////////////挂靠定时器0 执行的代码
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            menu[4]=false;
            menu[5]=false;
            menu[6]=false;
            menu[7]=false;
            menu[8]=false;
            menu[9]=false;
            menu[10]=false;
            menu[11]=false;
            menu[12]=false;
            menu[13]=false;
            menu[14]=false;
            menu[15]=false;
            menu[16]=false;
            menu[17]=false;
            menu[19]=false;
           }

         buydangeshu=GetHoldingbuyOrdersCount();//定时更新订单个数
         selldangeshu=GetHoldingsellOrdersCount();
         if(buydangeshu>0 && selldangeshu==0)//确定单一方向
           {
            onlybuydan=true;
           }
         else
           {
            onlybuydan=false;
           }
         if(buydangeshu==0 && selldangeshu>0)
           {
            onlyselldan=true;
           }
         else
           {
            onlyselldan=false;
           }

         price1m5kLow=GetiLowest(1,5,0);//预先设定几个数值，都是最近几根K线的最高最低值 用来止盈止损用 放定时器里
         price1m5kHigh=GetiHighest(1,5,0);
         price1m10kLow=GetiLowest(1,10,0);
         price1m10kHigh=GetiHighest(1,10,0);
         price5m3kLow=GetiLowest(5,3,0);
         price5m3kHigh=GetiHighest(5,3,0);
         price5m5kLow=GetiLowest(5,5,0);
         price5m5kHigh=GetiHighest(5,5,0);
         price15m3kLow=GetiLowest(15,3,0);
         price15m3kHigh=GetiHighest(15,3,0);
         price15m5kLow=GetiLowest(15,5,0);
         price15m5kHigh=GetiHighest(15,5,0);
         price15m10kLow=GetiLowest(15,10,0);
         price15m10kHigh=GetiHighest(15,10,0);
         pricemkLow[0]=price1m5kLow;
         pricemkLow[1]=price1m10kLow;
         pricemkLow[2]=price5m3kLow;
         pricemkLow[3]=price5m5kLow;
         pricemkLow[4]=price15m3kLow;
         pricemkLow[5]=price15m5kLow;
         pricemkLow[6]=price15m10kLow;

         pricemkHigh[0]=price1m5kHigh;
         pricemkHigh[1]=price1m10kHigh;
         pricemkHigh[2]=price5m3kHigh;
         pricemkHigh[3]=price5m5kHigh;
         pricemkHigh[4]=price15m3kHigh;
         pricemkHigh[5]=price15m5kHigh;
         pricemkHigh[6]=price15m10kHigh;
         //for(int i=0; i<7; i++)
         // {
         //  Print(i," ",pricemkLow[i]);
         //  }
         ///////////////////////////////////////////////////////////////////
         if(menu6[10] && PeriodSeconds()!=60)//ATR止盈止损
           {
            ATRvalue=iATR(NULL,0,ATRcanshu,0);
            // Print("ATRvalue =",ATRvalue);
            for(int cnt=0; cnt<OrdersTotal(); cnt++)
              {
               if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
                 {
                  if(OrderSymbol()==Symbol())
                    {
                     double stp=OrderStopLoss();
                     double tpt=OrderTakeProfit();
                     double OpenPrice=OrderOpenPrice();

                     if(OriginalLot==0)
                       {
                        OriginalLot=OrderLots();
                       }
                     if(OrderType()==OP_BUY)
                       {
                        if(AutoATRStoploss)
                          {
                           bool a2=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice-ATRvalue*ATRSLbeishu-diancha-ATRSLpianyi*Point,OrderTakeProfit(),0,CLR_NONE);
                           if(a2)
                             {
                              stp=OpenPrice-ATRvalue*ATRSLbeishu-diancha-ATRSLpianyi*Point;
                             }
                          }
                        if(AutoATRTakeProfit)
                          {
                           bool a3=OrderModify(OrderTicket(),OrderOpenPrice(),stp,OpenPrice+ATRvalue*ATRTPbeishu-ATRTPpianyi*Point,0,CLR_NONE);
                          }

                       }
                     if(OrderType()==OP_SELL)
                       {
                        if(AutoATRStoploss)
                          {
                           bool a6=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice+ATRvalue*ATRSLbeishu+diancha+ATRSLpianyi*Point,OrderTakeProfit(),0,CLR_NONE);
                           if(a6)
                             {
                              stp=OpenPrice+ATRvalue*ATRSLbeishu+diancha+ATRSLpianyi*Point;
                             }
                          }
                        if(AutoATRTakeProfit)
                          {
                           bool a7=OrderModify(OrderTicket(),OrderOpenPrice(),stp,OpenPrice-ATRvalue*ATRTPbeishu+ATRTPpianyi*Point,0,CLR_NONE);
                          }
                       }
                    }
                 }
               else
                 {
                  OriginalLot=0;
                 }
              }
           }

         ///////////////////////////////////////////////////////////////////////
         if(iBreakoutSLpingcangBuy)
           {
            int static iBreakoutSLpingcangjishu1=0;
            if(iBreakoutSLpingcangBuyPrice<Bid)
              {
               iBreakoutSLpingcangjishu1++;
               if(iBreakoutSLpingcangjishu1>=iBreakoutSLpingcangjishu)
                 {
                  iBreakoutSLpingcangBuy=false;
                  iBreakoutSLpingcang=false;
                  iBreakoutSLpingcangjishu1=0;
                  Print("等待次数到 价格没有再突破新高 监控关闭");
                  comment1("等待次数到 价格没有再突破新高 监控关闭");
                 }
              }
            else
              {
               yijianpingbuydan();
               Print("等待时间到 价格还是没有返回 Buy单止损平仓");
               comment1("等待时间到 价格还是没有返回 Buy单止损平仓");
              }
           }
         if(iBreakoutSLpingcangSell)
           {
            int static iBreakoutSLpingcangjishu1=0;
            if(iBreakoutSLpingcangSellPrice>Bid)
              {
               iBreakoutSLpingcangjishu1++;
               if(iBreakoutSLpingcangjishu1>=iBreakoutSLpingcangjishu)
                 {
                  iBreakoutSLpingcangSell=false;
                  iBreakoutSLpingcang=false;
                  iBreakoutSLpingcangjishu1=0;
                  Print("等待次数到 价格没有再突破新低 监控关闭");
                  comment1("等待次数到 价格没有再突破新低 监控关闭");
                 }
              }
            else
              {
               yijianpingselldan();
               Print("等待时间到 价格还是没有返回 Sell单止损平仓");
               comment1("等待时间到 价格还是没有返回 Sell单止损平仓");
              }
           }
         //////////////////////////////////////////////////////////////////////////
         timeGMT0=TimeGMT();
        }
     }
///////////////////////////////////////////////////////////////////////////////////定时器0 t0000 结束
   if(dingdanxianshi && timeGMTYesNo2 && timeGMT2==D'1970.01.01 00:00:00')//定时器2 日志文字提示 定时删除 默认 20s 秒执行一次 搜索定位 t2222
     {
      timeGMT2=TimeGMT();
     }
   else
     {
      if(timeGMTYesNo2 && TimeGMT()>=timeGMT2+timeGMTSeconds2)
        {
         ///////////////////////////////////////////////////////////////////////////
         if(ObjectFind("zi")>=0)//日志文字提示 定时删除
            ObjectDelete("zi");
         if(ObjectFind("zi1")>=0)
            ObjectDelete("zi1");
         if(ObjectFind(0,"zi2")==0)
            ObjectDelete(0,"zi2");
         if(ObjectFind(0,"zi3")==0)
            ObjectDelete(0,"zi3");
         if(ObjectFind(0,"zi4")==0)
            ObjectDelete(0,"zi4");
         if(ObjectFind(0,"zi5")==0)
            ObjectDelete(0,"zi5");
         diancha=MarketInfo(Symbol(),MODE_SPREAD)*Point;
         BuyTrendLineSLjishu=5;
         SellTrendLineSLjishu=5;
         if(fansuoYes==false)//如果订单反锁时 不执行止盈止损 自动分步平仓
           {
            if(GetHoldingbuyOrdersCount()>0 || GetHoldingsellOrdersCount()>0)//如果订单反锁时 不执行止盈止损 自动分步平仓
              {
               if(NormalizeDouble(CGetbuyLots(),2)==NormalizeDouble(CGetsellLots(),2))
                 {
                  fansuoYes=true;
                  Print("多空锁仓中 不执行止盈止损 自动分步平仓 解锁后需要重新加载EA恢复功能 注意价格是否会触发分步平仓");
                  comment4("多空锁仓中 不执行止盈止损 自动分步平仓 解锁后");
                  comment5("需要重新加载EA恢复功能 注意价格是否会触发分步平仓");
                 }
              }
           }
         /////////////////////////////////////////////////////////////////////////////

         //////////////////////////////////////////////////////////////////////////////挂靠定时器执行 20s运行一次
         dingdanshu=100;//定时恢复默认值 dingdanshu4 空闲 备用
         dingdanshu1=dingdangeshu10;
         dingdanshu1=dingdangeshu10nom;
         dingdanshu2=zhinengSLTPdingdangeshu;//dingdanshu2已经使用，
         dingdanshu3=50;//dingdanshu3已经使用
         guadangeshu=huaxianguadangeshu;
         huaxianguadanlotsT=huaxianguadanlots;
         linepianyi1=linepianyi;
         buyLotslinshi=CGetbuyLots();
         sellLotslinshi=CGetsellLots();
         buylineOnTimer=Ask;
         selllineOnTimer=Bid;
         /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         if(menu[27] && menu27Tick)
           {
            if(ObjectFind(0,"BuyStop1")==0 && ObjectGetDouble(0,"BuyStop1",OBJPROP_PRICE,0)<Bid)
              {
               comment4("K线收盘时 K线实体越过了横线 开仓追");
               Print("K线收盘时 K线实体越过了横线 开仓追 Tick");
               int keybuy=OrderSend(Symbol(),OP_BUY,buyLotslinshi1,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"BuyStop1");
                  buyLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
            if(ObjectFind(0,"SellStop1")==0 && ObjectGetDouble(0,"SellStop1",OBJPROP_PRICE,0)>Bid)
              {
               comment4("K线收盘时 K线实体越过了横线 开仓追");
               Print("K线收盘时 K线实体越过了横线 开仓追 Tick");
               int keysell=OrderSend(Symbol(),OP_SELL,sellLotslinshi1,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell>0)
                 {
                  PlaySound("ok.wav");
                  ObjectDelete(0,"SellStop1");
                  sellLotslinshi1=0.0;
                  menu[27]=false;
                  menu27Tick=false;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }

              }
           }
         ////////////////////////////////////////////////////////////////////////////////////////
         ///////////////////////////////////////////////////////////////////////////////
         if(mbfx_tubiao)
           {
            if(NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",0,0),4)==0.0)
              {
               comment4("MBFX 指标 没有找到  请放到Indicators/Custom/MBFX Timing.ex4 ");
               Print("震荡突破 指标 没有找到 请放到Indicators/Custom/MBFX Timing.ex4");
               mbfx_tubiao=false;
               return;
              }
            double value0=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",0,0),2);
            double value1=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",1,0),2);
            double value2=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",2,0),2);
            double value11K=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",1,1),2);
            double value21K=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",2,1),2);
            if(ObjectFind(0,"mbfxR1")<0)
              {
               ObjectCreate(0,"mbfxR1",OBJ_LABEL,0,0,0);
               ObjectSetInteger(0,"mbfxR1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
               ObjectSetInteger(0,"mbfxR1",OBJPROP_XDISTANCE,80);
               ObjectSetInteger(0,"mbfxR1",OBJPROP_YDISTANCE,100);
               ObjectSetText("mbfxR1","MBFX "+string(value0),12,"黑体",dingdanxianshicolor);
               ObjectSetString(0,"mbfxR1",OBJPROP_TOOLTIP,"MBFX震荡指标 单边行情请勿参考 数值0到100之间  如果出现 亮黄色 反转信号 下面会有提示");
              }
            else
              {
               ObjectSetText("mbfxR1","MBFX "+string(value0),12,"黑体",dingdanxianshicolor);
              }
            /*
                  if(ObjectFind(0,"mbfxR3")<0)
            {
             ObjectCreate(0,"mbfxR3",OBJ_LABEL,0,0,0);
             ObjectSetInteger(0,"mbfxR3",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
             ObjectSetInteger(0,"mbfxR3",OBJPROP_XDISTANCE,100);
             ObjectSetInteger(0,"mbfxR3",OBJPROP_YDISTANCE,120);
             ObjectSetText("mbfxR3","MBFX "+string(value1),12,"黑体",dingdanxianshicolor);
             ObjectSetString(0,"mbfxR3",OBJPROP_TOOLTIP,"MBFX 指标 数值0到100之间  如果出现 亮黄色 反转信号 下面会有提示");
            }
            else
            {
             ObjectSetText("mbfxR3","MBFX "+string(value1),12,"黑体",dingdanxianshicolor);
            }

                  if(ObjectFind(0,"mbfxR4")<0)
            {
             ObjectCreate(0,"mbfxR4",OBJ_LABEL,0,0,0);
             ObjectSetInteger(0,"mbfxR4",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
             ObjectSetInteger(0,"mbfxR4",OBJPROP_XDISTANCE,100);
             ObjectSetInteger(0,"mbfxR4",OBJPROP_YDISTANCE,140);
             ObjectSetText("mbfxR4","MBFX "+string(value2),12,"黑体",dingdanxianshicolor);
             ObjectSetString(0,"mbfxR4",OBJPROP_TOOLTIP,"MBFX 指标 数值0到100之间  如果出现 亮黄色 反转信号 下面会有提示");
            }
            else
            {
             ObjectSetText("mbfxR4","MBFX "+string(value2),12,"黑体",dingdanxianshicolor);
            }
            */
            if(ObjectFind(0,"mbfxR2")<0)
              {
               ObjectCreate(0,"mbfxR2",OBJ_LABEL,0,0,0);
               ObjectSetInteger(0,"mbfxR2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
               ObjectSetInteger(0,"mbfxR2",OBJPROP_XDISTANCE,80);
               ObjectSetInteger(0,"mbfxR2",OBJPROP_YDISTANCE,120);
               ObjectSetText("mbfxR2"," ",12,"黑体",dingdanxianshicolor);
               ObjectSetString(0,"mbfxR2",OBJPROP_TOOLTIP," ");
              }
            else
              {
               if(value0>20 && value0<80)
                 {
                  ObjectSetText("mbfxR2"," ",12,"黑体",dingdanxianshicolor);
                  ObjectSetString(0,"mbfxR2",OBJPROP_TOOLTIP," ");
                 }
               else
                 {
                  if(value0>=80 && value1>200 && value11K<=100)
                    {
                     ObjectSetText("mbfxR2","MBFX回撤",12,"黑体",dingdanxianshicolor);
                     ObjectSetString(0,"mbfxR2",OBJPROP_TOOLTIP,"上升途中 出现了 回撤信号 ");
                     if(mbfxSleeptime+mbfxSleep>TimeCurrent())
                       {

                       }
                     else
                       {
                        Print("MBFX指标 上升途中出现了 回撤信号");
                        comment4("MBFX指标 上升途中出现了 回撤信号");

                        if(menu3[22]==false)
                          {
                           PlaySound("alert.wav");
                           PlaySound("maidou.wav");
                          }
                        mbfxSleeptime=TimeCurrent();
                        if(menu2[2])
                          {
                           Print("MBFX指标 上升途中出现了 回撤信号 先平仓");
                           comment5("MBFX指标 上升途中出现了 回撤信号 先平仓");
                           yijianpingbuydan();
                           menu2[2]=false;
                          }
                       }

                    }
                  if(value0<=20 && value2>200 && value21K<=100)
                    {
                     ObjectSetText("mbfxR2","MBFX反弹",12,"黑体",dingdanxianshicolor);
                     ObjectSetString(0,"mbfxR2",OBJPROP_TOOLTIP,"下降途中 出现了 反弹信号 ");
                     if(mbfxSleeptime+mbfxSleep>TimeCurrent())
                       {

                       }
                     else
                       {
                        Print("MBFX指标 下降途中 出现了 反弹信号");
                        comment4("MBFX指标 下降途中 出现了 反弹信号");

                        if(menu3[22]==false)
                          {
                           PlaySound("alert.wav");
                           PlaySound("maidou.wav");
                          }
                        mbfxSleeptime=TimeCurrent();
                        if(menu2[2])
                          {
                           Print("MBFX指标 下降途中 出现了 反弹信号 先平仓");
                           comment5("MBFX指标 下降途中 出现了 反弹信号 先平仓");
                           yijianpingselldan();
                           menu2[2]=false;
                          }
                       }

                    }
                 }
              }
           }
         ///////////////////////////////////////////////////

         if(ObjectFind(0,"SLbuyQpengcangline")==0)
           {
            SLbuyQpengcangline=NormalizeDouble(ObjectGet("SLbuyQpengcangline",1),Digits);  //定时更新横线的价格
           }
         if(ObjectFind(0,"SLsellQpengcangline")==0)
           {
            SLsellQpengcangline=NormalizeDouble(ObjectGet("SLsellQpengcangline",1),Digits);  //定时更新横线的价格
           }
         if(ObjectFind(0,"SLbuyQpengcangline1")==0)
           {
            SLbuyQpengcangline=NormalizeDouble(ObjectGet("SLbuyQpengcangline1",1),Digits);  //定时更新横线的价格
           }
         if(ObjectFind(0,"SLsellQpengcangline1")==0)
           {
            SLsellQpengcangline=NormalizeDouble(ObjectGet("SLsellQpengcangline1",1),Digits);  //定时更新横线的价格
           }
         //////////////////////////////////////////////////////////////////////////////////////////////////////////////// 短线剥头皮 开始
         if(SL1mbuyLine)//一分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL1mbuyLine")==0)
              {
               SL1mbuyLineprice1=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL1mbuyLineprice1>=SL1mbuyLineprice)
                  SL1mbuyLineprice=SL1mbuyLineprice1;
               ObjectMove("SL1mbuyLine",0,Time[3],SL1mbuyLineprice);
              }
            else
              {
               SL1mbuyLineprice=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;
               SetLevel("SL1mbuyLine",SL1mbuyLineprice,Maroon);
              }
           }
         if(SL1msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL1msellLine")==0)
              {
               SL1msellLineprice1=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL1msellLineprice1<=SL1msellLineprice)
                  SL1msellLineprice=SL1msellLineprice1;
               ObjectMove("SL1msellLine",0,Time[3],SL1msellLineprice);
              }
            else
              {
               SL1msellLineprice=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL1msellLine",SL1msellLineprice,Maroon);
              }
           }
         if(SL5mbuyLine)//五分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL5mbuyLine")==0)
              {
               SL5mbuyLineprice1=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL5mbuyLineprice1>=SL5mbuyLineprice)
                  SL5mbuyLineprice=SL5mbuyLineprice1;
               ObjectMove("SL5mbuyLine",0,Time[3],SL5mbuyLineprice);
              }
            else
              {
               SL5mbuyLineprice=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SetLevel("SL5mbuyLine",SL5mbuyLineprice,Maroon);
              }
           }
         if(SL5msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL5msellLine")==0)
              {
               SL5msellLineprice1=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL5msellLineprice1<=SL5msellLineprice)
                  SL5msellLineprice=SL5msellLineprice1;
               ObjectMove("SL5msellLine",0,Time[3],SL5msellLineprice);
              }
            else
              {
               SL5msellLineprice=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL5msellLine",SL5msellLineprice,Maroon);
              }
           }
         if(SL15mbuyLine)//十五分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL15mbuyLine")==0)
              {
               SL15mbuyLineprice1=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL15mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL15mbuyLineprice1>=SL15mbuyLineprice)
                  SL15mbuyLineprice=SL15mbuyLineprice1;
               ObjectMove("SL15mbuyLine",0,Time[3],SL15mbuyLineprice);
              }
            else
              {
               SL15mbuyLineprice=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL15mlinetimeframe,0))-SLbuylinepianyi*Point;;
               SetLevel("SL15mbuyLine",SL15mbuyLineprice,Maroon);
              }
           }
         if(SL15msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL15msellLine")==0)
              {
               SL15msellLineprice1=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL15msellLineprice1<=SL15msellLineprice)
                  SL15msellLineprice=SL15msellLineprice1;
               ObjectMove("SL15msellLine",0,Time[3],SL15msellLineprice);
              }
            else
              {
               SL15msellLineprice=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL15msellLine",SL15msellLineprice,Maroon);
              }
           }
         ///////////////////////////////////////////////////////剥头皮结束
         timeGMT2=TimeGMT();
        }
     }
///////////////////////////////////////////////////////////////////////////////定时器2结束 t2222
   if(GetHoldingdingdanguadanOrdersCount()==0)//没有订单或挂单时 下面的代码 终止运行
     {
      if(timertrue==true)
        {
         return;
        }
      else
        {
         if(ObjectFind("buy")>=0)//删左上角文字
            ObjectDelete("buy");
         if(ObjectFind("sell")>=0)
            ObjectDelete("sell");
         if(ObjectFind("buysell")>=0)
            ObjectDelete("buysell");
         if(ObjectFind("AccountEquity")>=0)
            ObjectDelete("AccountEquity");
         if(ObjectFind("AccountFreeMargin")>=0)
            ObjectDelete("AccountFreeMargin");
         if(ObjectFind("zi")>=0)
            ObjectDelete("zi");
         if(ObjectFind(0,"iBSTrend")==0)
            ObjectDelete(0,"iBSTrend");
         if(ObjectFind(0,"MBFX")==0)
            ObjectDelete(0,"MBFX");
         if(ObjectFind(0,"iBreakout")==0)
            ObjectDelete(0,"iBreakout");
         if(ObjectFind(0,"iBreakoutfanshou")==0)
            ObjectDelete(0,"iBreakoutfanshou");
         linebuypingcang=false;//订单手动平仓后 解除横线模式的触线平仓
         linebuypingcangR=false;
         linebuypingcangC=false;
         linebuypingcangctrlR=false;
         linesellpingcang=false;
         linesellpingcangR=false;
         linesellpingcangC=false;
         linesellpingcangctrlR=false;

         timertrue=true;
         return;
        }
     }
   else
     {
      timertrue=false;
     }
   if(timertrue)
     {
      return;
     }
   if(Lots()>0.0)
     {
      OnTimerswitch=true;
     }
   else
     {
      OnTimerswitch=false;
     }
   if(dingdanxianshi)//订单信息显示在图表
     {
      if(ObjectFind("buy")<0)
        {
         ObjectCreate(0,"buy",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"buy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"buy",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"buy",OBJPROP_YDISTANCE,dingdanxianshiY);
         ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         if(gloxianshijunjian)
           {
            ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手",12,"黑体",dingdanxianshicolor);
           }

        }
      if(ObjectFind("sell")<0)
        {
         ObjectCreate(0,"sell",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"sell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"sell",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"sell",OBJPROP_YDISTANCE,dingdanxianshiY+20);
         ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         if(gloxianshijunjian)
           {
            ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手",12,"黑体",dingdanxianshicolor);
           }

        }
      if(ObjectFind("buysell")<0)
        {
         ObjectCreate(0,"buysell",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"buysell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"buysell",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"buysell",OBJPROP_YDISTANCE,dingdanxianshiY+40);
         ObjectSetText("buysell","buylimit "+string(GetHoldingguadanbuylimitOrdersCount())+" buystop "+string(GetHoldingguadanbuystopOrdersCount())+" selllimit "+string(GetHoldingguadanselllimitOrdersCount())+" sellstop "+string(GetHoldingguadansellstopOrdersCount()),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         ObjectSetText("buysell","buylimit "+string(GetHoldingguadanbuylimitOrdersCount())+" buystop "+string(GetHoldingguadanbuystopOrdersCount())+" selllimit "+string(GetHoldingguadanselllimitOrdersCount())+" sellstop "+string(GetHoldingguadansellstopOrdersCount()),12,"黑体",dingdanxianshicolor);
        }

      if(ObjectFind("AccountEquity")<0)
        {
         ObjectCreate(0,"AccountEquity",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"AccountEquity",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"AccountEquity",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"AccountEquity",OBJPROP_YDISTANCE,dingdanxianshiY+60);
         ObjectSetText("AccountEquity","账户净值:"+DoubleToString(NormalizeDouble(AccountEquity(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         ObjectSetText("AccountEquity","账户净值:"+DoubleToString(NormalizeDouble(AccountEquity(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }

      if(ObjectFind("AccountFreeMargin")<0)
        {
         ObjectCreate(0,"AccountFreeMargin",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_YDISTANCE,dingdanxianshiY+80);
         ObjectSetText("AccountFreeMargin","可用保证金:"+DoubleToString(NormalizeDouble(AccountFreeMargin(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         ObjectSetText("AccountFreeMargin","可用保证金:"+DoubleToString(NormalizeDouble(AccountFreeMargin(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }
      /////////////////////////////////////////////////////////////
      if(ObjectFind("botoupi")<0)
        {
         ObjectCreate(0,"botoupi",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"botoupi",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"botoupi",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"botoupi",OBJPROP_YDISTANCE,dingdanxianshiY+100);
         if(Tickmode)
           {
            ObjectSetText("botoupi","剥头皮模式 启用",12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"botoupi");
           }
        }
      else
        {
         if(Tickmode)
           {
            ObjectSetText("botoupi","剥头皮模式 启用",12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"botoupi");
           }
        }
      ///////////////////////////////////////////////////////////////////////////
      if(ObjectFind("zonglirun")<0)
        {
         ObjectCreate(0,"zonglirun",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"zonglirun",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"zonglirun",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"zonglirun",OBJPROP_YDISTANCE,dingdanxianshiY+160);
         if(accountProfitswitch)
           {
            ObjectSetText("zonglirun","总利润模式平仓 启用 止盈"+DoubleToString(accountProfitmax,0)+"止损"+DoubleToString(accountProfitmin,0),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"zonglirun");
           }
        }
      else
        {
         if(accountProfitswitch)
           {
            ObjectSetText("zonglirun","总利润模式平仓 启用 止盈"+DoubleToString(accountProfitmax,0)+"止损"+DoubleToString(accountProfitmin,0),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"zonglirun");
           }
        }
      //////////////////////////////////////////////////////////////////////////////
      if(ObjectFind("zonglirun1")<0)
        {
         ObjectCreate(0,"zonglirun1",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"zonglirun1",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"zonglirun1",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"zonglirun1",OBJPROP_YDISTANCE,dingdanxianshiY+180);
         if(accountProfitswitch1)
           {
            ObjectSetText("zonglirun1","总利润模式平仓剥头皮 启用 止盈"+DoubleToString(accountProfitmax1,0)+"止损"+DoubleToString(accountProfitmin1,0),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"zonglirun1");
           }
        }
      else
        {
         if(accountProfitswitch1)
           {
            ObjectSetText("zonglirun1","总利润模式平仓剥头皮 启用 止盈"+DoubleToString(accountProfitmax1,0)+"止损"+DoubleToString(accountProfitmin1,0),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"zonglirun1");
           }
        }
      /////////////////////////////////////////////////////////////////////////////
      if(imbfxT)
        {
         if(ObjectFind("MBFX")<0)
           {
            ObjectCreate(0,"MBFX",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"MBFX",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"MBFX",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"MBFX",OBJPROP_YDISTANCE,dingdanxianshiY+120);
            ObjectSetText("MBFX","MBFX指标平仓启用",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"MBFX")==0)
            ObjectDelete(0,"MBFX");
        }
      if(iBSTrend)
        {
         if(ObjectFind("iBSTrend")<0)
           {
            ObjectCreate(0,"iBSTrend",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_YDISTANCE,dingdanxianshiY+140);
            ObjectSetText("iBSTrend","BSTrend指标平仓启用",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"iBSTrend")==0)
            ObjectDelete(0,"iBSTrend");
        }
      /////////////////////////////////////////////////////////////////////////////////////////////////////
      if(iBreakout)
        {
         if(ObjectFind("iBreakout")<0)
           {
            ObjectCreate(0,"iBreakout",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"iBreakout",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"iBreakout",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"iBreakout",OBJPROP_YDISTANCE,dingdanxianshiY+160);
            ObjectSetText("iBreakout","Breakout指标平仓启用 参数"+DoubleToString(iBreakoutmax,2)+"%",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"iBreakout")==0)
            ObjectDelete(0,"iBreakout");
        }
      ///////////////////////////////////////////////////////////////
      if(iBreakoutfanshou)
        {
         if(ObjectFind("iBreakoutfanshou")<0)
           {
            ObjectCreate(0,"iBreakoutfanshou",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"iBreakoutfanshou",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"iBreakoutfanshou",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"iBreakoutfanshou",OBJPROP_YDISTANCE,dingdanxianshiY+180);
            ObjectSetText("iBreakoutfanshou","Breakout指标 全平后反手启用 参数"+DoubleToString(iBreakoutfanshoumax,2)+"%",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"iBreakoutfanshou")==0)
            ObjectDelete(0,"iBreakoutfanshou");
        }

      ///////////////////////////////////////////////////////////////////////////////////////////

     }
///////////////////////////////////////////////////////////////////////////////////////////订单信息显示在图表 结束

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(OnTimerswitch==false)//没有订单时 终止运行
     {
      return;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(EAswitch==false)
     {
      return;
     }
///////////////////////////////////////////////////////////////////////////////////////////
   if(huaxianTimeSwitch)//在定时器中使用划线平仓或反锁 布林带平仓
      HuaxianSwitch();
////////////////////////////////////////////////////////
   if(SL5QTPtimeCurrenttrue)//剥头皮 定时器 测试中
     {
      if(SL5QTPtimeCurrent+SL5QTPtime<TimeCurrent())
        {
         SLQlotsT=SLQlots;
         if(SL5QTPtimeCurrent+SL5QTPtime1<TimeCurrent())
           {
            yijianpingcangMagic(1688);
            Print("剥头皮等待时间超过",SL5QTPtime1,"秒直接平仓 ",SL5QTPtimeCurrent);
            comment(StringFormat("剥头皮等待时间超过%G秒直接平仓",SL5QTPtime1));
            SL5QTPtimeCurrenttrue=false;
            SLbuylineQpingcangT=false;
            SLbuylineQpingcang=false;
            SLselllineQpingcangT=false;
            SLselllineQpingcang=false;
            if(ObjectFind(0,"SLsellQpengcangline1")==0)
               ObjectDelete(0,"SLsellQpengcangline1");
            if(ObjectFind(0,"SLbuyQpengcangline1")==0)
               ObjectDelete(0,"SLbuyQpengcangline1");
           }
         else
           {
            if(AccountProfit()>0.0)
              {
               yijianpingcangMagic(1688);
               Print("剥头皮等待时间超过",SL5QTPtime,"秒保本平仓 ",SL5QTPtimeCurrent);
               comment(StringFormat("剥头皮等待时间超过%G秒保本平仓",SL5QTPtime));
               SL5QTPtimeCurrenttrue=false;
               SLbuylineQpingcangT=false;
               SLbuylineQpingcang=false;
               SLselllineQpingcangT=false;
               SLselllineQpingcang=false;
               if(ObjectFind(0,"SLsellQpengcangline1")==0)
                  ObjectDelete(0,"SLsellQpengcangline1");
               if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                  ObjectDelete(0,"SLbuyQpengcangline1");
              }
           }
        }
     }
//-----
   if(imbfxT)//依据指标自动平仓 测试阶段 I+1
     {
      double mbfx=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",7,0.0,0,0),4);
      if(mbfx==0.0)
        {
         comment("MBFX指标没有找到 无法启用 请放到Indicators/Custom/MBFX Timing.ex4 ");
         Print("MBFX指标没有找到 无法启用 请放到Indicators/Custom/MBFX Timing.ex4");
         imbfxT=false;
         return;
        }
      if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()==0.0)//
        {
         if(mbfx>imbfxTmax)
           {
            xunhuanquanpingcang();
            imbfxT=false;
            Print("MBFX指标 大于",imbfxTmax,"buy单自动平仓 ",mbfx);
           }
        }
      else
        {
         if(GetHoldingbuyOrdersCount()==0.0 && GetHoldingsellOrdersCount()>0)//
           {
            if(mbfx<imbfxTmin)
              {
               xunhuanquanpingcang();
               imbfxT=false;
               Print("MBFX指标 小于",imbfxTmin,"sell单自动平仓 ",mbfx);
              }
           }
         else
           {
            imbfxT=false;
            comment("没订单或多空单都有 无法启动指标平仓");
            Print("没订单或多空单都有 无法启动指标平仓");
           }
        }
     }
//-----
   if(iBSTrend)//依据指标自动平仓I+2 测试阶段
     {
      double bstrend=NormalizeDouble(iCustom(NULL,0,"Custom/bstrend-indicator",12,0,0),5);
      //Print(bstrend);
      if(bstrend==0.0)
        {
         comment("BSTrend指标没有找到 无法启用 请放到Indicators/Custom/bstrend-indicator.ex4 ");
         Print("BSTrend指标没有找到 无法启用 或刚好当前的数值等于0");
         iBSTrend=false;
         return;
        }
      if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()==0.0)//多单
        {
         if(bstrend<imbfxTmin)
           {
            xunhuanquanpingcang();
            iBSTrend=false;
            Print("BSTrend指标 小于",iBSTrendmin,"多单自动平仓 ",bstrend);
           }
        }
      else
        {
         if(GetHoldingbuyOrdersCount()==0.0 && GetHoldingsellOrdersCount()>0)//
           {
            if(bstrend>iBSTrendmax)
              {
               xunhuanquanpingcang();
               iBSTrend=false;
               Print("BSTrend指标 大于",iBSTrendmax,"空单自动平仓 ",bstrend);
              }
           }
         else
           {
            iBSTrend=false;
            comment("没订单或多空单都有 无法启动指标平仓");
            Print("没订单或多空单都有 无法启动指标平仓");
           }
        }
     }
//////////////////////////////////////////////////////////////////////////////////////
   if(iBreakoutSLpingcang)//Breakout指标 突破箱体 等待60秒如不反转 止损平仓
     {
      double ibreakout;
      ibreakout=NormalizeDouble(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0),2);
      if(ibreakout==0.0)
        {
         comment("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4 ");
         Print("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4");
         iBreakoutSLpingcang=false;
         return;
        }

      if(ibreakout>100)
        {
         iBreakoutSLpingcangSell=true;
         iBreakoutSLpingcangSellPrice=Bid;
         Print("Breakout指标 突破箱体 等待60秒如不反转 止损平仓");
        }
      if(ibreakout<-100)
        {
         iBreakoutSLpingcangBuy=true;
         iBreakoutSLpingcangBuyPrice=Bid;
         Print("Breakout指标 突破箱体 等待60秒如不反转 止损平仓");
        }
     }
//////////////////////////////////////////////////////////////////////////////////////
   if(iBreakout)//依据指标自动平仓I+3 测试阶段
     {
      double ibreakout;
      if(iBreakout15)
        {
         ibreakout=NormalizeDouble(iCustom(NULL,15,"Custom/XU v4-Breakout",1,0),2);
         //Print(ibreakout);
        }
      else
        {
         ibreakout=NormalizeDouble(iCustom(NULL,0,"Custom/XU v4-Breakout",1,0),2);
         //Print(ibreakout);
        }

      if(ibreakout==0.0)
        {
         comment("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4 ");
         Print("Breakout指标没有找到 无法启用 请放到Indicators/Custom/XU v4-Breakout.ex4");
         iBreakout=false;
         return;
        }
      if(GetHoldingbuyOrdersCount()>0.0)//多单
        {
         if(ibreakout>iBreakoutmax)
           {
            yijianpingbuydan();
            iBreakout=false;
            Print("Breakout指标 大于",iBreakoutmax,"多单自动平仓 ",ibreakout);
           }
        }
      if(GetHoldingsellOrdersCount()>0.0)//空单
        {
         if(ibreakout<-iBreakoutmax)
           {
            yijianpingselldan();
            iBreakout=false;
            Print("Breakout指标 小于",-iBreakoutmax,"空单自动平仓 ",ibreakout);
           }

        }
     }
///////////////////////////////////////////////////////////////////////////////////////
   if(linebuypingcangC)//触及横线全平仓 定时器
     {
      // Print("触及横线全平仓 定时器");
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         xunhuanquanpingcang();
         linebuypingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }

      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         xunhuanquanpingcang();
         linebuypingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(linesellpingcangC)//触及横线全平仓 定时器
     {
      //Print("触及横线全平仓 定时器");
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         xunhuanquanpingcang();
         linesellpingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         xunhuanquanpingcang();
         linesellpingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }
//////////////////////////////////////////////////////////////////////////////////////////////////// 上面 从订单显示 到这来 是5s运行一次的 不在定时器2中
   if(timeGMTYesNo1 && timeGMT1==D'1970.01.01 00:00:00')//定时器1 ea自动止盈止损主程序 默认180秒运行一次 搜索定位 t1111 180s
     {
      timeGMT1=TimeGMT();
      //Print("定时器1启用 ",TimeGMT());
     }
   else
     {
      if(timeGMTYesNo1 && TimeGMT()>=timeGMT1+timeGMTSeconds1)
        {
         //Print("定时器1时间到 ea自动止盈止损主程序 处理中 . . . ",TimeGMT());
         ///////////////////////////////////////////////////////////////////////////////////// 挂靠定时器执行的相关代码
         if(linelock==false)//横线模式执行后 清场
           {
            linebuykaicang=false;
            linesellkaicang=false;
            linekaicangshiftR=false;
            linekaicangT=false;
            linekaicangctrl=false;
            linebuypingcang=false;
            linebuypingcangR=false;
            linebuypingcangC=false;
            linebuypingcangctrlR=false;
            linesellpingcang=false;
            linesellpingcangR=false;
            linesellpingcangC=false;
            linesellpingcangctrlR=false;
           }
         shangpress=0;
         xiapress=0;
         leftpress=0;
         rightpress=0;//清除方向键按下次数 挂靠定时器1执行
         keylotshalf=keylots;
         SLlinepingcangjishu1=0;//

         akey=false;//定时清除按键状态 挂靠定时器1执行
         zkey=false;
         ctrl=false;
         ctrlR=false;
         shift=false;
         shiftR=false;
         tab=false;
         bkey=false;
         skey=false;
         pkey=false;
         lkey=false;
         tkey=false;
         gkey=false;
         okey=false;
         ykey=false;
         kkey=false;
         vkey=false;
         fkey=false;
         jkey=false;
         dkey=false;
         mkey=false;
         nkey=false;
         nakey=false;//主键盘数字1 左边的按键
         ikey=false;
         hkey=false;

         pricemkLowjishu=0;
         pricemkHighjishu=0;
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(ObjectFind("firstPS")!=-1)
            ObjectDelete("firstPS");
         if(GetLastError()==129)
           {
            linebuykaicang=false;
            linesellkaicang=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         //////////////////////////////////////////////////////////////////////////////////////////////////


         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(EAswitch==false)
            return;
         if(fansuoYes)
            return;//如果反锁订单时 不执行自动止盈止损
         for(int cnt=0; cnt<OrdersTotal(); cnt++) //ea止盈止损主程序
           {
            if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && autosttp)
                 {
                  double stp=OrderStopLoss();
                  double tpt=OrderTakeProfit();
                  double OpenPrice=OrderOpenPrice();

                  if(OriginalLot==0)
                    {
                     OriginalLot=OrderLots();
                    }
                  if(OrderType()==OP_BUY)
                    {
                     if(AutoStoploss && AutoTakeProfit && stp==0 && tpt==0)
                        bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice-Point*stoploss,OpenPrice+Point*takeprofit,0,CLR_NONE);
                     else
                       {
                        if(AutoStoploss && stp==0)
                          {
                           bool a2=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice-Point*stoploss,OrderTakeProfit(),0,CLR_NONE);
                          }

                        if(AutoTakeProfit && tpt==0)
                          {
                           bool a3=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OpenPrice+Point*takeprofit,0,CLR_NONE);
                          }

                        if(AutoTrailingStop && ((Bid-OpenPrice)>Point*TrailingStop))
                          {
                           if((Bid-stp)>TrailingStop*Point)
                              bool a4=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,CLR_NONE);
                          }
                       }
                    }
                  if(OrderType()==OP_SELL)
                    {

                     if(AutoStoploss && AutoTakeProfit && stp==0 && tpt==0)
                        bool a5=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice+Point*stoploss,OpenPrice-Point*takeprofit,0,CLR_NONE);
                     else
                       {
                        if(AutoStoploss && stp==0)
                          {
                           bool a6=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice+Point*stoploss,OrderTakeProfit(),0,CLR_NONE);
                          }
                        if(AutoTakeProfit && tpt==0)
                          {
                           bool a7=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OpenPrice-Point*takeprofit,0,CLR_NONE);
                          }

                        if(AutoTrailingStop && ((OpenPrice-Ask)>Point*TrailingStop))
                          {
                           if((stp-Ask)>TrailingStop*Point)
                              bool a8=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,CLR_NONE);
                          }
                       }
                    }
                 }
              }
            else
              {
               OriginalLot=0;
              }
           }
         timeGMT1=TimeGMT();
        }
     }
///////////////////////////////////////////////////////////////////////
   if(timeGMTYesNo3 && timeGMT3==D'1970.01.01 00:00:00')//定时器3 t3333
     {
      timeGMT3=TimeGMT();
      Print("定时器3启用 ",TimeLocal());
     }
   else
     {
      if(timeGMTYesNo3 && TimeGMT()>=timeGMT3+timeGMTSeconds3)
        {
         //Print("定时器3时间到 处理中 . . . ",TimeGMT());
         if(buytrue03)
           {
            if(GetiLowest(timeframe03,bars03,beginbar03)-pianyiliang03*Point<timebuyprice)
              {
               Print("不后移SL");
              }
            else
              {
               PiliangSL(buytrue03,GetiLowest(timeframe03,bars03,beginbar03),jianju03,pianyiliang03,juxianjia03,dingdangeshu03);
               timebuyprice=GetiLowest(timeframe03,bars03,beginbar03)-pianyiliang03*Point;
              }
           }
         else
           {
            if(GetiHighest(timeframe03,bars03,beginbar03)+pianyiliang03*Point>timesellprice)
              {
               Print("不后移SL");
              }
            else
              {
               PiliangSL(buytrue03,GetiHighest(timeframe03,bars03,beginbar03),jianju03,pianyiliang03,juxianjia03,dingdangeshu03);
               timesellprice=GetiHighest(timeframe03,bars03,beginbar03)+pianyiliang03*Point;
              }
           }
         //juxianjiadingshi03=true;
         timeGMT3=TimeGMT();
        }
     }
///////////////////////////////////////////////////////////////////////////////////
   if(timeGMTYesNo4 && timeGMT4==D'1970.01.01 00:00:00')//定时器4
     {
      timeGMT4=TimeGMT();
      Print("定时器4启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo4 && TimeGMT()>=timeGMT4+timeGMTSeconds4)
        {
         Print("定时器4时间到 处理中 . . . ",TimeLocal());
         if(buytrue04)
           {
            PiliangTP(buytrue04,GetiHighest(timeframe04,bars04,beginbar04),jianju04,pianyiliang04tp,juxianjia04,dingdangeshu04);
           }
         else
           {
            PiliangTP(buytrue04,GetiLowest(timeframe04,bars04,beginbar04),jianju04,pianyiliang04tp,juxianjia04,dingdangeshu04);
           }
         //juxianjiadingshi03=true;
         timeGMT4=TimeGMT();
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(timeGMTYesNo5 && timeGMT5==D'1970.01.01 00:00:00')//定时器5
     {
      timeGMT5=TimeGMT();
      Print("定时器5启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo5 && TimeGMT()>=timeGMT5+timeGMTSeconds5)
        {
         Print("定时器5时间到 处理中 . . . ",TimeLocal());
         if(buytrue05)
           {
            PiliangSL(buytrue05,GetiLowest(dingshitimeframe05,dingshibars05,dingshibeginbar05),dingshijianju05,dingshipianyiliang05,dingshijuxianjia05,dingshidingdangeshu05);
           }
         else
           {
            PiliangSL(buytrue05,GetiHighest(dingshitimeframe05,dingshibars05,dingshibeginbar05),dingshijianju05,dingshipianyiliang05,dingshijuxianjia05,dingshidingdangeshu05);
           }
         //juxianjiadingshi03=true;
         timeGMT5=TimeGMT();
        }
     }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(timeGMTYesNo6 && timeGMT6==D'1970.01.01 00:00:00')//定时器6
     {
      timeGMT6=TimeGMT();
      Print("定时器6启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo6 && TimeGMT()>=timeGMT6+timeGMTSeconds6)
        {
         Print("定时器6时间到 处理中 . . . ",TimeLocal());
         if(buytrue06)
           {
            PiliangTP(buytrue06,GetiHighest(dingshitimeframe06,dingshibars06,dingshibeginbar06),dingshijianju06,dingshipianyiliang06tp,dingshijuxianjia06,dingshidingdangeshu06);
           }
         else
           {
            PiliangTP(buytrue06,GetiLowest(dingshitimeframe06,dingshibars06,dingshibeginbar06),dingshijianju06,dingshipianyiliang06tp,dingshijuxianjia06,dingshidingdangeshu06);
           }
         //juxianjiadingshi03=true;
         timeGMT6=TimeGMT();
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(Tickmode==true)//Tick模式如果启用
     {
      return;
     }
   else
     {
      if(EAswitch==false)
         return;
      if(fansuoYes)
         return;
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
           {
            int ti=OrderTicket();
            double open=OrderOpenPrice();
            string zhushi=OrderComment();
            if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=OrderOpenPrice()+TrailingStop*Point)
              {
               string from=StringSubstr(OrderComment(),0,4);
               if(zhushi=="" || from!="from")
                 {
                  bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Bid,slippage);
                  if(oc==true)
                     PlaySound("ok.wav");
                 }
               else
                 {
                  int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                    {
                     double hlot=OrderLots();
                     double hcp=OrderClosePrice();
                     double bid=open+TrailingStop*Point;
                     for(int n=GraduallyNum; n>0; n--)
                       {
                        bid+=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                        if(Bid>=bid && bid>=hcp+minTP*Point)
                          {
                           bool oc=OrderClose(ti,hlot,Bid,slippage,CLR_NONE);
                           if(oc==true)
                             {
                              PlaySound("ok.wav");
                              break;
                             }
                          }
                       }
                    }
                 }
              }
            if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=OrderOpenPrice()-TrailingStop*Point)
              {
               string from=StringSubstr(OrderComment(),0,4);
               if(zhushi=="" || from!="from")
                 {
                  bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Ask,slippage);
                  if(oc==true)
                     PlaySound("ok.wav");
                 }
               else
                 {
                  int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                    {
                     double hlot=OrderLots();
                     double hcp=OrderClosePrice();
                     double ask=open-TrailingStop*Point;
                     for(int n=GraduallyNum; n>0; n--)
                       {
                        ask-=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                        if(Ask<=ask && ask<=hcp-minTP*Point)
                          {
                           bool oc=OrderClose(ti,hlot,Ask,slippage,CLR_NONE);
                           if(oc==true)
                             {
                              PlaySound("ok.wav");
                              break;
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }
////////////////////////////////////////////////////////////////////////////////////////////////
//EA运行代码结束 下面是自定义函数
double Lots()//当前货币对的订单仓位总数 不含挂单 不区分反锁单
  {
   double lots=0.0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               lots+=OrderLots();
              }
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(lots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closecode()//分步平仓
  {
// Print("closecode函数运行");
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         int ti=OrderTicket();
         double open=OrderOpenPrice();
         string zhushi=OrderComment();
         if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=OrderOpenPrice()+TrailingStop*Point)
           {
            string from=StringSubstr(OrderComment(),0,4);
            double lot=NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian);
            if(zhushi=="" || from!="from")
              {
               if(lot<minlot)
                 {
                  return;
                 }
               bool oc=OrderClose(OrderTicket(),lot,Bid,slippage);
               if(oc==true)
                  PlaySound("ok.wav");
              }
            else
              {
               int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                 {
                  double hlot=OrderLots();
                  double hcp=OrderClosePrice();
                  double bid=open+TrailingStop*Point;
                  for(int n=GraduallyNum; n>0; n--)
                    {
                     bid+=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                     if(Bid>=bid && bid>=hcp+minTP*Point)
                       {
                        bool oc=OrderClose(ti,hlot,Bid,slippage,CLR_NONE);
                        if(oc==true)
                          {
                           PlaySound("ok.wav");
                           break;
                          }
                       }
                    }
                 }
              }
           }
         if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=OrderOpenPrice()-TrailingStop*Point)
           {
            string from=StringSubstr(OrderComment(),0,4);
            double lot=NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian);
            if(zhushi=="" || from!="from")
              {
               if(lot<minlot)
                 {
                  return;
                 }
               bool oc=OrderClose(OrderTicket(),lot,Ask,slippage);
               if(oc==true)
                  PlaySound("ok.wav");
              }
            else
              {
               int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                 {
                  double hlot=OrderLots();
                  double hcp=OrderClosePrice();
                  double ask=open-TrailingStop*Point;
                  for(int n=GraduallyNum; n>0; n--)
                    {
                     ask-=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                     if(Ask<=ask && ask<=hcp-minTP*Point)
                       {
                        bool oc=OrderClose(ti,hlot,Ask,slippage,CLR_NONE);
                        if(oc==true)
                          {
                           PlaySound("ok.wav");
                           break;
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }
//////////////////////////////////////////////
void zuizaokeyclose()//平最早下的一单
  {
// for(int cnt=OrdersTotal()-1;cnt>=0;cnt--)
   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
           }
         else
           {
            if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
              {
               //  Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  return;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                 }
              }
           }
        }



      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }
///////////////////////////////////////////
void zuijinkeyclose()//平最近下的一单
  {
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print(error());
              }
           }
         else
           {
            if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
              {
               //   Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  return;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print(error());
                 }
              }
           }
        }
      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }
///////////////////////////////////////////
void zuijinBuyclose()//平最近下的一Buy单
  {
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               //Print("平最近下的一Buy单 成功");
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print(error());
              }
           }
        }
      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }
////////////////////////////////////////////////////////////
void zuijinSellclose()//平最近下的一Sell单
  {
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
           {
            //   Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               // Print("平最近下的一Sell单 成功");
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print(error());
              }
           }

        }
      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }
///////////////////////////////////////////
void zuidakeyclose()//平最大价格的一单
  {
   int ti=0;
   int ty=0;
   int op=0;
   int ticket[200]= {};
   int type[200];
   double openprice[200];
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==0 || OrderType()==1)
              {
               ticket[ti]=OrderTicket();
               openprice[op]=OrderOpenPrice();
               type[ty]=OrderType();
               ti++;
               ty++;
               op++;
              }
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   int maxopen=ArrayMaximum(openprice,op,0);
   int minopen=ArrayMinimum(openprice,op,0);
   int maxticket=ticket[maxopen];
   int minticket=ticket[minopen];
   if(OrderSelect(maxticket,SELECT_BY_TICKET)==true)
     {
      //Print(maxticket," 订单选择成功");
      bool oc=OrderClose(maxticket,OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
      if(oc==true)
        {
         PlaySound("ok.wav");
         return;
        }
      else
        {
         PlaySound("timeout.wav");
         Print("GetLastError=",error());
        }
     }
   /*
      if(OrderSelect(minticket,SELECT_BY_TICKET)==true)
        {
         Print(minticket," 订单选择成功");
         bool oc=OrderClose(minticket,OrderLots(),OrderClosePrice(),3,CLR_NONE);
         if(oc==true)
           {
            PlaySound("ok.wav");
            return;
           }
         else PlaySound("timeout.wav");
        }
   */
  }
///////////////////////////////////////////////
void zuixiaokeyclose()//平最小价格的一单
  {
   int ti=0;
   int ty=0;
   int op=0;
   int ticket[200]= {};
   int type[200];
   double openprice[200];
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==0 || OrderType()==1)
              {
               ticket[ti]=OrderTicket();
               openprice[op]=OrderOpenPrice();
               type[ty]=OrderType();
               ti++;
               ty++;
               op++;
              }
           }
     }
   int maxopen=ArrayMaximum(openprice,op,0);
   int minopen=ArrayMinimum(openprice,op,0);
   int maxticket=ticket[maxopen];
   int minticket=ticket[minopen];
   /*
      if(OrderSelect(maxticket,SELECT_BY_TICKET)==true)
        {
         Print(maxticket," 订单选择成功");
         bool oc=OrderClose(maxticket,OrderLots(),OrderClosePrice(),3,CLR_NONE);
         if(oc==true)
           {
            PlaySound("ok.wav");
            return;
           }
         else PlaySound("timeout.wav");
        }
        */

   if(OrderSelect(minticket,SELECT_BY_TICKET)==true)
     {
      //Print(minticket," 订单选择成功");
      bool oc=OrderClose(minticket,OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);



      if(oc==true)
        {
         PlaySound("ok.wav");
         return;
        }
      else
        {
         PlaySound("timeout.wav");
         Print("GetLastError=",error());
        }
     }

  }
//////////////////////////////////////////////////////////////////
void xunhuanquanpingcang()//循环全平仓 循环语句的当前货币对全平仓 没平完会一直平
  {
   int jishu=0;
   int errorjishu=0;
   while(xunhuandingdanshu()!=0)
     {
      for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
         //  for(int cnt=0;cnt<OrdersTotal();cnt++)
        {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
              {
               // Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  jishu++;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                  errorjishu++;
                 }
              }
            else
              {
               if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
                 {
                  //   Print(OrderTicket()," 订单选择成功");
                  bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
                  if(oc)
                    {
                     PlaySound("ok.wav");
                     jishu++;
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     Print("GetLastError=",error());
                     errorjishu++;
                    }
                 }
              }
           }
         else
           {
            Print("订单选择失败");
           }
         if(jishu>=pingcangdingdanshu)
           {
            Print("已预定计划平仓最近的",jishu,"单 ");
            pingcangdingdanshu=1000;
            jishu=0;
            return;
           }
        }
      if(errorjishu>20)
        {
         Print("平仓订单时出差 请人工查看错误代码");
         pingcangdingdanshu=1000;
         jishu=0;
         errorjishu=0;
         return;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void xunhuanquanpingcangplus()//循环全平仓 账户订单全平   没平完会一直平
  {
   int jishu=0;
   int errorjishu=0;
   while(xunhuandingdanshuplus()!=0)
     {
      for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
         //  for(int cnt=0;cnt<OrdersTotal();cnt++)
        {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderType()==OP_BUY)
              {
               // Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  jishu++;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",error());
                  errorjishu++;
                 }
              }
            else
              {
               if(OrderType()==OP_SELL)
                 {
                  //   Print(OrderTicket()," 订单选择成功");
                  bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
                  if(oc)
                    {
                     PlaySound("ok.wav");
                     jishu++;
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     Print("GetLastError=",error());
                     errorjishu++;
                    }
                 }
              }
           }
         else
           {
            Print("订单选择失败");
           }
         if(jishu>=pingcangdingdanshu)
           {
            Print("已预定计划平仓最近的",jishu,"单 ");
            pingcangdingdanshu=1000;
            jishu=0;
            return;
           }
        }
      if(errorjishu>20)
        {
         Print("全平仓订单时出差 请人工查看错误代码");
         pingcangdingdanshu=1000;
         jishu=0;
         errorjishu=0;
         return;
        }
     }
  }

/*
void xunhuanquanpingcangMagic(int xunhuanMagic)//循环语句的当前货币对全平仓 没平完会一直平
  {
while(xunhuandingdanshu()!=0)
  {
   for(int cnt=OrdersTotal()-1;cnt>=0;cnt--)



      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
            if(oc)
              {
               PlaySound("ok.wav");
              }
            else{PlaySound("timeout.wav");Print("GetLastError=",error());}
           }
         else
           {
            if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
              {
               //   Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");

                 }
               else{PlaySound("timeout.wav");Print("GetLastError=",error());}
              }
           }
        }
      else
        {
         Print("订单选择失败");
        }
     }
  }
  }

  int xunhuandingdanshuMagic()
  {
int aa=0;
for(int cntt=OrdersTotal()-1;cntt>=0;cntt--)

  {
   if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES)==true)
     {
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
           {
            aa++;
           }
        }
     }
  }
if(aa==0)Print("全部平仓成功");else Print("当前货币对订单数 ",aa);
return(aa);
  }


*/
/////////////////////////////////////////////////////////////////
int xunhuandingdanshu()
  {
   int aa=0;
   for(int cntt=OrdersTotal()-1; cntt>=0; cntt--)

     {
      if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               aa++;
              }
           }
        }
     }
   if(aa==0)
      Print("全部平仓成功");
   else
      Print("当前货币对订单数 ",aa);
   return(aa);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int xunhuandingdanshuplus()
  {
   int aa=0;
   for(int cntt=OrdersTotal()-1; cntt>=0; cntt--)

     {
      if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
           {
            aa++;
           }
        }
     }
   if(aa==0)
      Print("全部平仓成功");
   else
      Print("货币对订单数 ",aa);
   return(aa);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getbuySL(double price,int bars) //price 当前的买价
  {
   double ATRSL;
   double LowSL;
   ATRSL=price-80*Point+(Ask-Bid); //ATRSL 当前的买价减去多少个点再加上点差，固定止损值，如果在一分钟五分钟 短周期图表上下单请修改成适合自己的止损值。
   LowSL=Low[iLowest(NULL,0,MODE_LOW,bars,0)]; //LowSL 当前图表时间周期下从最新的一个k线开始往后(也就是往左)数15根k线，取其中的最低点的价格作为止损值，也可以固定时间周期，修改NULL后面的数值0，15，60，240
//LowSL 如果想修改取最低值的参考K线范围，请修改倒数第二个数字，倒数第一个0就是从最新的k线开始，往左数到多少根k线结束。
//下面是做判断，根据不同的条件返回不同的止损值
   if((ATRSL<LowSL) && (ATRSL<=price))
     {
      return(ATRSL);  //如果市场处于震荡中，ATRSL<LowSL 直接取ATRSL 之前设定的固定止损值。
     }
   else
      if((ATRSL>LowSL) && (LowSL<=price))
        {
         return(LowSL-(Ask-Bid));  //如果处于单边市场中， ATRSL>LowSL 如果ATRSL预设的止损比较小，使用最频繁的就是这个 取LowSL的值再减个点差 作为止损值
        }
      else
         if((price<ATRSL) && (price<LowSL))
           {
            return(price-80*Point);  //当前点差过大，当前的买价小于预设的两个止损值，那就直接从当前买价price减去多少点作为新的止损值
           }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(price-200*Point);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getsellSL(double price,int bars) //price 当前的卖价
  {
   double ATRSL;
   double HighSL;
   ATRSL=price+80*Point-(Ask-Bid); //ATRSL 当前的卖价加上多少个点再加个点差，固定止损值，如果在一分钟五分钟 短周期图表上下单请修改成适合自己的止损值。
   HighSL=High[iHighest(NULL,0,MODE_HIGH,bars,0)]; //HighSL 当前图表时间周期下从最新的一个k线开始往后(也就是往左)数15根k线，取其中的最高点的价格作为止损值，也可以固定时间周期，修改NULL后面的数值0，15，60，240
//HighSL 如果想修改取最高值的参考K线范围，请修改倒数第二个数字，倒数第一个0就是从最新的k线开始，往左数到多少根k线结束。
   if((ATRSL>HighSL) && (ATRSL>=price))
     {
      return(ATRSL);  //如果市场处于震荡中，ATRSL>HighSL 直接取ATRSL 之前设定的固定止损值。
     }
   else
      if((ATRSL<HighSL) && (HighSL>=price))
        {
         return(HighSL+Ask-Bid+5*Point);  //如果处于单边市场中， ATRSL<HighSL 如果ATRSL预设的止损比较小，使用最频繁的就是这个 取HighSL的值再加个点差 作为止损值
        }
      else
         if((price>ATRSL) && (price>HighSL))
           {
            return(price+80*Point);  //当前点差过大，当前的卖价大于预设的两个止损值，那就直接从当前卖价price加上多少点作为新的止损值
           }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(price+200*Point);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HoldingOrderbuyAvgPrice()//多单平均价
  {
   double Tmp=0;
   double TotalLots=0;
   for(int i=OrdersTotal()-1; i>=0; i--)












     {
      bool os=OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true;



      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
        {
         Tmp+=OrderOpenPrice()*OrderLots();
         TotalLots+=OrderLots();
        }
     }
   if(TotalLots==0)
      return(0);
   else
      return(Tmp/TotalLots);
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HoldingOrdersellAvgPrice()//空单平均价
  {
   double Tmp=0;
   double TotalLots=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool os=OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true;



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
        {
         Tmp+=OrderOpenPrice()*OrderLots();
         TotalLots+=OrderLots();
        }
     }
   if(TotalLots==0)
      return(0);
   else
      return(Tmp/TotalLots);
  }





















/* fanxiangsuodan
只能在只有单向订单情况下使用，如果有多空单，可能会进入死循环一直下单，切记！！！
如果不慎进入死循环一直开单，请立即关闭MT4上面的 自动交易 按钮，
原理：
按时间排序，从最早的一单开始依次判断订单类型，然后开反向的同手数订单，直到多空手数相等，
由于只是简单的从最早的一单开始对订单进行判断并处理，如果有多空单时，尤其是每单不同手数的
多空单，造成多空总手数一直不相等而进入死循环一直下单，最好的使用方法是在单向订单的情况下
使用，最好使用统一的下单手数，这样可以尽量避免进入死循环，而且可以解决部分同时有多空单的问题，
比如你下了很多 多单，行情不对，手动锁了几单之后，又想用这个脚本全锁，由于最早下的都是多单，
所以脚本运行之后一直在开空单，之前你手动锁的空单离现在最近，脚本运行不到你下空单的位置就因为
多空总手数相等而退出了。
*/
void fanxiangsuodan() //一键批量开反向单锁仓只有同向单时使用
  {
   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(buyLots()==sellLots())
        {
         Alert(Symbol(),"  已经处于锁仓状态 ");
         return;
        }



      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         double lots=OrderLots();
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
           {
            int b1=OrderSend(Symbol(),OP_SELL,lots,Bid,5,0,0,NULL,0,0,CLR_NONE);
            if(b1>0)
              {
               PlaySound("ok.wav");
               if(buyLots()==sellLots())
                 {
                  Print(Symbol(),"  buy单锁仓成功 ");
                  return;
                 }
              }
           }
         else
           {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
              {
               int s1=OrderSend(Symbol(),OP_BUY,lots,Ask,5,0,0,NULL,0,0,CLR_NONE);
               if(s1>0)
                 {
                  PlaySound("ok.wav");
                  if(buyLots()==sellLots())
                    {
                     Print(Symbol(),"  sell单锁仓成功 ");
                     return;
                    }
                 }
              }
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double buyLots()
  {
   double buylots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY)
              {
               buylots+=OrderLots();
              }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(buylots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double sellLots()
  {
   double selllots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_SELL)
              {
               selllots+=OrderLots();
              }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(selllots);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadanbuylimit()//智能buylimit单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double ask;
   ask=Low[iLowest(NULL,zhinengtimeframe,MODE_LOW,zhinenga,zhinengb)]+press();
   if(Ask<ask+zhinengguadanjuxianjia*Point)
      ask=Ask-zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiabuy!=0)
      ask+=zhinengguadanzengjiabuy*Point;
   for(int i=zhinengguadangeshu; i>0; i--)

     {
      if(zhinengguadanSL!=0)
         guadansl=ask-zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=ask+zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,zhinengguadanlots,ask,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask-=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }
///////////////////////////////////////////////////////////////////
void zhinengguadanbuystop()//智能buystop单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double ask;
   ask=High[iHighest(NULL,zhinengtimeframe,MODE_HIGH,zhinenga,zhinengb)]+press();
   if(Ask>ask-zhinengguadanjuxianjia*Point)
      ask=Ask+zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiabuystop!=0)
      ask+=zhinengguadanzengjiabuystop*Point;
   for(int i=zhinengguadangeshu; i>0; i--)
     {
      if(zhinengguadanSL!=0)
         guadansl=ask-zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=ask+zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYSTOP,zhinengguadanlots,ask,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask+=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadanselllimit()//智能selllimit单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double bid;
   bid=High[iHighest(NULL,zhinengtimeframe,MODE_HIGH,zhinenga,zhinengb)]+press();
   if(Bid>bid-zhinengguadanjuxianjia*Point)
      bid=Bid+zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiasell!=0)
      bid-=zhinengguadanzengjiasell*Point;
   for(int i=zhinengguadangeshu; i>0; i--)


     {
      if(zhinengguadanSL!=0)
         guadansl=bid+zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=bid-zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,zhinengguadanlots,bid,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid+=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadansellstop()//智能sellstop单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double bid;
   bid=Low[iLowest(NULL,zhinengtimeframe,MODE_LOW,zhinenga,zhinengb)]+press();
   if(Bid<bid+zhinengguadanjuxianjia*Point)
      bid=Bid-zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiasellstop!=0)
      bid-=zhinengguadanzengjiasellstop*Point;
   for(int i=zhinengguadangeshu; i>0; i--)



     {
      if(zhinengguadanSL!=0)
         guadansl=bid+zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=bid-zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLSTOP,zhinengguadanlots,bid,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid-=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }



/* 临时弃用
void guadanbuylimit()//委买单
  {
if(expirationM==0) expiration=0;
double guadansl=0,guadantp=0;
double ask,bid;
bid=Bid+guadanjuxianjia*Point;//距离现价的点数
ask=Ask-guadanjuxianjia*Point;
for(int i=guadangeshu;i>0;i--)



  {
   if(guadanSL!=0) guadansl=ask-guadanSL*Point;
   if(guadanTP!=0) guadantp=ask+guadanTP*Point;
   int ticket=OrderSend(Symbol(),OP_BUYLIMIT,guadanlots,ask,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
   if(ticket>0)
     {
      PlaySound("ok.wav");
      ask-=guadanjianju*Point;
     }
   else
      PlaySound("timeout.wav");
  }
  }
void guadanselllimit()//委卖单
  {
if(expirationM==0) expiration=0;
double guadansl=0,guadantp=0;
double ask,bid;
bid=Bid+guadanjuxianjia*Point;//距离现价的点数
ask=Ask-guadanjuxianjia*Point;
for(int i=guadangeshu;i>0;i--)
  {
   if(guadanSL!=0) guadansl=bid+guadanSL*Point;
   if(guadanTP!=0) guadantp=bid-guadanTP*Point;
   int ticket=OrderSend(Symbol(),OP_SELLLIMIT,guadanlots,bid,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
   if(ticket>0)
     {
      PlaySound("ok.wav");
      bid+=guadanjianju*Point;
     }
   else
      PlaySound("timeout.wav");
  }
  }
void guadanbuystop()//突破追买单
  {
if(expirationM==0) expiration=0;
double guadansl=0,guadantp=0;
double ask,bid;
bid=Bid+guadanjuxianjia*Point;//距离现价的点数
ask=Ask+guadanjuxianjia*Point;
for(int i=guadangeshu;i>0;i--)
  {
   if(guadanSL!=0) guadansl=ask-guadanSL*Point;
   if(guadanTP!=0) guadantp=ask+guadanTP*Point;
   int ticket=OrderSend(Symbol(),OP_BUYSTOP,guadanlots,ask,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
   if(ticket>0)
     {
      PlaySound("ok.wav");
      ask+=guadanjianju*Point;
     }
   else
      PlaySound("timeout.wav");
  }
  }
void guadansellstop()//突破追卖单
  {
if(expirationM==0) expiration=0;
double guadansl=0,guadantp=0;
double ask,bid;
bid=Bid-guadanjuxianjia*Point;//距离现价的点数
ask=Ask-guadanjuxianjia*Point;
for(int i=guadangeshu;i>0;i--)
  {
   if(guadanSL!=0) guadansl=bid+guadanSL*Point;
   if(guadanTP!=0) guadantp=bid-guadanTP*Point;
   int ticket=OrderSend(Symbol(),OP_SELLSTOP,guadanlots,bid,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
   if(ticket>0)
     {
      PlaySound("ok.wav");
      bid-=guadanjianju*Point;
     }
   else
      PlaySound("timeout.wav");
  }
  }
  */
void pingguadan()//批量平挂单
  {
//---
   int tick[1000]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }



   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
                         {
                          if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                            {pingFlag=1;Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
                          }
                     if(OrderSymbol()==Symbol() && cmd==OP_SELL)
                         {
                          if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                             {pingFlag=1;Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
                          }
             */
            if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
              {
               if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                 {pingFlag=1; Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
              }
            else
               if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                 {
                  if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                    {pingFlag=1; Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                 }
               else
                  if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                    {
                     if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                       {pingFlag=1; Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                    }
                  else
                     if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                       {
                        if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                          {pingFlag=1; Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                       }
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平挂单成功"); PlaySound("ok.wav");}
   else
     {Print("平仓失败，再来一次"); PlaySound("timeout.wav");}
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingcang()//一键平仓
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=5;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }
   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingcangMagic(int Magic)//一键平仓
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=5;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }
   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY && OrderMagicNumber()==Magic) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            if(OrderSymbol()==Symbol() && cmd==OP_SELL && OrderMagicNumber()==Magic)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Print("平仓失败，再来一次"); PlaySound("timeout.wav");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingbuydan()
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }



   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            /*            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
                          {
                           if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                             {pingFlag=1;Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
                          }

                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }

//+------------------------------------------------------------------+
void yijianpingselldan()
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)


     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }
   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)



        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
                          {
                           if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                             {pingFlag=1;Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
                          }*/
            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }
//+------------------------------------------------------------------+
void yijianfanshou()//一键反手
  {
   if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()>0)
     {
      Print("当前订单方向不统一 无法一键反手开仓");
      comment("当前订单方向不统一 无法一键反手开仓");
     }
   else
     {
      Print("一键反手开仓执行 当前订单平仓处理中");
      comment("一键反手开仓执行 当前订单平仓处理中");
      if(CGetbuyLots()>0.0 &&CGetsellLots()==0.0)
        {
         yijianfanshouselllots=CGetbuyLots();
         xunhuanquanpingcang();
         int keysell=OrderSend(Symbol(),OP_SELL,yijianfanshouselllots,Bid,keyslippage,0,0,NULL,0,0);
         if(keysell>0)
           {
            PlaySound("ok.wav");
            Print("一键反手开仓成功");
            comment("一键反手开仓成功");
            yijianfanshouselllots=0.0;
            return;
           }
         else
           {
            PlaySound("timeout.wav");
           }
        }
      if(CGetbuyLots()==0.0 &&CGetsellLots()>0.0)
        {
         yijianfanshoubuylots=CGetsellLots();
         xunhuanquanpingcang();
         int keybuy=OrderSend(Symbol(),OP_BUY,yijianfanshoubuylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
           {
            PlaySound("ok.wav");
            Print("一键反手开仓成功");
            comment("一键反手开仓成功");
            yijianfanshoubuylots=0.0;
            return;
           }
         else
           {
            PlaySound("timeout.wav");
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void suocang()//一键锁仓
  {
   if(CGetbuyLots()==CGetsellLots())
     {
      Alert(Symbol()," 已经处于锁仓状态 或 空仓");
      return;
     }
   else
     {
      if(CGetbuyLots()>CGetsellLots())
         CLockOrder(OP_SELL);//If buy order lots>sell lots,send sell order to lock.如果多单大于空单，开空单锁仓
      if(CGetbuyLots()<CGetsellLots())
         CLockOrder(OP_BUY);//If buy order lots<sell lots,send buy order to lock.如果多单小于空单，开多单锁仓
     }
  }
//+----------------------------锁仓程序(Lock Order)-------------------+
void CLockOrder(int m_Ordertype)
  {

   if(m_Ordertype==OP_BUY)
     {
      //if(OrderSend(Symbol(),OP_BUY,CGetsellLots()-CGetbuyLots(),Ask,5,0,0,NULL,0,0))
      int keybuy=OrderSend(Symbol(),OP_BUY,CGetsellLots()-CGetbuyLots(),Ask,5,0,0,NULL,0,0);
      if(keybuy>0)
        {
         PlaySound("ok.wav");
         Print(Symbol()," 锁仓成功");
         comment4(" 锁仓成功");
         if(menu[29])
           {
            SetLevel("Buy Line",Bid-menu29buypianyi*Point,Red,"锁仓成功后 再回撤 平掉原来错误的Sell仓位");
            buylineOnTimer=Bid;
            monianjian(49);
            monianjian(38);
            monianjian(25);
            Print("锁仓成功后 再回撤 平掉原来错误的Sell仓位启动");
            comment5("锁仓成功后 再回撤 平掉原来错误的Sell仓位启动");
            menu[29]=false;
           }
        }
      else
        {
         PlaySound("timeout.wav");
         Print("GetLastError=",error());
        }
     }

   if(m_Ordertype==OP_SELL)//rrr
     {
      // if(OrderSend(Symbol(),OP_SELL,CGetbuyLots()-CGetsellLots(),Bid,5,0,0,NULL,0,0))
      int keysell=OrderSend(Symbol(),OP_SELL,CGetbuyLots()-CGetsellLots(),Bid,5,0,0,NULL,0,0);
      if(keysell>0)
        {
         PlaySound("ok.wav");
         Print(Symbol()," 锁仓成功");
         comment4(" 锁仓成功");
         if(menu[29])
           {
            SetLevel("Sell Line",Ask+menu29sellpianyi*Point,clrForestGreen,"锁仓成功后 再回撤 平掉原来错误的Buy仓位");
            selllineOnTimer=Bid;
            monianjian(48);
            monianjian(38);
            monianjian(25);
            Print("锁仓成功后 再回撤 平掉原来错误的Buy仓位 启动");
            comment5("锁仓成功后 再回撤 平掉原来错误的Buy仓位 启动");
            menu[29]=false;
           }
        }
      else
        {
         PlaySound("timeout.wav");
         Print("GetLastError=",error());
        }
     }
// return(0);
  }

//+--------------计算buy下单量Calculate Buy Order Lots----------------+
double CGetbuyLots()
  {
   double m_buylots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY)
              {
               m_buylots+=OrderLots();
              }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(m_buylots);
  }
//+--------------------------------------------------------------------+
//+--------------计算sell下单量Calculate Sell Order Lots---------------+
double CGetsellLots()
  {
   double m_selllots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_SELL)
              {
               m_selllots+=OrderLots();
              }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(m_selllots);
  }
//+--------------------------------------------------------------------+
int GetHoldingbuyOrdersCount()//计算多单个数
  {
   int buyCount=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
           {
            buyCount+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(buyCount);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingsellOrdersCount()//计算空单个数
  {
   int sellCount=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
           {
            sellCount+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(sellCount);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingdingdanguadanOrdersCount()//计算定单及挂单总个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
        {
         geshu+=1;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanOrdersCount()//计算挂单个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
        {
         geshu+=1;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanbuylimitOrdersCount()//计算挂单buylimit个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanbuystopOrdersCount()//计算挂单buystop个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
           {
            geshu+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanselllimitOrdersCount()//计算挂单selllimit个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
           {
            geshu+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadansellstopOrdersCount()//计算挂单sellstop个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
           {
            geshu+=1;
           }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(geshu);
  }

/*
void zhinengsl()//批量智能设置止损
  {
double bid=0,ask=0;



if(SL==0.0)
  {
   bid=zhinenggetbuySL(Bid);
   ask=zhinenggetsellSL(Ask);
  }



else
  {
   if(SL<Bid)
     {
      bid=SL;
      ask=zhinenggetsellSL(Ask);
     }
   else
     {
      ask=SL;
      bid=zhinenggetbuySL(Bid);
     }
  }
for(int  i=0;i<OrdersTotal();i++)



  {
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
        {
         bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),bid+press(),OrderTakeProfit(),0);
         bid-=c*Point;
        }
   if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
     {
      bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),ask+press(),OrderTakeProfit(),0);
      ask+=c*Point;
     }
  }
PlaySound("ok.wav");
  }



double zhinenggetbuySL(double price)
  {
double ATRSL;
double LowSL;
ATRSL=price-(e+d)*Point;
LowSL=Low[iLowest(NULL,timeframe,MODE_LOW,a,b)];
if((ATRSL<LowSL) && (ATRSL<=price)) {return(ATRSL);}
else if((ATRSL>LowSL) &&(LowSL<=price)) {return(LowSL-(Ask-Bid)-d*Point);}
else if((price<ATRSL) && (price<LowSL)) {return(price-e*10*Point);}
return(price-300*Point);
  }



double zhinenggetsellSL(double price)
  {
double ATRSL;
double HighSL;
ATRSL=price+(e+d)*Point;
HighSL=High[iHighest(NULL,timeframe,MODE_HIGH,a,b)];
if((ATRSL>HighSL) && (ATRSL>=price)) {return(ATRSL);}
else if((ATRSL<HighSL) && (HighSL>=price)) {return(HighSL+(Ask-Bid)+d*Point);}
else if((price>ATRSL) && (price>HighSL)) {return(price+e*10*Point);}
return(price+300*Point);
  }



void zhinengtp()//批量智能设置止盈
  {
double bid=0,ask=0;



if(TP==0.0)
  {
   bid=zhinenggetbuyTP(Ask);
   ask=zhinenggetsellTP(Bid);
  }
else
  {
   if(TP>Bid)
     {
      ask=TP;
      bid=zhinenggetbuyTP(Ask);
     }
   else
     {
      bid=TP;
      ask=zhinenggetsellTP(Bid);
     }
  }
for(int  i=0;i<OrdersTotal();i++)
  {
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
        {
         bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask+press(),0);
         ask+=c*Point;
        }
   if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
     {
      bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid+press(),0);
      bid-=c*Point;
     }
  }
PlaySound("ok.wav");
  }



double zhinenggetbuyTP(double price)
  {
double ATRSL;
double LowSL;
ATRSL=price-(e+d)*Point;
LowSL=Low[iLowest(NULL,timeframe,MODE_LOW,a,b)];
if((ATRSL<LowSL) && (ATRSL<=price)) {return(ATRSL);}
else if((ATRSL>LowSL) &&(LowSL<=price)) {return(LowSL+(Ask-Bid)-d*Point);}
else if((price<ATRSL) && (price<LowSL)) {return(price-e*10*Point);}
return(price-300*Point);
  }



double zhinenggetsellTP(double price)
  {
double ATRSL;
double HighSL;
ATRSL=price+(e+d)*Point;
HighSL=High[iHighest(NULL,timeframe,MODE_HIGH,a,b)];
if((ATRSL>HighSL) && (ATRSL>=price)) {return(ATRSL);}
else if((ATRSL<HighSL) && (HighSL>=price)) {return(HighSL-(Ask-Bid)+d*Point);}
else if((price>ATRSL) && (price>HighSL)) {return(price+e*10*Point);}
return(price+300*Point);
  }

//| 本脚本参考了 批量设置止盈止损的脚本.mq4 感谢原作者 boolapi
//|   xyz  2016.07.09 xyz0217@live.cn

*/
void piliangsltp()//批量修改止盈止损点数或直接输入价位的脚本
  {
   int iTp=TargetProfit,iSl=StopLoss;
   bool bOrderModify;
   double dTargetProfit,cStopLoss;
   if(Digits==3 || Digits==5)
     {
      iTp*=10;
      iSl*=10;
     }

   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;



      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
        {
         if(StopLoss==0 && TargetProfit==0 && FixedStopLoss==0.0 && FixedTargetProfit==0.0)
           {
            dTargetProfit=0;
            cStopLoss=0;
           }
         else
           {
            if(FixedTargetProfit!=0.0)
               dTargetProfit=FixedTargetProfit;
            else
              {
               if(iTp==0)
                  dTargetProfit=OrderTakeProfit();
               else
                  dTargetProfit=OrderOpenPrice()+Point*iTp;
              }
            if(FixedStopLoss!=0.0)
               cStopLoss=FixedStopLoss;
            else
              {
               if(iSl==0)
                  cStopLoss=OrderStopLoss();
               else
                  cStopLoss=OrderOpenPrice()-Point*iSl;
              }
           }
         bOrderModify=OrderModify(OrderTicket(),
                                  OrderOpenPrice(),
                                  cStopLoss,
                                  dTargetProfit,
                                  0);
         if(GetLastError()==4109)
           {
            MessageBox("请在\"工具\"->\"选项\"->\"EA交易\"里勾选\"启用EA交易系统\"","设置止盈止损",0);
            return;
           }
        }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
        {
         if(StopLoss==0 && TargetProfit==0 && FixedStopLoss==0.0 && FixedTargetProfit==0.0)
           {
            dTargetProfit=0;
            cStopLoss=0;
           }
         else
           {
            if(FixedTargetProfit!=0.0)
               dTargetProfit=FixedTargetProfit;
            else
              {
               if(iTp==0)
                  dTargetProfit=OrderTakeProfit();
               else
                  dTargetProfit=OrderOpenPrice()-Point*iTp;
              }
            if(FixedStopLoss!=0.0)
               cStopLoss=FixedStopLoss;
            else
              {
               if(iSl==0)
                  cStopLoss=OrderStopLoss();
               else
                  cStopLoss=OrderOpenPrice()+Point*iSl;
              }
           }
         bOrderModify=OrderModify(OrderTicket(),
                                  OrderOpenPrice(),
                                  cStopLoss,
                                  dTargetProfit,
                                  0);
         if(!bOrderModify)
            if(GetLastError()==4109)
              {
               MessageBox("请在\"工具\"->\"选项\"->\"EA交易\"里勾选\"启用EA交易系统\"","设置止盈止损",0);
               return;
              }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangTPdianshu(int dianshu)//
  {
   if(bkey)
     {
      Print("多单批量移动止盈到均价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("多单批量移动止盈到均价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止盈到均价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("空单批量移动止盈到均价的%G个基点上 处理中 . . .",dianshu));
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   double baobenbuyTP=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+dianshu*Point;
   double baobensellTP=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobenbuyTP,0);
            baobenbuyTP+=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobensellTP,0);
            baobensellTP-=piliangtpjianju*Point;
           }
        }
     }
   PlaySound("ok.wav");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangSLdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止损到均价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("多单批量移动止损到均价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止损到均价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("空单批量移动止损到均价的%G个基点上 处理中 . . .",dianshu));
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   double baobenbuySL=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-dianshu*Point;
   double baobensellSL=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobenbuySL,OrderTakeProfit(),0);
            baobenbuySL-=piliangsljianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobensellSL,OrderTakeProfit(),0);
            baobensellSL+=piliangsljianju*Point;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangTPnowdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止盈到现价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("多单批量移动止盈到现价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止盈到现价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("空单批量移动止盈到现价的%G个基点上 处理中 . . .",dianshu));
     }
   double bid=Bid+dianshu*Point;
   double ask=Ask-dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid,0);
            bid+=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask,0);
            ask-=piliangtpjianju*Point;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangSLnowdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止损到现价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("多单批量移动止损到现价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止损到现价的",dianshu,"个基点上 处理中 . . .");
      comment1(StringFormat("空单批量移动止损到现价的%G个基点上 处理中 . . .",dianshu));
     }
   double bid=Bid-dianshu*Point;
   double ask=Ask+dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),bid,OrderTakeProfit(),0);
            bid-=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),ask,OrderTakeProfit(),0);
            ask+=piliangtpjianju*Point;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment(string str)//订单信息显示在图表
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"zi",OBJPROP_XDISTANCE,dingdanxianshiX1);
      ObjectSetInteger(0,"zi",OBJPROP_YDISTANCE,dingdanxianshiY1);
      ObjectSetText("zi",str,16,"黑体",dingdanxianshicolor);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment1(string str)//订单信息显示在图表副本1
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi1",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"zi1",OBJPROP_XDISTANCE,dingdanxianshiX2);
      ObjectSetInteger(0,"zi1",OBJPROP_YDISTANCE,dingdanxianshiY2);
      ObjectSetText("zi1",str,16,"黑体",dingdanxianshicolor);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment2(string str)//订单信息显示在图表副本2
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi2",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"zi2",OBJPROP_XDISTANCE,dingdanxianshiX3);
      ObjectSetInteger(0,"zi2",OBJPROP_YDISTANCE,dingdanxianshiY3);
      ObjectSetText("zi2",str,16,"黑体",dingdanxianshicolor);
     }
  }

//+------------------------------------------------------------------+
void comment3(string str)//订单信息显示在图表副本3
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi3",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi3",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,"zi3",OBJPROP_XDISTANCE,dingdanxianshiX4);
      ObjectSetInteger(0,"zi3",OBJPROP_YDISTANCE,dingdanxianshiY4);
      ObjectSetText("zi3",str,16,"黑体",dingdanxianshicolor);
     }
  }
//+------------------------------------------------------------------+
void comment4(string str)//订单信息显示在图表副本4
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi4",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi4",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,"zi4",OBJPROP_XDISTANCE,dingdanxianshiX5);
      ObjectSetInteger(0,"zi4",OBJPROP_YDISTANCE,dingdanxianshiY5);
      ObjectSetText("zi4",str,16,"黑体",dingdanxianshicolor);
     }
  }
//+------------------------------------------------------------------+
void comment5(string str)//订单信息显示在图表副本4
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi5",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi5",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,"zi5",OBJPROP_XDISTANCE,dingdanxianshiX6);
      ObjectSetInteger(0,"zi5",OBJPROP_YDISTANCE,dingdanxianshiY6);
      ObjectSetText("zi5",str,16,"黑体",dingdanxianshicolor);
     }
  }
//+------------------------------------------------------------------+
void commentR1(string str)//订单信息显示在图表 右边1
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"ziR1",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"ziR1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"ziR1",OBJPROP_XDISTANCE,80);
      ObjectSetInteger(0,"ziR1",OBJPROP_YDISTANCE,30);
      ObjectSetText("ziR1",str,12,"黑体",dingdanxianshicolor);
     }
  }
//+------------------------------------------------------------------+
void movesttp()//移动当前价的止盈止损
  {
   for(int cnt=0; cnt<OrdersTotal(); cnt++) //移动止盈止损
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
           {
            double stp=OrderStopLoss();
            double tpt=OrderTakeProfit();
            double OpenPrice=OrderOpenPrice();

            if(OriginalLot==0)
              {
               OriginalLot=OrderLots();
              }
            if(OrderType()==OP_BUY && onlybuy1)
              {
               if(stp==0 && tpt==0)
                  return;
               else
                 {
                  if(stp!=0 && onlystp)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp-moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }
                  if(stp!=0 && onlyup)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp+moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }

                  if(tpt!=0 && onlytpt)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt+Point*moveSTTP,0,CLR_NONE);
                    }
                  if(tpt!=0 && onlydown)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt-Point*moveSTTP,0,CLR_NONE);
                    }
                 }
              }
            if(OrderType()==OP_SELL && onlysell1)
              {
               if(stp==0 && tpt==0)
                  return;
               else
                 {
                  if(stp!=0 && onlystp)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp+moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }
                  if(stp!=0 && onlydown)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp-moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }

                  if(tpt!=0 && onlytpt)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt-Point*moveSTTP,0,CLR_NONE);
                    }
                  if(tpt!=0 && onlyup)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt+Point*moveSTTP,0,CLR_NONE);
                    }
                 }
              }
           }
        }
      else
        {
         OriginalLot=0;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetiLowest(int Timeframe,int bars,int beginbar)//获取最近多少根K线的最低点的价格
  {
   double LowSL=Low[iLowest(NULL,Timeframe,MODE_LOW,bars,beginbar)];
   return LowSL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetiHighest(int Timeframe,int bars,int beginbar)
  {
   double HighSL=High[iHighest(NULL,Timeframe,MODE_HIGH,bars,beginbar)];
   return HighSL;
  }
void PiliangSL(bool buytrue,double price,int jianju,int pianyiliang,int juxianjia,int dingdangeshu)//buytrue 如果是buy单就是true sell单就是false //pianyiliang 正数是正向偏移 负数是反向偏移

  {
   int jishu=0;
   bool om;
   double bid=0,ask=0;
//if(juxianjiadingshi03==false)
//  {
   if(buytrue && price+juxianjia*Point>Ask)
      price=Ask-juxianjia*Point;
   if(buytrue==false && price-juxianjia*Point<Bid)
      price=Bid+juxianjia*Point;
//   }
   ask=price-pianyiliang*Point;
   bid=price+pianyiliang*Point;
   for(int i=OrdersTotal()-1; i>=0; i--)

     {
      if(jishu>=dingdangeshu)
         break;



      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && buytrue)
           {
            om=OrderModify(OrderTicket(),OrderOpenPrice(),ask,OrderTakeProfit(),0);
            ask-=jianju*Point;
            jishu+=1;
           }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && buytrue==false)
        {
         om=OrderModify(OrderTicket(),OrderOpenPrice(),bid,OrderTakeProfit(),0);
         bid+=jianju*Point;
         jishu+=1;
        }
     }
   if(om)
      PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PiliangTP(bool buytrue,double price,int jianju,int pianyiliang,int juxianjia,int dingdangeshu)//buytrue 如果是buy单就是true sell单就是false
  {
   int jishu=0;
   bool om;
   double bid=0,ask=0;
//if(juxianjiadingshi03==false)
//  {
   if(buytrue && price-juxianjia*Point<Bid)
      price=Bid+juxianjia*Point;
   if(buytrue==false && price+juxianjia*Point>Ask)
      price=Ask-juxianjia*Point;
//   }
   ask=price-pianyiliang*Point;
   bid=price+pianyiliang*Point;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(jishu>=dingdangeshu)
         break;



      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && buytrue)
           {
            om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask,0);
            ask+=jianju*Point;
            jishu+=1;
           }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && buytrue==false)
        {
         om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid,0);
         bid-=jianju*Point;
         jishu+=1;
        }
     }
   if(om)
      PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Guadanbuylimit(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//委买单
  {
   double guadansl=0.0,guadantp=0.0;
   double sl1=sl,tp1=tp;
   if(Ask-juxianjia*Point<price)
      price=Ask-juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl==MathRound(sl))
        {
         if(sl==0.0)
           {
            guadansl=0;
           }
         else
           {
            guadansl=price-sl*Point;
           }
        }
      else
        {
         guadansl=sl1;
        }



      if(tp==MathRound(tp))
        {
         if(tp==0.0)
           {
            guadantp=0;
           }
         else
           {
            guadantp=price+tp*Point;
           }
        }
      else
        {
         guadantp=tp1;
        }
      // if(sl!=0) guadansl=price-sl*Point;
      // if(tp!=0) guadantp=price+tp*Point;
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price-=jianju*Point;
         sl1-=jianju*Point;
         tp1-=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Guadanselllimit(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//委卖单
  {
   double guadansl=0,guadantp=0;
   double sl1=sl,tp1=tp;
   if(Bid+juxianjia*Point>price)
      price=Bid+juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl==MathRound(sl))
        {
         if(sl==0.0)
           {
            guadansl=0;
           }
         else
           {
            guadansl=price+sl*Point;
           }
        }
      else
        {
         guadansl=sl1;
        }
      if(tp==MathRound(tp))
        {
         if(tp==0.0)
           {
            guadantp=0;
           }
         else
           {
            guadantp=price-tp*Point;
           }
        }
      else
        {
         guadantp=tp1;
        }
      //if(sl!=0) guadansl=price+sl*Point;
      //if(tp!=0) guadantp=price-tp*Point;
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price+=jianju*Point;
         sl1+=jianju*Point;
         tp1+=jianju*Point;
        }
      else
        {
         PlaySound("timeout.wav");
        }
     }
   PlaySound("ok.wav");
  }

//+------------------------------------------------------------------+
void Guadanbuystop(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//突破追买单
  {
   double guadansl=0,guadantp=0;
   if(Ask+juxianjia*Point>price)
      price=Ask+juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl!=0)
         guadansl=price-sl*Point;
      if(tp!=0)
         guadantp=price+tp*Point;
      int ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price+=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
void Guadansellstop(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//突破追卖单
  {
   double guadansl=0,guadantp=0;
   if(Bid-juxianjia*Point<price)
      price=Bid-juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl!=0)
         guadansl=price+sl*Point;
      if(tp!=0)
         guadantp=price-tp*Point;
      int ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);
      if(ticket>0)
        {
         price-=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Fibguadan(int guadantype,double lowprice,double highprice)//guadantype=0 buylimit guadantype=1 selllimit 斐波那契挂单
  {
   int sl=fibGuadansl;
   int geshu=fibGuadangeshu;
   double fib[7]= {-0.236,0,0.236,0.382,0.5,0.618,0.764};
   if(guadantype==0)
     {

      for(int i=6; i>=0; i--)



        {
         if(i==fibhulue6 || i==fibhulue5 || i==fibhulue4 || i==fibhulue3 || i==fibhulue2 || i==fibhulue1 || i==fibhulue0)
            continue;
         double price=NormalizeDouble(lowprice+(highprice-lowprice)*fib[i]-fibbuypianyiliang*Point,Digits);
         Print("i=",i," 百分比位",fib[i]*100,"%"," 挂单个数=",geshu,"  挂单价位=",price);
         if(price>Ask)
            continue;
         if(i==0 && fibGuadansl1!=0)
            sl=fibGuadansl1;
         //Print(fibGuadansl);
         Guadanbuylimit(fibGuadanlots,price,geshu,fibGuadanjianju,sl,fibGuadantp,fibGuadanjuxianjia);
         geshu++;
        }
     }

   if(guadantype==1)
     {
      for(int i=6; i>0; i--)
        {
         if(i==fibhulue6 || i==fibhulue5 || i==fibhulue4 || i==fibhulue3 || i==fibhulue2 || i==fibhulue1 || i==fibhulue0)
            continue;
         double price=NormalizeDouble(highprice-(highprice-lowprice)*fib[i]+fibsellpianyiliang*Point,Digits);
         Print("i=",i," 百分比位",fib[i]*100,"%"," 挂单个数=",geshu,"  挂单价位=",price);
         if(price<Bid)
            continue;
         if(i==0 && fibGuadansl1!=0)
            sl=fibGuadansl1;
         Guadanselllimit(fibGuadanlots,price,geshu,fibGuadanjianju,sl,fibGuadantp,fibGuadanjuxianjia);
         geshu++;
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Tenguadan(bool buyorsell,int weishu,double max)//整数位追单
  {
   if(max>MarketInfo(Symbol(),MODE_SPREAD))
      max=MarketInfo(Symbol(),MODE_SPREAD);
   double bid=StrToDouble(StringSubstr(DoubleToString(Bid,Digits),0,weishu));



   if(buyorsell)
     {
      double price=bid+(max+tenbuypianyiliang)*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后buylimit开始挂单价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(price+stoplevel*Point>Ask) Print("挂单离现价过近 在停止水平位挂单"); price=Ask-(stoplevel+3)*Point;

      Guadanbuylimit(tenGuadanlots,price,tenGuadangeshu,tenGuadanjianju,tenGuadansl,tenGuadantp,tenGuadanjuxianjia);
     }
   else
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("挂selllimit单计算整数位需要加的点数",digits);
      double price=bid+digits*Point-tensellpianyiliang*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后selllimit挂单价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(Bid+stoplevel*Point>price) Print("挂单离现价过近 在停止水平位挂单"); price=Bid+(stoplevel+3)*Point;
      Guadanselllimit(tenGuadanlots,price,tenGuadangeshu,tenGuadanjianju,tenGuadansl,tenGuadantp,tenGuadanjuxianjia);
     }
  }
//+------------------------------------------------------------------+
void Tensltp(bool buyorsell,bool SLtrue,int weishu,double max)//整数位追单
  {
   if(max>MarketInfo(Symbol(),MODE_SPREAD))
      max=MarketInfo(Symbol(),MODE_SPREAD);
   double bid=StrToDouble(StringSubstr(DoubleToString(Bid,Digits),0,weishu));

   if(buyorsell && SLtrue)
     {
      double price=bid-max*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后buy单SL价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(price+stoplevel*Point>Ask) Print("挂单离现价过近 在停止水平位挂单"); price=Ask-(stoplevel+3)*Point;
      PiliangSL(true,price,tensltpjianju,tensltppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }

   if(!buyorsell && !SLtrue)
     {
      double price=bid+max*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后sell单TP价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      PiliangTP(false,price,tensltpjianju,tentppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }

   if(buyorsell && !SLtrue)
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("计算整数位需要加的点数",digits);
      double price=bid+digits*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后buy单TP价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(Bid+stoplevel*Point>price) Print("挂单离现价过近 在停止水平位挂单"); price=Bid+(stoplevel+3)*Point;
      PiliangTP(true,price,tensltpjianju,tentppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);

     }

   if(!buyorsell && SLtrue)
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("计算整数位需要加的点数",digits);
      double price=bid+digits*Point+MarketInfo(Symbol(),MODE_SPREAD)*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后sell单SL价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      PiliangSL(false,price,tensltpjianju,tensltppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }

  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void buysellnowSL(bool buyorsell,double lots,int Timeframe,int bars,int beginbars,double pianyiliang)//带止损下单
  {
   if(buyorsell)
     {
      Print("市价buy ",lots,"手 带止损 取",bars,"根K线计算最高最低价 处理中 . . .");
      comment(StringFormat("市价buy %G手 带止损 取%G根K线计算最高最低价 处理中 . . .",lots,bars));

      if(testtradeSLSP)//是否支持直接带止损下单
        {
         double buysl=GetiLowest(Timeframe,bars,beginbars)-(MarketInfo(Symbol(),MODE_SPREAD)+pianyiliang)*Point;//rrr
         int buySLticket=OrderSend(Symbol(),OP_BUY,lots,Ask,keyslippage,buysl,0,NULL,0,0);
         if(buySLticket>0)
           {
            PlaySound("ok.wav");
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
            falsetimeCurrent=TimeCurrent();
           }
        }
      else
        {
         int buySLticket1=OrderSend(Symbol(),OP_BUY,lots,Ask,keyslippage,0,0,NULL,0,0);
         if(buySLticket1>0)
           {
            PlaySound("ok.wav");
            if(OrderSelect(buySLticket1,SELECT_BY_TICKET,MODE_TRADES)==true)
              {
               double buysl1=GetiLowest(Timeframe,bars,beginbars)-(MarketInfo(Symbol(),MODE_SPREAD)+pianyiliang)*Point;
               bool keybuy1=OrderModify(OrderTicket(),OrderOpenPrice(),buysl1,0,0);
              }
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
            falsetimeCurrent=TimeCurrent();
           }
        }
     }

   else
     {
      Print("市价sell ",lots,"手 带止损 取",bars,"根K线计算 处理中 . . .");
      comment(StringFormat("市价sell %G手 带止损 取%G根K线计算 处理中 . . .",lots,bars));
      if(testtradeSLSP)
        {
         double sl=GetiHighest(Timeframe,bars,beginbars)+(MarketInfo(Symbol(),MODE_SPREAD)*2+pianyiliang)*Point;
         int sellSLticket=OrderSend(Symbol(),OP_SELL,lots,Bid,keyslippage,sl,0,NULL,0,0);
         if(sellSLticket>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
            falsetimeCurrent=TimeCurrent();
           }
        }
      else
        {
         int sellSLticket=OrderSend(Symbol(),OP_SELL,lots,Bid,keyslippage,0,0,NULL,0,0);
         if(sellSLticket>0)
           {
            PlaySound("ok.wav");
            if(OrderSelect(sellSLticket,SELECT_BY_TICKET,MODE_TRADES)==true)
              {
               double sl=GetiHighest(Timeframe,bars,beginbars)+(MarketInfo(Symbol(),MODE_SPREAD)*2+pianyiliang)*Point;
               bool keysell=OrderModify(OrderTicket(),OrderOpenPrice(),sl,0,0);
              }
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",error());
            falsetimeCurrent=TimeCurrent();
           }
        }
     }
  }

//////////////////////////////////////////////////////////////////////////////////
string swaptype()//过夜库存费计算方法
  {
   int Num=(int)MarketInfo(Symbol(),MODE_SWAPTYPE);
   switch(Num)
     {
      case 0:
         return(" 隔夜库存费计算方法 - 点数计算");
      case 1:
         return(" 隔夜库存费计算方法 - 交易品种基础货币计算");
      case 2:
         return(" 隔夜库存费计算方法 - 通过利息");
      case 3:
         return(" 隔夜库存费计算方法 - 点数计算");
      default:
         return(" 隔夜库存费计算方法 Unknown");
     }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// === 获取订单ID ===
void GetOrdersID()
  {
   int i,n,t,o;
   bool all;
   n=OrdersTotal();
   ArrayResize(OrdersID,n);
   all=StringFind(管理持仓单号,"*")>=0;
   OpType= -1;
   for(i = 0,OrdersCount = 0; i<n; i++)
     {
      bool aa=OrderSelect(i,SELECT_BY_POS);
      if(Symbol()==OrderSymbol())
        {
         t=OrderTicket();
         if(all || (StringFind(管理持仓单号,DoubleToStr(t,0))>=0))
           {
            o=OrderType();
            if(o<2)
              {
               if((OpType>=0) && (o!=OpType))
                 {
                  OpType=-1;
                  break;
                 }
               else
                 {
                  OpType=o;
                  OrdersID[OrdersCount]=t;
                  OrdersCount++;
                 }
              }
           }
        }
     }



   if(OrdersCount==0)
     {
      ObjectDelete(TPObjName);
      ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      //------------
      建仓价=0;
      移动止损=0;

     }
  }
// === 寻找获利止损线 ===
void SearchObjName(int Type,bool GetTPObj=true,bool GetSLObj=true)
  {
   int    i,ObjType,iAbove,iBelow,iTP,iSL;
   double MinAbove,MaxBelow,y1,y2;
   string ObjName;

   MinAbove = 999999;
   MaxBelow = 0;
   iAbove   = -1;
   iBelow   = -1;
   for(i=0; i<ObjectsTotal(); i++)
     {
      ObjName = ObjectName(i);
      ObjType = ObjectType(ObjName);
      switch(ObjType)
        {
         case OBJ_TREND :
         case OBJ_TRENDBYANGLE :
            y1 = CalcLineValue(ObjName, 0, 1, ObjType);
            y2 = y1;
            break;
         case OBJ_CHANNEL :
            y1 = CalcLineValue(ObjName, 0, MODE_UPPER, ObjType);
            y2 = CalcLineValue(ObjName, 0, MODE_LOWER, ObjType);
            break;
         default :
            y1 = -1;
            y2 = -1;
        }



      if((y1>0) && (y1<Bid) && (y1>MaxBelow)) // 两条线都在当前价下方
        {
         MaxBelow = y1;
         iBelow   = i;
        }



      else
         if((y2>Bid) && (y2<MinAbove)) // 两条线都在当前价上方
           {
            MinAbove = y2;
            iAbove   = i;
           }



         else                // 两条线一上一下
           {
            if((y1>0) && (y1<MinAbove))
              {
               MinAbove = y1;
               iAbove   = i;
              }
            if(y2>MaxBelow)
              {
               MaxBelow = y2;
               iBelow   = i;
              }
           }
     }



   switch(Type)
     {
      case OP_BUY :
         iTP = iAbove;
         iSL = iBelow;
         break;
      case OP_SELL :
         iTP = iBelow;
         iSL = iAbove;
         break;
      default :
         iTP = -1;
         iSL = -1;
     }



   if(GetTPObj)
     {
      if(iTP>=0)
         TPObjName=ObjectName(iTP);
     }



   if(GetSLObj)
     {
      if(iSL>=0)
         SLObjName=ObjectName(iSL);
     }
  }



// === 计算获利价和止损价 ===
void CalcPrice(double &TPPrice,double &SLPrice)
  {

//制定方式初始化定义。。。。自己加条件修改                       //  |
   double BL1,BL2;                                              //  |
   BL1=NormalizeDouble(iCustom(NULL,0,"Bands",bandsA,bandsB,bandsC,1,0),Digits);                       //  |
   BL2=NormalizeDouble(iCustom(NULL,0,"Bands",bandsA,bandsB,bandsC,2,0),Digits);
//Print(BL1," ",BL2);
// 获利价
   switch(获利方式1制定2趋势线0无获利平仓)
     {
      case 1 :

         //制定1方式获利定义。。。。自己加条件修改等号后面的               //  |
         if(OrderType()==OP_SELL)
            TPPrice=BL2+MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point+bandsTPpianyi*Point;
         if(OrderType()==OP_BUY)
            TPPrice=BL1-MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point-bandsTPpianyi*Point;                                        //  |

         break;
      case 2 :
         TPPrice=CalcLineValue(TPObjName,0,1+OpType);
         break;
      default :
         TPPrice=-1;
     }



// 止损价
   switch(止损方式1制定2趋势线3移动止损0无止损)
     {
      case 1 :

         //制定1方式止损定义。。。。自己加条件修改等号后面的               //  |
         if(OrderType()==OP_SELL)
            SLPrice=BL1+MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point+bandsSLpianyi*Point;
         if(OrderType()==OP_BUY)
            SLPrice=BL2-MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point-bandsSLpianyi*Point;
         //  |

         break;
      case 2 :
         SLPrice=CalcLineValue(SLObjName,0,2-OpType);
         break;
      //-------------------
      case 3 :
         SLPrice=移动止损;
         break;

      default :
         SLPrice=-1;
     }
  }






// === 计算直线在某个k线的值 ===
double CalcLineValue(string ObjName,int Shift,int ValueIndex=1,int ObjType=-1)
  {
   double y1,y2,delta,ret;
   int    i;

   if((ObjType<0) && (StringLen(ObjName)>0))
      ObjType=ObjectType(ObjName);



   switch(ObjType)
     {
      case OBJ_TREND :
      case OBJ_TRENDBYANGLE :
         ret=LineGetValueByShift(ObjName,Shift);
         break;
      case OBJ_CHANNEL :
         i=GetBarShift(Symbol(),0,ObjectGet(ObjName,OBJPROP_TIME3));
         delta=ObjectGet(ObjName,OBJPROP_PRICE3)-LineGetValueByShift(ObjName,i);
         y1 = LineGetValueByShift(ObjName, Shift);
         y2 = y1 + delta;
         if(ValueIndex==MODE_UPPER)
            ret=MathMax(y1,y2);
         else
            if(ValueIndex==MODE_LOWER)
               ret=MathMin(y1,y2);
            else
               ret=-1;
         break;
      default :
         ret=-1;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(ret);
  }






// === 显示获利止损价水平线 ===
void ShowTPSLLines(double TPPrice,double SLPrice)
  {
   if(TPPrice<0)
      ObjectDelete(TP_PRICE_LINE);



   else
     {
      if(FindObject(TP_PRICE_LINE)<0)
        {
         ObjectCreate(TP_PRICE_LINE,OBJ_HLINE,0,0,0);
         ObjectSet(TP_PRICE_LINE,OBJPROP_COLOR,获利价格示例线);
         ObjectSet(TP_PRICE_LINE,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(TP_PRICE_LINE,OBJPROP_WIDTH,1);
        }
      ObjectMove(TP_PRICE_LINE,0,Time[0],TPPrice);
     }

   if(SLPrice<0)
      ObjectDelete(SL_PRICE_LINE);



   else
     {
      if(FindObject(SL_PRICE_LINE)<0)
        {
         ObjectCreate(SL_PRICE_LINE,OBJ_HLINE,0,0,0);
         ObjectSet(SL_PRICE_LINE,OBJPROP_COLOR,止损价格示例线);
         ObjectSet(SL_PRICE_LINE,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(SL_PRICE_LINE,OBJPROP_WIDTH,1);
        }
      ObjectMove(SL_PRICE_LINE,0,Time[0],SLPrice);
     }
  }
// === 查找对象 ===
int FindObject(string Name)
  {
   if(StringLen(Name)<=0)
      return(-1);
   else
      return(ObjectFind(Name));
  }
// === 平仓 ===
void CloseOrder(int Ticket,int type)
  {
   double ClosePrice;
   string str[2]= {"TP","SL"};



   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(OrderType()==OP_BUY)
         ClosePrice=MarketInfo(Symbol(),MODE_BID);
      else
         ClosePrice=MarketInfo(Symbol(),MODE_ASK);
      if(OrderClose(Ticket,OrderLots(),ClosePrice,0))
         Print("Order #",Ticket," was closed successfully at ",str[type]," ",ClosePrice);
      else
         Print("Order #",Ticket," reached ",str[type]," ",ClosePrice,", but failed to close for error ",GetLastError());
     }
  }
// === 计算直线上的值 ===
double LineGetValueByShift(string ObjName,int Shift)
  {
   double i1,i2,i,y1,y2,y;
   i1 = GetBarShift(Symbol(), 0, ObjectGet(ObjName, OBJPROP_TIME1));
   i2 = GetBarShift(Symbol(), 0, ObjectGet(ObjName, OBJPROP_TIME2));
//Print("aaa=",ObjectGet(ObjName,OBJPROP_TIME3));
   y1 = ObjectGet(ObjName, OBJPROP_PRICE1);
   y2 = ObjectGet(ObjName, OBJPROP_PRICE2);



   if(i1<i2)
     {
      i  = i1;
      i1 = i2;
      i2 = i;
      y  = y1;
      y1 = y2;
      y2 = y;
     }
   if(Shift>i1)
      y=(y2-y1)/(i2-i1) *(Shift-i1)+y1;
   else
      y=ObjectGetValueByShift(ObjName,Shift);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(y);
  }
// === 取时间值的shift数 ===
int GetBarShift(string symbol,int atimeframe,double time)
  {
   datetime now;
   now=iTime(symbol,atimeframe,0);
   int now1=StrToInteger(IntegerToString(now,0));
   int time1=StrToInteger(DoubleToStr(time,0));
// Print("now2=",now2,"  ","now=",now,"time=",time,"time1=",time1);
   if(time1<now1+atimeframe*60)
      return(iBarShift(symbol, atimeframe, time1));



   else
     {
      if(atimeframe==0)
         atimeframe=Period();
      return((now1 - time1) / atimeframe / 60);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double press()//增加或减少偏移
  {
   double pianyi=(shangpress-xiapress)*presspianyi*Point;
   shangpress=0;
   xiapress=0;
   return(pianyi);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Huaxianguadan()//划线 挂单
  {
//Print("划线平仓开始");
///////////////////////////////////////////////////////////////////
   double TPPrice,SLPrice,tpPrice,slPrice;
   获利方式1制定2趋势线0无获利平仓=2;
   止损方式1制定2趋势线3移动止损0无止损=2;



   if(kkey && vkey)//直接划线设置止盈止损 多单止损
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      if(SLPrice>0 && TPPrice<0)
         PiliangSL(true,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);



      //if(TPPrice>0 && SLPrice<0)PiliangSL(true,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            PiliangSL(true,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
         if(slPrice<Bid)
            PiliangSL(true,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      vkey=false;
     }



   if(kkey && akey)//直接划线设置止盈止损 空单止损
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      if(SLPrice>0 && TPPrice<0)
         PiliangSL(false,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);



      //if(TPPrice>0 && SLPrice<0)PiliangSL(false,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            PiliangSL(false,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
         if(slPrice>Bid)
            PiliangSL(false,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      akey=false;
     }



   if(okey && vkey)//直接划线设置止盈止损 多单止盈
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      //if(SLPrice>0 && TPPrice<0)PiliangTP(true,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice<0)
         PiliangTP(true,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            PiliangTP(true,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
         if(slPrice>Bid)
            PiliangTP(true,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      vkey=false;
     }



   if(okey && akey)//直接划线设置止盈止损 空单止盈
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      //if(SLPrice>0 && TPPrice<0)PiliangTP(false,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice<0)
         PiliangTP(false,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            PiliangTP(false,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
         if(slPrice<Bid)
            PiliangTP(false,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      akey=false;
     }
   if(okey && xkey)//直接划线挂单
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanbuylimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanbuylimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            Guadanbuylimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice<Bid)
            Guadanbuylimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      xkey=false;
     }



   if(kkey && xkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanselllimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanselllimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            Guadanselllimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice>Bid)
            Guadanselllimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      xkey=false;
     }



   if(pkey && xkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanbuystop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanbuystop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            Guadanbuystop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice>Bid)
            Guadanbuystop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      pkey=false;
      xkey=false;
     }



   if(lkey && xkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadansellstop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadansellstop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            Guadansellstop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice<Bid)
            Guadansellstop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      xkey=false;
     }
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID



   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名
      CalcPrice(TPPrice,SLPrice);
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);



      if((SLPrice>0) &&
         ((OpType==OP_BUY) && (Bid<=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         Guadanbuylimit(huaxianguadanlots,Ask-(stoplevel+5)*Point,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianguadan=false;
         Print("划线挂单模式关闭");
         comment1("划线挂单模式关闭");
        }



      if((SLPrice>0) &&
         //(((OpType== OP_BUY) &&(Bid>= TPPrice))||
         ((OpType==OP_SELL) && (Bid>=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         Guadanselllimit(huaxianguadanlots,Bid+(stoplevel+5)*Point,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianguadan=false;
         Print("划线挂单模式关闭");
         comment1("划线挂单模式关闭");
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Huaxiankaicang()//划线直接开仓
  {
   获利方式1制定2趋势线0无获利平仓=2;
   止损方式1制定2趋势线3移动止损0无止损=2;
// Print("划线平仓开始");
   double TPPrice,SLPrice;
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID



   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名
      CalcPrice(TPPrice,SLPrice);
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);



      if((SLPrice>0) &&
         ((OpType==OP_BUY) && (Bid<=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         for(int i=huaxiankaicanggeshu; i>0; i--)
           {
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,MarketInfo(Symbol(),MODE_ASK),keyslippage,0,0,NULL,0,0);
            Print(TimeCurrent());
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
            Sleep(huaxiankaicangtime);
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxiankaicang=false;
         Print("触及划线直接开仓模式关闭");
         comment1("触及划线直接开仓模式关闭");
        }



      if((SLPrice>0) &&
         //(((OpType== OP_BUY) &&(Bid>= TPPrice))||
         ((OpType==OP_SELL) && (Bid>=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         for(int i=huaxiankaicanggeshu; i>0; i--)
           {
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,MarketInfo(Symbol(),MODE_BID),keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",error());
              }
            Print(TimeCurrent());
            Sleep(huaxiankaicangtime);
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxiankaicang=false;
         Print("触及划线直接开仓模式关闭");
         comment1("触及划线直接开仓模式关闭");
        }
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HuaxianSwitch()////划线平仓代码 划线锁仓 布林带平仓
  {
//Print("HuaxianSwitch运行");
   double TPPrice,SLPrice;
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID
   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名



      //--------------
      if(止损方式1制定2趋势线3移动止损0无止损==3)
        {
         建仓价=OrderOpenPrice();
         if(OrderType()==OP_BUY)
            //如果(订单类型=多单)
           {
            if(移动止损<建仓价-Point*止损)
               移动止损=建仓价-Point*止损;
            if(Bid>建仓价+首次保护盈利止损*Point && 移动止损<建仓价+保护盈利*Point)
               移动止损=建仓价+保护盈利*Point;
            if(Bid>建仓价+移动步长*1*Point && 移动止损<建仓价+保护盈利*Point)
               移动止损=建仓价+保护盈利*Point;
            if(Bid>建仓价+移动步长*2*Point && 移动止损<建仓价+移动步长*1*Point)
               移动止损=建仓价+移动步长*1*Point;
            if(Bid>建仓价+移动步长*3*Point && 移动止损<建仓价+移动步长*2*Point)
               移动止损=建仓价+移动步长*2*Point;
            if(Bid>建仓价+移动步长*5*Point && 移动止损<建仓价+移动步长*3*Point)
               移动止损=建仓价+移动步长*3*Point;
            if(Bid>建仓价+移动步长*7*Point && 移动止损<建仓价+移动步长*4*Point)
               移动止损=建仓价+移动步长*4*Point;
           }

         if(OrderType()==OP_SELL)
            //如果 仓单类型=空单，则，
           {
            if(移动止损<建仓价+Point*止损)
               移动止损=建仓价+Point*止损;
            if(Ask<建仓价-首次保护盈利止损*Point && 移动止损>建仓价-保护盈利*Point-(Ask-Bid)*Point)
               移动止损=建仓价-保护盈利*Point-(Ask-Bid)*Point;
            if(Ask<建仓价-移动步长*1*Point && 移动止损>建仓价-保护盈利*Point-(Ask-Bid)*Point)
               移动止损=建仓价-保护盈利*Point-(Ask-Bid)*Point;
            if(Ask<建仓价-移动步长*2*Point && 移动止损>建仓价-移动步长*1*Point)
               移动止损=建仓价-移动步长*1*Point;
            if(Ask<建仓价-移动步长*3*Point && 移动止损>建仓价-移动步长*2*Point)
               移动止损=建仓价-移动步长*2*Point;
            if(Ask<建仓价-移动步长*5*Point && 移动止损>建仓价-移动步长*3*Point)
               移动止损=建仓价-移动步长*3*Point;
            if(Ask<建仓价-移动步长*7*Point && 移动止损>建仓价-移动步长*4*Point)
               移动止损=建仓价-移动步长*4*Point;
           }
        }
      //---------------
      CalcPrice(TPPrice,SLPrice);
      /*
               MesgText="止损：";
               if(SLPrice<0)
                  MesgText=MesgText+" __ ";
               else
                  MesgText=MesgText+DoubleToStr(SLPrice,Digits);
               MesgText=MesgText+"  ；止赢：";
               if(TPPrice<0)
                  MesgText=MesgText+" __ ";
               else
                  MesgText=MesgText+DoubleToStr(TPPrice,Digits);
               Comment(MesgText);
      */
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);
      if((SLPrice>0) &&
         (((OpType== OP_BUY) &&(Bid<= SLPrice))||
          ((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         if(huaxianShift)
           {
            suocang();
           }
         else
           {
            if(huaxianCtrl)
              {
               fanxiangsuodan();
              }
            else
              {
               xunhuanquanpingcang();
              }
           }

         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianSwitch=false;
         huaxianTimeSwitch=false;
         huaxianShift=false;
         huaxianCtrl=false;
         Print("触及划线直接平仓或反锁模式关闭");
         comment1("触及划线直接平仓或反锁模式关闭");
        }



      if((TPPrice>0) &&
         (((OpType== OP_BUY) &&(Bid>= TPPrice))||
          ((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         if(huaxianShift)
           {
            suocang();
           }
         else
           {
            if(huaxianCtrl)
              {
               fanxiangsuodan();
              }
            else
              {
               xunhuanquanpingcang();
              }
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianSwitch=false;
         huaxianTimeSwitch=false;
         huaxianShift=false;
         huaxianCtrl=false;
         Print("触及划线直接平仓或反锁模式关闭");
         comment1("触及划线直接平仓或反锁模式关闭");
        }
     }
  }
//+------------------------------------------------------------------+
void SetLevel(string text,double price,color col1,string TOOLTIP="")//划一条横线
  {
   string linename=text;
   if(ObjectFind(linename)!=0)
     {
      ObjectCreate(linename,OBJ_HLINE,0,Time[0],price);
      ObjectSet(linename,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(linename,OBJPROP_LEVELWIDTH,5);
      ObjectSet(linename,OBJPROP_COLOR,col1);
      ObjectSetString(0,linename,OBJPROP_TOOLTIP,TOOLTIP);
     }
   else
     {
      ObjectMove(linename,0,Time[0],price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrendLine(string name,datetime time1,double price1,datetime time2,double price2,color color1=Red,string TOOLTIP="",int WIDTH=1,bool RAY_RIGHT=false)//划一条趋势线
  {
   if(ObjectFind(0,name)==0)
     {
      ObjectDelete(0,name);
     }
   ObjectCreate(0,name,OBJ_TREND,0,time1,price1,time2,price2);
   ObjectSet(name,OBJPROP_BACK,false);
   ObjectSet(name,OBJPROP_WIDTH,WIDTH);
   ObjectSet(name,OBJPROP_RAY_RIGHT,RAY_RIGHT);
   ObjectSet(name,OBJPROP_COLOR,color1);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,TOOLTIP);

  }

//+------------------------------------------------------------------+
string error()//获取最后一次错误信息 输出中文错误信息
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
         myLastErrorStr = "运行报错:4059 测试模式中函数被禁用";
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
         //Print("错误号",myErrorNum,"没有找到对应的中文解释，请查询帮助文档");
         myLastErrorStr = IntegerToString(GetLastError()) + " 这个错误没有找到中文解释,请查阅帮助文档并补齐" ; //
         break;
     }
   Print(myLastErrorStr);
   return(myLastErrorStr);
  }
//////////////////////////////////////////////////////////////////////////////////////////
void monianjian(int sparam)//模拟按键 动作 转换成鼠标点击执行 模拟按键按下 执行按键 运行的代码 sparam是按下按键时输出的sparam值
  {
   string Sparam=IntegerToString(sparam);
   long a=999;
   double b=9999;
   OnChartEvent(CHARTEVENT_KEYDOWN,a,b,Sparam);
  }
///////////////////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+//鼠标 按钮 图形 相关 函数开始
//可移动按钮模块作者微信:13717465888QQ群:3210497如果借用部分内容请加此版权说明
void OnChartEvent2(const int id, const long &lparam, const double &dparam, const string &sparam)
  {

   if(id == CHARTEVENT_MOUSE_MOVE)//跟着鼠标的移动
     {
      //Comment("POINT: ",(int)lparam,",",(int)dparam,"\n",MouseState((uint)sparam));
      //Print("sparam=",sparam,"=lparam=",lparam," dparam=",dparam);
      //--- 准备变量
      int      x1     = (int)lparam;
      int      y1     = (int)dparam;
      datetime dt    = 0;
      double   price = 0;
      int      window = 0;

      //--- 依据日期/时间转换X和Y坐标
      if(ChartXYToTimePrice(0, x1, y1, window, dt, price))
        {
         if(ObjectFind(0,"TimeLine1")==0)
           {
            ObjectMove("TimeLine1",0,dt,0);
            ObjectSetString(0,"TimeLine1",OBJPROP_TOOLTIP,"本地时间 "+TimeToStr(dt+shijiancha,TIME_DATE | TIME_MINUTES));
           }
         //Print("移动中");
         // Print(dt);

         /* if(鼠标跟随)
            {
             水平线 = price;
             // ObjectSetString(0, pre + "0", OBJPROP_TEXT, DoubleToStr(price, Digits()));
             HLineCreate(menu[1], 水平线,"HL Line");
            }*/
         if(shubiaogensuiBuy)
           {
            HLineCreate(true, price,"Buy Line",Red);
           }
         if(shubiaogensuiSell)
           {
            HLineCreate(true, price,"Sell Line",ForestGreen);
           }
         if(shubiaogensuiSL)
           {
            HLineCreate(true, price,"SL Line",FireBrick);
           }

        }
      if(sparam == "1")//点鼠标左键 跳出
        {
         if(shubiaogensuiBuy || shubiaogensuiSell || shubiaogensuiSL)
           {
            if(ObjectFind(0,"Buy Line")==0)
              {
               buyline=NormalizeDouble(ObjectGet("Buy Line",1),Digits);   //定时更新横线的价格
               buylineOnTimer=Ask;
              }
            if(ObjectFind(0,"Sell Line")==0)
              {
               sellline=NormalizeDouble(ObjectGet("Sell Line",1),Digits);   //定时更新横线的价格
               selllineOnTimer=Bid;
              }
            if(ObjectFind(0,"SL Line")==0)
              {
               slline=NormalizeDouble(ObjectGet("SL Line",1),Digits);   //定时更新横线的价格
              }
           }
         shubiaogensuiBuy=false;
         shubiaogensuiSell=false;
         shubiaogensuiSL=false;
        }
      if(sparam == "2")//鼠标右键
        {
         ObjectDelete(0,"TimeLine1");
        }
      if(sparam == "9")//Ctrl+鼠标左键
        {
         if(ObjectFind(0,"TimeLine1")<0)
           {
            ObjectCreate(0,"TimeLine1",OBJ_VLINE,0,Time[200],0);
            ObjectSet("TimeLine1",OBJPROP_BACK,false);
            ObjectSet("TimeLine1",OBJPROP_WIDTH,1);
            ObjectSet("TimeLine1",OBJPROP_COLOR,clrCrimson);
            ObjectSetString(0,"TimeLine1",OBJPROP_TOOLTIP,"时间线");
           }
         else
           {
            ObjectDelete(0,"TimeLine1");
           }
        }
      if(sparam == "16")//鼠标中键控线 需要按住 滚轴移动一下
        {
         if(ObjectFind(0,"TimeLine1")<0)
           {
            ObjectCreate(0,"TimeLine1",OBJ_VLINE,0,Time[200],0);
            ObjectSet("TimeLine1",OBJPROP_BACK,false);
            ObjectSet("TimeLine1",OBJPROP_WIDTH,1);
            ObjectSet("TimeLine1",OBJPROP_COLOR,clrCrimson);
            ObjectSetString(0,"TimeLine1",OBJPROP_TOOLTIP,"时间线");
           }
        }
      /* if(menu[2] && sparam == "16")//鼠标中键控线
         {
          鼠标跟随 = true;
          menu[1] = true;
          if(menu[1])//设置颜色
             ObjectSetInteger(0, pre + IntegerToString(1), OBJPROP_BGCOLOR, COLOR_ENABLE);
          else
             ObjectSetInteger(0, pre + IntegerToString(1), OBJPROP_BGCOLOR, COLOR_DISABLE);
         }*/
     }

   if(id == CHARTEVENT_OBJECT_CLICK)//鼠标点击图表中 的对象  点击菜单后执行相应的代码  图表按钮相关代码开始 mmmm
     {
      //Print("检测到点击事件 sparam= ",sparam);
      ////////////////////////////////////////////////////////////////////////////////////常用菜单 相关 执行代码 按钮0 mmm1
      if(sparam == pre1 + IntegerToString(0))//按钮1
        {
         if(menu1[0])
           {
            ObjectsDeleteAll(0, pre8);
            menu1[0]=false;
            for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu1[i])
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x8=but_zhu_x+anjiu_W*缩放;
            but_y8=but_zhu_y;
            Draw_button8();//
            for(int i = 0; i < menu_zs8; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu8[i])
                 {
                  ObjectSetInteger(0, pre8 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre8 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre1 + IntegerToString(1))//按钮2
        {
         if(menu1[1])
           {
            ObjectsDeleteAll(0, pre12);
            menu1[1]=false;
            for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu1[i])
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x12=but_zhu_x+anjiu_W*缩放;
            but_y12=but_zhu_y;
            Draw_button12();//
            for(int i = 0; i < menu_zs12; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu12[i])
                 {
                  ObjectSetInteger(0, pre12 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre12 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre1 + IntegerToString(2))//按钮3
        {
         if(menu1[2])
           {
            ObjectsDeleteAll(0, pre13);
            menu1[2]=false;
            for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu1[i])
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x13=but_zhu_x+anjiu_W*缩放;
            but_y13=but_zhu_y;
            Draw_button13();//
            for(int i = 0; i < menu_zs13; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu13[i])
                 {
                  ObjectSetInteger(0, pre13 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre13 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre1 + IntegerToString(3))//按钮4
        {
         if(menu1[3])
           {
            ObjectsDeleteAll(0, pre14);
            menu1[3]=false;
            for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu1[i])
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x14=but_zhu_x+anjiu_W*缩放;
            but_y14=but_zhu_y;
            Draw_button14();//
            for(int i = 0; i < menu_zs14; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu14[i])
                 {
                  ObjectSetInteger(0, pre14 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre14 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre1 + IntegerToString(4))//按钮5
        {
         if(menu1[4])
           {
            ObjectsDeleteAll(0, pre15);
            menu1[4]=false;
            for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu1[i])
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x15=but_zhu_x+anjiu_W*缩放;
            but_y15=but_zhu_y;
            Draw_button15();//
            for(int i = 0; i < menu_zs15; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu15[i])
                 {
                  ObjectSetInteger(0, pre15 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre15 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre1 + IntegerToString(5))//按钮6
        {

        }
      if(sparam == pre1 + IntegerToString(6))//按钮7
        {

        }
      if(sparam == pre1 + IntegerToString(7))//按钮8
        {
         monianjian(8217);
         menu1[7]=true;
        }
      if(sparam == pre1 + IntegerToString(8))//按钮9
        {
         monianjian(8240);
         menu1[8]=true;
        }
      if(sparam == pre1 + IntegerToString(9))//按钮10
        {
         monianjian(8223);
         menu1[9]=true;
        }
      if(sparam == pre1 + IntegerToString(10))//按钮11
        {
         monianjian(8225);
         menu1[10]=true;
        }
      if(sparam == pre1 + IntegerToString(11))//按钮12
        {
         monianjian(42);
         monianjian(82);
         menu1[11]=true;
        }
      if(sparam == pre1 + IntegerToString(12))//按钮13
        {
         monianjian(15);
         monianjian(1);
         menu1[12]=true;
        }
      if(sparam == pre1 + IntegerToString(13))//按钮14
        {
         monianjian(42);
         monianjian(34);
         menu1[13]=true;
        }
      if(sparam == pre1 + IntegerToString(14))//按钮15 带止损下单
        {
         if(menu1[14])
           {
            if(bars0971==1 || ObjectFind(0,"zi1")<0)
              {
               menu1[14]=true;
               bars0971=bars097;
               shiftRtimeCurrent=TimeCurrent()-1000;
               Print("带止损开仓模式 关闭");
               comment1("带止损开仓模式 关闭");
              }
            else
              {
               bars0971--;
               Print("带止损开仓模式 启动 计算最近的 ",bars0971," 根K线设止损 重复按减少K线 ");
               comment1(StringFormat("带止损开仓模式 启动 计算最近的 %G 根K线设止损 重复按减少K线 ",bars0971));
               return;
              }
           }
         else
           {
            Print("带止损开仓模式 启动 计算最近的 ",bars0971," 根K线设止损 重复按减少K线 ");
            comment1(StringFormat("带止损开仓模式 启动 计算最近的 %G 根K线设止损 重复按减少K线 ",bars0971));
           }
        }
      if(sparam == pre1 + IntegerToString(15))//按钮16
        {
         monianjian(8212);
         menu1[15]=true;
        }
      if(sparam == pre1 + IntegerToString(16))//按钮17
        {
         monianjian(8230);
         menu1[16]=true;
        }
      if(sparam == pre1 + IntegerToString(17))//按钮18
        {

        }
      if(sparam == pre1 + IntegerToString(18))//按钮19
        {
         monianjian(15);
         monianjian(11);
         menu1[18]=true;
        }
      ////////////////////////////////////////////////////////////////////////////////////////// 按钮0 常用菜单 副图1 mmm11
      if(sparam == pre8 + IntegerToString(0))//按钮1
        {
         if(yinyang5mkaicang)
           {
            yinyang5mkaicang=false;
            Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 关闭");
            comment("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 关闭");
            menu8[0]=true;
           }
         else
           {
            yinyang5mkaicang=true;
            yinyang5mkaicanggeshu1=yinyang5mkaicanggeshu+(rightpress-leftpress);
            Print("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 开启 次数",yinyang5mkaicanggeshu1);
            comment(StringFormat("当前5分钟图表最近两根K线收盘时颜色相同开仓追单 开启 次数%G",yinyang5mkaicanggeshu1));
            kkey=false;
           }
        }
      if(sparam == pre8 + IntegerToString(1))//按钮2
        {
         if(yinyang5mkaicangshiftR)
           {
            yinyang5mkaicangshiftR=false;
            Print("5分钟出现两根相同颜色的K线启动横线模式追单 关闭");
            comment("5分钟出现两根相同颜色的K线启动横线模式追单 关闭");
            menu8[1]=true;
           }
         else
           {
            yinyang5mkaicangshiftR=true;
            yinyang5mkaicanggeshu1=yinyang5mkaicanggeshu+(rightpress-leftpress);
            Print("5分钟出现两根相同颜色的K线启动横线模式追单 开启 次数",yinyang5mkaicanggeshu1);
            comment(StringFormat("5分钟出现两根相同颜色的K线启动横线模式追单 开启 次数%G",yinyang5mkaicanggeshu1));
           }
        }
      if(sparam == pre8 + IntegerToString(2))//按钮3
        {
         if(yinyang5mpingcang)
           {
            yinyang5mpingcang=false;
            Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓 关闭");
            comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓 关闭");
            menu8[2]=true;
           }
         else
           {
            yinyang5mpingcang=true;
            Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓 开启");
            comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(3))//按钮4
        {
         if(yinyang5mpingcangshiftR)
           {
            yinyang5mpingcangshiftR=false;
            Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 关闭");
            comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 关闭");
            menu8[3]=true;
           }
         else
           {
            yinyang5mpingcangshiftR=true;
            yinyang5mpingcangtime=TimeCurrent();
            Print("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 开启");
            comment("当前5分钟图表最近两根K线收盘时颜色相同时平仓后反手 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(4))//按钮5
        {
         if(yinyang5mpingcangctrlR)
           {
            yinyang5mpingcangctrlR=false;
            Print("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 关闭");
            comment("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 关闭");
            menu8[4]=true;
           }
         else
           {
            yinyang5mpingcangctrlR=true;
            yinyang5mpingcangtime=TimeCurrent();
            Print("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 开启");
            comment("最近5分钟第二第三根K线和最近收盘的一根K线颜色相反时平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(5))//按钮6
        {
         if(yinyang5mpingcangBuy1K2Kyin)
           {
            yinyang5mpingcangBuy1K2Kyin=false;
            Print("5分钟追多单时 连续出现两根阴线 直接平仓 关闭");
            comment("5分钟追多单时 连续出现两根阴线 直接平仓 关闭");
            menu8[5]=true;
           }
         else
           {
            yinyang5mpingcangBuy1K2Kyin=true;
            Print("5分钟追多单时 连续出现两根阴线 直接平仓 开启");
            comment("5分钟追多单时 连续出现两根阴线 直接平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(6))//按钮7
        {
         if(yinyang5mpingcangSell1K2Kyang)
           {
            yinyang5mpingcangSell1K2Kyang=false;
            Print("5分钟追空单时 连续出现两根阳线 直接平仓 关闭");
            comment("5分钟追空单时 连续出现两根阳线 直接平仓 关闭");
            menu8[6]=true;
           }
         else
           {
            yinyang5mpingcangSell1K2Kyang=true;
            Print("5分钟追空单时 连续出现两根阳线 直接平仓 开启");
            comment("5分钟追空单时 连续出现两根阳线 直接平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(7))//按钮8
        {
         if(yinyang5mpingcangBuy1K2K3Kyin)
           {
            yinyang5mpingcangBuy1K2K3Kyin=false;
            Print("5分钟追多单时 连续出现3根阴线 直接平仓 关闭");
            comment("5分钟追多单时 连续出现3根阴线 直接平仓 关闭");
            menu8[7]=true;
           }
         else
           {
            yinyang5mpingcangBuy1K2K3Kyin=true;
            Print("5分钟追多单时 连续出现3根阴线 直接平仓 开启");
            comment("5分钟追多单时 连续出现3根阴线 直接平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(8))//按钮9
        {
         if(yinyang5mpingcangSell1K2K3Kyang)
           {
            yinyang5mpingcangSell1K2K3Kyang=false;
            Print("5分钟追空单时 连续出现3根阴线 直接平仓 关闭");
            comment("5分钟追空单时 连续出现3根阴线 直接平仓 关闭");
            menu8[8]=true;
           }
         else
           {
            yinyang5mpingcangSell1K2K3Kyang=true;
            Print("5分钟追空单时 连续出现3根阴线 直接平仓 开启");
            comment("5分钟追空单时 连续出现3根阴线 直接平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(9))//按钮10 已用
        {
         if(menu8[9])
           {
            Print("5分钟追多价格回撤 突破了最近的2根K线最低点先平仓 关闭");
            comment("5分钟追多价格回撤 突破了最近的2根K线最低点先平仓 关闭");
           }
         else
           {
            Print("5分钟追多价格回撤 突破了最近的2根K线最低点先平仓 开启");
            comment("5分钟追多价格回撤 突破了最近的2根K线最低点先平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(10)) //按钮11 已用
        {
         if(menu8[10])
           {
            Print("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓 关闭");
            comment("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓 关闭");
           }
         else
           {
            Print("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓 开启");
            comment("5分钟追空单价格回撤 突破了最近的2根K线最高点先平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(11))//按钮12 已用
        {
         if(menu8[11])
           {
            Print("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓 关闭");
            comment("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓 关闭");
           }
         else
           {
            Print("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓 开启");
            comment("5分钟追多单价格回撤 突破了最近的3根K线最低点先平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(12))//按钮13 已用
        {
         if(menu8[12])
           {
            Print("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓 关闭");
            comment("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓 关闭");
           }
         else
           {
            Print("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓 开启");
            comment("5分钟追空单价格回撤 突破了最近的3根K线最高点先平仓 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(13))//按钮14
        {
         if(menu8[13])
           {
            Print("5分钟收阳 直接开多单追 关闭");
            comment("5分钟收阳 直接开多单追 关闭");
           }
         else
           {
            Print("5分钟收阳 直接开多单追 开启");
            comment("5分钟收阳 直接开多单追 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(14))//按钮15
        {
         if(menu8[14])
           {
            Print("5分钟收阴 直接开空单追 关闭");
            comment("5分钟收阴 直接开空单追 关闭");
           }
         else
           {
            Print("5分钟收阴 直接开空单追 开启");
            comment("5分钟收阴 直接开空单追 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(15))//按钮16
        {
         if(menu8[15])
           {
            Print("5分钟收阳 横线模式开多单追 关闭");
            comment("5分钟收阳 横线模式开多单追 关闭");
           }
         else
           {
            Print("5分钟收阳 横线模式开多单追 开启");
            comment("5分钟收阳 横线模式开多单追 开启");
           }
        }
      if(sparam == pre8 + IntegerToString(16))//按钮17
        {
         if(menu8[16])
           {
            Print("5分钟收阴  横线模式开空单追 关闭");
            comment("5分钟收阴  横线模式开空单追 关闭");
           }
         else
           {
            Print("5分钟收阴  横线模式开空单追 开启");
            comment("5分钟收阴  横线模式开空单追 开启");
           }
        }
      //////////////////////////////////////////////////////////////////////////////////// 按钮0 副图2 mmm12
      if(sparam == pre12 + IntegerToString(0))//按钮1
        {
         if(dingshipingcang)
           {
            dingshipingcang=false;

            Print("当前五分钟K线收线时平仓 关闭");
            comment("当前五分钟K线收线时平仓 关闭");
            menu12[0]=true;
           }
         else
           {
            dingshipingcang=true;
            Print(" 当前五分钟K线收线时平仓  开启");
            comment("当前五分钟K线收线时平仓 开启");

           }
        }
      if(sparam == pre12 + IntegerToString(1))//按钮2
        {
         if(dingshipingcang15)
           {
            dingshipingcang15=false;

            Print("十五分钟K线收线时平仓 关闭");
            comment("十五分钟K线收线时平仓 关闭");
            menu12[1]=true;
           }
         else
           {
            dingshipingcang15=true;
            Print(" 十五分钟K线收线时平仓  开启");
            comment("十五分钟K线收线时平仓 开启");
           }
        }
      if(sparam == pre12 + IntegerToString(2))//按钮3
        {
         if(dingshipingcangF)
           {
            dingshipingcangF=false;
            Print("五分钟K线收线时平仓后反手 关闭");
            comment("五分钟K线收线时平仓后反手 关闭");
            menu12[2]=true;
           }
         else
           {
            dingshipingcangF=true;
            Print(" 五分钟K线收线时平仓后反手  开启");
            comment("五分钟K线收线时平仓后反手 开启");
           }
        }
      if(sparam == pre12 + IntegerToString(3))//按钮4
        {
         if(dingshipingcang15F)
           {
            dingshipingcang15F=false;
            Print("十五分钟K线收线时平仓后反手 关闭");
            comment("十五分钟K线收线时平仓后反手 关闭");
            menu12[3]=true;
           }
         else
           {
            dingshipingcang15F=true;
            Print(" 十五分钟K线收线时平仓后反手  开启");
            comment("十五分钟K线收线时平仓后反手 开启");
           }
        }
      if(sparam == pre12 + IntegerToString(4))//按钮5
        {
         if(dingshikaicang)
           {
            dingshikaicang=false;
            dingshikaicanggeshu1=dingshikaicanggeshu;
            Print("五分钟K线收盘时直接开仓 关闭");
            comment("五分钟K线收盘时直接开仓 关闭");
            menu12[4]=true;
           }
         else
           {
            dingshikaicang=true;
            dingshikaicanggeshu1=dingshikaicanggeshu+(rightpress-leftpress);
            Print("五分钟K线收盘时直接开仓 开启 次数",dingshikaicanggeshu1);
            comment(StringFormat("五分钟K线收盘时直接开仓 开启 次数%G",dingshikaicanggeshu1));
           }
        }
      if(sparam == pre12 + IntegerToString(5))//按钮6
        {
         if(dingshikaicang15)
           {
            dingshikaicang15=false;
            dingshikaicanggeshu1=dingshikaicanggeshu;
            Print("十五分钟K线收盘时直接开仓 关闭");
            comment("十五分钟K线收盘时直接开仓 关闭");
            menu12[5]=true;
           }
         else
           {
            dingshikaicang15=true;
            dingshikaicanggeshu1=dingshikaicanggeshu+(rightpress-leftpress);
            Print("十五分钟K线收盘时直接开仓 开启 次数",dingshikaicanggeshu1);
            comment(StringFormat("五十分钟K线收盘时直接开仓 开启 次数%G",dingshikaicanggeshu1));
           }
        }
      if(sparam == pre12 + IntegerToString(6))//按钮7
        {

        }
      if(sparam == pre12 + IntegerToString(7))//按钮8
        {

        }
      if(sparam == pre12 + IntegerToString(8))//按钮9
        {

        }
      if(sparam == pre12 + IntegerToString(9))//按钮10
        {

        }
      //////////////////////////////////////////////////////////////////////////////////// 按钮0 副图3 mmm13
      if(sparam == pre13 + IntegerToString(0))//13按钮1
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[0]=true;
           }
         else
           {
            monianjian(15);
            monianjian(2);
            //menu13[0]=true;
           }
        }
      if(sparam == pre13 + IntegerToString(1))//13按钮2
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[0]=true;
           }
         else
           {
            monianjian(45);
            monianjian(24);
            menu13[1]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(2))//13按钮3
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[2]=true;
           }
         else
           {
            monianjian(45);
            monianjian(37);
            menu13[2]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(3))//13按钮4
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[3]=true;
           }
         else
           {
            monianjian(45);
            monianjian(25);
            menu13[3]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(4))//13按钮5
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[4]=true;
           }
         else
           {
            monianjian(45);
            monianjian(38);
            menu13[4]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(5))//13按钮6
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[5]=true;
           }
         else
           {
            monianjian(47);
            monianjian(24);
            menu13[5]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(6))//13按钮7
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[6]=true;
           }
         else
           {
            monianjian(47);
            monianjian(37);
            menu13[6]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(7))//13按钮8
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[7]=true;
           }
         else
           {
            monianjian(30);
            monianjian(24);
            menu13[7]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(8))//13按钮9
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[8]=true;
           }
         else
           {
            monianjian(30);
            monianjian(37);
            menu13[8]=true;
            menu13[0]=false;
           }
        }
      if(sparam == pre13 + IntegerToString(9))//13按钮10
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[9]=true;
           }
         else
           {
            monianjian(15);
            monianjian(3);
            //menu13[9]=true;
           }
        }
      if(sparam == pre13 + IntegerToString(10))//13按钮11
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[10]=true;
           }
         else
           {
            monianjian(15);
            monianjian(8);
            //menu13[9]=true;
           }
        }
      if(sparam == pre13 + IntegerToString(11))//13按钮12
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[11]=true;
           }
         else
           {
            monianjian(42);
            monianjian(15);
            monianjian(8);
            //menu13[9]=true;
           }
        }
      if(sparam == pre13 + IntegerToString(12))//13按钮13
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[12]=true;
           }
         else
           {
            monianjian(29);
            monianjian(15);
            monianjian(8);
            //menu13[9]=true;
           }
        }
      if(sparam == pre13 + IntegerToString(13))//13按钮14
        {
         if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0 || ObjectFind(0,"SL Line")==0)
           {
            Print("图表有横线 存在 请先 删除");
            comment("图表有横线 存在 请先 删除");
            menu13[13]=true;
           }
         else
           {
            //monianjian(29);
            monianjian(15);
            monianjian(9);
            //menu13[9]=true;
           }
        }
      //////////////////////////////////////////////////////////////////////////////////// 按钮0 副图4 mmm14
      if(sparam == pre14 + IntegerToString(0))//14按钮1
        {
         menu14[0]=true;
        }
      //////////////////////////////////////////////////////////////////////////////////// 按钮0 副图4 mmm15
      if(sparam == pre15 + IntegerToString(0))//14按钮1
        {
         menu15[0]=true;
        }
      //////////////////////////////////////////////////////////////////////////////////// 横线模式 执行 代码  mmm2
      if(sparam == pre + IntegerToString(0))//按钮1
        {
         if(linelock)
           {
            shubiaogensuiBuy=false;
            Print("当前横线有任务在 监控中 无法移动 可以按Q键取消任务");
            comment("当前横线有任务在 监控中 无法移动 可以按Q键取消任务");
           }
         else
           {
            shubiaogensuiBuy=true;
           }
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         menu[0]=true;
        }
      if(sparam == pre + IntegerToString(1))
        {
         if(linelock)
           {
            shubiaogensuiSell=false;
            Print("当前横线有任务在 监控中 无法移动 可以按Q键取消任务");
            comment("当前横线有任务在 监控中 无法移动 可以按Q键取消任务");
           }
         else
           {
            shubiaogensuiSell=true;
           }
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         menu[1]=true;
        }
      if(sparam == pre + IntegerToString(2))
        {
         shubiaogensuiSL=true;
         menu[2]=true;
        }
      if(sparam == pre + IntegerToString(3))
        {
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
         if(ObjectFind(0,"SL Line")==0)
            ObjectDelete(0,"SL Line");
         menu[3]=true;

         linebar01=linebar;
         linebuykaicang=false;
         linebuypingcang=false;
         linebuyfansuo=false;
         linesellkaicang=false;
         linesellpingcang=false;
         linesellfansuo=false;
         yijianFanshou=false;
         linelock=false;
         lkey=false;
         linebuyzidongjiacang=false;
         linesellzidongjiacang=false;
         linebuypingcangR=false;
         linesellpingcangR=false;
         linebuypingcangC=false;
         linesellpingcangC=false;
         linebuypingcangctrlR=false;
         linesellpingcangctrlR=false;
         linebuypingcangonly=false;
         linesellpingcangonly=false;
         linekaicangT=false;
         linekaicangctrl=false;
         timeseconds1=timeseconds1P;
         pingcangdingdanshu=1000;
         hengxianAi1=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi1a=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi2=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi3=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi4=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi5=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi6=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi7=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         hengxianAi8=false;//横线模式时按H+主数字键  追踪指标一些变化 自动移动横线
         shangpress=0;
         xiapress=0;
         leftpress=0;
         rightpress=0;//清除方向键按下次数
         fkeyHolding=false;//
         fkeyHoldingfanshou=false;
         menu[24]=false;
         menu[26]=false;
         hengxianJJSkaicangBuy=false;
         hengxianJJSkaicangSell=false;

        }
      if(sparam == pre + IntegerToString(4))//按钮5
        {
         monianjian(38);
         monianjian(37);
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[4]=true;
           }

        }
      if(sparam == pre + IntegerToString(5))//按钮6
        {
         monianjian(54);
         monianjian(38);
         monianjian(37);
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[5]=true;
           }
        }
      if(sparam == pre + IntegerToString(6))//按钮7
        {
         monianjian(285);
         monianjian(38);
         monianjian(37);
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[6]=true;
           }
        }
      if(sparam == pre + IntegerToString(7))//按钮8
        {
         monianjian(29);
         monianjian(38);
         monianjian(37);
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[7]=true;
           }
        }
      if(sparam == pre + IntegerToString(8))//按钮9
        {
         //monianjian(29);
         monianjian(38);
         monianjian(34);
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[8]=true;
           }
        }
      if(sparam == pre + IntegerToString(9))//按钮10
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[9]=true;
           }
         else
           {
            monianjian(54);
            monianjian(38);
            monianjian(34);
            skey=false;
            lkey=false;
           }

        }
      if(sparam == pre + IntegerToString(10))//按钮11
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[10]=true;
           }
         else
           {
            //monianjian(54);
            monianjian(38);
            monianjian(25);
           }
        }
      if(sparam == pre + IntegerToString(11))//按钮12
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[11]=true;
           }
         else
           {
            if(linesellpingcangR)
              {
               Print("这个按钮不能双击 需要等待2s后才可以关闭");
               comment2("这个按钮不能双击 需要等待2s后才可以关闭");
               monianjian(38);
               monianjian(25);
               menu[11]=true;
              }
            else
              {
               monianjian(54);
               monianjian(38);
               monianjian(25);
              }

           }
        }
      if(sparam == pre + IntegerToString(12))//按钮13
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[12]=true;
           }
         else
           {
            monianjian(33);
            monianjian(38);
            monianjian(25);
           }
        }
      if(sparam == pre + IntegerToString(13))//按钮14
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[13]=true;
           }
         else
           {
            if(linebuypingcangctrlR)
              {
               Print("这个按钮不能双击 需要等待2s后才可以关闭");
               comment2("这个按钮不能双击 需要等待2s后才可以关闭");
               monianjian(38);
               monianjian(25);
               menu[13]=true;
              }
            else
              {
               monianjian(285);
               monianjian(38);
               monianjian(25);
              }
           }
        }
      if(sparam == pre + IntegerToString(14))//按钮15
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[13]=true;
           }
         else
           {
            if(fkeyHolding)
              {
               Print("这个按钮不能双击 需要等待2s后才可以关闭");
               comment2("这个按钮不能双击 需要等待2s后才可以关闭");
               monianjian(38);
               monianjian(25);
               menu[1]=true;
              }
            else
              {
               monianjian(33);
               monianjian(285);
               monianjian(38);
               monianjian(25);
              }
           }
        }
      if(sparam == pre + IntegerToString(15))//按钮16
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[15]=true;
           }
         else
           {
            monianjian(48);
            monianjian(38);
            monianjian(25);
           }
        }
      if(sparam == pre + IntegerToString(16))//按钮17
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[16]=true;
           }
         else
           {
            monianjian(49);
            monianjian(38);
            monianjian(25);
           }
        }
      if(sparam == pre + IntegerToString(17))//按钮18
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[17]=true;
           }
         else
           {
            //monianjian(49);
            monianjian(38);
            monianjian(33);
           }
        }
      if(sparam == pre + IntegerToString(18))//按钮19
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[18]=true;
           }
         else
           {
            monianjian(54);
            monianjian(38);
            monianjian(33);
            menu[18]=true;
           }
        }
      if(sparam == pre + IntegerToString(19))//按钮20
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment1("这个按钮 开启后 需要等待3秒后 点击两次 才能关闭");
            menu[19]=true;
           }
         else
           {
            if(yijianFanshou)
              {
               yijianFanshou=false;
               Print("触线平仓后反手 关闭");
               comment("触线平仓后反手 关闭");
               menu[19]=true;
              }
            else
              {
               monianjian(285);
               monianjian(38);
               monianjian(33);
               menu[19]=false;
               //Print("linebuyfansuo ",linebuyfansuo,"linesellfansuo ",linesellfansuo );
              }
           }
        }
      if(sparam == pre + IntegerToString(20))//按钮21
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[20]=true;
           }
         else
           {
            //monianjian(54);
            monianjian(38);
            monianjian(20);
            menu[20]=true;
           }
        }
      if(sparam == pre + IntegerToString(21))//按钮22
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[21]=true;
           }
         else
           {
            //monianjian(54);
            monianjian(38);
            monianjian(44);
            menu[21]=true;
           }
        }
      if(sparam == pre + IntegerToString(22))//按钮23
        {
         if(menu[22])
           {
            if(ObjectFind(0,"onameBBC0")==0)
              {
               ObjectsDeleteAll(0, pre223);
               menu[22]=false;
               for(int i = 0; i < menu_zs; i++)//重绘后 读取一遍按钮状态 改变背景色
                 {
                  if(menu[i])
                    {
                     ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                    }
                  else
                    {
                     ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                    }
                 }
               for(int i = 0; i < menu_zs223; i++)//
                 {
                  if(menu223[i])
                    {
                     menu[22]=true;
                    }
                 }
               return;
              }
            else
              {
               but_x223=but_x+anjiu_W*缩放;
               but_y223=but_y;
               Draw_button223();//
               for(int i = 0; i < menu_zs223; i++)//重绘后 读取一遍按钮状态 改变背景色
                 {
                  if(menu223[i])
                    {
                     ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                    }
                  else
                    {
                     ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                    }
                 }
               menu[22]=false;
              }

           }
         else
           {
            but_x223=but_x+anjiu_W*缩放;
            but_y223=but_y;
            Draw_button223();//
            for(int i = 0; i < menu_zs223; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu223[i])
                 {
                  ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre + IntegerToString(23))//按钮24
        {
         if(menu[23])
           {
            if(ObjectFind(0,"onameBBD0")==0)
              {
               ObjectsDeleteAll(0, pre224);
               menu[23]=false;
               for(int i = 0; i < menu_zs; i++)//重绘后 读取一遍按钮状态 改变背景色
                 {
                  if(menu[i])
                    {
                     ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                    }
                  else
                    {
                     ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                    }
                 }
               for(int i = 0; i < menu_zs224; i++)//
                 {
                  if(menu224[i])
                    {
                     menu[23]=true;
                    }
                 }
               return;
              }
            else
              {
               but_x224=but_x+anjiu_W*缩放;
               but_y224=but_y;
               Draw_button224();//
               for(int i = 0; i < menu_zs224; i++)//重绘后 读取一遍按钮状态 改变背景色
                 {
                  if(menu224[i])
                    {
                     ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                    }
                  else
                    {
                     ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                    }
                 }
               menu[23]=false;
              }

           }
         else
           {
            but_x224=but_x+anjiu_W*缩放;
            but_y224=but_y;
            Draw_button224();//
            for(int i = 0; i < menu_zs224; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu224[i])
                 {
                  ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre + IntegerToString(24))//按钮25
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[24]=true;
           }
         else
           {
            if(menu[24])
              {
               monianjian(38);
               monianjian(25);
               Print("越线后等五分钟收线实体穿过后平仓 关闭");//
               comment1(" 越线后等五分钟收线实体穿过后平仓 关闭");
              }
            else
              {
               monianjian(38);
               monianjian(25);
               Print("越线后等五分钟收线实体穿过后平仓 启动");//
               comment(" 越线后等五分钟收线实体穿过后平仓 启动");
              }
           }
        }

      if(sparam == pre + IntegerToString(25))//按钮26
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[25]=true;
           }
         else
           {
            if(menu[25])
              {
               monianjian(38);
               monianjian(25);
               Print("触线平仓后 距离现价几个点反手追单 关闭");//
               comment1("触线平仓后 距离现价几个点反手追单 关闭");
              }
            else
              {
               monianjian(33);
               monianjian(38);
               monianjian(25);
               Print("触线平仓后 距离现价几个点反手追单 启动");//
               comment1("触线平仓后 距离现价几个点反手追单 启动");
              }
           }
        }
      if(sparam == pre + IntegerToString(26))//按钮27
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[26]=true;
           }
         else
           {
            if(menu[26]==false)
              {
               if(ObjectFind("Buy Line")==0 && linelock==false)
                 {
                  if(ObjectFind("SL Line")==0 && buyline>slline && slline<Bid && ObjectFind("BuySL2")<0)
                    {
                     menu[26]=true;
                     hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                     hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                     linelock=true;

                     menu224[0]=true;
                     ObjectCreate(0,"BuySL2",OBJ_HLINE,0,Time[0],slline,0);
                     ObjectSet("BuySL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"BuySL2",OBJPROP_TOOLTIP," 越线等待几十秒 还越线 平最近下的几单 BuySL2");
                     ObjectDelete(0,"SL Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     else
                       {
                        menu224_0geshu1=hengxianJJSkaicanggeshu1;
                       }
                     Print("越线等待几十秒 还越线 平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment1(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));


                     Print("渐进式触及横线开Buy单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1,"发现SL Line 同时启动 越线等待30s平仓");
                     comment2(StringFormat("渐进式触及横线开Buy单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                     tab=false;
                     return;
                    }
                  else
                    {
                     menu[26]=true;
                     hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                     hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                     linelock=true;
                     Print("渐进式触及横线开Buy单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                     comment2(StringFormat("渐进式触及横线开Buy单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                     tab=false;
                     return;
                    }

                 }
               if(ObjectFind("Sell Line")==0 && linelock==false)
                 {
                  if(ObjectFind("SL Line")==0 && sellline<slline && slline>Bid && ObjectFind("SellSL2")<0)
                    {
                     menu[26]=true;
                     hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                     hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                     linelock=true;

                     menu224[0]=true;
                     ObjectCreate(0,"SellSL2",OBJ_HLINE,0,Time[0],slline,0);
                     ObjectSet("SellSL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"SellSL2",OBJPROP_TOOLTIP," 越线等待几十秒 还越线 平最近下的几单 BuySL2");
                     ObjectDelete(0,"SL Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     else
                       {
                        menu224_0geshu1=hengxianJJSkaicanggeshu1;
                       }
                     Print("越线等待几十秒 还越线 平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment1(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));

                     Print("渐进式触及横线开Sell单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                     comment2(StringFormat("渐进式触及横线开Sell单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                     tab=false;
                     return;
                    }
                  else
                    {
                     menu[26]=true;
                     hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu+(rightpress-leftpress);
                     hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi+(shangpress-xiapress)*5;
                     linelock=true;
                     Print("渐进式触及横线开Sell单 开启 参考价格和位置 开仓",hengxianJJSkaicanggeshu1,"次 偏移",hengxianJJSkaicangpianyi1);
                     comment2(StringFormat("渐进式触及横线开Sell单 开启  横线每次偏移%G个点 开仓%G次",hengxianJJSkaicangpianyi1/10,hengxianJJSkaicanggeshu1));
                     tab=false;
                     return;
                    }

                 }
              }
            else
              {
               menu[26]=false;
               if(menu224_0geshu1==hengxianJJSkaicanggeshu1)
                 {
                  menu224[0]=false;
                  ObjectDelete(0,"BuySL2");
                  ObjectDelete(0,"SellSL2");
                  menu224_0geshu1=menu224_0geshu;
                 }
               hengxianJJSkaicanggeshu1=hengxianJJSkaicanggeshu;
               hengxianJJSkaicangpianyi1=hengxianJJSkaicangpianyi;
               linelock=false;
               Print("渐进式触及横线开仓 关闭 ");
               comment2("渐进式触及横线开仓 关闭 ");
               ObjectDelete(0,"Buy Line");
               ObjectDelete(0,"Sell Line");
               hengxianJJSkaicangBuy=false;
               hengxianJJSkaicangSell=false;
               tab=false;
               return;
              }
           }
        }
      if(sparam == pre + IntegerToString(27))//按钮28
        {
         if(menu[27])
           {
            ObjectDelete(0,"BuyStop1");
            ObjectDelete(0,"SellStop1");
            buyLotslinshi1=0.0;
            sellLotslinshi1=0.0;
            menu27Tick=true;
            Print("小阻力位先平仓K线实体越过再开相同的仓位追 关闭");
            comment1("小阻力位先平仓K线实体越过再开相同的仓位追 关闭");
           }
         else
           {
            if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0)
              {
               Print("小阻力位先平仓K线实体越过再开相同的仓位追 开启");
               comment1("小阻力位先平仓K线实体越过再开相同的仓位追 开启");
               if(menu[28]==false)
                 {
                  monianjian(38);
                  monianjian(25);
                 }
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  menu27Tick=true;
                  Print("ShiftR 小阻力位先平仓K线越过再开相同的仓位追 开启");
                  comment1("ShiftR 小阻力位先平仓K线越过再开相同的仓位追 开启");
                 }

              }
            else
              {
               Print("需要先按Q键生成一条平仓线 Buy单用绿线 Sell单用红线");
               comment1("需要先按Q键生成一条平仓线 Buy单用绿线 Sell单用红线");
               menu[27]=true;
              }
           }
        }
      if(sparam == pre + IntegerToString(28))//按钮29
        {
         if(menu[28])
           {
            Print("策略性平仓回撤几个点后再下相同的订单追 薅羊毛 关闭");
            comment2("策略性平仓回撤几个点后再下相同的订单追 薅羊毛 关闭");
           }
         else
           {
            if(ObjectFind(0,"Buy Line")==0 || ObjectFind(0,"Sell Line")==0)
              {
               Print("策略性平仓回撤几个点后再下相同的订单追 薅羊毛 开启");
               comment2("策略性平仓回撤几个点后再下相同的订单追 薅羊毛 开启");
               if(menu[27]==false)
                 {
                  monianjian(38);
                  monianjian(25);
                 }
              }
            else
              {
               Print("需要先按Q键生成一条平仓线 Buy单用绿线 Sell单用红线");
               comment2("需要先按Q键生成一条平仓线 Buy单用绿线 Sell单用红线");
               menu[28]=true;
              }
           }
        }
      if(sparam == pre + IntegerToString(29))//按钮30
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu[29]=true;
           }
         else
           {
            if(menu[29])
              {
               monianjian(38);
               monianjian(33);
               Print("反锁后再回撤几个点平原来的单 关闭");//
               comment2("反锁后再回撤几个点平原来的单 关闭");
              }
            else
              {

               monianjian(38);
               monianjian(33);
               Print("反锁后再回撤几个点平原来的单 启动");//
               comment2("反锁后再回撤几个点平原来的单 启动");
              }
           }
        }
      ////////////////////////////////////////////////////////////////////////////////////横线模式 副图23 更多功能 执行代码 按钮223 mmm223
      if(sparam == pre223 + IntegerToString(0))//按钮1
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 ");
            comment(" 未找到横线 无法启动 ");
            menu223[0]=true;
           }
         else
           {
            //monianjian(54);
            monianjian(35);
            monianjian(2);
            menu223[0]=true;
           }
        }
      if(sparam == pre223 + IntegerToString(1))//按钮2
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 ");
            comment(" 未找到横线 无法启动 ");
            menu223[1]=true;
           }
         else
           {
            if(ObjectFind(0,"Buy Line")==0)
              {
               if(Vegas_144==false && Vegas_169==false && Vegas_288==false && Vegas_338==false)
                 {
                  Vegas_144=true;
                  Vegas_169=false;
                  Vegas_288=false;
                  Vegas_338=false;
                  Print("根据 EMA144 移动Buy Line横线");
                  comment2("根据 EMA144 移动Buy Line横线");
                 }
               else
                 {
                  if(Vegas_169==false && Vegas_288==false && Vegas_338==false)
                    {
                     Vegas_144=false;
                     Vegas_169=true;
                     Vegas_288=false;
                     Vegas_338=false;
                     menu223[1]=false;
                     Print("根据 EMA169 移动Buy Line横线");
                     comment2("根据 EMA169 移动Buy Line横线");
                    }
                  else
                    {
                     if(Vegas_288==false && Vegas_338==false)
                       {
                        Vegas_144=false;
                        Vegas_169=false;
                        Vegas_288=true;
                        Vegas_338=false;
                        menu223[1]=false;
                        Print("根据 EMA288 移动Buy Line横线");
                        comment2("根据 EMA288 移动Buy Line横线");
                       }
                     else
                       {
                        if(Vegas_338==false)
                          {
                           Vegas_144=false;
                           Vegas_169=false;
                           Vegas_288=false;
                           Vegas_338=true;
                           menu223[1]=false;
                           Print("根据 EMA338 移动Buy Line横线");
                           comment2("根据 EMA338 移动Buy Line横线");
                          }
                        else
                          {
                           Vegas_144=false;
                           Vegas_169=false;
                           Vegas_288=false;
                           Vegas_338=false;
                           menu223[1]=true;
                           Print("根据 Vegas 移动Buy Line横线 关闭");
                           comment2("根据 Vegas 移动Buy Line横线 关闭");
                          }
                       }
                    }

                 }
              }
            if(ObjectFind(0,"Sell Line")==0)
              {
               if(Vegas_144==false && Vegas_169==false && Vegas_288==false && Vegas_338==false)
                 {
                  Vegas_144=true;
                  Vegas_169=false;
                  Vegas_288=false;
                  Vegas_338=false;
                  Print("根据 EMA144 移动Sell Line横线");
                  comment2("根据 EMA144 移动Sell Line横线");
                 }
               else
                 {
                  if(Vegas_169==false && Vegas_288==false && Vegas_338==false)
                    {
                     Vegas_144=false;
                     Vegas_169=true;
                     Vegas_288=false;
                     Vegas_338=false;
                     menu223[1]=false;
                     Print("根据 EMA169 移动Sell Line横线");
                     comment2("根据 EMA169 移动Sell Line横线");
                    }
                  else
                    {
                     if(Vegas_288==false && Vegas_338==false)
                       {
                        Vegas_144=false;
                        Vegas_169=false;
                        Vegas_288=true;
                        Vegas_338=false;
                        menu223[1]=false;
                        Print("根据 EMA288 移动Sell Line横线");
                        comment2("根据 EMA288 移动Sell Line横线");
                       }
                     else
                       {
                        if(Vegas_338==false)
                          {
                           Vegas_144=false;
                           Vegas_169=false;
                           Vegas_288=false;
                           Vegas_338=true;
                           menu223[1]=false;
                           Print("根据 EMA338 移动Sell Line横线");
                           comment2("根据 EMA338 移动Sell Line横线");
                          }
                        else
                          {
                           Vegas_144=false;
                           Vegas_169=false;
                           Vegas_288=false;
                           Vegas_338=false;
                           menu223[1]=true;
                           Print("根据 Vegas 移动Sell Line横线 关闭");
                           comment2("根据 Vegas 移动Sell Line横线 关闭");
                          }
                       }
                    }

                 }
              }

           }
        }
      if(sparam == pre223 + IntegerToString(2))//按钮3
        {
         Print("45631");//测试 搜索点
        }
      ////////////////////////////////////////////////////////////////////////////////////横线模式 副图224 更多功能 执行代码 按钮224 mmm224
      if(sparam == pre224 + IntegerToString(0))//按钮1
        {
         if(ObjectFind(0,"BuySL2")==0 ||  ObjectFind(0,"SellSL2")==0)
           {
            ObjectDelete(0,"BuySL2");
            ObjectDelete(0,"SellSL2");
            Print("越线等待几十秒还越线平最近下的几单 关闭");
            comment2("越线等待几十秒还越线平最近下的几单 关闭");
            menu224[0]=true;
            menu224_0geshu1=menu224_0geshu;
           }
         else
           {
            if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
              {
               Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
               comment1("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
               menu224[0]=true;
              }
            else
              {
               if(ObjectFind(0,"Buy Line")==0)
                 {
                  if(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)<Bid)
                    {
                     ObjectCreate(0,"BuySL2",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0));
                     ObjectSet("BuySL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"BuySL2",OBJPROP_TOOLTIP," 越线等待几十秒 还越线 平最近下的几单 BuySL2");
                     ObjectDelete(0,"Buy Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     Print("越线等待几十秒 还越线 平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment2(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));
                    }
                  else
                    {
                     ObjectCreate(0,"SellSL2",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0));
                     ObjectSet("SellSL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"SellSL2",OBJPROP_TOOLTIP,"越线等待几十秒 还越线 平最近下的几单 SellSL2 ");
                     ObjectDelete(0,"Buy Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     Print("越线等待几十秒还越线平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment2(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));
                    }
                 }
               if(ObjectFind(0,"Sell Line")==0)
                 {
                  if(ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)<Bid)
                    {
                     ObjectCreate(0,"BuySL2",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0));
                     ObjectSet("BuySL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"BuySL2",OBJPROP_TOOLTIP,"越线等待几十秒还越线平最近下的几单  BuySL2");
                     ObjectDelete(0,"Sell Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     Print("越线等待几十秒还越线平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment5(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));
                    }
                  else
                    {
                     ObjectCreate(0,"SellSL2",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0));
                     ObjectSet("SellSL2",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"SellSL2",OBJPROP_TOOLTIP,"越线等待几十秒还越线平最近下的几单 SellSL2");
                     ObjectDelete(0,"Sell Line");
                     if(dingdanshu3<=9)
                       {
                        menu224_0geshu1=dingdanshu3;
                       }
                     Print("越线等待几十秒还越线平最近下的几单 启动 平最近下的",menu224_0geshu1,"单");
                     comment5(StringFormat("越线等待几十秒还越线平最近下的几单 启动 平最近下的%G单",menu224_0geshu1));
                    }
                 }
              }
           }
        }
      if(sparam == pre224 + IntegerToString(1))//按钮2
        {
         if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
           {
            Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            comment(" 未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
            menu224[1]=true;
           }
         else
           {
            if(menu224[1])
              {
               Print("越线缓慢开仓直到返回 关闭");//
               comment2("越线缓慢开仓直到返回 关闭");
               ObjectDelete(0,"Buy Line");
               ObjectDelete(0,"Sell Line");
               ObjectDelete(0,"SL Line");
               menu224_1geshu1=menu224_1geshu;
               menu224_1sleep1=menu224_1sleep;
               linelock=false;
              }
            else
              {
               if(!ObjectFind(0,"SL Line")==0)
                 {
                  Print("越线缓慢开仓直到返回 启动失败 未找到SL Line 请按X键调出");//
                  comment2("越线缓慢开仓直到返回 启动失败 未找到SL Line 请按X键调出");
                  menu224[1]=true;
                 }
               else
                 {
                  menu224_1geshu1=menu224_1geshu-leftpress+rightpress;
                  menu224_1sleep1=menu224_1sleep+shangpress-xiapress;
                  Print("越线缓慢开仓直到返回 启动 开仓个数",menu224_1geshu1,"间隔时间",menu224_1sleep1);//
                  comment2(StringFormat("越线缓慢开仓直到返回 启动 开仓个数%G 间隔时间%G秒",menu224_1geshu1,menu224_1sleep1));
                 }
              }
           }
        }
      if(sparam == pre224 + IntegerToString(2))//按钮3
        {

        }
      if(sparam == pre224 + IntegerToString(3))//按钮4
        {

        }
      ////////////////////////////////////////////////////////////////////////////////////指标相关 执行 按钮2 mmm3
      if(sparam == pre2 + IntegerToString(0))//按钮1
        {
         if(menu2[0])
           {
            ObjectsDeleteAll(0, pre31);
            menu2[0]=false;
            for(int i = 0; i < menu_zs2; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu2[i])
                 {
                  ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
            return;
           }
         else
           {
            but_x31=but_x2+anjiu_W*缩放;
            but_y31=but_y2;
            Draw_button31();//
            for(int i = 0; i < menu_zs31; i++)//重绘后 读取一遍按钮状态 改变背景色
              {
               if(menu31[i])
                 {
                  ObjectSetInteger(0, pre31 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
                 }
               else
                 {
                  ObjectSetInteger(0, pre31 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
                 }
              }
           }
        }
      if(sparam == pre2 + IntegerToString(1))//按钮13
        {
         if(imbfxT==false)
           {
            imbfxT=true;
            Print("当前图表参考MBFX指标 自动平仓 开启");
            comment1("当前图表参考MBFX指标 自动平仓 开启");

           }
         else
           {
            imbfxT=false;
            Print("当前图表参考MBFX指标 自动平仓 关闭");
            comment1("当前图表参考MBFX指标 自动平仓 关闭");
            menu2[1]=true;
           }
        }
      if(sparam == pre2 + IntegerToString(2))//按钮3
        {
         if(menu2[2])
           {
            menu2[2]=true;
            Print("MBFX指标 出现亮黄色反转信号时 平仓 关闭");
            comment3("MBFX指标 出现亮黄色反转信号时 平仓 关闭");
           }
         else
           {
            Print("MBFX指标 出现亮黄色反转信号时 平仓 开启");
            comment3("MBFX指标 出现亮黄色反转信号时 平仓 开启");
           }
        }
      ////////////////////////////////////////////////////////////////////////////////////其他 相关 执行 按钮3 mmm4
      if(sparam == pre3 + IntegerToString(0))//按钮1
        {
         monianjian(38);
         monianjian(45);
         //menu3[0]=false;
        }
      if(sparam == pre3 + IntegerToString(1))//按钮2
        {
         monianjian(54);
         monianjian(38);
         monianjian(45);
         // menu3[1]=false;
        }
      if(sparam == pre3 + IntegerToString(2))//按钮3
        {
         monianjian(24);
         monianjian(33);
         menu3[2]=true;
        }
      if(sparam == pre3 + IntegerToString(3))//按钮4
        {
         monianjian(37);
         monianjian(33);
         menu3[3]=true;
        }
      if(sparam == pre3 + IntegerToString(4))//按钮5
        {
         monianjian(24);
         monianjian(20);
         menu3[4]=true;
        }
      if(sparam == pre3 + IntegerToString(5))//按钮6
        {
         monianjian(37);
         monianjian(20);
         menu3[5]=true;
        }
      if(sparam == pre3 + IntegerToString(6))//按钮7
        {
         monianjian(15);
         monianjian(4);
         menu3[6]=true;
        }
      if(sparam == pre3 + IntegerToString(7))//按钮8
        {
         monianjian(15);
         monianjian(5);
         menu3[7]=true;
        }
      if(sparam == pre3 + IntegerToString(8))//按钮9
        {
         monianjian(15);
         monianjian(6);
         menu3[8]=true;
        }
      if(sparam == pre3 + IntegerToString(9))//按钮10
        {
         monianjian(15);
         monianjian(7);
         menu3[9]=true;
        }
      if(sparam == pre3 + IntegerToString(10))//按钮11
        {
         monianjian(48);
         monianjian(35);
         menu3[10]=true;
        }
      if(sparam == pre3 + IntegerToString(11))//按钮12
        {
         monianjian(31);
         monianjian(35);
         menu3[11]=true;
        }
      if(sparam == pre3 + IntegerToString(12))//按钮13
        {
         monianjian(48);
         monianjian(22);
         menu3[12]=true;
        }
      if(sparam == pre3 + IntegerToString(13))//按钮14
        {
         monianjian(31);
         monianjian(22);
         menu3[13]=true;
        }
      if(sparam == pre3 + IntegerToString(14))//按钮15
        {
         if(menu3[14])
           {
            menu3[14]=true;
            Print("账户总净值低于 ",gloAccountEquityLow," 全平仓 关闭");
            comment3(StringFormat("账户总净值低于 %G 全平仓 关闭",gloAccountEquityLow));
           }
         else
           {
            Print("账户总净值低于 ",gloAccountEquityLow," 全平仓 开启");
            comment3(StringFormat("账户总净值低于 %G 全平仓 开启",gloAccountEquityLow));
           }
        }
      if(sparam == pre3 + IntegerToString(15))//按钮16
        {
         if(menu3[15])
           {
            menu3[15]=true;
            Print("账户总净值高于 ",gloAccountEquityHigh," 全平仓 关闭");
            comment3(StringFormat("账户总净值高于 %G 全平仓 关闭",gloAccountEquityHigh));
           }
         else
           {
            Print("账户总净值高于 ",gloAccountEquityHigh," 全平仓 开启");
            comment3(StringFormat("账户总净值高于 %G 全平仓 开启",gloAccountEquityHigh));
           }
        }
      if(sparam == pre3 + IntegerToString(16))//按钮17
        {
         if(menu3[16])
           {
            menu3[16]=true;
            Print("总利润低于 ",gloAccountProfitmin," 全平仓 关闭");
            comment3(StringFormat("总利润低于 %G 全平仓 关闭",gloAccountProfitmin));

           }
         else
           {
            Print("总利润低于 ",gloAccountProfitmin," 全平仓 开启");
            comment3(StringFormat("总利润低于 %G 全平仓 开启",gloAccountProfitmin));
           }
        }
      if(sparam == pre3 + IntegerToString(17))//按钮18
        {
         if(menu3[17])
           {
            menu3[17]=true;
            Print("总利润回到保本线后 反手 关闭");
            comment3("总利润回到保本线后 反手 关闭");

           }
         else
           {
            Print("总利润回到保本线后 反手 开启");
            comment3("总利润回到保本线后 反手 开启");
           }
        }
      if(sparam == pre3 + IntegerToString(18))//按钮19
        {
         if(menu3[18])
           {
            menu3[18]=true;
            Print("本金盈利50%全平仓 关闭");
            comment3("本金盈利50%全平仓 关闭");
           }
         else
           {
            Print("本金盈利50%全平仓 开启");
            comment3("本金盈利50%全平仓 开启");
           }
        }
      if(sparam == pre3 + IntegerToString(19))//按钮20
        {

        }
      if(sparam == pre3 + IntegerToString(20))//按钮21
        {
         double a=0.0;
         for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
            //  for(int cnt=0;cnt<OrdersTotal();cnt++)
           {
            if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol())
                 {
                  a=OrderLots();
                  Print(a);
                  break;
                 }
              }
           }
         if(a!=0.0)
           {
            GlobalVariableSet("glodefaultlots",a);
            Print("默认下单手数更新成功 请重新加载EA");
            comment1("默认下单手数更新成功 请重新加载EA");
            Alert("默认下单手数更新成功 当前为",GlobalVariableGet("glodefaultlots"),"手 请重新加载EA");
            menu3[20]=true;
           }
         else
           {
            Print("请先手动下一单 手数是您想设置的手数 再按 然后重新加载EA");
            comment1("请先手动下一单 手数是您想设置的手数 再按  然后重新加载EA");
            menu3[20]=true;
           }
        }
      if(sparam == pre3 + IntegerToString(21))//按钮22
        {
         int a=MessageBox("确定恢复出厂时的全局参数设置吗？稍后请重新加载EA",NULL,MB_OKCANCEL);
         if(a==1)
           {
            GlobalVariablesDeleteAll(NULL,0);
            ExpertRemove();
           }
         menu3[21]=true;
        }
      if(sparam == pre3 + IntegerToString(22))//按钮23
        {
         if(menu3[22])
           {
            menu3[22]=true;
            comment4("声音提醒 恢复");
           }
         else
           {
            comment4("声音提醒 关闭 下单声音除外");
           }

        }
      ////////////////////////////////////////////////////////////////////////////////////备用  执行代码 按钮4 mmm5
      if(sparam == pre4 + IntegerToString(0))//按钮1
        {
         if(menu4[0])
           {
            comment3("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 关闭 ");
           }
         else
           {
            comment3("5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K实体 报警提醒 启动 ");
           }
        }
      if(sparam == pre4 + IntegerToString(1))//按钮2
        {
         if(!ObjectFind(0,"onamezhegai")==0)
           {
            Draw_zhegai();
            menu4[1]=false;
            comment3("遮盖当前未收盘K线 以减少波动影响对行情的判断 ");
           }
         else
           {
            ObjectDelete(0,"onamezhegai");
           }
        }
      if(sparam == pre4 + IntegerToString(2))//按钮3
        {
         if(menu4[2])
           {
            monianjian(15);
            monianjian(10);
            Print("Tick剧烈波动时自动平Buy单 关闭");
            comment3("Tick剧烈波动时自动平Buy单 关闭");
           }
         else
           {
            if(menu4[3])
              {
               Print("启动失败 同时只能启动一个方向");
               comment3("启动失败 同时只能启动一个方向");
               menu4[2]=true;
              }
            else
              {
               monianjian(48);
               monianjian(15);
               monianjian(10);
               Print("Tick剧烈波动时自动平Buy单 开启");
               comment3("Tick剧烈波动时自动平Buy单 开启");
              }
           }
        }
      if(sparam == pre4 + IntegerToString(3))//按钮4
        {
         if(menu4[3])
           {
            monianjian(15);
            monianjian(10);
            Print("Tick剧烈波动时自动平Sell单 关闭");
            comment3("Tick剧烈波动时自动平Sell单 关闭");
           }
         else
           {
            if(menu4[2])
              {
               Print("启动失败 同时只能启动一个方向");
               comment3("启动失败 同时只能启动一个方向");
               menu4[3]=true;
              }
            else
              {
               monianjian(31);
               monianjian(15);
               monianjian(10);
               Print("Tick剧烈波动时自动平Sell单 开启");
               comment3("Tick剧烈波动时自动平Sell单 开启");
              }
           }
        }
      if(sparam == pre4 + IntegerToString(4))//按钮5
        {

         // menu4[4]=false;
        }
      if(sparam == pre4 + IntegerToString(5))//按钮6
        {

         // menu4[5]=false;
        }
      if(sparam == pre4 + IntegerToString(6))//按钮7
        {

         // menu4[6]=false;
        }
      if(sparam == pre4 + IntegerToString(7))//按钮8
        {

         // menu4[7]=false;
        }
      if(sparam == pre4 + IntegerToString(8))//按钮9
        {
         if(ObjectFind(0,"BuySL1")==0 ||  ObjectFind(0,"SellSL1")==0)
           {
            ObjectDelete(0,"BuySL1");
            ObjectDelete(0,"SellSL1");
            Print("K线收盘时 K线实体越过横线止损 关闭");
            comment5("K线收盘时 K线实体越过横线止损 关闭");
            menu4[8]=true;
            BuySL1=false;
            SellSL1=false;
            menu4_8jishu=50;
           }
         else
           {
            if(!ObjectFind(0,"Buy Line")==0 && !ObjectFind(0,"Sell Line")==0)
              {
               Print("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
               comment5("未找到横线 无法启动 请先生成 按Q键可快速切换 W S 上下移动");
               menu4[8]=true;
              }
            else
              {
               if(ObjectFind(0,"Buy Line")==0)
                 {
                  if(ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0)<Bid)
                    {
                     ObjectCreate(0,"BuySL1",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0));
                     ObjectSet("BuySL1",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"BuySL1",OBJPROP_TOOLTIP,"当前K线收盘时 K线实体越过横线 止损出局 防止 上下影线影响 ");
                     ObjectDelete(0,"Buy Line");
                     menu4_8jishu=dingdanshu3;
                     Print("K线收盘时 K线实体越过横线止损 启动 平最近",menu4_8jishu,"单");
                     comment5(StringFormat("K线收盘时 K线实体越过横线止损 启动 平最近%G单",menu4_8jishu));
                    }
                  else
                    {
                     ObjectCreate(0,"SellSL1",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Buy Line",OBJPROP_PRICE,0));
                     ObjectSet("SellSL1",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"SellSL1",OBJPROP_TOOLTIP,"当前K线收盘时 K线实体越过横线 止损出局 防止 上下影线影响 ");
                     ObjectDelete(0,"Buy Line");
                     menu4_8jishu=dingdanshu3;
                     Print("K线收盘时 K线实体越过横线止损 启动 平最近",menu4_8jishu,"单");
                     comment5(StringFormat("K线收盘时 K线实体越过横线止损 启动 平最近%G单",menu4_8jishu));
                    }
                 }
               if(ObjectFind(0,"Sell Line")==0)
                 {
                  if(ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0)<Bid)
                    {
                     ObjectCreate(0,"BuySL1",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0));
                     ObjectSet("BuySL1",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"BuySL1",OBJPROP_TOOLTIP,"当前K线收盘时 K线实体越过横线 止损出局 防止 上下影线影响 ");
                     ObjectDelete(0,"Sell Line");
                     menu4_8jishu=dingdanshu3;
                     Print("K线收盘时 K线实体越过横线止损 启动 平最近",menu4_8jishu,"单");
                     comment5(StringFormat("K线收盘时 K线实体越过横线止损 启动 平最近%G单",menu4_8jishu));
                    }
                  else
                    {
                     ObjectCreate(0,"SellSL1",OBJ_HLINE,0,Time[0],ObjectGetDouble(0,"Sell Line",OBJPROP_PRICE,0));
                     ObjectSet("SellSL1",OBJPROP_COLOR,clrMaroon);
                     ObjectSetString(0,"SellSL1",OBJPROP_TOOLTIP,"当前K线收盘时 K线实体越过横线 止损出局 防止 上下影线影响 ");
                     ObjectDelete(0,"Sell Line");
                     menu4_8jishu=dingdanshu3;
                     Print("K线收盘时 K线实体越过横线止损 启动 平最近",menu4_8jishu,"单");
                     comment5(StringFormat("K线收盘时 K线实体越过横线止损 启动 平最近%G单",menu4_8jishu));
                    }
                 }
              }
           }
        }
      if(sparam == pre4 + IntegerToString(9))//按钮10
        {

        }
      ////////////////////////////////////////////////////////////////////////////////////自动化  执行代码 按钮7 mmm7
      if(sparam == pre5 + IntegerToString(0))//按钮1
        {
         monianjian(29);
         monianjian(33);
         //menu5[0]=false;
        }
      if(sparam == pre5 + IntegerToString(1))//按钮2
        {

        }
      if(sparam == pre5 + IntegerToString(2))//按钮3
        {

        }
      if(sparam == pre5 + IntegerToString(3))//按钮4
        {

        }
      if(sparam == pre5 + IntegerToString(4))//按钮5
        {

        }
      if(sparam == pre5 + IntegerToString(5))//按钮6
        {

        }
      if(sparam == pre5 + IntegerToString(6))//按钮7
        {

        }
      if(sparam == pre5 + IntegerToString(7))//按钮8
        {

        }
      ////////////////////////////////////////////////////////////////////////////////////短线追单模式  执行代码 按钮6 mmm6
      if(sparam == pre6 + IntegerToString(0))//按钮1
        {
         if(menu6[0])
           {
            menu6[0]=true;
            Print("短线追Buy单模式 关闭 ");
            comment3("短线追Buy单模式 关闭 ");
            ObjectDelete(0,"dxzdBuyi2kSL");
            ObjectDelete(0,"dxzdBuyi3kSL");
            ObjectDelete(0,"dxzdBuyi4kSL");
            ObjectDelete(0,"dxzdBuyi5kSL");
            ObjectDelete(0,"dxzdBuyi2kSL1");
            ObjectDelete(0,"dxzdBuyi3kSL1");
            ObjectDelete(0,"dxzdBuyi4kSL1");
            ObjectDelete(0,"dxzdBuyi5kSL1");
            ObjectDelete(0,"dxzdBuyLineC");
            ObjectDelete(0,"dxzdBuyLineO");
            ObjectDelete(0,"dxzdBuyLineL");
            dxzdBuyLineL1=false;
            dxzdBuyLineO1=false;
            dxzdBuyLineC1=false;
           }
         else
           {
            Print("短线追Buy单模式 启动 ");
            comment3("短线追Buy单模式 启动 ");
           }
        }
      if(sparam == pre6 + IntegerToString(1))//按钮2
        {
         if(menu6[1])
           {
            menu6[1]=true;
            Print("短线追Sell单模式 关闭 ");
            comment3("短线追Sell单模式 关闭 ");
            ObjectDelete(0,"dxzdSelli2kSL");
            ObjectDelete(0,"dxzdSelli3kSL");
            ObjectDelete(0,"dxzdSelli4kSL");
            ObjectDelete(0,"dxzdSelli5kSL");
            ObjectDelete(0,"dxzdSelli2kSL1");
            ObjectDelete(0,"dxzdSelli3kSL1");
            ObjectDelete(0,"dxzdSelli4kSL1");
            ObjectDelete(0,"dxzdSelli5kSL1");
            ObjectDelete(0,"dxzdSellLineC");
            ObjectDelete(0,"dxzdSellLineO");
            ObjectDelete(0,"dxzdSellLineH");
            dxzdSellLineH1=false;
            dxzdSellLineO1=false;
            dxzdSellLineC1=false;
           }
         else
           {
            Print("短线追Sell单模式 启动 ");
            comment3("短线追Sell单模式 启动 ");
           }
        }
      if(sparam == pre6 + IntegerToString(2))//按钮3
        {
         if(menu6[2])
           {
            monianjian(15);
            monianjian(52);
            menu6[2]=true;
            Print("短线剥头皮模式 追Buy单 关闭");
            comment4("短线剥头皮模式 追Buy单 关闭");
           }
         else
           {
            if(menu6[3])
              {
               Print("短线剥头皮 启动失败 同时只能启动一个方向");
               comment4("短线剥头皮 启动失败 同时只能启动一个方向");
               menu6[2]=true;
              }
            else
              {
               if(Tickmode==false)
                 {
                  monianjian(15);
                  monianjian(52);
                  Print("短线剥头皮模式 追Buy单 开启");
                  comment4("短线剥头皮模式 追Buy单 开启");
                 }
               else
                 {
                  menu6[2]=true;
                 }
              }
           }
        }
      if(sparam == pre6 + IntegerToString(3))//按钮4
        {
         if(menu6[3])
           {
            monianjian(15);
            monianjian(51);
            menu5[1]=true;
            Print("短线剥头皮模式 追Sell单 关闭");
            comment4("短线剥头皮模式 追Sell单 关闭");
           }
         else
           {
            if(menu6[2])
              {
               Print("短线剥头皮 启动失败 同时只能启动一个方向");
               comment4("短线剥头皮 启动失败 同时只能启动一个方向");
               menu6[3]=true;
              }
            else
              {
               if(Tickmode==false)
                 {
                  monianjian(15);
                  monianjian(51);
                  Print("短线剥头皮模式 追Sell单 开启");
                  comment4("短线剥头皮模式 追Sell单 开启");
                 }
               else
                 {
                  menu6[3]=true;
                 }
              }
           }
        }
      if(sparam == pre6 + IntegerToString(4))//按钮5
        {
         if(menu6[4])
           {
            if(ObjectFind(0,"znBuy5mSL1")>=0)
              {
               ObjectDelete(0,"znBuy5mSL1");
               Print("取消最近的一根止损线 继续按取消");
               comment4("取消最近的一根止损线 继续按取消");
               return;
              }
            else
              {
               if(ObjectFind(0,"znBuy5mSL2")>=0)
                 {
                  ObjectDelete(0,"znBuy5mSL2");
                  Print("取消最近的二根止损线 继续按取消");
                  comment4("取消最近的二根止损线 继续按取消");
                  return;
                 }
               else
                 {
                  menu6[4]=true;
                  Print("5分钟追buy单智能设止损线 关闭 ");
                  comment3("5分钟追buy单智能设止损线 关闭 ");
                  ObjectDelete(0,"znBuy5mSL1");
                  ObjectDelete(0,"znBuy5mSL2");
                  ObjectDelete(0,"znBuy5mSL3");
                  znBuy5mSL1=false;
                  znBuy5mSL2=false;
                  znBuy5mSL3=false;
                 }
              }
           }
         else
           {
            Print("5分钟追buy单智能设止损线 启动 ");
            comment3("5分钟追buy单智能设止损线 启动 ");
            if(ObjectFind(0,"znBuy5mSL1")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy5mSL1",OBJ_RECTANGLE,0,tpriceK[zn5mSL1bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL1bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL1bar,0)]+zn5mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy5mSL1",OBJPROP_BACK,false);
               ObjectSet("znBuy5mSL1",OBJPROP_WIDTH,1);
               ObjectSet("znBuy5mSL1",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy5mSL1",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线1");
              }
            if(ObjectFind(0,"znBuy5mSL2")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy5mSL2",OBJ_RECTANGLE,0,tpriceK[zn5mSL2bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL2bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL2bar,0)]+zn5mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy5mSL2",OBJPROP_BACK,false);
               ObjectSet("znBuy5mSL2",OBJPROP_WIDTH,1);
               ObjectSet("znBuy5mSL2",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy5mSL2",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线2");
              }
            if(ObjectFind(0,"znBuy5mSL3")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy5mSL3",OBJ_RECTANGLE,0,tpriceK[zn5mSL3bar-1],lpriceK[ArrayMinimum(lpriceK,zn5mSL3bar,0)]+zn5mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK[ArrayMinimum(lpriceK,zn5mSL3bar,0)]+zn5mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy5mSL3",OBJPROP_BACK,false);
               ObjectSet("znBuy5mSL3",OBJPROP_WIDTH,1);
               ObjectSet("znBuy5mSL3",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy5mSL3",OBJPROP_TOOLTIP,"5分钟Buy单智能止损线3");
              }
           }
        }
      if(sparam == pre6 + IntegerToString(5))//按钮6
        {
         if(menu6[5])
           {
            if(ObjectFind(0,"znSell5mSL1")>=0)
              {
               ObjectDelete(0,"znSell5mSL1");
               Print("取消最近的一根止损线 继续按取消");
               comment4("取消最近的一根止损线 继续按取消");
               return;
              }
            else
              {
               if(ObjectFind(0,"znSell5mSL2")>=0)
                 {
                  ObjectDelete(0,"znSell5mSL2");
                  Print("取消最近的二根止损线 继续按取消");
                  comment4("取消最近的二根止损线 继续按取消");
                  return;
                 }
               else
                 {
                  menu6[5]=true;
                  Print("5分钟追Sell单智能设止损线 关闭 ");
                  comment3("5分钟追Sell单智能设止损线 关闭 ");
                  ObjectDelete(0,"znSell5mSL1");
                  ObjectDelete(0,"znSell5mSL2");
                  ObjectDelete(0,"znSell5mSL3");
                  znSell5mSL1=false;
                  znSell5mSL2=false;
                  znSell5mSL3=false;
                 }
              }
           }
         else
           {
            Print("5分钟追Sell单智能设止损线 启动 ");
            comment3("5分钟追Sell单智能设止损线 启动 ");
            if(ObjectFind(0,"znSell5mSL1")<0)      //第一次启动运行
              {
               Print(hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha);
               ObjectCreate(0,"znSell5mSL1",OBJ_RECTANGLE,0,tpriceK[zn5mSL1bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL1bar,0)]+zn5mSellSLpianyi*Point+diancha);
               ObjectSet("znSell5mSL1",OBJPROP_BACK,false);
               ObjectSet("znSell5mSL1",OBJPROP_WIDTH,1);
               ObjectSet("znSell5mSL1",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell5mSL1",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线1");
              }
            if(ObjectFind(0,"znSell5mSL2")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znSell5mSL2",OBJ_RECTANGLE,0,tpriceK[zn5mSL2bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL2bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL2bar,0)]+zn5mSellSLpianyi*Point+diancha);
               ObjectSet("znSell5mSL2",OBJPROP_BACK,false);
               ObjectSet("znSell5mSL2",OBJPROP_WIDTH,1);
               ObjectSet("znSell5mSL2",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell5mSL2",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线2");
              }
            if(ObjectFind(0,"znSell5mSL3")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znSell5mSL3",OBJ_RECTANGLE,0,tpriceK[zn5mSL3bar-1],hpriceK[ArrayMaximum(hpriceK,zn5mSL3bar,0)]+zn5mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK[ArrayMaximum(hpriceK,zn5mSL3bar,0)]+zn5mSellSLpianyi*Point+diancha);
               ObjectSet("znSell5mSL3",OBJPROP_BACK,false);
               ObjectSet("znSell5mSL3",OBJPROP_WIDTH,1);
               ObjectSet("znSell5mSL3",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell5mSL3",OBJPROP_TOOLTIP,"5分钟Sell单智能止损线3");
              }
           }
        }
      if(sparam == pre6 + IntegerToString(6))//按钮7
        {
         if(menu6[6])
           {
            if(ObjectFind(0,"znBuy15mSL1")>=0)
              {
               ObjectDelete(0,"znBuy15mSL1");
               Print("取消最近的一根止损线 继续按取消");
               comment4("取消最近的一根止损线 继续按取消");
               return;
              }
            else
              {
               if(ObjectFind(0,"znBuy15mSL2")>=0)
                 {
                  ObjectDelete(0,"znBuy15mSL2");
                  Print("取消最近的二根止损线 继续按取消");
                  comment4("取消最近的二根止损线 继续按取消");
                  return;
                 }
               else
                 {
                  menu6[6]=true;
                  Print("15分钟追buy单智能设止损线 关闭 ");
                  comment3("15分钟追buy单智能设止损线 关闭 ");
                  ObjectDelete(0,"znBuy15mSL1");
                  ObjectDelete(0,"znBuy15mSL2");
                  ObjectDelete(0,"znBuy15mSL3");
                  znBuy15mSL1=false;
                  znBuy15mSL2=false;
                  znBuy15mSL3=false;
                 }
              }
           }
         else
           {
            Print("15分钟追buy单智能设止损线 启动 ");
            comment3("15分钟追buy单智能设止损线 启动 ");
            if(ObjectFind(0,"znBuy15mSL1")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy15mSL1",OBJ_RECTANGLE,0,tpriceK15[zn15mSL1bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL1bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL1bar,0)]+zn15mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy15mSL1",OBJPROP_BACK,false);
               ObjectSet("znBuy15mSL1",OBJPROP_WIDTH,1);
               ObjectSet("znBuy15mSL1",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy15mSL1",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线1");
              }
            if(ObjectFind(0,"znBuy15mSL2")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy15mSL2",OBJ_RECTANGLE,0,tpriceK15[zn15mSL2bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL2bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL2bar,0)]+zn15mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy15mSL2",OBJPROP_BACK,false);
               ObjectSet("znBuy15mSL2",OBJPROP_WIDTH,1);
               ObjectSet("znBuy15mSL2",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy15mSL2",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线2");
              }
            if(ObjectFind(0,"znBuy15mSL3")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znBuy15mSL3",OBJ_RECTANGLE,0,tpriceK15[zn15mSL3bar-1],lpriceK15[ArrayMinimum(lpriceK15,zn15mSL3bar,0)]+zn15mBuySLpianyi*Point-diancha,Time[0]+2500,lpriceK15[ArrayMinimum(lpriceK15,zn15mSL3bar,0)]+zn15mBuySLpianyi*Point-diancha);
               ObjectSet("znBuy15mSL3",OBJPROP_BACK,false);
               ObjectSet("znBuy15mSL3",OBJPROP_WIDTH,1);
               ObjectSet("znBuy15mSL3",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znBuy15mSL2",OBJPROP_TOOLTIP,"15分钟Buy单智能止损线2");
              }
           }
        }
      if(sparam == pre6 + IntegerToString(7))//按钮8
        {
         if(menu6[7])
           {
            if(ObjectFind(0,"znSell15mSL1")>=0)
              {
               ObjectDelete(0,"znSell15mSL1");
               Print("取消最近的一根止损线 继续按取消");
               comment4("取消最近的一根止损线 继续按取消");
               return;
              }
            else
              {
               if(ObjectFind(0,"znSell15mSL2")>=0)
                 {
                  ObjectDelete(0,"znSell15mSL2");
                  Print("取消最近的二根止损线 继续按取消");
                  comment4("取消最近的二根止损线 继续按取消");
                  return;
                 }
               else
                 {
                  menu6[7]=true;
                  Print("15分钟追Sell单智能设止损线 关闭 ");
                  comment3("15分钟追Sell单智能设止损线 关闭 ");
                  ObjectDelete(0,"znSell15mSL1");
                  ObjectDelete(0,"znSell15mSL2");
                  ObjectDelete(0,"znSell15mSL3");
                  znSell15mSL1=false;
                  znSell15mSL2=false;
                  znSell15mSL3=false;
                 }
              }
           }
         else
           {
            Print("15分钟追Sell单智能设止损线 启动 ");
            comment3("15分钟追Sell单智能设止损线 启动 ");
            if(ObjectFind(0,"znSell15mSL1")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znSell15mSL1",OBJ_RECTANGLE,0,tpriceK15[zn15mSL1bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL1bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL1bar,0)]+zn15mSellSLpianyi*Point+diancha);
               ObjectSet("znSell15mSL1",OBJPROP_BACK,false);
               ObjectSet("znSell15mSL1",OBJPROP_WIDTH,1);
               ObjectSet("znSell15mSL1",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell15mSL1",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线1");
              }
            if(ObjectFind(0,"znSell15mSL2")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znSell15mSL2",OBJ_RECTANGLE,0,tpriceK15[zn15mSL2bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL2bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL2bar,0)]+zn15mSellSLpianyi*Point+diancha);
               ObjectSet("znSell15mSL2",OBJPROP_BACK,false);
               ObjectSet("znSell15mSL2",OBJPROP_WIDTH,1);
               ObjectSet("znSell15mSL2",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell15mSL2",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线2");
              }
            if(ObjectFind(0,"znSell15mSL3")<0)      //第一次启动运行
              {
               ObjectCreate(0,"znSell15mSL3",OBJ_RECTANGLE,0,tpriceK15[zn15mSL3bar-1],hpriceK15[ArrayMaximum(hpriceK15,zn15mSL3bar,0)]+zn15mSellSLpianyi*Point+diancha,Time[0]+2500,hpriceK15[ArrayMaximum(hpriceK15,zn15mSL3bar,0)]+zn15mSellSLpianyi*Point+diancha);
               ObjectSet("znSell15mSL3",OBJPROP_BACK,false);
               ObjectSet("znSell15mSL3",OBJPROP_WIDTH,1);
               ObjectSet("znSell15mSL3",OBJPROP_COLOR,clrCrimson);
               ObjectSetString(0,"znSell15mSL3",OBJPROP_TOOLTIP,"15分钟Sell单智能止损线3");
              }
           }
        }
      if(sparam == pre6 + IntegerToString(8))//按钮9
        {
         if(menu6[8])
           {
            ObjectDelete(0,"2kbuySL1");
            Print("连续两个阳线设止损线于阳线最低点 关闭 ");
            comment4("连续两个阳线设止损线于阳线最低点 关闭");
           }
         else
           {
            TrendLine("2kbuySL1",Time[2],Low[2]-pianyilingGlo,Time[0]+2500,Low[2]-pianyilingGlo,Red,"连续两个阳线设止损线于阳线最低点");
            Print("连续两个阳线设止损线于阳线最低点 开启");
            comment4("连续两个阳线设止损线于阳线最低点 开启");
           }
        }
      if(sparam == pre6 + IntegerToString(9))//按钮10
        {
         if(menu6[9])
           {
            ObjectDelete(0,"2ksellSL1");
            Print("连续两个阴线设止损线于阴线最高点 关闭 ");
            comment4("连续两个阴线设止损线于阴线最高点 关闭");
           }
         else
           {
            TrendLine("2ksellSL1",Time[2],High[2]+pianyilingGlo,Time[0]+2500,High[2]+pianyilingGlo,clrBrown,"连续两个阴线设止损线于阴线最高点");
            Print("连续两个阴线设止损线于阴线最高点 开启");
            comment4("连续两个阴线设止损线于阴线最高点 开启");
           }
        }
      if(sparam == pre6 + IntegerToString(10))//按钮11
        {
         if(menu6[10])
           {
            menu6[10]=true;
            AutoStoploss=true;
            AutoTakeProfit=true;
            Print("参考ATR指标设置止盈止损 关闭 ");
            comment3("参考ATR指标设置止盈止损 关闭 ");

           }
         else
           {
            AutoStoploss=false;
            AutoTakeProfit=false;
            Print("参考ATR指标设置止盈止损 启动 ");
            comment3("参考ATR指标设置止盈止损 启动 ");

           }
        }
      if(sparam == pre6 + IntegerToString(11))//按钮12
        {

        }
      if(sparam == pre6 + IntegerToString(12))//按钮13
        {

        }
      ////////////////////////////////////////////////////////////////////////////////////指标相关 副图1 执行代码 按钮31 mmm31
      if(sparam == pre31 + IntegerToString(0))//按钮1
        {
         if(!iBreakoutSLpingcang)
           {
            iBreakoutSLpingcang=true;
            Print("突破箱体 等待60秒 未返回 直接止损 启动");
            comment("突破箱体 等待60秒 未返回 直接止损 启动");
           }
         else
           {
            iBreakoutSLpingcang=false;
            Print("突破箱体 等待60秒 未返回 直接止损 关闭");
            comment("突破箱体 等待60秒 未返回 直接止损 关闭");
            menu31[0]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(1))//按钮2
        {
         if(!iBreakoutSLpingcangNow)
           {
            iBreakoutSLpingcangNow=true;
            Print("突破箱体 直接止损 启动 参数 ",iBreakoutSLpingcangNowmax);
            comment(StringFormat("突破箱体 直接止损 启动 参数 %G",iBreakoutSLpingcangNowmax));
           }
         else
           {
            iBreakoutSLpingcangNow=false;
            Print("突破箱体 直接止损 关闭");
            comment("突破箱体 直接止损 关闭");
            menu31[1]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(2))//按钮3
        {
         if(iBreakout==false)
           {
            iBreakout=true;
            iBreakout15=false;
            iBreakoutfanshou=false;
            iBreakoutfanshou15=false;
            Print("当前图表参考Breakout指标 自动平仓 开启");
            comment1("当前图表参考Breakout指标 自动平仓 开启");
           }
         else
           {
            iBreakout=false;
            iBreakout15=false;
            iBreakoutfanshou=false;
            iBreakoutfanshou15=false;
            iBreakoutkaicangbuy=false;
            iBreakoutkaicangsell=false;
            Print("当前图表参考Breakout指标 自动平仓 关闭");
            Print("当前图表参考Breakout指标 全平后反手开仓 关闭");
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
            comment1("当前图表参考Breakout指标 功能 关闭");
            menu31[2]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(3))//按钮4
        {
         if(iBreakoutfanshou==false)
           {
            iBreakoutfanshou=true;
            iBreakoutfanshou15=false;
            Print("当前图表参考Breakout指标 全平后反手开仓 开启");
            comment1("当前图表参考Breakout指标 全平后反手开仓 开启");
           }
         else
           {
            iBreakoutfanshou=false;
            iBreakoutfanshou15=false;
            Print("当前图表参考Breakout指标 全平后反手开仓 关闭");
            comment1("当前图表参考Breakout指标 全平后反手开仓 关闭");
            menu31[3]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(4))//按钮5
        {
         if(iBreakoutkaicangbuy==false)
           {
            iBreakoutkaicangbuy=true;
            iBreakoutkaicangsell=false;;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式Buy单开仓 开启");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式Buy单开仓 开启");
           }
         else
           {
            iBreakoutkaicangbuy=false;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式开仓 关闭");
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            if(ObjectFind(0,"SL Line")==0)
               ObjectDelete(0,"SL Line");
            menu31[4]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(5))//按钮6
        {
         if(iBreakoutkaicangsell==false)
           {
            iBreakoutkaicangbuy=false;
            iBreakoutkaicangsell=true;;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式Sell单开仓 开启");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式Sell单开仓 开启");
           }
         else
           {
            iBreakoutkaicangsell=false;
            Print("当前图表参考Breakout指标矩形横线位置启动横线模式Sell单开仓 关闭");
            comment1("当前图表参考Breakout指标矩形横线位置启动横线模式Sell单开仓 关闭");
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            if(ObjectFind(0,"SL Line")==0)
               ObjectDelete(0,"SL Line");
            menu31[5]=true;
           }
        }
      if(sparam == pre31 + IntegerToString(6))
        {
         if(breakoutNot==false)
           {
            breakoutNot=true;
            breakoutNot1=true;
            Print("当前图表参考Breakout指标 突破提醒 开启");
            comment1("当前图表参考Breakout指标 突破提醒 开启");
            menu31[6]=true;
           }
         else
           {
            breakoutNot=false;
            breakoutNot1=false;
            Print("当前图表参考Breakout指标 突破提醒 关闭");
            comment1("当前图表参考Breakout指标 突破提醒 关闭");

           }
        }
      /////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////// mmmm

      if(sparam == pre + "v")//隐藏按钮
        {
         //close_bool = true;//当有主菜单的时候再启用
         if(ObjectFind(0,pre+"title")==0)
           {
            Print("按下隐藏按钮");
            ObjectsDeleteAll(0, pre);//删除所有包含此物件前缀名的对象
            Draw_button0();
            for(int i = 0; i < menu_zs; i++)
              {
               if(menu[i] || menu1[i] || menu2[i] || menu3[i] || menu4[i] || menu5[i] || menu6[i])
                 {
                  ObjectSetInteger(0, pre + "v", OBJPROP_BGCOLOR, Red);
                  Print("按钮有被按下的 请确认 没有监控任务在 执行中 ");
                  comment4("按钮有被按下的 请确认 没有监控任务 在执行中 ");
                  return;
                 }
              }
            for(int i = 0; i < menu_zs8; i++)
              {
               if(menu8[i] || menu31[i] || menu12[i] || menu13[i] || menu223[i])
                 {
                  ObjectSetInteger(0, pre + "v", OBJPROP_BGCOLOR, Red);
                  Print("按钮有被按下的 请确认 没有监控任务在 执行中 ");
                  comment4("按钮有被按下的 请确认 没有监控任务 在执行中 ");
                  return;
                 }
              }
           }
         else
           {
            Draw_button_zhu();   //绘主菜单图
            Draw_button();   //1绘图
            Draw_button2();   //2绘主菜单图
            Draw_button3();   //3绘主菜单图
            Draw_button4();   //4绘主菜单图
            Draw_button5();   //5绘主菜单图
            Draw_button6();   //5绘主菜单图
            ObjectSetInteger(0, pre + "v", OBJPROP_BGCOLOR, COLOR_ENABLE);
           }

        }

      if(sparam == pre1 + "title")//隐藏下拉菜单1 常用
        {
         view_but1 = !view_but1;
         Draw_button_zhu();//
         for(int i = 0; i < menu_zs_zhu; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu1[i])
              {
               ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre + "title")//隐藏下拉菜单2
        {
         view_but = ! view_but;
         Draw_button();//用于移动后重绘制
         for(int i = 0; i < menu_zs; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu[i])
              {
               ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre2 + "title")//隐藏下拉菜单3
        {
         ObjectsDeleteAll(0,pre31);
         view_but2 = !view_but2;
         Draw_button2();//
         for(int i = 0; i < menu_zs2; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu2[i])
              {
               ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre3 + "title")//隐藏下拉菜单4
        {
         view_but3 = !view_but3;
         Draw_button3();//
         for(int i = 0; i < menu_zs3; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu3[i])
              {
               ObjectSetInteger(0, pre3 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre3 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre4 + "title")//隐藏下拉菜单5
        {
         view_but4 = !view_but4;
         Draw_button4();//
         for(int i = 0; i < menu_zs4; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu4[i])
              {
               ObjectSetInteger(0, pre4 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre4 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre5 + "title")//隐藏下拉菜单6
        {
         view_but5 = !view_but5;
         Draw_button5();//
         for(int i = 0; i < menu_zs5; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu5[i])
              {
               ObjectSetInteger(0, pre5 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre5 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      if(sparam == pre6 + "title")//隐藏下拉菜单6
        {
         view_but6 = !view_but6;
         Draw_button6();//
         for(int i = 0; i < menu_zs6; i++)//重绘后 读取一遍按钮状态 改变背景色
           {
            if(menu6[i])
              {
               ObjectSetInteger(0, pre6 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre6 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs; i++)//循环获取按键 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre + IntegerToString(i))
           {
            menu[i] = !menu[i];
            if(menu[i])//设置颜色
              {
               ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs12; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre12 + IntegerToString(i))
           {
            menu12[i] = !menu12[i];
            if(menu12[i])//设置颜色
              {
               ObjectSetInteger(0, pre12 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre12 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs13; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre13 + IntegerToString(i))
           {
            menu13[i] = !menu13[i];
            if(menu13[i])//设置颜色
              {
               ObjectSetInteger(0, pre13 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre13 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs14; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre14 + IntegerToString(i))
           {
            menu14[i] = !menu14[i];
            if(menu14[i])//设置颜色
              {
               ObjectSetInteger(0, pre14 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre14 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs15; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre15 + IntegerToString(i))
           {
            menu15[i] = !menu15[i];
            if(menu15[i])//设置颜色
              {
               ObjectSetInteger(0, pre15 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre15 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs223; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre223 + IntegerToString(i))
           {
            menu223[i] = !menu223[i];
            if(menu223[i])//设置颜色
              {
               ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre223 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs224; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre224 + IntegerToString(i))
           {
            menu224[i] = !menu224[i];
            if(menu224[i])//设置颜色
              {
               ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre224 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs31; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色 循环改变状态
        {
         if(sparam == pre31 + IntegerToString(i))
           {
            menu31[i] = !menu31[i];
            if(menu31[i])//设置颜色
              {
               ObjectSetInteger(0, pre31 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre31 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs_zhu; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre1 + IntegerToString(i))
           {
            menu1[i] = !menu1[i];
            if(menu1[i])//设置颜色
              {
               ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre1 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs2; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre2 + IntegerToString(i))
           {
            menu2[i] = !menu2[i];
            if(menu2[i])//设置颜色
              {
               ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre2 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs3; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre3 + IntegerToString(i))
           {
            menu3[i] = !menu3[i];
            if(menu3[i])//设置颜色
              {
               ObjectSetInteger(0, pre3 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre3 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs4; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre4 + IntegerToString(i))
           {
            menu4[i] = !menu4[i];
            if(menu4[i])//设置颜色
              {
               ObjectSetInteger(0, pre4 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre4 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs5; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre5 + IntegerToString(i))
           {
            menu5[i] = !menu5[i];
            if(menu5[i])//设置颜色
              {
               ObjectSetInteger(0, pre5 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre5 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs6; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre6 + IntegerToString(i))
           {
            menu6[i] = !menu6[i];
            if(menu6[i])//设置颜色
              {
               ObjectSetInteger(0, pre6 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre6 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      for(int i = 0; i < menu_zs8; i++)//循环获取按键时 按下 还是没 按下 按下是 true 并改变背景色
        {
         if(sparam == pre8 + IntegerToString(i))
           {
            menu8[i] = !menu8[i];
            if(menu8[i])//设置颜色
              {
               ObjectSetInteger(0, pre8 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_ENABLE);
              }
            else
              {
               ObjectSetInteger(0, pre8 + IntegerToString(i), OBJPROP_BGCOLOR, COLOR_DISABLE);
              }
           }
        }
      //////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(id == CHARTEVENT_OBJECT_DRAG)//拖动 鼠标移动 图表中的 对象
     {
      string name = pre + "title";
      string name1 = pre1 + "title";
      string name2 = pre2 + "title";
      string name3 = pre3 + "title";
      string name4 = pre4 + "title";
      string name5 = pre5 + "title";
      string name6 = pre6 + "title";
      string name8 = pre8 + "title";
      string name31 = pre31 + "title";
      string name12 = pre12 + "title";
      string name13 = pre13 + "title";
      string name14 = pre14 + "title";
      string name15 = pre15 + "title";
      string name223 = pre223 + "title";
      string name224 = pre224 + "title";
      if(sparam == name223)
        {
         if(ObjectFind(0, name223) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x223 = (int)ObjectGetInteger(0, pre223 + "title", OBJPROP_XDISTANCE);
            but_y223 = (int)ObjectGetInteger(0, pre223 + "title", OBJPROP_YDISTANCE);
            Draw_button223();//用于移动后重绘制
            ObjectSetInteger(0, pre223 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name224)
        {
         if(ObjectFind(0, name224) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x224 = (int)ObjectGetInteger(0, pre224 + "title", OBJPROP_XDISTANCE);
            but_y224 = (int)ObjectGetInteger(0, pre224 + "title", OBJPROP_YDISTANCE);
            Draw_button224();//用于移动后重绘制
            ObjectSetInteger(0, pre224 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name12)
        {
         if(ObjectFind(0, name12) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x12 = (int)ObjectGetInteger(0, pre12 + "title", OBJPROP_XDISTANCE);
            but_y12 = (int)ObjectGetInteger(0, pre12 + "title", OBJPROP_YDISTANCE);
            Draw_button12();//用于移动后重绘制
            ObjectSetInteger(0, pre12 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name13)
        {
         if(ObjectFind(0, name13) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x13 = (int)ObjectGetInteger(0, pre13 + "title", OBJPROP_XDISTANCE);
            but_y13 = (int)ObjectGetInteger(0, pre13 + "title", OBJPROP_YDISTANCE);
            Draw_button13();//用于移动后重绘制
            ObjectSetInteger(0, pre13 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name14)
        {
         if(ObjectFind(0, name14) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x14 = (int)ObjectGetInteger(0, pre14 + "title", OBJPROP_XDISTANCE);
            but_y14 = (int)ObjectGetInteger(0, pre14 + "title", OBJPROP_YDISTANCE);
            Draw_button14();//用于移动后重绘制
            ObjectSetInteger(0, pre14 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name15)
        {
         if(ObjectFind(0, name15) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x15 = (int)ObjectGetInteger(0, pre15 + "title", OBJPROP_XDISTANCE);
            but_y15 = (int)ObjectGetInteger(0, pre15 + "title", OBJPROP_YDISTANCE);
            Draw_button15();//用于移动后重绘制
            ObjectSetInteger(0, pre15 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name31)
        {
         if(ObjectFind(0, name31) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x31 = (int)ObjectGetInteger(0, pre31 + "title", OBJPROP_XDISTANCE);
            but_y31 = (int)ObjectGetInteger(0, pre31 + "title", OBJPROP_YDISTANCE);
            Draw_button31();//用于移动后重绘制
            ObjectSetInteger(0, pre31 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name)
        {
         if(ObjectFind(0, name) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x = (int)ObjectGetInteger(0, pre + "title", OBJPROP_XDISTANCE);
            but_y = (int)ObjectGetInteger(0, pre + "title", OBJPROP_YDISTANCE);
            Draw_button();//用于移动后重绘制
            ObjectSetInteger(0, pre + "title", OBJPROP_SELECTED, true);
           }
        }

      if(sparam == name1)
        {
         if(ObjectFind(0, name1) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_zhu_x = (int)ObjectGetInteger(0, pre1 + "title", OBJPROP_XDISTANCE);
            but_zhu_y = (int)ObjectGetInteger(0, pre1 + "title", OBJPROP_YDISTANCE);
            Draw_button_zhu();//用于移动后重绘制
            ObjectSetInteger(0, pre1 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name2)
        {
         if(ObjectFind(0, name2) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x2 = (int)ObjectGetInteger(0, pre2 + "title", OBJPROP_XDISTANCE);
            but_y2 = (int)ObjectGetInteger(0, pre2 + "title", OBJPROP_YDISTANCE);
            Draw_button2();//用于移动后重绘制
            ObjectSetInteger(0, pre2 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name3)
        {
         if(ObjectFind(0, name3) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x3 = (int)ObjectGetInteger(0, pre3 + "title", OBJPROP_XDISTANCE);
            but_y3 = (int)ObjectGetInteger(0, pre3 + "title", OBJPROP_YDISTANCE);
            Draw_button3();//用于移动后重绘制
            ObjectSetInteger(0, pre3 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name4)
        {
         if(ObjectFind(0, name4) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x4 = (int)ObjectGetInteger(0, pre4 + "title", OBJPROP_XDISTANCE);
            but_y4 = (int)ObjectGetInteger(0, pre4 + "title", OBJPROP_YDISTANCE);
            Draw_button4();//用于移动后重绘制
            ObjectSetInteger(0, pre4 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name5)
        {
         if(ObjectFind(0, name5) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x5 = (int)ObjectGetInteger(0, pre5 + "title", OBJPROP_XDISTANCE);
            but_y5 = (int)ObjectGetInteger(0, pre5 + "title", OBJPROP_YDISTANCE);
            Draw_button5();//用于移动后重绘制
            ObjectSetInteger(0, pre5 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name6)
        {
         if(ObjectFind(0, name6) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x6 = (int)ObjectGetInteger(0, pre6 + "title", OBJPROP_XDISTANCE);
            but_y6 = (int)ObjectGetInteger(0, pre6 + "title", OBJPROP_YDISTANCE);
            Draw_button6();//用于移动后重绘制
            ObjectSetInteger(0, pre6 + "title", OBJPROP_SELECTED, true);
           }
        }
      if(sparam == name8)
        {
         if(ObjectFind(0, name8) == 0)   //设置移动后的标题坐标,并防止超出窗口
           {
            but_x8 = (int)ObjectGetInteger(0, pre8 + "title", OBJPROP_XDISTANCE);
            but_y8 = (int)ObjectGetInteger(0, pre8 + "title", OBJPROP_YDISTANCE);
            Draw_button8();//用于移动后重绘制
            ObjectSetInteger(0, pre8 + "title", OBJPROP_SELECTED, true);
           }
        }

     }
  }
////////////////////////////////////////////////////////////////// mmmm
//////////////////////////////////////////////////////////////////////////画按钮
void Draw_button_zhu()//画常用菜单按钮 mmm1
  {
   string ostr1[menu_zs_zhu][3] =//数组不要超过2维
     {
        {"", "根据最近几根K线形态>", "建议在5分钟或者15分钟图表上 根据最近几根K线形态 参考阴线 阳线 最高 最低价 0K是当前K线 1K是最近的一根收盘K线 类推 有些功能开启 没有文字提示 看按钮的颜色 按下就是开启 图表需要调整到相应的时间周期"},
        {"", "根据时间或K线形态>", "根据时间或K线形态 参考时间 阴线 阳线 最高 最低价"},
        {"", "划趋势线模式>", "首先在图表当前价的上方和下方划一条或两条趋势线 以趋势线为基础执行一些指令 不是横线 启用前请先把 图表其他线 删除"},
        {"", "各种止损>", "各种止损"},
        {"", "备用>", "备用"},
        {"", "备用", "备用"},
        {"", "备用", "备用"},
        {"", "一键全平", "当前货币对全平 Ctrl+Alt+P键 "},
        {"", "一键平多单", "一键平多单 Ctrl+Alt+B键 Ctrl+Alt+PageDown 平最近下的一Buy单"},
        {"", "一键平空单", "一键平空单 Ctrl+Alt+S键 Ctrl+Alt+End 平最近下的一Sell单"},
        {"", "一键反手", "当前货币对全平后反手 Ctrl+Alt+F键"},
        {"", "一键锁仓", "一键锁仓 Shift+小键盘0 反锁时 止盈止损 自动分步平仓都不运行 但解锁时 需注意 安全起见 先关闭分步平仓 Tab+主键盘数字0"},
        {"", "反锁后取消止盈止损", "反锁后取消止盈止损 Tab+ Esc 键"},
        {"", "一键平挂单", "一键平挂单 Shift+G "},
        {"", "带止损下单模式", "按小键盘9 或 6 下单时 带止损 根据最近几根K线的最高或最低点加点差偏移 确定止损位 快捷键 小键盘“ 0 ” 重复按 减少K线 启动后 按ShiftR 300秒内 按一分钟图表计算最高最低价"},
        {"", "设置止盈位在保本线", "批量设置止盈位在保本线上,默认Ctrl+Alt+ T 键  提前按一下B/S可分别操作"},
        {"", "设置止损位在保本线", "批量设置止损位在保本线上,默认Ctrl+Alt+ L 键  提前按一下B/S可分别操作"},
        {"", "未设置", "未设置"},
        {"", "关闭EA的部分功能", "EA运行总开关 临时关闭 Tab+主键盘0 再按一下 分布平仓临时关闭 可以多次点击"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_zhu_x;//按钮在图表的位置
   int y = but_zhu_y;//按钮在图表的位置
   EditCreate(false, pre1 + "title","常用菜单", "点击显示下拉框 可拖动 小键盘9开多单 小键盘6开空单 平最近一单 PageDown键 平最早一单 End 键 平价格最高的一单 Insert 键 平价格最低的一单 Delete键 下单前按一下小键盘0 带止损下单 ", but_zhu_x, but_zhu_y, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs_zhu ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but1, pre1 + IntegerToString(i),ostr1[i][1],ostr1[i][2],x, y,Edit_w, Edit_h);
     }
  }
////////////////////////////////////////////////////////////////////////////////////
void Draw_button0()//画按钮 隐藏按钮开关
  {
   int Edit_w = d(15); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_zhu_x;//按钮在图表的位置
   int y = but_zhu_y;//按钮在图表的位置
//   EditCreate(false, pre + "title","横线模式", "点击显示下拉框 可拖动 ", but_x, but_y, Edit_w, Edit_h,true); //标题不可编辑,可移动
   EditCreate(false, pre + "v","2", "显示或隐藏按钮", x - Edit_w, y, Edit_w, Edit_h); //标题不可编辑,可移动
   ObjectSetString(0, pre + "v", OBJPROP_FONT, "Webdings");
//   EditCreate(false, pre + "r","r", "关闭", but_x - Edit_w + Edit_h, but_y, Edit_h, Edit_h); //标题不可编辑,可移动
//  ObjectSetString(0, pre + "r", OBJPROP_FONT, "Webdings");
  }
//////////////////////////////////////////////////////////////
void Draw_button()//画按钮1 横线模式相关按钮 mmm2
  {
   /*  if(close_bool)//有主菜单时用
       {
        ObjectsDeleteAll(0, pre);
        return;
       }*/
   string ostr[menu_zs][3] =//数组不要超过2维
     {
        {"", "移动Buy Line横线", "移动Buy Line横线 按 Q 键 切换或清除横线"},
        {"", "移动Sell Line横线", "移动Sell Line横线 按 Q 键 切换或清除横线"},
        {"", "移动SL Line止损横线", "移动SL Line止损横线"},
        {"", "清除图表横线", "清除图表横线 按Q键可快速切换 W S 上下移动"},
        {"", "开仓没止损", "默认以时间为唯一参考 开仓不论价位 没止损 适合快行情 按X键 调出止损线 可以带止损开单 突破单移动对应的横线越过当前价格就可以用"},
        {"", "开仓参考时间价格带止损", "位置和时间都参考止损7K 最近7根K线计算最高最低点再偏移一些作为止损 适合慢行情"},
        {"", "开仓参考时间价格无止损", "不带止损开仓参考时间和位置 按左右方向键减少或增加开仓次数 按上下方向键增加或减少1秒时间间隔"},
        {"", "开仓只开一次", "只开一次仓，需要提前按右方向键增加开仓仓位"},
        {"", "在横线位置挂单", "直接在横线位置挂单 提前按方向键左右键减少或增加挂单个数 方向键上下键增加或减少挂单间距 提前按右边Ctrl 挂反向stop单 按/键挂单仓位减半"},
        {"", "在横线位置挂单带止损", "直接在横线位置挂单7K 50 提前按方向键左右键减少或增加挂单个数 方向键上下键增加或减少挂单间距 带止损 可提前生成SL Line止损横线"},
        {"", "平仓", "触线直接平仓 激活触线前 按主数字键1~9 只平仓最近下的多少单 提前按Tab键 定时器模式全平仓 默认Tick模式全平"},
        {"", "越过横线一单一单平仓", "越过横线一单一单平仓 速度慢 但可能有更多利润空间 默认间隔2s 注意严格要求Buy单用绿线 Sell单用红线 平仓"},
        {"", "全平后挂反向单", "全平后距现价移动多少点 挂反向追单 上下方向键可以增大偏移量"},
        {"", "止损时回撤止损", "触线想等回撤几个点再止损 触线修改止盈止损 反向移动几个点后全止盈 薅羊毛有风险"},
        {"", "止损时回撤止损后反手", "触线想等回撤几个点再止损 当订单触及新的止损线时 同时开反向追单 可以鼠标微调开仓横线的位置"},
        {"", "只平Buy单", "触线只平Buy单"},
        {"", "只平Sell单", "触线只平Sell单"},
        {"", "反锁", "触及横线反锁"},
        {"", "横线处挂反锁单", "直接在横线处挂反锁单 平台提前知道了你的止损点 有可能被黑"},
        {"", "全平后反手追", "触线全平后反手开仓"},
        {"", "横线处止盈", "横线处设置止盈 提前按右边的Shift 统一止赢位 提前按主键盘1-9只处理最近多少单 红线只处理Buy单止损 绿线只处理Sell单止损 止盈颜色相反"},
        {"", "横线处止损", "横线处设置止损 提前按右边的Shift 统一止损位 提前按主键盘1-9只处理最近多少单 红线只处理Buy单止损 绿线只处理Sell单止损 止盈颜色相反"},
        {"", "===更多辅助功能===>", "更多辅助 自动移动横线的 功能 "},
        {"", "===更多 功能===>", "更多横线模式的 主要功能 由于功能太多 只能放三级目录了"},
        {"", "5分钟K线实体越线平仓", "触线后 等五分钟收K线时 判断K线实体是否越线 再平仓 上下引线忽略 如成功 移动横线到K线最高或最低点继续执行越线平仓 只在止损平仓时使用 多单用Buy Line 空单用Sell Line"},
        {"", "全平后后移几点反手追", "触线平仓后 把横线后移几个点 再触线时反手追 中间留一点空间"},
        {"", "渐进式触线开仓", "越过横线开一单 然后后移横线一个点 再越过横线 继续开一单 类推 默认0.5个点间距 按X键调出止损线 会同时启动等待30s越线后平仓\n启动前按左右方向键 减少或增加开仓次数 上键增加移动横线的间距 下键减小间距 如果是负数 变成顺式加仓 但第一单还是正向的 Tab+L+K"},
        {"", "小阻力先平仓实体越过再开", "下单盈利后经常会遇到小阻力位回撤后延续行情的情况 两种解决方法 一种先平仓 回撤时再开 一种K线实体越过阻力点时\n再重新开同样的仓位追 默认5分钟收盘后运行一次 提前按ShiftR 越线直接追20秒运行一次 和下面的策略性平仓 结合使用 注意调整到适合自己的参数"},
        {"", "策略性平仓回撤再追单薅羊毛", "追单时到达一个阻力区域时先平仓 回撤几个点后 程序自动开原来的仓位 继续追 薅羊毛 可以和上面的 小阻力先平仓 同时开启 开仓成功后记得关闭其中一个\n策略性平仓触发后 会自动取消 小阻力先平仓 反之不会 按/键 回撤偏移减半"},
        {"", "反锁后再回撤几个点平原来的单", "确定下单方向错误 回撤时先反锁 再多回撤几个点后 把之前错误的仓位平仓掉 留下反锁的一笔订单 "},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x;//按钮在图表的位置
   int y = but_y;//按钮在图表的位置
   EditCreate(false, pre + "title","横线模式", "点击显示下拉框 可拖动 横线模式按钮太多 如果发现运行异常 重新加载EA ", but_x, but_y, Edit_w, Edit_h,true); //标题不可编辑,可移动
// EditCreate(false, pre + "v","2", "显示隐藏", but_x - Edit_w + Edit_h * 2, but_y, Edit_h, Edit_h); //标题不可编辑,可移动
// ObjectSetString(0, pre + "v", OBJPROP_FONT, "Webdings");
//   EditCreate(false, pre + "r","r", "关闭", but_x - Edit_w + Edit_h, but_y, Edit_h, Edit_h); //标题不可编辑,可移动
//  ObjectSetString(0, pre + "r", OBJPROP_FONT, "Webdings");
   for(int i = 0; i < menu_zs ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but, pre + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button2()//画按钮2 指标相关 mmm3
  {
   string ostr[menu_zs2][3] =//数组不要超过2维
     {
        {"", "Breakout指标 >", "Breakout指标"},
        {"", "MBFX指标自动平仓", "当前图表参考MBFX指标 自动平仓"},
        {"", "震荡时MBFX提示反转平仓", "MBFX指标 出现 亮黄色 反转信号时 平仓 MBFX是震荡指标 行情单边时 请勿使用 "},
        {"", "备", "备"},
        {"", "备", "备"},
        {"", "备", "备"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x2;//按钮在图表的位置
   int y = but_y2;//按钮在图表的位置
   EditCreate(false, pre2 + "title","指标相关", "点击显示下拉框 可拖动 ", but_x2, but_y2, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs2 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but2,pre2 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button3()//画按钮4 mmm4
  {
   string ostr[menu_zs3][3] =//数组不要超过2维
     {
        {"", "总利润模式全平仓", "利润或亏损达到预设的 金额 直接全部平仓 "},
        {"", "总利润模式薅羊毛", "盈利很小就直接平仓 薅羊毛 利润或亏损达到预设的 金额 直接全部平仓"},
        {"", "斐波那契百分比挂多单", "以斐波那契百分比挂单 默认对应K线 11和31 参数较复杂其他请参考设置 慎用"},
        {"", "斐波那契百分比挂空单", "以斐波那契百分比挂单 默认对应K线 11和31 参数较复杂其他请参考设置 慎用"},
        {"", "整数位批量抓回撤追多", "价格在接近整数位时 经常回撤结束 继续当前的趋势 整数位批量抓回撤追多"},
        {"", "整数位批量抓回撤追空", "价格在接近整数位时 经常回撤结束 继续当前的趋势 整数位批量抓回撤追空"},
        {"", "定时器3 追踪止损 一分钟用", "定时计算最近几根K线的最高最低点重新自动设置止盈 止损 追单用 对应K线 11偏移 50  定时60秒  默认只处理最近10单 一分钟上用 启用前需按B多单S空单 "},
        {"", "定时器4 追踪止盈 一分钟用", "对应K线 11偏移 -20  定时60秒 一分钟上用"},
        {"", "定时器5 追踪止损 五分钟用", "对应K线 7 偏移 50 定时300秒  默认只处理最近10单 五分钟上用"},
        {"", "定时器6 追踪止盈 五分钟用", "对应K线 7 偏移 -20 定时300秒  默认只处理最近10单"},
        {"", "多单批量智能止损", "计算最近几根K线的最高 最低点 加上偏移量 作为止盈止损位 b/s+u/h"},
        {"", "空单批量智能止损", "对应K线7 偏移 -20 或 50 五或十五分钟上用"},
        {"", "多单批量智能止盈", "计算最近几根K线的最高 最低点 加上偏移量 作为止盈止损位 b/s+u/h"},
        {"", "空单批量智能止盈", "对应K线7 偏移 -20 或 50 五或十五分钟上用"},
        {"", "总净值低于多少全平仓", "账户总净值低于多少全平仓 参数在 客户端全局参数 里面 设置"},
        {"", "总净值高于多少全平仓", "账户总净值高于多少全平仓 参数在 客户端全局参数 里面 设置"},
        {"", "总利润低于多少全平仓", "总利润模式 盈利后开启 利润如果再回到保本线附近 全平仓 参数在 客户端全局参数 里面 设置"},
        {"", "总利润模式保本后反手", "下单之后亏损 回到保本线后平仓后反手 反方向追单 只有单一货币对订单的时候 才能用"},
        {"", "本金盈利50%后全平仓", "下单后 计算 总利润大于 余额*50% 直接全平仓 不分品种"},
        {"", "未设置", "未设置"},
        {"", "设置全局默认下单手数", "请先手动下一单 手数是您想设置的默认下单手数 再点这个按钮 提示成功 重新加载EA就修改成功了"},
        {"", "全局参数恢复出厂设置", "全局客户端参数 恢复出厂设置 请重新加载EA"},
        {"", "全局禁止声音提醒", "开启后 EA 将停止 声音提醒"},
        {"", "未设置", "未设置"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x3;//按钮在图表的位置
   int y = but_y3;//按钮在图表的位置
   EditCreate(false, pre3 + "title","其他", "点击显示下拉框 可拖动 ", but_x3, but_y3, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs3 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but3,pre3 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button4()//画按钮4 mmm5
  {
   string ostr[menu_zs4][3] =//数组不要超过2维
     {
        {"", "回撤力度过大盖过2K3K提醒", "5分钟K线收盘时 回撤力度过大 实体盖过了2K和3K 报警提醒 声音和文字 M+主键盘2"},
        {"", "遮盖当前未收盘K线", "遮盖当前未收盘K线 以减少波动都行情的判断 Esc快捷键"},
        {"", "Tick剧烈波动时自动平Buy单", "行情忽然大幅波动时平仓 博最大收益 开启前先按一下Ctrl  进入调试模式可以进EA日志 查看细节"},
        {"", "Tick剧烈波动时自动平Sell单", "两个只能同时启动一个 参数是在GBPUSD上测试的 其他货币对 需要进入调试模式看日志 再设置合适的参数"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "K线收盘时实体越线止损", "先按Q键 生成一条止损线 移动到 你想止损的位置 在点这个按钮 它会生成一个独立于横线模式的止损线\n 等到当前K线收盘时 实体越过横线 才止损平仓 上下阴线忽略 如果成功 横线会移动到K线的最高或最低点加偏移\n 这次再触线就直接平仓了 提前按主数字键 只处理最近的几单"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x4;//按钮在图表的位置
   int y = but_y4;//按钮在图表的位置
   EditCreate(false, pre4 + "title","备用", "点击显示下拉框 可拖动 ", but_x4, but_y4, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs4 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but4,pre4 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button5()//画按钮7 自动化 mmm7
  {
   string ostr[menu_zs5][3] =//数组不要超过2维
     {

        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x5;//按钮在图表的位置
   int y = but_y5;//按钮在图表的位置
   EditCreate(false, pre5 + "title","自动化", "点击显示下拉框 可拖动 ", but_x5, but_y5, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs5 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but5,pre5 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button6()//画按钮6 mmm6
  {
   string ostr[menu_zs6][3] =//数组不要超过2维
     {
        {"", "追Buy单准备工作 ", "根据最近的2 3 4 5根K线的最低点或最高点加上偏移量和点差后计算四个止损位 手动按9 6 下单 按“/”在次K线上划开仓线 触及绿线开仓 重复按 由远到近的启动三根绿线  "},
        {"", "追Sell单准备工作 ", "回撤到第一止损位平一单 第二平最近下的两单 类推 越过止损线并不会马上止损 有偏移量和等待时间 快捷键启动Z+“<” “>” 启动后手动取消止损线 按主键盘“/” 短线追单和下面的剥头皮可以一起运行 效果更好" },
        {"", "短线剥头皮追Buy单", "启动后 减小止盈止损的点数 同时生成三条止损线 触及第一第二条平部分仓位 第三条全平 9 6 下单 快捷键Tab+“<”“>” 启动后再按“<”“>”一根一根取消最近的止损线"},
        {"", "短线剥头皮追Sell单", "启动后 按Tab+P 生成一条距离均价多少点的止盈横线  过线一单一单缓慢平仓 按小键盘 * 键批量下很小止盈止损的订单 如果长时间不碰到止盈止损出场，我加了时间限制，按*键下的单时间一到，无论盈亏直接全平  按小键盘“.” 仓位翻倍 "},
        {"", "5分钟追buy单智能设止损线", "根据5分钟图表 计算最近的几根K线的最高价或最低价 加上偏移和点差 生成三根止损线 触及等待几秒钟 如果还不能返回 开始平仓"},
        {"", "5分钟追Sell单智能设止损线", "触及第一根 平两单 类推 启动后 再点击按钮 会取消最近的一根止损线 直到取消 "},
        {"", "15分钟追buy单智能设止损线", "同上 止损线的参数 在设置里，可以调整 "},
        {"", "15分钟追Sell单智能设止损线", "同上"},
        {"", "5分钟连续两根K线收阳设止损", "连续两根K线收阳 设止损线为阳线的最低点加偏移 实体越过平最近三单"},
        {"", "5分钟连续两根K线收阴设止损", "连续两根K线收阴 设止损线为阴线的最高点加偏移 实体越过平最近三单"},
        {"", "参考ATR指标设置止盈止损", "根据ATR指标参数14设置止盈止损 默认止损2倍ATR加上偏移和点差 止盈3倍ATR只有偏移没有考虑点差 有问题请调整偏移 60秒运行一次 一分钟图表不运行\n注意ATR值变小时止盈止损也会变小 仅短线追单时使用 启动后 EA主止盈止损功能关闭"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x6;//按钮在图表的位置
   int y = but_y6;//按钮在图表的位置
   EditCreate(false, pre6 + "title","短线追单", "只适合一些5分钟或15分钟图表 上涨和下跌速度比较快没有回撤的的货币对 如GBPUSD 慢行情阴阳K线相间的不适合", but_x6, but_y6, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs6 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but6,pre6 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button8()//画副图按钮8 mmm11
  {
   string ostr[menu_zs8][3] =//数组不要超过2维
     {
        {"", "5分钟1K2K颜色相同追单 ", "当前5分钟图表最近两根K线收盘时实体颜色相同时开仓追单 左右方向键 减少或增加开仓个数"},
        {"", "5分钟1K2K相同横线追单", "当前5分钟图表最近两根K线收盘时实体颜色相同时开仓追单 启动横线模式追单 参考时间和价格 无法左右键加仓"},
        {"", "5分钟1K2K颜色相同平仓", "当前5分钟图表最近两根K线收盘时实体颜色相同时平仓 监控状态只能持续很短时间"},
        {"", "5分钟1K2K相同平仓后反手", "当前5分钟图表最近两根K线收盘时实体颜色相同时平仓后反手 监控状态只能持续很短时间"},
        {"", "2k和3K与1K不同平仓", "第二第三根K线和最近收盘的一根K线颜色相反时平仓"},
        {"", "Buy单连收2根阴线平仓", "追多单时连收2根阴线直接平仓"},
        {"", "Sell单连收2根阳线平仓", "追空单时连收2根阳线直接平仓"},
        {"", "Buy单连收3根阴线平仓", "追多单时连收3根阴线直接平仓"},
        {"", "Sell单连收3根阳线平仓", "追空单时连收3根阳线直接平仓"},
        {"", "追Buy单回撤突破2K平仓", "追多单价格回撤 突破了最近的2根K线最低点时先平仓 行情可能停止或陷入震荡  "},
        {"", "追Sell单回撤突破2K平仓", "追空单价格回撤 突破了最近的2根K线最高点时先平仓 行情可能停止或陷入震荡  "},
        {"", "追Buy单回撤突破3K平仓", "追多单价格回撤 突破了最近的3根K线最低点时先平仓 行情可能停止或陷入震荡  "},
        {"", "追Sell单回撤突破3K平仓", "追空单价格回撤 突破了最近的3根K线最高点时先平仓 行情可能停止或陷入震荡  "},
        {"", "5分钟收阳直接开多单追", "5分钟收阳 直接开多单追"},
        {"", "5分钟收阴直接开空单追", "5分钟收阴 直接开空单追"},
        {"", "5分钟收阳横线模式开多单追", "5分钟收阳横线模式开多单追 暂时无法上下方向键调整开仓间隔 左右键调整开仓个数"},
        {"", "5分钟收阴横线模式开空单追", "5分钟收阴横线模式开空单追 暂时无法上下方向键调整开仓间隔 左右键调整开仓个数"},


     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x8;//按钮在图表的位置
   int y = but_y8;//按钮在图表的位置
//EditCreate(false, pre8 + "title","按钮菜单8", "点击显示下拉框 可拖动 ", but_x8, but_y8, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs8 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but8,pre8 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button31()//画按钮31 横线模式相关 按钮mmm31
  {
   string ostr[menu_zs31][3] =//数组不要超过2维
     {
        {"", "突破箱体等待60s止损平仓", "突破箱体等待60秒如果还未返回止损平仓 需要提前加载指标 文件在qq群"},
        {"", "突破箱体直接止损平仓", "突破箱体直接止损平仓 启动前先修改指标参数 第二个是显示箱体 第五个是计算最近多少根K线"},
        {"", "触及箱体平仓", "触及箱体接近100%时平仓"},
        {"", "触及箱体平仓后反手", "触及箱体接近100%时平仓后反手"},
        {"", "次低点横线模式追多", "根据箱体中间的两条线开仓追 止损在箱体突破位加上偏移量"},
        {"", "次高点横线模式追空", "根据箱体中间的两条线开仓追 止损在箱体突破位加上偏移量"},
        {"", "突破时报警提示音", "需提前放入指标和声音文件 快捷键M+主键盘 1 可以设为自动启动"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
        {"", "一次只能开启一个功能", "一次只能开启一个功能 请先关闭"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x31;//按钮在图表的位置
   int y = but_y31;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs31 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but31, pre31 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button12()//画按钮12 mmm12
  {
   string ostr[menu_zs12][3] =//数组不要超过2维
     {
        {"", "五分钟K线收盘时全平仓", "五分钟K线收盘时全平仓 以时间为标准平仓"},
        {"", "十五分钟K线收盘时全平仓", "十五分钟K线收盘时全平仓 以时间为标准平仓"},
        {"", "五分钟K线收盘平仓后反手", "五分钟K线收盘平仓后反手"},
        {"", "十五分钟K线收盘平仓后反手", "十五分钟K线收盘平仓时后反手"},
        {"", "五分钟K线收盘时直接开仓", "五分钟K线收盘时直接开仓 启动前需要有单一方向的订单引导"},
        {"", "十五分钟K线收盘时直接开仓", "十五分钟K线收盘时直接开仓 启动前需要有单一方向的订单引导"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x12;//按钮在图表的位置
   int y = but_y12;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs12 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but12, pre12 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button13()//画按钮13 mmm13
  {
   string ostr[menu_zs13][3] =//数组不要超过2维
     {
        {"", "==触及线开始挂单==", " 触及划线挂单模式开启需要至少一个订单指引挂单方向 下面直接挂单按钮不用 指引"},
        {"", "直接挂Buylimit", "直接挂Buylimit 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "直接挂Selllimit", "直接挂Selllimit 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "直接挂Buystop", "直接挂Buystop 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "直接挂Sellstop", "直接挂Sellstop 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "Buy单直接设置止盈", "Buy单直接设置止盈 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "Buy单直接设置止损", "Buy单直接设置止损 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "Sell单直接设置止盈", "Sell单直接设置止盈 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "==Sell单直接设置止损==", "Sell单直接设置止损 需要第一个按钮 触线挂单开启 并找到趋势线"},
        {"", "触及线开仓", "触及线开仓"},
        {"", "触及线平仓", "触及线平仓 提前按右边的Shift在定时器中运行"},
        {"", "触及线反锁", "触及线反锁 提前按右边的Shift在定时器中运行"},
        {"", "触及线开反向单反锁", "提前按右边的Shift在定时器中运行"},
        {"", "触及布林轨平仓", "触及布林轨平仓 默认参数20 提前按一下右边的Shift在定时器中运行"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x13;//按钮在图表的位置
   int y = but_y13;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs13 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but13, pre13 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button14()//画按钮14 mmm14
  {
   string ostr[menu_zs14][3] =//数组不要超过2维
     {
        {"", "手动设置三道止损线", "Tab+Z 生成止损线 AD移动到合适的位置 有20秒的时间设置，过了就不能动了 再按是生成第二根止损线\n操作步骤一样 一共有三根止损线 取消止损线Shift+Tab+Z \n第一止损线5分钟收盘实体越过平两单 递增 如果影线穿过 移动到影线处 再触及直接平仓三单 递增"},
        {"", "暂未设置1", "暂未设置1"},
        {"", "暂未设置1", "暂未设置1"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x14;//按钮在图表的位置
   int y = but_y14;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs14 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but14, pre14 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button15()//画按钮13 mmm15
  {
   string ostr[menu_zs15][3] =//数组不要超过2维
     {
        {"", "暂未设置1", "暂未设置1"},
        {"", "暂未设置1", "暂未设置1"},
        {"", "暂未设置1", "暂未设置1"},

     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x15;//按钮在图表的位置
   int y = but_y15;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs15 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but15, pre15 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button223()//画按钮223 mmm223
  {
   string ostr[menu_zs223][3] =//数组不要超过2维
     {
        {"", "根据布林带上中下轨移动横线", "点击切换 根据布林带上下轨 或中轨自动移动横线位置 配合横线功能使用 只在横线模式有监控任务时 能启用 参数是Tab+8上的 快捷键H+1"},
        {"", "根据Vegas均线系统移动横线", "Vegas隧道 是指EMA 144 169 288 338 等均线组成的隧道 请先把均线添加到图表  暂时使用4根 点击切换 只在5分钟收盘时移动一次 开启时注意当前价格和均线的位置"},
        {"", "暂未设置1", "暂未设置1"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x223;//按钮在图表的位置
   int y = but_y223;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs223 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but223, pre223 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_button224()//画按钮224 mmm224
  {
   string ostr[menu_zs224][3] =//数组不要超过2维
     {
        {"", "触线等待30秒平仓", "越线等待几十秒 再判断是否越线 如果还没回来 平最近下的几单 启动前按主数字键 改变平仓个数 启动后 独立于横线模式 "},
        {"", "越线缓慢开仓直到返回", "越线缓慢开仓直到返回 如果你认为这个位置非常重要 价格不会停留太久就会回撤 可以启用 默认10秒开仓一次 开仓上限10次\n必须按X键调整止损线的位置才可以启动 上下方向键增加减少间隔开仓时间 左右方向键减少增加开仓个数"},
        {"", "未设置", "未设置"},
        {"", "未设置", "未设置"},
     };
   int Edit_w = d(anjiu_W); //按钮宽
   int Edit_h = d(anjiu_H);//按钮高
   int x = but_x224;//按钮在图表的位置
   int y = but_y224;//按钮在图表的位置
//  EditCreate(true, pre31 + "title","隐藏模式", "点击显示下拉框 可拖动 ", but_x31, but_y31, Edit_w, Edit_h,true); //标题不可编辑,可移动
   for(int i = 0; i < menu_zs224 ; i++)
     {
      y = y + Edit_h;
      EditCreate(view_but224, pre224 + IntegerToString(i),ostr[i][1],ostr[i][2],x, y,Edit_w, Edit_h);
     }
  }
//////////////////////////////////////////////////////////////
void Draw_zhegai()// 遮盖当前未收盘K线
  {

   int Edit_w =500; //按钮宽
   int Edit_h =2000;//按钮高
   int x;//按钮在图表的位置
   int y;
   bool a=ChartTimePriceToXY(0,0,Time[0],Open[0],x,y);
   x=x-2;
//int y = 0;//按钮在图表的位置 OBJPROP_TIME
   EditCreate(false,pre + "zhegai","遮盖当前未收盘K线", "点击", x, 0, Edit_w, Edit_h,false,true,"微软雅黑",10,2,0,0,clrBlack,clrBlack); //标题不可编辑,可移动
  }
//////////////////////////////////////////////////////////////

//创建按钮
void EditCreate(const bool             view,//显示隐藏
                const string           name = "Edit",            // 对象名称
                const string           text = "Text",            // 文本
                const string           tooltip = "\n",            // 提示信息文本
                const int              x = 0,                    // X 坐标
                const int              y = 0,                    // Y 坐标
                const int              width = 50,               // 宽度
                const int              height = 18,              // 高度
                const bool             selection = false,        // 突出移动
                const bool             read_only = true,        // 不可编辑
                const string           font = "微软雅黑",           // 字体
                const int              font_size = anjiu_zt,        // 字体大小
                const ENUM_ALIGN_MODE  align = ALIGN_CENTER,     // 对齐类型
                const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // 图表定位角
                const color            clr = clrBlack,           // 文本颜色
                const color            back_clr = clrWhite,      // 背景色
                const color            border_clr = clrDarkGray,     // 边框颜色 clrNONE
                const bool             back = false,             // 在背景中
                const bool             hidden = false,            // 隐藏在对象列表
                const long             chart_ID = 0,            // 图表 ID
                const int              sub_window = 0,           // 子窗口指数
                const long             z_order = 0)              // 鼠标单击优先
  {
   if(view)
     {
      ObjectDelete(0, name);
      return;
     }
   if(ObjectFind(chart_ID, name) != 0) //找到对象
      ObjectCreate(chart_ID, name, OBJ_EDIT, sub_window, 0, 0);

   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(chart_ID, name, OBJPROP_ALIGN, align);
   ObjectSetInteger(chart_ID, name, OBJPROP_READONLY, read_only);
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
   ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, tooltip);
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
  }
//创建水平线
void HLineCreate(const bool            view,//显示隐藏
                 double                price = 0,         // 线的价格
                 const string          name = "HLine",    // 线的名称
                 const color           clr = clrYellow,      // 线的颜色
                 const ENUM_LINE_STYLE style = STYLE_SOLID, // 线的风格
                 const int             width = 1,         // 线的宽度
                 const bool            back = false,      // 在背景中
                 const bool            selection = true,  // 突出移动
                 const bool            hidden = true,     // 隐藏在对象列表
                 const int             sub_window = 0,    // 子窗口指数
                 const long            chart_ID = 0,      // 图表 ID
                 const long            z_order = 0)       // 鼠标单击优先
  {
   if(!view)
     {
      ObjectDelete(0, name);
      return;
     }
   if(!price)
      price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   if(ObjectFind(chart_ID, name) != 0) //找到对象
      ObjectCreate(chart_ID, name, OBJ_HLINE, sub_window, 0, price);
   else
      ObjectMove(chart_ID, name, 0, 0, price);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
   ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
  }

///////////////////////////////////////////////////////////////////////   图表按钮 代码 结束
/////////////////////////////////////////////////////////嵌入一个划线的指标
void drawTrend(string name,string fang,int zhouqi1,int zhouqi2,int isHigh,color linecolor)
  {
   double p1,p2;
   int bar=0;
   if(isHigh ==0)
     {
      p1 = Low[iLowest(NULL, 0, MODE_LOW, zhouqi1, bar)];
      p2 = Low[iLowest(NULL, 0, MODE_LOW, zhouqi2, bar)];
     }
   else
     {
      p1=High[iHighest(NULL, 0, MODE_HIGH, zhouqi1, bar)];
      p2=High[iHighest(NULL, 0, MODE_HIGH, zhouqi2, bar)];
     }


   int nu1=0,nu2=0;
   for(int i=0; i<zhouqi1+bar; i++)
     {
      if(isHigh ==0)
        {
         if(Low[i]==p1)
           {
            nu1=i;
            break;
           }
        }
      else
        {
         if(High[i]==p1)
           {
            nu1=i;
            break;
           }
        }
     }

   for(int h=0; h<zhouqi2+bar; h++)
     {
      if(isHigh ==0)
        {
         if(Low[h]==p2)
           {
            nu2=h;
            break;
           }
        }
      else
        {
         if(High[h]==p2)
           {
            nu2=h;
            break;
           }
        }
     }
   if(p1!=p2)
     {
      ObjectCreate(name,OBJ_TREND,0,Time[nu1],p1,Time[nu2],p2);
      ObjectSet(name,OBJPROP_COLOR,linecolor);
      ObjectSet(name,OBJPROP_STYLE,STYLE_DOT);

     }
   if(zhouqi1==208 || zhouqi1==104 ||zhouqi1==52)
     {
      ObjectCreate(fang,OBJ_RECTANGLE,0,Time[nu1+4],p1,Time[0],p1+CurrentPeriod()*Point);
     }
   if(zhouqi2 == 26 && isHigh ==0)
     {
      ObjectCreate(fang+"Low",OBJ_RECTANGLE,0,Time[nu2+4],p2,Time[0],p2+CurrentPeriod()*Point);
     }
   if(zhouqi2 == 26 && isHigh ==1)
     {
      ObjectCreate(fang+"High",OBJ_RECTANGLE,0,Time[nu2+4],p2,Time[0],p2+CurrentPeriod()*Point);
     }
   color mycolor=Red;
   if(zhouqi1==208)
     {
      mycolor = Blue;
     }
   if(zhouqi1==104)
     {
      mycolor = Red;
     }
   if(zhouqi1==52)
     {
      mycolor = Yellow;
     }
   if(zhouqi2==26)
     {
      if(isHigh ==0)
        {
         mycolor = Green;
         ObjectSet(fang+"Low",OBJPROP_COLOR,mycolor);
        }
      else
        {
         mycolor = Coral;

         ObjectSet(fang+"High",OBJPROP_COLOR,mycolor);
        }

     }

   ObjectSet(fang,OBJPROP_COLOR,mycolor);
  }
//+------------------------------------------------------------------+
int CurrentPeriod()
  {
   int iperiod = Period();
   switch(iperiod)
     {
      case 1:
         return (1);
         break;
      case 5:
         return (1);
         break;
      case 15:
         return (1);
         break;
      case 30:
         return (2);
         break;
      case 60:
         return (2);
         break;
      case 240:
         return (4);
         break;
     }
   return (10);
  }
///////////////////////////////////////////////////////////////////////////

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
string MouseState(uint state)
  {
   string res;
   res+="\nML: "   +(((state& 1)== 1)?"DN":"UP");   // mouse left
   res+="\nMR: "   +(((state& 2)== 2)?"DN":"UP");   // mouse right
   res+="\nMM: "   +(((state&16)==16)?"DN":"UP");   // mouse middle
   res+="\nMX: "   +(((state&32)==32)?"DN":"UP");   // mouse first X key
   res+="\nMY: "   +(((state&64)==64)?"DN":"UP");   // mouse second X key
   res+="\nSHIFT: "+(((state& 4)== 4)?"DN":"UP");   // shift key
   res+="\nCTRL: " +(((state& 8)== 8)?"DN":"UP");   // control key
   return(res);
  }
//+------------------------------------------------------------------+
void pingzuijin(int geshu)//平最近下的多少单
  {
   Print("平最近下的",geshu,"单 处理中...");
   for(int i=geshu; i>0; i--)
     {
      zuijinkeyclose();
     }
  }
//+------------------------------------------------------------------+
