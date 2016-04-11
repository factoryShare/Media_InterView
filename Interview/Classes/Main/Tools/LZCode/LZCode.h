#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZCode : NSObject
/**
 *  判断是否第一次启动程序
 */
+(BOOL)isFisrtStarApp;

#pragma mark 视图大全
/**
 *  给视图添加点击手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addTap:(UIView *)myView;
/**
 *  给视图添加长安按手势
 *
 *  @param view 要添加到得视图
 */
+(void)addLongPress:(UIView *)view;
/**
 *  给视图添加轻扫手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addSwip:(UIView *)myView;
/**
 *  给视图添加移动手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addPan:(UIView *)myView;
/**
 *  视图添加旋转手势
 *
 *  @param myView 要添加到得视图
 */
+(void)addRotation:(UIView *)myView;

#pragma mark 沙盒
/**
 *  获得documents地址
 */
+ (NSString *)getDocuments;
/**
 *  获得library地址 (配置文件）
 */
+ (NSString *)getLibrary;
/**
 *  获得library下得caches,缓存的地址，同步时不会备份cashes中的文件
 */
+ (NSString *)getCaches;
/**
 *  获得temp的地址，里面缓存的数据当设备重启时销毁
 */
+ (NSString *)getTemp;
@end
