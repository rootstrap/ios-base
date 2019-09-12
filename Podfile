platform :ios, '11.4'
use_frameworks!
inhibit_all_warnings!

target 'ios-base' do
  pod 'Alamofire', '~> 4.8.1'
  pod 'Moya', '~> 13.0'
  pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  pod 'RSFontSizes', '~> 1.0.2'
  pod 'Firebase/Core', '~> 6.1.0'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'R.swift', '~> 5.0.3'

  # FB SDK ---
  pod 'FBSDKCoreKit', '~> 5.5.0'
  pod 'FBSDKLoginKit', '~> 5.5.0'
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.7.4', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.7.3', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 8.0.0', :configurations => ['Debug']
end
