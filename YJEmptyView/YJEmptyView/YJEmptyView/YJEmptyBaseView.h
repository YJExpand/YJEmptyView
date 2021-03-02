//
//  YJEmptyBaseView.h
//  YJEmptyView
//
//  Created by YJExpand on 2021/1/1.
//

/*
 ⚠️ 使用说明：
 默认初始化①  ---图片、文字
 默认初始化②  ---图片、文字、按钮
 
 view的高度是使用autolayout自动撑开，有需要可以重写yj_setupSubviews方法
 重写yj_setupSubviews方法，最好使用autoLayout自动撑开，否则高度默认为kDefaultEmptyViewHeigth
 */
#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^emptyBtnClickBlock)(UIButton *btn);

@interface YJEmptyBaseView : UIView<YJEmptyViewDelegate>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText;

+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText
                         btnNormalText:(NSString *)btnNormalText
                      buttonClickBlock:(emptyBtnClickBlock)block;

@property (nonatomic,readonly,weak) UIScrollView *yjSuperView;
@property (nonatomic,readonly,strong) UIImageView *imageView;
@property (nonatomic,readonly,strong) UILabel *titleLB;
@property (nonatomic,readonly,strong) UIButton *button;

/// 设置布局
- (void)yj_setupSubviews;
/// 格式化布局（子类继承该view时，可实现该方法，重新布局，自定义约束）
- (void)resetSubViewLayout;

#pragma mark- 外部微调参数
/// 重新设置button大小-----默认CGSizeMake(120, 35)
- (void)handleButtonSize:(CGSize)size;
/// 重新设置间距-----默认10.f
- (void)handleDefineMargin:(CGFloat)margin;
@end

NS_ASSUME_NONNULL_END
