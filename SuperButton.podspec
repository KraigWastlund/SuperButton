#
# Be sure to run `pod lib lint SuperButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SuperButton'
  s.version          = '0.6.3'
  s.summary          = 'Multifunction ui button'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A button that expands into at most 7 buttons allowing more functionality in a small space.
                       DESC

  s.homepage         = 'https://github.com/kraigwastlund/SuperButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kraigwastlund' => 'kraigwastlund@gmail.com' }
  s.source           = { :git => 'https://github.com/kraigwastlund/SuperButton.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kraigwastlund'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SuperButton/Classes/**/*'
  # s.resources = 'SuperButton/Assets/**/*.pdf'
  s.resource_bundles = {
    'SuperButton' => ['SuperButton/Assets/*.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency
end
