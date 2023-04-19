//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 06/04/23.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    @Published var  statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption:   SortOption = .holding
    
    private var canxellables = Set<AnyCancellable> ()
    
    private let portfolioDataService = PortfolioDataService()
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    
    
    enum SortOption {
        case rank, rankReversed, holding, holdingReversed, price, priceeversed
    }
    
    
    init() {
        addSubscribers()
    }
    
    
    func downloadData() {
        
    }
    
    func addSubscribers() {
      
       // updates all Coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: 0.5 , scheduler:  DispatchQueue.main   )
            .map(filterAndSortCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &canxellables)
        
        
        //update portfolio
        
        $allCoins
            .combineLatest(portfolioDataService.$saveEntites)
            .map(mapAllcoinsToportfoliocoins)
            .sink { [weak self] returnedCoin in
                self?.portfolioCoins = self?.sortPortfolioIfneeded(coins: returnedCoin) ?? []
                
            }
            .store(in: &canxellables)
        
        
        //updates market
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalmarketData)
            .sink { [weak self ] models in
                self?.statistics =  models
                self?.isLoading = false
            }
            .store(in: &canxellables)
        
        
       
        
        
    }
    
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOpttion: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOpttion, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holding:
             coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingReversed:
             coins.sort{ $0.rank > $1.rank }
            
        case .price:
             coins.sort{ $0.currentPrice > $1.currentPrice }
        case .priceeversed:
             coins.sort{ $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioIfneeded(coins: [CoinModel])  -> [CoinModel] {
        switch sortOption {
        case .holding:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default :
            return coins
        }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return  coins }
        let lowercase = text.lowercased()
        return coins.filter { coin -> Bool in
            return  coin.name.lowercased().contains(lowercase) ||
                    coin.symbol.lowercased().contains(lowercase) ||
                    coin.id.lowercased().contains(lowercase)
        }
    }
     
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    private func mapGlobalmarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let datt = data else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market cap", value: datt.marketCap, precentageChange: datt.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "volume ", value: datt.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance ", value: datt.volume)
        let portfolioValue = portfolioCoins
                                .map { $0.currentHoldingsValue}
                                .reduce(0, +)
        let previousVlaue = portfolioCoins
            .map { coin -> Double  in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = (coin.priceChangePercentage24H ?? 0  ) / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
                
                //25%
            }
            .reduce(0, +)
        
        
        let percentageChange = ((portfolioValue - previousVlaue) / previousVlaue) * 100

        let portfolio = StatisticModel(title: "Portfolio value ", value: portfolioValue.asCurrencyWith2Decimals(), precentageChange: percentageChange )
        

        stats.append(volume)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    private func mapAllcoinsToportfoliocoins(coinmodel: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        return coinmodel
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else { return nil }
                
                return coin.updateHoldings(amount: entity.amount)
            }

    }
     
    
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(notificationType: .success)
    }
}
