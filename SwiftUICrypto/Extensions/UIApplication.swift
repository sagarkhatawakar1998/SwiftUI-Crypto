//
//  UIApplication.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 09/04/23.
//

import Foundation
import SwiftUI



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
