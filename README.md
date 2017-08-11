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

2) Delete the ThirdPartyKeys.plist by just removing the reference from XCode. This way, you will keep the file locally(it is already in the .gitignore list) in the project directory.

    -Note: Do NOT move the file from the current location, the script uses the $(PROJECT_DIR) directory.

3) Go to Product -> Scheme -> Edit scheme. Then select Pre-actions for the Build stage and make sure that the 'Provided build setting' is set to your current target.
    
    -Repeat this step for the Post-actions script. 

4) Done!

## Extensions

If your project needs some specific feature, utility or helpers, look into the existing branches for possible matches. 
Currently we have these extra branches:

**feature/observe_root_vc**: Detecting when rootViewController gets loaded.

**util_gradients**: Helper methods to easily add color gradients.


To use them simply download the branch and locally rebase against master/develop from your initial swift-base clone.

## Danger integration

Most of the configuration has been already done inside the swift-base files. The only thing you need to do is add the DANGER_GITHUB_API_TOKEN as an environment variable inside the Travis settings for your new repo after configuring Travis. To get this key talk with [@glm4](https://github.com/glm4) or [@pMalvasio](https://github.com/pmalvasio)
