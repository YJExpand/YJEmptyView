//
//  UIScrollView+EmptyView.h
//  YJEmptyView
//
//  Created by YJExpand on 2021/1/1.
//

/*
 ⚠️⚠️⚠️-----------使用前阅读
 
 ❗️❗️❗️：默认属性
 tableView :
 if (tableView.tableHeaderView){
    emptyView 默认Top是kEmptyViewTop（130.f）
 }else{
    emptyView 默认Top是贴着tableHeaderView.bottom
 }
 
 collectionView:
    emptyView 默认Top是kEmptyViewTop（130.f）
 
 ❗️❗️❗️：使用说明
 tableView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:kEmptyViewImageName titleText:@"testet"];
 或
 tableView.yj_emptyViewDataSource = self;(需要实现代理emptyViewFromSuperView:方法，返回一个遵循<YJEmptyViewDelegate>的View,可自定义也可使用【YJEmptyBaseView】)
 注意：如果自定义的View不自动撑开的话，必须要实现- (CGSize)emptyViewSize:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView;
 
 若要实现加载数据时自动显示emptyView -------需要实现yj_emptyLoadDataBegin和yj_emptyLoadDataEnd
 
 ----------------------------------
 暂时这样，后面再更新
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YJEmptyViewDelegate <NSObject>

@optional
/// 当emptyView状态变更时，会给调用
/// @param status ---显示（Yes）-----隐藏（NO）
/// @param superView 添加到的View（主要用来判断是TableView或CollectionView）
- (void)updateEmptyViewShowStatus:(BOOL)status superView:(UIScrollView *)superView;
@end

@protocol YJEmptyViewDataSource <NSObject>

/// 返回站位View(必须实现)
/// @param superView -
- (UIView<YJEmptyViewDelegate> *)emptyViewFromSuperView:(UIScrollView *)superView;
@optional

/// 手动设置emptyView的大小
/// @param emptyView -
/// @param superView -
- (CGSize)emptyViewSize:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView;

/// 设置emptyView和superView的间距
/// @param emptyView -
/// @param superView -
- (UIEdgeInsets)emptyViewEdgeInset:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView;
@end

@interface UIScrollView (EmptyView)
@property (nonatomic,strong) UIView<YJEmptyViewDelegate> *yj_emptyView;
/// 是否自动显示空白页  define Yes
@property (nonatomic,assign) BOOL autoShowEmptyView;
@property (nonatomic,weak) id<YJEmptyViewDataSource> yj_emptyViewDataSource;

- (void)yj_emptyViewReloadData;

/// 开始加载数据 （必须和yj_emptyLoadDataEnd配套使用）
- (void)yj_emptyLoadDataBegin;
/// 结束加载数据 （必须和yj_emptyLoadDataBegin配套使用）
- (void)yj_emptyLoadDataEnd;
/// 更新top，默认130.f
- (void)yj_updateEmptyViewTop:(CGFloat)top;

@end

NS_ASSUME_NONNULL_END
