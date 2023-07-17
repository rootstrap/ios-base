//
//  UserServiceUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest
@testable import ios_base_Debug

class UserServiceUnitTests: XCTestCase {
  
  let userResponse = User(id: 1, username: "username", email: "test@mail.com")
  
  var testUser: User!
  var sessionManager: SessionManager!
  var userDataManager: UserDataManager!
  
  override func setUp() {
    super.setUp()
    testUser = User(id: 0, username: "", email: "")
    sessionManager = SessionManager()
    userDataManager = UserDataManager()
  }

  override func tearDown() {
    sessionManager.deleteSession()
    userDataManager.deleteUser()
  }
  
  @MainActor func testUserPersistence() {
    let service = AuthenticationServices(
      sessionManager: sessionManager,
      userDataManager: userDataManager
    )
    _ = service.saveUserSession(userResponse, headers: [:])
    guard let persistedUser = userDataManager.currentUser else {
      XCTFail("User should NOT be nil")
      return
    }
    XCTAssert(persistedUser.id == testUser.id)
    XCTAssert(persistedUser.username == testUser.username)
    XCTAssert(persistedUser.email == testUser.email)
  }
}
