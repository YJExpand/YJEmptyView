//
//  CollectionView_NormalVC.m
//  YJEmptyView
//
//  Created by YJExpand on 2021/2/22.
//

#import "CollectionView_NormalVC.h"

@interface CollectionView_NormalVC ()

@end

@implementation CollectionView_NormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yj_initCollectionView];
    
    self.collectionView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:@"myy_blankpages_nonet" titleText:@"没有数据啊"];
    
    [self loadData];
}

- (void)loadData{
    [self.collectionView yj_beginLoading];
    kWeakSelf;
    [self async_loadDataWithBlock:^{
        [weakSelf.collectionView yj_endLoading];
        [weakSelf randomDataSource];
        [weakSelf.collectionView reloadData];
    }];
}
@end
