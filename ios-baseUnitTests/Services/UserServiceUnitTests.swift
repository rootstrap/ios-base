//
//  UserServiceUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 TopTier labs. All rights reserved.
//

import XCTest
@testable import ios_base_Debug

class UserServiceUnitTests: XCTestCase {
  
  let testUser = User(
    id: 0,
    username: "test",
    email: "test-user@rootstrap.com",
    image: nil
  )
  let subject = UserService.sharedInstance
  
  override func setUp() {
    super.setUp()
    SessionManager.deleteSession()
    UserDataManager.deleteUser()
  }
  
  func testUserPersistence() {
    subject.saveUserSession(user: testUser, headers: [:])
    guard let persistedUser = UserDataManager.currentUser else {
      XCTFail("User should NOT be nil")
      return
    }
    XCTAssert(UserDataManager.isUserLogged)
    XCTAssert(persistedUser.id == testUser.id)
    XCTAssert(persistedUser.username == testUser.username)
    XCTAssert(persistedUser.email == testUser.email)
  }
  
  func testGoodSessionPersistence() {
    let client = "dummySessionClient"
    let token = "dummySessionToken"
    let uid = testUser.email
    let expiry = "\(Date.timeIntervalSinceReferenceDate)"
    let sessionHeaders = [
      HTTPHeader.uid.rawValue: uid,
      HTTPHeader.client.rawValue: client,
      HTTPHeader.token.rawValue: token,
      HTTPHeader.expiry.rawValue: expiry
    ]
    
    subject.saveUserSession(user: testUser, headers: sessionHeaders)
    guard let persistedSession = SessionManager.currentSession else {
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
    subject.saveUserSession(user: testUser, headers: unusableHeaders)
    XCTAssert(SessionManager.currentSession == nil)
    XCTAssertFalse(SessionManager.validSession)
    
    // Testing case where should be session but not valid
    let wrongSessionHeaders = [
      "testKey": "testValue",
      HTTPHeader.uid.rawValue: "",
      HTTPHeader.client.rawValue: "",
      HTTPHeader.token.rawValue: ""
    ]
    subject.saveUserSession(user: testUser, headers: wrongSessionHeaders)
    XCTAssert(SessionManager.currentSession != nil)
    XCTAssertFalse(SessionManager.validSession)
  }
}
