//
//  YJEmptyBaseView.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/1/1.
//

#import "YJEmptyBaseView.h"

#define kDefineMargin 10.f
#define kDefineButtonSize CGSizeMake(120, 35)

@interface YJEmptyBaseView()
/// 父View
@property (nonatomic,weak) UIScrollView *yjSuperView;
/// 图片
@property (nonatomic,strong) UIImageView *imageView;
/// 标题
@property (nonatomic,strong) UILabel *titleLabel;
/// 按钮
@property (nonatomic,strong) UIButton *button;
/// 图片
@property (nonatomic,strong) UIImage *image;
/// 按钮点击block
@property (nonatomic,copy) emptyBtnClickBlock buttonClickBlock;
/// 间隔
@property (nonatomic,assign) CGFloat margin;
@end

@implementation YJEmptyBaseView

/// 创建只有图片和文本的占位view
/// @param imageName 图片名字
/// @param titleText 文本
+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText{
    YJEmptyBaseView *view = [[self alloc] initWithImage:[UIImage imageNamed:imageName]
                                              titleText:titleText
                                          btnNormalText:nil
                                       buttonClickBlock:nil];
    return view;
}

/// 创建有图片、文本、点击按钮的占位view
/// @param imageName 图片名字
/// @param titleText 文本
/// @param btnNormalText 按钮文字
/// @param block 点击回调
+ (instancetype)yj_createWithImageName:(NSString *)imageName
                             titleText:(NSString *)titleText
                         btnNormalText:(NSString *)btnNormalText
                      buttonClickBlock:(emptyBtnClickBlock)block{
    
    YJEmptyBaseView *view = [[self alloc] initWithImage:[UIImage imageNamed:imageName]
                                              titleText:titleText
                                          btnNormalText:btnNormalText
                                       buttonClickBlock:block];
    return view;
}

/// 初始化
/// @param image 图片名字
/// @param titleText 文本
/// @param btnNormalText 按钮文字
/// @param block 点击回调
- (instancetype)initWithImage:(UIImage *)image
                    titleText:(NSString *)titleText
                btnNormalText:(NSString *_Nullable)btnNormalText
             buttonClickBlock:(emptyBtnClickBlock _Nullable)block{
    self = [self init];
    if (self) {
        self.margin = kDefineMargin;
        self.image = image;
        self.titleLabel.text = titleText;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        self.buttonClickBlock = block;
        if (btnNormalText.length) {
            [self.button setTitle:btnNormalText forState:UIControlStateNormal];
            [self addSubview:self.button];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self yj_updateFrame];
}

#pragma mark- action [点击事件]

/// 按钮点击
- (void)buttonClick:(UIButton *)btn{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(btn);
    }
}
#pragma mark- public [公共方法]
/// 重新设置button大小-----默认CGSizeMake(120, 35)
- (void)yj_handleButtonSize:(CGSize)size{
    CGRect buttonFrame = _button.frame;
    buttonFrame.size = size;
    _button.frame = buttonFrame;
    [self layoutIfNeeded];
}

/// 重新设置间距-----默认10.f
- (void)yj_handleDefineMargin:(CGFloat)margin{
    self.margin = margin;
    [self layoutIfNeeded];
}
/// 更新frame
- (void)yj_updateFrame{
    CGSize imageSize = self.image.size;
    CGFloat imageViewCenterX = (self.frame.size.width - imageSize.width) * 0.5;
    _imageView.frame = CGRectMake(imageViewCenterX, 0, imageSize.width, imageSize.height);
    
    CGSize titleSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
    _titleLabel.frame = CGRectMake(0, _imageView.frame.origin.y + imageSize.height + self.margin, self.bounds.size.width, titleSize.height);
  
    if (_button) {
        CGSize buttonSize = _button.bounds.size;
        CGFloat buttonCenterX = (self.frame.size.width - buttonSize.width) * 0.5;
        _button.frame = CGRectMake(buttonCenterX, _titleLabel.frame.origin.y + titleSize.height + self.margin, buttonSize.width, buttonSize.height);
    }
}

#pragma mark- <YJEmptyViewDelegate>

/// 当emptyView状态变更时，会给调用
/// @param status ---显示（Yes）-----隐藏（NO）
/// @param superView 添加到的View（主要用来判断是TableView或CollectionView）
- (void)emptyViewShowUpdateStatus:(BOOL)status superView:(UIScrollView *)superView{
    self.yjSuperView = superView;
    [self layoutIfNeeded];
}

/// 初始化大小
- (CGSize)emptyViewInitSize{
    // 默认为屏幕的宽度
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGSize emptyViewSize = CGSizeMake(bounds.size.width, 200);
    self.frame = CGRectMake(0, 0, emptyViewSize.width, emptyViewSize.height);
    [self yj_updateFrame];
    CGFloat heigth = _button ? _button.frame.origin.y + _button.bounds.size.height : _titleLabel.frame.origin.y + _titleLabel.bounds.size.height;
    return CGSizeMake(emptyViewSize.width, heigth > 0 ? heigth : emptyViewSize.height);
}

#pragma mark- getting
/// 图片
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
    }
    return _imageView;
}
/// 标题
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/// 按钮
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, kDefineButtonSize.width, kDefineButtonSize.height);
        _button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
