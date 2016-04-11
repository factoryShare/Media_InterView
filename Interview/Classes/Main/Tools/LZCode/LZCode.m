#define USERKEY @"APPSTART"

#import "LZCode.h"

@implementation LZCode

/**
 *  判断是否第一次启动程序
 */
+(BOOL)isFisrtStarApp{
    /**
     *  #define USERKEY @"APPSTART"
     */
    //获得单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //读取次数（用户上一次启动app的次数）
    NSString *number = [userDefaults objectForKey:USERKEY];
    //判断是否有值
    if (number!=nil) {
        //能够取到值，则不是第一次启动
        NSInteger starNumer = [number integerValue];
        //用上一次的次数+1次
        NSString *str = [NSString stringWithFormat:@"%ld",++starNumer];
        //存的是用户这一次启动的次数
        [userDefaults setObject:str forKey:USERKEY];
        [userDefaults synchronize];
        //输出启动次数=上一次启动的次数+1
        NSLog(@"用户第%ld次启动程序",starNumer);
        return NO;
    }else{
        //不能取到值，则是第一次启动
        NSLog(@"用户是第一次启动");
        [userDefaults setObject:@"1" forKey:USERKEY];
        [userDefaults synchronize];
        return YES;
    }
}


#pragma mark 手势大全

/**
 *  给视图添加点击手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addTap:(UIView *)myView{
    
    //创建一个点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    //设置点击几次
    tap.numberOfTapsRequired = 1;
    //设置几根手指
    tap.numberOfTouchesRequired = 1;
    
    //添加回调函数
    [tap addTarget:self action:@selector(tap:)];
    //视图添加手势
    [myView addGestureRecognizer:tap];
    
    //创建点击2次的手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]init];
    tap2.numberOfTapsRequired = 2;
    [tap2 addTarget:self action:@selector(tapTwo:)];
    [myView addGestureRecognizer:tap2];
    
    //手势冲突解决办法
    [tap requireGestureRecognizerToFail:tap2];
}
//手势触发的回调函数
+(void)tap:(UITapGestureRecognizer *)t{
    NSLog(@"hello , how are you");
}
//点击2次触发的函数
+(void)tapTwo:(UITapGestureRecognizer *)tapTwo{
    //获得添加手势的视图
    UIView *v = tapTwo.view;
    NSLog(@"v %@",v);
    
    NSLog(@"胆敢点我两次");
}

/**
 *  给视图添加长安按手势
 *
 *  @param view 要添加到得视图
 */
+(void)addLongPress:(UIView *)view{
    //创建长按手势 -》UIGestureRecognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]init];
    //设置响应时间
    longPress.minimumPressDuration = 2;
    //添加回调函数
    [longPress addTarget:self action:@selector(l:)];
    //视图添加手势
    [view addGestureRecognizer:longPress];
}
+(void)l:(UILongPressGestureRecognizer *)l{
    UIView *v = l.view;
}

