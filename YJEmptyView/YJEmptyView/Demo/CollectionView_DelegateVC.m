//
//  CollectionView_DelegateVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/3/1.
//

#import "CollectionView_DelegateVC.h"

@interface CollectionView_DelegateVC ()<YJEmptyViewDataSource>

@end

@implementation CollectionView_DelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initCollectionView];
    
    self.collectionView.yj_emptyViewDataSource = self;
    
    [self loadData];
}

- (void)loadData{
    [self.collectionView yj_emptyLoadDataBegin];
    kWeakSelf;
    [self async_loadDataWithBlock:^{
        [weakSelf.collectionView yj_emptyLoadDataEnd];
        [weakSelf randomDataSource];
        [weakSelf.collectionView reloadData];
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
- (UIEdgeInsets)emptyViewEdgeInset:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView{
    return UIEdgeInsetsMake(200, 0, 0, 0);
}
@end
