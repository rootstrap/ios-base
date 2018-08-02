platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'ios-base' do
  pod 'Alamofire', '~> 4.7.2'
  pod 'IQKeyboardManagerSwift', '~> 6.0.1'

  # FB SDK ---
  pod 'FBSDKCoreKit', '~> 4.33.0'
  pod 'FBSDKLoginKit', '~> 4.33.0'
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.7.3', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.7.3', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 6.1.0', :configurations => ['Debug']
end
