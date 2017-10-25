#!/bin/sh

set -o pipefail && xcodebuild \
-workspace ios-base.xcworkspace \
-scheme ios-base \
-destination 'platform=iOS Simulator,name=iPhone 6,OS=10.2' \
build test | xcpretty --test --color
