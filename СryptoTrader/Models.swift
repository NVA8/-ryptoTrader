//
//  Models.swift
//  СryptoTrader
//
//  Created by Валерий Никитин on 10.10.2023.
//

import Foundation

struct HistoricalData: Codable {
    // Предполагаемые поля для HistoricalData
    let prices: [[Double]]
    // ... добавьте другие поля по мере необходимости
}

struct TrendingResponse: Decodable {
    let coins: [TrendingCoin]
}

struct TrendingCoin: Decodable {
    let item: CoinDetail
}

struct CoinDetail: Decodable {
    let id: String
    let coin_id: Int
    let name: String
    let symbol: String
    let market_cap_rank: Int
    let thumb: String
    let small: String
    let large: String
    let slug: String
    let price_btc: Double
    let score: Int
}


struct CoinInfo: Codable {
    let item: CryptoData
    // ... добавьте другие поля по мере необходимости
}

struct AssetPlatform: Codable {
    let id: String
    let name: String
    // ... добавьте другие поля по мере необходимости
}

struct ExchangeRates: Codable {
    let rates: [String: RateInfo]
}

struct RateInfo: Codable {
    let name: String
    let unit: String
    let value: Double
    // ... добавьте другие поля по мере необходимости
}

struct CoinSearchResult: Decodable {
    struct Coin: Decodable {
        let id: String
        let name: String
        let api_symbol: String
        let symbol: String
        let market_cap_rank: Int
        let thumb: String
        let large: String
    }
    
    let coins: [Coin]
}




struct GlobalData: Codable {
    let data: GlobalInfo
    
    struct GlobalInfo: Codable {
        let active_cryptocurrencies: Int
        let upcoming_icos: Int
        let ongoing_icos: Int
        let ended_icos: Int
        let markets: Int
        let total_market_cap: [String: Double]
        let total_volume: [String: Double]
        let market_cap_percentage: [String: Double]
        let market_cap_change_percentage_24h_usd: Double
        let updated_at: Int
    }
}


struct CryptoData: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double
    let market_cap_rank: Int
    let fully_diluted_valuation: Double?
    let total_volume: Double
    let high_24h: Double
    let low_24h: Double
    let price_change_24h: Double
    let price_change_percentage_24h: Double
    let market_cap_change_24h: Double
    let market_cap_change_percentage_24h: Double
    let circulating_supply: Double
    let total_supply: Double?
    let max_supply: Double?
    let ath: Double
    let ath_change_percentage: Double
    let ath_date: String
    let atl: Double
    let atl_change_percentage: Double
    let atl_date: String
    let roi: ROI?
    let last_updated: String
    let price_change_percentage_14d_in_currency: Double?
    let price_change_percentage_1h_in_currency: Double?
    let price_change_percentage_200d_in_currency: Double?
    let price_change_percentage_24h_in_currency: Double?
    let price_change_percentage_30d_in_currency: Double?
    let price_change_percentage_7d_in_currency: Double?
}
struct ROI: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
    // Добавьте другие поля по мере необходимости
}

struct CoinDetailData: Decodable {
    var id: String
    var symbol: String
    var name: String
    var description: [String: String] // Для поддержки описания на разных языках
    var image: ImageURLs
    var genesis_date: String
    var market_data: MarketData
}


struct MarketData: Decodable {
    var current_price: USDPrice
    var ath: ATH
    var ath_change_percentage: ATHChangePercentage
    var ath_date: ATHDate
    var atl: ATL
    var atl_change_percentage: ATLChangePercentage
    var market_cap: MarketCap
    var market_cap_rank: Int
    var fully_diluted_valuation: FullyDilutedValuation
    var market_cap_fdv_ratio: Double
    var total_volume: TotalVolume
    var high_24h: High24h
    var low_24h: Low24h
    var price_change_24h: Double
    var price_change_percentage_24h: Double
    var price_change_percentage_7d: Double
    var price_change_percentage_14d: Double
    var price_change_percentage_30d: Double
    var price_change_percentage_60d: Double
    var price_change_percentage_200d: Double
    var price_change_percentage_1y: Double
    var market_cap_change_24h: Double
    var market_cap_change_percentage_24h: Double
    var total_supply: Double?
    var max_supply: Double?
    var circulating_supply: Double?
    var sparkline_7d: Sparkline7d
    var reducedSparkline: [Double] {
        return sparkline_7d.price.enumerated().compactMap { index, price in
            return index % 4 == 0 ? price : nil
        }
    }
    var last_updated: String
    var community_data: CommunityData?
    var developer_data: DeveloperData?


}
struct CommunityData: Decodable {
    var facebook_likes: Int?
    var twitter_followers: Int
    var reddit_average_posts_48h: Int
    var reddit_average_comments_48h: Int
    var reddit_subscribers: Int
    var reddit_accounts_active_48h: Int
    var telegram_channel_user_count: Int?
}

struct DeveloperData: Decodable {
    var forks: Int
    var stars: Int
    var subscribers: Int
    var total_issues: Int
    var closed_issues: Int
    var pull_requests_merged: Int
    var pull_request_contributors: Int
    var code_additions_deletions_4_weeks: CodeAdditionsDeletions
}

struct Market: Decodable {
    var name: String
    var identifier: String
    var has_trading_incentive: Bool
}

struct ConvertedLast: Decodable {
    var btc: Double
    var eth: Double
    var usd: Double
}

struct ConvertedVolume: Decodable {
    var btc: Double
    var eth: Double
    var usd: Double
}
struct CodeAdditionsDeletions: Decodable {
    var additions: Int
    var deletions: Int
}
struct USDPrice: Decodable {
    var usd: Double
}
struct Sparkline7d: Decodable {
    var price: [Double]
}
struct ATH: Decodable {
    var usd: Double
}
struct ATHChangePercentage: Decodable {
    var usd: Double
}

struct ATHDate: Decodable {
    var usd: String
}

struct ATL: Decodable {
    var usd: Double
}

struct ATLChangePercentage: Decodable {
    var usd: Double
}

struct MarketCap: Decodable {
    var usd: Double
}

struct FullyDilutedValuation: Decodable {
    var usd: Double
}

struct TotalVolume: Decodable {
    var usd: Double
}

struct High24h: Decodable {
    var usd: Double
}

struct Low24h: Decodable {
    var usd: Double
}
struct ImageURLs: Decodable {
    var thumb: String
    var small: String
    var large: String
}


