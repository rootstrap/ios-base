platform :ios, '14.0'
use_frameworks!
inhibit_all_warnings!

# Add here all the necessary keys used in the project.
# Then update the setup-secrets.sh to fill in the value for the new key.
plugin 'cocoapods-keys', {
  project: "ios-base",
  keys: [
    "FacebookAppID",
    "FacebookAPIKey"
  ]
}

# Injects all the secrets from the environment variables
# This is to avoid the `pod install` step asking for key input.
pre_install do |_|
  system("chmod +x .setup-secrets.sh")
  system("./.setup-secrets.sh")
end

target 'ios-base' do
  pod 'Alamofire', '~> 5.2.0'
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
