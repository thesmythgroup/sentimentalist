//
//  ViewController.swift
//  Sentimentalist
//
//  Created by Johannes Fahrenkrug on 11/14/17.
//  Copyright © 2017 The Smyth Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sentimentLabel.text = SentimentAnalyzer.shared.emoji(forScore: 0)
    }
    
    @IBAction func textDidChange(_ sender: Any) {
        if let text = textField.text {
            SentimentAnalyzer.shared.analyze(text) { (score) in
                self.sentimentLabel.text = SentimentAnalyzer.shared.emoji(forScore: score)
            }
        }
    }
}

