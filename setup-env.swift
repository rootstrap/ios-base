import Foundation

// MARK: ConfiguratorError

/// The possible errors that `ProjectConfigurator` can throw.
public enum ConfiguratorError: LocalizedError {
  /// The arguments provided to the configurator do not match the requirements
  case invalidArguments

  /// The source file providing the secret keys can not be found.
  case keysFileNotFound

  /// Could not read valid keys from the source file provided.
  case emptyData

  /// One of the keys in the source file was not found in the environment.
  case keyMissing(String)

  public var errorDescription: String? {
    switch self {
    case .invalidArguments:
      return "The arguments provided to the configurator do not match the requirements"
    case .keysFileNotFound:
      return "The source file providing the secret keys can not be found."
    case .emptyData:
      return "Could not read valid keys from the source file provided."
    case .keyMissing(let key):
      return "The key \"\(key)\" is missing."
    }
  }
}

// MARK: EnvironmentConfigurator

/// This class configures environment variables for the project.
/// It takes a source file with the keys definition and inject the values
/// to the provided output file.
public final class EnvironmentConfigurator {

  enum Defaults {
    static let secretsFile = "secrets.xcconfig"
    static let keysFile = "keys.env"
  }

  private let keysSource: String

  private let fileManager = FileManager.default

  public init(keysSource: String? = nil) {
    self.keysSource = (keysSource ?? Defaults.keysFile).expandingTildeInPath
  }

  public func injectEnvironment(into file: String? = nil) throws {
    let keys = try readKeys()

    let fullPath = (file ?? Defaults.secretsFile).expandingTildeInPath
    if !fileManager.fileExists(atPath: fullPath) {
      fileManager.createFile(atPath: fullPath, contents: nil)
    }

    var rows: [String] = []
    for key in keys {
      do {
        let value = try require(key: key)
        rows.append("\(key) = \(value)")
      } catch {
        // Attempt to write the key-value pairs found before failure.
        try rows.joined(separator: "\n")
          .write(toFile: fullPath, atomically: true, encoding: .utf8)
        throw error
      }
    }
    try rows.joined(separator: "\n")
      .write(toFile: fullPath, atomically: true, encoding: .utf8)
  }

  private func readKeys() throws -> [String] {
    guard fileManager.fileExists(atPath: keysSource) else {
      throw ConfiguratorError.keysFileNotFound
    }

    guard
      let data = fileManager.contents(atPath: keysSource),
      let content = String(data: data, encoding: .utf8)
    else {
      throw ConfiguratorError.emptyData
    }

    return content.split(separator: "\n")
      .map { String($0) }
      .filter { !$0.starts(with: "#") && !$0.isEmpty }
  }

  private func require(key: String) throws -> String {
    let environment = ProcessInfo.processInfo.environment
    guard let value = environment[key], !value.isEmpty else {
      throw ConfiguratorError.keyMissing(key)
    }

    return value
  }

}

// MARK: Script

private let arguments = CommandLine.arguments
private let executableName: String = arguments.first ?? "setup-env"

private func outputError(_ error: Error) {
  fputs("Configurator failed: \(error.localizedDescription)\n", stderr)
}

private func showHelp() {
  print("Usage:")
  print("\(executableName) <keys_source> <output_xcconfig>")
}

guard arguments.count >= 1 else {
  showHelp()
  outputError(ConfiguratorError.invalidArguments)
  exit(EXIT_FAILURE)
}

private let keysSource = arguments[safe: 1]
private let outputXCConfigFile = arguments[safe: 2]

private let configurator = EnvironmentConfigurator(keysSource: keysSource)

do {
  try configurator.injectEnvironment(into: outputXCConfigFile)
  print("Environment configured successfuly!")
  exit(EXIT_SUCCESS)
} catch {
  outputError(error)
  exit(EXIT_FAILURE)
}

// MARK: Extensions

internal extension String {
  var expandingTildeInPath: String {
    NSString(string: self).expandingTildeInPath
  }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    guard index >= 0 && index < count else {
      return nil
    }
    return self[index]
  }
}
