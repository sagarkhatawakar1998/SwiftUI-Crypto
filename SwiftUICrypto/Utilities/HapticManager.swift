//
//  HapticManager.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 12/04/23.
//

import Foundation
import SwiftUI

class  HapticManager {
    static let genarator = UINotificationFeedbackGenerator()
    
    
    static func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        genarator.notificationOccurred(notificationType)
    }
}
