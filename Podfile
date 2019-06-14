platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'ios-base' do
  pod 'Alamofire', '~> 4.8.1'
  pod 'Moya/RxSwift', '~> 13.0'
  pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  pod 'RSFontSizes', '~> 1.0.2'
  pod 'Firebase/Core', '~> 6.1.0'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'RxSwift', '~> 4.5.0'
  pod 'RxCocoa', '~> 4.5.0'

  # FB SDK ---
  pod 'FBSDKCoreKit', '~> 4.33.0'
  pod 'FBSDKLoginKit', '~> 4.33.0'
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.7.4', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.7.3', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 8.0.0', :configurations => ['Debug']
end
