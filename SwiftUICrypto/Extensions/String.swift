//
//  String.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 15/04/23.
//

import Foundation


extension String {
    
    var removingHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range:  nil)
    }
}
