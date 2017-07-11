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

## Facebook integration

The project already include the FBSDK and the configuration needed on the .plist file. After create a Facebook App you only need to replace:

1) On the URL types array, the value on the "Item 0" for the string "fb" + the ID of your app. i.e: "fb435272928934".

2) The "FacebookAppID" value for the same AppID that you replace above.

3) The "FacebookDisplayName" value for the name of the app on Facebook.

4) Done.

## Third Party keys management 

For security reasons all private api keys will be added on a separated .plist file that will be excluded from git. So you will need to follow the next steps:

1) Rename the ThirdPartyKeys.example.plist file on your project so that it is called ThirdPartyKeys.plist.
  Every entrance of this file should be a dictionary where each key would be *ApiKeyName*. 
  All dictionaries should have one entrance for each environment configuration where the actual value for the specific api key will be set.
  ![screen shot 2017-06-02 at 4 48 30 pm](https://cloud.githubusercontent.com/assets/16453725/26742399/e39db67a-47b3-11e7-9ce6-fd2c894748dd.png)

3) In order to consume the right key for the particular scheme configuration that you are using to build/archive your code you will need to add a run script as a pre-action for both cases. To do this follow the next steps: 
    1. Go to Edit Scheme.
    2. Expand Build options.
    3. Select Pre-actions.
    4. Click on Add a run script.
    5. Set your project on *Provide build setting from* section.
    6. Paste this script:
    ```
    /usr/libexec/PlistBuddy -c "Set :ConfigurationName \"$CONFIGURATION\"" "$PROJECT_DIR/$INFOPLIST_FILE"
    ```
    7. Repeat this steps for Archive options.

4) Done!

## Danger integration

Most of the configuration it's already done inside the swift-base files. The only thing you need to do is add the DANGER_GITHUB_API_TOKEN as a environment variable inside Travis settings for your new repo after configuring Travis. To get this key talk with [@glm4](https://github.com/glm4) or [@pMalvasio](https://github.com/pmalvasio)
