//
//  TableView_headerViewVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/2/22.
//

#import "TableView_headerViewVC.h"

@interface TableView_headerViewVC ()

@end

@implementation TableView_headerViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    headerView.backgroundColor = [UIColor mq_randomColor];
    UILabel *headerLB = [[UILabel alloc] init];
    headerLB.text = @"headerView";
    [headerView addSubview:headerLB];
    [headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = headerView;
    self.tableView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据啊"];
    
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
