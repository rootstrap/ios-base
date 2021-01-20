## Build Automation with Fastlane

### New Project Setup

Several steps need to be executed before building a project for the first time.

  1. Install latest Xcode command line tools
  ```
  xcode-select --install
  ```

  2. Install latest Fastlane 
  ```
  # Using RubyGems
  sudo gem install fastlane -NV
  # Alternatively using Homebrew
  brew install fastlane
  ```

  3. Create required App Ids in the Apple Developer Portal and App Store Connect 
  This can be done on the Portal itself or using [fastlane produce](https://docs.fastlane.tools/actions/produce/)
  ```
  fastlane produce -u {apple_id} --app-name {app_name} --team-id {team_id} --app-identifier {app_id} 
  ```
  4. Create private empty repository to store signing certificates, eg. `git@github.com:rootstrap/{app_name}-certificates.git`

  5. Generate Matchfile with [fastlane match](https://docs.fastlane.tools/actions/match/)
  ```
  fastlane match init 
  ```
  select `git` as storage mode and specify the URL of the certificates git repo

  6. **optional** If the Developer account has old/invalid certificates which are not shared, it is recommended to use the `nuke` action to clear the existing certificates (*use with caution*):
  ```
  fastlane match nuke development
  fastlane match nuke distribution
  ```

  7. **optional** If wanting to reuse existing distribution certificates, these can be imported into the certificates repository using match with the `import` action:
  ```
  fastlane match import \
    --username {{username}} \
    --git_url {{certificates_git_url}} \
    --team_id {{team_id}} \
    --type appstore  \
    --app_identifier com.{{company}}.{{app_name}} \
  ```
    * Fastlane will prompt for location of the `.cer` and `.p12` files
    * Fastlane will require setting a passphrase for encrypting the files in git


  8. Generate app bundle identifiers 
  ```
  fastlane match appstore -u {{username}} --team-id {{team_id}} -a com.{{company}}.{{app_name}} 
  ```

  9. Check the `fastlane/Appfile` and `fastlane/Fastfile`; set and/or validate the required values and environment variables before use:

 
### Fastlane usage

```
fastlane ios {{lane}}
```

Lanes for each deployment target are provided with some basic behavior, which can be modified as needed:

- Each target has three options: `debug_*`, `archive_*` and `release_*`.
  - The `debug` lane will install pod dependencies and run tests 
  - The `archive` lane will additionally build the application with the specified profile and certificate, keeping the `.ipa` in the local folder for upload.
  - The `release` lane will:
    - Check the repo status (it has to be clean, with no pending changes)
    - Increment the build number.
    - Tag the new release and push it to the set branch (dev and staging push to develop and production to master by default, but it's configurable).
    - Build the app signed with an **App Store** certificate
    - Generate a changelog from the commit diff between this new version and the previous.
    - Upload to testflight and wait until it's processed.

- Additionally, lane `test_develop` can be used by the CI job to only run the unit test against simulators (specified by `devices` variable in Fastfile)