/**
 *  给视图添加轻扫手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addSwip:(UIView *)myView{
    //创建轻扫手势
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]init];
    //设置方向
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    //添加回调函数
    [swip addTarget:self action:@selector(swip:)];
    //添加手势
    [myView addGestureRecognizer:swip];
    
    UISwipeGestureRecognizer *swip2 = [[UISwipeGestureRecognizer alloc]init];
    //设置方向
    swip2.direction = UISwipeGestureRecognizerDirectionDown;
    [swip2 addTarget:self action:@selector(swip:)];
    [myView addGestureRecognizer:swip2];
    
    UISwipeGestureRecognizer *swip3 = [[UISwipeGestureRecognizer alloc]init];
    //设置方向
    swip3.direction = UISwipeGestureRecognizerDirectionUp;
    [swip3 addTarget:self action:@selector(swip:)];
    [myView addGestureRecognizer:swip3];
    
    UISwipeGestureRecognizer *swip4 = [[UISwipeGestureRecognizer alloc]init];
    //设置方向
    swip4.direction = UISwipeGestureRecognizerDirectionRight;
    [swip4 addTarget:self action:@selector(swip:)];
    [myView addGestureRecognizer:swip4];
}
+(void)swip:(UISwipeGestureRecognizer *)s{
    CGPoint centerPonit = s.view.center;//获得中心点的位置
    
    switch (s.direction) {
            //如果向左轻扫
        case UISwipeGestureRecognizerDirectionLeft:
        {
            //x方向 - 10
            s.view.center = CGPointMake(centerPonit.x-10, centerPonit.y);
        }break;
        case UISwipeGestureRecognizerDirectionDown:{
            s.view.center = CGPointMake(centerPonit.x, centerPonit.y +10);
        }break;
        case UISwipeGestureRecognizerDirectionUp:{
            s.view.center = CGPointMake(centerPonit.x, centerPonit.y -10);
        }break;
        case UISwipeGestureRecognizerDirectionRight:{
            s.view.center = CGPointMake(centerPonit.x+10, centerPonit.y);
        }break;
            
        default:
            break;
    }
}
/**
 *  给视图添加移动手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addPan:(UIView *)myView{
    //创建移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    //添加回调函数
    [pan addTarget:self action:@selector(pan:)];
    //视图添加手势
    [myView addGestureRecognizer:pan];
}
//移动手势的回调函数
+(void)pan:(UIPanGestureRecognizer *)pan{
    
    static CGPoint beganCenter;
    //获得偏移量
    CGPoint point = [pan translationInView:pan.view];
    NSLog(@"point %@",NSStringFromCGPoint(point));
    //判断手势的状态
    switch (pan.state) {
            //开始
        case UIGestureRecognizerStateBegan:
        {
            beganCenter = pan.view.center;
            NSLog(@"手指开始触摸");
        }break;
            // 移动
        case UIGestureRecognizerStateChanged:{
            NSLog(@"手指移动");
        }break;
            //结束
        case UIGestureRecognizerStateEnded:{
            NSLog(@"手指结束触摸");
        }break;
        default:
            break;
    }
    pan.view.center = CGPointMake(point.x+beganCenter.x, point.y+beganCenter.y );
}

/**
 *  视图添加旋转手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addRotation:(UIView *)myView{
    //创建旋转手势的对象
    UIRotationGestureRecognizer * ro = [[UIRotationGestureRecognizer alloc]init];
    [ro addTarget:self action:@selector(ro:)];
    //添加手势
    [myView addGestureRecognizer:ro];
}
//手势的回调函数，从手指放到指定的视图上，到手指离开这个视图，这个回调函数一直在调用
+(void)ro:(UIRotationGestureRecognizer *)r{
    //获得本次旋转的弧度
    CGFloat f = r.rotation;
    NSLog(@"弧度 %f",f);
    //endF记录的是上一次旋转的弧度
    static  CGFloat endF = 0;
    NSLog(@"endF %f",endF);
    //形变是弧度=上一次旋转的弧度+本次旋转的弧度
    r.view.transform = CGAffineTransformMakeRotation(f+endF);
    //如果结束触摸，则更新旋转的弧度
    if (r.state == UIGestureRecognizerStateEnded) {
        endF += r.rotation;
        NSLog(@"结束触摸 enf %f",endF);
    }
}

/**
 *  添加捏合手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addPinch:(UIView *)myView{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]init];
    //添加回调函数
    [pinch addTarget:self action:@selector(pinch:)];
    //添加手势
    [myView addGestureRecognizer:pinch ];
}
//捏合手势的回调函数
+(void)pinch:(UIPinchGestureRecognizer *)p{
    CGFloat s = p.scale;//获得缩放的系数
    static CGFloat endScale = 1;//记录上一次缩放的系数
    //视图的tranform  = 上一次缩放的系数 * 本次缩放的系数
    p.view.transform = CGAffineTransformMakeScale(p.scale*endScale, p.scale*endScale);
    //触摸结束的时候记录缩放的系数
    if (p.state == UIGestureRecognizerStateEnded) {
        endScale *= p.scale;
    }
}


#pragma mark 沙盒

/**
 *  获得documents地址
 */
+ (NSString *)getDocuments{
    NSArray *docArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = docArr[0];
    
    return docPath;
}
/**
 *  获得library地址 (配置文件）
 */
+ (NSString *)getLibrary{
    NSArray *libArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = libArray[0];
    return libPath;
}
/**
 *  获得library下得caches,缓存的地址，同步时不会备份cashes中的文件
 */
+ (NSString *)getCaches{
    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cashesPath = caches[0];
    return cashesPath;
}
/**
 *  获得temp的地址，里面缓存的数据当设备重启时销毁
 */
+ (NSString *)getTemp{
    NSString *temp = NSTemporaryDirectory();
    return temp;
}











@end
