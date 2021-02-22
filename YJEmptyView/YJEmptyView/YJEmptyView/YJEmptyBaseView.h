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
 */
#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YJEmptyBaseView : UIView<YJEmptyViewDelegate>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText;

+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText
                         btnNormalText:(NSString *)btnNormalText
                      buttonClickBlock:(void(^)(UIButton *btn))block;

@property (nonatomic,readonly,weak) UIScrollView *yjSuperView;
@property (nonatomic,readonly,strong) UIImageView *imageView;
@property (nonatomic,readonly,strong) UILabel *titleLB;
@property (nonatomic,readonly,strong) UIButton *button;

#pragma mark- 外部微调参数
- (void)handleButtonSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
