//
//  NormalEmptyView.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/4/6.
//

#import "NormalEmptyView.h"

@implementation NormalEmptyView

+ (instancetype)createNormalEmptyView{
    return [self yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据"];
}

+ (instancetype)yj_createWithImageName:(NSString *)imageName titleText:(NSString *)titleText btnNormalText:(NSString *)btnNormalText buttonClickBlock:(emptyBtnClickBlock)block{
    NormalEmptyView *emptyView = [super yj_createWithImageName:imageName titleText:titleText btnNormalText:btnNormalText buttonClickBlock:block];
    // 配置一些属性
    emptyView.button.layer.cornerRadius = 5.f;
    emptyView.button.layer.borderColor = [UIColor redColor].CGColor;
    emptyView.button.layer.borderWidth = 2.f;
    emptyView.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [emptyView yj_handleButtonSize:CGSizeMake(100, 45)];
    return emptyView;
}
@end
