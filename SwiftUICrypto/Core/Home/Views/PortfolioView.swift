//
//  PortfolioView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 12/04/23.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selected: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if (selected != nil) {
                        portfolioInputSection
                    }
                  
                }
                .navigationTitle("Edit portfolio")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                                XmarkButton()
                            }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        trailingNavBarbutton
                    }
                })
                
                .onChange(of: vm.searchText) { newValue in
                    if  newValue == "" {
                        removeSelectedCoin()
                    }
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}



extension PortfolioView {
    private var coinLogoList : some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                   CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                               updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selected?.id == coin.id
                                    ? Color.theme.green : Color.clear, lineWidth: 1)
                        
                        )
                    
                }
            }
            .frame(height: 150)
            .padding(4)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selected = coin
        if  let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),  let amount = portfolioCoin.currentHoldings  {
                quantityText = "\(amount)"
        }
        else {
            quantityText = ""
        }
        
    }
    
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selected?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selected?.symbol ?? ""): ")
                Spacer()
                Text(selected?.currentPrice.asNumberString() ?? "")
            }
            Divider()
            HStack {
                Text("Amount in portfoli")
                Spacer()
                TextField("Ex. 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals()     )
            }
            
        }
    }
    
    private var trailingNavBarbutton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("saved")
                    .font(.headline)
            }
            .opacity((selected != nil && selected?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)

        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selected, let amount = Double(quantityText) else {return}
        
        // save portfoli
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        // hide
        UIApplication.shared.endEditing()
        
        //hide checkmarrk
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                 showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selected = nil
        vm.searchText = ""
    }
}
