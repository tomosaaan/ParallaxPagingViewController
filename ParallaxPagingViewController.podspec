#
#  Be sure to run `pod spec lint ParallaxPagingViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ParallaxPagingViewController"
  s.version      = "0.8.0"
  s.homepage     = "https://github.com/tomokitakahashi/ParallaxPagingViewController"
  s.summary      = "ParallaxPagingViewController is paging library with parallax animation"
  s.license      = "MIT"
  s.author       = { "Tomoki Takahashi" => "tom_aaa_0905@yahoo.co.jp" }
  s.source       = { :git => "https://github.com/tomokitakahashi/ParallaxPagingViewController.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'ParallaxPagingViewController/Sources/*.{swift}'
  s.requires_arc = true
  s.frameworks = "UIKit"
end
