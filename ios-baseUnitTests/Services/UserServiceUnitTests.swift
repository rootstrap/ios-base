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
  
  let userResponse: [String: Any] = [
    "user": [
      "id": 0,
      "username": "test",
      "email": "test-user@rootstrap.com"
    ]
  ]
  
  var testUser: User!
  
  override func setUp() {
    super.setUp()
    if let userDictionary = userResponse["user"] as? [String: Any] {
      testUser = User(dictionary: userDictionary)
    }
    SessionManager.deleteSession()
    UserDataManager.deleteUser()
  }
  
  func testUserPersistence() {
    AuthenticationServices.saveUserSession(fromResponse: userResponse, headers: [:])
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
    let sessionHeaders: [String: Any] = [
      APIClient.HTTPHeader.uid.rawValue: uid,
      APIClient.HTTPHeader.client.rawValue: client,
      APIClient.HTTPHeader.token.rawValue: token,
      APIClient.HTTPHeader.expiry.rawValue: expiry
    ]
    
    AuthenticationServices.saveUserSession(
      fromResponse: userResponse,
      headers: sessionHeaders
    )
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
    let unusableHeaders = [APIClient.HTTPHeader.client: "badHeaderKey"]
    AuthenticationServices.saveUserSession(
      fromResponse: userResponse,
      headers: unusableHeaders
    )
    XCTAssert(SessionManager.currentSession == nil)
    XCTAssertFalse(SessionManager.validSession)
    
    // Testing case where should be session but not valid
    let wrongSessionHeaders = [
      "testKey": "testValue",
      APIClient.HTTPHeader.uid.rawValue: "",
      APIClient.HTTPHeader.client.rawValue: "",
      APIClient.HTTPHeader.token.rawValue: ""
    ]
    AuthenticationServices.saveUserSession(
      fromResponse: userResponse,
      headers: wrongSessionHeaders
    )
    XCTAssert(SessionManager.currentSession != nil)
    XCTAssertFalse(SessionManager.validSession)
  }
}
