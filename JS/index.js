import * as sentiment from 'sentiment'

export class Analyzer {
    static analyze(phrase) {
        let result = sentiment(phrase)
        return result['score']
    }
};