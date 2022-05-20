//
//  TableView_NormalVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/2/22.
//

#import "TableView_NormalVC.h"

@interface TableView_NormalVC ()

@end

@implementation TableView_NormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    YJEmptyBaseView *emptyView = [YJEmptyBaseView yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据啊"];
    emptyView.titleLabel.font = [UIFont systemFontOfSize:30];
    self.tableView.yj_emptyView = emptyView;
    [self.tableView yj_updateEmptyViewTop:10];
    
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
