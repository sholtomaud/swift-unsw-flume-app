//
//  FlumeAppUITests.swift
//  FlumeAppUITests
//
//  Created by Sholto Maud on 28/6/2025.
//

import XCTest

final class FlumeAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor

    func testExperimentCreationFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to Experiments tab
        app.tabBars.buttons["Experiments"].tap()

        // Tap the "Add Experiment" button
        app.navigationBars["Experiments"].buttons["Add Experiment"].tap()

        // Fill in experiment details within the sheet
        let experimentNameTextField = app.sheets.textFields["Experiment Name"]
        experimentNameTextField.tap()
        experimentNameTextField.typeText("My UI Test Experiment")
        app.keyboards.buttons["Done"].tap() // Dismiss keyboard

        let notesTextField = app.sheets.textFields["Notes"]
        notesTextField.tap()
        notesTextField.typeText("Notes from UI test")
        app.keyboards.buttons["Done"].tap() // Dismiss keyboard

        // Tap Save button
        app.sheets.buttons["Save"].tap()

        // Verify the new experiment appears in the list
        let newExperimentName = "My UI Test Experiment"
        let newExperimentElement = app.staticTexts[newExperimentName]
        XCTAssertTrue(newExperimentElement.waitForExistence(timeout: 5))

        // Tap on the newly created experiment to navigate to its detail view
        newExperimentElement.tap()

        // Verify that the detail view is displayed by checking for a unique element
        XCTAssertTrue(app.staticTexts["Notes from UI test"].exists)
    }

    @MainActor

    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
