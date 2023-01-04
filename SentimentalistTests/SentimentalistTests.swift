//
//  SentimentalistTests.swift
//  SentimentalistTests
//
//  Created by Johannes Fahrenkrug on 1/2/23.
//  Copyright © 2017-2023 The Smyth Group. All rights reserved.

import XCTest
@testable import Sentimentalist

final class SentimentalistTests: XCTestCase {

    func testAnalyze() async {        
        var score = await SentimentAnalyzer.shared.analyze("I love cats")
        XCTAssertEqual(score, 3)
        
        score = await SentimentAnalyzer.shared.analyze("I dislike zuchinis")
        XCTAssertEqual(score, -2)
    }
    
    func testEmojiForScore() {
        XCTAssertEqual(SentimentAnalyzer.shared.emoji(forScore: 4), "😃")
        XCTAssertEqual(SentimentAnalyzer.shared.emoji(forScore: -2), "🙁")
    }

    func testPerformance() {
        self.measure {
            let exp = expectation(description: "Finished")
            Task {
              _ = await SentimentAnalyzer.shared.analyze("I love cats")
              exp.fulfill()
            }
            wait(for: [exp], timeout: 10.0)
        }
    }

}
