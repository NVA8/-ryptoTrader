//
//  AnalyticsService.swift
//  СryptoTrader
//
//  Created by Валерий Никитин on 11.10.2023.
//

import Foundation


class AnalysisService {

    let coinService = CryptoService() // Сервис для работы с CoinGecko
    let gptService = GPTService()   // Сервис для работы с GPT-4
    
    func analyzeCoin(coinId: String, completion: @escaping (String?, Error?) -> Void) {
        coinService.fetchCoinDetailData(coinId: coinId, base: "BTC", target: "USD") { result in
            switch result {
            case .success(let coinDetailData):
                // Формируем вопрос или текст для анализа в GPT-4
                let question = self.formulateQuestion(for: coinDetailData)
                self.gptService.askGPT4(question: question) { (response, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    completion(response, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func formulateQuestion(for coinDetail: CoinDetailData) -> String {
        return "Технический анализ для \(coinDetail.name): текущая цена \(coinDetail.market_data.current_price.usd) USD, изменение за 24 часа \(coinDetail.market_data.price_change_percentage_24h)%. Какие перспективы?"
    }
}

