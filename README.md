[![Build Status](https://img.shields.io/travis/rootstrap/ios-base/master.svg)](https://travis-ci.org/rootstrap/ios-base)
[![Maintainability](https://api.codeclimate.com/v1/badges/21b076c80057210cda75/maintainability)](https://codeclimate.com/github/rootstrap/ios-base/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/21b076c80057210cda75/test_coverage)](https://codeclimate.com/github/rootstrap/ios-base/test_coverage)
[![License](https://img.shields.io/github/license/rootstrap/ios-base.svg)](https://github.com/rootstrap/ios-base/blob/master/LICENSE.md)

# iOS Base Template
**iOS base** is a boilerplate project created by Rootstrap for new projects using Swift 5. The main objective is helping any new projects jump start into feature development by providing a handful of functionalities.

## Features
This template comes with:
#### Main
- Complete **API service** class to easily communicate with **REST services**.
- Examples for **account creation** and **Facebook integration**.
- Useful classes to **manage User and Session data**.
- **Secure** way to store keys of your **third party integrations**.
- Generic implementation of **navigation** between view controllers.
- Handy **helpers** and **extensions** to make your coding experience faster and easier.


#### Extensions
 This App Template also contains other branches with specific features that may be of use to you:

- [**feature/mvvm+rxswift**](https://github.com/rootstrap/ios-base/tree/feature/mvvm%2Brxswift) in case you want to work with **RxSwift** and **MVVM**.
- [**feature/moya_integration**](https://github.com/rootstrap/ios-base/tree/feature/moya_integration) manage routes and HTTP resources with Moya and Alamofire.

To use them simply download the branch and locally rebase against master/develop from your initial **iOS base** clone.
**Important**: See steps below on how to install this features.

## How to use
1. Clone repo.
2. Install desired extensions from their branches.
3. Run `./init` from the recently created folder.
4. Initialize a new git repo and add your remote url.
5. Done!

To manage user and session persistence after the original sign in/up we store that information in the native UserDefaults. The parameters that we save are due to the usage of [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) for authentication on the server side. Suffice to say that this can be modified to be on par with the server authentication of your choice.

## Pods
#### Main
 - [Alamofire](https://github.com/Alamofire/Alamofire) for easy and elegant connection with an API.
 - [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager) for auto-scrolling to current input in long views.
    Note: this pod is not fully working on iOS 11. [Here](https://github.com/hackiftekhar/IQKeyboardManager/issues/972) is the issue we encountered and the meantime solution.
 - [R.swift](https://github.com/mac-cain13/R.swift) for strongly typed and autocompleted assets, segues and more.


#### Utilities

We have developed other libraries that can be helpful and you could integrate with the dependency manager of your choice.

- **[PagedLists:](https://github.com/rootstrap/PagedLists)** Custom `UITableView` and `UICollectionView` classes to easily handle pagination.
- **[RSFontSizes:](https://github.com/rootstrap/RSFontSizes)** allows you to manage different font sizes for every device screen size in a flexible manner.
- **[RSFormView:](https://github.com/rootstrap/RSFormView)** a library that helps you to build fully customizable forms for data entry in a few minutes.
- **[SwiftGradients:](https://github.com/rootstrap/SwiftGradients)** Useful extensions for `UIViews` and `CALayer` classes to add beautiful color gradients.


#### Testing
 - [KIF](https://github.com/kif-framework/KIF) for UI testing.
 - [KIF/IdentifierTests](https://github.com/kif-framework/KIF) to have access to accesibility identifiers.

#### Optional
 - [FBSDKCoreKit](https://github.com/facebook/facebook-ios-sdk) facebook pods dependency.
 - [FBSDKLoginKit](https://github.com/facebook/facebook-ios-sdk) for facebook login.

## Optional configuration
#### facebook
1. In `info.plist` on the URL types array, find `fbXXXXXXXXXXX` and replace it for the string "fb" + the ID of your app. i.e: `fb435272928934`.
2. Change the `FacebookAppID` value for the same AppID that you replace above.
3. Change the `FacebookDisplayName` value for the name of the app on Facebook.
4. Done :)

## Code Quality Standards
In order to meet the required code quality standards,  this project runs [SwiftLint](https://github.com/realm/SwiftLint )
during the build phase and reports warnings/errors directly through XCode.
The current SwiftLint rule configuration is based on [Rootstrap's Swift style guides](https://rootstrap.github.io/swift) and is synced with
the CodeCliemate's configuration file.

**NOTE:** Make sure you have SwiftLint version 0.35.0 or greater installed to avoid known false-positives with some of the rules.

## Security recommendations

### Third Party Keys

We strongly recommend that all private keys be added to a `.plist` file that will remain locally and not be committed to your project repo. An example file is already provided, these are the final steps to set it up:

1. Rename the `ThirdPartyKeys.example.plist` file on your project so that it is called `ThirdPartyKeys.plist`.
  To add a set of keys simply add a dictionary with the name you want the key to have and add the corresponding **Debug**, **Staging** and **Release** keys as items.
2. Remove the reference of `ThirdPartyKeys.plist` from XCode but do not delete the file. This way, you will keep the file locally(it is already in the .gitignore list) in the project directory.
  **Note: Do NOT move the file from the current location, the script uses the $(PROJECT_DIR) directory.**
3. Go to **Product** -> **Scheme** -> **Edit scheme**. Then select **Pre-actions** for the Build stage and make sure that the `Provided build setting` is set to your current target.
**Repeat this step for the Post-actions script.**
4. Done :)

#### Secure storage

We recommend using [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) for storing `.plist` files containing Third Party keys, as well as any other sensitive files. Alternatively when not using Fastlane Match (eg might not be compatible with some CICD systems), AWS S3 can also be used for storing Certificates, Private Keys and Profiles required for app signing. The CICD code examples (described below) make use of the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) to download any files relevant for our project from a predefined bucket and folder 

Another alternative for managing sensitive files whithin the repo using Git-Secret can be found in the [**feature/git-secret**]
(https://github.com/rootstrap/ios-base/tree/feature/jenkins) branch 


## Automated Build and Deployment using Fastlane

We use [Fastlane](https://docs.fastlane.tools) to automate code signing, building and release to TestFlight. 

See details in [Fastlane folder](fastlane/README.md).

## Continuous Integration / Delivery

We recommend [GitHub Actions](https://docs.github.com/en/actions) for integrating Fastlane into a CI/CD pipeline. You can find two workflows in the GitHub workflows folder:
* [ci.yml](.github/workflows/release.myl)       : triggered on any push and PR, runs unit tests, coverage report and static analysis with [CodeClimate](https://github.com/codeclimate/codeclimate)
* [release.yml](.github/workflows/release.yml)  : triggered on push to specific branches, builds, signs and submits to TestFlight

Alternatively you can merge branch [**feature/jenkins**](https://github.com/rootstrap/ios-base/tree/feature/jenkins) for some equivalent CICD boilerplate with **Jenkins**.

On both alternatives we assume usage of Fastlane match for managing signing Certificates and Profiles, and AWS S3 for storing other files containing third-party keys 

## License

iOS-Base is available under the MIT license. See the LICENSE file for more info.

**NOTE:** Remove the free LICENSE file for private projects or replace it with the corresponding license.

## Credits

**iOS Base** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/ios-base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
