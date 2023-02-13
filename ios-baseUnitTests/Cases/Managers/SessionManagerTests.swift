//
//  SessionManagerTests.swift
//  ios-baseUnitTests
//
//  Created by German on 2/9/22.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import ios_base_Debug

internal final class SessionManagerTests: XCTestCase {

  private let testSession = Session(
    uid: "uuid",
    client: "client",
    token: "token",
    expires: Date()
  )

  private var userDefaults: UserDefaults!

  override func setUp() {
    super.setUp()

    // swiftlint:disable:next force_unwrapping
    userDefaults = UserDefaults(suiteName: "Test Suite")!
  }

  func testSessionStoredCorrectly() {
    let sessionManager = SessionManager(userDefaults: userDefaults)
    sessionManager.currentSession = testSession

    XCTAssertEqual(testSession.client, sessionManager.currentSession?.client)
    XCTAssertEqual(testSession.uid, sessionManager.currentSession?.uid)
    XCTAssertEqual(testSession.expiry, sessionManager.currentSession?.expiry)
    XCTAssertEqual(testSession.accessToken, sessionManager.currentSession?.accessToken)
  }

  func testCurrentUserDeletion() {
    let sessionManager = SessionManager(userDefaults: userDefaults)
    sessionManager.currentSession = testSession

    XCTAssertNotNil(sessionManager.currentSession)

    sessionManager.deleteSession()
    XCTAssertNil(sessionManager.currentSession)
  }

  func testSessionValidation() {
    let sessionManager = SessionManager(userDefaults: userDefaults)
    sessionManager.currentSession = testSession
    XCTAssertTrue(sessionManager.validSession)

    let invalidSessions: [Session] = [
      .init(uid: "", client: "client", token: "token", expires: Date()),
      .init(uid: "uid", client: "", token: "token", expires: nil),
      .init(uid: "uid", client: "client", token: "", expires: Date.distantFuture),
      .init(uid: nil, client: nil, token: "accessToken", expires: Date.distantFuture)
    ]
    for session in invalidSessions {
      sessionManager.currentSession = session
      XCTAssertFalse(sessionManager.validSession)
    }
  }
}
