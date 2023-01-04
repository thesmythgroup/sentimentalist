//
//  ContentView.swift
//  Sentimentalist
//
//  Created by Johannes Fahrenkrug on 1/2/23.
//  Copyright © 2017-2023 The Smyth Group. All rights reserved.

import SwiftUI
import Combine

@MainActor
class ViewModel: ObservableObject {
    /// The sentence to be analyzed
    @Published var sentence = "" {
        didSet {
            if (sentence != oldValue) {
                Task {
                    let score = await SentimentAnalyzer.shared.analyze(sentence)
                    emoji = SentimentAnalyzer.shared.emoji(forScore: score)
                }
            }
        }
    }
    
    /// The emoji representing the sentiment of the current sentence
    @Published var emoji = SentimentAnalyzer.shared.emoji(forScore: 0)
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            TextField("Sentence", text: $viewModel.sentence).font(.system(size: 34))
            Spacer()
            Text(viewModel.emoji).font(.system(size: 134))
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
