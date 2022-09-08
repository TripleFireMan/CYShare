//
//  ShareModel.h
//  customer_rebuild
//
//  Created by 全球蛙 on 2019/5/31.
//  Copyright © 2019 TestProject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYShareBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYShareModel : NSObject

/**
 分享面板标题
 */
@property (nonatomic, copy) NSString * title;

/**
 分享标题
 */
@property (nonatomic, copy) NSString * shareTitle;

/**
 分享内容
 */
@property (nonatomic, copy) NSString * shareSummary;
/**
 分享图片
 */
@property (nonatomic, copy) NSString *shareImageUrl;
/**
 分享地址
 //如果是小程序 则为路径
 */
@property (nonatomic, copy) NSString * shareTargetUrl;

/**
 分享备注
 */
@property (nonatomic, copy) NSString * shareRemark;

/**
 * thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 */
@property (nonatomic, strong) id thumImage;

//分享是否小程序
@property (nonatomic, assign)BOOL isXcx;

/// 分享类型。默认是分享到微信与微信朋友圈
@property (nonatomic, assign) CYShareActionType shareType;
/// 点击之后的回调
@property (nonatomic, copy  ) void(^shareActionBlock)(CYShareAction *action);
/// 点击埋点回调
@property (nonatomic, copy  ) void(^trackPointBlock)(CYShareAction *action);

/// 分享模型的初始化
/// @param isMiniPrograme 是否是小程序
/// @param shareTitle 分享标题
/// @param imageUrl 分享图片URL
/// @param miniProgramPath 小程序的分享path
+ (CYShareModel *) shareWithMiniPrograme:(BOOL)isMiniPrograme
                            shareTitle:(NSString *)shareTitle
                         shareImageURL:(NSString *)imageUrl
                      miniProgramePath:(NSString *)miniProgramPath;

/// 分享单图片
+ (CYShareModel *) shareModelWithImg:(UIImage *)img
                        actionType:(void(^)(CYShareAction *))actionBlock;

/// 取到微信分享合适的图片 限制最大128kb
- (NSData *)getThumImage;

- (NSData *)getThumImageWithLimitData:(NSInteger)kb;
@end

NS_ASSUME_NONNULL_END
