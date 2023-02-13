//
//  UserServiceUnitTests.swift
//  ios-baseUnitTests
//
//  Created by German on 4/30/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import XCTest
import RSSwiftNetworking
@testable import ios_base_Debug

class UserServiceUnitTests: XCTestCase {

  private var userService: UserServices!
  private var networkMocker: NetworkMocker!
  
  override func setUpWithError() throws {
    try super.setUpWithError()

    networkMocker = NetworkMocker()
    try networkMocker.setUp()
    userService = UserServices()
    UserDataManager.deleteUser()
  }

  override func tearDown() {
    super.tearDown()
    networkMocker.tearDown()
  }

  func testServiceSavesUser() {
    let expectation = expectation(description: "User object should be persisted")
    testUserStorageAfterProfileFetch(success: true) { result in
      switch result {
      case .success(let user):
        expectation.fulfill()
        XCTAssertNotNil(UserDataManager.currentUser)
        XCTAssertEqual(UserDataManager.currentUser?.id, user.id)
        XCTAssertEqual(UserDataManager.currentUser?.email, user.email)
      case .failure(let error):
        XCTFail("Test expected to succeed. \(error)")
      }
    }

    wait(for: [expectation], timeout: 5.0)
  }

  func testServicesReturnsError() {
    let expectation = expectation(description: "Request should fail")
    testUserStorageAfterProfileFetch(success: false) { result in
      switch result {
      case .success:
        XCTFail("GET Profile Request expected to fail")
      case .failure(let error):
        expectation.fulfill()
        XCTAssertNil(UserDataManager.currentUser)
        XCTAssertNotNil(error)
      }

    }
    wait(for: [expectation], timeout: 5.0)
  }

  private func testUserStorageAfterProfileFetch(
    success: Bool,
    completion: @escaping (Result<User, Error>) -> Void
  ) {
    networkMocker.stub(with: .profile(success: success), method: .GET)
    userService.getMyProfile(completion: completion)
  }
}
