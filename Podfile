platform :ios, '10.0'
use_frameworks!

target 'swift-base' do
  pod 'Alamofire', '~> 4.5.1'
  pod 'SwiftyJSON', '~> 3.1.3'
  pod 'IQKeyboardManagerSwift', '~> 5.0.4'

  # FB SDK ---
  pod 'FBSDKCoreKit';
  pod 'FBSDKLoginKit';
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.5.2', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.5.2', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 6.0.0', :configurations => ['Debug']
end
