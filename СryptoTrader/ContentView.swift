//
//  ContentView.swift
//  СryptoTrader
//
//  Created by Валерий Никитин on 09.10.2023.
//

import Foundation
import SwiftUI

class CryptoViewModel: ObservableObject  {
    @Published var searchText: String = ""
    @Published var cryptos: [CryptoData] = []
    
    private let cryptoService: CryptoService
    
    init(cryptoService: CryptoService = CryptoService()) {
        self.cryptoService = cryptoService
        fetchCryptoData()
    }
    
    func fetchCryptoData() {
        cryptoService.fetchCryptoData { result in
            switch result {
            case .success(let fetchedCryptos):
                DispatchQueue.main.async {
                    self.cryptos = fetchedCryptos
                }
            case .failure(let error):
                print("Failed to fetch crypto data: \(error)")
            }
        }
    }
    func fetchCoinDetail(coinId: String) {
        cryptoService.fetchCoinDetailData(coinId: coinId, base: "BTC", target: "USD") { result in
                switch result {
                case .success(let coinDetailData):
                    print(coinDetailData)  // Тут вы выводите детальные данные о монете в консоль
                case .failure(let error):
                    print("Failed to fetch coin detail data: \(error)")
                }
            }
        }
}


struct CryptoDetailNewView: View {
    var crypto: CryptoData
    @ObservedObject var viewModel: CryptoViewModel

    var cryptoProperties: [(String, (CryptoData) -> String)] {
        return [
            ("Name:", { $0.name }),
            ("Symbol:", { $0.symbol }),
            ("Price:", { String(format: "$%.2f", $0.current_price) }),
            ("Market Cap:", { "\($0.market_cap)" }),
            ("Market Cap Rank:", { "\($0.market_cap_rank)" }),
            ("Fully Diluted Valuation:", { $0.fully_diluted_valuation.map { "\($0)" } ?? "N/A" }),
            ("Total Volume:", { "\($0.total_volume)" }),
            ("24h High:", { "\($0.high_24h)" }),
            ("24h Low:", { "\($0.low_24h)" }),
            ("Price Change 24h:", { "\($0.price_change_24h)" }),
            ("Price Change Percentage 24h:", { "\($0.price_change_percentage_24h)%" }),
            ("Market Cap Change 24h:", { "\($0.market_cap_change_24h)" }),
            ("Market Cap Change Percentage 24h:", { "\($0.market_cap_change_percentage_24h)%" }),
            ("Circulating Supply:", { "\($0.circulating_supply)" }),
            ("Total Supply:", { $0.total_supply.map { "\($0)" } ?? "N/A" }),
            ("Max Supply:", { $0.max_supply.map { "\($0)" } ?? "N/A" }),
            ("All-Time High:", { "\($0.ath)" }),
            ("ATH Change Percentage:", { "\($0.ath_change_percentage)%" }),
            ("ATH Date:", { $0.ath_date }),
            ("All-Time Low:", { "\($0.atl)" }),
            ("ATL Change Percentage:", { "\($0.atl_change_percentage)%" }),
            ("ATL Date:", { $0.atl_date }),
            ("Last Updated:", { $0.last_updated }),
            ("ROI Times:", { $0.roi?.times.map { "\($0)" } ?? "N/A" }),
            ("ROI Currency:", { $0.roi?.currency ?? "N/A" }),
            ("ROI Percentage:", { $0.roi?.percentage.map { "\($0)%" } ?? "N/A" }),
            ("Price Change Percentage 14d:", { $0.price_change_percentage_14d_in_currency.map { "\($0)%" } ?? "N/A" }),
            ("Price Change Percentage 1h:", { $0.price_change_percentage_1h_in_currency.map { "\($0)%" } ?? "N/A" }),
            ("Price Change Percentage 200d:", { $0.price_change_percentage_200d_in_currency.map { "\($0)%" } ?? "N/A" }),
            ("Price Change Percentage 24h:", { "\($0.price_change_percentage_24h_in_currency)%" }),
            ("Price Change Percentage 30d:", { $0.price_change_percentage_30d_in_currency.map { "\($0)%" } ?? "N/A" }),
            ("Price Change Percentage 7d:", { $0.price_change_percentage_7d_in_currency.map { "\($0)%" } ?? "N/A" })
        ]
    }

    var body: some View {
            VStack {
                List {
                    ForEach(cryptoProperties, id: \.0) { property in
                        HStack {
                            Text(property.0).bold()
                            Spacer()
                            Text(property.1(crypto))
                        }
                    }
                }
                .padding()

                Button(action: {
                    viewModel.fetchCoinDetail(coinId: crypto.id)
                }) {
                    Text("Fetch Coin Details")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationBarTitle(crypto.name, displayMode: .inline)
        }
    }


struct ContentView: View {
    @State private var isShowingDetail = false
    @State private var selectedCrypto: CryptoData?
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel = CryptoViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by name", text: Binding<String>(
                    get: { self.viewModel.searchText },
                    set: { self.viewModel.searchText = $0 }
                ))
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

                List(viewModel.cryptos.filter {
                                    viewModel.searchText.isEmpty ? true : $0.name.lowercased().contains(viewModel.searchText.lowercased())
                                }) { crypto in
                                    NavigationLink(destination: CryptoDetailNewView(crypto: crypto, viewModel: viewModel)) { // <-- Change made here
                                        Text(crypto.name)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", crypto.current_price))")
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                            .navigationBarTitle("CryptoTrader", displayMode: .inline)
                        }
                    }
                }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
