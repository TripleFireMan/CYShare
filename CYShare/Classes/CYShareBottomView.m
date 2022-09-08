//
//
//  Created by 成焱 on 2020/11/10.
//Copyright © 2020 TestProject. All rights reserved.
//

#import "CYShareBottomView.h"
#import <CYKit/CYKit.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface CYShareAction ()


@property (nonatomic, copy  ) CYVoidBlock block;

@end

@implementation CYShareAction


+ (instancetype) shareModelWithType:(CYShareActionType)actionType{
    CYShareAction *action = [CYShareAction new];
    action.action = actionType;

    return action;
}

@end

@interface CYShareBottomView ()
@property (nonatomic, strong) UIImageView   *line;
@property (nonatomic, strong) UIImageView   *bottomLine;
@property (nonatomic, strong) UILabel       *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation CYShareBottomView

@synthesize container = _container;
@synthesize maskView = _maskView;
@synthesize closeBlock = _closeBlock;
@synthesize otherBlock = _otherBlock;

+ (instancetype) showOnView:(UIView *)aView animated:(BOOL)animated closeBlock:(void (^)(void))closeBlock otherBlock:(void (^)(id _Nonnull))otherBlock{
    
    CYShareBottomView *detailView = [CYShareBottomView new];
    detailView.closeBlock = closeBlock;
    detailView.otherBlock = otherBlock;
    [aView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    detailView.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    detailView.container.alpha = 0.f;
    [detailView.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.width.offset(kScreenSize.width);
        make.top.mas_equalTo(detailView.mas_bottom);
    }];
    [detailView layoutIfNeeded];
    [UIView animateWithDuration:animated?0.35:0.f animations:^{
        detailView.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        detailView.container.alpha = 1.f;
        [detailView.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.width.offset(kScreenSize.width);
        }];
        
        [detailView layoutIfNeeded];
    }];
    return detailView;
}

- (id) initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self){
      [self setupSubviews];
      [self addConstrainss];
      

  }
  return self;
}

- (void) addShareActions:(NSArray<CYShareAction *> *)actions{
    for (UIView *sub in self.stackView.subviews) {
        [sub removeFromSuperview];
    }
    __block UIButton *curBtn = nil;
    [actions enumerateObjectsUsingBlock:^(CYShareAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self buttonWithAction:obj];
        [self.stackView addArrangedSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(60);
            make.height.offset(96);
        }];
        curBtn = btn;
    }];
    
}

- (void) layoutSubviews{
    [super layoutSubviews];
    [self.container cy_cornerRound:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(12, 12)];
}

- (void) setupSubviews
{
    [self addSubview:self.maskView];
    [self addSubview:self.container];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.closeBtn];
    [self.container addSubview:self.line];
    [self.container addSubview:self.scrollView];
    [self.scrollView addSubview:self.stackView];
}

- (void) addConstrainss
{
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.right.offset(0);
        make.width.offset(kScreenSize.width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.height.offset(49);
    }];

    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.width.height.offset(46);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(49);
        make.left.right.offset(0);
        make.height.offset(1);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(self.line.mas_bottom).offset(20);
        make.bottom.offset(-CY_Height_Bottom_SafeArea-40);
        make.height.offset(97);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

- (void) hide:(BOOL)animated
{
    [UIView animateWithDuration:animated?0.35:0.f animations:^{
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom);
            make.left.right.offset(0);
            make.width.offset(kScreenSize.width);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark - Lazy
- (UIView *) container{
    if (!_container) {
        _container = [UIView new];
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (UIView *) maskView{
    @weakify(self);
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [self hide:YES];
        }];
        tap.numberOfTapsRequired = 1;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UILabel *) titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = CYPingFangSCMedium(16);
        _titleLabel.textColor = kTitleColor();
        _titleLabel.text = @"分享到";
    }
    return _titleLabel;
}


- (UIButton * )closeBtn{
    @weakify(self);
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"pop_btn_close"] forState:UIControlStateNormal];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hide:YES];
        }];
    }
    return _closeBtn;
}

- (UIImageView *) line{
    if (!_line) {
        _line = [UIImageView new];
        
        _line.backgroundColor = kLineColor();
    }
    return _line;
}


- (UIImageView *) bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIImageView new];
        _bottomLine.backgroundColor = kLineColor();
    }
    return _bottomLine;
}

- (UIStackView *) stackView{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.spacing = kScreenWidth - 140 - 120;
    }
    return _stackView;
}

- (UIScrollView *) scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 70, 0, 70);
    }
    return _scrollView;
}

- (UIButton *) buttonWithAction:(CYShareAction *)action{
    @weakify(self);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setTitleColor:kSummaryColor() forState:UIControlStateNormal];
    [button setImage:action.img forState:UIControlStateNormal];
    button.titleLabel.font = CYPingFangSCRegular(15);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 36, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(60 + 16, -60, 0, 0);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.otherBlock ? self.otherBlock(action): nil;
        [self hide:YES];
    }];
    return button;
}

@end
