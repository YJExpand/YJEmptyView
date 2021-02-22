//
//  UIScrollView+EmptyView.m
//  yjEmptyView
//
//  Created by YJExpand on 2021/1/1.
//

#import "UIScrollView+EmptyView.h"
#import <objc/runtime.h>

#define kEmptyViewTop 130.f

@interface UIScrollView()
@property (nonatomic,strong) NSMutableArray<NSLayoutConstraint *> *emptyConstraintArr;
@property (nonatomic,strong) NSMutableArray<NSLayoutConstraint *> *emptyConstraintSizeArr;
@property (nonatomic,assign) CGFloat emptyViewTop;
@end

@implementation UIScrollView (EmptyView)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

- (UIView<YJEmptyViewDelegate> *)yj_emptyView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setYj_emptyView:(UIView<YJEmptyViewDelegate> *)yj_emptyView{
    if (objc_getAssociatedObject(self, @selector(autoShowEmptyView)) == nil) {
        self.autoShowEmptyView = YES;
    }
    [self handleSetEmptyViewWithView:yj_emptyView];
    if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UITableView class]]) {
        [self yj_showEmptyView];
    }
}

- (BOOL)autoShowEmptyView{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setAutoShowEmptyView:(BOOL)autoShowEmptyView{
    objc_setAssociatedObject(self, @selector(autoShowEmptyView), @(autoShowEmptyView), OBJC_ASSOCIATION_ASSIGN);
}

- (id<YJEmptyViewDataSource>)yj_emptyViewDataSource{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setYj_emptyViewDataSource:(id<YJEmptyViewDataSource>)yj_emptyViewDataSource{
    objc_setAssociatedObject(self, @selector(yj_emptyViewDataSource), yj_emptyViewDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSLayoutConstraint *> *)emptyConstraintArr{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEmptyConstraintArr:(NSMutableArray<NSLayoutConstraint *> *)emptyConstraintArr{
    objc_setAssociatedObject(self, @selector(emptyConstraintArr), emptyConstraintArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSLayoutConstraint *> *)emptyConstraintSizeArr{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEmptyConstraintSizeArr:(NSMutableArray<NSLayoutConstraint *> *)emptyConstraintSizeArr{
    objc_setAssociatedObject(self, @selector(emptyConstraintSizeArr), emptyConstraintSizeArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)emptyViewTop{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setEmptyViewTop:(CGFloat)emptyViewTop{
    objc_setAssociatedObject(self, @selector(emptyViewTop), @(emptyViewTop), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark- public
- (void)yj_emptyViewReloadData{
    [self yj_showEmptyView];
}

- (void)yj_emptyLoadDataBegin{
    self.autoShowEmptyView = NO;
    self.yj_emptyView.hidden = YES;
}

- (void)yj_emptyLoadDataEnd{
    self.autoShowEmptyView = YES;
    [self yj_showEmptyView];
}

- (void)yj_updateEmptyViewTop:(CGFloat)top{
    self.emptyViewTop = top;
    [self handleEmptyContaint];
}

#pragma mark- private
- (void)removeEmptyView{
    if (self.yj_emptyView) {
        [self.yj_emptyView removeFromSuperview];
    }
}
- (void)yj_showEmptyView{
    
    if (self.autoShowEmptyView == NO) return;
    
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewFromSuperView:)]) {  // 优先使用代理
        [self handleSetEmptyViewWithView:[self.yj_emptyViewDataSource emptyViewFromSuperView:self]];
    }
    
    [self handleEmptyContaint];
    
    BOOL total = [self totalDataCount];
    self.yj_emptyView.hidden = total;
    [self bringSubviewToFront:self.yj_emptyView];
    [self.yj_emptyView updateEmptyViewShowStatus:!total superView:self];
    
}
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

- (void)handleSetEmptyViewWithView:(UIView<YJEmptyViewDelegate> *)view{
    NSAssert((view && [view conformsToProtocol:@protocol(YJEmptyViewDelegate)]), @"该view未遵循<YJEmptyViewDelegate>");
    [self removeEmptyView];
    if (view != self.yj_emptyView) {
        objc_setAssociatedObject(self, @selector(yj_emptyView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:view];
        view.hidden = YES;
    }
}
- (void)handleEmptyContaint{
    if (!self.yj_emptyView) return;
    if (self.emptyConstraintArr.count) {
        [self removeConstraints:self.emptyConstraintArr];
    }
    self.emptyConstraintArr = [NSMutableArray array];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewEdgeInset:superView:)]) {
        edge = [self.yj_emptyViewDataSource emptyViewEdgeInset:self.yj_emptyView superView:self];
    }
    CGFloat emptyTop = kEmptyViewTop;
    if (objc_getAssociatedObject(self, _cmd)) {  // 说明设过值
        emptyTop = self.emptyViewTop;
    }
    NSLayoutConstraint *top;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        if (tableView.tableHeaderView) {
            top = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tableView.tableHeaderView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:edge.top];
        }else{
            top = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:emptyTop+edge.top];
        }
    }else{
        top = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:emptyTop+edge.top];
    }
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-(fabs(edge.left)+fabs(edge.right))];
    [self.emptyConstraintArr addObjectsFromArray:@[top,centerX,width]];
    
    if ([self.yj_emptyViewDataSource respondsToSelector:@selector(emptyViewSize:superView:)]) {
        CGSize viewSize = [self.yj_emptyViewDataSource emptyViewSize:self.yj_emptyView superView:self];
        [self.emptyConstraintArr removeObject:width];
        if (self.emptyConstraintSizeArr.count) {
            [self.yj_emptyView removeConstraints:self.emptyConstraintArr];
        }
        self.emptyConstraintSizeArr = [NSMutableArray array];
        NSLayoutConstraint *newWidth = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewSize.width];
        NSLayoutConstraint *newHeight = [NSLayoutConstraint constraintWithItem:self.yj_emptyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewSize.height];
        [self.emptyConstraintSizeArr addObjectsFromArray:@[newWidth,newHeight]];
        [self.yj_emptyView addConstraints:self.emptyConstraintSizeArr];
    }
    [self addConstraints:self.emptyConstraintArr];
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
    [self yj_showEmptyView];
}
///section
- (void)yj_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_insertSections:sections withRowAnimation:animation];
    [self yj_showEmptyView];
}
- (void)yj_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_deleteSections:sections withRowAnimation:animation];
    [self yj_showEmptyView];
}
- (void)yj_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_reloadSections:sections withRowAnimation:animation];
    [self yj_showEmptyView];
}

///row
- (void)yj_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self yj_showEmptyView];
}
- (void)yj_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self yj_showEmptyView];
}
- (void)yj_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self yj_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self yj_showEmptyView];
}

- (void)yj_setTableHeaderView:(UIView *)tableHeaderView{
    [self yj_setTableHeaderView:tableHeaderView];
    [self handleEmptyContaint];
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
    [self yj_showEmptyView];
}
///section
- (void)yj_insertSections:(NSIndexSet *)sections{
    [self yj_insertSections:sections];
    [self yj_showEmptyView];
}
- (void)yj_deleteSections:(NSIndexSet *)sections{
    [self yj_deleteSections:sections];
    [self yj_showEmptyView];
}
- (void)yj_reloadSections:(NSIndexSet *)sections{
    [self yj_reloadSections:sections];
    [self yj_showEmptyView];
}

///item
- (void)yj_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_insertItemsAtIndexPaths:indexPaths];
    [self yj_showEmptyView];
}
- (void)yj_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_deleteItemsAtIndexPaths:indexPaths];
    [self yj_showEmptyView];
}
- (void)yj_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self yj_reloadItemsAtIndexPaths:indexPaths];
    [self yj_showEmptyView];
}
@end
