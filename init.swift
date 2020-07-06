import Foundation

let baseProjectName = "ios-base"
var projectName = "RSDemoProject"
let baseDomain = "com.rootstrap"
var bundleDomain = baseDomain
let baseCompany = "Rootstrap Inc."
var companyName = baseCompany

let whiteList: [String] = [".DS_Store", "UserInterfaceState.xcuserstate", "init.swift"]
let fileManager = FileManager.default
var currentFolder: String {
  return fileManager.currentDirectoryPath
}

enum SetupStep: Int {
  case nameEntry = 1
  case bundleDomainEntry
  case companyNameEntry
  
  var question: String {
    switch self {
    case .nameEntry: return "Enter a name for the project"
    case .bundleDomainEntry: return "Enter the reversed domain of your organization"
    case .companyNameEntry: return "Enter the Company name to use on file's headers"
    }
  }
}

// Helper methods

func prompt(message: String) -> String? {
  print("\n" + message)
  let answer = readLine()
  return answer == nil || answer == "" ? nil : answer!
}

func setup(step: SetupStep, defaultValue: String) -> String {
  let result = prompt(message: "\(step.rawValue). " + step.question + " (leave blank for \(defaultValue)).")
  guard let res = result else {
    print(defaultValue)
    return defaultValue
  }
  return res
}

func shell(_ args: String...) -> (output: String, exitCode: Int32) {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.currentDirectoryPath = currentFolder
  let pipe = Pipe()
  task.standardOutput = pipe
  task.launch()
  task.waitUntilExit()
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: .utf8) ?? ""
  return (output, task.terminationStatus)
}

extension URL {
  var fileName: String {
    let urlValues = try? resourceValues(forKeys: [.nameKey])
    return urlValues?.name ?? ""
  }
  
  var isDirectory: Bool {
    let urlValues = try? resourceValues(forKeys: [.isDirectoryKey])
    return urlValues?.isDirectory ?? false
  }
  
  func rename(from oldName: String, to newName: String) {
    if fileName.contains(oldName) {
      let newName = fileName.replacingOccurrences(of: oldName, with: newName)
      try! fileManager.moveItem(at: self, to: URL(fileURLWithPath: newName, relativeTo: deletingLastPathComponent()))
    }
  }
  
  func replaceOccurrences(of value: String, with newValue: String) {
    guard let fileContent = try? String(contentsOfFile: path, encoding: .utf8) else {
      print("Unable to read file at: \(self)")
      return
    }
    let updatedContent = fileContent.replacingOccurrences(of: value, with: newValue)
    try! updatedContent.write(to: self, atomically: true, encoding: .utf8)
  }
  
  func setupForNewProject() {
    replaceOccurrences(of: baseProjectName, with: projectName)
    replaceOccurrences(of: baseDomain, with: bundleDomain)
    rename(from: baseProjectName, to: projectName)
  }
}

// Helper functions

func changeOrganizationName() {
  let pbxProjectPath = "\(currentFolder)/\(baseProjectName).xcodeproj/project.pbxproj"
  guard
    fileManager.fileExists(atPath: pbxProjectPath),
    companyName != baseCompany
  else { return }

  print("\nUpdating company name to '\(companyName)'...")
  
  let filterKey = "ORGANIZATIONNAME"
  let organizationNameFilter = "\(filterKey) = \"\(baseCompany)\""
  let organizationNameReplacement = "\(filterKey) = \"\(companyName)\""
  let fileUrl = URL(fileURLWithPath: pbxProjectPath)
  fileUrl.replaceOccurrences(
    of: organizationNameFilter,
    with: organizationNameReplacement
  )
}

// Project Initialization

print("""
+-----------------------------------------+
|                                         |
|       < New iOS Project Setup >         |
|                                         |
+-----------------------------------------+
""")

projectName = setup(step: .nameEntry, defaultValue: projectName)
bundleDomain = setup(step: .bundleDomainEntry, defaultValue: baseDomain)
companyName = setup(step: .companyNameEntry, defaultValue: baseCompany)

//Remove current git tracking
_ = shell("rm", "-rf", ".git")

changeOrganizationName()

print("\nRenaming to '\(projectName)'...")
let enumerator = fileManager.enumerator(at: URL(fileURLWithPath: currentFolder), includingPropertiesForKeys: [.nameKey, .isDirectoryKey])!
var directories: [URL] = []
while let itemURL = enumerator.nextObject() as? URL {
  guard !whiteList.contains(itemURL.fileName) else { continue }
  if itemURL.isDirectory {
    directories.append(itemURL)
  } else {
    itemURL.setupForNewProject()
  }
}

for dir in directories.reversed() {
  dir.rename(from: baseProjectName, to: projectName)
}
//TODO: Rename current dir
let currentURL = URL(fileURLWithPath: currentFolder)
currentURL.rename(from: baseProjectName, to: projectName)

print("Installing pods...")
_ = shell("pod", "install")
print("Opening new project...")
_ = shell("open", "\(projectName).xcworkspace")
// Initialization Done!
print("************** ALL SET! *******************")
