//
//  UserDataManagerTests.swift
//  ios-baseUnitTests
//
//  Created by German on 1/9/22.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import ios_base_Debug

internal final class UserDataManagerTests: XCTestCase {

  func testUserPersistedCorrectly() {
    let testUser: User = .mock
    UserDataManager.currentUser = testUser

    let persistedUser = UserDataManager.currentUser
    XCTAssertEqual(persistedUser?.id, testUser.id)
    XCTAssertEqual(persistedUser?.username, testUser.username)
    XCTAssertEqual(persistedUser?.email, testUser.email)
    XCTAssertTrue(UserDataManager.isUserLogged)
  }

  func testCurrentUserDeletion() {
    UserDataManager.currentUser = .mock

    XCTAssertNotNil(UserDataManager.currentUser)
    XCTAssertTrue(UserDataManager.isUserLogged)

    UserDataManager.deleteUser()
    XCTAssertNil(UserDataManager.currentUser)
    XCTAssertFalse(UserDataManager.isUserLogged)
  }
}
