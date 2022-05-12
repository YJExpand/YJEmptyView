//
//  DIY_EmptyViewVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/3/1.
//

#import "DIY_EmptyViewVC.h"
#import "DIYEmptyView.h"
@interface DIY_EmptyViewVC ()

@end

@implementation DIY_EmptyViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    
    self.tableView.yj_emptyView = [[DIYEmptyView alloc] init];
//    [self.tableView yj_updateEmptyViewDefaultHeigth:90.f];
    [self loadData];
}

- (void)loadData{
    [self.tableView yj_beginLoading];
    kWeakSelf;
    [self async_loadDataWithBlock:^{
        [weakSelf.tableView yj_endLoading];
        [weakSelf randomDataSource];
        [weakSelf.tableView reloadData];
    }];
}
@end
