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

/// 创建只有图片和文本的占位view
/// @param imageName 图片名字
/// @param titleText 文本
+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText;

/// 创建有图片、文本、点击按钮的占位view
/// @param imageName 图片名字
/// @param titleText 文本
/// @param btnNormalText 按钮文字
/// @param block 点击回调
+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText
                         btnNormalText:(NSString *)btnNormalText
                      buttonClickBlock:(emptyBtnClickBlock)block;

/// 父View
@property (nonatomic,readonly,weak) UIScrollView *yjSuperView;
/// 图片
@property (nonatomic,readonly,strong) UIImageView *imageView;
/// 文本描述
@property (nonatomic,readonly,strong) UILabel *titleLB;
/// 点击按钮
@property (nonatomic,readonly,strong) UIButton *button;

#pragma mark- public [公共方法]

/// 重新设置button大小-----默认CGSizeMake(120, 35)
- (void)yj_handleButtonSize:(CGSize)size;

/// 重新设置间距-----默认10.f
- (void)yj_handleDefineMargin:(CGFloat)margin;

/// 更新frame ----子类可重写改方法设置frame
- (void)yj_updateFrame;
@end

NS_ASSUME_NONNULL_END
