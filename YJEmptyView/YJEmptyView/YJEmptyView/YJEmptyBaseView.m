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
@property (nonatomic,weak) UIScrollView *yjSuperView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) emptyBtnClickBlock buttonClickBlock;
@property (nonatomic,strong) NSMutableArray<NSLayoutConstraint *> *btnConstraitSizeArr;
@property (nonatomic,strong) NSMutableArray<NSLayoutConstraint *> *constraitArr; // 缓存约束
@property (nonatomic,assign) CGFloat margin;
@end

@implementation YJEmptyBaseView

+ (instancetype)yj_createWithImageName:(NSString *)imageName titleText:(NSString *)titleText{
    YJEmptyBaseView *view = [[self alloc] initWithImage:[UIImage imageNamed:imageName] titleText:titleText];
    return view;
}

+ (instancetype)yj_createWithImageName:(NSString *)imageName titleText:(NSString *)titleText btnNormalText:(NSString *)btnNormalText buttonClickBlock:(emptyBtnClickBlock)block{
    YJEmptyBaseView *view = [[self alloc] initWithImage:[UIImage imageNamed:imageName] titleText:titleText btnNormalText:btnNormalText buttonClickBlock:block];
    return view;
}

- (instancetype)initWithImage:(UIImage *)image titleText:(NSString *)titleText btnNormalText:(NSString *)btnNormalText buttonClickBlock:(emptyBtnClickBlock)block{
    self = [self initWithImage:image titleText:titleText];
    if (self) {
        self.buttonClickBlock = block;
        [self.button setTitle:btnNormalText forState:UIControlStateNormal];
        [self addSubview:self.button];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image titleText:(NSString *)titleText
{
    self = [super init];
    if (self) {
        self.margin = kDefineMargin;
        self.image = image;
        self.titleLB.text = titleText;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLB];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)yj_setupSubviews{
    if (!self.yjSuperView) return;
    [self resetSubViewLayout];
    
    NSLayoutConstraint *imageViewCenterX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *imageViewTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraints:@[imageViewCenterX,imageViewTop]];
    
    NSLayoutConstraint *titleLeft = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.margin];
    NSLayoutConstraint *titleRight = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-self.margin];
    NSLayoutConstraint *titleTop = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.margin];
    NSLayoutConstraint *titleBottom = [NSLayoutConstraint constraintWithItem:self.titleLB attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.constraitArr addObjectsFromArray:@[titleTop,titleLeft,titleRight,titleBottom]];
    
    if (_button) { // 有button,额外处理
        [self.constraitArr removeObject:titleBottom];
        NSLayoutConstraint *buttonCenterX = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *buttonTop = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLB attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.margin];
        NSLayoutConstraint *buttonBottom = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        buttonBottom.priority = UILayoutPriorityDefaultHigh;
        [self.constraitArr addObjectsFromArray:@[buttonCenterX,buttonTop,buttonBottom]];
        if (!self.btnConstraitSizeArr.count) {
            [self handleButtonSize:kDefineButtonSize];
        }
    }
    [self addConstraints:self.constraitArr];
}

- (void)resetSubViewLayout{
    if (self.constraitArr.count) {
        [self removeConstraints:self.constraitArr];
    }
    [self.constraitArr removeAllObjects];
}
#pragma mark- action
- (void)buttonClick:(UIButton *)btn{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(btn);
    }
}
#pragma mark- 外部微调参数
- (void)handleButtonSize:(CGSize)size{
    if (self.btnConstraitSizeArr.count) {
        [self.button removeConstraints:self.btnConstraitSizeArr];
        [self.btnConstraitSizeArr removeAllObjects];
    }
    NSLayoutConstraint *buttonWidth = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.width];
    NSLayoutConstraint *buttonHeight = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size.height];
    [self.btnConstraitSizeArr addObjectsFromArray:@[buttonWidth,buttonHeight]];
    [self.button addConstraints:self.btnConstraitSizeArr];
}

- (void)handleDefineMargin:(CGFloat)margin{
    self.margin = margin;
    [self yj_setupSubviews];
}
#pragma mark- <YJEmptyViewDelegate>
- (void)updateEmptyViewShowStatus:(BOOL)status superView:(UIScrollView *)superView{
    self.yjSuperView = superView;
    [self yj_setupSubviews];
}
#pragma mark- getting
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = [UIColor grayColor];
        _titleLB.font = [UIFont systemFontOfSize:18.f];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLB;
}
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (NSMutableArray<NSLayoutConstraint *> *)btnConstraitSizeArr{
    if (!_btnConstraitSizeArr) {
        _btnConstraitSizeArr = [NSMutableArray array];
    }
    return _btnConstraitSizeArr;
}
- (NSMutableArray<NSLayoutConstraint *> *)constraitArr{
    if (!_constraitArr) {
        _constraitArr = [NSMutableArray array];
    }
    return _constraitArr;
}
@end
