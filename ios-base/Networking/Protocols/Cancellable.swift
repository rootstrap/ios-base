/// Defines a cancellable work.
internal protocol Cancellable {
  func cancel() -> Self
}
