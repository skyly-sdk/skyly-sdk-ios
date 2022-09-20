#
# Be sure to run `pod lib lint Skyly.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Skyly'
  s.version          = ENV['LIB_VERSION'] || '0.1.0' #fallback to last published version
  s.summary          = 'Skyly SDK for publishers.'
  s.swift_versions   = '5.5.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
**DEPRECATED**: This SDK is deprecated and will be removed in the future. Please use the new SDK: https://github.com/farly-sdk/farly-ios-sdk
DESC

  s.homepage         = 'https://github.com/skyly-sdk/skyly-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Philippe Auriach' => 'philippe.auriach@mobsuccess.com' }
  s.source           = { :git => 'https://github.com/skyly-sdk/skyly-sdk-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Skyly/Classes/**/*'

  s.deprecated = true
  
  # s.resource_bundles = {
  #   'Skyly' => ['Skyly/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
