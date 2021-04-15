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
    emptyView 默认Top是kEmptyViewTop
 }else{
    emptyView 默认Top是贴着tableHeaderView.bottom + Top是kEmptyViewTop
 }
 
 collectionView:
    emptyView 默认Top是kEmptyViewTop
 
 ❗️❗️❗️：使用说明
 tableView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:kEmptyViewImageName titleText:@"testet"];
 或
 tableView.yj_emptyViewDataSource = self;(需要实现代理emptyViewFromSuperView:方法，返回一个遵循<YJEmptyViewDelegate>的View,可自定义也可使用【YJEmptyBaseView】)
 
 注意：
 如果自定义的View不自动撑开的话，必须要实现
    - (CGSize)emptyViewSize:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView;
 否则高度默认>= kDefaultEmptyViewHeigth
 
 若要实现加载数据时自动显示emptyView -------需要实现yj_beginLoading和yj_endLoading
 
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
- (void)emptyViewShowUpdateStatus:(BOOL)status superView:(UIScrollView *)superView;
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

/// 空白页占位View
@property (nonatomic,strong) UIView<YJEmptyViewDelegate> *yj_emptyView;
/// 是否自动显示空白页  define Yes
@property (nonatomic,assign) BOOL autoShowEmptyView;

/// 空白占位View来源
@property (nonatomic,weak) id<YJEmptyViewDataSource> yj_emptyViewDataSource;

/// emptyView显示（当设置 autoShowEmptyView=No 时，手动操作）
- (void)yj_emptyViewShow;
/// emptyView隐藏（当设置 autoShowEmptyView=No 时，手动操作）
- (void)yj_emptyViewHide;

/// 开始加载数据 （必须和yj_endLoading配套使用）
- (void)yj_beginLoading;
/// 结束加载数据 （必须和yj_beginLoading配套使用）
- (void)yj_endLoading;

/// 更新top，默认kEmptyViewTop
- (void)yj_updateEmptyViewTop:(CGFloat)top;

/// 更新EmptyView默认高度
/// @param heigth -
- (void)yj_updateEmptyViewDefaultHeigth:(CGFloat)heigth;
@end

NS_ASSUME_NONNULL_END
