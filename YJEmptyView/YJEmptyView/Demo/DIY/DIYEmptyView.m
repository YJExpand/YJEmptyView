//
//  DIYEmptyView.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/4/6.
//

#import "DIYEmptyView.h"
#import <Masonry/Masonry.h>
#import "UIColor+ext.h"

@interface DIYEmptyView()
@property(nonatomic ,strong) UILabel *label;
@end

@implementation DIYEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [self emptyViewInitSize].width, [self emptyViewInitSize].height);
        self.backgroundColor = [UIColor mq_randomColor];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
        }];
    }
    return self;
}

/// 初始化大小
- (CGSize)emptyViewInitSize{
    return CGSizeMake(300, 60);
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"这是一个DIYEmptyView!!";
    }
    return _label;
}
@end
