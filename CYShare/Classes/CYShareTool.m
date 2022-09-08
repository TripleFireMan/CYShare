//
//  ShareTool.m
//  ZhuaZhou
//
//  Created by chengyan on 2021/11/9.
//

#import "CYShareTool.h"
#import "CYShareBottomView.h"
#import "WXApi.h"
#import <Photos/Photos.h>
#import "CYKit.h"
@interface CYShareTool()
@property (nonatomic, copy) CYWechatAuthBlock wechatAuthBlock;
@property (nonatomic, copy) CYWechatShareBlock wechatShareBlock;
@end

@implementation CYShareTool
+ (void)shareWithShareModel:(CYShareModel *)shareModel
{
    NSMutableArray *shareActions = @[].mutableCopy;
    if (shareModel.shareType & CYShareAction_Wechat) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_Wechat];
        action.img = [UIImage imageNamed:@"details_icon_wechat" inBundle:CYBundle(@"CYShare") compatibleWithTraitCollection:nil];
        action.title = @"微信好友";
        [shareActions addObject:action];
    }

    if ((shareModel.shareType & CYShareAction_Circle) && !shareModel.isXcx) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_Circle];
        action.img = [UIImage imageNamed:@"details_icon_pyq" inBundle:CYBundle(@"CYShare") compatibleWithTraitCollection:nil];
        action.title = @"朋友圈";

    
        [shareActions addObject:action];
    }

    if (shareModel.shareType & CYShareAction_SaveToAlbum) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_SaveToAlbum];
        action.img = [UIImage imageNamed:@"details_icon_img" inBundle:CYBundle(@"CYShare") compatibleWithTraitCollection:nil];
        action.title = @"保存相册";
        [shareActions addObject:action];
    }

    [[CYShareBottomView showOnView:[UIApplication sharedApplication].keyWindow animated:YES closeBlock:^{

        } otherBlock:^(id  _Nonnull value) {
            CYShareAction *action = (CYShareAction *)value;
            if (shareModel.shareActionBlock) {
                /// 分享到微信好友与朋友圈的操作，直接拦截
                shareModel.shareActionBlock(action);
            }
            // 埋点回调
            if (shareModel.trackPointBlock) {
                shareModel.trackPointBlock(action);
            }
        }] addShareActions:shareActions];
}

+ (void)screenShots:(UIView *)view complete:(void (^)(id _Nonnull))block{
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.f);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [view.layer renderInContext:ctx];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 保存相册
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        block?block(image):nil;
    });
}

+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        result(YES);
        return;
    }
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        result(NO);
        return ;
    }

    if (status == PHAuthorizationStatusNotDetermined) {

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 回调是在子线程的
            NSLog(@"%@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status != PHAuthorizationStatusAuthorized) {
                      NSLog(@"未开启相册权限,请到设置中开启");
                      result(NO);
                      return ;
                  }
                  result(YES);
            });

        }];
    }
}

@end

@implementation CYShareTool(WX)


- (BOOL)isInstallWeChat{
    return [WXApi isWXAppInstalled];
}

#pragma mark - 微信三方登录

- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL ret = NO;
    ret |= [WXApi handleOpenURL:url delegate:self];
    return ret;
}
-(BOOL)wechatAuthWithBlock:(CYWechatAuthBlock)block viewController:(nonnull UIViewController *)vc {

    self.wechatAuthBlock = block;
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1245";
    [WXApi sendAuthReq:req viewController:vc delegate:self completion:nil];
    return YES;
}

+ (void) regiesterWx:(NSString *)key
       universalLink:(NSString *)linkurl
            LogLevel:(NSInteger)logLevel
               block:(void(^)(NSString *log))block{
    [WXApi startLogByLevel:logLevel logBlock:block];
    [WXApi registerApp:key universalLink:linkurl];
}
- (void) shareImg:(UIImage *)img scene:(int)scene com:(void (^)(BOOL))complete{
    self.wechatShareBlock = complete;
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.scene = scene;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    WXImageObject *imgs = [WXImageObject object];
    imgs.imageData = UIImagePNGRepresentation(img);
    urlMessage.mediaObject = imgs;
    sendReq.message = urlMessage;
    //发送分享信息
    [WXApi sendReq:sendReq completion:nil];
}
- (void)WechatShareWithTitle:(NSString *)titel
                 Description:(NSString *)description
                       Image:(UIImage *)image
                     PushUrl:(NSString *)pushURL
                       Scene:(int)scene
                       Block:(CYWechatShareBlock)block{
    self.wechatShareBlock = block;
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.scene = scene;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = titel;
    urlMessage.description = description;
    [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = pushURL;//分享链接
    //完成发送对象实例
//    urlMessage.mediaObject = webObj;
    WXImageObject *img = [WXImageObject object];
    img.imageData = UIImagePNGRepresentation(image);
    urlMessage.mediaObject = img;
    sendReq.message = urlMessage;
    //发送分享信息
    [WXApi sendReq:sendReq completion:nil];

}
@end
