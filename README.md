# YJEmptyView
[![CocoaPods](https://img.shields.io/cocoapods/v/YJEmptyView.svg?style=flat)](https://cocoapods.org/pods/YJEmptyView)&nbsp;
[![CocoaPods](https://img.shields.io/cocoapods/p/YJEmptyView.svg)](https://github.com/indulgeIn/YJEmptyView)&nbsp;
A beautiful display of data blank page frame, at the same time, high expansibility
一个优美显示数据空白页的框架，同时拓展性高
```
self.tableView.yj_emptyView = [YJEmptyBaseView yj_createWithImageName:@"占位图" titleText:@"文字提示"];
```
# 安装
### CocoaPods
1. 在 Podfile 中添加：
```
pod 'YJEmptyView'
```
2. 执行 `pod install` 或 `pod update`。
3. 导入 `<YJEmptyView/YJEmptyView.h>`

若搜索不到库，可执行`pod repo update`，或使用 `rm ~/Library/Caches/CocoaPods/search_index.json` 移除本地索引然后再执行安装，或更新一下 CocoaPods 版本。
### 手动安装
> 将YJEmptyView文件夹拽入项目中，导入头文件：#import "YJEmptyView.h"
