
const Sentiment = require('sentiment')

export class Analyzer {
    static analyze(phrase) {
        let sentiment = new Sentiment()
        let result = sentiment.analyze(phrase)
        return result['score']
    }
}
