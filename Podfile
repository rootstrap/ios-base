platform :ios, '10.0'
use_frameworks!

target 'swift-base' do
  pod 'Alamofire', '~> 4.0'
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'SwiftyJSON', '~> 3.1.3'
  pod 'IQKeyboardManagerSwift', '~> 4.0.8'
  pod 'SDWebImage', '~> 3.8'
  
  # FB SDK ---
  pod 'FBSDKCoreKit';
  pod 'FBSDKLoginKit';
  pod 'FBSDKShareKit';
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.5.2', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.5.2', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 6.0.0', :configurations => ['Debug']
end
