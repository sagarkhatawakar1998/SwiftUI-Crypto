//
//  StatisticModel.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 09/04/23.
//

import Foundation


struct StatisticModel: Identifiable {
    let id =  UUID().uuidString
    let title: String
    let value: String
    let precentageChange: Double?
    
    init(title: String, value: String, precentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.precentageChange = precentageChange
    }
}


let newModel1 = StatisticModel(title: "", value: "", precentageChange: nil)
let newModel2 = StatisticModel(title: "", value: "", precentageChange: nil)

