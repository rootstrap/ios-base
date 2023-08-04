//
//  UserServiceUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest
import RSSwiftNetworking
import RSSwiftNetworkingAlamofire
@testable import ios_base_Debug

class UserServiceUnitTests: XCTestCase {
  
  let testUser = User(id: 1, username: "username", email: "test@mail.com")
  
  var sessionManager: SessionManager!
  var userDataManager: UserDataManager!
  
  override func setUp() {
    super.setUp()
    sessionManager = SessionManager()
    userDataManager = UserDataManager()
  }

  override func tearDown() {
    super.tearDown()
    sessionManager.deleteSession()
    userDataManager.deleteUser()
    SessionManager.shared.deleteSession()
    UserDataManager.shared.deleteUser()
  }

  func testUserPersistence() {
    let service = AuthenticationServices(
      sessionManager: sessionManager,
      userDataManager: userDataManager
    )
    _ = service.saveUserSession(testUser, headers: [:])
    guard let persistedUser = userDataManager.currentUser else {
      XCTFail("User should NOT be nil")
      return
    }
    let user = User(id: 1, username: "username", email: "test@mail.com")
    XCTAssert(persistedUser.id == user.id)
    XCTAssert(persistedUser.username == user.username)
    XCTAssert(persistedUser.email == user.email)
  }
  
  func testGoodSessionPersistence() {
    let client = "dummySessionClient"
    let token = "dummySessionToken"
    let uid = testUser.email
    let expiry = "\(Date.timeIntervalSinceReferenceDate)"
    let sessionHeaders: [String: Any] = [
      HTTPHeader.uid.rawValue: uid,
      HTTPHeader.client.rawValue: client,
      HTTPHeader.token.rawValue: token,
      HTTPHeader.expiry.rawValue: expiry
    ]
    
    let service = AuthenticationServices(
      sessionManager: sessionManager,
      userDataManager: userDataManager
    )
    _ = service.saveUserSession(testUser, headers: sessionHeaders)
    
    guard let persistedSession = sessionManager.currentSession else {
      XCTFail("Session should NOT be nil")
      return
    }
    
    XCTAssert(persistedSession.client == client)
    XCTAssert(persistedSession.accessToken == token)
    XCTAssert(persistedSession.uid == uid)
    XCTAssert(persistedSession.accessToken == token)
  }
  
  func testBadSessionPersistence() {
    // Testing case where shouldn't be session at all
    let unusableHeaders = [HTTPHeader.client: "badHeaderKey"]
    let service = AuthenticationServices(
      sessionManager: sessionManager,
      userDataManager: userDataManager
    )
    _ = service.saveUserSession(testUser, headers: unusableHeaders)
    XCTAssert(sessionManager.currentSession == nil)
    XCTAssert(sessionManager.currentSession?.isValid == nil)
    
    // Testing case where should be session but not valid
    let wrongSessionHeaders = [
      "testKey": "testValue",
      HTTPHeader.uid.rawValue: "",
      HTTPHeader.client.rawValue: "",
      HTTPHeader.token.rawValue: ""
    ]
    _ = service.saveUserSession(testUser, headers: wrongSessionHeaders)
    XCTAssert(sessionManager.currentSession != nil)
    XCTAssertFalse(sessionManager.currentSession?.isValid ?? true)
  }
}
