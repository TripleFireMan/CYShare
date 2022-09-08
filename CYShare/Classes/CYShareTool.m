//
//  ShareTool.m
//  ZhuaZhou
//
//  Created by chengyan on 2021/11/9.
//

#import "CYShareTool.h"
#import "CYShareBottomView.h"

@implementation CYShareTool
+ (void)shareWithShareModel:(CYShareModel *)shareModel
{
    NSMutableArray *shareActions = @[].mutableCopy;
    if (shareModel.shareType & CYShareAction_Wechat) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_Wechat];
        action.img = [UIImage imageNamed:@"details_icon_wechat"];
        action.title = @"微信好友";
        [shareActions addObject:action];
    }

    if ((shareModel.shareType & CYShareAction_Circle) && !shareModel.isXcx) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_Circle];
        action.img = [UIImage imageNamed:@"details_icon_pyq"];
        action.title = @"朋友圈";
        [shareActions addObject:action];
    }

    if (shareModel.shareType & CYShareAction_SaveToAlbum) {
        CYShareAction *action = [CYShareAction shareModelWithType:CYShareAction_SaveToAlbum];
        action.img = [UIImage imageNamed:@"details_icon_img"];
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
@end
