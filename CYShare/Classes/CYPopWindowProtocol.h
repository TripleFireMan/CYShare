//
//  Dev_PopWindowProtocol.h
//  customer_rebuild
//
//  Created by 成焱 on 2020/7/17.
//  Copyright © 2020 TestProject. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYPopWindowProtocol <NSObject>

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, copy  ) void(^closeBlock)(void);

@property (nonatomic, copy  ) void(^otherBlock)( id _Nullable value);

+ (instancetype) showOnView:(UIView *)aView
                   animated:(BOOL)animated
                 closeBlock:(void  (^ _Nullable)(void))closeBlock
                 otherBlock:(void  (^ _Nullable)(id  value))otherBlock;

- (void) hide:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
