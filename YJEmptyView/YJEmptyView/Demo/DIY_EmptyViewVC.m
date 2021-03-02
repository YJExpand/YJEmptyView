//
//  DIY_EmptyViewVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/3/1.
//

#import "DIY_EmptyViewVC.h"

@interface DIY_EmptyViewVC ()

@end

@implementation DIY_EmptyViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    
    self.tableView.yj_emptyView = [[DIYEmptyView alloc] init];
    [self.tableView yj_updateEmptyViewDefaultHeigth:90.f];
    [self loadData];
}

- (void)loadData{
    [self.tableView yj_emptyLoadDataBegin];
    kWeakSelf;
    [self async_loadDataWithBlock:^{
        [weakSelf.tableView yj_emptyLoadDataEnd];
        [weakSelf randomDataSource];
        [weakSelf.tableView reloadData];
    }];
}
@end


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
