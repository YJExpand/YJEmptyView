//
//  UIScrollView+EmptyView.m
//  yjEmptyView
//
//  Created by YJExpand on 2021/1/1.
//

#import "UIScrollView+EmptyView.h"
#import <objc/runtime.h>

// 默认top约束
#define kEmptyViewTop 130.f
// 默认占位图的高度大于等于50.f
#define kDefaultEmptyViewHeigth 50.f

@interface UIScrollView()
/// 空白占位View的top 距离
@property (nonatomic,assign) CGFloat emptyViewTop;
/// 是否加载中
@property (nonatomic,assign) BOOL loading;
@end

@implementation UIScrollView (EmptyView)

/// 交换方法
/// @param method1 方法1
/// @param method2 方法2
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    Method originalMethod = class_getInstanceMethod(self, method1);
    Method swizzledMethod = class_getInstanceMethod(self, method2);
    BOOL addSuccess = class_addMethod(self, method1, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addSuccess) {
        class_replaceMethod(self, method2, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark- public【公共方法】

/// emptyView显示（当设置 autoShow=No 时，手动操作）
- (void)yj_emptyViewShow{
    if (self.loading == YES) return; // 正在加载数据
    // 优先使用代理获取的emptyView布局
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewFromSuperView:)]) {
        self.yj_emptyView = [self.yj_emptyViewDataSource emptyViewFromSuperView:self];
    }
    BOOL total = [self totalDataCount];
    self.yj_emptyView.hidden = total;
    [self bringSubviewToFront:self.yj_emptyView];
    if ([self.yj_emptyView respondsToSelector:@selector(emptyViewShowUpdateStatus:superView:)]) {
        [self.yj_emptyView emptyViewShowUpdateStatus:!total superView:self];
    }
    
    // 设置emptyView 的frame
    CGSize emptyViewSize = CGSizeMake(200, 200);
    if ([self.yj_emptyView respondsToSelector:@selector(emptyViewInitSize)]) {
        emptyViewSize = [self.yj_emptyView emptyViewInitSize];
    }
    
    CGFloat x = (self.bounds.size.width - emptyViewSize.width) / 2.0;
    CGFloat y = self.emptyViewTop;
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewEdgeInset:superView:)]) {
        UIEdgeInsets edge = [self.yj_emptyViewDataSource emptyViewEdgeInset:self.yj_emptyView superView:self];
        emptyViewSize.width -= edge.left + edge.right;
        x = (self.bounds.size.width - emptyViewSize.width) / 2.0;
        y += edge.top;
    }
    
    
    
    if ([self isKindOfClass:[UITableView class]]) {
        CGRect tableViewHeaderFrame = ((UITableView *)self).tableHeaderView.frame;
        y += tableViewHeaderFrame.origin.y + tableViewHeaderFrame.size.height;
    }
    self.yj_emptyView.frame = CGRectMake(x, y, emptyViewSize.width, emptyViewSize.height);
}

/// emptyView隐藏（当设置 autoShow=No 时，手动操作）
- (void)yj_emptyViewHide{
    if (!self.yj_emptyView) return;
    if (!self.autoShow) return;
    self.yj_emptyView.hidden = YES;
}

/// 开始加载数据 （必须和yj_endLoading配套使用）
- (void)yj_beginLoading{
    self.loading = YES;
    self.yj_emptyView.hidden = YES;
}

/// 结束加载数据 （必须和yj_beginLoading配套使用）
- (void)yj_endLoading{
    self.loading = NO;
    [self autoShow];
}

/// 更新top，默认kEmptyViewTop
- (void)yj_updateEmptyViewTop:(CGFloat)top{
    [self setEmptyViewTop:top];
}

#pragma mark- private 【私有方法】

/// 自动显示
- (void)autoShowEmptyView{
    if (self.autoShow == NO) return;  // 关闭自动显示emptyView
    // 显示
    if (@available(iOS 11.0, *)) {
        __weak typeof(self) weakSelf = self;
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            [tableView performBatchUpdates:^{
                
            } completion:^(BOOL finished) {
                [weakSelf yj_emptyViewShow];
            }];
        }else if ([self isKindOfClass:[UICollectionView class]]){
            UICollectionView *collectionView = (UICollectionView *)self;
            [collectionView performBatchUpdates:^{
                
            } completion:^(BOOL finished) {
                [weakSelf yj_emptyViewShow];
            }];
        }else{
            [self yj_emptyViewShow];
        }
        
    } else {
        [self yj_emptyViewShow];
    }
    
}

/// 获取cell的个数
- (NSInteger)totalDataCount{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

/// 对EmptyView 赋值
- (void)handleSetEmptyViewWithView:(UIView<YJEmptyViewDelegate> *)view{
    NSAssert((view && [view conformsToProtocol:@protocol(YJEmptyViewDelegate)]), @"该view未遵循<YJEmptyViewDelegate>");
    
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewFromSuperView:)]) {  // 优先使用代理
        view = [self.yj_emptyViewDataSource emptyViewFromSuperView:self];
    }
    if (view != self.yj_emptyView) {
        [self.yj_emptyView removeFromSuperview];
        objc_setAssociatedObject(self, @selector(yj_emptyView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:view];
        view.hidden = YES;
    }
}

///// 对loadingView 赋值
//- (void)handleSetLoadingViewWithView:(UIView *)view{
//    if (view == nil) {
//        return;
//    }
//    if (view != self.yj_loadingView) {
//        [self.yj_loadingView removeFromSuperview];
//        objc_setAssociatedObject(self, @selector(yj_loadingView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        [self addSubview:view];
//        view.hidden = YES;
//    }
//}

