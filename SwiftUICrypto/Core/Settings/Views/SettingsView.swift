//
//  SettingsView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 15/04/23.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURl = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/@SwiftfulThinking")!
    let coffeeURL = URL(string: "https://www.youtube.com/@SwiftfulThinking")!
    let coinGeko = URL(string: "https://www.coingecko.com/en/api")!
    let personalURl = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    
    
    var body: some View {
        NavigationView {
            List {
                swiftfulthinkng
                coinGeckoSection
                
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


extension SettingsView {
    private var swiftfulthinkng: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app made for practie")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Subscrine", destination:  defaultURl)
            Link("😍", destination:  coffeeURL)
            
        } header: {
            Text("Swiftful Thinkin")
            
            
        }
    }
    
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Crypto data is Used in the app from a free api")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Visit coin", destination:  coinGeko)
            Link("😍", destination:  coffeeURL)
            
        } header: {
            Text(" coinGecko")
            
            
        }
    }
    
    
    private var devloperSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Crypto data is Used in the app from a free api")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
            Link("Visit coin", destination:  coinGeko)
            Link("😍", destination:  coffeeURL)
            
        } header: {
            Text(" coinGecko")
            
            
        }
    }
}
