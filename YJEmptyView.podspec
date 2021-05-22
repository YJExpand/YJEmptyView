
Pod::Spec.new do |spec|
  spec.name         = "YJEmptyView"
  spec.version      = "1.2.1"
  spec.summary      = "A beautiful framework for displaying emptyView"
  spec.homepage     = "https://github.com/YJExpand/YJEmptyView.git"
  spec.license      = "MIT"
  spec.author       = { "YJExpand" => "YJExpand@163.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/YJExpand/YJEmptyView.git", :tag => "1.2.1" }
  spec.source_files  = "YJEmptyView/YJEmptyView/YJEmptyView/*.{h,m}"
  # spec.public_header_files = "Classes/**/*.h"
  spec.requires_arc = true
end
