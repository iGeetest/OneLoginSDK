#
# Be sure to run `pod lib lint OneLoginSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'GTOneLoginSDK'
  s.version = '2.3.4' 
  s.summary = '极验一键登录SDK'
  s.homepage = 'https://www.geetest.com'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Geetest' => 'liulian@geetest.com' }
  s.source = { :git => 'https://github.com/iGeetest/OneLoginSDK.git', :tag => s.version.to_s, :submodules => true } 
  s.ios.deployment_target = '8.0'

  s.frameworks = 'CFNetwork', 'CoreTelephony', 'Foundation', 'SystemConfiguration', 'UIKit'
  s.libraries = 'c++.1', 'z.1.2.8'

  s.subspec 'Main' do |dm|
    dm.vendored_frameworks = 'SDK/account_login_sdk_noui_core.framework', 'SDK/EAccountApiSDK.framework', 'SDK/TYRZUISDK.framework', 'SDK/OneLoginSDK.framework'
    dm.resources = 'SDK/OneLoginResource.bundle', 'README.md'
  end

  s.subspec 'CUCC' do |dc|
    dc.vendored_frameworks = 'SDK/KsyzVerify.framework', 'SDK/OAuth.framework'
  end

end
