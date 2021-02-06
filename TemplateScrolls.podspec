#
# Be sure to run `pod lib lint TemplateScrolls.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TemplateScrolls'
  s.version          = '1.0.2'
  s.summary          = '不需要手动实现 TableView CollectionView 的 dataSource, delegate 协议的滚动列表'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    系统的 Table Collection View 非常实用，但是总是有一大堆代理方法必须要写。
    该组件默认实现了所有的代理方法，使用时免写了大量的代理方法，只需要少量的配置代码。
    并且还支持 TableView 自适应高度、高度缓存.
    CollectionView 暂时还必须要自行指定宽高.
    table、collection View 都支持按 section 为单元的 单选、多选
                       DESC

  s.homepage         = 'https://github.com/Zhangguiguang/TemplateScrolls'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GG' => 'zhanggzgzhz@gmail.com' }
  s.source           = { :git => 'https://github.com/Zhangguiguang/TemplateScrolls.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TemplateScrolls/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TemplateScrolls' => ['TemplateScrolls/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'UITableView+FDTemplateLayoutCell', '1.6.0'
  s.dependency 'TTMutableArray', '>= 1.0.1'
  
end
