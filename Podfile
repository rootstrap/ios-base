platform :ios, '11.4'
use_frameworks!
inhibit_all_warnings!

target 'ios-base' do
  pod 'Alamofire', '~> 5.2.0'
  pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  pod 'RSFontSizes', '~> 1.0.2'
  pod 'Firebase/Core', '~> 6.1.0'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'R.swift', '~> 5.0.3'

  # Uncomment if needed ---
  # pod 'PagedLists', '~> 1.0.0'
  # pod 'RSFormView', '~> 2.1.1'
  # pod 'SwiftGradients', '~> 1.0.0'
  # ------

  # FB SDK ---
  pod 'FBSDKCoreKit', '~> 5.5.0'
  pod 'FBSDKLoginKit', '~> 5.5.0'
  # ------
  
  target 'ios-baseUITests' do
    inherit! :complete
    pod 'Swifter', '~> 1.4.7'
  end
end
