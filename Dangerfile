# Ensure there is a summary for a pull request
fail 'Please provide a summary in the Pull Request description' if github.pr_body.length < 5
fail 'Please provide a summary in the Pull Request description' if github.pr_body.length < 2
 
# Warn when there is a big PR
warn("Be careful, maybe this PR it's too big") if git.lines_of_code > 500
 
# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress. Wait for MERGE") if github.pr_labels.include? "On hold"
 
# Warn when there are merge commits in the diff
warn 'Please rebase to get rid of the merge commits in this Pull Request' if git.commits.any? { |c| c.message =~ /^Merge branch 'master'/ }
  
# Run SwiftLint
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files
print "swiftlint executed"
