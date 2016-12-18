#
#  Be sure to run `pod spec lint DPSlideMenuKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DPSlideMenuKit"
  s.version      = "0.1.1"
  s.summary      = "slide menu"

  s.description  = <<-DESC
                    simple slide menu kit with different colors
                    DESC

  s.homepage     = "https://github.com/HongliYu/DPSlideMenuKit-Swift"
  s.license      = "MIT"
  s.author       = { "HongliYu" => "yhlssdone@gmail.com" }
  s.source       = { :git => "https://github.com/HongliYu/DPSlideMenuKit-Swift.git", :tag => "0.1.1" }

  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source_files = "DPSlideMenuKit/"
  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.module_name  = 'DPSlideMenuKit'

end
