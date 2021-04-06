//
//  TableView_ClickVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/4/6.
//

#import "TableView_ClickVC.h"
#import "NormalEmptyView.h"
@interface TableView_ClickVC ()

@end

@implementation TableView_ClickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    
    kWeakSelf;
    self.tableView.yj_emptyView = [NormalEmptyView yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据啊" btnNormalText:@"点我一下" buttonClickBlock:^(UIButton * _Nonnull btn) {
       TableView_ClickVC *vc = [[TableView_ClickVC alloc] init];
        vc.title = weakSelf.title;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
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
