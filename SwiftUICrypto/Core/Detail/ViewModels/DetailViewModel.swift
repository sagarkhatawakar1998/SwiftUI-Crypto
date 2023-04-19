//
//  DetailViewModel.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 15/04/23.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    @Published var coin: CoinModel
    @Published var overViewStatisics: [StatisticModel] = []
    @Published var additonalStatisics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
 
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToSatistics)
            .sink {[weak self ] returnedarrys in
                print("recievd coin Deetail")
                print(returnedarrys.overView)
                self?.overViewStatisics = returnedarrys.overView
                self?.additonalStatisics = returnedarrys.additonla

            }
            .store(in: &cancellables)
        
        
        coinDetailService.$coinDetail
            .sink {[weak self] returnedCoindetails in
                self?.coinDescription = returnedCoindetails?.redableDescription
                self?.websiteURL = returnedCoindetails?.links?.homepage?.first
                self?.redditURL =  returnedCoindetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    
    private func mapDataToSatistics(coinDetail: CoinDetailModel?, coinModel: CoinModel) -> (overView: [StatisticModel], additonla: [StatisticModel]) {
       
        
        var overViewArray: [StatisticModel] = createOverViewArray(coinModel: coinModel)
        
        let additonla: [StatisticModel] = createAdditonalArray(coinDetail: coinDetail, coinModel: coinModel)
        return (overViewArray, additonla)
        
    }
    
    
    func createOverViewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "currrent price", value: price, precentageChange: pricePercentChange)
        let marketcap = "%" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPerentag = coinModel.marketCapChangePercentage24H
        let marketStat = StatisticModel(title: "Market Cap", value: marketcap, precentageChange: marketCapPerentag)
        
        
        let rank = "\(coinModel.rank)"
        let rankStat =  StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "volume", value: volume)
        
        var overViewArray: [StatisticModel] = [
            priceStat,
            marketStat,
            rankStat,
            volumeStat
        ]
        
        return overViewArray
    }
    
    func createAdditonalArray(coinDetail: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? ""
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith2Decimals() ?? ""
        let lowStat = StatisticModel(title: "24h low", value: low)
        
        let priceChaneg = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercntChaneg2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "Price change", value: priceChaneg, precentageChange: pricePercntChaneg2)
        
        let marketCapChange =  "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChange2 = coinModel.marketCapChangePercentage24H
        let marketCpaChangestat = StatisticModel(title: "24H market cap change", value: marketCapChange, precentageChange: marketCapChange2)
        
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/1" : "\(blockTime)"
        
        let blockStat = StatisticModel(title: "Block time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "N/a"
        let hashingStat =  StatisticModel(title: "hashing Algo", value: hashing)

        let additonla = [
            highStat,
            lowStat,
            priceChangeStat,
            marketCpaChangestat,
            blockStat,
            hashingStat
        ]
        
        return additonla
    }
}
