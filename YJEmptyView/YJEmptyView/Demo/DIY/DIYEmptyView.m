//
//  DIYEmptyView.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/4/6.
//

#import "DIYEmptyView.h"
#import <Masonry/Masonry.h>
#import "UIColor+ext.h"

@implementation DIYEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor mq_randomColor];
        UILabel *testLB = [[UILabel alloc] init];
        testLB.text = @"这是一个DIYEmptyView!!";
        [self addSubview:testLB];
        [testLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
        }];
    }
    return self;
}

@end
