//
//  CircleButtonAnimationView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 06/04/23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding  var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1) : .none ,  value: 0)
            
        
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
