//
//  ShareTool.h
//  ZhuaZhou
//
//  Created by chengyan on 2021/11/9.
//

#import <Foundation/Foundation.h>
#import "CYShareModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^CYWechatAuthBlock)(BOOL ret, NSString * code);
typedef void (^CYWechatShareBlock)(BOOL success);
@interface CYShareTool : NSObject

/// 调起分享弹框
+ (void)shareWithShareModel:(CYShareModel *)shareModel;

/// 截图
+ (void)screenShots:(UIView *)view complete:(void(^)(id img))block;

/// 获取保存相册权限
+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result;

@end

/// 微信扩展
@interface CYShareTool (WX)

/// 注册微信
+ (void) regiesterWx:(NSString *)key
       universalLink:(NSString *)linkurl
            LogLevel:(NSInteger)logLevel
               block:(void(^)(NSString *log))block;

/// 检测微信是否安装
- (BOOL) isInstallWeChat;

/// 微信处理url
- (BOOL)handleOpenURL:(NSURL *)url;

/// 微信登录
- (BOOL) wechatAuthWithBlock:(CYWechatAuthBlock)block viewController:(UIViewController *)vc;

/// 微信分享图文
- (void)WechatShareWithTitle:(nullable NSString *)titel
                 Description:(nullable NSString *)description
                       Image:(nullable UIImage *)image
                     PushUrl:(nullable NSString *)pushURL
                       Scene:(int)scene
                       Block:(nullable CYWechatShareBlock)block;
/// 分享图片
- (void) shareImg:(UIImage *)img scene:(int)scene com:(void (^ __nullable)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
