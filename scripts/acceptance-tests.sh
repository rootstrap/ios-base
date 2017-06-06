#!/bin/sh

set -o pipefail && xcodebuild \
-workspace swift-base.xcworkspace \
-scheme swift-base \
-destination 'platform=iOS Simulator,name=iPhone 6,OS=10.2' \
build test | xcpretty --test --color
