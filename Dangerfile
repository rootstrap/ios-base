# Ensure there is a summary for a pull request
fail("Please provide a summary in the Pull Request description") if github.pr_body.length < 2
 
# Warn when there is a big PR
warn("Be careful, maybe this PR it's too big") if git.lines_of_code > 700
 
# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
fail("PR is classed as Work in Progress. Do NOT merge") if github.pr_labels.map(&:downcase).include? "on hold"
 
# Warn when there are merge commits in the diff
warn("Please rebase to get rid of the merge commits in this Pull Request") if git.commits.any? { |c| c.message =~ /^Merge branch 'master'/ }
  
# Run SwiftLint
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files
print "swiftlint executed"
