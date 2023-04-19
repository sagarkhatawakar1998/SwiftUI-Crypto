//
//  CoinImageViewModel.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 08/04/23.
//

import Foundation
import SwiftUI
import Combine



class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    private var cancellabled = Set<AnyCancellable>()
    private let coin: CoinModel
    private let dataService : CoinImageService
    
    init(coin: CoinModel)  {
        self.coin = coin
        dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink {[weak self]  _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellabled)

    }
}
