platform :ios, '14.0'
use_frameworks!
inhibit_all_warnings!

target 'ios-base' do
  pod 'RSSwiftNetworking/AlamofireProvider', '~> 1.1.0'
  pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  pod 'RSFontSizes', '~> 1.2.0'
  pod 'R.swift', '~> 5.0.3'
  pod 'SwiftLint', '~> 0.43.1'
  pod 'Firebase/CoreOnly', '~> 8.6.0'
  pod 'Firebase/Analytics', '~> 8.6.0'
  pod 'Firebase/Crashlytics', '~> 8.6.0'

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
    pod 'Swifter', '~> 1.5.0'
  end
end
