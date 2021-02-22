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
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dataSource[indexPath.row][0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.dataSource[indexPath.row][1];
    const char *classCharName = [className cStringUsingEncoding:NSASCIIStringEncoding];
    Class collectionVC = objc_getClass(classCharName);
    UIViewController *vc = [[collectionVC alloc] init];
    vc.title = self.dataSource[indexPath.row][1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- getting
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObjectsFromArray:@[@[@"tableView--普通（TableView_NormalVC）",@"TableView_NormalVC"],
                                        @[@"tableView--带headerView(TableView_headerViewVC)",@"TableView_headerViewVC"],
                                        @[@"collectionView--普通（CollectionView_NormalVC）",@"CollectionView_NormalVC"]
        ]];
    }
    return _dataSource;
}
@end
