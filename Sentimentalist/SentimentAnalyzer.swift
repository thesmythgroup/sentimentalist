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
        let jsCode = try? String.init(contentsOf: Bundle.main.url(forResource: "Sentimentalist.bundle", withExtension: "js")!)
        
        // The Swift closure needs @convention(block) because JSContext's setObject:forKeyedSubscript: method
        // expects an Objective-C compatible block in this instance.
        // For more information check out https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Attributes.html#//apple_ref/doc/uid/TP40014097-CH35-ID350
        let nativeLog: @convention(block) (String) -> Void = { message in
            print("JS Log: \(message)")
        }
        
        // Create a new JavaScript context that will contain the state of our evaluated JS code.
        self.context = JSContext(virtualMachine: self.vm)
        
        // Register our native logging function in the JS context
        self.context.setObject(nativeLog, forKeyedSubscript: "nativeLog" as NSString)
        
        // Evaluate the JS code that defines the functions to be used later on.
        self.context.evaluateScript(jsCode)
    }
        
    /// Analyze the sentiment of a given English sentence.
    /// - Parameters:
    ///     - sentence: The sentence to analyze
    /// - Returns : The sentiment score
    func analyze(_ sentence: String) async -> Int {
        let jsModule = self.context.objectForKeyedSubscript("Sentimentalist")
        let jsAnalyzer = jsModule?.objectForKeyedSubscript("Analyzer")
        if let result = jsAnalyzer?.invokeMethod("analyze", withArguments: [sentence]) {
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
