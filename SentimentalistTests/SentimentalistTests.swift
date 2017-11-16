//
//  SentimentalistTests.swift
//  SentimentalistTests
//
//  Created by Johannes Fahrenkrug on 11/14/17.
//  Copyright © 2017 The Smyth Group. All rights reserved.
//

import XCTest
@testable import Sentimentalist

class SentimentalistTests: XCTestCase {
    
    func testAnalyze() {
        let positiveExpectation = expectation(description: "Call positive completion block")
        let negativeExpectation = expectation(description: "Call negative completion block")
        
        SentimentAnalyzer.shared.analyze("I love cats", completion: { (score) in
            positiveExpectation.fulfill()
            XCTAssertEqual(score, 3)
        })
        
        SentimentAnalyzer.shared.analyze("I dislike zuchinis", completion: { (score) in
            negativeExpectation.fulfill()
            XCTAssertEqual(score, -2)
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testEmojiForScore() {
        XCTAssertEqual(SentimentAnalyzer.shared.emoji(forScore: 4), "😃")
        XCTAssertEqual(SentimentAnalyzer.shared.emoji(forScore: -2), "🙁")
    }

    func testPerformance() {
        self.measure {
            let callbackExpectation = expectation(description: "Call completion block")
            SentimentAnalyzer.shared.analyze("I love cats", completion: { (score) in
                callbackExpectation.fulfill()
            })
            waitForExpectations(timeout: 10, handler: nil)
        }
    }
    
}
