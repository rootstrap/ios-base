Fastlane documentation
================
We use [Fastlane](https://docs.fastlane.tools/) for automating the iOS application build and submission

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Project setup

1. Generate certificate and profiles for each target
2. [Disable automatic signing](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/Procedures/Procedures.html#//apple_ref/doc/uid/TP40005929-CH4-SW7) for each target in XCode and associate to the right provisioning profile
3. For uploading the builds to TestFlight, [AppStore Connect API](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api) keys are required
4. For uploading the builds to S3, [AWS keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) with valid permissions are required

# Required environment variables

* `FASTLANE_USER`                         : Your App Store Connect / Apple Developer Portal id used for managing certificates and submitting to the App Store
* `FASTLANE_PASSWORD`                     : Your App Store Connect / Apple Developer Portal password, usually only needed if you also set the 
* `FASTLANE_TEAM_ID`                      : Developer Portal team id
* `LANG` and `LC_ALL`                     : These set up the locale your shell and all the commands you execute run at. These need to be set to UTF-8 to work correctly,for example en_US.UTF-8
* `APPLE_CERT`                            : Local path to distribution certificate file to be used for signing the build 
* `APPLE_KEY`                             : Private key (.p12 file) used for encrypting certificate
* `APPLE_KEY_PASSWORD`                    : Password to private key file
* `APP_STORE_CONNECT_API_KEY_KEY_ID`      : AppStore Connect API ID
* `APP_STORE_CONNECT_API_KEY_ISSUER_ID`   : AppStore Connect issuer ID
* `APP_STORE_CONNECT_API_KEY_FILE`        : location of .p8 API key file
* `AWS_ACCESS_KEY_ID`                     : credentials for uploading files to S3
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`
* `BUILDS_BUCKET`                         : S3 bucket to upload the build to
* `SLACK_CHANNEL`                         : Slack webhook url for sending notifications upon completion  
* `SLACK_URL`                             : Slack channel name

# Available Actions

## build_*
* Runs `pod install`
* If needed downloads and installs the corresponding distribution certificate and profile
* Builds and archive corresponding target (.ipa file is kept locally)
```
fastlane build_develop
```

## share_*
* Runs the build steps for the corresponding target
* Gathers build version
* Uploads the resulting .ipa to S3
* Sends a Slack notification
```
fastlane share_develop
```

## release_*
* Checks for the Git status
* Runs the build steps for the corresponding target
* Generates changelog
* Pushes the resulting .ipa to TestFlight
* Sends a Slack notification
```
fastlane release_develop
```
