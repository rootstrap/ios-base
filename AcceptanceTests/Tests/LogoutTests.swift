//
//  LogoutTests.swift
//  ios-base
//
//  Created by Rootstrap on 5/16/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import KIF
import OHHTTPStubs
@testable import ios_base_Debug

class LogoutTests: KIFTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    
    //Simulates the login
    SessionManager.currentSession = Session(
      uid: "rootstrap@gmail.com", client: "client",
      token: "token", expires: Date(timeIntervalSinceNow: 3.15576E+07)
    )
    AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot, animated: false)
  }
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
  }
  
  override func afterAll() {
    super.afterAll()
    
    AppNavigator.shared.navigate(
      to: OnboardingRoutes.firstScreen, with: .changeRoot, animated: false
    )
  }
  
  // MARK: - Tests
  
  func testLogoutSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_out")) { _ in
      let stubPath = OHPathForFile("LogoutSuccess.json", type(of: self))
      return fixture(
        filePath: stubPath!, status: 200,
        headers: ["Content-Type": "application/json"]
      ).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "LogoutButton")
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    XCTAssertEqual(SessionManager.validSession, false)
  }
}
