//
//  SentimentAnalyzer.swift
//  Sentimentalist
//
//  Created by Johannes Fahrenkrug on 11/14/17.
//  Copyright © 2017 The Smyth Group. All rights reserved.
//

import UIKit
import JavaScriptCore

/// An analyzer of sentiments
class SentimentAnalyzer: NSObject {
    /// Singleton instance. Much more resource-friendly than creating multiple new instances.
    static let shared = SentimentAnalyzer()
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    private override init() {
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
        self.context = JSContext(virtualMachine: self.vm)
        
        // Evaluate the JS code that defines the functions to be used later on.
        self.context.evaluateScript(jsCode)
    }
    
    /**
         Analyze the sentiment of a given English sentence.
 
         - Parameters:
             - sentence: The sentence to analyze
             - completion: The block to be called on the main thread upon completion
             - score: The sentiment score
     */
    func analyze(_ sentence: String, completion: @escaping (_ score: Int) -> Void) {
        // Run this asynchronously in the background
        DispatchQueue.global(qos: .userInitiated).async {
            var score = 0
            
            // In the JSContext global values can be accessed through `objectForKeyedSubscript`.
            // In Objective-C you can actually write `context[@"analyze"]` but unfortunately that's
            // not possible in Swift yet.
            if let result = self.context.objectForKeyedSubscript("analyze").call(withArguments: [sentence]) {
                score = Int(result.toInt32())
            }
            
            // Call the completion block on the main thread
            DispatchQueue.main.async {
                completion(score)
            }
        }
    }
    
    /**
         Return an emoji for the given sentiment score.
 
         - Parameters:
             - score: The sentiment score
 
         - Returns: String with a single emoji character
     */
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

