## Installation

Instructions for install the project, change the name and use this project

1) Clone repo.

2) Change the name of the project on the left sidbar in Xcode.

3) Enter on Manage Schemas and change the name to the new one.

4) Close Xcode.

5) Rename the main and the source folder.

6) Right click the project bundle .xcodeproj file and select “Show Package Contents” from the context menu.

7) Open the .pbxproj file with any text editor.

8) Search and replace any occurrence of the original folder name with the new folder name.

9) Save the file.

10) Open Podfile and change the target name with the new name of your project.

11) Run pod install.

12) Done :)

## Travis - SwiftLint configuration

1) Replace any occurrence of swift-base in the .travis.yml file.

2) Login into travis-ci.com with your github account

3) Add the project to the list of projects to build

4) Happy linting :)

## Danger integration

## Facebook integration

The project already include the FBSDK and the configuration needed on the .plist file. After create a Facebook App you only need to replace:

1) On the URL types array, the value on the "Item 0" for the string "fb" + the ID of your app. i.e: "fb435272928934".

2) The "FacebookAppID" value for the same AppID that you replace above.

3) The "FacebookDisplayName" value for the name of the app on Facebook.

4) Done.
