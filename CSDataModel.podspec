#
# Be sure to run `pod lib lint CSDataModel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CSDataModel'
  s.version          = '1.0.0'
  s.summary          = 'Dictionary & Array Convert to Custom Objective-C DataModel Object'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = 'It\'s a simple use runtime to convert NSDictionary & NSArray to custom DataModel;\nCustom Object\'s property must NSObject such as: NSString NSNumber NSArray...'

  s.homepage         = 'https://github.com/csdq/CSDataModel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mr.s' => 'stqemail@163.com' }
  s.source           = { :git => 'https://github.com/csdq/CSDataModel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

s.source_files = 'CSDataModel/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'CSDataModel' => ['CSDataModel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
