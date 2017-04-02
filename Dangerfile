# Ensure there is a summary for a pull request
fail 'Please provide a summary in the Pull Request description' if github.pr_body.length < 5

# Run SwiftLint
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files
print "swiftlint executed"
