//
//  SPH_Mobile_AppTests.swift
//  SPH_Mobile_AppTests
//
//  Created by Anjana George on 15/8/20.
//  Copyright © 2020 Anjana George. All rights reserved.
//

import XCTest
import Moya
@testable import SPH_Mobile_App

class SPH_Mobile_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDataUsage() {
        let sut = DataUsage()
        let result = (sut.result == nil)
        XCTAssertTrue(result)
    }
    
    func testDataUsageResult() {
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "json"), let data = try? Data(contentsOf: url)  {
            do {
                let dataUsageInfo = try JSONDecoder().decode(DataUsage.self, from: data)
                let result = (dataUsageInfo.result != nil)
                XCTAssertTrue(result)
            } catch {
            }
        }
    }
    
    func testDataUsageRecord() {
        if let url = Bundle.main.url(forResource: "mockData", withExtension: "json"), let data = try? Data(contentsOf: url)  {
            do {
                let dataUsageInfo = try JSONDecoder().decode(DataUsage.self, from: data)
                let result = (dataUsageInfo.result?.records?.count != 0)
                XCTAssertTrue(result)
            } catch {
            }
        }
    }
    
    func testSavedData() {
        if let data = UserDefaults.standard.value(forKey:"dataUsageRecord") as? Data {
            if (try? PropertyListDecoder().decode(Array<Record>.self, from: data)) != nil {
                XCTAssertTrue(true)
            }else {
                XCTAssertTrue(false)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
