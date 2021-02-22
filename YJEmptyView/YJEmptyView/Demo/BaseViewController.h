//
//  BaseViewController.h
//  YJEmptyView
//
//  Created by YJExpand on 2021/2/22.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+ext.h"
#import "YJEmptyViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSources;
- (void)yj_initTableView;
- (void)yj_initCollectionView;
- (void)async_loadDataWithBlock:(void(^)(void))block;
- (void)randomDataSource; // 随机赋值dataSources
@end


#ifndef kWeakSelf
#define kWeakSelf WEAK_OBJ(self,weakSelf)
#endif
/**
 *  weak obj
 *  @param TARGET 实例
 *  @param NAME   弱实例名字
 */
#ifndef WEAK_OBJ
#define WEAK_OBJ(TARGET,NAME)  __weak typeof(TARGET) NAME = TARGET;
#endif

NS_ASSUME_NONNULL_END
