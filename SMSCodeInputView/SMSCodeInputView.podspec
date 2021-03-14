#
# Be sure to run `pod lib lint SMSCodeInputView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMSCodeInputView'
  s.version          = '0.1.0'
  s.summary          = 'SMSCodeInputView is class for displaying OneTimePassword view. UI can be easy customized. Pure Swift.'

  s.description      = <<-DESC
  	SMSCodeInputView encapsulates several UITextField inside UIStackView. It can be easily customized.
  	Use this class for OTP from SMS (or othe sources).
	It uses password auto fill feature starting from iOS 12. 
                       DESC

  s.homepage         = 'https://github.com/Sergey Zalozniy/SMSCodeInputView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Zalozniy' => 's.zalozniy1900@gmail.com' }
  s.source           = { :git => 'https://github.com/Sergey Zalozniy/SMSCodeInputView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SMSCodeInputView/Classes/**/*'
  
  s.swift_versions = ['5.0']
  # s.resource_bundles = {
  #   'SMSCodeInputView' => ['SMSCodeInputView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
