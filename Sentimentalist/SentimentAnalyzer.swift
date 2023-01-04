//
//  SentimentAnalyzer.swift
//  Sentimentalist
//
//  Created by Johannes Fahrenkrug on 1/2/23.
//  Copyright © 2017-2023 The Smyth Group. All rights reserved.

import Foundation
import JavaScriptCore

/// An analyzer of sentiments
class SentimentAnalyzer {
    /// Singleton instance. Much more resource-friendly than creating multiple new instances.
    static let shared = SentimentAnalyzer()
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    private init() {
        let jsCode = """
         // From https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
         function randomNumber(min, max) {
             min = Math.ceil(min);
             max = Math.floor(max);
             //The maximum is inclusive and the minimum is inclusive
             return Math.floor(Math.random() * (max - min + 1)) + min;
         }
         
         function analyze(sentence) {
             return randomNumber(-5, 5);
         }
         """
        
        // Create a new JavaScript context that will contain the state of our evaluated JS code.
        context = JSContext(virtualMachine: vm)
        
        // Evaluate the JS code that defines the functions to be used later on.
        context.evaluateScript(jsCode)
    }
        
    /// Analyze the sentiment of a given English sentence.
    /// - Parameters:
    ///     - sentence: The sentence to analyze
    /// - Returns : The sentiment score
    func analyze(_ sentence: String) async -> Int {
        if let result = context.globalObject.invokeMethod("analyze", withArguments: [sentence]) {
            return Int(result.toInt32())
        }
        
        return 0
    }
        
    /// Return an emoji for the given sentiment score.
    /// - Parameters:
    ///     - score: The sentiment score
    /// - Returns: String with a single emoji character
    func emoji(forScore score: Int) -> String {
        switch score {
        case 5...Int.max:
            return "😍"
        case 4:
            return "😃"
        case 3:
            return "😊"
        case 2, 1:
            return "🙂"
        case -1, -2:
            return "🙁"
        case -3:
            return "☹️"
        case -4:
            return "😤"
        case Int.min...(-5):
            return "😡"
        default:
            return "😐"
        }
    }
}
