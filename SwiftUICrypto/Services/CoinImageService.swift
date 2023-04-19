//
//  CoinImageService.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 08/04/23.
//

import Foundation
import SwiftUI

import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private    var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManger = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    
    func getCoinImage() {
        if let savedimage = fileManger.getImage(imageName: imageName, folderName: folderName) {
            image = savedimage
            print("retrived image from file manger")
        }
        else {
            downloadCoinImage()
        }
    }
    
    func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self]
                returnedimage in
                guard let self = self, let downloadedImage = returnedimage else {return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManger.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
