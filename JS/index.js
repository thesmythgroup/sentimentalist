const Sentiment = require('sentiment')

export class Analyzer {
    static analyze(phrase) {
        // Make sure nativeLog is defined and is a function
        if (typeof nativeLog === 'function') {
            nativeLog(`Analyzing '${phrase}'`)
        }

        let sentiment = new Sentiment()
        let result = sentiment.analyze(phrase)
        return result['score']
    }
};