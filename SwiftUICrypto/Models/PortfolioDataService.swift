//
//  PortfolioDataService.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 12/04/23.
//

import Foundation
import CoreData


class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containername = "PortfolioContainer"
    private let enetityname = "PortfolioEntity"
    @Published var saveEntites: [PortfolioEntity] = []

    
    
    init() {
        self.container = NSPersistentContainer(name: containername)
        container.loadPersistentStores { _, err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
        
        self.getPortfolio()
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        // check if coin is already in portfolio
        if let entity = saveEntites.first(where: { $0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            }
            else {
                delete(entity: entity)
            }
        }
        else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    
    // MARK: private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: enetityname)
        do {
            saveEntites =  try container.viewContext.fetch(request)
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity  = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
        
    }
    
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    
    private func save() {
        do {
            try container.viewContext.save()
        }
        catch let errr {
            print("error saving to core data \(errr.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
