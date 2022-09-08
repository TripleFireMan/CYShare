//
//  ShareModel.m
//  customer_rebuild
//
//  Created by 全球蛙 on 2019/5/31.
//  Copyright © 2019 TestProject. All rights reserved.
//

#import "CYShareModel.h"
#import <SDWebImage/SDWebImage.h>
@implementation CYShareModel
- (id) init{
    self = [super init];
    if (self) {
        self.shareType = CYShareAction_Wechat | CYShareAction_Circle;
    }
    return self;
}

+ (CYShareModel *) shareWithMiniPrograme:(BOOL)isMiniPrograme shareTitle:(NSString *)shareTitle shareImageURL:(NSString *)imageUrl miniProgramePath:(NSString *)miniProgramPath{
    CYShareModel *model = [CYShareModel new];
    model.isXcx = isMiniPrograme;
    model.title = shareTitle;
    model.shareImageUrl = imageUrl;
    model.shareTargetUrl = miniProgramPath;
    model.shareTitle = shareTitle;
    model.thumImage = imageUrl;
    if (model.isXcx) {
        model.shareType = CYShareAction_Wechat;
    }
    return model;
}

+ (CYShareModel *) shareModelWithImg:(UIImage *)img actionType:(void (^)(CYShareAction * _Nonnull))actionBlock{
    CYShareModel *model = [CYShareModel new];
    model.shareType = CYShareAction_Circle | CYShareAction_Wechat | CYShareAction_SaveToAlbum;
    model.thumImage = img;
    model.shareActionBlock = actionBlock;
    return model;
}
/// 微信分享网页 thumImage 大小不能超过64K
- (NSData *)getThumImage {
    return [self getThumImageWithLimitData:64];
}

/// 微信分享小程序 hdImageData 大小不能超过128K
- (NSData *)getThumImageWithLimitData:(NSInteger)kb{
    NSData *data1 = nil;
    if ([self.thumImage isKindOfClass:[UIImage class]]) {
        data1 = UIImagePNGRepresentation(self.thumImage);
    }else{
        UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.thumImage]]];
        if (img) {
            data1 = UIImagePNGRepresentation(img);
        }
        else{
            data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumImage]];
        }
    }
    NSInteger maxLength = kb * 1024;
    UIImage *selfImg = [UIImage imageWithData:data1];
    CGFloat compression = 1;
        NSData *data = UIImageJPEGRepresentation(selfImg, compression);
        //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
        if (data.length < maxLength) return data;
        
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(selfImg, compression);
            //NSLog(@"Compression = %.1f", compression);
            //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength) return data;
        UIImage *resultImage = [UIImage imageWithData:data];
        // Compress by size
        NSUInteger lastDataLength = 0;
        while (data.length > maxLength && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLength / data.length;
            //NSLog(@"Ratio = %.1f", ratio);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
            //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
        }
        //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
        return data;
}

@end
