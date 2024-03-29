//
//  TableView_HeaderView_DelegateVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/3/1.
//

#import "TableView_HeaderView_DelegateVC.h"

@interface TableView_HeaderView_DelegateVC ()<YJEmptyViewDataSource>

@end

@implementation TableView_HeaderView_DelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
    headerView.backgroundColor = [UIColor mq_randomColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.yj_emptyViewDataSource = self;
    
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

#pragma mark- <YJEmptyViewDataSource>
- (UIView<YJEmptyViewDelegate> *)emptyViewFromSuperView:(UIScrollView *)superView{
    return [YJEmptyBaseView yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据啊"];;
}
///// 手动设置emptyView的大小
///// @param emptyView -
///// @param superView -
//- (CGSize)emptyViewSize:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView{
//
//}
//
/// 设置emptyView和superView的间距
/// @param emptyView -
/// @param superView -
//- (UIEdgeInsets)emptyViewEdgeInset:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView{
//    return UIEdgeInsetsMake(200, 0, 0, 0);
//}
@end
