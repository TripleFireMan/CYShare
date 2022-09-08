//
//  ShareTool.h
//  ZhuaZhou
//
//  Created by chengyan on 2021/11/9.
//

#import <Foundation/Foundation.h>
#import "CYShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CYShareTool : NSObject

/**
 调起分享弹框
 */
+ (void)shareWithShareModel:(CYShareModel *)shareModel;

@end

NS_ASSUME_NONNULL_END