#pragma mark- getting && setting
/// 空白页占位View
- (UIView<YJEmptyViewDelegate> *)yj_emptyView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setYj_emptyView:(UIView<YJEmptyViewDelegate> *)yj_emptyView{
    [self handleSetEmptyViewWithView:yj_emptyView];
}

///// 加载中占位View
//- (UIView *)yj_loadingView{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setYj_loadingView:(UIView *)yj_loadingView{
//    [self handleSetLoadingViewWithView:yj_loadingView];
//}

/// 是否自动显示空白页  define Yes
- (BOOL)autoShow{
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        return YES;
    }
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setAutoShow:(BOOL)autoShow{
    if (autoShow == YES) { //自动显示emptyView
        [self yj_emptyViewShow];
    }else{  // 主动隐藏
        self.yj_emptyView.hidden = YES;
    }
    objc_setAssociatedObject(self, @selector(autoShow), @(autoShow), OBJC_ASSOCIATION_ASSIGN);
}

/// 空白占位View数据源
- (id<YJEmptyViewDataSource>)yj_emptyViewDataSource{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setYj_emptyViewDataSource:(id<YJEmptyViewDataSource>)yj_emptyViewDataSource{
    objc_setAssociatedObject(self, @selector(yj_emptyViewDataSource), yj_emptyViewDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 空白占位View的top 距离
- (CGFloat)emptyViewTop{
    CGFloat emptyTop = kEmptyViewTop;
    if (objc_getAssociatedObject(self, _cmd)) {  // 说明设过值
        emptyTop = [objc_getAssociatedObject(self, _cmd) floatValue];
    }
    return emptyTop;
}
- (void)setEmptyViewTop:(CGFloat)emptyViewTop{
    objc_setAssociatedObject(self, @selector(emptyViewTop), @(emptyViewTop), OBJC_ASSOCIATION_ASSIGN);
}

/// 是否加载中
- (BOOL)loading{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setLoading:(BOOL)loading{
    objc_setAssociatedObject(self, @selector(loading), @(loading), OBJC_ASSOCIATION_ASSIGN);
}

@end


#pragma mark- UITableView-------------------
@implementation UITableView (Empty)
+ (void)load{
    
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(yj_reloadData)];
    
    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:withRowAnimation:) method2:@selector(yj_insertSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:withRowAnimation:) method2:@selector(yj_deleteSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:withRowAnimation:) method2:@selector(yj_reloadSections:withRowAnimation:)];
    
    ///row
    [self exchangeInstanceMethod1:@selector(insertRowsAtIndexPaths:withRowAnimation:) method2:@selector(yj_insertRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteRowsAtIndexPaths:withRowAnimation:) method2:@selector(yj_deleteRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadRowsAtIndexPaths:withRowAnimation:) method2:@selector(yj_reloadRowsAtIndexPaths:withRowAnimation:)];
    
    [self exchangeInstanceMethod1:@selector(setTableHeaderView:) method2:@selector(yj_setTableHeaderView:)];
}
- (void)yj_reloadData{
    [self yj_reloadData];
    
    [self autoShowEmptyView];
}
///section
- (void)yj_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_insertSections:sections withRowAnimation:animation];
    [self autoShowEmptyView];
}
- (void)yj_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_deleteSections:sections withRowAnimation:animation];
    [self autoShowEmptyView];
}
- (void)yj_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_reloadSections:sections withRowAnimation:animation];
    [self autoShowEmptyView];
}

///row
- (void)yj_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self autoShowEmptyView];
}
- (void)yj_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self autoShowEmptyView];
}
- (void)yj_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self autoShowEmptyView];
}

- (void)yj_setTableHeaderView:(UIView *)tableHeaderView{
    [self yj_setTableHeaderView:tableHeaderView];
    [self autoShowEmptyView];
}
@end


#pragma mark- UICollectionView
@implementation UICollectionView (Empty)

+ (void)load{
    
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(yj_reloadData)];
    
    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:) method2:@selector(yj_insertSections:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:) method2:@selector(yj_deleteSections:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:) method2:@selector(yj_reloadSections:)];
    
    ///item
    [self exchangeInstanceMethod1:@selector(insertItemsAtIndexPaths:) method2:@selector(yj_insertItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(deleteItemsAtIndexPaths:) method2:@selector(yj_deleteItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(reloadItemsAtIndexPaths:) method2:@selector(yj_reloadItemsAtIndexPaths:)];
    
}
- (void)yj_reloadData{
    [self yj_reloadData];
    [self autoShowEmptyView];
}
///section
- (void)yj_insertSections:(NSIndexSet *)sections{
    [self yj_insertSections:sections];
    [self autoShowEmptyView];
}
- (void)yj_deleteSections:(NSIndexSet *)sections{
    [self yj_deleteSections:sections];
    [self autoShowEmptyView];
}
- (void)yj_reloadSections:(NSIndexSet *)sections{
    [self yj_reloadSections:sections];
    [self autoShowEmptyView];
}

///item
- (void)yj_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_insertItemsAtIndexPaths:indexPaths];
    [self autoShowEmptyView];
}
- (void)yj_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_deleteItemsAtIndexPaths:indexPaths];
    [self autoShowEmptyView];
}
- (void)yj_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_reloadItemsAtIndexPaths:indexPaths];
    [self autoShowEmptyView];
}
@end
