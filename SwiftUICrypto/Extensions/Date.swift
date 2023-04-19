//
//  Date.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 15/04/23.
//

import Foundation


extension Date {
    
    
    //"2013-07-06T00:00:00.000Z"
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:sssZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShorDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
