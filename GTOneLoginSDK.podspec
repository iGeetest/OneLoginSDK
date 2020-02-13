#
# Be sure to run `pod lib lint OneLoginSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GTOneLoginSDK'
  s.version          = '2.1.0'
  s.summary          = '极验一键登录SDK'
  s.homepage         = 'https://www.geetest.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geetest' => 'liulian@geetest.com' }
  s.source           = { :git => 'https://github.com/iGeetest/OneLoginSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.frameworks = 'CFNetwork', 'CoreTelephony', 'Foundation', 'SystemConfiguration', 'UIKit'
  s.libraries = 'c++.1', 'z.1.2.8'

  s.vendored_frameworks = 'SDK/account_login_sdk_noui_core.framework', 'SDK/EAccountApiSDK.framework', 'SDK/TYRZSDK.framework', 'SDK/OneLoginSDK.framework'
  s.resources = 'SDK/OneLoginResource.bundle', 'README.md'

  # s.subspec 'GTDeepknow' do |sd|
  #   sd.framework = 'AdSupport'
  #   sd.vendored_frameworks = 'SDK/DeepKnowSDK.framework'
  # end

end
