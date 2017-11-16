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
        let jsCode = try? String.init(contentsOf: Bundle.main.url(forResource: "Sentimentalist.bundle", withExtension: "js")!)
        
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
            let jsModule = self.context.objectForKeyedSubscript("Sentimentalist")
            let jsAnalyzer = jsModule?.objectForKeyedSubscript("Analyzer")
            
            // In the JSContext global values can be accessed through `objectForKeyedSubscript`.
            // In Objective-C you can actually write `context[@"analyze"]` but unfortunately that's
            // not possible in Swift yet.
            if let result = jsAnalyzer?.objectForKeyedSubscript("analyze").call(withArguments: [sentence]) {
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

