# YJEmptyView
[![CocoaPods](https://img.shields.io/cocoapods/v/YJEmptyView.svg?style=flat)](https://cocoapods.org/pods/YJEmptyView)&nbsp;
[![CocoaPods](https://img.shields.io/cocoapods/p/YJEmptyView.svg)](https://github.com/indulgeIn/YJEmptyView)&nbsp;


A beautiful display of data blank page frame, at the same time, high expansibility

一个优美显示数据空白页的框架，同时拓展性高

#### 效果展示
    1、一般空白页  2、有点击按钮的空白页  3、识别tableView的headerView自适应  4、DIY空白页
<img src="https://github.com/YJExpand/YJEmptyView/blob/main/YJEmptyView/YJEmptyView/ExamplePhoto/normal.png" width="40%" height="40%">              <img src="https://github.com/YJExpand/YJEmptyView/blob/main/YJEmptyView/YJEmptyView/ExamplePhoto/click.png" width="40%" height="40%">
<img src="https://github.com/YJExpand/YJEmptyView/blob/main/YJEmptyView/YJEmptyView/ExamplePhoto/headerView.png" width="40%" height="40%">              <img src="https://github.com/YJExpand/YJEmptyView/blob/main/YJEmptyView/YJEmptyView/ExamplePhoto/DIY.png" width="40%" height="40%">

## 一、Installation 安装
#### CocoaPods
1. 在 Podfile 中添加：
```
pod 'YJEmptyView'
```
2. 执行 `pod install` 或 `pod update`。
3. 导入 `<YJEmptyView/YJEmptyViewHeader.h>`

若搜索不到库，可执行`pod repo update`，或使用 `rm ~/Library/Caches/CocoaPods/search_index.json` 移除本地索引然后再执行安装，或更新一下 CocoaPods 版本。
#### 手动安装
> 将YJEmptyView文件夹拽入项目中，导入头文件：#import "YJEmptyViewHeader.h"

## 二、Example 例子
1、简单使用
```
self.tableView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:@"占位图" titleText:@"文字提示"];
```
2、使用代理<YJEmptyViewDataSource>
```
/// 设置代理
self.tableView.yj_emptyViewDataSource = self;

///实现该协议方法，可自定义UIView遵循<YJEmptyViewDelegate>
- (UIView<YJEmptyViewDelegate> *)emptyViewFromSuperView:(UIScrollView *)superView;
```
3、DIY
```
@interface DIYEmptyView : UIView<YJEmptyViewDelegate>
@end
@implementation DIYEmptyView
-----
各种操作（UI、action...）
-----
@end
⚠️⚠️⚠️：处理emptyView的高度
方案一、可使用自动撑开进行布局  
方案二、self.tableView.yj_emptyViewDataSource = self;
        实现<YJEmptyViewDataSource>的协议方法，返回size
        - (CGSize)emptyViewSize:(UIView<YJEmptyViewDelegate> *)emptyView superView:(UIScrollView *)superView;
self.tableView.yj_emptyView = [[DIYEmptyView alloc] init];
```
## 三、 Release Notes 最近更新 
1.2.0 发布正式版本

1.2.1 修复EmptyView 自适应布局的问题

1.2.2 修复EmptyView 部分情况下约束冲突问题
