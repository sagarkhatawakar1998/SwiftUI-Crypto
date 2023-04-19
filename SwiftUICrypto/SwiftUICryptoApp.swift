//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 06/04/23.
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]

    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
