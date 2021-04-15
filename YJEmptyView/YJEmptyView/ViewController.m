//
//  ViewController.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/2/22.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSArray *> *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YJEmptyView--Demo";
}

#pragma mark- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row][0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row][1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"普通的使用EmptyView,一句代码搞定";
    }else if (section == 1){
        return @"使用代理使用EmptyView";
    }else if (section == 2){
        return @"使用EmptyView--带点击跳转";
    }
    return @"DIY--EmptyView";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.dataSource[indexPath.section][indexPath.row][1];
    const char *classCharName = [className cStringUsingEncoding:NSASCIIStringEncoding];
    Class collectionVC = objc_getClass(classCharName);
    UIViewController *vc = [[collectionVC alloc] init];
    vc.title = self.dataSource[indexPath.section][indexPath.row][1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- getting
- (NSMutableArray<NSArray *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObjectsFromArray:@[@[@[@"tableView--普通",@"TableView_NormalVC"],
                                             @[@"tableView--带headerView",@"TableView_headerViewVC"],
                                             @[@"collectionView--普通",@"CollectionView_NormalVC"]],
                                           @[@[@"tableView--普通",@"TableView_DelegateVC"],
                                             @[@"tableView--带headerView",@"TableView_HeaderView_DelegateVC"],
                                             @[@"collectionView",@"CollectionView_DelegateVC"]],
                                           @[@[@"tableView--带点击跳转",@"TableView_ClickVC"]],
                                           @[@[@"tableView--DIY空白页",@"DIY_EmptyViewVC"]]
        ]];
    }
    return _dataSource;
}
@end
