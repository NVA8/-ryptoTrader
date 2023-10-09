//
//  CryptoService.swift
//  СryptoTrader
//
//  Created by Валерий Никитин on 10.10.2023.
//

import Foundation


class CryptoService {
    private func convertToReadableDate(from timestamp: Double) -> String {
        // Конвертировать миллисекунды в секунды
        let date = Date(timeIntervalSince1970: timestamp / 1000.0)

        // Создать DateFormatter для преобразования даты в строку
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU") // для русского формата даты

        return dateFormatter.string(from: date)
    }
    func convertHistoricalDataToReadableFormat(historicalData: HistoricalData) -> [(date: String, price: Double)] {
        return historicalData.prices.map { priceData in
            let timestamp = priceData[0]
            let price = priceData[1]
            return (date: convertToReadableDate(from: timestamp), price: price)
        }
    }

    private func fetchData<T: Decodable>(from urlString: String, decodeTo type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                print("Decoded Data: \(decodedData)")
                completion(.success(decodedData))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCryptoData(completion: @escaping (Result<[CryptoData], Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en"
        fetchData(from: urlString, decodeTo: [CryptoData].self, completion: completion)
    }
    
    func fetchHistoricalData(for coinId: String, days: Int, completion: @escaping (Result<HistoricalData, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId)/market_chart?vs_currency=usd&days=\(days)"
        fetchData(from: urlString, decodeTo: HistoricalData.self, completion: completion)
    }

    func fetchTrendingCoins(completion: @escaping (Result<TrendingResponse, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/search/trending"
        fetchData(from: urlString, decodeTo: TrendingResponse.self, completion: completion)
    }
    func fetchCoinDetailData(coinId: String, marketIdentifier: String = "binance", base: String, target: String, completion: @escaping (Result<CoinDetailData, Error>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId)?localization=false&tickers=true&market_data=true&community_data=true&developer_data=true&sparkline=true"
        fetchData(from: urlString, decodeTo: CoinDetailData.self) { result in
            switch result {
            case .success(let coinDetailData):

                completion(.success(coinDetailData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

