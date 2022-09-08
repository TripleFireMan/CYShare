//
//  Created by 成焱 on 2020/11/10.
//Copyright © 2020 TestProject. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYPopWindowProtocol.h"

typedef  NS_ENUM(NSInteger,CYShareActionType) {
    CYShareAction_Wechat = 1 << 0,
    CYShareAction_SaveToAlbum= 1 << 1,
    CYShareAction_Circle = 1 << 2,
};

@interface CYShareAction : NSObject

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) UIImage *img;
@property (nonatomic, assign) CYShareActionType action;
+ (instancetype) shareModelWithType:(CYShareActionType)actionType;


@end

@interface CYShareBottomView: UIView <CYPopWindowProtocol>
#pragma mark- as

#pragma mark- model

#pragma mark- view

#pragma mark- api
- (void) addShareActions:(NSArray < CYShareAction *> *)actions;

@end
