//
//  TopupImpUITests.swift
//  MiniSuperAppUITests
//
//  Created by woongs on 2021/12/06.
//

import XCTest
import Swifter

final class TopupImpUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var server: HttpServer!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        server = HttpServer()
        self.app = XCUIApplication()
    }

    func testTopupSuccess() throws {
        // given
        let cardOnFileJSONPath = try TestUtil.path(for: "cardOnFile.json", in: type(of: self))
        server["/cards"] = shareFile(cardOnFileJSONPath)
        
        let topupResponse = try TestUtil.path(for: "topupSuccessResponse.json", in: type(of: self))
        server["/topup"] = shareFile(topupResponse)
        
        // when
        try server.start()
        self.app.launch()
        
        // then
        self.app.tabBars.buttons["superpay_home_tab_bar_item"].tap()
        self.app.buttons["superpay_dashboard_topup_button"].tap()
        
        let textField = app.textFields["topup_enteramount_textfield"]
        textField.tap()
        textField.typeText("10000")
        
        app.buttons["topup_enteramount_confirm_button"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "superpay_dashboard_balance_label").label, "10,000")
    }

}
