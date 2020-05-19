### CI/CD with Jenkins

The Jenkinsfile in this folder can be used to automatically trigger Fastlane and archive the application builds from a [Jenkins](https://jenkins.io) server.
- These needs to be updated before use with the proper values for the project in the `environment` section:
  ```
    environment {
        APP_NAME = 'ios-base'
        SLACK_CHANNEL = '#ios-base'
        S3_BUCKET = 'ios-base-files'
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCESS_KEY = credentials('aws-s3-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-s3-secret-access-key')
    }
  ```
- `Jenkinsfile` is a Multibranch Pipeline job, set to trigger upon commits to the project repo
  - Runs the following steps:
    - Install gem dependencies
    - Runs `test` lane
    - *if standing on `qa` or `develop` branch*: Run `build_develop` lane and store the IPA file on the specified location in AWS S3
    - *if standing on `staging` branch*: Run `release_staging` to push a Beta build to TestFlight
    - *if standing on `master` branch*: Run `release_production` to push a Prod build to TestFlight

#### Jenkins server requirements:
  - Jenkins 2.164+
  - [MultiBranch Pipeline plugin](https://plugins.jenkins.io/workflow-multibranch/)
  - [Pipeline: Multibranch build strategy extension](https://plugins.jenkins.io/multibranch-build-strategy-extension/)   --> this is needed for preventing the job to trigger itself upon version bump commits
  - [Slack Notification plugin](https://plugins.jenkins.io/slack/) ---> set the right channel name for `SLACK_CHANNEL` variable in both Jenkinsfiles.
  - Valid credentials for AWS with privileges to upload files to the specified bucket -stored in Credentials store with id `aws-s3-access-key`

#### Jenkins agent requirements
  - MacOS 10.12: Sierra or later
  - Ruby 2.6+
  - Bundler 1.x
  - CocoaPods 1.9+
  - Xcode CLI 
  - Fastlane
