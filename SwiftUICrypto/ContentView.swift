//
//  ContentView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 06/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                Text("Acent")
                    .foregroundColor(Color.theme.accent)
                Text("Secondary")
                    .foregroundColor(Color.theme.secondaryText)
                Text("Red")
                    .foregroundColor(Color.theme.red)
                Text("green")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
