//
//  CoinDetailDataService.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 15/04/23.
//

import Foundation

import Combine


class CoinDetailDataService {
    
    @Published  var coinDetail: CoinDetailModel? = nil

    var coinDetailSubscription: AnyCancellable?
    private var  coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoins()
    }
    
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetals in
                self?.coinDetail = returnedCoinDetals
            
                self?.coinDetailSubscription?.cancel()
            })
        
        
    }
}
