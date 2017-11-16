import * as sentiment from 'sentiment'

export class Analyzer {
    static analyze(phrase) {
        // Make sure nativeLog is defined and is a function
        if (typeof nativeLog === 'function') {
            nativeLog(`Analyzing '${phrase}'`)
        }

        let result = sentiment(phrase)
        return result['score']
    }
};